function [ output_args ] = fnSampleNIDAQ_AI( input_args )
%FNSAMPLENIDAQ_AI Summary of this function goes here
%   Detailed explanation goes here

%TODO:
%   inform user about the fqn of the saved file
%   wait for user action between preparations and startForeground for less
%   latency after starting

mfilename_fqn = mfilename('fullpath');
current_path = fileparts(mfilename_fqn);

daq_session = daq.createSession('ni');
% just hardcode this for now
DAQ_ID = 'Dev1';
daq_session.Rate = 2000;
daq_session.DurationInSeconds = 60 * 8;

%daq_session.DurationInSeconds = 10;


[ch,idx] = addAnalogInputChannel(daq_session, DAQ_ID, 0:3, 'Voltage');

range_abs = abs(5);
range_max = range_abs;
range_min = range_abs * -1;


ch(1).Range = [range_min, range_max];
ch(2).Range = [range_min, range_max];
ch(3).Range = [range_min, range_max];
ch(4).Range = [range_min, range_max];

output.daq_session = daq_session;
output.ch = ch;

h = msgbox('Click the button to start sampling', 'Manual Start Control');
uiwait(h);
disp('Startimg sampling now...');
%beep;
[output.data, output.timestamps, output.triggerTime] = startForeground(daq_session);
beep;
pause(0.5);
beep;
pause(0.5);
beep;
triggertime_string = datestr(output.triggerTime, 'yyyymmddTHHMMSS.FFF');

outfile_FQN = fullfile(current_path, '..', '..', ['NI_analog_in_data.', triggertime_string, '.mat']);
disp('Saving data...');
save(outfile_FQN, 'output');
disp(['Sampled data saved as: ', outfile_FQN]);

figure
x_vec = output.timestamps;
plot(x_vec, output.data(:, 1), x_vec, output.data(:, 2), x_vec, output.data(:, 3))


end

