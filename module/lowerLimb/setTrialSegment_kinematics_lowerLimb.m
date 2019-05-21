% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setTrialSegment_kinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Set segment parameters
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,Vmarker,btk2] = ...
    setTrialSegment_kinematics_lowerLimb(Session,Patient,Condition,Marker,Event,Forceplate,tGrf,Grf,btk,btk2,s,fMarker)

n = size(Marker.R_IAS,3);

% =========================================================================
% RIGHT PELVIS
% =========================================================================
% Pelvis axes (Dumas and Wojtusch 2018)
Z5 = Vnorm_array3(Marker.R_IAS-Marker.L_IAS);
Y5 = Vnorm_array3(cross(Marker.R_IAS-(Marker.R_IPS+Marker.L_IPS)/2,...
    Marker.L_IAS-(Marker.R_IPS+Marker.L_IPS)/2));
X5 = Vnorm_array3(cross(Y5,Z5));
w_pelvis = mean(sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2))); % pelvis width
% Determination of the lumbar joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    LJC(1) = -34.0/100;
    LJC(2) = 4.9/100;
    LJC(3) = 0.0/100;
elseif strcmp(Patient.gender,'Homme')
    LJC(1) = -33.5/100;
    LJC(2) = -3.2/100;
    LJC(3) = 0.0/100;
end
Vmarker.LJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    LJC(1)*w_pelvis*X5 + LJC(2)*w_pelvis*Y5 + LJC(3)*w_pelvis*Z5;
% Export marker in C3D file
temp = [Vmarker.LJC(1,:,:) -Vmarker.LJC(3,:,:) Vmarker.LJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'LJC');
% Determination of the hip joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    R_HJC(1) = -13.9/100;
    R_HJC(2) = -33.6/100;
    R_HJC(3) = 37.2/100;
    L_HJC(1) = -13.9/100;
    L_HJC(2) = -33.6/100;
    L_HJC(3) = -37.2/100;
elseif strcmp(Patient.gender,'Homme')
    R_HJC(1) = -9.5/100;
    R_HJC(2) = -37.0/100;
    R_HJC(3) = 36.1/100;
    L_HJC(1) = -9.5/100;
    L_HJC(2) = -37.0/100;
    L_HJC(3) = -36.1/100;
end
Vmarker.R_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    R_HJC(1)*w_pelvis*X5 + R_HJC(2)*w_pelvis*Y5 + R_HJC(3)*w_pelvis*Z5;
Vmarker.L_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    L_HJC(1)*w_pelvis*X5 + L_HJC(2)*w_pelvis*Y5 + L_HJC(3)*w_pelvis*Z5;
% Export marker in C3D file
temp = [Vmarker.R_HJC(1,:,:) -Vmarker.R_HJC(3,:,:) Vmarker.R_HJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_HJC');
% Export marker in C3D file
temp = [Vmarker.L_HJC(1,:,:) -Vmarker.L_HJC(3,:,:) Vmarker.L_HJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_HJC');
% Pelvis parameters (Dumas and Chèze 2007)
rP5 = Vmarker.LJC;
rD5 = (Vmarker.R_HJC+Vmarker.L_HJC)/2;
w5 = Z5;
u5 = X5;
Segment(5).Q = [u5;rP5;rD5;w5];
Segment(5).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];

% =========================================================================
% RIGHT FEMUR
% =========================================================================
% Femur markers
Segment(4).rM = [Marker.R_FTC,Marker.R_FLE,Vmarker.R_HJC];
% Knee joint centre
% Reconstruction from Condition.Static.LowerLimb.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.LowerLimb.Segment(4).rM',Segment(4).rM(:,:,i)');
end
Vmarker.R_KJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.LowerLimb.Vmarker.R_KJC,[1 1 n])) ...
    + Translation;
