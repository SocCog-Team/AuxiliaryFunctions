function [ ] = fn_disp_overwrite(message_string, n_chars_to_overwrite)
%FN_DISP_OVERWRITE Summary of this function goes here
%   Detailed explanation goes here

ASCII_BACKSPACE_CODE = 8;

persistent last_message_length
if isempty(last_message_length)
	last_message_length = 0;
end

if exist('n_chars_to_overwrite', 'var') && ~isempty(n_chars_to_overwrite)
	last_message_length = n_chars_to_overwrite;
end

disp([ char(repmat(ASCII_BACKSPACE_CODE, 1, last_message_length)) message_string]);

last_message_length = numel(message_string) + 1;
end

