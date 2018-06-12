% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_plotCycle
% -------------------------------------------------------------------------
% Subject:      Plot marker during gait cycle
% -------------------------------------------------------------------------
% Inputs:       - Marker (structure)
%               - Vmarker (structure)
%               - n (int)
% Outputs:      
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates:
% =========================================================================

function posture_plotCycle(Marker,Vmarker,n)

for i = 1:n    
    fig = figure(2); hold on; axis equal; view(45,20);   
    % Markers
    names = fieldnames(Marker);
    for j = 1:size(names)
        if ~isempty(Marker.(names{j}))
            plot3(permute(Marker.(names{j})(1,1,i),[3,1,2]),permute(Marker.(names{j})(2,1,i),[3,1,2]),permute(Marker.(names{j})(3,1,i),[3,1,2]), ...
                'Marker','.','Color','Red','Markersize',20);
        end
    end    
    % Virtual markers
    names = fieldnames(Vmarker);
    for j = 1:size(names)
        if ~isempty(Vmarker.(names{j})) && isempty(strfind(names{j},'static'))
            plot3(permute(Vmarker.(names{j})(1,1,i),[3,1,2]),permute(Vmarker.(names{j})(2,1,i),[3,1,2]),permute(Vmarker.(names{j})(3,1,i),[3,1,2]), ...
                'Marker','.','Color','Green','Markersize',20);
        end
    end   
    pause(0.01);
    if i~= n
        clf(fig);
    end
end