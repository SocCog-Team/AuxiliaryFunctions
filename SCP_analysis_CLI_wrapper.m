function [ output_args ] = SCP_analysis_CLI_wrapper( mfile_to_run_string )
%SCP_ANALYSIS_CLI_WRAPPER Summary of this function goes here
%   Detailed explanation goes here
% mfile_to_run_string: this can be the full string to call a matlab
% function with arguments

current_datetime_string = datestr(datetime('now'), 'yyyymmddTHHMMSS');

% use the following if you want individually saved diaries
current_prefix_string = current_datetime_string;
% otherwise use the following
current_prefix_string = 'last_recent.';

if (fnIsMatlabRunningInTextMode())
    current_diary_fqn = fullfile(pwd, [current_prefix_string, mfilename, '.diary.txt']);
    if exist(current_diary_fqn, 'file')
        disp(['Deleting already existing diary file: ', current_diary_fqn]);
        delete(current_diary_fqn);
    end
    diary(current_diary_fqn);
    disp(['Starting to log matlab output to diary file: ', current_diary_fqn, ' starttime: ', current_datetime_string]);

end

% make sure everything is in the path
AddSCPCodeToMatlabPath();

disp(['Trying to evaluate ', mfile_to_run_string]);
eval(mfile_to_run_string);


% to return to the shell we need to exit/quit the current matlab instance
if (fnIsMatlabRunningInTextMode())
    disp(['Stopping to log matlab output to diary file: ', current_diary_fqn]);
    diary off;
    exit
end

end

function [ running_in_text_mode ] = fnIsMatlabRunningInTextMode( input_args )
%FNISMATLABRUNNINGINTEXTMODE is this matlab instance running as textmode
%application
%   Detailed explanation goes here

running_in_text_mode = 0;

if (~usejava('awt'))
    running_in_text_mode = 1;
end

return
end

