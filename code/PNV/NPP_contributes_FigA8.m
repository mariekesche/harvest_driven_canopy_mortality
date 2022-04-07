%Calculation of forest NPP and export of trend and uncertainty
%Marieke Scheel

%set output folder for NPP trends and SE 
pathname='C:\..\sims_plotted_together\Mortality_bar_plots';

%add path for helper functions
addpath('../dependencies');

%% import forest NPP values in cells (in cflux_forest_rel)
opts = detectImportOptions('cflux.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('cflux.txt',opts,'ReadVariableNames',true);
cflux(:,1:4)=table2array(T(:,1:4)); %column 4 is forest NPP

%get only time range 1985-2010
cflux_sim_years=timerange(cflux,3);

%correct NPP value to be positive (NPP * -1)
cflux_sim_years(:,4)=cflux_sim_years(:,4).*(-1);

%find which country the coodinates correspond to and add country fao number
cflux_sim_years=country_nbr(cflux_sim_years,5);

%get median for each country and sort by country
cflux_years_me=median_europe(cflux_sim_years);
cflux_years_me=sortrows(cflux_years_me,3);

%get trends and uncertainties
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156); 
for j=1:6
    x = 1985:2010; 
    y = cflux_years_me(cntr(j,:)',2);
    %trends of all countries in array
    [trend(j,:), ~, ~ ]=polypredci(x, y, 1);     
    %add Standard Error 
    mdl=fitlm(x,y);
    SE(j,1)=mdl.Coefficients.SE(2);
end
trend(:,2)=[];

%export trends (NPP as header, countries in rows)
trend=array2table(trend);
output_file='NPP_PNV.xlsx';
writetable(trend,fullfile(pathname, output_file),'WriteVariableNames',false);
%export SE (SE as header, countries in rows)
SE=array2table(SE);
output_file='NPP_SE_PNV.xlsx';
writetable(SE,fullfile(pathname, output_file),'WriteVariableNames',false);