Vmarker.R_KJC = Vmarker.R_KJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.R_KJC(1,:,:) -Vmarker.R_KJC(3,:,:) Vmarker.R_KJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_KJC');
% Femur axes (Dumas and Wojtusch 2018)
Y4 = Vnorm_array3(Vmarker.R_HJC-Vmarker.R_KJC);
X4 = Vnorm_array3(cross(Marker.R_FLE-Vmarker.R_HJC,Vmarker.R_KJC-Vmarker.R_HJC));
Z4 = Vnorm_array3(cross(X4,Y4));
% Femur parameters (Dumas and Chèze 2007)
rP4 = Vmarker.R_HJC;
rD4 = Vmarker.R_KJC;
w4 = Vnorm_array3(Marker.R_FLE-Vmarker.R_KJC);%Z4;
u4 = X4;
Segment(4).Q = [u4;rP4;rD4;w4];

% =========================================================================
% RIGHT TIBIA/FIBULA
% =========================================================================
% Tibia/fibula Marker
Segment(3).rM = [Marker.R_FAX,Marker.R_TTC,Marker.R_FAL,Vmarker.R_KJC];
% Ankle joint centre
% Reconstruction from Condition.Static.LowerLimb.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.LowerLimb.Segment(3).rM',Segment(3).rM(:,:,i)');
end
Vmarker.R_AJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.LowerLimb.Vmarker.R_AJC,[1 1 n])) ...
    + Translation;
Vmarker.R_AJC = Vmarker.R_AJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.R_AJC(1,:,:) -Vmarker.R_AJC(3,:,:) Vmarker.R_AJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_AJC');
% Tibia/fibula axes (Dumas and Wojtusch 2018)
Y3 = Vnorm_array3(Vmarker.R_KJC-Vmarker.R_AJC);
X3 = Vnorm_array3(cross(Vmarker.R_AJC-Marker.R_FAX,Vmarker.R_KJC-Marker.R_FAX));
Z3 = Vnorm_array3(cross(X3,Y3));
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP3 = Vmarker.R_KJC;
rD3 = Vmarker.R_AJC;
w3 = Vnorm_array3(Marker.R_FAL-Vmarker.R_AJC);%Z3;
u3 = X3;
Segment(3).Q = [u3;rP3;rD3;w3];

