% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    writeConditionC3d
% -------------------------------------------------------------------------
% Subject:      Create a C3D merging all trials of the current condition
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function btk3 = writeConditionC3d(Session,Condition,btk2,file2,k)

% =========================================================================
% EMG signal (only band-pass filter)
% =========================================================================

if k == 1
    btkWriteAcquisition(btk2,'temp.c3d');
else
    clear btk2;
    % Load previous merged file
    btk1 = btkReadAcquisition('temp.c3d');
    Marker1 = btkGetMarkers(btk1);
    nMarker = fieldnames(Marker1);
    Forceplate1 = btkGetForcePlatforms(btk1);
    tGrf1 = btkGetForcePlatformWrenches(btk1);
    Grf1 = btkGetGroundReactionWrenches(btk1);
    Analog1 = btkGetAnalogs(btk1);
    nAnalog = fieldnames(Analog1);
    Scalar1 = btkGetScalars(btk1);
    nScalar = fieldnames(Scalar1);
    Event1 = btkGetEvents(btk1);
    nEvent = fieldnames(Event1);
    Angle1 = btkGetAngles(btk1);
    nAngle = fieldnames(Angle1);
    Moment1 = btkGetMoments(btk1);
    nMoment = fieldnames(Moment1);
    Power1 = btkGetPowers(btk1);
    nPower = fieldnames(Power1);
    fMarker = btkGetPointFrequency(btk1);
    n1 = length(Marker1.(nMarker{1}));
    t1 = btkGetLastFrame(btk1)/btkGetPointFrequency(btk1);
    % Load next file to be merged
    btk2 = btkReadAcquisition([strrep(file2,'.c3d',''),'_out.c3d']);
    Marker2 = btkGetMarkers(btk2);
    Forceplate2 = btkGetForcePlatforms(btk2);
    tGrf2 = btkGetForcePlatformWrenches(btk2);
    Grf2 = btkGetGroundReactionWrenches(btk2);
    Analog2 = btkGetAnalogs(btk2);
    Scalar2 = btkGetScalars(btk2);
    Event2 = btkGetEvents(btk2);
    Angle2 = btkGetAngles(btk2);
    Moment2 = btkGetMoments(btk2);
    Power2 = btkGetPowers(btk2);
    n2 = length(Marker2.(nMarker{1}));
    t2 = btkGetLastFrame(btk2)/btkGetPointFrequency(btk2);
    % Set BTK parameters to export a new C3D file
    btk3 = btkNewAcquisition(size(nMarker,1),n1+n2);
    btkSetFrequency(btk3,fMarker);
    btkSetAnalogSampleNumberPerFrame(btk3,1);
    % Merge Marker data
    for m = 1:size(nMarker,1)
        btkSetPoint(btk3,m,[Marker1.(nMarker{m});Marker2.(nMarker{m})]);
        btkSetPointLabel(btk3,m,nMarker{m});
    end
    % Merge EMG data
    nEMG = 1;
    for m = 1:size(nAnalog,1)
        if ~strcmp(Session.EMG{nEMG},'none')
            if ~isempty(strfind(nAnalog{m},'R_')) || ...
               ~isempty(strfind(nAnalog{m},'L_'))
                btkAppendAnalog(btk3,Session.EMG{nEMG},...
                    [Analog1.(nAnalog{m});Analog2.(nAnalog{m})],'EMG signal (mV)');
                nEMG = nEMG+1;
            end
        end
    end
    for m = 1:size(nScalar,1)
        btkSetPointNumber(btk3,btkGetPointNumber(btk3)+1);
        btkSetPointType(btk3,btkGetPointNumber(btk3),'scalar');
        btkSetPoint(btk3,btkGetPointNumber(btk3),...
            [Scalar1.(nScalar{m});Scalar2.(nScalar{m})]);
        btkSetPointLabel(btk3,btkGetPointNumber(btk3),Session.EMG{m});
        btkSetPointDescription(btk3,btkGetPointNumber(btk3),'EMG envelop normalised by cycle max');
    end
    % Merge GRF data
    btkAppendForcePlatformType2(btk3,[tGrf1(1).F; tGrf2(1).F],...
        [tGrf1(1).M; tGrf2(1).M],Forceplate2(1).corners',[0,0,0],[0,0,0]);
    btkAppendForcePlatformType2(btk3,[tGrf1(2).F; tGrf2(2).F],...
        [tGrf1(2).M; tGrf2(2).M],Forceplate2(2).corners',[0,0,0],[0,0,0]);
    % Merge Event data
    for m = 1:size(nEvent,1)
        for l = 1:length(Event1.(nEvent{m}))
            if strfind(nEvent{m},'Right_')
                newname = regexprep(nEvent{m},'Right_','');
                newname = regexprep(newname,'_',' ');
                btkAppendEvent(btk3,newname,Event1.(nEvent{m})(l),'Right');
            elseif strfind(nEvent{m},'Left_')
                newname = regexprep(nEvent{m},'Left_','');
                newname = regexprep(newname,'_',' ');
                btkAppendEvent(btk3,newname,Event1.(nEvent{m})(l),'Left');
            end
        end
    end
    for m = 1:size(nEvent,1)
        for l = 1:length(Event2.(nEvent{m}))
            if strfind(nEvent{m},'Right_')
                newname = regexprep(nEvent{m},'Right_','');
                newname = regexprep(newname,'_',' ');
                btkAppendEvent(btk3,newname,Event2.(nEvent{m})(l)+t1,'Right');
            elseif strfind(nEvent{m},'Left_')
                newname = regexprep(nEvent{m},'Left_','');
                newname = regexprep(newname,'_',' ');
                btkAppendEvent(btk3,newname,Event2.(nEvent{m})(l)+t1,'Left');
            end
        end
    end
    % Merge Angle data
    for m = 1:size(nAngle,1)
        btkSetPointNumber(btk3,btkGetPointNumber(btk3)+1);
        btkSetPointType(btk3,btkGetPointNumber(btk3),'angle');
        btkSetPoint(btk3,btkGetPointNumber(btk3),[Angle1.(nAngle{m});Angle2.(nAngle{m})]);
        btkSetPointLabel(btk3,btkGetPointNumber(btk3),nAngle{m});
        if strfind(nAngle{m},'Ankle')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');
        elseif strfind(nAngle{m},'Knee')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');
        elseif strfind(nAngle{m},'Hip')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');
        elseif strfind(nAngle{m},'Pelvis')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Oup(+)/Odw, Z-Axis: IR(+)/ER');
        elseif strfind(nAngle{m},'Foot')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');
        end
    end
    % Merge Moment data
    for m = 1:size(nMoment,1)
        btkSetPointNumber(btk3,btkGetPointNumber(btk3)+1);
        btkSetPointType(btk3,btkGetPointNumber(btk3),'moment');
        btkSetPoint(btk3,btkGetPointNumber(btk3),[Moment1.(nMoment{m});Moment2.(nMoment{m})]);
        btkSetPointLabel(btk3,btkGetPointNumber(btk3),nMoment{m});
        if strfind(nMoment{m},'Ankle')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Moment (Nm/kg): X-Axis: PF(+)/DF, Y-Axis: IR(+)/ER, Z-Axis: Ad(+)/Ab');
        elseif strfind(nMoment{m},'Knee')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
        elseif strfind(nMoment{m},'Hip')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
        end
    end
    % Merge Power data    
    for m = 1:size(nPower,1)
        btkSetPointNumber(btk3,btkGetPointNumber(btk3)+1);
        btkSetPointType(btk3,btkGetPointNumber(btk3),'power');
        btkSetPoint(btk3,btkGetPointNumber(btk3),[Power1.(nPower{m});Power2.(nPower{m})]);
        btkSetPointLabel(btk3,btkGetPointNumber(btk3),nPower{m});
        if strfind(nPower{m},'Ankle')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Power (W/kg): Gen(+)/Abs');
        elseif strfind(nPower{m},'Knee')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Power (W/kg): Gen(+)/Abs');
        elseif strfind(nPower{m},'Hip')
            btkSetPointDescription(btk3,btkGetPointNumber(btk3),'Power (W/kg): Gen(+)/Abs');
        end
    end
    btkWriteAcquisition(btk3,'temp.c3d');
end