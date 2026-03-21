% (C) 2001-2018 Intel Corporation. All rights reserved.
% Your use of Intel Corporation's design tools, logic functions and other 
% software and tools, and its AMPP partner logic functions, and any output 
% files from any of the foregoing (including device programming or simulation 
% files), and any associated documentation or information are expressly subject 
% to the terms and conditions of the Intel Program License Subscription 
% Agreement, Intel FPGA IP License Agreement, or other applicable 
% license agreement, including, without limitation, that your use is for the 
% sole purpose of programming logic devices manufactured by Intel and sold by 
% Intel or its authorized distributors.  Please refer to the applicable 
% agreement for further details.




clear;

run set_test_parameters.m;

code_number     = param.Test_code_number;   % Code number
nb              = param.Test_nb;              % number of codewords


% Obtaining parameters
[matrix,Q,cwd_length,M] = get_ldpc_dvb_index(code_number);
info_length = cwd_length - M*Q;



%------  Input Data  -----%
rand('seed',0)
Data = floor(2*rand(nb,info_length));


%------ Encoding by LDPC DVB standard ------%
cwd = LDPC_encoder_DVB(Data, param);

