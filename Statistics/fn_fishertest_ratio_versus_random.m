function [fisher_table] = fn_fishertest_ratio_versus_random( ratio_count )
%FN_FISHERTEST_RATIO_VERSUS_RANDOM Summary of this function goes here
%   Detailed explanation goes here


fisher_table = zeros(2);
fisher_table(:,1) = ratio_count;
odd_number_handling_method = 'increase_by_one'; % increase_by_one, split_unfavorably


if any(isnan(ratio_count))
	disp([mfilename, ': called with NaN value, skipping...']);
	fisher_table = zeros(2); % we return an all zer table as fishertest will error out on NaNs
	return
end

n_total = sum(ratio_count);
switch odd_number_handling_method
	case 'increase_by_one'
		% if odd increase by one to test against 50% ratio
		if mod(n_total, 2)
			n_total = n_total + 1;
		end
		fisher_table(:,2) = [n_total/2, n_total/2];
	case 'split_unfavorably'
		% keep the number the same, but bias in the same direction as ratio
		% is biased which will result in a conservative test.
		if ratio(1) > ratio(2)
			fisher_table(:,2) = [ceil(n_total/2), floor(n_total/2)];
		else
			fisher_table(:,2) = [floor(n_total/2), ceil(n_total/2)];
		end
end

return
end

