% [p, observeddifference, effectsize, exact] = fn_permutationTest_by_measure(sample1, sample2, permutations [, varargin])
%
%       Permutation test (aka randomisation test), testing for a difference
%       in means between two samples. 
%
% In:
%       sample1 - vector of measurements from one (experimental) sample
%       sample2 - vector of measurements from a second (control) sample
%       permutations - the number of permutations
%
% Optional (name-value pairs):
%       sidedness - whether to test one- or two-sided:
%           'both' - test two-sided (default)
%           'smaller' - test one-sided, alternative hypothesis is that
%                       the mean of sample1 is smaller than the mean of
%                       sample2
%           'larger' - test one-sided, alternative hypothesis is that
%                      the mean of sample1 is larger than the mean of
%                      sample2
%       exact - whether or not to run an exact test, in which all possible
%               combinations are considered. this is only feasible for
%               relatively small sample sizes. the 'permutations' argument
%               will be ignored for an exact test. (1|0, default 0)
%				SM: exact will be forced if permutations == 0, otherwise it
%				will just beused if it results in fewer "permutations"
%       plotresult - whether or not to plot the distribution of randomised
%                    differences, along with the observed difference (1|0,
%                    default: 0)
%       showprogress - whether or not to show a progress bar. if 0, no bar
%                      is displayed; if showprogress > 0, the bar updates 
%                      every showprogress-th iteration.
%
%	measure - which measure to use to compare the two groups
%	     	   meandifference (default), ranksum
%
% Out:  
%       p - the resulting p-value
%       observeddifference - the observed difference between the two
%                            samples, i.e. mean(sample1) - mean(sample2)
%       effectsize - the effect size, Hedges' g
%
% Usage example:
%       >> permutationTest(rand(1,100), rand(1,100)-.25, 10000, ...
%          'plotresult', 1, 'showprogress', 250)
% 
%                    Copyright 2015-2018, 2021 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology
% from https://github.com/lrkrol/permutationTest
% 2021-01-13 lrk
%   - Replaced effect size calculation with Hedges' g, from Hedges & Olkin
%     (1985), Statistical Methods for Meta-Analysis (p. 78, formula 3),
%     Orlando, FL, USA: Academic Press.
% 2020-07-14 lrk
%   - Added version-dependent call to hist/histogram
% 2019-02-01 lrk
%   - Added short description
%   - Increased the number of bins in the plot
% 2018-03-15 lrk
%   - Suppressed initial MATLAB:nchoosek:LargeCoefficient warning
% 2018-03-14 lrk
%   - Added exact test
% 2018-01-31 lrk
%   - Replaced calls to mean() with nanmean()
% 2017-06-15 lrk
%   - Updated waitbar message in first iteration
% 2017-04-04 lrk
%   - Added progress bar
% 2017-01-13 lrk
%   - Switched to inputParser to parse arguments
% 2016-09-13 lrk
%   - Caught potential issue when column vectors were used
%   - Improved plot
% 2016-02-17 toz
%   - Added plot functionality
% 2015-11-26 First version

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


function [p, observeddifference, effectsize, exact] = fn_permutationTest_by_measure(sample1, sample2, permutations, varargin)

% parsing input
p = inputParser;

addRequired(p, 'sample1', @isnumeric);
addRequired(p, 'sample2', @isnumeric);
addRequired(p, 'permutations', @isnumeric);

addParamValue(p, 'sidedness', 'both', @(x) any(validatestring(x,{'both', 'smaller', 'larger'})));
addParamValue(p, 'exact' , 0, @isnumeric);
addParamValue(p, 'plotresult', 0, @isnumeric);
addParamValue(p, 'showprogress', 0, @isnumeric);
addParamValue(p, 'measure', 'meandifference', @(y) any(validatestring(y, {'meandifference', 'ranksum'})));


parse(p, sample1, sample2, permutations, varargin{:})

sample1 = p.Results.sample1;
sample2 = p.Results.sample2;
permutations = p.Results.permutations;
sidedness = p.Results.sidedness;
exact = p.Results.exact;
plotresult = p.Results.plotresult;
showprogress = p.Results.showprogress;
measure = p.Results.measure;


