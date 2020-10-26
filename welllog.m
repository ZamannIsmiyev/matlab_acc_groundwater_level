%function welllog(filename,pre_time,break_time0,break_time1,break_time2,break_time3)
function welllog(filename,pre_time,break_time0,break_time1,break_time2,break_time3,wflag)
% 2020-10-10:
% Load the acceleration data -> Convert to velocity and displacement
% Compare the converted signal with water lelvel
% 2020-10-16:
% Add values: 
%  + break_time0=0;break_time1=0;control the time before correction of vel
%  + break_time2=0;break_time3=0;control the time before correction of disp
% 2020-10-19: Use LTA/STA to detect the main stream
% Usage of the function
%   - filename: input data file name (xlsfile)
%
%   - break_time0: starttime of velocity signal break (use to corretion)
%   - break_time1: endtime of velocity signal break (use to corretion)
%   - break_time2: starttime of displacement signal break (use to corretion)
%   - break_time3: starttime of displacement signal break (use to corretion)
%   At 1st run, set all break_time = 0; pick the time range and re-run
% 2020-10-26: Add the option to write out the converted data by "wflag";
% Assum that input data is acceleration and output data are velocity and
% displacement data.
%%
%close all; clear all; clc;
%pre_time = 5;
%break_time0=0;break_time1=0;break_time2=0;break_time3=0;
%filename = 'Liujia-Well.xlsx';
data = xlsread(filename,1);
vout = [];
dout = [];
t = data(:,1); t = t'; % Time
% I wrote other function called convert_data(time,data,which_cv)
dt = (t(end)-t(1))/(length(t)-1);
brkpt=[break_time0/dt break_time1/dt]; % Assign the time break of the signal.
brkpt1=[break_time2/dt break_time3/dt]; % Assign the time break of the signal.
%
%
ae = data(:,2); ae = ae'; % NE component series
an = data(:,3); an = an'; % NS component series
az = data(:,4); az = az'; % UD component series
% Detect the main stream by LTA/STA 
%   Detec the point match the trigger on and off of 2 channel, and choose 1
     [pon1 ipon1 poff1 ipoff1]=stalta(an,3,0.3,3.0,1.5,dt);
     [pon2 ipon2 poff2 ipoff2]=stalta(ae,3,0.3,3.0,1.5,dt);
     ddt1=poff1-pon1;
     ddt2=poff2-pon2;
     if(ddt2>ddt1) 
         pon=pon2;
         poff=poff2;
     else
         pon=pon1;
         poff=poff1;
     end
     id = t>=((pon*dt)-pre_time) & t<=(poff*dt); % detect the time of the main signals
     An = an(id);
     Ae = ae(id);
     Az = az(id);
     T=t(id);
%wt = data(:,6); wt = wt'; 
%wt = wt(~isnan(wt)); % Remove NaN values
wt = 1:1:dt*length(az); % Fake the time
wh = data(:,7); wh = wh'; % Ground water level
wh=wh(1:length(wt)); % Cut the same windows size
wh = wh(~isnan(wh)); % Remove NaN values
%
Wt = round(pon*dt):1:dt*length(az); % Cut the GWL signal coresponded with acc data
Wh = wh(round(pon*dt):length(wt));
% Convert from acc to vel
ve = convert_data(t,ae,'a2v');
vz = convert_data(t,az,'a2v');
vn = convert_data(t,an,'a2v');
%
Ve = convert_data(T,Ae,'a2v');
Vz = convert_data(T,Az,'a2v');
Vn = convert_data(T,An,'a2v');

%detrend
ve = detrend(ve,1,brkpt);
vn = detrend(vn,1,brkpt);
vz = detrend(vz,1,brkpt);
%
Ve = detrend(Ve,1,brkpt);
Vn = detrend(Vn,1,brkpt);
Vz = detrend(Vz,1,brkpt);
% Now convert from vel to disp
de = convert_data(t,ve,'v2d');
dn = convert_data(t,vn,'v2d');
dz = convert_data(t,vz,'v2d');
%
De = convert_data(T,Ve,'v2d');
Dn = convert_data(T,Vn,'v2d');
Dz = convert_data(T,Vz,'v2d');
%detrend
De = detrend(De,1,brkpt1);
Dz = detrend(Dz,1,brkpt1);
Dn = detrend(Dn,1,brkpt1);

%% Write the converted data out
if (wflag=='y')| (wflag=='Y')
vout = [vout T' Ve' Vn' Vz']; % velocity data
dout = [dout T' De' Dn' Dz']; % displacement data
vfn = strcat(filename(1:end-5),"-vel.xlsx");
%disp(vfn)
dfn = strcat(filename(1:end-5),"-dis.xlsx");
%disp(dfn)
%
checkforfile=exist((vfn),'file');
%disp(vfn)
if checkforfile==1; % if not create new one
    disp(["remove old file:",vfn])
    delete vfn
end
disp(['Write data to file as "time - E - N - Z" into file', vfn])
xlswrite(vfn,vout,1);
%else % if yes, count the number of previous inputs
%disp(["remove old file:",vfn])
%delete vfn
%disp(["Write data to file:",vfn])
%xlswrite(vfn,vout,1);
%end
%
disp(['Write data to file as "time - E - N - Z" into file', dfn])
xlswrite(dfn,dout,1);
else
    disp('Not write out the data')
