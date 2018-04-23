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
    diary(fullfile(pwd, [current_prefix_string, mfilename, '.diary.txt']));
end

% make sure everything is in the path
AddSCPCodeToMatlabPath();

disp(['Trying to evaluate ', mfile_to_run_string]);
eval(mfile_to_run_string);


% to return to the shell we need to exit/quit the current matlab instance
if (fnIsMatlabRunningInTextMode())
    diary off;
    exit
end

end

function [ running_in_text_mode ] = fnIsMatlabRunningInTextMode( input_args )
%FNISMATLABRUNNINGFROMCLI is this matlab instance running as textmode
%application
%   Detailed explanation goes here

running_in_text_mode = 0;

if (~usejava('awt'))
    running_in_text_mode = 1;
end

return
end

