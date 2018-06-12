function [Session,Condition] = launchStatic_upperLimb(Session,Condition,Patient,static,n)

% Import markers
Condition.Rmarker = importStaticMarker_upperLimb(static,n,'Right',Session.system,Session.markerSet.upperLimb);
Condition.Lmarker = importStaticMarker_upperLimb(static,n,'Left',Session.system,Session.markerSet.upperLimb);
% Define segments parameters
[Condition.Rstatic,Condition.Rmarker,Condition.Rvmarker] = setStaticSegment_upperLimb(Patient,Condition.Rmarker);
[Condition.Lstatic,Condition.Lmarker,Condition.Lvmarker] = setStaticSegment_upperLimb(Patient,Condition.Lmarker);
% Plot static
% plotStatic(Condition..Rmarker,Condition..Rvmarker);
% plotStatic(Condition..Lmarker,Condition..Lvmarker);