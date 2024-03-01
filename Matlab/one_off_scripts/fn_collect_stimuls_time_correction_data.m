function [ ] = fn_collect_stimuls_time_correction_data( )
%FN_COLLECT_STIMULS_TIME_CORRECTION_DATA Summary of this function goes here
%   Detailed explanation goes here


sessiondir_list = {...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210423', '20210423T105645.A_Elmo.B_KN.SCP_01.sessiondir'), ...		% SemiSolo
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2023', '230705', '20230705T134053.A_Curius.B_RS.SCP_01.sessiondir'), ...		% SemiSolo blocked/shuffled
	...%fullfile('F:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210416', '20210416T105525.A_Elmo.B_KN.SCP_01.sessiondir'), ...		% SemiSolo
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210416', '20210416T105525.A_Elmo.B_KN.SCP_01.sessiondir'), ...		% SemiSolo
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2023', '230616', '20230616T094811.A_Curius.B_VC.SCP_01.sessiondir'), ...		% SoloBRewardAB
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2020', '201218', '20201218T130348.A_Elmo.B_FS.SCP_01.sessiondir'), ...		% SoloBRewardAB
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2023', '230623', '20230623T124557B.A_Curius.B_Elmo.SCP_01.sessiondir'), ...	% SoloXRewardAB
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2023', '230623', '20230623T124557.A_Curius.B_Elmo.SCP_01.sessiondir'), ...	% SoloXRewardAB
	...%fullfile('G:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210127', '20210127T130717.A_Elmo.B_FS.SCP_01.sessiondir'), ...
 	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210127', '20210127T130717.A_Elmo.B_FS.SCP_01.sessiondir'), ...
	...%fullfile('D:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210219', '20210219T145809.A_Elmo.B_DL.SCP_01.sessiondir'), ...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210219', '20210219T145809.A_Elmo.B_DL.SCP_01.sessiondir'), ...		% Shuffled/Blocked
	...%fullfile('E:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210423', '20210423T105645.A_Elmo.B_KN.SCP_01.sessiondir'), ...
	...%fullfile('G:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210205', '20210205T151709.A_Elmo.B_DL.SCP_01.sessiondir'), ...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210205', '20210205T151709.A_Elmo.B_DL.SCP_01.sessiondir'), ...		% Shuffled only
	...%fullfile('F:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2020', '201218', '20201218T130348.A_Elmo.B_FS.SCP_01.sessiondir'), ...
	...%fullfile('D:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '211006', '20211006T143535.A_Elmo.B_None.SCP_01.sessiondir'), ...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '211006', '20211006T143535.A_Elmo.B_None.SCP_01.sessiondir'), ...
	...%fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '211006', '20211006T143535.A_Elmo.B_None.SCP_01.sessiondir'), ...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2021', '210129', '20210129T150949.A_Elmo.B_FS.SCP_01.sessiondir'), ...
	fullfile('Y:', 'SCP_DATA', 'SCP-CTRL-01', 'SESSIONLOGS', '2023', '230406', '20230406T152452.A_Curius.B_AE.SCP_01.sessiondir'), ...
	};

%maybe use find_all to collect this over all sessions?


% corrected_col_name_list = {	...
% 	'A_InitialFixationOnsetTime_ms', ...
% 	'B_InitialFixationOnsetTime_ms', ...
% 	'A_TargetOnsetTime_ms', ...
% 	'B_TargetOnsetTime_ms', ...
% 	'A_TargetOffsetTime_ms', ...
% 	'B_TargetOffsetTime_ms', ...
% 	'A_GoSignalTime_ms', ...
% 	'B_GoSignalTime_ms',...
% };

corrected_col_name_list = {	...
	'A_InitialFixationOnsetTime_ms', ...
	'B_InitialFixationOnsetTime_ms', ...
	'A_TargetOnsetTime_ms', ...
	'A_TargetOffsetTime_ms', ...
	'A_GoSignalTime_ms', ...
	'B_GoSignalTime_ms',...
};



% uncorrected_col_name_list = {...
% 	'uncorrected_A_InitialFixationOnsetTime_ms', ...
% 	'uncorrected_B_InitialFixationOnsetTime_ms', ...
% 	'uncorrected_A_TargetOnsetTime_ms', ...
% 	'uncorrected_B_TargetOnsetTime_ms', ...
% 	'uncorrected_A_TargetOffsetTime_ms', ...
% 	'uncorrected_B_TargetOffsetTime_ms', ...
% 	'uncorrected_A_GoSignalTime_ms', ...
% 	'uncorrected_B_GoSignalTime_ms',...
% };

bin_width_ms = 1000 / (60 * 10);
edges_list = (-100 - 0.5*(bin_width_ms) : bin_width_ms : 0 + 0.5*(bin_width_ms));
screen_refresh_lines = (-100: (1000/(2 * 60)): 0);


