% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importTrialEMG
% -------------------------------------------------------------------------
% Subject:      Load trial EMG signals
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [EMG,btk2] = importTrialEMG(Session,Analog,Event,MaxEMG,btk2,n0,n,fMarker,fAnalog)

% =========================================================================
% EMG signal (only band-pass filter)
% =========================================================================
nAnalog = fieldnames(Analog);
for j = 1:length(nAnalog)
    if strfind(nAnalog{j},'EMG_')%strfind(nAnalog{j},'Right_')
        % Rebase (remove signal mean)
        Analog2.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
        % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
        [B,A] = butter(4,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
        Analog2.(nAnalog{j}) = filtfilt(B, A, Analog2.(nAnalog{j}));
%         % Interpolate to number of marker frames
%         x = 1:length(Analog2.(nAnalog{j}));
%         xx = linspace(1,length(Analog2.(nAnalog{j})),n);
%         temp = Analog2.(nAnalog{j});
%         Analog2.(nAnalog{j}) = [];
%         Analog2.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
        % Keep only cycle data (keep 5 frames before and after first and last
        % event)
        events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
            n0+1;
        % Zeroing of low signals
        temp = size(Analog2.(nAnalog{j})...
                ((events(1))*fAnalog/fMarker:(events(end))*fAnalog/fMarker,:),1);
        extra = (btkGetAnalogFrameNumber(btk2) - temp)/2;
        if max(Analog2.(nAnalog{j})) > 1e-6
            Analog2.(nAnalog{j}) = Analog2.(nAnalog{j})...
                (events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:);
        else
            Analog2.(nAnalog{j}) = NaN(size(Analog2.(nAnalog{j})...
                (events(1)*fAnalog/fMarker-extra:events(end)*fAnalog/fMarker+extra,:)));
        end
    end
end
% Export EMG signals (manage if a channel as been removed in the hardware
% for maintenance reasons)
nAnalog2 = fieldnames(Analog2);
for i = 9:length(nAnalog2)%1:length(nAnalog2)
%     for j = 9:16
%         if strcmp(nAnalog2{i},['Right_',num2str(j)])
%             if ~strcmp(Session.EMG{j},'none')
                btkAppendAnalog(btk2,Session.EMG{i},...%btkAppendAnalog(btk2,Session.EMG{i+8},...
                    Analog2.(nAnalog2{i}),'EMG signal (V)');
                EMG.(Session.EMG{i}).signal = permute(Analog2.(nAnalog2{i}),[2,3,1]);%EMG.(Session.EMG{i+8}).signal = permute(Analog2.(nAnalog2{i}),[2,3,1]);
%             end
%         end
%     end
end

% =========================================================================
% EMG envelop
% =========================================================================
% nAnalog = fieldnames(Analog);
% for j = 1:length(nAnalog)
%     if strfind(nAnalog{j},'EMG_')
%         % Rebase (remove signal mean)
%         Analog.(nAnalog{j}) = Analog.(nAnalog{j}) - mean(Analog.(nAnalog{j}));
%         % Band-pass filter (Butterworth 4nd order, 30-300 Hz)
%         [B,A] = butter(4,[30/(fAnalog/2) 300/(fAnalog/2)],'bandpass');
%         Analog.(nAnalog{j}) = filtfilt(B, A, Analog.(nAnalog{j}));
%         % Rectification (absolute value of the signal)
%         Analog.(nAnalog{j}) = abs(Analog.(nAnalog{j}));
%         % Low pass filter (Butterworth 2nd order, 50 Hz)
%         [B,A] = butter(2,50/(fAnalog/2),'low');
%         Analog.(nAnalog{j}) = filtfilt(B, A, Analog.(nAnalog{j}));
%         % Interpolate to number of marker frames
%         x = 1:length(Analog.(nAnalog{j}));
%         xx = linspace(1,length(Analog.(nAnalog{j})),n);
%         temp = Analog.(nAnalog{j});
%         Analog.(nAnalog{j}) = [];
%         Analog.(nAnalog{j}) = (interp1(x,temp,xx,'spline'))';
%         % Keep only cycle data (keep 5 frames before and after first and last
%         % event)
%         events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
%             n0+1;
%         if max(Analog.(nAnalog{j})) > 1e-6
%             Analog.(nAnalog{j}) = Analog.(nAnalog{j})...
%                 (events(1)-5:events(end)+5,:);
%         else
%             Analog.(nAnalog{j}) = NaN(size(Analog.(nAnalog{j})...
%                 (events(1)-5:events(end)+5,:)));
%         end
%     end
% end
% % Normalise by condition max and export EMG signals (manage if a channel as
% % been removed in the hardware for maintenance reasons)
% nAnalog2 = fieldnames(Analog2);
% for i = 1:length(nAnalog2)
%     for j = 1:16
%         if strcmp(nAnalog2{i},['EMG_',num2str(j)])
%             if ~strcmp(Session.EMG{j},'none')
%                 btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
%                 btkSetPointType(btk2,btkGetPointNumber(btk2),'scalar');
%                 btkSetPoint(btk2,btkGetPointNumber(btk2),...
%                     [Analog.(nAnalog2{i})/max(Analog.(nAnalog2{i})) ...
%                     zeros(size(Analog.(nAnalog2{i}))) ...
%                     zeros(size(Analog.(nAnalog2{i})))]);
%                 btkSetPointLabel(btk2,btkGetPointNumber(btk2),Session.EMG{j});
%                 btkSetPointDescription(btk2,btkGetPointNumber(btk2),'EMG envelop normalised by condition max');
%                 EMG.(Session.EMG{j}).envelop = ...
%                     permute(Analog.(nAnalog2{i}),[2,3,1])/MaxEMG.(Session.EMG{j}).max;
%             end
%         end
%     end
% end