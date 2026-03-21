@echo off

if "%~1"=="help"     goto help
if "%~1"=="scripts"  goto gen_script
if "%~1"=="vsim"     goto simulate
if "%~1"=="vsim_gui" goto show_gui
if "%~1"=="clean"    goto clean

echo Argument 1 "%~1" is not valid.
echo Valid arguments are: help, scripts, vsim, vsim_gui, and clean.
goto end

:help
	@echo.
	@echo "              Altera Hybrid Memory Cube Controller Example Design Simulation"
	@echo "********************************************************************************************"
	@echo.
	@echo "Note: Specify the location of the HMC BFM using HMC_MODEL=<PATH> when running simulations"
	@echo.
	@echo "Make Targets"
	@echo "scripts   - Generates simulation scripts"
	@echo "vsim      - Runs simulation in MentorGraphics Questasim"
	@echo "vsim_gui  - Opens simulation waveform in MentorGraphics Questasim"
	@echo "clean     - Delete files generated from simulation"
	@echo "*********************************************************************************************"
	@echo.
	goto end

:gen_script
	@echo on
	ip-make-simscript --spd=..\..\ip\bidir_pin\bidir_pin.spd --spd=..\..\ip\altera_atx_pll_ip\altera_atx_pll_ip.spd --spd=..\..\ip\altera_hmcc_ip\altera_hmcc_ip.spd
	@echo off
	goto end



:simulate
	setlocal

	if "%~2"=="HMC_MODEL" (
		if "%~3"=="" (
			set HMC_MODEL="C:\absolute\dir\to\local\HMC_model\hmc_bfm_some_revision"
		) else (
			set HMC_MODEL="%~3%"
		)
	) else (
		set HMC_MODEL="C:\absolute\dir\to\local\HMC_model\hmc_bfm_some_revision"
	)

	for /f "useback tokens=*" %%a in ('%HMC_MODEL%') do set HMC_MODEL=%%~a

	set "HMC_FILES= +incdir+%HMC_MODEL%\src"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\pkg_cad.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\pkt.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_bfm_pkg.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_flit_bfm.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_bfm.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_pkt_driver.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_err_inj.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_retry.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_flow_ctrl.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_mem.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_flit_top.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_serdes.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_cov.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_cad2pkt.sv"
	set "HMC_FILES=%HMC_FILES% %HMC_MODEL%\src\hmc_perf_monitor.sv"

	echo Redirecting output to vsim.log...

	(
	if exist .\libraries (
		if not exist .\libraries\nul (
			echo Backing up file named "libraries" to "libraries_file".
			move .\libraries .\libraries_file
			vlib .\libraries
		)
	) else (
		vlib .\libraries
	)

	if exist .\libraries\work (
		if not exist .\libraries\work\nul (
			echo Backing up file named "work" in .\libraries to "work_file".
			move .\libraries\work .\libraries\work_file
			vlib .\libraries\work
		)
	) else (
		vlib .\libraries\work
	)

	@echo on
	qverilog %HMC_FILES% hmc_cfg.sv +librescan -mfcu +nop_mean=0 -novopt -work .\libraries\work
	vsim -c -do .\mentor.\msim_setup.tcl -do vsim.do
	@echo off

	move vsim.wlf hmcc_wf.wlf
	) > vsim.log 2>&1
	endlocal

	goto end



:show_gui
	@echo on
	vsim -view .\hmcc_wf.wlf
	@echo off
	goto end



:clean
	@echo on
	del modelsim.ini vish_stacktrace.vstf qverilog.log transcript hmcc_wf.wlf vsim.log
	rd /s /q libraries
	@echo off
	goto end



:end
	pause
