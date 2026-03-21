# HMC_MODEL must be made to point to the directory containing the HMC simulation model.
HMC_MODEL ?= /absolute/dir/to/local/HMC_model/hmc_bfm_some_revision

EXAMPLE_SRCDIR := ../src


#example design source
EGD_FILES += $(EXAMPLE_SRCDIR)/i2c_32sub.v
EGD_FILES += $(EXAMPLE_SRCDIR)/i2c_control.sv
EGD_FILES += $(EXAMPLE_SRCDIR)/m20k_2port.v
EGD_FILES += $(EXAMPLE_SRCDIR)/request_generator.sv
EGD_FILES += $(EXAMPLE_SRCDIR)/response_monitor.sv
EGD_FILES += $(EXAMPLE_SRCDIR)/hmcc_example.sv
EGD_FILES += $(EXAMPLE_SRCDIR)/atx_pll_recal.sv

# HMC simulation model
HMC_FILES  +=+incdir+$(HMC_MODEL)/src
HMC_FILES  += $(HMC_MODEL)/src/pkg_cad.sv
HMC_FILES  += $(HMC_MODEL)/src/pkt.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_bfm_pkg.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_flit_bfm.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_bfm.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_pkt_driver.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_err_inj.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_retry.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_flow_ctrl.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_mem.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_flit_top.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_serdes.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_cov.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_cad2pkt.sv
HMC_FILES  += $(HMC_MODEL)/src/hmc_perf_monitor.sv
TB_FILES  := hmc_cfg.sv hmcc_tb.sv



VCS_OPTIONS  :=
VCS_OPTIONS  +=-timescale=1ns/1ps 
VCS_OPTIONS  +=+v2k 
VCS_OPTIONS  +=+systemverilogext+.sv 
VCS_OPTIONS  +=-no_error ZONMCM 
VCS_OPTIONS  +=-debug_all 
VCS_OPTIONS  +=+vcs+vcdpluson
VCS_OPTIONS  +=+vcs+dumpvars
VCS_OPTIONS  +=+memcbk
VCS_OPTIONS  +=-ova_debug
VCS_OPTIONS  +=-licqueue  
VCS_OPTIONS  +=-assert enable_hier
VCS_OPTIONS  +=-v2k_generate


QUESTASIM_OPTIONS  :=
QUESTASIM_OPTIONS  += +librescan
QUESTASIM_OPTIONS  += -mfcu
QUESTASIM_OPTIONS  += +nop_mean=0
QUESTASIM_OPTIONS  += -novopt

help:
	@echo
	@echo "              Altera Hybrid Memory Cube Controller Example Design Simulation"
	@echo "********************************************************************************************"
	@echo
	@echo "Note: Specify the location of the HMC BFM using HMC_MODEL=<PATH> when running simulations"
	@echo "      Optionally edit the HMC_MODEL default path at the top of this Makefile"
	@echo
	@echo "Make Targets"
	@echo "scripts   - Generates simulation scripts"
	@echo
	@echo "vcs       - Runs simulation in Synopsys VCS"
	@echo "vsim      - Runs simulation in MentorGraphics Questasim"
	@echo "ncsim     - Runs simulation in Cadence NCSim"
	@echo
	@echo "vcs_gui   - Opens simulation waveform in Synopsys VCS"
	@echo "vsim_gui  - Opens simulation waveform in MentorGraphics Questasim"
	@echo "ncsim_gui - Opens simulation waveform in Cadence NCSim"
	@echo "*********************************************************************************************"
	@echo

scripts:
	ip-make-simscript  --spd=../../ip/bidir_pin/bidir_pin.spd --spd=../../ip/altera_atx_pll_ip/altera_atx_pll_ip.spd --spd=../../ip/altera_hmcc_ip/altera_hmcc_ip.spd

ncsim:
	# NCSim is executed with ./cadence folder as the working directory.
	{ \
	cd cadence;\
	sh ncsim_setup.sh SKIP_ELAB=1 SKIP_SIM=1;\
	ncvlog  -compcnfg   ../$(EXAMPLE_SRCDIR)/i2c_32sub.v;\
	ncvlog  -sv     	../$(EXAMPLE_SRCDIR)/i2c_control.sv;\
	ncvlog  -compcnfg   ../$(EXAMPLE_SRCDIR)/m20k_2port.v;\
	ncvlog  -sv     	../$(EXAMPLE_SRCDIR)/request_generator.sv;\
	ncvlog  -sv     	../$(EXAMPLE_SRCDIR)/response_monitor.sv;\
	ncvlog  -sv     	../$(EXAMPLE_SRCDIR)/hmcc_example.sv;\
	ncvlog  -sv     	../$(EXAMPLE_SRCDIR)/atx_pll_recal.sv;\
	irun +compile -sysv_ext .sv -sv -access +rc $(HMC_FILES) ../hmc_cfg.sv;\
	ncvlog  -sv         ../hmcc_tb.sv;\
	ncelab  -nolog -timescale 1ps/1ps -access +rc hmcc_tb;\
	ncsim   -nolog hmcc_tb -input ../ncsim_wave_gen.tcl;\
	} | tee ncsim.log

vsim:
	{ \
	if [ ! -d "./libraries" ]; then vlib ./libraries; fi;\
	if [ ! -d "./libraries/work" ]; then vlib ./libraries/work; fi;\
	qverilog $(HMC_FILES) hmc_cfg.sv $(QUESTASIM_OPTIONS) -work ./libraries/work;\
	vsim -c -do mentor/msim_setup.tcl -do vsim.do;\
	mv vsim.wlf hmcc_wf.wlf;\
	} | tee vsim.log

vcs:
	{ \
	sh synopsys/vcs/vcs_setup.sh \
		TOP_LEVEL_NAME="hmcc_tb" \
		USER_DEFINED_ELAB_OPTIONS="\"$(VCS_OPTIONS) $(EGD_FILES) $(HMC_FILES) $(TB_FILES)"\" \
		USER_DEFINED_SIM_OPTIONS="\"+vpdfile+hmcc_wf.vpd"\";\
	} | tee vcs.log

ncsim_gui:
	simvision ./cadence/hmcc_wf.shm

vsim_gui:
	vsim -view ./hmcc_wf.wlf

vcs_gui:
	dve -vpd ./hmcc_wf.vpd

clean:
	# Clean Cadence files
	rm -rf cadence/INCA_libs cadence/libraries cadence/ncsim.key cadence/ncvlog.log cadence/irun.log cadence/ncelab.log cadence/ncsim.log cadence/hmcc_wf.shm ncsim.log

	# Clean Mentor files
	rm -rf libraries work modelsim.ini vish_stacktrace.vstf qverilog.log transcript hmcc_wf.wlf vsim.log

	# Clean Synopsys files
	rm -rf csrc simv.daidir simv.vdb simv ucli.key verilog.dump hmcc_wf.vpd vcs.log
