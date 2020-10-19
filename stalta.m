function [pon ipon poff ipoff] = stalta(tseries,ltw,stw,trigon,trigoff,dt)

% STALTA estimates first arrival of a seismogram based on ratio of
% short-term to long-term averages exceeding some specified 
% threshold value. LTW,STW are window lengths in seconds of 
% long and short term averages, THRESH is threshold and DT is 
% sample interval of time series TSERIES.

    il = fix( ltw / dt);
    is = fix(stw / dt);
    nt = length(tseries); 
    aseries = abs( hilbert(tseries) );
    sra = zeros(1, nt);
    for ii = il + 1:nt
       lta = mean(aseries(ii - il : ii));
       sta = mean(aseries(ii - is : ii));
       sra(ii) = sta / lta;
    end

    ipon = find(sra > trigon);
    ipoff = find(sra > trigoff);
%    while (poff > pon)
%        poff=poff
%    end
    
    if ~isempty(ipon)
      pon = ipon(1);
    end
    if ~isempty(ipoff)
      poff = ipoff(end);
    end
    return

%    time=[1:nt]*dt;
%    figure(99)
%    subplot(3,1,1)
%    plot(time,tseries,'b')
%    hold on 
%    plot([time(itmax),time(itmax)],[-2*max(tseries),2*max(tseries)],'r');
%    hold off
%    subplot(3,1,2)
%    plot(time,aseries,'b')
%    hold on 
%    plot([time(itmax),time(itmax)],[-2*max(aseries),2*max(aseries)],'r');
%    hold off
%    subplot(3,1,3)
%    plot(time,sra,'b')
%    hold on 
%    plot([time(itmax),time(itmax)],[0,1.5*max(sra)],'r');
%    hold off
%    pause