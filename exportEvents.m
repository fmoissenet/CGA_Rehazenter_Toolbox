% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportEvents
% -------------------------------------------------------------------------
% Subject:      Update and export updated events to C3D
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Event,btk2] = exportEvents(Event,trial,btk2,fMarker)

nEvent = fieldnames(Event);
events = round(sort([Event.RHS,Event.RTO,Event.LHS,Event.LTO])*fMarker)-...
    btkGetFirstFrame(trial)+1;
for i = 1:length(nEvent)
    Event.(nEvent{i}) = (Event.(nEvent{i})+(-btkGetFirstFrame(trial)-events(1)+1+5)/fMarker);
    for j = 1:length(Event.(nEvent{i}))
        if strfind(nEvent{i},'RHS')
            if j == 1
                btkAppendEvent(btk2,'Foot Strike1',Event.(nEvent{i})(j),'Right');
            elseif j == 2
                btkAppendEvent(btk2,'Foot Strike2',Event.(nEvent{i})(j),'Right');
            end
        elseif strfind(nEvent{i},'RTO')
            btkAppendEvent(btk2,'Foot Off',Event.(nEvent{i})(j),'Right');
        elseif strfind(nEvent{i},'LHS')
            if j == 1
                btkAppendEvent(btk2,'Foot Strike1',Event.(nEvent{i})(j),'Left');
            elseif j == 2
                btkAppendEvent(btk2,'Foot Strike2',Event.(nEvent{i})(j),'Left');
            end
        elseif strfind(nEvent{i},'LTO')
            btkAppendEvent(btk2,'Foot Off',Event.(nEvent{i})(j),'Left');
        end
    end
end