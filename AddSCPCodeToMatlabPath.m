function [ output_args ] = AddSCPCodeToMatlabPath( input_args )
%ADDSCPCODETOMATLABPATH Summary of this function goes here
%   Detailed explanation goes here

CurrentDir = pwd;

% we need to start somewhere, so go there manually
cd (fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller', 'CODE', 'AuxiliaryFunctions', 'Matlab'));


% assuming we are in SCPDirs.SCP_CODE_BaseDir.AuxiliaryFunctions already
cd (fullfile(pwd, 'Matlab'));

% abstract over different filesystem starting points
SCPDirs = GetDirectoriesByHostName();


%AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir), [], [] );
% selectively add the different code repositories
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'AuxiliaryFunctions'), [], [] );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'LogFileAnalysis'), [], fullfile(SCPDirs.SCP_CODE_BaseDir, 'LogFileAnalysis', 'fnParseEventIDEReportSCPv06.m') );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'SessionDataAnalysis'), [], [] );


cd(CurrentDir);

end

