# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#--------------------------------------------------------------#
#
# a10-pcie-devkit-prj:  Create quartus project from a QIP/Qsys file
#
#
#  Arg 0 : $project_name : Qsys or QPF file $project_name                                                                                       "
#        : optional   : No"
#        : default    : None"
#
#  Arg 1 : $GenerateQPFQ : Generate QII project
#        : optional   : yes
#        : default    : 1"
#
#  Arg 2 : $GenerateSynth : Generate DUT RTL Files
#        : optional   : yes
#        : default    : 0  --> No Synth, 1 --> Verilog, 2 --> VHDL"
#
#  Arg 3 : $GenerateSimTb : Generate TB Sim
#        : optional   : yes
#        : default    : 0"
#
#  Arg 4 : $DeviceQSF : A10 device
#        : optional   : yes
#        : default    : 10AX115S1F45I1SG"
#
load_package report
load_package flow


global env
set IP_ROOTDIR $env(QUARTUS_ROOTDIR)
set IP_ROOTDIR "${IP_ROOTDIR}/../ip"
set QSYS_ROOTDIR $env(QUARTUS_ROOTDIR)
set QSYS_ROOTDIR "${QSYS_ROOTDIR}/sopc_builder/bin/"

set  QuartusPRO 0

parray ::tcl_platform
set OP_system $::tcl_platform(os)
set PlatformWin [expr ("${OP_system}"=="Linux")?0:1]

#--------------------------------------------------------------#
#
# Input Argument
#
# name of the QSYS file
set project_name  [lindex $quartus(args) 0]
if { [ regexp .qsys $project_name ] } {
   regsub -all {.qsys} $project_name {} project_name
}



#--------------------------------------------------------------#
#
# GenerateQPF
#
set GenerateQPF  [lindex $quartus(args) 1]
if { [ string eq "" $GenerateQPF] } {
   set GenerateQPF 1
}

#--------------------------------------------------------------#
#
# GenerateSynth
#
set GenerateSynth  [lindex $quartus(args) 2]
set qsys_gen_synth "--synthesis=VERILOG"
set qsys_gen_sim "--simulation=VERILOG"
if { [ string eq "" $GenerateSynth] } {
   set GenerateSynth 0
} else {
   if { $GenerateSynth > 1 } {
      set qsys_gen_synth "--synthesis=VHDL"
   }
}

#--------------------------------------------------------------#
#
# GenerateSimTb
#
set GenerateSimTb  [lindex $quartus(args) 3]
if { [ string eq "" $GenerateSimTb] } {
   set GenerateSimTb 0
}


#--------------------------------------------------------------#
#
# DeviceQSF
#
set DeviceQSF  [lindex $quartus(args) 4]
if { [ string eq "" $DeviceQSF] } {
   set DeviceQSF "10AX115S1F45I1SG"
}

set a10_devkit_tcl "${project_name}_a10_revd_devkit_qsf.tcl"
set a10_devkit_sdc "${project_name}_a10_revd_devkit_sdc.sdc"

set deviceFamily_qsf "Arria 10"
set deviceFamily_short "a10"

set PassSynthGeneration 1
set PassSimGeneration   1

puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
puts "--------- ::"
puts "--------- :: Running : a10-pcie-devkit-prj.tcl"
puts "--------- ::"
puts "--------- ::   Project name                        : $project_name        "
puts "--------- ::   Generate Quartus Project            : $GenerateQPF         "
puts "--------- ::   Generate QSYS synthesis fileset     : $GenerateSynth       "
puts "--------- ::   Generate simulation testbench       : $GenerateSimTb       "
puts "--------- ::   Device                              : $DeviceQSF           "
puts "--------- ::   Quartus Pro                         : $QuartusPRO          "
puts "--------- ::   Platform Windows                    : $PlatformWin         "
puts "--------- ::"
# Main program
#
# ip-generate and create a new project
set qsys_filename "${project_name}.qsys"
set TBQSYS "${project_name}_tb/${project_name}_tb.qsys"
set QIPFILE "${project_name}/${project_name}.qip"
set failgen "${project_name}_fail.txt"

# Cleanup previous dir
file delete -force -- ${project_name}
if { [ file exist $failgen ] == 1 } {
   file delete -force -- ${failgen}
}

puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
if { $GenerateSimTb > 0 } {
   puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
   puts "--------- ::"
   puts "--------- :: qsys-generate ${project_name}.qsys ${qsys_gen_sim} --testbench=STANDARD --testbench-simulation=VERILOG"
   puts "--------- ::"
   puts "--------- ::"
   if { [ catch {exec  ${QSYS_ROOTDIR}qsys-generate ${project_name}.qsys ${qsys_gen_sim} --testbench=STANDARD --testbench-simulation=VERILOG} msg ] } {
      puts "--------- :: $msg"
   }
   if { [ file exist $TBQSYS ] == 1 } {
      set PassSimGeneration   1
   } else {
      set PassSimGeneration   0
      puts "--------- :: Fail ${project_name}.qsys simulation generation"
   }
}
if { $GenerateSynth > 0 } {
   puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
   puts "--------- ::"
   if { $QuartusPRO > 0 } {
     puts "--------- :: qsys-generate --pro ${project_name}.qsys ${qsys_gen_synth}"
   } else {
     puts "--------- :: qsys-generate ${project_name}.qsys ${qsys_gen_synth}"
   }
   puts "--------- ::"
   puts "--------- ::"
   if { $QuartusPRO > 0 } {
     if { [ catch { exec ${QSYS_ROOTDIR}qsys-generate --pro ${project_name}.qsys ${qsys_gen_synth}} msg ] } {
        puts "--------- :: $msg"
     }
   } else {
     if { [ catch { exec ${QSYS_ROOTDIR}qsys-generate ${project_name}.qsys ${qsys_gen_synth}} msg ] } {
        puts "--------- :: $msg"
     }
   }
   if { [ file exist $QIPFILE ] == 1 } {
      set PassSynthGeneration   1
   } else {
      set PassSynthGeneration   0
      puts "--------- :: Fail ${project_name}.qsys synthesis generation"
   }
   puts "--------- ::"
}



