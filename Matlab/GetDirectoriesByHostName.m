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
DirectoriesStruct = struct();

% DEFAULT TO USING THE SERVER
if ~exist('override_directive', 'var')
    override_directive = 'remote';
end


% ready this for unix systems...
[sys_status, host_name] = system('hostname');
host_name = host_name(1:end-1); % last char of host name result is ascii 10 (LF)
DS.CurrentHostName = strtrim(host_name);
DS.CurrentShortHostName = DS.CurrentHostName; % if the hostnmae has no domain part these two are the same

% extract the short host name by removing the domain parts
dot_idx=strfind(host_name, '.');
if ~isempty(dot_idx)
    DS.CurrentShortHostName = host_name(1:dot_idx(1)-1);
end

% first check whether a path definition mat file exists
if exist(fullfile(start_dir, [DS.CurrentShortHostName, '.mat'])) == 2
    % the named mat file exists, so load the required variables
    disp(['Found per host directory definition file, attempting to read from: ', fullfile(start_dir, [DS.CurrentShortHostName, '.mat'])]);
    tmp_mat_struct = load(fullfile(start_dir, [DS.CurrentShortHostName, '.mat']));
    
    if isfield(tmp_mat_struct, 'local')
        DS.local = tmp_mat_struct.local;
    else
        error([fullfile(start_dir, [DS.CurrentShortHostName, '.mat']), ' does not contain (a valid) .local definition set, please adjust the mat file']);
    end
    if isfield(tmp_mat_struct, 'remote')
        DS.remote = tmp_mat_struct.remote;
    else
        error([fullfile(start_dir, [DS.CurrentShortHostName, '.mat']), ' does not contain (a valid) .remote definition set, please adjust the mat file']);
    end
else
    switch host_name
        case {'hms-beagle2', 'hms-beagle2.local', 'hms-beagle2.lan'}
                DS.local.SCP_DATA_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller');
                DS.local.SCP_CODE_BaseDir = fullfile('/', 'space', 'data_local', 'moeller', 'DPZ', 'taskcontroller', 'CODE');
                DS.remote.SCP_DATA_BaseDir =  fullfile('/', 'Volumes', 'social_neuroscience_data', 'taskcontroller');
                DS.remote.SCP_CODE_BaseDir = fullfile(DS.remote.SCP_DATA_BaseDir, 'CODE');

        case {'SCP-VIDEO-01-A', 'SCP-VIDEO-01-B'}
                DS.local.SCP_DATA_BaseDir = fullfile('C:');
                DS.local.SCP_CODE_BaseDir = fullfile('C:', 'SCP_CODE');
                %DS.remote.SCP_DATA_BaseDir =  fullfile('Z:', 'taskcontroller');
                DS.remote.SCP_DATA_BaseDir =  fullfile('Y:');
                
                DS.remote.SCP_CODE_BaseDir = fullfile(DS.remote.SCP_DATA_BaseDir, 'CODE');

        case {'SCP-CTRL-00', 'SCP-CTRL-01B'}
                DS.local.SCP_DATA_BaseDir = fullfile('C:');
                DS.local.SCP_CODE_BaseDir = fullfile('C:', 'SCP_CODE');
                DS.remote.SCP_DATA_BaseDir =  fullfile('Z:', 'taskcontroller');
                DS.remote.SCP_CODE_BaseDir = fullfile(DS.remote.SCP_DATA_BaseDir, 'CODE');

        otherwise           
            disp(['Hostname ', host_name, ' not handeled yet']);
            disp(['Either add a case statement for ', host_name, ' to GetDirectoriesByHostName.m ']);
            disp(['or create ', [host_name, '.mat'], ' with the following fields:']);
            disp(['local.SCP_DATA_BaseDir: the fully qualified path to the local parent directory of the SCP_DATA directory']);
            disp(['remote.SCP_DATA_BaseDir: the fully qualified path to the remote parent directory of the SCP_DATA directory']);
            disp(['local.SCP_CODE_BaseDir: the fully qualified path to the local parent directory of the SCP Code directory']);
            disp(['remote.SCP_CODE_BaseDir: the fully qualified path to the remote parent directory of the SCP Code directory']);            
            disp('');
            disp('Please use the GUI to select the requested directories.');
            [local, remote] = fn_select_basedirs( start_dir );
            DS.local = local;
            DS.remote = remote;
            save(fullfile(start_dir, [DS.CurrentShortHostName, '.mat']), 'local', 'remote');
            %error('Unsure what to do now...');
            
    end
