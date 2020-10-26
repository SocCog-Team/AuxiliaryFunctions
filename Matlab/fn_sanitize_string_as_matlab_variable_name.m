function [ sanitized_string ] = fn_sanitize_string_as_matlab_variable_name( raw_string )
%FN_SANITIZE_STRING_AS_MATLAB_VARIABLE_NAME Summary of this function goes here

sanitized_string = [];

if length(raw_string) > 64
    disp('Input string is longer then the max. 64 characters matlab uses as variable name.');
    disp(raw_string);
    sanitized_string = [];
    return
end


% some characters are not really helpful inside matlab variable names, so
% replace them with something that should not cause problems
taboo_char_list =		{' ', '-', '.', '=', '/'};
replacement_char_list = {'_', '_', '_dot_', '_eq_', '_'};

% and some characters are not permitted as first char, like underscores or
% numbers
taboo_first_char_list = {'_', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
replacement_first_char_list = {'US', 'Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'};

sanitized_string = raw_string;
% check first character to not be a number
taboo_first_char_idx = find(ismember(taboo_first_char_list, raw_string(1)));
if ~isempty(taboo_first_char_idx)
	sanitized_string = [replacement_first_char_list{taboo_first_char_idx}, raw_string(2:end)];
end



for i_taboo_char = 1: length(taboo_char_list)
	current_taboo_string = taboo_char_list{i_taboo_char};
	current_replacement_string = replacement_char_list{i_taboo_char};
	current_taboo_processed = 0;
	remain = sanitized_string;
	tmp_string = '';
	while (~current_taboo_processed)
		[token, remain] = strtok(remain, current_taboo_string);
		tmp_string = [tmp_string, token, current_replacement_string];
		if isempty(remain)
			current_taboo_processed = 1;
			% we add one superfluous replaceent string at the end, so
			% remove that
			tmp_string = tmp_string(1:end-length(current_replacement_string));
		end
	end
	sanitized_column_name = tmp_string;
end

if (strcmp(raw_string, ' '))
	sanitized_string = 'EmptyString';
	disp('Found empty string as column/variable name, replacing with "EmptyString"...');
end

if length(sanitized_string) > 64
    disp('Proto-output string is longer then the max. 64 characters matlab uses as variable name.');
    disp(sanitized_string);
    sanitized_string = [];
    return
end

return
end