% enforcing row vectors
if iscolumn(sample1), sample1 = sample1'; end
if iscolumn(sample2), sample2 = sample2'; end

allobservations = [sample1, sample2];

switch measure
	case 'meandifference'
		observeddifference = nanmean(sample1) - nanmean(sample2);
		pooledstd = sqrt(  ( (numel(sample1)-1)*std(sample1)^2 + (numel(sample2)-1)*std(sample2)^2 )  /  ( numel(allobservations)-2 )  );
		effectsize = observeddifference / pooledstd;
	case 'ranksum'
		[pval, ~, ranksum_stats] = ranksum(sample1, sample2, 'method', 'exact');
		observeddifference = ranksum_stats.ranksum;
		[~, ~, ranksum_stats] = ranksum(sample1, sample2, 'method', 'approximate');
		pooledstd = NaN;
		effectsize = ranksum_stats.zval / sqrt((sum(~isnan(sample1)) + sum(~isnan(sample2))));
end

w = warning('off', 'MATLAB:nchoosek:LargeCoefficient');
if ~exact && permutations > nchoosek(numel(allobservations), numel(sample1))
    warning(['the number of permutations (%d) is higher than the number of possible combinations (%d);\n' ...
             'consider running an exact test using the ''exact'' argument'], ...
             permutations, nchoosek(numel(allobservations), numel(sample1)));
	disp('Automagically switching to exact test...');
	exact = 1;
end
warning(w);

if showprogress, w = waitbar(0, 'Preparing test...', 'Name', 'permutationTest'); end

requested_permutations = permutations;
if exact
    % getting all possible combinations
	try
		allcombinations = nchoosek(1:numel(allobservations), numel(sample1));
		permutations = size(allcombinations, 1);
	catch ME
		disp([mfilename, ': Too many combinations for exact test, reverting to sampling instead (', num2str(requested_permutations), ' permutations).']);
		exact = 0;
		permutations = requested_permutations;
	end
end

if (permutations ==0 )
		disp([mfilename, ': Too many combinations for exact test, but 0 permutations requested (force exact), skipping']);
		p = [];
		return
end

% we really only want the potentially costly exact method when we can not
% reach the desired number of permutations without resampling...
if permutations > requested_permutations
	disp([mfilename, ': requested permutations: ', num2str(requested_permutations), ' planned permutations: ', num2str(permutations)]);
	if requested_permutations > 0
		disp([mfilename, ': reverting to sampling of requested number of permutations']);
		exact = 0;
		permutations = requested_permutations;
	else
		disp([mfilename, ': sticking to exact...']);
	end
end
if permutations < requested_permutations
	disp([mfilename, ': requested permutations: ', num2str(requested_permutations), ' planned permutations: ', num2str(permutations), ' using exact method']);
end

% running test
randomdifferences = zeros(1, permutations);
if showprogress, waitbar(0, w, sprintf('Permutation 1 of %d', permutations), 'Name', 'permutationTest'); end
for n = 1:permutations
    if showprogress && mod(n,showprogress) == 0, waitbar(n/permutations, w, sprintf('Permutation %d of %d', n, permutations)); end
    
    % selecting either next combination, or random permutation
    if exact, permutation = [allcombinations(n,:), setdiff(1:numel(allobservations), allcombinations(n,:))];
    else, permutation = randperm(length(allobservations)); end
    
    % dividing into two samples
    randomSample1 = allobservations(permutation(1:length(sample1)));
    randomSample2 = allobservations(permutation(length(sample1)+1:length(permutation)));
    
    % saving differences between the two samples
	switch measure
		case 'meandifference'
			randomdifferences(n) = nanmean(randomSample1) - nanmean(randomSample2);
		case 'ranksum'
			% the exact ranksum test is pretty slow, see whether the approximte one is fast enough 
			[~, ~, ranksum_stats] = ranksum(randomSample1, randomSample2, 'method', 'approximate');
			randomdifferences(n) = ranksum_stats.ranksum;
			% or calculate the test statistik by hand
% 			r = avrRank([randomSample1, randomSample2]);
% 			n1 = length(randomSample1);
% 			n2 = length(randomSample2);
% 			R1 = sum(r(1:n1));
% 			R2 = sum(r(n1+1:end));
% 			U1 = R1 - ((n1*(n1+1))/(2));
% 			U2 = (n1 * n2) - U1;
% 			randomdifferences(n) = min([U1, U2]);
	end
