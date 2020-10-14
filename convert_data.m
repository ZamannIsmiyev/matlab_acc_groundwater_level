function [d]=convert_data(time,data,which_cv)
% Sub-function use to convert the data 
% code for home work on time series processing (spectrum analysic)
% General Geophysic class - TIGP ESS Program - Academia Sinica
% Created date: 2018-10-23 20:50
% Modified date: xxx
% Tested on Matlab R2017b
% version (1.0)
%------------------Input definition----------------------------------------
% which_convert: data input and output of sub-program
%   if no option default 'v2a' (velocity to acceleration)
%       if you put 'a2d': convert acc2dis
%       if you put 'a2v': convert acc2vel
%       if you put 'd2a': convert dis2acc
%       if you put 'd2v': convert dis2vel
%       if you put 'v2d': convert vel2dis
%       if you put 'v2a': convert vel2acc
%% ----------------------------------Process-------------------------------
t=time';% convert row signal (for example (1x100)) to column signal (100x1)
d=data';% convert row signal (for example (1x100)) to column signal (100x1)
if nargin<3, which_cv='v2a'; end % if not definite covert type, default type is 'v2a'.
%if nargin<4, which_color='b'; end % if not definite headerlineIn, default line =0 chosen.
%if nargin<5, filtered='0'; end % if not definite filter, default = 0 (no) chosen.
%--------------------Convert by  approximate derivate----------------------
if strcmp(which_cv,'v2a') || strcmp(which_cv,'d2v')
%   use the way like definiton of approximate derivate
    %d1=diff(d)./diff(t);
    %d1(end+1)=d1(end);
%   or
    d1=gradient(d,t); % It more accuracy - belive me (Long)
    d=d1';
elseif strcmp(which_cv,'d2a')
%   use the way like definiton of approximate derivate
    %d1=diff(d)./diff(t);
    %d1(end+1)=d1(end);
%   or
    d1=gradient(d,t); % It more accuracy
    %d2=diff(d1)./diff(t);
    %d2(end+1)=d2(end);
%   or
    d2=gradient(d1,t); % It more accuracy
    d=d2';
%----------------------------Convert by integration------------------------
elseif strcmp(which_cv,'a2v') || strcmp(which_cv,'v2d')
%   use this way cumulative integration 
    d1=cumtrapz(t,d);
    d=d1';
    % or either this way Trapezoidal numerical integration
    %d1=trapz(d,t); % It almost the same, but my prefer cumtrapz
elseif strcmp(which_cv,'d2a')
%   use this way cumulative integration 
    d1=cumtrapz(t,d);
    d2=cumtrapz(t,d1);    
    % or either this way Trapezoidal numerical integration
    %d1=trapz(d,t); % It almost the same, but my prefer cumtrapz
    %d2=trapz(d1,t);
    d=d1';
end
end