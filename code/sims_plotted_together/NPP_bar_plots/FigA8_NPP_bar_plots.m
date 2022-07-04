%NPP trends in different simulations plotted
%Marieke Scheel

%plot NPP rates (data stems from NPP_contributes_FigA8.m in diff simulation
%folders) %NPP in col, cntr order after FAO nbrs in rows
%import trends
opts = detectImportOptions('NPP_manag_climfix.xlsx');
opts.VariableNamingRule= 'preserve';
T = readtable('NPP_PNV.xlsx',opts,'ReadVariableNames',true);
NPP_PNV=table2array(T);
T = readtable('NPP_manag_nofix.xlsx',opts,'ReadVariableNames',true);
NPP_manag_nofix=table2array(T);
T = readtable('NPP_manag_nothin.xlsx',opts,'ReadVariableNames',true);
NPP_manag_nothin=table2array(T);
T = readtable('NPP_manag_climfix.xlsx',opts,'ReadVariableNames',true);
NPP_manag_climfix=table2array(T);
T = readtable('NPP_manag_co2fix.xlsx',opts,'ReadVariableNames',true);
NPP_manag_co2fix=table2array(T);
T = readtable('NPP_manag_ndepfix.xlsx',opts,'ReadVariableNames',true);
NPP_manag_ndepfix=table2array(T);

%import SE
opts = detectImportOptions('NPP_SE_manag_climfix.xlsx');
opts.VariableNamingRule= 'preserve';
T = readtable('NPP_SE_PNV.xlsx',opts,'ReadVariableNames',true);
NPP_SE_PNV=table2array(T);
T = readtable('NPP_SE_manag_nofix.xlsx',opts,'ReadVariableNames',true);
NPP_SE_manag_nofix=table2array(T);
T = readtable('NPP_SE_manag_nothin.xlsx',opts,'ReadVariableNames',true);
NPP_SE_manag_nothin=table2array(T);
T = readtable('NPP_SE_manag_climfix.xlsx',opts,'ReadVariableNames',true);
NPP_SE_manag_climfix=table2array(T);
T = readtable('NPP_SE_manag_co2fix.xlsx',opts,'ReadVariableNames',true);
NPP_SE_manag_co2fix=table2array(T);
T = readtable('NPP_SE_manag_ndepfix.xlsx',opts,'ReadVariableNames',true);
NPP_SE_manag_ndepfix=table2array(T);

%put canopy trends in same array by simulations with fixed or without fixed
%drivers
trends_nofix=horzcat(NPP_PNV(:,1),NPP_manag_nofix(:,1),NPP_manag_nothin(:,1));
SE_nofix=horzcat(NPP_SE_PNV(:,1),NPP_SE_manag_nofix(:,1),NPP_SE_manag_nothin(:,1));
trends_fix=horzcat(NPP_manag_climfix(:,1),NPP_manag_co2fix(:,1),NPP_manag_ndepfix(:,1));
SE_fix=horzcat(NPP_SE_manag_climfix(:,1),NPP_SE_manag_co2fix(:,1),NPP_SE_manag_ndepfix(:,1));

%add labels (a, b, c) in corners of figure panels
char_num = 2;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot NPP
figure(2)
t=tiledlayout(2,1, 'TileSpacing', 'compact');
title(t, 'NPP trends in different simulations');
%tile without fixed drivers
nexttile
x=1:6;
b=bar(x,trends_nofix, 'grouped');
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
ylim([-0.01 0.012])
xticklabels(categorical({'AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH'}))
%legend
hL = legend('PNV', 'managed', 'managed without thinning', 'Standard error' ,'NumColumns',2,'FontSize',9);
legend('boxoff')
hL.Location = 'southoutside';    
ylabel('NPP trend in kg[C]/m^2yr')
%add letter in corner
text(0.015,0.95,chars_let{1},'Units','normalized','FontSize',11)

%tile with fixed drivers
nexttile
x=1:6;
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
ylim([-0.01 0.012])
xticklabels(categorical({'AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH'}))
%legend
hL = legend('managed with climate as the only non-fixed parameter', 'managed with CO2 as the only non-fixed parameter', 'managed with Nitrogen deposition as the only non-fixed parameter', 'Standard error' ,'NumColumns',2,'FontSize',9);
legend('boxoff')
hL.Location = 'southoutside';    
ylabel('NPP trend in kg[C]/m^2yr')
%add letter in corner
text(0.015,0.95,chars_let{2},'Units','normalized','FontSize',11)
t.Padding = 'none';
t.TileSpacing = 'none';