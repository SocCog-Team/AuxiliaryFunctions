function [ out_matching_item_ldx ] = fn_find_regexpmatch_entries_in_cell_list( cell_list, regexp_match_pattern_list, multi_pattern_mode_string )
%FN_FIND_REGEXPMATCH_ENTRIES_IN_CELL_LIST Summary of this function goes here
%   Detailed explanation goes here


%cur_Channel_Classfication_col_names = fieldnames(cur_Channel_Classfication_table);
%matching_col_ldx = fn_find_regexpmatch_entries_in_cell_list(cur_Channel_Classfication_col_names, ['^[A|B]_', cur_subject_name, '_*'])

% make sure this is a cell list
if ~iscell(regexp_match_pattern_list)
	regexp_match_pattern_list = {regexp_match_pattern_list};
end

if ~exist('multi_pattern_mode_string', 'var') || isempty(multi_pattern_mode_string)
	multi_pattern_mode_string = 'add';
end

switch multi_pattern_mode_string
	case 'add'
		%out_matching_item_ldx = logical((1:1:length(cell_list)));
		%out_matching_item_ldx = logical(ones([1, length(cell_list)]));
		% we start with none...
		out_matching_item_ldx = logical(zeros([1, length(cell_list)]));
	otherwise
		error([mfilename, ': unknown multi_pattern_mode_string: ', multi_pattern_mode_string]);
end



n_patterns = length(regexp_match_pattern_list);
%out_matching_item_ldx = logical((1:1:length(cell_list)));

% note we will just add the

for i_pattern = 1 : n_patterns
	regexp_match_pattern = regexp_match_pattern_list{i_pattern};

	n_items = length(cell_list);
	% unclude all by default and remove the non matches?
	matching_item_ldx = logical((1:1:length(cell_list)));

	for i_item = 1 : n_items

		if isempty(regexp(cell_list{i_item}, regexp_match_pattern))
			matching_item_ldx(i_item) = 0;
		end

	end
	switch multi_pattern_mode_string
		case 'add'
			out_matching_item_ldx = out_matching_item_ldx | matching_item_ldx;
		otherwise
			error([mfilename, ': unknown multi_pattern_mode_string: ', multi_pattern_mode_string]);
	end

end

end

