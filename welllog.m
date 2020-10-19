function welllog(filename,break_time0,break_time1,break_time2,break_time3)
%close all; clear all; clc;
% Load the acceleration data
% Convert to velocity and displacement
% Compare with water lelvel
%break_time0=0;break_time1=0;break_time2=0;break_time3=0;
%
%filename = 'ilan.xlsx';
data = xlsread(filename,1);
t = data(:,1); t = t'; % Time
ae = data(:,2); ae = ae'; % NE component series
an = data(:,3); an = an'; % NS component series
az = data(:,4); az = az'; % UD component series
%
%wt = data(:,6); wt = wt'; 
%wt = wt(~isnan(wt)); % Remove NaN values
wt = 1:1:0.005*length(az); % Fake the time
wh = data(:,7); wh = wh'; % Ground water level
wh=wh(1:length(wt)); % Cut the same windows size
wh = wh(~isnan(wh)); % Remove NaN values
%
% I wrote other function called convert_data(time,data,which_cv)
dt = (t(end)-t(1))/(length(t)-1);
brkpt=[break_time0/dt break_time1/dt]; % Assign the time break of the signal.
brkpt1=[break_time2/dt break_time3/dt]; % Assign the time break of the signal.
% Convert from acc to vel
ve = convert_data(t,ae,'a2v');
vz = convert_data(t,az,'a2v');
vn = convert_data(t,an,'a2v');
%detrend
ve = detrend(ve,1,brkpt);vz = detrend(vz,1,brkpt);
% The N component had break points. Need more effort
vn = detrend(vn,1,brkpt);
%vn = break_detrend(t,vn);
% Now convert from vel to disp
de = convert_data(t,ve,'v2d');
dn = convert_data(t,vn,'v2d');
dz = convert_data(t,vz,'v2d');
%detrend
de = detrend(de,1,brkpt1);
dz = detrend(dz,1,brkpt1);
dn = detrend(dn,1,brkpt1);

%% Plot section
% Here I used the filename to made the figure title
h = figure('Name',filename([1:end-5]),'Numbertitle','off',...
    'Units','normalized','Position',[0 0 1 1],'visible','on');

subplot(3,3,1)
plot(t,ae,'-k','LineWidth',1.1);grid on;hold on;
ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
ylim([-max(abs(ae))*1.2 max(abs(ae))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('E-component')
legend('Ground motion','GWL variation','Location','SE');
%
subplot(3,3,4)
plot(t,an,'-k','LineWidth',1.1);grid on; hold on;
ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
ylim([-max(abs(an))*1.2 max(abs(an))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('N-component')
legend('Ground motion','GWL variation','Location','SE');
%ylim([-max(abs(an))-10 max(abs(an))+10])
%
subplot(3,3,7)
plot(t,az,'-k','LineWidth',1.1);grid on; hold on;
ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
ylim([-max(abs(az))*1.2 max(abs(az))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('Z-component')
legend('Ground motion','GWL variation','Location','SE');
%ylim([-max(abs(az))-10 max(abs(az))+10])
% -------------------------------------------------------------------------
subplot(3,3,2)
plot(t,ve,'k','LineWidth',1.1);grid on; hold on;
ylabel('Vel(cm/s)');xlabel('Time(sec)')
ylim([-max(abs(ve))*1.2 max(abs(ve))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('E-component')
legend('Ground motion','GWL variation','Location','SE');
%
subplot(3,3,5)
plot(t,vn,'k','LineWidth',1.1);grid on; hold on;
ylabel('Vel(cm/s)');xlabel('Time(sec)')
ylim([-max(abs(vn))*1.2 max(abs(vn))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('N-component')
legend('Ground motion','GWL variation','Location','SE');
%
subplot(3,3,8)
plot(t,vz,'k','LineWidth',1.1);grid on; hold on;
ylabel('Vel(cm/s)');xlabel('Time(sec)')
ylim([-max(abs(vz))*1.2 max(abs(vz))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('Z-component')
legend('Ground motion','GWL variation','Location','SE');
%--------------------------------------------------------------------------
subplot(3,3,3)
plot(t,de,'k','LineWidth',1.1);grid on; hold on;
ylabel('Disp(cm)');xlabel('Time(sec)')
ylim([-max(abs(de))*1.2 max(abs(de))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('E-component')
legend('Ground motion','GWL variation','Location','SE');
%
subplot(3,3,6)
plot(t,dn,'k','LineWidth',1.1);grid on; hold on;
ylabel('Disp(cm)');xlabel('Time(sec)')
ylim([-max(abs(dn))*1.2 max(abs(dn))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('N-component')
legend('Ground motion','GWL variation','Location','SE');
%
subplot(3,3,9)
plot(t,dz,'k','LineWidth',1.1);grid on; hold on;
ylabel('Disp(cm)');xlabel('Time(sec)')
ylim([-max(abs(dz))*1.2 max(abs(dz))*1.2])
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
ylabel('GWL variation (cm)')
title('Z-component')
legend('Ground motion','GWL variation','Location','SE');
%
mes=['Comparison of EQ signal and Ground Water Level at ',filename([1:end-5]),' (Average GWL = ',num2str(mean(wh)),' (m))'];
suptitle(mes)
%
print('-dtiff','-r100',[filename([1:end-5]),'.tiff'])
%close(h);
end