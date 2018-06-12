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
    computeSpatiotemporal_lowerLimb(Session,Vmarker,Event,fMarker,btk2)

% =========================================================================
% Initialisation
% =========================================================================
Spatiotemporal.R_stancePhase = [];                                         % % of gait cycle
Spatiotemporal.R_swingPhase = [];                                          % % of gait cycle
Spatiotemporal.R_doubleSupport1 = [];                                      % % of gait cycle     
Spatiotemporal.R_doubleSupport2 = [];                                      % % of gait cycle
Spatiotemporal.R_singleSupport = [];                                       % % of gait cycle
Spatiotemporal.R_strideLength = [];                                        % m
Spatiotemporal.R_stepLength = [];                                          % m
Spatiotemporal.R_gaitCycle = [];                                           % s
Spatiotemporal.L_stancePhase = [];
Spatiotemporal.L_swingPhase = [];
Spatiotemporal.L_singleSupport = [];
Spatiotemporal.L_doubleSupport1 = [];
Spatiotemporal.L_doubleSupport2 = [];
Spatiotemporal.L_strideLength = [];
Spatiotemporal.L_stepLength = [];
Spatiotemporal.L_gaitCycle = [];
Spatiotemporal.strideWidth = [];                                           % m
Spatiotemporal.cadence = [];                                               % step/min
Spatiotemporal.velocity = [];                                              % m/s
Spatiotemporal.velocityAdim = [];                                          % adimensioned
e = Event;
Event.RHS = fix(Event.RHS*fMarker);
Event.RTO = fix(Event.RTO*fMarker);
Event.LHS = fix(Event.LHS*fMarker);
Event.LTO = fix(Event.LTO*fMarker);

% =========================================================================
% Phases
% =========================================================================
if Event.LHS(1) < Event.RHS(1)
    Spatiotemporal.R_stancePhase = (Event.RTO(2) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_stancePhase = (Event.LTO(1) - Event.LHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_swingPhase = (Event.RHS(2) - Event.RTO(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_swingPhase = (Event.LHS(2) - Event.LTO(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_doubleSupport1 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_doubleSupport2 = (Event.RTO(2) - Event.LHS(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_singleSupport = 100-Spatiotemporal.R_doubleSupport1-...
        Spatiotemporal.R_doubleSupport2;
    Spatiotemporal.L_doubleSupport1 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_doubleSupport2 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.L_singleSupport = 100-Spatiotemporal.L_doubleSupport1-...
        Spatiotemporal.L_doubleSupport2;
elseif Event.LHS(1) > Event.RHS(1)
    Spatiotemporal.R_stancePhase = (Event.RTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_stancePhase = (Event.LTO(2) - Event.LHS(1)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_swingPhase = (Event.RHS(2) - Event.RTO(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_swingPhase = (Event.LHS(2) - Event.LTO(2)) ...
        * 100/(Event.LHS(2) - Event.LHS(1));
    Spatiotemporal.R_doubleSupport1 = (Event.LTO(1) - Event.RHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_doubleSupport2 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.R_singleSupport = 100-Spatiotemporal.R_doubleSupport1-...
        Spatiotemporal.R_doubleSupport2;
    Spatiotemporal.L_doubleSupport1 = (Event.RTO(1) - Event.LHS(1)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_doubleSupport2 = (Event.LTO(2) - Event.RHS(2)) ...
        * 100/(Event.RHS(2) - Event.RHS(1));
    Spatiotemporal.L_singleSupport = 100-Spatiotemporal.L_doubleSupport1-...
        Spatiotemporal.L_doubleSupport2;
end

% =========================================================================
% Distance parameters
% =========================================================================
Spatiotemporal.R_strideLength = Vmarker.R_AJC(1,:,Event.RHS(2)) - ...
    Vmarker.R_AJC(1,:,Event.RHS(1));
Spatiotemporal.L_strideLength = Vmarker.L_AJC(1,:,Event.LHS(2)) - ...
    Vmarker.L_AJC(1,:,Event.LHS(1));
if Event.LHS(1) < Event.RHS(1)
    Spatiotemporal.R_stepLength = Vmarker.R_AJC(1,:,Event.RHS(1)) - ...
        Vmarker.L_AJC(1,:,Event.LHS(1));
    Spatiotemporal.L_stepLength = Vmarker.L_AJC(1,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(1,:,Event.RHS(1));
    Spatiotemporal.strideWidth = mean([abs(Vmarker.R_AJC(3,:,Event.RHS(1)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.R_AJC(3,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(1)))]);
elseif Event.LHS(1) > Event.RHS(1)
    Spatiotemporal.R_stepLength = Vmarker.R_AJC(1,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(1,:,Event.LHS(1));
    Spatiotemporal.L_stepLength = Vmarker.L_AJC(1,:,Event.LHS(1)) - ...
        Vmarker.R_AJC(1,:,Event.RHS(1));
    Spatiotemporal.strideWidth = mean([abs(Vmarker.R_AJC(3,:,Event.RHS(2)) - ...
        Vmarker.L_AJC(3,:,Event.LHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(1)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(1))),abs(Vmarker.L_AJC(3,:,Event.LHS(2)) - ...
        Vmarker.R_AJC(3,:,Event.RHS(2)))]);
end

% =========================================================================
% Cadence, walking speed
% =========================================================================
Spatiotemporal.R_gaitCycle = (e.RHS(2) - e.RHS(1));
Spatiotemporal.L_gaitCycle = (e.LHS(2) - e.LHS(1));
Spatiotemporal.cadence = mean([(1/Spatiotemporal.R_gaitCycle),...
    (1/Spatiotemporal.L_gaitCycle)])*60*2;
Spatiotemporal.velocity = mean([...
    Spatiotemporal.cadence*Spatiotemporal.R_strideLength, ...
    Spatiotemporal.cadence*Spatiotemporal.L_strideLength])/(60*2);
Spatiotemporal.velocityAdim = Spatiotemporal.velocity/...
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