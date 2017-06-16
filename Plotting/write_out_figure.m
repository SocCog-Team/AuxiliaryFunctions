function [ ret_val ] = write_out_figure(img_fh, outfile_fqn, verbosity_str)
%WRITE_OUT_FIGURE save the figure referenced by img_fh to outfile_fqn,
% using .ext of outfile_fqn to decide which image type to save as.
%   Detailed explanation goes here
% write out the data

if ~exist('verbosity_str', 'var')
	verbosity_str = 'verbose';
end


% check whether the path exists, create if not...
[pathstr, name, img_type] = fileparts(outfile_fqn);
if isempty(dir(pathstr)),
	mkdir(pathstr);
end

switch img_type(2:end)
	case 'pdf'
		% pdf in 7.3.0 is slightly buggy...
		print(img_fh, '-dpdf', outfile_fqn);
	case 'ps'
		print(img_fh, '-depsc2', outfile_fqn);
	case {'tiff', 'tif'}
		% tiff creates a figure
		print(img_fh, '-dtiff', outfile_fqn);
	case 'png'
		% tiff creates a figure
		print(img_fh, '-dpng', outfile_fqn);
	case 'fig'	
		%sm: allows to save figures for further refinements
		saveas(img_fh, outfile_fqn, 'fig');		
	case 'eps'
		print (img_fh, '-depsc', '-r300', outfile_fqn); 
	otherwise
		% default to uncompressed images
		disp(['Image type: ', img_type, ' not handled yet...']);
		% write out the mosaic as image, sadly the compression does not work...
		% 		imwrite(mos, [outfile_fqn, '.tif'], format, 'Compression', 'none');
end

if strcmp(verbosity_str, 'verbose')
	if ~isnumeric(img_fh)
		disp(['Saved figure (', num2str(img_fh.Number), ') to: ', outfile_fqn]);	% >R2014b have structure figure handles
	else
		disp(['Saved figure (', num2str(img_fh), ') to: ', outfile_fqn]);			% older Matlab has numeric figure handles
	end
end
ret_val = 0;
return
end
