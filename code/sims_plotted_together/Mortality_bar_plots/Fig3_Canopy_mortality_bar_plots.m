%Canopy mortality trends in different simulations plotted
%Marieke Scheel

%plot mortality rates (data stems from canopy_mort_trend_contributes_Fig3.m
%in diff simulation folders) %order: stem, canopy, carbon in cols,
%cntr order after FAO nbrs in rows
%import trends in countries
opts = detectImportOptions('morttrend_manag_climfix.xlsx');
opts.VariableNamingRule= 'preserve';
T = readtable('morttrend_PNV.xlsx',opts,'ReadVariableNames',true);
morttrend_PNV=table2array(T);
T = readtable('morttrend_manag_nofix.xlsx',opts,'ReadVariableNames',true);
morttrend_manag_nofix=table2array(T);
T = readtable('morttrend_manag_nothin.xlsx',opts,'ReadVariableNames',true);
morttrend_manag_nothin=table2array(T);
T = readtable('morttrend_manag_climfix.xlsx',opts,'ReadVariableNames',true);
morttrend_manag_climfix=table2array(T);
T = readtable('morttrend_manag_co2fix.xlsx',opts,'ReadVariableNames',true);
morttrend_manag_co2fix=table2array(T);
T = readtable('morttrend_manag_ndepfix.xlsx',opts,'ReadVariableNames',true);
morttrend_manag_ndepfix=table2array(T);

%import SE (from quant_mort_trend.m, calculated using fitlm) in countries
opts = detectImportOptions('morttrend_SE_manag_climfix.xlsx');
opts.VariableNamingRule= 'preserve';
T = readtable('morttrend_SE_PNV.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_PNV=table2array(T);
T = readtable('morttrend_SE_manag_nofix.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_manag_nofix=table2array(T);
T = readtable('morttrend_SE_manag_nothin.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_manag_nothin=table2array(T);
T = readtable('morttrend_SE_manag_climfix.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_manag_climfix=table2array(T);
T = readtable('morttrend_SE_manag_co2fix.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_manag_co2fix=table2array(T);
T = readtable('morttrend_SE_manag_ndepfix.xlsx',opts,'ReadVariableNames',true);
morttrend_SE_manag_ndepfix=table2array(T);

%import trends and SE central Europe
opts = detectImportOptions('trend_SE_centr_manag_climfix.xlsx');
opts.VariableNamingRule= 'preserve';
T = readtable('trend_SE_centr_manag_climfix.xlsx',opts,'ReadVariableNames',true);
central_trend_climfix=table2array(T);
T = readtable('trend_SE_centr_manag_co2fix.xlsx',opts,'ReadVariableNames',true);
central_trend_co2fix=table2array(T);
T = readtable('trend_SE_centr_manag_ndepfix.xlsx',opts,'ReadVariableNames',true);
central_trend_ndepfix=table2array(T);
T = readtable('trend_SE_centr_manag_nofix.xlsx',opts,'ReadVariableNames',true);
central_trend_nofix=table2array(T);
T = readtable('trend_SE_centr_manag_nothin.xlsx',opts,'ReadVariableNames',true);
central_trend_nothin=table2array(T);
T = readtable('trend_SE_centr_natural.xlsx',opts,'ReadVariableNames',true);
central_trend_PNV=table2array(T);

%put canopy trends in arrays by fixed drivers or no fixed drivers
trends_nofix=horzcat(morttrend_PNV(:,2),morttrend_manag_nofix(:,2),morttrend_manag_nothin(:,2));
trends_nofix(7,1)=central_trend_PNV(1,1);
trends_nofix(7,2)=central_trend_nofix(1,1);
trends_nofix(7,3)=central_trend_nothin(1,1);
SE_nofix=horzcat(morttrend_SE_PNV(:,2),morttrend_SE_manag_nofix(:,2),morttrend_SE_manag_nothin(:,2));
SE_nofix(7,1)=central_trend_PNV(2,1);
SE_nofix(7,2)=central_trend_nofix(2,1);
SE_nofix(7,3)=central_trend_nothin(2,1);
trends_fix=horzcat(morttrend_manag_climfix(:,2),morttrend_manag_co2fix(:,2),morttrend_manag_ndepfix(:,2));
trends_fix(7,1)=central_trend_climfix(1,1);
trends_fix(7,2)=central_trend_co2fix(1,1);
trends_fix(7,3)=central_trend_ndepfix(1,1);
SE_fix=horzcat(morttrend_SE_manag_climfix(:,2),morttrend_SE_manag_co2fix(:,2),morttrend_SE_manag_ndepfix(:,2));
SE_fix(7,1)=central_trend_climfix(2,1);
SE_fix(7,2)=central_trend_co2fix(2,1);
SE_fix(7,3)=central_trend_ndepfix(2,1);

%add labels (a, b, c) in corners of figure panels
char_num = 2;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%bar plot with trends and Standard error
figure(1)
t=tiledlayout(2,1, 'TileSpacing', 'compact');
title(t, 'Canopy mortality trends in different simulations');
%tile with mortality trends in simulations without fixed trends
nexttile
x=1:7;
b=bar(x,trends_nofix, 'grouped'); %bar in all countries and Central Europe
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(trends_nofix);
% Get the x coordinate of the bars
x_coord = nan(nbars, ngroups);
for i = 1:nbars
    x_coord(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x_coord',trends_nofix,SE_nofix,'k','linestyle','none');
hold off
ylim([-0.02 0.04])
xticklabels(categorical({'AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH'; 'Central Europe'}))
%legend
hL = legend('PNV', 'managed', 'managed without thinning', 'Standard error' ,'NumColumns',2,'FontSize',9);
legend('boxoff')
hL.Location = 'southoutside'; 
ylabel('mortality trend in %/yr')
%add letter in corner of tile
text(0.015,0.95,chars_let{1},'Units','normalized','FontSize',12)

%next tile with mortality trends in simulations with fixed trends
nexttile
x=1:7;
b=bar(x,trends_fix, 'grouped','FaceColor','flat');
b(1).FaceColor=[0.4940, 0.1840, 0.5560];
b(2).FaceColor=[0.4660, 0.6740, 0.1880];
b(3).FaceColor=[0.3010, 0.7450, 0.9330];
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(trends_fix);
% Get the x coordinate of the bars
x_coord = nan(nbars, ngroups);
for i = 1:nbars
    x_coord(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x_coord',trends_fix,SE_fix,'k','linestyle','none');
hold off
ylim([-0.02 0.04])
xticklabels(categorical({'AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH'; 'Central Europe'}))
%legend
hL = legend('managed with climate as the only non-fixed parameter', 'managed with CO2 as the only non-fixed parameter', 'managed with Nitrogen deposition as the only non-fixed parameter', 'Standard error' ,'NumColumns',2,'FontSize',9);
legend('boxoff')
hL.Location = 'southoutside';    
ylabel('mortality trend in %/yr')
%letter in corner of tile
text(0.015,0.95,chars_let{2},'Units','normalized','FontSize',12)
t.Padding = 'none';
t.TileSpacing = 'none';