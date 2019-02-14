function [ output_rect ] = fnFormatPaperSize( type, gcf_h, fraction, do_center_in_paper )
%FNFORMATPAPERSIZE Set the paper size for a plot, also return a reasonably
%tight output_rect.
% 20070827sm: changed default output formatting to allow pretty paper output
% Example usage:
%     Cur_fh = figure('Name', 'Test');
%     fnFormatDefaultAxes('16to9slides');
%     [output_rect] = fnFormatPaperSize('16to9landscape', gcf);
%     set(gcf(), 'Units', 'centimeters', 'Position', output_rect);


if nargin < 3
    fraction = 1;	% fractional columns?
end
if nargin < 4
    do_center_in_paper = 0;	% center the rectangle in the page
end


nature_single_col_width_cm = 8.9;
nature_double_col_width_cm = 18.3;
nature_full_page_width_cm = 24.7;

A4_w_cm = 21.0;
A4_h_cm = 29.7;
% defaults
left_edge_cm = 1;
bottom_edge_cm = 2;

switch type
    
    case {'BoS_manuscript.5'}
        left_edge_cm = 0.05;
        bottom_edge_cm = 0.05;
        dpz_column_width_cm = 38.6 * 0.5 * 0.8;   % the columns are 38.6271mm, but the imported pdf in illustrator are too large (0.395)
        rect_w = (dpz_column_width_cm - 2*left_edge_cm) * fraction;
        rect_h = ((dpz_column_width_cm * 610/987) - 2*bottom_edge_cm) * fraction; % 610/987 approximates the golden ratio
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm*fraction rect_h+2*bottom_edge_cm*fraction], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
        
    case {'PrimateNeurobiology2018DPZ0.5', 'SfN2018.5'}
        left_edge_cm = 0.05;
        bottom_edge_cm = 0.05;
        dpz_column_width_cm = 38.6 * 0.5 * 0.8;   % the columns are 38.6271mm, but the imported pdf in illustrator are too large (0.395)
        rect_w = (dpz_column_width_cm - 2*left_edge_cm) * fraction;
        rect_h = ((dpz_column_width_cm * 610/987) - 2*bottom_edge_cm) * fraction; % 610/987 approximates the golden ratio
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm*fraction rect_h+2*bottom_edge_cm*fraction], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
     
   case 'PrimateNeurobiology2018DPZ'
        left_edge_cm = 0.05;
        bottom_edge_cm = 0.05;
        dpz_column_width_cm = 38.6 * 0.8;   % the columns are 38.6271mm, but the imported pdf in illustrator are too large (0.395)
        rect_w = (dpz_column_width_cm - 2*left_edge_cm) * fraction;
        rect_h = ((dpz_column_width_cm * 610/987) - 2*bottom_edge_cm) * fraction; % 610/987 approximates the golden ratio
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm*fraction rect_h+2*bottom_edge_cm*fraction], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
 
   case 'DPZ2017Evaluation'
        left_edge_cm = 0.05;
        bottom_edge_cm = 0.05;
        dpz_column_width_cm = 34.7 * 0.8;   % the columns are 347, 350, 347 mm, but the imported pdf in illustrator are too large (0.395)
        rect_w = (dpz_column_width_cm - 2*left_edge_cm) * fraction;
        rect_h = ((dpz_column_width_cm * 610/987) - 2*bottom_edge_cm) * fraction; % 610/987 approximates the golden ratio
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm*fraction rect_h+2*bottom_edge_cm*fraction], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
    
    case '16to9portrait'
        left_edge_cm = 1;
        bottom_edge_cm = 1;
        rect_w = (9 - 2*left_edge_cm) * fraction;
        rect_h = (16 - 2*bottom_edge_cm) * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm rect_h+2*bottom_edge_cm], 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters');
 
    case '16to9landscape'
        left_edge_cm = 1;
        bottom_edge_cm = 1;
        rect_w = (16 - 2*left_edge_cm) * fraction;
        rect_h = (9 - 2*bottom_edge_cm) * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        set(gcf_h, 'PaperSize', [rect_w+2*left_edge_cm rect_h+2*bottom_edge_cm], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
        
    case 'ms13_paper'
        rect_w = nature_single_col_width_cm * fraction;
        rect_h = nature_single_col_width_cm * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        %set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        % try to manage plots better
        set(gcf_h, 'PaperSize', [rect_w rect_h], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
        
    case 'ms13_paper_unitdata'
        rect_w = nature_single_col_width_cm * fraction;
        rect_h = nature_single_col_width_cm * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        % configure the format PaperPositon [left bottom width height]
        %set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        set(gcf_h, 'PaperSize', [rect_w rect_h], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
        
    case 'ms13_paper_unitdata_halfheight'
        rect_w = nature_single_col_width_cm * fraction;
        rect_h = nature_single_col_width_cm * fraction * 0.5;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        % configure the format PaperPositon [left bottom width height]
        %set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        set(gcf_h, 'PaperSize', [rect_w rect_h], 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters');
        
        
    case 'fp_paper'
        rect_w = 4.5 * fraction;
        rect_h = 1.835 * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_w_cm - rect_w) * 0.5;
            bottom_edge_cm = (A4_h_cm - rect_h) * 0.5;
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        % configure the format PaperPositon [left bottom width height]
        set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'sfn_poster'
        rect_w = 27.7 * fraction;
        rect_h = 12.0 * fraction;
        % configure the format PaperPositon [left bottom width height]
        if (do_center_in_paper)
            left_edge_cm = (A4_h_cm - rect_w) * 0.5;	% landscape!
            bottom_edge_cm = (A4_w_cm - rect_h) * 0.5;	% landscape!
        end
        output_rect = [left_edge_cm bottom_edge_cm rect_w rect_h];	% left, bottom, width, height
        %output_rect = [1.0 2.0 27.7 12.0];	% full width
        % configure the format PaperPositon [left bottom width height]
        set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'sfn_poster_0.5'
        output_rect = [1.0 2.0 (25.9/2) 8.0];	% half width
        output_rect = [1.0 2.0 11.0 10.0];	% height was (25.9/2)
        % configure the format PaperPositon [left bottom width height]
        %set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'sfn_poster_0.5_2012'
        output_rect = [1.0 2.0 (25.9/2) 8.0];	% half width
        output_rect = [1.0 2.0 11.0 9.0];	% height was (25.9/2)
        % configure the format PaperPositon [left bottom width height]
        %set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'europe'
        output_rect = [1.0 2.0 27.7 12.0];
        set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'europe_portrait'
        output_rect = [1.0 2.0 20.0 27.7];
        set(gcf_h, 'PaperType', 'A4', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'default'
        % letter 8.5 x 11 ", or 215.9 mm ? 279.4 mm
        output_rect = [1.0 2.0 19.59 25.94];
        set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    case 'default_portrait'
        output_rect = [1.0 2.0 25.94 19.59];
        set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'portrait', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
    otherwise
        output_rect = [1.0 2.0 25.9 12.0];
        set(gcf_h, 'PaperType', 'usletter', 'PaperOrientation', 'landscape', 'PaperUnits', 'centimeters', 'PaperPosition', output_rect);
        
end

return
end
