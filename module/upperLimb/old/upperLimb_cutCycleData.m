% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_cutCycleData
% -------------------------------------------------------------------------
% Subject:      Extract the gait cycle from the trial 
% -------------------------------------------------------------------------
% Inputs:       - Condition (structure)
%               - Marker (structure)
%               - side (char)
%               - nGait (int)
% Outputs:      - Emg (structure)
%               - n1 (int)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 29/11/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Marker,n1] = upperLimb_cutCycleData(Condition,Marker,side,nGait)

% =========================================================================
% Define start and stop frames
% =========================================================================
if strcmp(side,'Right')
    start = Condition.Gait(nGait).Treatment.Event.RHS(1);
    stop = Condition.Gait(nGait).Treatment.Event.RHS(2);
elseif strcmp(side,'Left')
    start = Condition.Gait(nGait).Treatment.Event.LHS(1);
    stop = Condition.Gait(nGait).Treatment.Event.LHS(2);
end
n1 = stop-start+1;

% =========================================================================
% Cut data
% =========================================================================
names = fieldnames(Marker);
if ~isempty(names)
    for i = 1:size(names,1)
        if ~isempty(Marker.(names{i}))
            Marker.(names{i}) = Marker.(names{i})(:,:,start:stop);
        end
    end
end