load( 'CmlHome.mat' );

% determine where to store your files
base_name = 'lte_rtl_crc_et';
if ispc
    	data_directory = strcat( cml_home, '\output\', base_name, '\' );
else
    	data_directory = strcat( cml_home, '/output/', base_name, '/' );
end;
if ~exist( data_directory, 'dir' )
    	mkdir(data_directory);
end;

% LTE supported block sizes
K = [
      40,   48,   56,   64,   72,   80,   88,   96,  104,  112, ...
	 120,  128,  136,  144,  152,  160,  168,  176,  184,  192, ...
	 200,  208,  216,  224,  232,  240,  248,  256,  264,  272, ...
	 280,  288,  296,  304,  312,  320,  328,  336,  344,  352, ...
	 360,  368,  376,  384,  392,  400,  408,  416,  424,  432, ...
	 440,  448,  456,  464,  472,  480,  488,  496,  504,  512, ...
	 528,  544,  560,  576,  592,  608,  624,  640,  656,  672, ...
	 688,  704,  720,  736,  752,  768,  784,  800,  816,  832, ...
	 848,  864,  880,  896,  912,  928,  944,  960,  976,  992, ...
	1008, 1024, 1056, 1088, 1120, 1152, 1184, 1216, 1248, 1280, ...
	1312, 1344, 1376, 1408, 1440, 1472, 1504, 1536, 1568, 1600, ...
	1632, 1664, 1696, 1728, 1760, 1792, 1824, 1856, 1888, 1920, ...
	1952, 1984, 2016, 2048, 2112, 2176, 2240, 2304, 2368, 2432, ...
	2496, 2560, 2624, 2688, 2752, 2816, 2880, 2944, 3008, 3072, ...
	3136, 3200, 3264, 3328, 3392, 3456, 3520, 3584, 3648, 3712, ...
	3776, 3840, 3904, 3968, 4032, 4096, 4160, 4224, 4288, 4352, ...
	4416, 4480, 4544, 4608, 4672, 4736, 4800, 4864, 4928, 4992, ...
	5056, 5120, 5184, 5248, 5312, 5376, 5440, 5504, 5568, 5632, ...
	5696, 5760, 5824, 5888, 5952, 6016, 6080, 6144];

SNR_table =[0.5 1 0.3 20];

for i = 1:length(K)

	record = K(i); %index

	sim_param(record).comment = sprintf('RTL test: %d bits, s-maxlogMAP/8it/8bits', K(i));
	sim_param(record).SNR = SNR_table(round(rand(1)*3)+1);
	sim_param(record).framesize = K(i);
	sim_param(record).code_bits_per_frame = sim_param(record).framesize*3+12;
	sim_param(record).channel = 'awgn';
	sim_param(record).decoder_type = 5;
	sim_param(record).num_engines = 8;
	sim_param(record).rtl_simulation = 1;
	sim_param(record).dump_iter = 1;
	sim_param(record).crc_et = 1;
	sim_param(record).crc_type = round(rand(1)); % 0 -- CRC24A, 1 -- CRC24B
	sim_param(record).dump_dir = [cml_home, '/../test'];
	sim_param(record).sldwin_size = 32;
	sim_param(record).fxp_data_width = [8 0 13 0];
	sim_param(record).max_iterations = 8;
	sim_param(record).plot_iterations = sim_param(record).max_iterations;
	sim_param(record).linetype = 'b-';
	sim_param(record).sim_type = 'coded';
	sim_param(record).code_configuration = 1;
	sim_param(record).SNR_type = 'Eb/No in dB';
	sim_param(record).modulation = 'QPSK';
	sim_param(record).mod_order = 4;
	sim_param(record).mapping = 'gray';
	sim_param(record).bicm = 0;
	sim_param(record).demod_type = 0;
	sim_param(record).legend = sim_param(record).comment;
	sim_param(record).code_interleaver = ...
	    strcat( 'CreateLTEInterleaver(', int2str(sim_param(record).framesize ), ')' );
	sim_param(record).g1 = [1 0 1 1;    1 1 0 1];
	sim_param(record).g2 = sim_param(record).g1;
	sim_param(record).nsc_flag1 = 0;
	sim_param(record).nsc_flag2 = 0;
	sim_param(record).pun_pattern1 = [1 1;    1 1];
	sim_param(record).pun_pattern2= [0 0;    1 1 ];
	sim_param(record).tail_pattern1 = [1 1 1;    1 1 1];
	sim_param(record).tail_pattern2 = sim_param(record).tail_pattern1;
	sim_param(record).filename = strcat( data_directory, ...
	    strcat( 'rtl',int2str(K(i)),  int2str(sim_param(record).framesize ), sim_param(record).channel, sim_param(record).modulation, int2str(sim_param(record).mod_order), int2str(sim_param(record).decoder_type), int2str(sim_param(record).max_iterations), '.mat') );
	sim_param(record).reset = 1;
	sim_param(record).max_trials = 1;
	sim_param(record).minBER = 1e-9;
	sim_param(record).max_frame_errors = 40*ones( 1, length(sim_param(record).SNR) );
	sim_param(record).save_rate = ceil(614400/sim_param(record).framesize);
end