% =========================================================================
% RIGHT FOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_MJC = (Marker.R_FM5+Marker.R_FM1)/2;
% Export marker in C3D file
temp = [Vmarker.R_MJC(1,:,:) -Vmarker.R_MJC(3,:,:) Vmarker.R_MJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_MJC');
% Foot axes (Dumas and Wojtusch 2018)
X2 = Vnorm_array3(Vmarker.R_MJC-Marker.R_FCC);
Y2 = Vnorm_array3(cross(Marker.R_FM5-Marker.R_FCC,Marker.R_FM1-Marker.R_FCC));
Z2 = Vnorm_array3(cross(X2,Y2));
% Foot parameters (Dumas and Chèze 2007)
rP2 = Vmarker.R_AJC;
rD2 = Vmarker.R_MJC;
w2 = Z2;
u2 = X2;
Segment(2).Q = [u2;rP2;rD2;w2];
Segment(2).rM = [Marker.R_FCC,Marker.R_FM1,Marker.R_FM5];

% =========================================================================
% RIGHT FORCEPLATE (1)
% =========================================================================
% Set segment parameters
if s(1) == 1
    temp1 = permute(Grf(1).P,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    rP1 = permute(temp2,[2,3,1]);
elseif s(1) == 2
    temp1 = permute(Grf(2).P,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    rP1 = permute(temp2,[2,3,1]);
else
rP1 = NaN(3,1,length(Marker.R_FCC));
end
rD1 = zeros(3,1,length(Marker.R_FCC));
u1 = repmat([1;0;0],[1,1,length(Marker.R_FCC)]);
w1 = repmat([1;0;0],[1,1,length(Marker.R_FCC)]);
Segment(1).Q = [u1;rP1;rD1;w1];

% =========================================================================
% LEFT PELVIS
% =========================================================================
% Pelvis axes (Dumas and Wojtusch 2018)
Z105 = Vnorm_array3(Marker.R_IAS-Marker.L_IAS);
Y105 = Vnorm_array3(cross(Marker.R_IAS-(Marker.R_IPS+Marker.L_IPS)/2,...
    Marker.L_IAS-(Marker.R_IPS+Marker.L_IPS)/2));
X105 = Vnorm_array3(cross(Y105,Z105));
w_pelvis = mean(sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2))); % pelvis width
% Determination of the lumbar joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    LJC(1) = -34.0/100;
    LJC(2) = 4.9/100;
    LJC(3) = 0.0/100;
elseif strcmp(Patient.gender,'Homme')
    LJC(1) = -33.5/100;
    LJC(2) = -3.2/100;
    LJC(3) = 0.0/100;
end
Vmarker.LJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    LJC(1)*w_pelvis*X5 + LJC(2)*w_pelvis*Y5 + LJC(3)*w_pelvis*Z5;
% Determination of the hip joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    R_HJC(1) = -13.9/100;
    R_HJC(2) = -33.6/100;
    R_HJC(3) = 37.2/100;
    L_HJC(1) = -13.9/100;
    L_HJC(2) = -33.6/100;
    L_HJC(3) = -37.2/100;
elseif strcmp(Patient.gender,'Homme')
    R_HJC(1) = -9.5/100;
    R_HJC(2) = -37.0/100;
    R_HJC(3) = 36.1/100;
    L_HJC(1) = -9.5/100;
    L_HJC(2) = -37.0/100;
    L_HJC(3) = -36.1/100;
end
Vmarker.R_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    R_HJC(1)*w_pelvis*X5 + R_HJC(2)*w_pelvis*Y5 + R_HJC(3)*w_pelvis*Z5;
Vmarker.L_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    L_HJC(1)*w_pelvis*X5 + L_HJC(2)*w_pelvis*Y5 + L_HJC(3)*w_pelvis*Z5;
% Pelvis parameters (Dumas and Chèze 2007)
rP105 = Vmarker.LJC;
rD105 = (Vmarker.R_HJC+Vmarker.L_HJC)/2;
w105 = -Z105;
u105 = X105;
Segment(105).Q = [u105;rP105;rD105;w105];
Segment(105).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];

% =========================================================================
% LEFT FEMUR
% =========================================================================
% Femur markers
Segment(104).rM = [Marker.L_FTC,Marker.L_FLE,Vmarker.L_HJC];
% Knee joint centre
% Reconstruction from Condition.Static.LowerLimb.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.LowerLimb.Segment(104).rM',Segment(104).rM(:,:,i)');
end
Vmarker.L_KJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.LowerLimb.Vmarker.L_KJC,[1 1 n])) ...
    + Translation;
Vmarker.L_KJC = Vmarker.L_KJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.L_KJC(1,:,:) -Vmarker.L_KJC(3,:,:) Vmarker.L_KJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_KJC');
% Femur axes (Dumas and Wojtusch 2018)
Y104 = Vnorm_array3(Vmarker.L_HJC-Vmarker.L_KJC);
X104 = -Vnorm_array3(cross(Marker.L_FLE-Vmarker.L_HJC,Vmarker.L_KJC-Vmarker.L_HJC));
Z104 = Vnorm_array3(cross(X104,Y104));
% Femur parameters (Dumas and Chèze 2007)
rP104 = Vmarker.L_HJC;
rD104 = Vmarker.L_KJC;
w104 = Vnorm_array3(Marker.L_FLE-Vmarker.L_KJC);%Z4;
u104 = X104;
Segment(104).Q = [u104;rP104;rD104;w104];

% =========================================================================
% LEFT TIBIA/FIBULA
% =========================================================================
% Tibia/fibula Marker
Segment(103).rM = [Marker.L_FAX,Marker.L_TTC,Marker.L_FAL,Vmarker.L_KJC];
% Ankle joint centre
% Reconstruction from Condition.Static.LowerLimb.Rstatic data by rigid body rotation & translation
% Soederqvist and Wedin 1993 and Challis 1995
Rotation = [];
Translation = [];
RMS = [];
for i = 1:n
    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
        = soder(Condition.Static.LowerLimb.Segment(103).rM',Segment(103).rM(:,:,i)');
