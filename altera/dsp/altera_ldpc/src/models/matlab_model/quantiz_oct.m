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


function [indx, quantv, distor] = quantiz_oct(sig, partition, varargin)


% Compute INDX
[nRows, nCols] = size(sig);   % to ensure proper output orientation
indx = zeros(nRows, nCols);
for i = 1 : length(partition)
    indx = indx + (sig > partition(i));
end;

if nargout < 2  % Don't output quantized values
    return
end;

% Compute QUANTV

codebook = varargin{1};

quantv = codebook(indx+1);

if nargout > 2
    % Compute distortion
    distor = 0;
    for i = 0 : length(codebook)-1
        distor = distor + sum((sig(find(indx==i)) - codebook(i+1)).^2);
    end;
    distor = distor / length(sig);
end

% [EOF] - quantiz.m