if { $GenerateQPF > 0 && $PassSimGeneration>0 && $PassSynthGeneration>0 } {
   set devkit_qsys_script "${IP_ROOTDIR}/altera/altera_pcie/altera_pcie_a10_ed/example_design/a10-revd-devkit-pinout-qsys-script.tcl"
   puts "--------- ::---------------------------------------------------------------------------------------------------------------- "
   puts "--------- ::"
   if { $QuartusPRO > 0 } {
     puts "--------- :: qsys-script --pro --package-version=16.1 --quartus-project=${project_name} --script=${devkit_qsys_script} --cmd=set argstring ${project_name},${DeviceQSF}"
   } else {
     puts "--------- :: qsys-script --package-version=16.0 --script=${devkit_qsys_script} --cmd=set argstring ${project_name},${DeviceQSF}"
   }
   puts "--------- ::"
   puts "--------- ::"
   if { $QuartusPRO > 0 } {
     if { $PlatformWin > 0 } {
       if { [ catch {exec ${QSYS_ROOTDIR}qsys-script --pro --package-version=16.1 --quartus-project=${project_name} --script=${devkit_qsys_script} --cmd=\"set argstring ${project_name},${DeviceQSF}\"} msg ] } { 
          puts "--------- :: $msg"
	  }
     } else {
       if { [ catch {exec qsys-script --pro --package-version=16.1 --quartus-project=${project_name} --script=${devkit_qsys_script} --cmd=\'set argstring ${project_name},${DeviceQSF}\'} msg ] } { 
          puts "--------- :: $msg"
	  }
     }
   } else {
     if { $PlatformWin > 0 } {
       if { [ catch {exec ${QSYS_ROOTDIR}qsys-script --package-version=16.0 --script=${devkit_qsys_script} --cmd=\"set argstring ${project_name},${DeviceQSF}\"} msg ] } { 
          puts "--------- :: $msg"
	  }
     } else {
       if { [ catch {exec qsys-script --package-version=16.0 --script=${devkit_qsys_script} --cmd=\'set argstring ${project_name},${DeviceQSF}\'} msg ] } { 
          puts "--------- :: $msg"
          }
     }
   }
   puts "--------- ::"
   #--------------------------------------------------------------#
   #
   # Retrieve device family from QSF
   #
   #--------------------------------------------------------------#
   #
   # Create project
   if { $QuartusPRO > 0 } {
     project_open $project_name
   } else {
     project_new -overwrite $project_name
   }
   #--------------------------------------------------------------#
   #
   # Project setting
   set_global_assignment -name TOP_LEVEL_ENTITY $project_name
   set_global_assignment -name FAMILY "$deviceFamily_qsf"
   set_global_assignment -name DEVICE "$DeviceQSF"

   #Waiving some warnings
   set_instance_assignment -name MESSAGE_DISABLE 14284 -entity altpcie_dynamic_control
   set_instance_assignment -name MESSAGE_DISABLE 14285 -entity altpcie_dynamic_control
   set_instance_assignment -name MESSAGE_DISABLE 14320 -entity altpcie_dynamic_control
   set_global_assignment -name MESSAGE_DISABLE 13410
   set_global_assignment -name MESSAGE_DISABLE 12677
   set_global_assignment -name MESSAGE_DISABLE 15610

   if { $GenerateQPF>0 } {
      if { [ file exist $QIPFILE ] == 1 } {
         set_global_assignment -name QIP_FILE $QIPFILE
      } else {
         set_global_assignment -name QSYS_FILE ${project_name}.qsys
      }
   } else {
      set_global_assignment -name QSYS_FILE ${project_name}.qsys
   }

   # Pinout created with a10-revd-devkit-pinout-qsys-script.tcl
   if { [ file exist $a10_devkit_tcl ] == 1 } {
      source $a10_devkit_tcl
   }
   # SDC created with a10-revd-devkit-pinout-qsys-script.tcl
   if { [ file exist $a10_devkit_sdc ] == 1 } {
      set_global_assignment -name SDC_FILE $a10_devkit_sdc
   }

   # Fitter settings
   set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
   set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON
   puts "--------- ::"
   puts "--------- :: Successfully generated : ${project_name}.qpf, ${project_name}.qsf                                               "
   puts "--------- ::                                                                                                                 "
   project_close

   # Cleanup unused QII dir
   file delete -force -- db
}


if { $PassSimGeneration==0 || $PassSynthGeneration==0 } {
   set FAILG [ open $failgen "w" ]
   puts $FAILG "synth:${PassSynthGeneration} tb:${PassSimGeneration} "
   close $FAILG
}
