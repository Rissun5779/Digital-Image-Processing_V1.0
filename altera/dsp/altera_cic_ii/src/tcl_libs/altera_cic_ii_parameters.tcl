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




proc add_module_parameters_filter_type {} {
    add_parameter FILTER_TYPE string "interpolator"
    set_parameter_property FILTER_TYPE DISPLAY_NAME "Filter Type"
    set_parameter_property FILTER_TYPE ENABLED true
    set_parameter_property FILTER_TYPE UNITS None
    set_parameter_property FILTER_TYPE DESCRIPTION "Specifies an Interpolator or Decimator"
    set_parameter_property FILTER_TYPE DISPLAY_HINT radio
    set_parameter_property FILTER_TYPE HDL_PARAMETER true
    set_parameter_property FILTER_TYPE ALLOWED_RANGES {interpolator:Interpolator decimator:Decimator}
    set_parameter_property FILTER_TYPE GROUP "Module type"
}

proc add_module_parameters_number_of_stages {} {
    add_parameter STAGES INTEGER 1 
    set_parameter_property STAGES DISPLAY_NAME "Number of Stages"
    set_parameter_property STAGES ENABLED true
    set_parameter_property STAGES UNITS None
    set_parameter_property STAGES ALLOWED_RANGES 1:12
    set_parameter_property STAGES DESCRIPTION "Number of Stages"
    set_parameter_property STAGES HDL_PARAMETER true
    set_parameter_property STAGES GROUP "Filter Specifications"
}

proc add_module_parameters_differential_delay {} {
    add_parameter DIFF_DELAY INTEGER 1 
    set_parameter_property DIFF_DELAY DISPLAY_NAME "Differential Delay"
    set_parameter_property DIFF_DELAY ENABLED true
    set_parameter_property DIFF_DELAY UNITS None
    set_parameter_property DIFF_DELAY ALLOWED_RANGES 1:2
    set_parameter_property DIFF_DELAY DESCRIPTION "Differential Delay"
    set_parameter_property DIFF_DELAY HDL_PARAMETER true
    set_parameter_property DIFF_DELAY GROUP "Filter Specifications"
}

proc add_module_parameters_variable_rate {} {
    add_parameter VARIABLE_RATE_ENABLED INTEGER 0
    set_parameter_property VARIABLE_RATE_ENABLED DISPLAY_NAME "Enable variable rate change factor"
    set_parameter_property VARIABLE_RATE_ENABLED UNITS None
    set_parameter_property VARIABLE_RATE_ENABLED DESCRIPTION "Chose between a variable rate change factor or fixed rate"
    set_parameter_property VARIABLE_RATE_ENABLED DISPLAY_HINT boolean
    set_parameter_property VARIABLE_RATE_ENABLED HDL_PARAMETER true
    set_parameter_property VARIABLE_RATE_ENABLED GROUP "Filter Specifications"


    add_parameter RATE_CHANGE_FACTOR_FIXED INTEGER 8
    set_parameter_property RATE_CHANGE_FACTOR_FIXED DISPLAY_NAME "Rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_FIXED ENABLED true
    set_parameter_property RATE_CHANGE_FACTOR_FIXED VISIBLE true
    set_parameter_property RATE_CHANGE_FACTOR_FIXED ALLOWED_RANGES 2:32000
    set_parameter_property RATE_CHANGE_FACTOR_FIXED UNITS None
    set_parameter_property RATE_CHANGE_FACTOR_FIXED DESCRIPTION "Rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_FIXED HDL_PARAMETER false
    set_parameter_property RATE_CHANGE_FACTOR_FIXED DERIVED false
    set_parameter_property RATE_CHANGE_FACTOR_FIXED GROUP "Filter Specifications"

    add_parameter RATE_CHANGE_FACTOR_LOWER_BOUND INTEGER 8
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND DISPLAY_NAME "Minimum rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND ENABLED false
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND VISIBLE false
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND ALLOWED_RANGES 2:32000
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND UNITS None
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND DESCRIPTION "Minimum rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND HDL_PARAMETER false
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND DERIVED false
    set_parameter_property RATE_CHANGE_FACTOR_LOWER_BOUND GROUP "Filter Specifications"

    add_parameter RATE_CHANGE_FACTOR_UPPER_BOUND INTEGER 21
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND DISPLAY_NAME "Maximum rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND ENABLED false
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND VISIBLE false
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND ALLOWED_RANGES 2:32000
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND UNITS None
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND DESCRIPTION "Maximum rate change factor"
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND HDL_PARAMETER false
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND DERIVED false
    set_parameter_property RATE_CHANGE_FACTOR_UPPER_BOUND GROUP "Filter Specifications"

    add_parameter RATE_CHANGE_MIN INTEGER 8
    set_parameter_property RATE_CHANGE_MIN DERIVED TRUE
    set_parameter_property RATE_CHANGE_MIN VISIBLE false
    set_parameter_property RATE_CHANGE_MIN HDL_PARAMETER TRUE

    add_parameter RATE_CHANGE_MAX INTEGER 21
    set_parameter_property RATE_CHANGE_MAX DERIVED TRUE
    set_parameter_property RATE_CHANGE_MAX VISIBLE false
    set_parameter_property RATE_CHANGE_MAX HDL_PARAMETER TRUE


}


