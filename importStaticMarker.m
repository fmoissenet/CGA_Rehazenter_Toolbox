% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importStaticMarker
% -------------------------------------------------------------------------
% Subject:      Load static markers
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Marker,btk2] = importStaticMarker(Marker,btk2)

nMarker = fieldnames(Marker);
for j = 1:size(nMarker,1)
    % Keep only the man value of the coordinates
    Marker.(nMarker{j}) = mean(Marker.(nMarker{j}),1);
    % Export BTK markers
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