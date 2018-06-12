% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_plotStatic
% -------------------------------------------------------------------------
% Subject:      Plot marker during static
% -------------------------------------------------------------------------
% Inputs:       - Marker (structure)
%               - Vmarker (structure)
% Outputs:      
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 14/12/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates:
% =========================================================================

function posture_plotStatic(Marker,Vmarker)

fig = figure; hold on; axis equal;
% Markers
names = fieldnames(Marker);
for j = 1:size(names)
    if ~isempty(Marker.(names{j}))
        plot3(permute(Marker.(names{j})(1,1,1),[3,1,2]),permute(Marker.(names{j})(2,1,1),[3,1,2]),permute(Marker.(names{j})(3,1,1),[3,1,2]), ...
            'Marker','.','Color','Red','Markersize',20);
    end
end    
% Virtual markers
if ~isempty(Vmarker)
    names = fieldnames(Vmarker);
    for j = 1:size(names)
        if ~isempty(Vmarker.(names{j}))
            plot3(permute(Vmarker.(names{j})(1,1,1),[3,1,2]),permute(Vmarker.(names{j})(2,1,1),[3,1,2]),permute(Vmarker.(names{j})(3,1,1),[3,1,2]), ...
                'Marker','.','Color','Green','Markersize',20);
        end
    end 
end