proc add_module_parameters_multi_channel {} {
    add_parameter NUMBER_OF_INTERFACES INTEGER 1
    set_parameter_property NUMBER_OF_INTERFACES DISPLAY_NAME "Number of interfaces"
    set_parameter_property NUMBER_OF_INTERFACES ENABLED true
    set_parameter_property NUMBER_OF_INTERFACES ALLOWED_RANGES 1:32
    set_parameter_property NUMBER_OF_INTERFACES UNITS None
    set_parameter_property NUMBER_OF_INTERFACES DESCRIPTION "Number of interfaces"
    set_parameter_property NUMBER_OF_INTERFACES HDL_PARAMETER true
    set_parameter_property NUMBER_OF_INTERFACES GROUP "Filter Specifications"

    add_parameter CHANNELS_PER_INTERFACE INTEGER 1
    set_parameter_property CHANNELS_PER_INTERFACE DISPLAY_NAME "Number of channels per interface"
    set_parameter_property CHANNELS_PER_INTERFACE ENABLED true
    set_parameter_property CHANNELS_PER_INTERFACE ALLOWED_RANGES 1:1024
    set_parameter_property CHANNELS_PER_INTERFACE UNITS None
    set_parameter_property CHANNELS_PER_INTERFACE DESCRIPTION "Number of channels per interface"
    set_parameter_property CHANNELS_PER_INTERFACE HDL_PARAMETER true
    set_parameter_property CHANNELS_PER_INTERFACE GROUP "Filter Specifications"

}



