% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeSpatiotemporal_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute spatiotemporal parameters based on marker traj.
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Spatiotemporal,btk2] = ...
    computeSpatiotemporal_lowerLimb(Session,Vmarker,Event,fMarker,fAnalog,btk2)

% =========================================================================
% Initialisation
% =========================================================================
Spatiotemporal.R_Stance_Phase = [];                                        % % of gait cycle
Spatiotemporal.R_Swing_Phase = [];                                         % % of gait cycle
Spatiotemporal.R_Double_Support1 = [];                                     % % of gait cycle     
Spatiotemporal.R_Double_Support2 = [];                                     % % of gait cycle
Spatiotemporal.R_Single_Support = [];                                      % % of gait cycle
Spatiotemporal.R_Stride_Length = [];                                       % m
Spatiotemporal.R_Step_Length = [];                                         % m
Spatiotemporal.R_Gait_Cycle = [];                                          % s
Spatiotemporal.L_Stance_Phase = [];
Spatiotemporal.L_Swing_Phase = [];
Spatiotemporal.L_Single_Support = [];
Spatiotemporal.L_Double_Support1 = [];
Spatiotemporal.L_Double_Support2 = [];
Spatiotemporal.L_Stride_Length = [];
Spatiotemporal.L_Step_Length = [];
Spatiotemporal.L_Gait_Cycle = [];
Spatiotemporal.Stride_Width = [];                                          % m
Spatiotemporal.Cadence = [];                                               % step/min
Spatiotemporal.Velocity = [];                                              % m/s
Spatiotemporal.Velocity_Adim = [];                                         % adimensioned
e = Event;
Event.RHS = fix(Event.RHS*fMarker);
Event.RTO = fix(Event.RTO*fMarker);
Event.LHS = fix(Event.LHS*fMarker);
Event.LTO = fix(Event.LTO*fMarker);

% =========================================================================
% Phases
% =========================================================================
if Event.LHS(1) < Event.RHS(1)
    Spatiotemporal.R_Stance_Phase = (Event.RTO(2) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Stance_Phase = (Event.LTO(1) - Event.LHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_Swing_Phase = (Event.RHS(2) - Event.RTO(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Swing_Phase = (Event.LHS(2) - Event.LTO(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_Double_Support1 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_Double_Support2 = (Event.RTO(2) - Event.LHS(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_Single_Support = 100-Spatiotemporal.R_Double_Support1-...
        Spatiotemporal.R_Double_Support2;
    Spatiotemporal.L_Double_Support1 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Double_Support2 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.L_Single_Support = 100-Spatiotemporal.L_Double_Support1-...
        Spatiotemporal.L_Double_Support2;
elseif Event.LHS(1) > Event.RHS(1)
    Spatiotemporal.R_Stance_Phase = (Event.RTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Stance_Phase = (Event.LTO(2) - Event.LHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_Swing_Phase = (Event.RHS(2) - Event.RTO(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Swing_Phase = (Event.LHS(2) - Event.LTO(2)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_Double_Support1 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_Double_Support2 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_Single_Support = 100-Spatiotemporal.R_Double_Support1-...
        Spatiotemporal.R_Double_Support2;
    Spatiotemporal.L_Double_Support1 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Double_Support2 = (Event.LTO(2) - Event.RHS(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_Single_Support = 100-Spatiotemporal.L_Double_Support1-...
        Spatiotemporal.L_Double_Support2;
end

% =========================================================================
% Distance parameters
% =========================================================================
Spatiotemporal.R_Stride_Length = abs(Vmarker.R_AJC(1,:,Event.RHS(2)) - ...
    Vmarker.R_AJC(1,:,Event.RHS(1)));
Spatiotemporal.L_Stride_Length = abs(Vmarker.L_AJC(1,:,Event.LHS(2)) - ...
    Vmarker.L_AJC(1,:,Event.LHS(1)));
if Event.LHS(1) < Event.RHS(1)
    Spatiotemporal.R_Step_Length = abs(Vmarker.R_AJC(1,:,Event.RHS(1)) - ...
        Vmarker.L_AJC(1,:,Event.LHS(1)));
    Spatiotemporal.L_Step_Length = abs(Vmarker.L_AJC(1,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(1,:,Event.RHS(1)));
    Spatiotemporal.Stride_Width = mean([abs(Vmarker.R_AJC(3,:,Event.RHS(1)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.R_AJC(3,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(1)))]);
elseif Event.LHS(1) > Event.RHS(1)
    Spatiotemporal.R_Step_Length = abs(Vmarker.R_AJC(1,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(1,:,Event.LHS(1)));
    Spatiotemporal.L_Step_Length = abs(Vmarker.L_AJC(1,:,Event.LHS(1)) - ...
        Vmarker.R_AJC(1,:,Event.RHS(1)));
    Spatiotemporal.Stride_Width = mean([abs(Vmarker.R_AJC(3,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(1)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(2)))]);
end

% =========================================================================
% Cadence, walking speed
% =========================================================================
Spatiotemporal.R_Gait_Cycle = (e.RHS(2) - e.RHS(1));
Spatiotemporal.L_Gait_Cycle = (e.LHS(2) - e.LHS(1));
Spatiotemporal.Cadence = mean([(1/Spatiotemporal.R_Gait_Cycle),...
    (1/Spatiotemporal.L_Gait_Cycle)])*60*2;
Spatiotemporal.Velocity = mean([...
    Spatiotemporal.Cadence*Spatiotemporal.R_Stride_Length, ...
    Spatiotemporal.Cadence*Spatiotemporal.L_Stride_Length])/(60*2);
Spatiotemporal.Velocity_Adim = Spatiotemporal.Velocity/...
    sqrt(9.81*mean([Session.R_legLength,Session.L_legLength]));

% =========================================================================
% Export as metadata in C3D
% =========================================================================
nSpatiotemporal = fieldnames(Spatiotemporal);
info.format = 'Integer';
info.values = length(nSpatiotemporal);
btkAppendMetaData(btk2,'SPATIOTEMPORAL_PARAM','USED',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',length(nSpatiotemporal)];
for i = 1:length(nSpatiotemporal)
    info.values(i) = {nSpatiotemporal{i}};
end
btkAppendMetaData(btk2,'SPATIOTEMPORAL_PARAM','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',length(nSpatiotemporal)];
info.values = {'% of gait cycle' '% of gait cycle' '% of gait cycle' ...
    '% of gait cycle' '% of gait cycle' 'm' 'm' 's' ...
    '% of gait cycle' '% of gait cycle' '% of gait cycle' ...
    '% of gait cycle' '% of gait cycle' 'm' 'm' 's' ...
    'm' 'step/min' 'm/s' 'adimensioned (Hof 1996)'};
btkAppendMetaData(btk2,'SPATIOTEMPORAL_PARAM','UNITS',info);
clear info;
info.format = 'Real';
info.dimensions = ['1x',length(nSpatiotemporal)];
for i = 1:length(nSpatiotemporal)
    info.values(i) = Spatiotemporal.(nSpatiotemporal{i});
end
btkAppendMetaData(btk2,'SPATIOTEMPORAL_PARAM','VALUES',info);