refresh2photodiod_delay_ms.sessionid_persample_list = {};
refresh2photodiod_delay_ms.first_col_name_presample_list = {};
refresh2photodiod_delay_ms.second_col_name_presample_list = {};
refresh2photodiod_delay_ms.data = [];

cur_offset = 0;
for i_session = 1 : length(sessiondir_list)
	cur_session_idx = [];
	cur_sessiondir_fqn = sessiondir_list{i_session};
	[cur_path, cur_sessionID, cur_ext] = fileparts(cur_sessiondir_fqn);

	if ~strcmp(cur_ext, '.sessiondir')
		disp([mfilename, ': current directory is not a .sessiondir, skipping...']);
		continue
	end
	
	% find the latest matlab version...
	tmp_triallog_dirstruct = dir(fullfile(cur_sessiondir_fqn, [cur_sessionID, '.triallog.v*.mat']));

	disp([mfilename, ': loading: ', fullfile(tmp_triallog_dirstruct(end).folder, tmp_triallog_dirstruct(end).name)]);
	load(fullfile(tmp_triallog_dirstruct(end).folder, tmp_triallog_dirstruct(end).name), 'report_struct');

	%% get the relevant columns:
	%corrected_col_idx = find(ismember(report_struct.header, corrected_col_name_list));
	%uncorrected_col_idx = find(ismember(report_struct.header, uncorrected_col_name_list));

	for i_corrected_cols = 1 : length(corrected_col_name_list)
		cur_corrected_col_name = corrected_col_name_list{i_corrected_cols};
		cur_uncorrected_col_name = ['uncorrected_', cur_corrected_col_name];

		if isfield(report_struct.cn, cur_corrected_col_name) && isfield(report_struct.cn, cur_uncorrected_col_name)
			corrected_col_idx = report_struct.cn.(cur_corrected_col_name);
			uncorrected_col_idx = report_struct.cn.(cur_uncorrected_col_name);

			% find the trials with a valid timestamp (0.0 denotes a missing value)
			trial_with_current_visual_event_idx = intersect(find(report_struct.data(:, corrected_col_idx)), find(report_struct.data(:, uncorrected_col_idx)));
			n_trials = length(trial_with_current_visual_event_idx);

			refresh2photodiod_delay_ms.sessionid_persample_list(cur_offset+1: cur_offset+n_trials, 1) = {cur_sessionID};
			refresh2photodiod_delay_ms.first_col_name_presample_list(cur_offset+1: cur_offset+n_trials, 1) = {cur_corrected_col_name};
			refresh2photodiod_delay_ms.second_col_name_presample_list(cur_offset+1: cur_offset+n_trials, 1) = {cur_uncorrected_col_name};
			refresh2photodiod_delay_ms.data(cur_offset+1: cur_offset+n_trials, 1) = report_struct.data(trial_with_current_visual_event_idx, corrected_col_idx);
			refresh2photodiod_delay_ms.data(cur_offset+1: cur_offset+n_trials, 2) = report_struct.data(trial_with_current_visual_event_idx, uncorrected_col_idx);
			cur_session_idx = union(cur_session_idx, cur_offset+1: cur_offset+n_trials);
			cur_session_idx = union(cur_session_idx, cur_offset+1: cur_offset+n_trials);

			cur_offset = cur_offset + n_trials;
		end
	end

delta_ms = diff(refresh2photodiod_delay_ms.data,1 ,2);	
non_zero_ldx = delta_ms ~= 0;


figure('Name', cur_sessionID);
histogram(delta_ms(intersect(find(non_zero_ldx), cur_session_idx)), edges_list);
hold on
xline(screen_refresh_lines);
hold off
cur_mean = mean(delta_ms(intersect(find(non_zero_ldx), cur_session_idx)));
cur_std = std(delta_ms(intersect(find(non_zero_ldx), cur_session_idx)));
title(['M: ', num2str(cur_mean), '; STD: ', num2str(cur_std)]);

end

refresh2photodiod_delay_ms.delta_ms = diff(refresh2photodiod_delay_ms.data,1 ,2);

% remove zeros
non_zero_ldx = refresh2photodiod_delay_ms.delta_ms ~= 0;
figure('Name', 'all_sessions');
histogram(refresh2photodiod_delay_ms.delta_ms(non_zero_ldx), edges_list);
hold on
xline(screen_refresh_lines);
hold off
cur_mean = mean(delta_ms(intersect(find(non_zero_ldx), cur_session_idx)));
cur_std = std(delta_ms(intersect(find(non_zero_ldx), cur_session_idx)));
title(['M: ', num2str(cur_mean), '; STD: ', num2str(cur_std)]);

end