proc add_module_data_storage {} {
    add_parameter REQUEST_INTEGRATOR_USE_MEM BOOLEAN  false
    set_parameter_property REQUEST_INTEGRATOR_USE_MEM DISPLAY_NAME "Map integrator data storage to memory"
    set_parameter_property REQUEST_INTEGRATOR_USE_MEM VISIBLE false
    set_parameter_property REQUEST_INTEGRATOR_USE_MEM DISPLAY_HINT boolean
    set_parameter_property REQUEST_INTEGRATOR_USE_MEM DESCRIPTION "Specifies the type of resources to be used the integrator"
    set_parameter_property REQUEST_INTEGRATOR_USE_MEM GROUP "Data Storage Options"


    add_parameter INTEGRATOR_USE_MEM BOOLEAN  false
    set_parameter_property INTEGRATOR_USE_MEM DISPLAY_NAME "Map integrator data storage to memory"
    set_parameter_property INTEGRATOR_USE_MEM VISIBLE true
    set_parameter_property INTEGRATOR_USE_MEM ENABLED false
    set_parameter_property INTEGRATOR_USE_MEM DERIVED true
    set_parameter_property INTEGRATOR_USE_MEM DISPLAY_HINT boolean
    set_parameter_property INTEGRATOR_USE_MEM DESCRIPTION "Specifies the type of resources to be used the integrator"
    set_parameter_property INTEGRATOR_USE_MEM GROUP "Data Storage Options"
    set_parameter_property INTEGRATOR_USE_MEM HDL_PARAMETER true


    add_parameter INTEGRATOR_MEM_TYPE string "auto"
    set_parameter_property INTEGRATOR_MEM_TYPE DISPLAY_NAME "RAM type used for integrator data storage"
    set_parameter_property INTEGRATOR_MEM_TYPE ENABLED false
    set_parameter_property INTEGRATOR_MEM_TYPE HDL_PARAMETER true
    set_parameter_property INTEGRATOR_MEM_TYPE DESCRIPTION "Specifies the type of resources to be used the integrator"
    set_parameter_property INTEGRATOR_MEM_TYPE ALLOWED_RANGES {"auto:Auto"}
    set_parameter_property INTEGRATOR_MEM_TYPE GROUP "Data Storage Options"

    add_parameter REQUEST_DIFFERENTIATOR_USE_MEM BOOLEAN  false
    set_parameter_property REQUEST_DIFFERENTIATOR_USE_MEM DISPLAY_NAME "Map differentiator data storage to memory"
    set_parameter_property REQUEST_DIFFERENTIATOR_USE_MEM VISIBLE false
    set_parameter_property REQUEST_DIFFERENTIATOR_USE_MEM DISPLAY_HINT boolean
    set_parameter_property REQUEST_DIFFERENTIATOR_USE_MEM DESCRIPTION "Specifies the type of resources to be used the differentiator"
    set_parameter_property REQUEST_DIFFERENTIATOR_USE_MEM GROUP "Data Storage Options"


    add_parameter DIFFERENTIATOR_USE_MEM BOOLEAN  false
    set_parameter_property DIFFERENTIATOR_USE_MEM DISPLAY_NAME "Map differentiator data storage to memory"
    set_parameter_property DIFFERENTIATOR_USE_MEM VISIBLE true
    set_parameter_property DIFFERENTIATOR_USE_MEM ENABLED false
    set_parameter_property DIFFERENTIATOR_USE_MEM DERIVED true
    set_parameter_property DIFFERENTIATOR_USE_MEM DISPLAY_HINT boolean
    set_parameter_property DIFFERENTIATOR_USE_MEM DESCRIPTION "Specifies the type of resources to be used the integrator"
    set_parameter_property DIFFERENTIATOR_USE_MEM GROUP "Data Storage Options"
    set_parameter_property DIFFERENTIATOR_USE_MEM HDL_PARAMETER true


    add_parameter DIFFERENTIATOR_MEM_TYPE string "auto"
    set_parameter_property DIFFERENTIATOR_MEM_TYPE DISPLAY_NAME "RAM type used for differentiator data storage"
    set_parameter_property DIFFERENTIATOR_MEM_TYPE ENABLED false
    set_parameter_property DIFFERENTIATOR_MEM_TYPE HDL_PARAMETER true
    set_parameter_property DIFFERENTIATOR_MEM_TYPE DESCRIPTION "Specifies the type of resources to be used the differentiator"
    set_parameter_property DIFFERENTIATOR_MEM_TYPE ALLOWED_RANGES {"auto:Auto"}
    set_parameter_property DIFFERENTIATOR_MEM_TYPE GROUP "Data Storage Options"

    
}

