function [ AssignedWinDriveLettersList ] = fnGetWindowsDriveLetterList()     
%FNGETWINDOWSDRIVELETTERLIST get a list of the currently assigned drive
%letters.
%   Detailed explanation goes here
    [system_status, AssignedWinDriveLetters] = system('wmic logicaldisk get caption');
        % this might need checking for sanity
        colon_idx = strfind(AssignedWinDriveLetters, ':');
        AssignedWinDriveLettersList = cell(size(colon_idx));
        for i_colon = 1 : length(colon_idx)
            AssignedWinDriveLettersList{i_colon} = AssignedWinDriveLetters(colon_idx(i_colon)-1);
        end
return 
end


