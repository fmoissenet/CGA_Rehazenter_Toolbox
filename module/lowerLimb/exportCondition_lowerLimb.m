% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportCondition_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Export .mat file for each condition with only intra cycle
%               data of each outcome
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Output = exportCondition_lowerLimb(Output,Segment,Joint,Marker,Vmarker,EMG,Event,Spatiotemporal,fMarker)

Event.RHS = fix(Event.RHS*fMarker);
Event.RTO = fix(Event.RTO*fMarker);
Event.LHS = fix(Event.LHS*fMarker);
Event.LTO = fix(Event.LTO*fMarker);

% =========================================================================
% Spatiotemporal
% =========================================================================
nSpatiotemporal = fieldnames(Spatiotemporal);
for i = 1:size(nSpatiotemporal,1)
    Output.Spatiotemporal.(nSpatiotemporal{i}) = Spatiotemporal.(nSpatiotemporal{i});
end

% =========================================================================
% RIGHT SIDE
% =========================================================================
R_n = Event.RHS(2)-Event.RHS(1)+1;
R_k = (1:R_n)';
R_ko = (linspace(1,R_n,101))';

% -------------------------------------------------------------------------
% Marker
% -------------------------------------------------------------------------
nMarker = fieldnames(Marker);
for i = 1:size(nMarker,1)
    temp = permute(Marker.(nMarker{i})(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
    Output.Rside.Marker.(nMarker{i}) = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
end

% -------------------------------------------------------------------------
% Vmarker
% -------------------------------------------------------------------------
nVmarker = fieldnames(Vmarker);
for i = 1:size(nVmarker,1)
    temp = permute(Vmarker.(nVmarker{i})(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
    Output.Rside.Vmarker.(nVmarker{i}) = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
end

% -------------------------------------------------------------------------
% EMG
% -------------------------------------------------------------------------
nEMG = fieldnames(EMG);
for i = 1:size(nEMG,1)
    temp = permute(EMG.(nEMG{i}).signal(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.Rside.EMG.(nEMG{i}).signal = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
    else
        Output.Rside.EMG.(nEMG{i}).signal = NaN(1,1,101);
    end
    temp = permute(EMG.(nEMG{i}).envelop(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.Rside.EMG.(nEMG{i}).envelop = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
    else
        Output.Rside.EMG.(nEMG{i}).envelop = NaN(1,1,101);
    end
end

% -------------------------------------------------------------------------
% Segment
% -------------------------------------------------------------------------
nSegment = fieldnames(Segment);
for i = 1:5
    for j = 1:size(nSegment,1)
        if size(Segment(i).(nSegment{j}),3) > 1
            temp = permute(Segment(i).(nSegment{j})(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
            if sum(isnan(temp)) ~= size(isnan(temp),1)
                Output.Rside.Segment(i).(nSegment{j}) = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
            else
                Output.Rside.Segment(i).(nSegment{j}) = NaN(1,1,101);
            end
        else
            Output.Rside.Segment(i).(nSegment{j}) = Segment(i).(nSegment{j});
        end
    end
end

% -------------------------------------------------------------------------
% Joint
% -------------------------------------------------------------------------
nJoint = fieldnames(Joint);
for i = 1:4
    for j = 1:size(nJoint,1)
        if size(Joint(i).(nJoint{j}),3) > 1
            temp = permute(Joint(i).(nJoint{j})(:,:,Event.RHS(1):Event.RHS(2)),[3,1,2]);
            if sum(isnan(temp)) ~= size(isnan(temp),1)
                Output.Rside.Joint(i).(nJoint{j}) = permute(interp1(R_k,temp,R_ko,'spline'),[2,3,1]);
            else
                Output.Rside.Joint(i).(nJoint{j}) = NaN(1,1,101);
            end
        else
            Output.Rside.Joint(i).(nJoint{j}) = Joint(i).(nJoint{j});
        end
    end
end

% -------------------------------------------------------------------------
% Event
% -------------------------------------------------------------------------
Output.Rside.Event.RHS = (Event.RHS-Event.RHS(1))*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Rside.Event.RTO = (Event.RTO-Event.RHS(1))*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Rside.Event.LHS = (Event.LHS-Event.RHS(1))*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Rside.Event.LTO = (Event.LTO-Event.RHS(1))*100/(Event.RHS(2)-Event.RHS(1)+1);

% =========================================================================
% LEFT SIDE
% =========================================================================
L_n = Event.LHS(2)-Event.LHS(1)+1;
L_k = (1:L_n)';
L_ko = (linspace(1,L_n,101))';

% -------------------------------------------------------------------------
% Marker
% -------------------------------------------------------------------------
nMarker = fieldnames(Marker);
for i = 1:size(nMarker,1)
    temp = permute(Marker.(nMarker{i})(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
    Output.Lside.Marker.(nMarker{i}) = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
end

% -------------------------------------------------------------------------
% Vmarker
% -------------------------------------------------------------------------
nVmarker = fieldnames(Vmarker);
for i = 1:size(nVmarker,1)
    temp = permute(Vmarker.(nVmarker{i})(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
    Output.Lside.Vmarker.(nVmarker{i}) = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
end

% -------------------------------------------------------------------------
% EMG
% -------------------------------------------------------------------------
nEMG = fieldnames(EMG);
for i = 1:size(nEMG,1)
    temp = permute(EMG.(nEMG{i}).signal(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.Lside.EMG.(nEMG{i}).signal = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
    else
        Output.Lside.EMG.(nEMG{i}).signal = NaN(1,1,101);
    end
    temp = permute(EMG.(nEMG{i}).envelop(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.Lside.EMG.(nEMG{i}).envelop = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
    else
        Output.Lside.EMG.(nEMG{i}).envelop = NaN(1,1,101);
    end
end

% -------------------------------------------------------------------------
% Segment
% -------------------------------------------------------------------------
nSegment = fieldnames(Segment);
for i = 101:105
    for j = 1:size(nSegment,1)
        if size(Segment(i).(nSegment{j}),3) > 1
            temp = permute(Segment(i).(nSegment{j})(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
            if sum(isnan(temp)) ~= size(isnan(temp),1)
                Output.Lside.Segment(i).(nSegment{j}) = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
            else
                Output.Lside.Segment(i).(nSegment{j}) = NaN(1,1,101);
            end
        else
            Output.Lside.Segment(i).(nSegment{j}) = Segment(i).(nSegment{j});
        end
    end
end

% -------------------------------------------------------------------------
% Joint
% -------------------------------------------------------------------------
nJoint = fieldnames(Joint);
for i = 101:104
    for j = 1:size(nJoint,1)
        if size(Joint(i).(nJoint{j}),3) > 1
            temp = permute(Joint(i).(nJoint{j})(:,:,Event.LHS(1):Event.LHS(2)),[3,1,2]);
            if sum(isnan(temp)) ~= size(isnan(temp),1)
                Output.Lside.Joint(i).(nJoint{j}) = permute(interp1(L_k,temp,L_ko,'spline'),[2,3,1]);
            else
                Output.Lside.Joint(i).(nJoint{j}) = NaN(1,1,101);
            end
        else
            Output.Lside.Joint(i).(nJoint{j}) = Joint(i).(nJoint{j});
        end
    end
end

% -------------------------------------------------------------------------
% Event
% -------------------------------------------------------------------------
Output.Lside.Event.RHS = (Event.RHS-Event.LHS(1))*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lside.Event.RTO = (Event.RTO-Event.LHS(1))*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lside.Event.LHS = (Event.LHS-Event.LHS(1))*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lside.Event.LTO = (Event.LTO-Event.LHS(1))*100/(Event.LHS(2)-Event.LHS(1)+1);