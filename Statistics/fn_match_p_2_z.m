function [ out_p, out_z ] = fn_match_p_2_z( in_p, in_z, sidedness )
%FN_MATCH_P_2_Z calculate ither p for a given z or z for a given p, return
%both
%   There must be 1001 versions of this functionality, here is mine...
% see http://en.wikipedia.org/wiki/Error_function for references and
% solutions
%
% TODO:
%	implement persistent memory of aleady calculated values to speed things
%	up...
%
% 20121018sm:
% use erf and erfinv instead, they are part of matlab already...


out_p = [];
out_z = [];

if (nargin < 3)
	disp(['Please specify either P or Z value (give [] for the desired parameter) and sidedness (either 1 or 2)...']);
	return
end
	
if isempty(in_p) & isempty(in_z)
	disp('Neither p nor z given, nothing to do');
	return
end

% p is given, calculate z
if ~isempty(in_p) & isempty(in_z)
	disp('Calculating Z from P');
	% Z is the value of the standard normal curve at which the fraction of
	% the curve left thereof equals P
	
end

% z is given, calculate p
if isempty(in_p) & ~isempty(in_z)
	disp('Calculating P from Z');
	% P is the fraction of the standard normal curve up to the requested Z
	% value
	
	
end



return
end