end

%
local.SCP_DATA_BaseDir = fullfile('C:');
local.SCP_CODE_BaseDir = fullfile('C:', 'SCP_CODE');
remote.SCP_DATA_BaseDir =  fullfile('Z:', 'taskcontroller');
remote.SCP_CODE_BaseDir = fullfile(DS.remote.SCP_DATA_BaseDir, 'CODE');



% can we reach the remote code base directory, if not try the local code
% base directory.
if ~isdir(DS.remote.SCP_CODE_BaseDir) && strcmp(override_directive, 'remote')
    if isdir(DS.local.SCP_CODE_BaseDir)
        disp('Requested remote SCP_CODE_BaseDir not recognized as directory (not reachable/mounted).');
        disp(['Demoting override_directive from ', override_directive, ' to ', 'local_code']);
        override_directive = 'local_code';
    else
        disp('Neither the local nor remote SCP_CODE_BaseDir was recognized as directory, bailing out');
        return;
    end
end

% can we reach the remote data base directory, if not try the local data
% base directory.
if ~isdir(DS.remote.SCP_DATA_BaseDir) && ismember(override_directive, {'remote', 'local_code'})
    if isdir(DS.local.SCP_DATA_BaseDir)
        disp('Requested remote SCP_DATA_BaseDir not recognized as directory (not reachable/mounted).');
        disp(['Demoting override_directive from ', override_directive, ' to ', 'local']);
        override_directive = 'local';
    else
        disp('Neither the local nor remote SCP_DATA_BaseDir was recognized as directory, bailing out');
        return;
    end
end


% honor the over-ride directive (if possible)
switch override_directive
    case 'remote'
        % remote data repository & remote code repository
        DS.SCP_DATA_BaseDir = DS.remote.SCP_DATA_BaseDir;
        DS.SCP_CODE_BaseDir = DS.remote.SCP_CODE_BaseDir;
    case 'local_code'
        % use the local code, as otherwise matlab gets confused
        DS.SCP_DATA_BaseDir = DS.remote.SCP_DATA_BaseDir;
        DS.SCP_CODE_BaseDir =  DS.local.SCP_CODE_BaseDir;
    case 'local'
        % use the local code, as otherwise matlab gets confused
        DS.SCP_DATA_BaseDir = DS.local.SCP_DATA_BaseDir;
        DS.SCP_CODE_BaseDir = DS.local.SCP_CODE_BaseDir;
end


DirectoriesStruct = DS;
end

function [ local, remote ] = fn_select_basedirs( start_dir )
feature('UseOldFileDialogs',1);

% the local folders
local.SCP_CODE_BaseDir = uigetdir(fullfile(start_dir, '..', '..'), 'Please select the local SCP CODE base directory.');
local.SCP_DATA_BaseDir = uigetdir(fullfile(start_dir, '..', '..', '..'), 'Please select the local SCP DATA base directory.');

% the remote directories
msgbox('Make sure to mount the server share containing the remote SCP_DATA directory before proceeding.');
remote.SCP_CODE_BaseDir = uigetdir(fullfile(start_dir, '..', '..'), 'Please select the remote SCP CODE base directory.');
remote.SCP_DATA_BaseDir = uigetdir(fullfile(start_dir, '..', '..', '..'), 'Please select the remote SCP DATA base directory.');

return
end