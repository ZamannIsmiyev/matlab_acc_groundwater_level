close all; clear all; clc
%% Control whole process by call other function
% function welllog(filename,pre_time,break_time0,break_time1,break_time2,break_time3)
% Usage of the function
%   - filename: input data file name (xlsfile)
%
%   - break_time0: starttime of velocity signal break (use to corretion)
%   - break_time1: endtime of velocity signal break (use to corretion)
%   - break_time2: starttime of displacement signal break (use to corretion)
%   - break_time3: starttime of displacement signal break (use to corretion)
%   At 1st run, set all break_time = 0; pick the time range and 
% I select the main stream = 5 seccond before first arrival
welllog('Liujia-Well.xlsx',5,0,0,0,0);
%
welllog('Chishan-Well.xlsx',5,0,0,0,0);
%
welllog('Ylan-Well.xlsx',5,0,0,0,0);

close all;