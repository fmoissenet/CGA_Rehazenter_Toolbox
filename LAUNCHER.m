% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% This toolbox uses the Biomechanical ToolKit for .c3d importation
% (https://code.google.com/p/b-tk/) 
% and the kinematics/dynamics toolbox developed by Raphaël Dumas 
% (https://nl.mathworks.com/matlabcentral/fileexchange/...
% 58021-3d-kinematics-and-inverse-dynamics)
% =========================================================================
% File name:    LAUNCHER
% -------------------------------------------------------------------------
% Subject:      Set parameters for CGA
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
clearvars;
warning('off','All');
clc;
disp('==================================================================');
disp('            REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX             ');
disp('==================================================================');
disp('              Authors: F. Moissenet, C. Schreiber                 ');
disp('                         Version: 2018                            ');
disp('                  Date of creation: 16/05/2018                    ');
disp('==================================================================');
disp(' ');

% =========================================================================
% Set toolbox folders
% =========================================================================
disp('Initialisation ...');
toolboxFolder = 'C:\Users\florent.moissenet\Documents\Professionnel\routines\github\CGA_Rehazenter_Toolbox';
normativeFile = 'C:\Users\florent.moissenet\Documents\Professionnel\routines\github\CGA_Rehazenter_Toolbox\norm\Normes spontanee.mat';
reportFolder = 'X:\Reports';
addpath(toolboxFolder);
addpath(genpath([toolboxFolder,'\module']));
addpath(genpath([toolboxFolder,'\toolbox']));
disp(' ');

% =========================================================================
% Set c3d folder
% =========================================================================
c3dFolder = 'C:\Users\florent.moissenet\Documents\Professionnel\publications\articles\1- en cours\Schreiber - Bdd\data\SS001';
matFolder = c3dFolder;

% =========================================================================
% Start Clinical Gait Analysis
% =========================================================================
startCGA(toolboxFolder,c3dFolder);