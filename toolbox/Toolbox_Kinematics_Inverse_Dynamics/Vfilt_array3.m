% FUNCTION
% Vfilt_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Filtering of vector 
%
% SYNOPSIS
% Vf = Vfilt_array3(V,f,fc)
%
% INPUT
% V (i.e., vector) 
% f (i.e., sampling frequency)
% fc (i.e., cut off frequency)
%
% OUTPUT
% Vf (i.e., vector)
%
% DESCRIPTION
% Filtering, along with the 3rd dimension (i.e., all frames, cf. data
% structure in user guide), of the vector components by a 4th order
% Butterworth
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% None
% 
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%
% Modified by Raphaël Dumas
% September 2012
% Filtering line by line (any number of line)
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________
%
% NOTE
% For Matlab user without Signal Processing Toolbox, butter.m can be 
% replaced by myButter.m  
% www.mathworks.com/matlabcentral/answers/137778-
%           butterworth-lowpass-filtering-without-signal-processing-toolbox
%__________________________________________________________________________


function Vf = Vfilt_array3(V,f,fc)

% Butterworth
% [af,bf] = butter(4,fc./(f/2)); % With Signal Processing Toolbox
[af,bf] = myButter(4,fc./(f/2),'low');

% Initialisation
Vf = [];
% Filtering line by line
for c = 1:size(V,1)
    Vc = filtfilt(af,bf,permute(V(c,1,:),[3,1,2]));
    Vf = [Vf;permute(Vc,[3,2,1])];
end

% Subfunction
function [Z, P, G] = myButter(n, W, pass)
% Digital Butterworth filter, either 2 or 3 outputs
% Jan Simon, 2014, BSD licence
% See docs of BUTTER for input and output
% Fast hack with limited accuracy: Handle with care!
% Until n=15 the relative difference to Matlab's BUTTER is < 100*eps

V = tan(W * 1.5707963267948966);
Q = exp((1.5707963267948966i / n) * ((2 + n - 1):2:(3 * n - 1)));

nQ = length(Q);
switch lower(pass)
   case 'stop'
      Sg = 1 / prod(-Q);
      c  = -V(1) * V(2);
      b  = (V(2) - V(1)) * 0.5 ./ Q;
      d  = sqrt(b .* b + c);
      Sp = [b + d, b - d];
      Sz = sqrt(c) * (-1) .^ (0:2 * nQ - 1);
   case 'bandpass'
      Sg = (V(2) - V(1)) ^ nQ;
      b  = (V(2) - V(1)) * 0.5 * Q;
      d  = sqrt(b .* b - V(1) * V(2));
      Sp = [b + d, b - d];
      Sz = zeros(1, nQ);
   case 'high'
      Sg = 1 ./ prod(-Q);
      Sp = V ./ Q;
      Sz = zeros(1, nQ);
   case 'low'
      Sg = V ^ nQ;
      Sp = V * Q;
      Sz = [];
   otherwise
      error('user:myButter:badFilter', 'Unknown filter type: %s', pass)
end

% Bilinear transform:
P = (1 + Sp) ./ (1 - Sp);
Z = repmat(-1, size(P));
if isempty(Sz)
   G = real(Sg / prod(1 - Sp));
else
   G = real(Sg * prod(1 - Sz) / prod(1 - Sp));
   Z(1:length(Sz)) = (1 + Sz) ./ (1 - Sz);
end

% From Zeros, Poles and Gain to B (numerator) and A (denominator):
if nargout == 2
   Z = G * real(poly(Z'));
   P = real(poly(P));
end
