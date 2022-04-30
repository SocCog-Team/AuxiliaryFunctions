function [ output_args ] = AddSCPCodeToMatlabPath( input_args )
%ADDSCPCODETOMATLABPATH Summary of this function goes here
%   Detailed explanation goes here

CurrentDir = pwd;
CurrentFunctionDir = fileparts(mfilename('fullpath')); % where does the function mfile live?


% we need to start somewhere, so go there manually
%cd (fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller', 'CODE', 'AuxiliaryFunctions', 'Matlab'));
% assuming we are in SCPDirs.SCP_CODE_BaseDir.AuxiliaryFunctions already
cd (fullfile(CurrentFunctionDir, 'Matlab'));

% abstract over different filesystem starting points

%override_directive = 'local'; %this allows to override automatically using the network, requires host specific changes to GetDirectoriesByHostName
override_directive = 'local_code'; %this allows to override automatically using the network, requires host specific changes to GetDirectoriesByHostName

SCPDirs = GetDirectoriesByHostName(override_directive);


%AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir), [], [] );
% selectively add the different code repositories
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'AuxiliaryFunctions'), [], [] );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'LogFileAnalysis'), [], fullfile(SCPDirs.SCP_CODE_BaseDir, 'LogFileAnalysis', 'fnParseEventIDEReportSCPv06.m') );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'SessionDataAnalysis'), [], fullfile(SCPDirs.SCP_CODE_BaseDir, 'SessionDataAnalysis', 'subject_bias_analysis_sm01.m') );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'eyetrackerDataAnalysis'), [], [] );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'coordination_testing'), [], [] );
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'Ephys'), [], fullfile(SCPDirs.SCP_CODE_BaseDir, 'Ephys', 'analysis_code', 'SCP_ephys_base_analysis.m') );
%AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'fieldtrip'), [], []); %fieldtrip should not be included like that, as requires a special dance, see/call Ephys/start_fieldtrip.m
%AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'LFP_timefrequency_analysis'), [], []); % see/call Ephys/start_LFP_timefrequency_analysis.m
AddToMatlabPath( fullfile(SCPDirs.SCP_CODE_BaseDir, 'External_modified'), [], []); 


cd(CurrentDir);
return
end

