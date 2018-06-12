% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importTrialReaction
% -------------------------------------------------------------------------
% Subject:      Load trial reaction forces
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Grf,tGrf] = importTrialReaction(Event,Forceplate,tGrf,Grf,n0,n,fMarker,fAnalog)

for j = 1:size(Forceplate,1)
    % Replace NaN by zeros
    temp = tGrf(j).F(:,1); temp(isnan(temp)) = 0; tGrf(j).F(:,1) = temp;
    temp = tGrf(j).F(:,2); temp(isnan(temp)) = 0; tGrf(j).F(:,2) = temp;
    temp = tGrf(j).F(:,3); temp(isnan(temp)) = 0; tGrf(j).F(:,3) = temp;
    temp = tGrf(j).M(:,1); temp(isnan(temp)) = 0; tGrf(j).M(:,1) = temp;
    temp = tGrf(j).M(:,2); temp(isnan(temp)) = 0; tGrf(j).M(:,2) = temp;
    temp = tGrf(j).M(:,3); temp(isnan(temp)) = 0; tGrf(j).M(:,3) = temp;
    temp = Grf(j).F(:,1); temp(isnan(temp)) = 0; Grf(j).F(:,1) = temp;
    temp = Grf(j).F(:,2); temp(isnan(temp)) = 0; Grf(j).F(:,2) = temp;
    temp = Grf(j).F(:,3); temp(isnan(temp)) = 0; Grf(j).F(:,3) = temp;
    temp = Grf(j).M(:,1); temp(isnan(temp)) = 0; Grf(j).M(:,1) = temp;
    temp = Grf(j).M(:,2); temp(isnan(temp)) = 0; Grf(j).M(:,2) = temp;
    temp = Grf(j).M(:,3); temp(isnan(temp)) = 0; Grf(j).M(:,3) = temp;
    % Low pass filter (Butterworth 2nd order, 15 Hz)
    [B,A] = butter(2,15/(fAnalog/2),'low');
    tGrf(j).F(:,1) = filtfilt(B,A,tGrf(j).F(:,1));
    tGrf(j).F(:,2) = filtfilt(B,A,tGrf(j).F(:,2));
    tGrf(j).F(:,3) = filtfilt(B,A,tGrf(j).F(:,3));
    tGrf(j).M(:,1) = filtfilt(B,A,tGrf(j).M(:,1));
    tGrf(j).M(:,2) = filtfilt(B,A,tGrf(j).M(:,2));
    tGrf(j).M(:,3) = filtfilt(B,A,tGrf(j).M(:,3));
    Grf(j).F(:,1) = filtfilt(B,A,Grf(j).F(:,1));
    Grf(j).F(:,2) = filtfilt(B,A,Grf(j).F(:,2));
    Grf(j).F(:,3) = filtfilt(B,A,Grf(j).F(:,3));
    Grf(j).M(:,1) = filtfilt(B,A,Grf(j).M(:,1));
    Grf(j).M(:,2) = filtfilt(B,A,Grf(j).M(:,2));
    Grf(j).M(:,3) = filtfilt(B,A,Grf(j).M(:,3));
    % Apply a 10N threshold
    threshold = 100;
    for k = 1:length(tGrf(j).F)
        if tGrf(j).F(k,3) < threshold; % vertical tGrf threshold
            tGrf(j).P(k,:) = zeros(1,3);
            tGrf(j).F(k,:) = zeros(1,3);
            tGrf(j).M(k,:) = zeros(1,3);
            Grf(j).P(k,:) = zeros(1,3);
            Grf(j).F(k,:) = zeros(1,3);
            Grf(j).M(k,:) = zeros(1,3);
        end
    end
    % Interpolate to number of marker frames
    x = 1:length(Grf(j).F);
    xx = linspace(1,length(Grf(j).F),n);
    temp = tGrf(j).P;
    tGrf(j).P = [];
    tGrf(j).P = (interp1(x,temp,xx,'pchip'))';
    temp = tGrf(j).F;
    tGrf(j).F = [];
    tGrf(j).F = (interp1(x,temp,xx,'pchip'))';
    temp = tGrf(j).M;
    tGrf(j).M = [];
    tGrf(j).M = (interp1(x,temp,xx,'pchip'))';
    temp = Grf(j).P;
    Grf(j).P = [];
    temp = medfilt1(temp); % remove spikes before interpolation
    Grf(j).P = (interp1(x,temp,xx,'pchip'))';
    temp = Grf(j).F;
    Grf(j).F = [];
    temp = medfilt1(temp); % remove spikes before interpolation
    Grf(j).F = (interp1(x,temp,xx,'pchip'))';
    temp = Grf(j).M;
    Grf(j).M = [];
    temp = medfilt1(temp); % remove spikes before interpolation
    Grf(j).M = (interp1(x,temp,xx,'pchip'))';
    % Keep only cycle data (keep 5 frames before and after first and last
    % event)
    events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
        n0+1;
    tGrf(j).F = tGrf(j).F(:,events(1)-5:events(end)+5)';
    tGrf(j).M = tGrf(j).M(:,events(1)-5:events(end)+5)';
    tGrf(j).P = tGrf(j).P(:,events(1)-5:events(end)+5)';
    Grf(j).F = Grf(j).F(:,events(1)-5:events(end)+5)';
    Grf(j).M = Grf(j).M(:,events(1)-5:events(end)+5)';
    Grf(j).P = Grf(j).P(:,events(1)-5:events(end)+5)';
    % Additional treatments for Matlab process
    Grf(j).M = Grf(j).M*10^(-3); % Convert from Nmm to Nm
    Grf(j).P = Grf(j).P*10^(-3);
    Grf(j).P = [Grf(j).P(:,1) Grf(j).P(:,3) -Grf(j).P(:,2)]; % Modify the ICS
    Grf(j).F = [Grf(j).F(:,1) Grf(j).F(:,3) -Grf(j).F(:,2)];
    Grf(j).M = [zeros(size(Grf(j).M(:,3))) -Grf(j).M(:,3) zeros(size(Grf(j).M(:,3)))];
    Grf(j).P = permute(Grf(j).P,[2,3,1]); % Store as 3-array vectors
    Grf(j).F = permute(Grf(j).F,[2,3,1]);
    Grf(j).M = permute(Grf(j).M,[2,3,1]);
end