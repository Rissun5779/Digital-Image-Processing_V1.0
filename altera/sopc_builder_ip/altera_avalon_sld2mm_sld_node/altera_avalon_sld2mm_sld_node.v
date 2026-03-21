module altera_avalon_sld2mm_sld_node (
  output tck,
  output tdi,
  output virtual_state_sdr,
  output virtual_state_cdr,
  output jtag_state_rti,
  output virtual_state_uir,
  output virtual_state_udr,
  output ir_in,
  input  tdo,
  
  input clk,
  output reset_n
    );
    
parameter SLD_AUTO_INSTANCE_INDEX = "YES";
parameter SLD_INSTANCE_INDEX = 0;
parameter SLD_TYPE_ID = 17;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign tck = 1'b0;
  assign tdi = 1'b0;
  assign virtual_state_sdr = 1'b0;
  assign virtual_state_cdr = 1'b0;
  assign jtag_state_rti = 1'b0;
  assign virtual_state_uir = 1'b0;
  assign virtual_state_udr = 1'b0;
  assign ir_in = 2'b0;
 // dummy reset
 assign reset_n = 0;

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
// sld_virtual_jtag_basic vji_node_sld2mm
//   (
//     .ir_in (ir_in),
//     .ir_out (),
//     .jtag_state_rti (jtag_state_rti),
//     .tck (tck),
//     .tdi (tdi),
//     .tdo (tdo),
//     .virtual_state_cdr (virtual_state_cdr),
//     .virtual_state_sdr (virtual_state_sdr),
//     .virtual_state_udr (virtual_state_udr),
//     .virtual_state_uir (virtual_state_uir)
//   );
  
// defparam vji_node_sld2mm.sld_auto_instance_index = SLD_AUTO_INSTANCE_INDEX;
// defparam vji_node_sld2mm.sld_instance_index = SLD_INSTANCE_INDEX;
// defparam vji_node_sld2mm.sld_type_id = SLD_TYPE_ID; 
 
// defparam vji_node_sld2mm.sld_ir_width = 1;
// defparam vji_node_sld2mm.sld_mfg_id = 110;
// defparam vji_node_sld2mm.sld_sim_action = "";
// defparam vji_node_sld2mm.sld_sim_n_scan = 0;
// defparam vji_node_sld2mm.sld_sim_total_length = 0;
// defparam vji_node_sld2mm.sld_version = 3;
// assign reset_n = 1;
//synthesis read_comments_as_HDL off



endmodule