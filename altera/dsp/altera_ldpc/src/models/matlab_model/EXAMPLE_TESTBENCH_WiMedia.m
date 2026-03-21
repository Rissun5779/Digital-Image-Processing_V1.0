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
cwd_length     = param.Test_cwd_length;    % codeword length (1320,1200)
%--- Decoder Parameters  ---%
decwidth       = param.Test_decwidth;      % width of the decoder LLRs
nb_iterations  = param.Test_nb_iterattions;% number of decoding iterations
attenuation    = param.Test_attenuation;   % attenuation factor
par            = param.Test_par;           % decoder parallelism




% Obtaining parameters
if (cwd_length==1200)
    short_frame=1;
else
    short_frame=0;
end

rate_table = [8 75 625 5];
for ii=1:4
    load( strcat('HG_0.',sprintf('%d',rate_table(ii)),'WiMedia.mat'));
    G_array{ii} = G(:,1:end-4*30*short_frame);
    info_length(ii) = size(G_array{ii},1);
end



%------  Input Data / Encoding -----%
rand('seed',0)
rate = floor(4*rand(1,nb))+1;


Data = zeros(nb,max(info_length));
for ii=1:4
    israte = rate==ii;
    nb_temp = sum(israte);
    
    %------ Randomly generated input data  -----%
    data_temp = floor(2*rand(nb_temp,info_length(ii)));
    Data(israte,1:info_length(ii)) = data_temp;
end

%------ Run the LDPC encoder (WiMedia) -----%
cwd = LDPC_encoder_WiMedia(Data, rate, param);





%------  modulation BPSK -----%
seq_bpsk = 1-2*cwd;     % 1--> -1     0-->1

%------  Channel -----%
rFEC=mean(info_length(rate)./cwd_length);
sigma = sqrt(1/(2*rFEC*(10^(SNR/10)))); % add random noise
seq_channel = seq_bpsk + sigma*randn(size(seq_bpsk)) ;

%-----  Formating datas for tb  -----%
q_values = (- floor((2^inwidth-1)/2)*2^(-inwidth+1):2^(-inwidth+1): floor((2^inwidth-1)/2)*2^(-inwidth+1)) ;%* 2^(inwidth-1)/(2^(inwidth-1)-1) ;
[~,qcode] = quantiz_oct(reshape(seq_channel,1,[]),q_values,circshift(0:2^inwidth-1,[0 2^(inwidth-1)]));
qcode = qcode.';
qcode((qcode>2^(inwidth-1)-1)) = qcode((qcode>2^(inwidth-1)-1))- 2^inwidth;
qcode = reshape(qcode,size(cwd,1),[]);




%------ Run the LDPC decoder (WiMedia) -----%
[dec, average_ite] = LDPC_decoder_WiMedia(qcode, rate, par, cwd_length, decwidth, nb_iterations, attenuation);





