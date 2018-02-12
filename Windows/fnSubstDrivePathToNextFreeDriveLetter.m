function [ SubstitutedDriveLetter ] = fnSubstDrivePathToNextFreeDriveLetter(input_file_FQN, subst_finalpathcomponent_string, mode_string)
%FNSUBSTDRIVEPATHTONEXTFREEDRIVELETTER try to use windows subst to create a
%"drive letter" for the given path
%already assigned
%   Detailed explanation goes here

SubstitutedDriveLetter = [];
if (ispc)    
    if ~exist('mode_string', 'var') || isempty(mode_string)
        mode_string = '';
    end
    
    if ~isempty(subst_finalpathcomponent_string)
        subst_anchor_idx = strfind(input_file_FQN, subst_finalpathcomponent_string);
        subst_anchor_string = input_file_FQN(1:(subst_anchor_idx(1) + length(subst_finalpathcomponent_string) - 1));
    else
        if isdir(input_file_FQN)
            subst_anchor_string = input_file_FQN;
        end
    end
    
    PossibleDiveLetterList = {  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',...
                                'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
      
    for i_ProtoSubstitutedDriveLetter = 1 : length(PossibleDiveLetterList)
        current_SubstitutedDriveLetter = [PossibleDiveLetterList{i_ProtoSubstitutedDriveLetter}, ':'];
        [subst_status, subst_output] = system(['subst ', current_SubstitutedDriveLetter, ' ', subst_anchor_string]);
        if (subst_status == 0)
            % we found our candidate
            SubstitutedDriveLetter = current_SubstitutedDriveLetter;
            if (strcmp(mode_string, 'delete'))
                [subst_status, subst_output] = system(['subst ', current_SubstitutedDriveLetter, ' /d']);
            end
            break
        end       
    end
end

    return
end

