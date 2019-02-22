% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeAverage_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute mean and std for lower limb data
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 21/02/2019
% Version: 1
% =========================================================================

function Condition = computeAverage_lowerLimb(Condition,i)

% Get fields
nSpatiotemporal = fieldnames(Condition(i).Trial(1).LowerLimb.Spatiotemporal);
nJointkinematics = fieldnames(Condition(i).Trial(1).LowerLimb.Jointkinematics);
nSegmentkinematics = fieldnames(Condition(i).Trial(1).LowerLimb.Segmentkinematics);
nDynamics = fieldnames(Condition(i).Trial(1).LowerLimb.Dynamics);
nEMG = fieldnames(Condition(i).Trial(1).LowerLimb.EMG);
nEvents = fieldnames(Condition(i).Trial(1).LowerLimb.Events);
% Merge data
for nField = 1:length(nSpatiotemporal)
    tSpatiotemporal = [];
    for nTrial = 1:size(Condition(i).Trial,2)
        tSpatiotemporal = [tSpatiotemporal Condition(i).Trial(nTrial).LowerLimb.Spatiotemporal.(nSpatiotemporal{nField})];
    end
    Condition(i).Average.LowerLimb.Spatiotemporal.(nSpatiotemporal{nField}).mean = nanmean(tSpatiotemporal);
    Condition(i).Average.LowerLimb.Spatiotemporal.(nSpatiotemporal{nField}).std = nanstd(tSpatiotemporal);
end
for nField = 1:length(nJointkinematics)
    tJointkinematics = [];
    for nTrial = 1:size(Condition(i).Trial,2)
        tJointkinematics = [tJointkinematics Condition(i).Trial(nTrial).LowerLimb.Jointkinematics.(nJointkinematics{nField})];
    end
    Condition(i).Average.LowerLimb.Jointkinematics.(nJointkinematics{nField}).mean = nanmean(tJointkinematics,2);
    Condition(i).Average.LowerLimb.Jointkinematics.(nJointkinematics{nField}).std = nanstd(tJointkinematics,1,2);
end
for nField = 1:length(nSegmentkinematics)
    tSegmentkinematics = [];
    for nTrial = 1:size(Condition(i).Trial,2)
        tSegmentkinematics = [tSegmentkinematics Condition(i).Trial(nTrial).LowerLimb.Segmentkinematics.(nSegmentkinematics{nField})];
    end
    Condition(i).Average.LowerLimb.Segmentkinematics.(nSegmentkinematics{nField}).mean = nanmean(tSegmentkinematics,2);
    Condition(i).Average.LowerLimb.Segmentkinematics.(nSegmentkinematics{nField}).std = nanstd(tSegmentkinematics,1,2);
end
for nField = 1:length(nDynamics)
    tDynamics = [];
    for nTrial = 1:size(Condition(i).Trial,2)
        tDynamics = [tDynamics Condition(i).Trial(nTrial).LowerLimb.Dynamics.(nDynamics{nField})];
    end
    Condition(i).Average.LowerLimb.Dynamics.(nDynamics{nField}).mean = nanmean(tDynamics,2);
    Condition(i).Average.LowerLimb.Dynamics.(nDynamics{nField}).std = nanstd(tDynamics,1,2);
end
for nField = 1:length(nEMG)
    tEMG = [];
    for nTrial = 1:size(Condition(i).Trial,2)
        if strfind(nEMG{nField},'Envelop') % only for envelops normalised as % of gait cycle
            tEMG = [tEMG Condition(i).Trial(nTrial).LowerLimb.EMG.(nEMG{nField})];
        end
    end
    Condition(i).Average.LowerLimb.EMG.(nEMG{nField}).mean = nanmean(tEMG,2);
    Condition(i).Average.LowerLimb.EMG.(nEMG{nField}).std = nanstd(tEMG,1,2);
end
for nField = 1:length(nEvents)
    tEvents = [];
    if ~isempty(strfind(nEvents{nField},'RTO')) || ~isempty(strfind(nEvents{nField},'LTO'))
        for nTrial = 1:size(Condition(i).Trial,2)
            tEvents = [tEvents Condition(i).Trial(nTrial).LowerLimb.Events.(nEvents{nField})(end)];
        end
        Condition(i).Average.LowerLimb.Events.(nEvents{nField}).mean = fix(nanmean(tEvents));
        Condition(i).Average.LowerLimb.Events.(nEvents{nField}).std = fix(nanstd(tEvents));
    end
end