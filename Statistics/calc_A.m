function [ nonpar_A, nonpar_b ] = calc_A( TPR, FPR )
%CALC_A calculate the nonparametric sensitivity measure A, the mean of the
%minimal and maximal possible ROC though a single data point in the 2D
%space spanned by the true positive rate (TPR) on the y-axis and the false
%positive rate (FPR) on the x-axis. (See Zhang and Mueller (2005): A NOTE
%ON ROC ANALYSIS AND NON-PARAMETRIC ESTIMATE OF SENSITIVITY, psychometrika,
%vol. 70, no. 1, 203?212)
%   TPR: ration of correct responses for condition A for all condition A
%   trials
%	FPR: ratio of wrong responses for condition B for all condition B
%	trials (or responses of condition A for a Con B trial)
%
% see: https://web.archive.org/web/20131214050624/https://sites.google.com/a/mtu.edu/whynotaprime/

if length(TPR) ~= length(FPR)
	disp('The true poositive ration and the false positive ration need to be vectors or equal length');
	return;
end
nonpar_A = zeros([size(TPR)]);
nonpar_b = nonpar_A;			% bias measure
for i_group = 1 : length(TPR)
	H = TPR(i_group);
	F = FPR(i_group);
	
	common_nonpar_A = (3/4) + ((H - F) / 4);
	
	if ((F <= 0.5) && (0.5 <= H))
		nonpar_A(i_group) = common_nonpar_A - (F * (1 - H));
		nonpar_b(i_group) = (5 - (4 * H)) / (1 + (4 * F));
	elseif ((F <= H) && (H <= 0.5))
		nonpar_A(i_group) = common_nonpar_A - (F / (4 * H));
		nonpar_b(i_group) = (H^2 + H) / (H^2 + F);
	elseif ((0.5 <= F) && (F <= H))
		nonpar_A(i_group) = common_nonpar_A - ((1 - H) / (4 * (1 - F)));
		nonpar_b(i_group) = ((1 - F)^2 + (1 - H)) / ((1 - F)^2 + (1 - F));
	else
		disp('TPR and FPR both need to be from the inclusive interval [0,1], exiting');
		nonpar_A(i_group) = 0;
		nonpar_b(i_group) = 0;
	end
end

return
end

