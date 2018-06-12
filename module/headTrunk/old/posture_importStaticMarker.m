% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_importStaticMarker
% -------------------------------------------------------------------------
% Subject:      Import and rename marker in the format proposed by S. Van
%               Sint Jan in Color Atlas of Skeletal Landmarks Definitions
%               and create generic right side marker
% -------------------------------------------------------------------------
% Inputs:       - file (btk)
%               - n (int)
%               - side (char)
%               - system (char)
%               - markersset (char)
% Outputs:      - Marker (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 02/12/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Marker = posture_importStaticMarker(file,n,side,system,markersset)

% =========================================================================
% Import marker trajectories in the correct format
% =========================================================================
temp = btkGetMarkers(file);
names = fieldnames(temp);
for i = 1:size(names,1)       
    % Modify the ICS
    if strcmp(system,'Qualisys')
        if strcmp(side,'Right')
            temp.(names{i}) = [temp.(names{i})(:,1) temp.(names{i})(:,3) -temp.(names{i})(:,2)];
        elseif strcmp(side,'Left')
            temp.(names{i}) = [temp.(names{i})(:,1) temp.(names{i})(:,3) temp.(names{i})(:,2)];
        end
    end
    % Convert from mm to m
    if strcmp(btkGetPointsUnit(file,'marker'),'mm')
        temp.(names{i}) = temp.(names{i})*10^(-3);
    end
    % Replace [0 0 0] by NaN
    for j = 1:n
        if temp.(names{i})(j,:) == [0 0 0];
            temp.(names{i})(j,:) = nan(1,3);
        end
    end
    % Compute mean position of each marker during file trial
    temp.(names{i}) = nanmean(temp.(names{i}));
    % Store Marker as 3-array vectors
    temp.(names{i}) = permute(temp.(names{i}),[2,3,1]);    
end

% =========================================================================
% Create generic markers
% =========================================================================
if strcmp(markersset,'LWBM (tronc/tete)')
    if strcmp(side,'Right')
        % Head
        Marker.R_HDF = temp.R_HDF;
        Marker.R_HDB = temp.R_HDB;
        Marker.L_HDF = temp.L_HDF;
        Marker.L_HDB = temp.L_HDB;
        % Trunk
        Marker.SJN = temp.SJN;
        Marker.SXS = temp.SXS;
        Marker.CV7 = temp.CV7;
        Marker.TV10 = temp.TV10;
        % Ilium
        Marker.R_IAS = temp.R_IAS;
        Marker.R_IPS = temp.R_IPS;
        Marker.L_IAS = temp.L_IAS;
        Marker.L_IPS = temp.L_IPS;
    elseif strcmp(side,'Left')
        names = fieldnames(temp);
        % Head
        Marker.R_HDF = temp.L_HDF;
        Marker.R_HDB = temp.L_HDB;
        Marker.L_HDF = temp.R_HDF;
        Marker.L_HDB = temp.R_HDB;
        % Trunk
        Marker.SJN = temp.SJN;
        Marker.SXS = temp.SXS;
        Marker.CV7 = temp.CV7;
        Marker.TV10 = temp.TV10;
        % Ilium
        Marker.R_IAS = temp.L_IAS;
        Marker.R_IPS = temp.L_IPS;
        Marker.L_IAS = temp.R_IAS;
        Marker.L_IPS = temp.R_IPS;
    end
end