%Canopy mortality trend and SE exported for all countries and Central
%Europe
%Marieke Scheel

%set output folder for Canopy mortality trends and SE
pathname='..\sims_plotted_together\Mortality_bar_plots';

%add path for helper functions and data
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/manag_nothin');

%% import canopy mortality (crownloss/diam_crownarea)
opts = detectImportOptions('crownloss.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('crownloss.txt',opts,'ReadVariableNames',true);
crownloss=table2array(T);
closs_temp(:,1:19)=crownloss(:,1:19);
opts = detectImportOptions('diam_crownarea.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_crownarea.txt',opts,'ReadVariableNames',true);
diam_crownarea=table2array(T);
carea_temp(:,1:19)=diam_crownarea(:,1:19);

%get only time range 1985-2010
carea_temp_years=timerange(carea_temp,3);
closs_temp_years=timerange(closs_temp,3);

%adjust canopy area if it reaches patch area
[closs,carea]=canopy_area_mort_adjusted(closs_temp_years, carea_temp_years, 1985,1);
for i=1:25
    [closs1,carea1]=canopy_area_mort_adjusted(closs_temp_years, carea_temp_years, 1985+i,i+1);
    closs=vertcat(closs, closs1);
    carea=vertcat(carea, carea1);
    clear carea1 closs1
end

%calculate canopy mortality
carea_total(:,1)=sum(carea(:,5:19),2);
closs_total(:,1)=sum(closs(:,5:19),2);
canopy_mort_sim_years(:,1:3)=carea(:,1:3);
canopy_mort_sim_years(:,4)=closs_total(:,1)./carea_total(:,1);
clear closs carea closs_total carea_total

%find which country coodinates correspond to and add country fao nbr
canopy_mort_sim_years=country_nbr(canopy_mort_sim_years,5);

%transform fractions to percentage
canopy_mort_sim_years(:,4)=canopy_mort_sim_years(:,4).*100;

%get EU average and sort by country
canopy_mort_sim_years_med=median_europe(canopy_mort_sim_years);
canopy_mort_sim_years_med=sortrows(canopy_mort_sim_years_med,3);

%calculate canopy mortality trends and SE of countries
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156);
for j=1:6
    x = transpose(1985:2010); 
    y = canopy_mort_sim_years_med(cntr(j,:)',2);
    %get trend of mortality in all countries in array
    [trend(j,2:3), ~, ~ ]=polypredci(x, y, 1);     
    %add SE
    mdl=fitlm(x,y);    
    SE(j,2)=mdl.Coefficients.SE(2);
end
trend(:,3)=[];

%export canopy mortality trend in respective countries 
% (canopy mortality as headers, countries in rows)
trend=array2table(trend);
output_file='morttrend_manag_nothin.xlsx';
writetable(trend,fullfile(pathname, output_file),'WriteVariableNames',false);
%export SE in resp. countries
SE=array2table(SE);
output_file='morttrend_SE_manag_nothin.xlsx';
writetable(SE,fullfile(pathname, output_file),'WriteVariableNames',false);

%% calculate Central European median canopy mortality
central_europe_mort_med=median_all_europe(canopy_mort_sim_years);

%calculate trend and SE in Central Europe
y=central_europe_mort_med(:,2);
[trend_SE_central, ~, ~ ]=polypredci(x, y, 1); %get trend of all countries in array
trend_SE_central(:,2)=[];
%add SE to array 
mdl=fitlm(x,y);    
trend_SE_central(2,1)=mdl.Coefficients.SE(2);

%export SE and trend of canopy mortality in Central Europe
trend_SE_central=array2table(trend_SE_central);
output_file='trend_SE_centr_manag_nothin.xlsx';
writetable(trend_SE_central,fullfile(pathname, output_file),'WriteVariableNames',false);
