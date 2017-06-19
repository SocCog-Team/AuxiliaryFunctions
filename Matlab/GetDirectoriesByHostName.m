function [ DirectoriesStruct ] = GetDirectoriesByHostName( )
%GETBASEDIRECTORYBYHOSTNAME this basically encapsulates a selection table
%to allow selecting specific directories for different computers.
%   The assumption is that on different hosts the data filesystem hierarchy
%   might be located at a diifferent starting point, whle the rest of the structure
%	should be invariant between hosts. One obvious use case for this is to
%	allow to handle the fact that unix/macosx pathes start with "/" while
%	windows paths start with a drive letter like "C:\"
%
% Just add new case clauses for new machines. If new directories need to be
% exported, make sure to add to all existing clauses...


% ready this for unix systems...
[sys_status, host_name] = system('hostname');
DS.CurrentHostName = strtrim(host_name(1:end-1));

switch host_name(1:end-1) % last char of host name result is ascii 10 (LF)
	case {'hms-beagle2', 'hms-beagle2.local'}
		if isdir('/Volumes/social_neuroscience_data/taskcontroller')
			% remote data repository
			DS.SCP_DATA_BaseDir = fullfile('/', 'Volumes', 'social_neuroscience_data', 'taskcontroller');
			DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
		else
			% local data copy
			disp('SCP data server share not mounted, falling back to local copy...');
			DS.SCP_DATA_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller');
			DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
		end
	case {'SCP-CTRL-00', 'SCP-CTRL-01', 'SCP-VIDEO-01-A', 'SCP-VIDEO-01-B'}
		DS.SCP_DATA_BaseDir = fullfile('Z:', 'taskcontroller');
		DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
% 	case 
% 		DS.SCP_DATA_BaseDir = fullfile('Z:', 'taskcontroller');
% 		DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
	otherwise
		error(['Hostname ', host_name(1:end-1), ' not handeled yet']);
end

DirectoriesStruct = DS;
end

