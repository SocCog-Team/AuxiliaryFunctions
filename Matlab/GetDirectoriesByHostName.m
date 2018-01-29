function [ DirectoriesStruct ] = GetDirectoriesByHostName( override_directive )
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

start_dir = fileparts(mfilename('fullpath'));

if ~exist('override_directive', 'var')
    override_directive = 'remote';
end


% ready this for unix systems...
[sys_status, host_name] = system('hostname');
host_name = host_name(1:end-1); % last char of host name result is ascii 10 (LF)
DS.CurrentHostName = strtrim(host_name);
DS.CurrentShortHostName = DS.CurrentHostName;

dot_idx=strfind(host_name, '.');
if ~isempty(dot_idx)
    % remove the domain
    DS.CurrentShortHostName = host_name(1:dot_idx(1)-1);
end

% first check whether a path definition mat file exists
if exist(fullfile(start_dir, [DS.CurrentShortHostName, '.mat'])) == 2
    % the named mat file exists, so load the required variables
    tmp_mat_struct = load(fullfile(start_dir, [DS.CurrentShortHostName, '.mat']));
    if isfield(tmp_mat_struct, 'SCP_DATA_BaseDir')
        DS.SCP_DATA_BaseDir = tmp.SCP_DATA_BaseDir;
    else
        error([fullfile(start_dir, [DS.CurrentShortHostName, '.mat']), ' does not contain (a valid) SCP_DATA_BaseDir, please adjust the mat file']);
    end
    if isfield(tmp_mat_struct, 'SCP_CODE_BaseDir')
        DS.SCP_DATA_BaseDir = tmp.SCP_CODE_BaseDir;
    else
        error([fullfile(start_dir, [DS.CurrentShortHostName, '.mat']), ' does not contain (a valid) SCP_CODE_BaseDir, please adjust the mat file']);
    end
else
    switch host_name
        case {'hms-beagle2', 'hms-beagle2.local', 'hms-beagle2.lan'}
            if isdir('/Volumes/social_neuroscience_data/taskcontroller')
                switch override_directive
                    case 'remote'
                        % remote data repository & remote code repository
                        DS.SCP_DATA_BaseDir = fullfile('/', 'Volumes', 'social_neuroscience_data', 'taskcontroller');
                        DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
                    case 'local_code'
                        % use the local code, as otherwise matlab gets confused
                        DS.SCP_DATA_BaseDir = fullfile('/', 'Volumes', 'social_neuroscience_data', 'taskcontroller');
                        DS.SCP_CODE_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller', 'CODE');
                    case 'local'
                        % use the local code, as otherwise matlab gets confused
                        DS.SCP_DATA_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller');
                        DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
                end
            else
                % local data copy, local code
                disp('SCP data server share not mounted, falling back to local copy...');
                DS.SCP_DATA_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller');
                DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
            end
            DS.CurrentShortHostName = 'hms-beagle2';
        case {'SCP-CTRL-00', 'SCP-CTRL-01', 'SCP-VIDEO-01-A', 'SCP-VIDEO-01-B'}
            DS.SCP_DATA_BaseDir = fullfile('Z:', 'taskcontroller');
            DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
            % 	case
            % 		DS.SCP_DATA_BaseDir = fullfile('Z:', 'taskcontroller');
            % 		DS.SCP_CODE_BaseDir = fullfile(DS.SCP_DATA_BaseDir, 'CODE');
        otherwise           
            disp(['Hostname ', host_name, ' not handeled yet']);
            disp(['Either add a case statement for ', host_name, ' or create ', [host_name, '.mat'], ' with the following fields:']);
            disp(['SCP_DATA_BaseDir: the fully qualified path to the parent directory of the SCP_DATA directory']);
            disp(['SCP_CODE_BaseDir: the fully qualified path to the parent directory of the SCP Code directory']);
            error('Unsure what to do now...');
            
    end
end
DirectoriesStruct = DS;
end

