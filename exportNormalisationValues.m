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

info.format = 'Integer';
info.values = 6;
btkAppendMetaData(btk2,'SUBJECT','USED',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',6];
info.values(1:6) = {'age' 'gender' 'weight' 'height' ...
    'R_legLength' 'L_legLength'};
btkAppendMetaData(btk2,'SUBJECT','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',6];
info.values(1:6) = {'years' 'adimensioned (0: woman, 1: man)' 'kg' 'm' 'm' 'm'};
btkAppendMetaData(btk2,'SUBJECT','UNITS',info);
clear info;
info.format = 'Real';
info.dimensions = ['1x',6];
info.values(1) = str2num(Session.date(7:end))-str2num(Patient.birthdate(7:end));
if strcmp(Patient.gender,'Homme')
    info.values(2) = 1;
elseif strcmp(Patient.gender,'Femme')
    info.values(2) = 0;
end
info.values(3) = Session.weight;
info.values(4) = Session.height;
info.values(5) = Session.R_legLength;
info.values(6) = Session.L_legLength;
btkAppendMetaData(btk2,'SUBJECT','VALUES',info);