end
%% Plot section
% Here I used the filename to made the figure title
h = figure('Name',filename([1:end-5]),'Numbertitle','off',...
    'Units','normalized','Position',[0 0 1 1],'visible','on');
% ------------------- Origin Acceleration Plot ----------------------------
subplot(3,4,1)
yyaxis left
plot(t,ae,'-','LineWidth',1.5);grid on;hold on;
plot(T,Ae,'-k','LineWidth',1.1);
ylabel('Acc(cm/s^2)');xlabel('Time(sec)');
ylim([-max(abs(Ae))*1.2 max(abs(Ae))*1.2]);
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
%plot(Wt',detrend(Wh',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('EW-component')
legend('Ground motion','Main signal selected by LTA/STA','GWL variation','Location','SE');
%
subplot(3,4,5)
yyaxis left
plot(t,an,'-','LineWidth',1.5);grid on;hold on;
plot(T,An,'-k','LineWidth',1.1);
ylabel('Acc(cm/s^2)');xlabel('Time(sec)');
ylim([-max(abs(An))*1.2 max(abs(An))*1.2]);
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
%plot(Wt',detrend(Wh',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('NS-component')
legend('Ground motion','Main signal selected by LTA/STA','GWL variation','Location','SE');
% %
subplot(3,4,9)
yyaxis left
plot(t,az,'-','LineWidth',1.5);grid on;hold on;
plot(T,Az,'-k','LineWidth',1.1);
ylabel('Acc(cm/s^2)');xlabel('Time(sec)');
ylim([-max(abs(Az))*1.2 max(abs(Az))*1.2]);
yyaxis right
plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
%plot(Wt',detrend(Wh',1),'LineWidth',1);
ylabel('GWL variation (cm)')
ylim([-max(abs(detrend(wh(1:length(wt)),1)))*1.2 max(abs(detrend(wh(1:length(wt)),1)))*1.2]);
title('UD-component')
legend('Ground motion','Main signal selected by LTA/STA','GWL variation','Location','SE');
% % ------------------- Selected Acceleration Plot ----------------------------
 subplot(3,4,2)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Ae,'-k','LineWidth',1.1);
 ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
 ylim([-max(abs(ae))*1.2 max(abs(ae))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('EW-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,6)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,An,'-k','LineWidth',1.1);
 ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
 ylim([-max(abs(An))*1.2 max(abs(An))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('NS-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,10)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Ae,'-k','LineWidth',1.1);
 ylabel('Acc(cm/s^2)');xlabel('Time(sec)')
 ylim([-max(abs(ae))*1.2 max(abs(ae))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('UD-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% % -------------------------- Velocity plot --------------------------------
 subplot(3,4,3)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Ve,'-k','LineWidth',1.1);
 ylabel('Vel(cm/s)');xlabel('Time(sec)')
 ylim([-max(abs(Ve))*1.2 max(abs(Ve))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('EW-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,7)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Vn,'-k','LineWidth',1.1);
 ylabel('Vel(cm/s)');xlabel('Time(sec)')
 ylim([-max(abs(Vn))*1.2 max(abs(Vn))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('NS-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,11)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Vz,'-k','LineWidth',1.1);
 ylabel('Vel(cm/s)');xlabel('Time(sec)')
 ylim([-max(abs(Vz))*1.2 max(abs(Vz))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('UD-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %------------------------------ Displacement plot -------------------------
 subplot(3,4,4)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,De,'-k','LineWidth',1.1);
 ylabel('Disp(cm)');xlabel('Time(sec)')
 ylim([-max(abs(De))*1.2 max(abs(De))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('EW-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,8)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Dn,'-k','LineWidth',1.1);
 ylabel('Disp(cm)');xlabel('Time(sec)')
 ylim([-max(abs(Dn))*1.2 max(abs(Dn))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('NS-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
% %
 subplot(3,4,12)
 yyaxis left
 grid on;hold on;
% plot(t,ae,'-b','LineWidth',1.1);
 plot(T,Dz,'-k','LineWidth',1.1);
 ylabel('Disp(cm)');xlabel('Time(sec)')
 ylim([-max(abs(Dz))*1.2 max(abs(Dz))*1.2])
 yyaxis right
% %plot(wt',detrend(wh(1:length(wt'))',1),'LineWidth',1);
 plot(Wt',detrend(Wh',1),'LineWidth',1);
 ylabel('GWL variation (cm)')
 ylim([-max(abs(detrend(Wh(1:length(Wt)),1)))*1.2 max(abs(detrend(Wh(1:length(Wt)),1)))*1.2]);
 title('UD-component')
 legend('Main stream Ground motion','Corresponded GWL variation','Location','SE');
 mes=['Comparison of EQ signal and Ground Water Level at ',filename([1:end-5]),' (Average GWL = ',num2str(mean(wh)),' (m))'];
 suptitle(mes)
%
print('-dtiff','-r100',[filename([1:end-5]),'.tiff'])
%close(h);
end