end
if showprogress, delete(w); end

switch measure
	case 'meandifference'
		% getting probability of finding observed difference from random permutations
		if strcmp(sidedness, 'both')
		    p = (length(find(abs(randomdifferences) > abs(observeddifference)))+1) / (permutations+1);
		elseif strcmp(sidedness, 'smaller')
		    p = (length(find(randomdifferences < observeddifference))+1) / (permutations+1);
		elseif strcmp(sidedness, 'larger')
		 p = (length(find(randomdifferences > observeddifference))+1) / (permutations+1);
		end
	case 'ranksum'
		% getting probability of finding observed ranksum from random permutations
		% mean differences aresupposed to be zero based, ranksums however
		% are positive, so demean both
		mean_random_ranksum = mean(randomdifferences);
		if strcmp(sidedness, 'both')
		    p = (length(find(abs(randomdifferences - mean_random_ranksum) > abs(observeddifference - mean_random_ranksum)))+1) / (permutations+1);
		elseif strcmp(sidedness, 'smaller')
		    p = (length(find((randomdifferences - mean_random_ranksum) < (observeddifference - mean_random_ranksum)))+1) / (permutations+1);
		elseif strcmp(sidedness, 'larger')
		 p = (length(find((randomdifferences - mean_random_ranksum) > (observeddifference - mean_random_ranksum)))+1) / (permutations+1);
		end
end

% plotting result
if plotresult
    figure;
    if verLessThan('matlab', '8.4')
        % MATLAB R2014a and earlier
        hist(randomdifferences, 20);
    else
        % MATLAB R2014b and later
        histogram(randomdifferences, 20);
    end
    hold on;
    xlabel('Random differences');
    ylabel('Count')
    od = plot(observeddifference, 0, '*r', 'DisplayName', sprintf('Observed difference.\nEffect size: %.2f,\np = %f', effectsize, p));
    legend(od);
end

end


function r = avrRank( x )
%AVRRANK Returns the sample ranks of the values in a vector. In case of ties
% (i.e., equal values) and missing values it computes their average rank.
%  
% INPUT:
%  x - any row or column vector, may be integer, character
%      or floating point. 
%
% OUTPUT:
%  r - vector of corresponding ranks for each element in x tied elements
%      are given an average rank for all tied elements.
%      
% SEE ALSO:
%  * rankt - package at 
%          http://www.mathworks.com/matlabcentral/fileexchange/27701-rankt
%  * FractionalRankings from Rankings toolbox
%          http://www.mathworks.com/matlabcentral/fileexchange/19496 
%  * tiedrank from MATLAB Statistics Toolbox
%  * rank function in EXCEL
%  * rank function in R language
%
% EXAMPLE:
% x = round(rand(1,10)*5);
% r = avrrank(x);
% disp([x;r])
%     3	  5    2	 1	 5	 0	 3	 2	 5	 0
%    6.5 9.0	4.5	3.0	9.0	1.5	6.5	4.5	9.0	1.5	
%
% Written by Jarek Tuszynski, SAIC, jaroslaw.w.tuszynski_at_saic.com
% Code covered by BSD License
%% Sort and create ranks array
[sx, sortidx] = sort(x(:));
nNaN  = sum(isnan(x));                 % number of NAN's in the array
nx    = numel(x) - nNaN;               % length of x without NAN's
ranks = [1:nx NaN(1,nNaN)]';           % push NAN's to the end
%% Adjust for ties by averaging their ranks
pos = 1;
while pos<nx
  while (pos<nx && sx(pos)~=sx(pos+1)), pos=pos+1; end 
  tieStart = pos;   % search until next tie is found
  while (pos<nx && sx(pos)==sx(pos+1)), pos=pos+1; end
  tieEnd   = pos;   % end of sequence of ties is found
  idx = tieStart : tieEnd;
  ranks(idx) = mean(ranks(idx)); % replace ranks with average ranks
end
%% Prepare output
r(sortidx) = ranks;
r = reshape(r,size(x));                % reshape to match input
return 
end