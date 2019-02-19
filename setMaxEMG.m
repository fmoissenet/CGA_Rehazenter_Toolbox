% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setMaxEMG
% -------------------------------------------------------------------------
% Subject:      Load trial EMG signals
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function MaxEMG = setMaxEMG(Session,Analog,MaxEMG,n,fAnalog)

nAnalog = fieldnames(Analog);
for j = 1:length(nAnalog)
    if ~isempty(strfind(nAnalog{j},'EMG_')) || ...
       ~isempty(strfind(nAnalog{j},'Right_')) || ...
       ~isempty(strfind(nAnalog{j},'Left_'))
        % Rebase (remove signal mean)
        temp = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        % Band-pass filter (Butterworth 2nd order, 30-300 Hz)
        [B,A] = butter(2,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
        temp = filtfilt(B, A, temp);
        % Rectification (absolute value of the signal)
        temp = abs(temp);
        % Low pass filter (Butterworth 2nd order, 30-300 Hz)
        [B,A] = butter(2,25/(fAnalog/2),'low');
        temp = filtfilt(B, A, temp);
        % Interpolate to number of marker frames
        x = 1:length(temp);
        xx = linspace(1,length(temp),n);
        temp2 = temp;
        temp3 = [];
        temp3 = (interp1(x,temp2,xx,'spline'))';
        % Max value
        if ~isempty(MaxEMG)
            if isfield(MaxEMG,nAnalog{j})
                MaxEMG.(nAnalog{j}).data = [MaxEMG.(nAnalog{j}).data; temp3];
            else
                MaxEMG.(nAnalog{j}).data = temp3;
            end
        else
            MaxEMG.(nAnalog{j}).data = temp3;
        end
    end
end
% Rename fields with muscle names
nMaxEMG = fieldnames(MaxEMG);
for i = 1:16
    if ~strcmp(Session.EMG{i},'none')
        MaxEMG.(Session.EMG{i}).data = MaxEMG.(nMaxEMG{i}).data;
        MaxEMG = rmfield(MaxEMG,nMaxEMG{i});
    end
end