proc add_module_optimizations {} {
    add_parameter ENABLE_PIPELINING BOOLEAN 0
    set_parameter_property ENABLE_PIPELINING DISPLAY_NAME "Use integrator pipelining"
    set_parameter_property ENABLE_PIPELINING ENABLED false
    set_parameter_property ENABLE_PIPELINING UNITS None
    set_parameter_property ENABLE_PIPELINING DESCRIPTION "Enable pipelining of Integrator states"
    set_parameter_property ENABLE_PIPELINING DISPLAY_HINT boolean
    set_parameter_property ENABLE_PIPELINING HDL_PARAMETER false
    set_parameter_property ENABLE_PIPELINING GROUP "Optimizations"


    add_parameter PIPELINING_DEPTH INTEGER 1
    set_parameter_property PIPELINING_DEPTH DISPLAY_NAME "Pipeline stages per integrator"
    set_parameter_property PIPELINING_DEPTH ENABLED true
    set_parameter_property PIPELINING_DEPTH VISIBLE false
    set_parameter_property PIPELINING_DEPTH UNITS None
    set_parameter_property PIPELINING_DEPTH DESCRIPTION "Pipeline stages per integrator"
    set_parameter_property PIPELINING_DEPTH ALLOWED_RANGES  1:1024
    set_parameter_property PIPELINING_DEPTH HDL_PARAMETER  false
    set_parameter_property PIPELINING_DEPTH GROUP "Optimizations"

    add_parameter PIPELINING INTEGER 0
    set_parameter_property PIPELINING DISPLAY_NAME "Pipeline stages per integrator"
    set_parameter_property PIPELINING ENABLED false
    set_parameter_property PIPELINING UNITS None    
    set_parameter_property PIPELINING VISIBLE true
    set_parameter_property PIPELINING DESCRIPTION "Pipeline stages per integrator"
    set_parameter_property PIPELINING ALLOWED_RANGES  0:1024
    set_parameter_property PIPELINING DERIVED  true
    set_parameter_property PIPELINING HDL_PARAMETER  true
    set_parameter_property PIPELINING GROUP "Optimizations"

}

