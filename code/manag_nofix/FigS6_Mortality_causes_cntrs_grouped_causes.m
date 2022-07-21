%Calculation and plotting of canopy mortality causes in countries
%Marieke Scheel

%add path for helper functions and data
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/manag_nofix');

%% plot mortality causes for Central europe
%import crownarea
opts = detectImportOptions('diam_crownarea.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_crownarea.txt',opts,'ReadVariableNames',true);
T=table2array(T);
%apply threshold 10 and 40 cm
crownarea_10(:,1:3)=T(:,1:3);
crownarea_10(:,4)=sum(T(:,5:19),2);
crownarea_40(:,1:3)=T(:,1:3);
crownarea_40(:,4)=sum(T(:,8:19),2);

%import cause files, (divided by crownarea * 100 = canopy mortality in percentage)
%with thresholds of 10 and 40 cm applied and only extraction of 1985-2010
opts = detectImportOptions('crownloss.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('crownloss_age.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_age_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_age_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_dist.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_dist_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_dist_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_fire.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_fire_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_fire_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_greff.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_greff_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_greff_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_harv.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_harv_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_harv_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_other.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_other_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_other_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
T = readtable('crownloss_thin.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_thin_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_thin_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);

%% compile moving averages 5 years by locations
[nbrrows_locat,~]=size(crownloss_thin_10);
%start index to extract time range at one cell at a time
%(to ensure that the last addition to count does not cause an error 
%in if statement--> nbrrows_locat+1)
start_ind=1:26:nbrrows_locat+1; 
count=1;
for i=1:nbrrows_locat
    if i==start_ind(count) %if loop at first year of next cell
        crownloss_age_10(i:i+25, 4)= movmean(crownloss_age_10(i:i+25,4), 5, 'omitnan','SamplePoints', crownloss_age_10(i:i+25,3));
        crownloss_dist_10(i:i+25, 4)= movmean(crownloss_dist_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_dist_10(i:i+25,3));
        crownloss_fire_10(i:i+25, 4)= movmean(crownloss_fire_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_fire_10(i:i+25,3));
        crownloss_greff_10(i:i+25, 4)= movmean(crownloss_greff_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_greff_10(i:i+25,3));
        crownloss_harv_10(i:i+25, 4)= movmean(crownloss_harv_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_harv_10(i:i+25,3));
        crownloss_other_10(i:i+25, 4)= movmean(crownloss_other_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_other_10(i:i+25,3));
        crownloss_thin_10(i:i+25, 4)= movmean(crownloss_thin_10(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_thin_10(i:i+25,3));
        crownloss_age_40(i:i+25, 4)= movmean(crownloss_age_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_age_40(i:i+25,3));
        crownloss_dist_40(i:i+25, 4)= movmean(crownloss_dist_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_dist_40(i:i+25,3));
        crownloss_fire_40(i:i+25, 4)= movmean(crownloss_fire_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_fire_40(i:i+25,3));
        crownloss_greff_40(i:i+25, 4)= movmean(crownloss_greff_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_greff_40(i:i+25,3));
        crownloss_harv_40(i:i+25, 4)= movmean(crownloss_harv_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_harv_40(i:i+25,3));
        crownloss_other_40(i:i+25, 4)= movmean(crownloss_other_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_other_40(i:i+25,3));
        crownloss_thin_40(i:i+25, 4)= movmean(crownloss_thin_40(i:i+25,4), 5, 'omitnan', 'SamplePoints', crownloss_thin_40(i:i+25,3));
        count=count+1;
    end
end

%% compile by diameter and cause in one file, col 4: natural causes, col 5: non-natural, i.e. harvest
crownloss_tot_10(:,1:3)=crownloss_other_40(:,1:3);
crownloss_tot_10(:,4:5)=horzcat(crownloss_age_10(:,4)+crownloss_dist_10(:,4)+crownloss_fire_10(:,4)+ crownloss_greff_10(:,4)+crownloss_thin_10(:,4)+ crownloss_other_10(:,4),crownloss_harv_10(:,4));
crownloss_tot_40(:,1:3)=crownloss_other_40(:,1:3);
crownloss_tot_40(:,4:5)=horzcat(crownloss_age_40(:,4)+crownloss_dist_40(:,4)+crownloss_fire_40(:,4) + crownloss_greff_40(:,4)+crownloss_thin_40(:,4)+ crownloss_other_40(:,4),crownloss_harv_40(:,4));

%find which country coodinates correspond to and add country fao nbr
crownloss_tot_10=country_nbr(crownloss_tot_10,6);
crownloss_tot_40=country_nbr(crownloss_tot_40,6);

%get EU median and sort by country
crownloss_tot_years_10_med=median_europe_sev_cols(crownloss_tot_10,6);
crownloss_tot_years_10_med=sortrows(crownloss_tot_years_10_med,4);
crownloss_tot_years_40_med=median_europe_sev_cols(crownloss_tot_40,6);
crownloss_tot_years_40_med=sortrows(crownloss_tot_years_40_med,4);

%% plot
%add labels (a, b, c) in corners of figure panels
char_num = 6;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot per country
tit=['AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH']; %titles of tiles
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156); %country rows
newcolors=brewermap(8,'Paired');
newcolors(3:6,:)=[];

figure(1)
t=tiledlayout(2,3, 'TileSpacing', 'compact');
title(t, 'Canopy mortality causes in managed simulation')
for j=1:6
    nexttile;
    x = transpose(1985:2010); 
    y = horzcat(crownloss_tot_years_10_med(cntr(j,:)',2:3),crownloss_tot_years_40_med(cntr(j,:)',2:3));
    hold on
    col=[2,4,1,3]; %plotting order
    for i = 1:4
      plot(x,y(:,i), 'Color', newcolors(col(1,i),1:3))
    end
    hold off
    title(tit(j,:)) 
    %legend underneath 5th tile
    if j==5
        hL = legend('natural mortality, diam. > 10 cm', 'harvest, diam. > 10 cm', 'natural mortality, diam. > 40 cm', 'harvest, diam. > 40 cm', 'NumColumns',2,'FontSize',9);
        legend('boxoff')
        hL.Location = 'southoutside';    
    end
    set(gca, 'XLimMode', 'manual', 'XLim', [1985 2010]);
    ylim([0 2.4])
    %remove y and x label in middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('Canopy mortality (%/yr)');
    end
    if j~=4 && j~=5 && j~=6
        set(gca,'XTickLabel',[]);
    else
        set(gca,'XTick',1985:10:2010)
        xlabel('year');
    end    
    %add letter in corner
    text(0.015,0.95,chars_let{j},'Units','normalized','FontSize',11)
end
t.TileSpacing = 'none';
t.Padding= 'none';
