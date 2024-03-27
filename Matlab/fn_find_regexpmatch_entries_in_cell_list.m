function [ matching_item_ldx ] = fn_find_regexpmatch_entries_in_cell_list( cell_list, regexp_match_pattern )
%FN_FIND_REGEXPMATCH_ENTRIES_IN_CELL_LIST Summary of this function goes here
%   Detailed explanation goes here


%cur_Channel_Classfication_col_names = fieldnames(cur_Channel_Classfication_table);
%matching_col_ldx = fn_find_regexpmatch_entries_in_cell_list(cur_Channel_Classfication_col_names, ['^[A|B]_', cur_subject_name, '_*'])


n_items = length(cell_list);
matching_item_ldx = logical((1:1:length(cell_list)));

for i_item = 1 : n_items
	
	if isempty(regexp(cell_list{i_item}, regexp_match_pattern))
		matching_item_ldx(i_item) = 0;
	end

end

end