end
Vmarker.L_AJC = ...
    Mprod_array3(Rotation , repmat(Condition.Static.LowerLimb.Vmarker.L_AJC,[1 1 n])) ...
    + Translation;
Vmarker.L_AJC = Vmarker.L_AJC(1:3,:,:);
% Export marker in C3D file
temp = [Vmarker.L_AJC(1,:,:) -Vmarker.L_AJC(3,:,:) Vmarker.L_AJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_AJC');
% Tibia/fibula axes (Dumas and Wojtusch 2018)
Y103 = Vnorm_array3(Vmarker.L_KJC-Vmarker.L_AJC);
X103 = -Vnorm_array3(cross(Vmarker.L_AJC-Marker.L_FAX,Vmarker.L_KJC-Marker.L_FAX));
Z103 = Vnorm_array3(cross(X103,Y103));
% Tibia/fibula parameters (Dumas and Chèze 2007)
rP103 = Vmarker.L_KJC;
rD103 = Vmarker.L_AJC;
w103 = Vnorm_array3(Marker.L_FAL-Vmarker.L_AJC);%Z3;
u103 = X103;
Segment(103).Q = [u103;rP103;rD103;w103];

% =========================================================================
% LEFT FOOT
% =========================================================================
% Metatarsal joint centre (Dumas and Wojtusch 2018)
Vmarker.L_MJC = (Marker.L_FM5+Marker.L_FM1)/2;
% Export marker in C3D file
temp = [Vmarker.L_MJC(1,:,:) -Vmarker.L_MJC(3,:,:) Vmarker.L_MJC(2,:,:)];
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPoint(btk2,btkGetPointNumber(btk2),permute(temp,[3,2,1])*1e3);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_MJC');
% Foot axes (Dumas and Wojtusch 2018)
X102 = Vnorm_array3(Vmarker.L_MJC-Marker.L_FCC);
Y102 = -Vnorm_array3(cross(Marker.L_FM5-Marker.L_FCC,Marker.L_FM1-Marker.L_FCC));
Z102 = Vnorm_array3(cross(X102,Y102));
% Foot parameters (Dumas and Chèze 2007)
rP102 = Vmarker.L_AJC;
rD102 = Vmarker.L_MJC;
w102 = Z102;
u102 = X102;
Segment(102).Q = [u102;rP102;rD102;w102];
Segment(102).rM = [Marker.L_FCC,Marker.L_FM1,Marker.L_FM5];

% =========================================================================
% LEFT FORCEPLATE (2)
% =========================================================================
% Set segment parameters
if s(2) == 1
    temp1 = permute(Grf(1).P,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    rP101 = permute(temp2,[2,3,1]);
elseif s(2) == 2
    temp1 = permute(Grf(2).P,[3,1,2]);
    temp2 = interp1(1:length(temp1),temp1,linspace(1,length(temp1),n),'pchip');
    rP101 = permute(temp2,[2,3,1]);
else
    rP101 = NaN(3,1,length(Marker.L_FCC));
end
rD101 = zeros(3,1,length(Marker.R_FCC));
u101 = repmat([1;0;0],[1,1,length(Marker.R_FCC)]);
w101 = repmat([1;0;0],[1,1,length(Marker.R_FCC)]);
Segment(101).Q = [u101;rP101;rD101;w101];

% =========================================================================
% EXPORT GRF IN C3D
% =========================================================================
btkAppendForcePlatformType2(btk2,tGrf(1).F,...
    tGrf(1).M,Forceplate(1).corners',[0,0,0],[0,0,0]);
btkAppendForcePlatformType2(btk2,tGrf(2).F,...
    tGrf(2).M,Forceplate(2).corners',[0,0,0],[0,0,0]);