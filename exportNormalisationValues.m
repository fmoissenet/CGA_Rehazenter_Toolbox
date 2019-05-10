% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportNormalisationValues
% -------------------------------------------------------------------------
% Subject:      Export to C3D metadata all information required to remove
%               data normalisation
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function btk2 = exportNormalisationValues(Session,Patient,btk2)

% SUBJECT metadata
nData = 6;
info.format = 'Integer';
info.values = nData;
btkAppendMetaData(btk2,'SUBJECT','USED',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',nData];
info.values(1:nData) = {'gender' 'age' 'weight' 'height' ...
    'R_legLength' 'L_legLength'};
btkAppendMetaData(btk2,'SUBJECT','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',nData];
info.values(1:nData) = {'adimensioned (0: woman, 1: man)' 'years' 'kg' 'm' 'm' 'm'};
btkAppendMetaData(btk2,'SUBJECT','UNITS',info);
clear info;
info.format = 'Real';
info.dimensions = ['1x',nData];
if strcmp(Patient.gender,'Homme')
    info.values(2) = 1;
elseif strcmp(Patient.gender,'Femme')
    info.values(2) = 0;
end
info.values(3) = Session.age;
info.values(4) = Session.weight;
info.values(5) = Session.height;
info.values(6) = Session.R_legLength;
info.values(7) = Session.L_legLength;
btkAppendMetaData(btk2,'SUBJECT','VALUES',info);