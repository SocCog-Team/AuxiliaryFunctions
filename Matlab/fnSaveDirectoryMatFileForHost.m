function [ output_args ] = fnSaveDirectoryMatFileForHost( local_SCP_DATA_BaseDir, local_SCP_CODE_BaseDir, remote_SCP_DATA_BaseDir, remote_SCP_CODE_BaseDir )
%FNSAVEDIRECTORYMATFILEFORHOST Summary of this function goes here
%   This can be used to create a cononical per-host directory definition
%   mat file

% get the directory this mfile lives in
[current_dir, ~, ~] = fileparts(mfilename('fullpath'));

if ~exist('local_SCP_DATA_BaseDir', 'var')
    local_SCP_DATA_BaseDir = fullfile('C:');
end
local.SCP_DATA_BaseDir = local_SCP_DATA_BaseDir;

if ~exist('local_SCP_CODE_BaseDir', 'var')
    local_SCP_CODE_BaseDir = fullfile('C:', 'SCP_CODE');
end
local.SCP_CODE_BaseDir = local_SCP_CODE_BaseDir;


if ~exist('remote_SCP_DATA_BaseDir', 'var')
    remote_SCP_DATA_BaseDir = fullfile('Z:', 'taskcontroller');
end
remote.SCP_DATA_BaseDir = remote_SCP_DATA_BaseDir;

if ~exist('remote_SCP_CODE_BaseDir', 'var')
    remote_SCP_CODE_BaseDir = fullfile(remote.SCP_DATA_BaseDir, 'CODE');
end
remote.SCP_CODE_BaseDir = remote_SCP_CODE_BaseDir;


[sys_status, host_name] = system('hostname');
host_name = host_name(1:end-1); % last char of host name result is ascii 10 (LF)
CurrentHostName = strtrim(host_name);
CurrentShortHostName = CurrentHostName; % if the hostnmae has no domain part these two are the same

% extract the short host name by removing the domain parts
dot_idx=strfind(CurrentHostName, '.');
if ~isempty(dot_idx)
    CurrentShortHostName = CurrentHostName(1:dot_idx(1)-1);
end

disp(['Saving directory definitions to ', fullfile(current_dir, [CurrentShortHostName, '.mat'])]);
save(fullfile(current_dir, [CurrentShortHostName, '.mat']), 'local', 'remote');

end

