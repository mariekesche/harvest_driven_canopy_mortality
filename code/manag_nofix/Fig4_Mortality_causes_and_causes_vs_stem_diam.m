%Calculation and plotting of mortality causes, as well as 
%natural and harvest mortality plotted against stem diameter 
%in Central Europe

%Marieke Scheel

%add path for helper functions and data
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/manag_nofix');

%% plot mortality causes for central europe
%import crownarea
opts = detectImportOptions('diam_crownarea.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_crownarea.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownarea_all=T;
crownarea_all_yrs=timerange(crownarea_all, 3);
%apply threshold 10 and 40 cm
crownarea_10(:,1:3)=T(:,1:3);
crownarea_10(:,4)=sum(T(:,5:19),2);
crownarea_40(:,1:3)=T(:,1:3);
crownarea_40(:,4)=sum(T(:,8:19),2);

%import cause files, (divided by crownarea * 100 = canopy mortality in percentage)
%with thresholds of 10 and 40 cm applied and only extraction of 1985-2010
opts = detectImportOptions('crownloss.txt'); %same import options for all
opts.VariableNamingRule= 'preserve';
T = readtable('crownloss_age.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_age_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_age_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_age_all=T(:,4:19);
T = readtable('crownloss_dist.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_dist_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_dist_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_dist_all=T(:,4:19);
T = readtable('crownloss_fire.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_fire_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_fire_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_fire_all=T(:,4:19);
T = readtable('crownloss_greff.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_greff_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_greff_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_greff_all=T(:,4:19);
T = readtable('crownloss_harv.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_harv_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_harv_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_harv_all=T(:,4:19);
T = readtable('crownloss_other.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_other_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_other_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_other_all=T(:,4:19);
T = readtable('crownloss_thin.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_thin_10=timerange(horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100)),3);
crownloss_thin_40=timerange(horzcat(T(:,1:3),(sum(T(:,8:19),2)./crownarea_40(:,4).*100)),3);
crownloss_thin_all=T(:,4:19);

%% compile moving averages of 5 years by locations
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

%get median for all of Europe for each class
crownloss_age_10=median_all_europe(crownloss_age_10);
crownloss_dist_10=median_all_europe(crownloss_dist_10);
crownloss_fire_10=median_all_europe(crownloss_fire_10);
crownloss_greff_10=median_all_europe(crownloss_greff_10);
crownloss_harv_10=median_all_europe(crownloss_harv_10);
crownloss_other_10=median_all_europe(crownloss_other_10);
crownloss_thin_10=median_all_europe(crownloss_thin_10);
crownloss_age_40=median_all_europe(crownloss_age_40);
crownloss_dist_40=median_all_europe(crownloss_dist_40);
crownloss_fire_40=median_all_europe(crownloss_fire_40);
crownloss_greff_40=median_all_europe(crownloss_greff_40);
crownloss_harv_40=median_all_europe(crownloss_harv_40);
crownloss_other_40=median_all_europe(crownloss_other_40);
crownloss_thin_40=median_all_europe(crownloss_thin_40);

% compile by diameter and cause in one file, col 4: natural causes, col 5: harvest
crownloss_tot_10(:,1)=1985:2010;
crownloss_tot_10(:,2:3)=horzcat(crownloss_age_10(:,2)+crownloss_dist_10(:,2)+crownloss_fire_10(:,2)+ crownloss_greff_10(:,2)+crownloss_thin_10(:,2)+ crownloss_other_10(:,2),crownloss_harv_10(:,2));
crownloss_tot_40(:,1)=1985:2010;
crownloss_tot_40(:,2:3)=horzcat(crownloss_age_40(:,2)+crownloss_dist_40(:,2)+crownloss_fire_40(:,2) + crownloss_greff_40(:,2)+crownloss_thin_40(:,2)+ crownloss_other_40(:,2),crownloss_harv_40(:,2));

%% natural and harvest mortality by stem size
%compile by all diameters in natural and harvest categories
crownloss_nat_all(:,1:3)=crownarea_all(:,1:3);
crownloss_nat_all(:,4:19)=crownloss_age_all+ crownloss_dist_all+crownloss_fire_all+crownloss_greff_all+crownloss_thin_all+crownloss_other_all;
crownloss_nonnat_all(:,1:3)=crownarea_all(:,1:3);
crownloss_nonnat_all(:,4:19)=crownloss_harv_all;

%get timerange 1985-2010
crownloss_nat_all_yrs=timerange(crownloss_nat_all,3);
crownloss_nonnat_all_yrs=timerange(crownloss_nonnat_all,3);

%calculate mortality in percentage
crownmort_nat_all_yrs(:,1:3)=crownloss_nat_all_yrs(:,1:3);
crownmort_nat_all_yrs(:,4:19)=crownloss_nat_all_yrs(:,4:19)./crownarea_all_yrs(:,4:19).*100;
crownmort_nonnat_all_yrs(:,1:3)=crownloss_nonnat_all_yrs(:,1:3);
crownmort_nonnat_all_yrs(:,4:19)=crownloss_nonnat_all_yrs(:,4:19)./crownarea_all_yrs(:,4:19).*100;

%compile moving averages over all years by location
[nbrrows_locat,~]=size(crownmort_nat_all_yrs);
%start index to extract time range at one cell at a time
%(to ensure that the last addition to count does not cause an error 
%in if statement--> nbrrows_locat+1)
start_ind=1:26:nbrrows_locat+1; 
count=1;
for i=1:nbrrows_locat
    if i==start_ind(count)
        crownmort_nat_all_yrs_smooth(i:i+25, 1:16)= movmean(crownmort_nat_all_yrs(i:i+25,4:19), 26, 'omitnan','SamplePoints', crownmort_nat_all_yrs(i:i+25,3));
        crownmort_nonnat_all_yrs_smooth(i:i+25, 1:16)= movmean(crownmort_nonnat_all_yrs(i:i+25,4:19), 26, 'omitnan', 'SamplePoints', crownmort_nonnat_all_yrs(i:i+25,3));
        count=count+1;
    end
end

%omit inf
ind_inf=crownmort_nat_all_yrs_smooth==Inf;
crownmort_nat_all_yrs_smooth(ind_inf==1)=NaN;
ind_inf=crownmort_nonnat_all_yrs_smooth==Inf;
crownmort_nonnat_all_yrs_smooth(ind_inf==1)=NaN;

%get EU median 
central_europe_mort_nat_median(1,1:16)=median(crownmort_nat_all_yrs_smooth(:,1:16),1, 'omitnan');
central_europe_mort_nonnat_median(1,1:16)=median(crownmort_nonnat_all_yrs_smooth(:,1:16),1, 'omitnan');

%% plot both canopyloss causes and canopyloss as a function of stem size
%colours for first panel
newcolors=brewermap(8,'Paired');
newcolors(3:6,:)=[];

%add labels (a and b) in corners of tiles
char_num = 2;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%initiate figure
figure(1)
t=tiledlayout(2,1, 'TileSpacing', 'compact');

%canopy mortality central europe, by diameter and causes
nexttile
title({'Central European canopy mortality causes', 'over time'});
x = transpose(1985:2010); 
y = horzcat(crownloss_tot_10(:,2:3),crownloss_tot_40(:,2:3));
hold on
j=[2,4,1,3]; %order of plotting (for colours)
for i = 1:4
  plot(x,y(:,i), 'Color', newcolors(j(1,i),1:3), 'LineWidth',1.2)
end
hold off
%legend
hL = legend('natural mortality, diam. > 10 cm', 'harvest, diam. > 10 cm', 'natural mortality, diam. > 40 cm', 'harvest, diam. > 40 cm', 'NumColumns',2,'FontSize',10);
legend('boxoff')
hL.Location = 'southoutside';
xlim([1985 2010])
ylim([0 2.3])
xlabel('year')
ylabel('Canopy mortality in %/yr')
%letter in corner of tile
text(0.015,0.95,chars_let{1},'Units','normalized','FontSize',12)

%change colours for next tile
newcolors(1,:)=[0 0 0];
newcolors(2,:)=[0.6 0.6 0.5];

nexttile
x=10:10:80;
y2=vertcat(central_europe_mort_nat_median, central_europe_mort_nonnat_median);
%plot canopy mortality by cause vs stem size
hold on
for i = 1:2
  plot(x,y2(i,1:8), 'Color', newcolors(i,1:3), 'LineWidth',1.2)
end
hold off
xlim([10 80])
diam_cate=categorical({'0-10' '20-30' '40-50' '60-70'});
set(gca,'XTick',10:20:80,'XTickLabel',diam_cate)
xlabel('stem diameter (cm)')
ylabel('Canopy mortality in %/yr')
title({'Central European canopy mortality causes', 'as a function of stem size'});
hL = legend('natural mortality', 'harvest','NumColumns',1,'FontSize',10);
legend('boxoff')
hL.Location = 'southoutside';
t.Padding = 'none';
t.TileSpacing = 'none';
%add letter in corner of tile
text(0.015,0.95,chars_let{2},'Units','normalized','FontSize',12)
