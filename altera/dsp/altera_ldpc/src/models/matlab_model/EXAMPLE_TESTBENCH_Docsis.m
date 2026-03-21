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

%--- Testbench Parameters  ---%
nb             = param.Test_nb;            % number of codewords
SNR            = param.Test_SNR;           % SNR
inwidth        = param.Test_inwidth;       % width of the input LLRs

%--- Decoder Parameters  ---%
decwidth       = param.Test_decwidth;      % width of the decoder LLRs
nb_iterations  = param.Test_nb_iterattions;% number of decoding iterations
attenuation    = param.Test_attenuation;   % attenuation factor


% Obtaining parameters
rate_table = [89 85 75];

H_array = cell(1,3);
G_array = cell(1,3);
info_length = zeros(1,3);
cwd_length = zeros(1,3);
for ii=1:3
    load( strcat('HG_Docsis',sprintf('%d',rate_table(ii)),'.mat'));

    H_array{ii} = H;
    G_array{ii} = G;

    info_length(ii) = size(G_array{ii},1);
    cwd_length(ii) = size(G_array{ii},2);
end




%------  Input Data  -----%
rand('seed',0);
rate = floor(3*rand(1,nb))+1;

Data = zeros(nb,max(info_length));
cwd = zeros(max(cwd_length),nb);
for ii=1:3
    G =  G_array{ii};
    israte = rate==ii;
    nb_temp = sum(israte);
    
    %------  Input Data  -----%
    data_temp = floor(2*rand(nb_temp,info_length(ii)));
    Data(israte,1:info_length(ii)) = data_temp;
    
    %------ Encoding  -----%
    cwd(1:cwd_length(ii),israte)= mod(data_temp*G,2)';
end



%------  modulation BPSK -----%
seq_bpsk = 1-2*cwd;     % 1--> -1     0-->1

%------  Channel -----%
rFEC=mean(info_length(rate)./cwd_length(rate));
sigma = sqrt(1/(2*rFEC*(10^(SNR/10))));
seq_channel = seq_bpsk + sigma*randn(size(seq_bpsk)) ;

%-----  Formating datas for tb  -----%
q_values = (- floor((2^inwidth-1)/2)*2^(-inwidth+1):2^(-inwidth+1): floor((2^inwidth-1)/2)*2^(-inwidth+1)) ;%* 2^(inwidth-1)/(2^(inwidth-1)-1) ;
[~,qcode] = quantiz_oct(reshape(seq_channel,1,[]),q_values,circshift(0:2^inwidth-1,[0 2^(inwidth-1)])); 
qcode = qcode.';
qcode((qcode>2^(inwidth-1)-1)) = qcode((qcode>2^(inwidth-1)-1))- 2^inwidth;
qcode = reshape(qcode,size(cwd,1),[]);


%----- Decoding using LDPC Docsis standard -----%
[dec, average_layer] = LDPC_decoder_Docsis(qcode, rate, decwidth, nb_iterations, attenuation);
