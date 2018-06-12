% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importTrialMarker
% -------------------------------------------------------------------------
% Subject:      Load trial markers
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Marker,btk2] = importTrialMarker(Marker,Event,n0,fMarker)

nMarker = fieldnames(Marker);
[B,A] = butter(4,6/(fMarker/2),'low');
for j = 1:size(nMarker,1)
    % Low pass filter (Butterworth 4nd order, 6 Hz)
    Marker.(nMarker{j}) = filtfilt(B,A,Marker.(nMarker{j}));
    % Keep only cycle data (keep 5 frames before and after first and last
    % event)
    events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
        n0+1;
    Marker.(nMarker{j}) = Marker.(nMarker{j})(events(1)-5:events(end)+5,:);
    % Export BTK markers
    if j == 1
        btk2 = btkNewAcquisition(size(nMarker,1),length(Marker.(nMarker{j})));
        btkSetFrequency(btk2,fMarker);
        btkSetAnalogSampleNumberPerFrame(btk2,1);
    end
    btkSetPoint(btk2,j,Marker.(nMarker{j}));
    btkSetPointLabel(btk2,j,nMarker{j})
    % Convert from mm to m
    Marker.(nMarker{j}) = Marker.(nMarker{j})*10^(-3);
    % Modify the ICS
    Marker.(nMarker{j}) = [Marker.(nMarker{j})(:,1) ...
        Marker.(nMarker{j})(:,3) ...
        -Marker.(nMarker{j})(:,2)];
    % Store Marker as 3-array vectors
    Marker.(nMarker{j}) = permute(Marker.(nMarker{j}),[2,3,1]);
end