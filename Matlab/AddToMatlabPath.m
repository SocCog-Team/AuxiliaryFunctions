function [ output_args ] = AddToMatlabPath( FullyQualifiedDirectoryToAdd, MfileToRun, MfileToOpen )
%ADDTOMATLABPATH Add the current or given path including its sub-folders 
%temporarily to the matlab path.
%		
% AddToMatlabPath( FullyQualifiedDirectoryToAdd, MfileToRun, MfileToOpen )
% FullyQualifiedDirectoryToAdd: if not empty add the directory tree
% starting at that directory to the matlab path, otherwise take the current
% directory.
% MfileToRun: if specified, execute that matlab mfile after adding to the
% matlab path
% MfileToOpen: if specified, open that matlab mfile after adding to the
% matlab path
% Note: This will first remove all entries of the matlab path starting with
% FullyQualifiedDirectoryToAdd to work around the fact that change
% notification on network shares sometimes does not work.


output_args = [];
%CurrentDir = pwd;

% allow empty or missing FullyQualifiedDirectoryToAdd
if ~exist('FullyQualifiedDirectoryToAdd', 'var') || isempty(FullyQualifiedDirectoryToAdd)
	FullyQualifiedDirectoryToAdd = fileparts(mfilename('fullpath'));
end
if ~exist('MfileToRun', 'var') || isempty(MfileToRun)
	MfileToRun = [];
end
if ~exist('MfileToOpen', 'var') || isempty(MfileToOpen)
	MfileToOpen = [];
end

cd(FullyQualifiedDirectoryToAdd);
CurrentMatlabPath = path;


PathToAddIsAlreadyDefined = strfind(CurrentMatlabPath, [FullyQualifiedDirectoryToAdd, pathsep]);

% delete existing paths containing the calling directory
% this is a work around for matlab's inability to detect changed files on
% many network shares (especially windows)
if ~isempty(PathToAddIsAlreadyDefined)
	% turn the path into cell array
	while length(CurrentMatlabPath) > 0
		[CurrentPathItem, remain] = strtok(CurrentMatlabPath, ';:');
		CurrentMatlabPath = remain(2:end);
		if ~isempty(strfind(CurrentPathItem, FullyQualifiedDirectoryToAdd))
			rmpath(CurrentPathItem);
		end
	end
end
% now add them again
addpath(genpath(pwd()));


if ~isempty(MfileToOpen)
	open(MfileToOpen);
end

if ~isempty(MfileToRun)
	run(MfileToOpen);
end
return
