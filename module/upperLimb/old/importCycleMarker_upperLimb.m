% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_importCycleMarker
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
% Date of creation: 04/01/2017
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Marker = upperLimb_importCycleMarker(file,n,f,side,system,markersset)

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
    % Interpolate data to fill the gaps
    x = 1:n;
    xx = 1:1:n;
    temp.(names{i}) = interp1(x,temp.(names{i}),xx,'spline');
    % Filt data (6Hz, 4th order Btw)
    [B,A] = butter(4,6/(f/2),'low');
    temp.(names{i}) = filtfilt(B,A,temp.(names{i}));
    % Store Marker as 3-array vectors
    temp.(names{i}) = permute(temp.(names{i}),[2,3,1]);    
end

% =========================================================================
% Create generic markers
% =========================================================================
if strcmp(markersset,'LWBM (sup)')
    if strcmp(side,'Right')
        % Trunk
        Marker.SJN = temp.SJN;
        Marker.SXS = temp.SXS;
        Marker.CV7 = temp.CV7;
        if isfield(temp,'TV8')
            Marker.TV8 = temp.TV8;
        end
        % Ilium
        Marker.R_IAS = temp.R_IAS;
        Marker.R_IPS = temp.R_IPS;
        Marker.L_IAS = temp.L_IAS;
        Marker.L_IPS = temp.L_IPS;
        % Scapula
        Marker.R_SAJ = temp.R_SAJ;
        Marker.R_SAA = temp.R_SAA;
        Marker.R_SRS = temp.R_SRS;
        Marker.R_SIA = temp.R_SIA;
        Marker.L_SAJ = temp.L_SAJ;
        Marker.L_SAA = temp.L_SAA;
        Marker.L_SRS = temp.L_SRS;
        Marker.L_SIA = temp.L_SIA;
        % Humerus
        Marker.R_HLE = temp.R_HLE;
        Marker.R_HME = temp.R_HME;
        Marker.L_HLE = temp.L_HLE;
        Marker.L_HME = temp.L_HME;
        % Ulna/radius
        Marker.R_RSP = temp.R_RSP;
        Marker.R_UHE = temp.R_UHE;
        Marker.L_RSP = temp.L_RSP;
        Marker.L_UHE = temp.L_UHE;
        % Hand
        Marker.R_HM2 = temp.R_HM2;
        Marker.R_HM5 = temp.R_HM5;
        Marker.L_HM2 = temp.L_HM2;
        Marker.L_HM5 = temp.L_HM5;   
    elseif strcmp(side,'Left')
        names = fieldnames(temp);
        % Trunk
        Marker.SJN = temp.SJN;
        Marker.SXS = temp.SXS;
        Marker.CV7 = temp.CV7;
        if isfield(temp,'TV8')
            Marker.TV8 = temp.TV8;
        end
        % Ilium
        Marker.R_IAS = temp.L_IAS;
        Marker.R_IPS = temp.L_IPS;
        Marker.L_IAS = temp.R_IAS;
        Marker.L_IPS = temp.R_IPS;
        % Scapula
        Marker.R_SAJ = temp.L_SAJ;
        Marker.R_SAA = temp.L_SAA;
        Marker.R_SRS = temp.L_SRS;
        Marker.R_SIA = temp.L_SIA;
        Marker.L_SAJ = temp.R_SAJ;
        Marker.L_SAA = temp.R_SAA;
        Marker.L_SRS = temp.R_SRS;
        Marker.L_SIA = temp.R_SIA;
        % Humerus
        Marker.R_HLE = temp.L_HLE;
        Marker.R_HME = temp.L_HME;
        Marker.L_HLE = temp.R_HLE;
        Marker.L_HME = temp.R_HME;
        % Ulna/radius
        Marker.R_RSP = temp.L_RSP;
        Marker.R_UHE = temp.L_UHE;
        Marker.L_RSP = temp.R_RSP;
        Marker.L_UHE = temp.R_UHE;
        % Hand
        Marker.R_HM2 = temp.L_HM2;
        Marker.R_HM5 = temp.L_HM5;
        Marker.L_HM2 = temp.R_HM2;
        Marker.L_HM5 = temp.R_HM5;  
    end
end

% =========================================================================
% Set walking direction
% =========================================================================
minusX = 1; % +X:1, -X:-1
names = fieldnames(Marker);
if ~isempty(Marker)
    if (Marker.R_IAS(1,1,fix(n/2+10))+100) - (Marker.R_IAS(1,1,fix(n/2-10))+100) < 0
        minusX = -1;
        for i = 1:size(names,1)
            if ~isempty(Marker.(names{i}))
                Marker.(names{i})(1,:,:) = -Marker.(names{i})(1,:,:);
                Marker.(names{i})(3,:,:) = -Marker.(names{i})(3,:,:);
            end
        end
    end
end