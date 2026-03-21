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


clear

run set_test_parameters.m;


%--- Testbench Parameters  ---%
nb             = param.Test_nb;            % number of codewords
SNR            = param.Test_SNR;           % SNR
inwidth        = param.Test_inwidth;       % width of the input LLRs

%--- Decoder Parameters  ---%
layered        = param.Test_layer;         % width of the decoder LLRs
decwidth       = param.Test_decwidth;      % width of the decoder LLRs
nb_iterations  = param.Test_nb_iterattions;% number of decoding iterations
attenuation    = param.Test_attenuation;   % attenuation factor
par            = param.Test_par;           % decoder parallelism

cwd_length     = param.Test_cwd_length;    % codeword length (8176,8160)



% Obtaining parameters
if (cwd_length==8160)
    short_frame=1;
else
    short_frame=0;
end


load('HG_78NASA.mat');
info_length = size(G,1)-18*short_frame;



%------ Random input data generation  -----%
rand('seed',0)
Data = floor(2*rand(nb,info_length));

%------ Encoding the input data  -----%
cwd = mod(Data*G(18*short_frame+(1:info_length),:),2)';
cwd(1:18*short_frame,:) = [];
cwd = [cwd ; zeros(2*short_frame,nb)];

%------  modulation BPSK -----%
seq_bpsk = 1-2*cwd;     % 1--> -1     0-->1

%------  Channel -----%
rFEC=info_length/cwd_length;
sigma = sqrt(1/(2*rFEC*(10^(SNR/10))));
seq_channel = seq_bpsk + sigma*randn(size(seq_bpsk)) ;

%-----  Formating datas for tb  -----%
q_values = (- floor((2^inwidth-1)/2)*2^(-inwidth+1):2^(-inwidth+1): floor((2^inwidth-1)/2)*2^(-inwidth+1)) ;%* 2^(inwidth-1)/(2^(inwidth-1)-1) ;
[temp,qcode] = quantiz_oct(reshape(seq_channel,1,[]),q_values,circshift(0:2^inwidth-1,[0 2^(inwidth-1)]));
qcode = reshape(qcode,cwd_length,[]);
qcode((qcode>2^(inwidth-1)-1)) = qcode((qcode>2^(inwidth-1)-1))- 2^inwidth;
qcode = reshape(qcode,cwd_length,[]);


%-----  Short to normal frame  -----%
if short_frame
    qcode = [(2^(inwidth-1)-1)*ones(18,nb); qcode(1:end-2,:) ];
end





%------ Run the LDPC decoder (NASA) -----%
[dec, average_ite] = LDPC_decoder_NASA(qcode, par, decwidth, nb_iterations, attenuation, layered);




if (short_frame)
    dec = [ dec(18+(1:info_length+1022),:); zeros(2,nb)];
end

