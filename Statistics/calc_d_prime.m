function [ d_prime ] = calc_d_prime( in_hit_rate, in_false_alarm_rate )
%CALC_D_PRIME return the d' value for a given pair of hit rate and false
%alarm rate.
%   
% see: http://en.wikipedia.org/wiki/D%27
% d' = Z(hit rate) - Z(false alarm rate)
% where function Z(p), p ? [0,1], is the inverse of the cumulative Gaussian
% distribution.
% no checking performed, will return NaN for any P outside [0,1]
% and Inf for any P equal 1 or 0

if (abs(max([in_hit_rate, in_false_alarm_rate])) > 1)
	disp('One of the specified rates is larger than one, bailing out by returning NaN');
end	

if (min([in_hit_rate, in_false_alarm_rate]) < 0)
	disp('One of the specified rates is negative, bailing out by returning NaN');
end	



% poor man's check for the statistics toolbox, assuming ttest will never be part of matlab base package...	
% might fail if statistics toolbox is installed but not licensed...
if (exist('ttest'))
	%disp('Using the statistics toolbox');
	d_prime = norminv(in_hit_rate) - norminv(in_false_alarm_rate);
else
	%disp('Not using the statistics toolbox');
	d_prime = my_norminv(in_hit_rate) - my_norminv(in_false_alarm_rate);
end
	
return
end


% if no statistics toolbox is available just look at "doc erf"
function [ out_p ] = my_normcdf(in_val)
% only works for z distribution, mean 0 variance 1
	out_p = 0.5 * erfc((-1 * in_val) / sqrt(2));
return
end

function [ out_val ] = my_norminv(in_p)
% only works for z distribution, mean 0 variance 1
	out_val = (-1 * sqrt(2)) * erfcinv(2 * in_p);
return
end