proc     add_module_input_options {} {
    add_parameter  INPUT_WIDTH INTEGER 8
    set_parameter_property INPUT_WIDTH DISPLAY_NAME "Input data width"
    set_parameter_property INPUT_WIDTH ENABLED true
    set_parameter_property INPUT_WIDTH UNITS None
    set_parameter_property INPUT_WIDTH ALLOWED_RANGES 1:32
    set_parameter_property INPUT_WIDTH DESCRIPTION "Bit width of the input stream"
    set_parameter_property INPUT_WIDTH HDL_PARAMETER true
    set_parameter_property INPUT_WIDTH GROUP "Input Options"

}
proc     add_module_output_options {} {
    add_parameter FULL_OUTPUT_RESOLUTION BOOLEAN true
    set_parameter_property FULL_OUTPUT_RESOLUTION DISPLAY_NAME "Full Resolution Output"
    set_parameter_property FULL_OUTPUT_RESOLUTION ENABLED true
    set_parameter_property FULL_OUTPUT_RESOLUTION DERIVED true
    set_parameter_property FULL_OUTPUT_RESOLUTION VISIBLE false
    set_parameter_property FULL_OUTPUT_RESOLUTION UNITS None
    set_parameter_property FULL_OUTPUT_RESOLUTION DESCRIPTION "Choose between full resolution output or rounding"
    set_parameter_property FULL_OUTPUT_RESOLUTION DISPLAY_HINT boolean
    set_parameter_property FULL_OUTPUT_RESOLUTION HDL_PARAMETER true 
    set_parameter_property FULL_OUTPUT_RESOLUTION GROUP "Output Options"


    add_parameter  REQUESTED_OUTPUT_WIDTH INTEGER 8
    set_parameter_property REQUESTED_OUTPUT_WIDTH DISPLAY_NAME "Output data width"
    set_parameter_property REQUESTED_OUTPUT_WIDTH VISIBLE false
    set_parameter_property REQUESTED_OUTPUT_WIDTH DERIVED false
    set_parameter_property REQUESTED_OUTPUT_WIDTH ALLOWED_RANGES 1:32
    set_parameter_property REQUESTED_OUTPUT_WIDTH UNITS None
    set_parameter_property REQUESTED_OUTPUT_WIDTH DESCRIPTION "Bit width of the output stream"
    set_parameter_property REQUESTED_OUTPUT_WIDTH HDL_PARAMETER false
    set_parameter_property REQUESTED_OUTPUT_WIDTH GROUP "Output Options"

    add_parameter  OUTPUT_WIDTH INTEGER 8
    set_parameter_property OUTPUT_WIDTH DISPLAY_NAME "Output data width"
    set_parameter_property OUTPUT_WIDTH ENABLED false
    set_parameter_property OUTPUT_WIDTH VISIBLE TRUE
    set_parameter_property OUTPUT_WIDTH VISIBLE TRUE
    set_parameter_property OUTPUT_WIDTH ALLOWED_RANGES 1:1024
    set_parameter_property OUTPUT_WIDTH DERIVED true
    set_parameter_property OUTPUT_WIDTH DESCRIPTION "Bit width of the output stream"
    set_parameter_property OUTPUT_WIDTH HDL_PARAMETER true
    set_parameter_property OUTPUT_WIDTH GROUP "Output Options"

    add_parameter ROUNDING_METHOD string "NONE"
    set_parameter_property ROUNDING_METHOD DISPLAY_NAME "Output Rounding Method"
    set_parameter_property ROUNDING_METHOD ENABLED false
    set_parameter_property ROUNDING_METHOD UNITS None
    set_parameter_property ROUNDING_METHOD DESCRIPTION "Method used for rounding output to given data width"
    set_parameter_property ROUNDING_METHOD DISPLAY_HINT radio
    set_parameter_property ROUNDING_METHOD ALLOWED_RANGES {"NONE:None" "truncation:Truncation" "convergent rounding:Convergent Rounding" "rounding up:Rounding Up" "saturation:Saturation" }
    set_parameter_property ROUNDING_METHOD GROUP "Output Options"


    add_parameter HOGENAUER_PRUNING BOOLEAN false
    set_parameter_property HOGENAUER_PRUNING DISPLAY_NAME "Perform Hogenauer pruning"
    set_parameter_property HOGENAUER_PRUNING ENABLED false
    set_parameter_property HOGENAUER_PRUNING UNITS None
    set_parameter_property HOGENAUER_PRUNING DESCRIPTION "Choose to allow pruning to occur at each stage of the filter"
    set_parameter_property HOGENAUER_PRUNING DISPLAY_HINT boolean
    set_parameter_property HOGENAUER_PRUNING HDL_PARAMETER false
    set_parameter_property HOGENAUER_PRUNING GROUP "Output Options"

}
proc add_module_widths {} {

    add_parameter C_STAGE_0_WIDTH INTEGER 60
    set_parameter_property C_STAGE_0_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_0_WIDTH VISIBLE false 
    set_parameter_property C_STAGE_0_WIDTH DERIVED true 
    
    add_parameter C_STAGE_1_WIDTH INTEGER 60
    set_parameter_property C_STAGE_1_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_1_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_1_WIDTH DERIVED true     

    add_parameter C_STAGE_2_WIDTH INTEGER 60
    set_parameter_property C_STAGE_2_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_2_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_2_WIDTH DERIVED true     

    add_parameter C_STAGE_3_WIDTH INTEGER 60
    set_parameter_property C_STAGE_3_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_3_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_3_WIDTH DERIVED true     

    add_parameter C_STAGE_4_WIDTH INTEGER 60
    set_parameter_property C_STAGE_4_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_4_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_4_WIDTH DERIVED true     

    add_parameter C_STAGE_5_WIDTH INTEGER 60
    set_parameter_property C_STAGE_5_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_5_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_5_WIDTH DERIVED true     

    add_parameter C_STAGE_6_WIDTH INTEGER 60
    set_parameter_property C_STAGE_6_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_6_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_6_WIDTH DERIVED true     

    add_parameter C_STAGE_7_WIDTH INTEGER 60
    set_parameter_property C_STAGE_7_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_7_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_7_WIDTH DERIVED true     

    add_parameter C_STAGE_8_WIDTH INTEGER 60
    set_parameter_property C_STAGE_8_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_8_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_8_WIDTH DERIVED true     

    add_parameter C_STAGE_9_WIDTH INTEGER 60
    set_parameter_property C_STAGE_9_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_9_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_9_WIDTH DERIVED true     

    add_parameter C_STAGE_10_WIDTH INTEGER 60
    set_parameter_property C_STAGE_10_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_10_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_10_WIDTH DERIVED TRUE     

    add_parameter C_STAGE_11_WIDTH INTEGER 60
    set_parameter_property C_STAGE_11_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_11_WIDTH VISIBLE false     
    set_parameter_property C_STAGE_11_WIDTH DERIVED TRUE     

    add_parameter C_STAGE_12_WIDTH INTEGER 60
    set_parameter_property C_STAGE_12_WIDTH HDL_PARAMETER true
    set_parameter_property C_STAGE_12_WIDTH VISIBLE false 
    set_parameter_property C_STAGE_12_WIDTH DERIVED TRUE 

    add_parameter I_STAGE_0_WIDTH INTEGER 60
    set_parameter_property I_STAGE_0_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_0_WIDTH VISIBLE false 
    set_parameter_property I_STAGE_0_WIDTH DERIVED true 
    
    add_parameter I_STAGE_1_WIDTH INTEGER 60
    set_parameter_property I_STAGE_1_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_1_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_1_WIDTH DERIVED true     

    add_parameter I_STAGE_2_WIDTH INTEGER 60
    set_parameter_property I_STAGE_2_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_2_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_2_WIDTH DERIVED true     

    add_parameter I_STAGE_3_WIDTH INTEGER 60
    set_parameter_property I_STAGE_3_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_3_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_3_WIDTH DERIVED true     

    add_parameter I_STAGE_4_WIDTH INTEGER 60
    set_parameter_property I_STAGE_4_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_4_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_4_WIDTH DERIVED true     

    add_parameter I_STAGE_5_WIDTH INTEGER 60
    set_parameter_property I_STAGE_5_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_5_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_5_WIDTH DERIVED true     

    add_parameter I_STAGE_6_WIDTH INTEGER 60
    set_parameter_property I_STAGE_6_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_6_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_6_WIDTH DERIVED true     

    add_parameter I_STAGE_7_WIDTH INTEGER 60
    set_parameter_property I_STAGE_7_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_7_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_7_WIDTH DERIVED true     

    add_parameter I_STAGE_8_WIDTH INTEGER 60
    set_parameter_property I_STAGE_8_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_8_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_8_WIDTH DERIVED true     

    add_parameter I_STAGE_9_WIDTH INTEGER 60
    set_parameter_property I_STAGE_9_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_9_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_9_WIDTH DERIVED true     

    add_parameter I_STAGE_10_WIDTH INTEGER 60
    set_parameter_property I_STAGE_10_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_10_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_10_WIDTH DERIVED    true 

    add_parameter I_STAGE_11_WIDTH INTEGER 60
    set_parameter_property I_STAGE_11_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_11_WIDTH VISIBLE false     
    set_parameter_property I_STAGE_11_WIDTH DERIVED    true 

    add_parameter I_STAGE_12_WIDTH INTEGER 60
    set_parameter_property I_STAGE_12_WIDTH HDL_PARAMETER true
    set_parameter_property I_STAGE_12_WIDTH VISIBLE false 
    set_parameter_property I_STAGE_12_WIDTH DERIVED true


    add_parameter MAX_I_STAGE_WIDTH INTEGER 60
    set_parameter_property MAX_I_STAGE_WIDTH HDL_PARAMETER true
    set_parameter_property MAX_I_STAGE_WIDTH VISIBLE false     
    set_parameter_property MAX_I_STAGE_WIDTH DERIVED true 

    add_parameter MAX_C_STAGE_WIDTH INTEGER 60
    set_parameter_property MAX_C_STAGE_WIDTH HDL_PARAMETER true
    set_parameter_property MAX_C_STAGE_WIDTH VISIBLE false 
    set_parameter_property MAX_C_STAGE_WIDTH DERIVED true 


}
proc add_module_parameters_cic_top {} {
    add_parameter selected_device_family STRING
    set_parameter_property selected_device_family VISIBLE false
    set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

    add_module_parameters_filter_type
    add_module_parameters_number_of_stages
    add_module_parameters_differential_delay
    add_module_parameters_variable_rate
    add_module_parameters_multi_channel
    add_module_input_options
    add_module_output_options
    add_module_data_storage
    add_module_optimizations
    add_module_widths
}

