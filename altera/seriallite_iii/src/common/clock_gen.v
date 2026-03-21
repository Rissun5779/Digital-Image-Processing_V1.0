`timescale 1fs/1fs

module clock_gen #
(
   parameter                     DEVICE_FAMILY              = "Stratix V",
   parameter                     lanes                      = 4,
   parameter                     reference_clock_frequency  = "257.8125 MHz",
   parameter                     coreclkin_frequency     = "153.918 MHz",
   parameter                     user_clock_frequency       = "138.526 MHz"
)
(
  // Reconfig interface signals
   input                         reconfig_clk,
   input                         reconfig_clk_reset,
   input                         reconfig_busy,
   input                         reconfig_clk_core_reset,

   // User Interface Clock and Reset
   output                        user_clock,
   output                        user_clock_reset,

   // Transceiver signals
   input                         xcvr_pll_locked,
   input          [lanes-1:0]    clkout,
   output                        coreclkin,
   output                        coreclkin_reset
);


   wire                          fpll_locked;
   wire                          fpll_ready;
   reg                           fpll_reset, next_fpll_reset;


   //*********************************************************************
   //
   // Clock Generator Reset State Machine
   //
   //*********************************************************************

   localparam                 CG_RESET       = 2'd0;
   localparam                 CG_WAITING_1   = 2'd1;
   localparam                 CG_WAITING_2   = 2'd2;
   localparam                 CG_READY       = 2'd3;

   reg      [1:0]             reset_state, next_reset_state;
   reg                        presync_user_clock_reset /* synthesis altera_attribute="disable_da_rule=r105" */ ;
   reg                        next_presync_user_clock_reset;
   reg      [4:0]             filter_count, next_filter_count;

   /* synthesis translate_off */

   reg [0:255] reset_state_encode;     // This string is for simulation debug

   always @ (reset_state) begin

      case (reset_state)

         CG_RESET:      reset_state_encode   <= "RESET"; 
         CG_WAITING_1:  reset_state_encode   <= "WAITING_1";
         CG_WAITING_2:  reset_state_encode   <= "WAITING_2";
         CG_READY:      reset_state_encode   <= "READY";

     endcase

   end

   /* synthesis translate_on */


   //
   // User clock reset syncronizer
   //
   dp_sync #
   (
      .dp_width(1),
      .dp_reset(1'b1)
   )
   user_clock_reset_sync
   (
      .async_reset_n(~presync_user_clock_reset),
      .sync_reset_n(1'b1),
      .clk(user_clock),
      .sync_ctrl(2'd2),
      .d(1'b0),
      .o(user_clock_reset)
   );


   //
   // Coreclkin reset syncronizer
   //
   dp_sync #
   (
      .dp_width(1),
      .dp_reset(1'b1)
   )
   coreclkin_reset_sync
   (
      .async_reset_n(~user_clock_reset),
      .sync_reset_n(1'b1),
      .clk(coreclkin),
      .sync_ctrl(2'd2),
      .d(1'b0),
      .o(coreclkin_reset)
   );

   altera_std_synchronizer #(
      .depth (2)
   ) fpll_locked_sync ( 
      .clk(reconfig_clk),
      .din(fpll_locked),
      .dout(fpll_ready),
      .reset_n(~reconfig_clk_reset)
   );
 
   //
   // Clock Generator Reset State Machine Storage
   //
   always @(posedge reconfig_clk) begin

      if ((reconfig_clk_reset == 1'b1)) begin

         reset_state                <= CG_RESET;
         fpll_reset                 <= 1'b1;
         presync_user_clock_reset   <= 1'b1;
         filter_count               <= 5'd0;

      end else if ((reconfig_clk_core_reset == 1'b1) && (reset_state==CG_READY)) begin

         reset_state                <= CG_WAITING_2;
         fpll_reset                 <= 1'b0;
         presync_user_clock_reset   <= 1'b1;
         filter_count               <= 5'd0;

      end else begin

         reset_state                <= next_reset_state;
         fpll_reset                 <= next_fpll_reset;
         presync_user_clock_reset   <= next_presync_user_clock_reset;
         filter_count               <= next_filter_count;

      end

   end

   //
   // Clock Generator Reset State Machine Decoder
   //
   always @* begin
 
      case (reset_state)

         CG_RESET: begin

            next_reset_state              = CG_WAITING_1;
            next_presync_user_clock_reset = 1'b1;
            next_fpll_reset               = 1'b1;
            next_filter_count             = 5'd0;

         end


         // Wait for the transceiver PLL to lock, and for reconfiguration to
         // complete. These must be completed for 16 clock cycles to filter
         // out gliches.
         CG_WAITING_1: begin

            next_reset_state              = (filter_count == 5'd31) ? CG_WAITING_2 : CG_WAITING_1;
            next_presync_user_clock_reset = 1'b1;
            next_fpll_reset               = 1'b1;
            next_filter_count             = ((xcvr_pll_locked == 1'b1) && (reconfig_busy == 1'b0)) ? filter_count + 5'd1 : 5'd0;

         end


         // Wait for the fPLL to lock.
         CG_WAITING_2: begin

            next_reset_state              = (filter_count == 5'd31 && !reconfig_clk_core_reset) ? CG_READY : CG_WAITING_2;
            next_presync_user_clock_reset = 1'b1;
            next_fpll_reset               = 1'b0;
            next_filter_count             = (fpll_ready  == 1'b1)  ? filter_count + 5'd1 : 5'd0;

         end


         // Normal operation. Stay in this state until either of
         // the PLLs lose lock or the core is reset.
         CG_READY: begin

            next_reset_state              = (xcvr_pll_locked == 1'b0) ? CG_WAITING_1 :
                                            (fpll_ready     == 1'b0) ? CG_WAITING_2 : CG_READY;
            next_presync_user_clock_reset = 1'b0;
            next_fpll_reset               = 1'b0;
            next_filter_count             = 5'd0;

         end


         default: begin

            next_reset_state              = CG_RESET;
            next_presync_user_clock_reset = 1'b1;
            next_fpll_reset               = 1'b1;
            next_filter_count             = 5'd0;

         end

      endcase

   end

generate 
if ((DEVICE_FAMILY == "Stratix V") | (DEVICE_FAMILY == "Arria V GZ") ) begin : SV_FPLL

   altera_pll #
   (
      .fractional_vco_multiplier("true"),
      .reference_clock_frequency(reference_clock_frequency),
      .operation_mode("direct"),
      .number_of_clocks(2),
      .output_clock_frequency0(coreclkin_frequency),
      .phase_shift0("0 ps"),
      .duty_cycle0(50),
      .output_clock_frequency1(user_clock_frequency),
      .phase_shift1("0 ps"),
      .duty_cycle1(50),
      .output_clock_frequency2("0 MHz"),
      .phase_shift2("0 ps"),
      .duty_cycle2(50),
      .output_clock_frequency3("0 MHz"),
      .phase_shift3("0 ps"),
      .duty_cycle3(50),
      .output_clock_frequency4("0 MHz"),
      .phase_shift4("0 ps"),
      .duty_cycle4(50),
      .output_clock_frequency5("0 MHz"),
      .phase_shift5("0 ps"),
      .duty_cycle5(50),
      .output_clock_frequency6("0 MHz"),
      .phase_shift6("0 ps"),
      .duty_cycle6(50),
      .output_clock_frequency7("0 MHz"),
      .phase_shift7("0 ps"),
      .duty_cycle7(50),
      .output_clock_frequency8("0 MHz"),
      .phase_shift8("0 ps"),
      .duty_cycle8(50),
      .output_clock_frequency9("0 MHz"),
      .phase_shift9("0 ps"),
      .duty_cycle9(50),
      .output_clock_frequency10("0 MHz"),
      .phase_shift10("0 ps"),
      .duty_cycle10(50),
      .output_clock_frequency11("0 MHz"),
      .phase_shift11("0 ps"),
      .duty_cycle11(50),
      .output_clock_frequency12("0 MHz"),
      .phase_shift12("0 ps"),
      .duty_cycle12(50),
      .output_clock_frequency13("0 MHz"),
      .phase_shift13("0 ps"),
      .duty_cycle13(50),
      .output_clock_frequency14("0 MHz"),
      .phase_shift14("0 ps"),
      .duty_cycle14(50),
      .output_clock_frequency15("0 MHz"),
      .phase_shift15("0 ps"),
      .duty_cycle15(50),
      .output_clock_frequency16("0 MHz"),
      .phase_shift16("0 ps"),
      .duty_cycle16(50),
      .output_clock_frequency17("0 MHz"),
      .phase_shift17("0 ps"),
      .duty_cycle17(50),
      .pll_type("General"),
      .pll_subtype("General")
   )
   altera_pll_i
   (
      .outclk({user_clock, coreclkin}),
      .locked(fpll_locked),
      .fboutclk( ),
      .fbclk(1'b0),
      .rst(fpll_reset),
      .refclk(clkout[0])
   );
 
  end // Stratix V fsdf.vhd
  else begin : A10_IOPLL
  
	altera_iopll_inst  user_clock_inst (
		.rst	(fpll_reset),
		.locked	(fpll_locked),
		.refclk	(clkout[0]),
		.outclk_0	({user_clock})
	);

  //A10 only support 64b which will have coreclkin coming from clockout[0] directly
  //40b will require another intermediate clock which is not generated in A10
  assign coreclkin = clkout[0];
  
   end // else
 endgenerate   

endmodule
