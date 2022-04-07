%Calculation and plotting of canopy mortality causes in countries and 
%in Central Europe
%Marieke Scheel

%add path for helper functions
addpath('../helper_functions');

%% plot mortality causes for Central Europe
%import crownarea
opts = detectImportOptions('diam_crownarea.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_crownarea.txt',opts,'ReadVariableNames',true);
T=table2array(T);
%apply threshold 10 cm
crownarea_10(:,1:3)=T(:,1:3);
crownarea_10(:,4)=sum(T(:,5:19),2);

% load cause files,(divided by crownarea * 100 = canopy mortality in percentage)
%with thresholds of 10 and 40 cm applied excl. harvest since it is 0 in PNV
opts = detectImportOptions('crownloss.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('crownloss_age.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_age_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));
T = readtable('crownloss_dist.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_dist_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));
T = readtable('crownloss_fire.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_fire_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));
T = readtable('crownloss_greff.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_greff_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));
T = readtable('crownloss_other.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_other_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));
T = readtable('crownloss_thin.txt',opts,'ReadVariableNames',true);
T=table2array(T);
crownloss_thin_10=horzcat(T(:,1:3),(sum(T(:,5:19),2)./crownarea_10(:,4).*100));

%% compile moving averages 5 years by locations
[nbrrows_locat,~]=size(crownloss_thin_10);
%start index to extract time range at one cell at a time
%(to ensure that the last addition to count does not cause an error 
%in if statement--> nbrrows_locat+1)
start_ind=1:216:nbrrows_locat+1; 
count=1;
for i=1:nbrrows_locat
    if i==start_ind(count) %if loop at first year of next cell
        crownloss_age_10(i:i+215, 4)= movmean(crownloss_age_10(i:i+215,4), 5, 'omitnan','SamplePoints', crownloss_age_10(i:i+215,3));
        crownloss_dist_10(i:i+215, 4)= movmean(crownloss_dist_10(i:i+215,4), 5, 'omitnan', 'SamplePoints', crownloss_dist_10(i:i+215,3));
        crownloss_fire_10(i:i+215, 4)= movmean(crownloss_fire_10(i:i+215,4), 5, 'omitnan', 'SamplePoints', crownloss_fire_10(i:i+215,3));
        crownloss_greff_10(i:i+215, 4)= movmean(crownloss_greff_10(i:i+215,4), 5, 'omitnan', 'SamplePoints', crownloss_greff_10(i:i+215,3));
        crownloss_other_10(i:i+215, 4)= movmean(crownloss_other_10(i:i+215,4), 5, 'omitnan', 'SamplePoints', crownloss_other_10(i:i+215,3));
        crownloss_thin_10(i:i+215, 4)= movmean(crownloss_thin_10(i:i+215,4), 5, 'omitnan', 'SamplePoints', crownloss_thin_10(i:i+215,3));
        count=count+1;
    end
end

%extract time range 1985-2015
crownloss_age_10=timerange(crownloss_age_10,3);
crownloss_dist_10=timerange(crownloss_dist_10,3);
crownloss_fire_10=timerange(crownloss_fire_10,3);
crownloss_greff_10=timerange(crownloss_greff_10,3);
crownloss_other_10=timerange(crownloss_other_10,3);
crownloss_thin_10=timerange(crownloss_thin_10,3);

%% compile in one array (age, dist, fire, greff+thin, other)
crownloss_tot_years(:,1:3)=crownloss_thin_10(:,1:3);
crownloss_tot_years(:,4:9)=horzcat(crownloss_age_10(:,4), crownloss_dist_10(:,4), crownloss_fire_10(:,4), crownloss_greff_10(:,4),crownloss_thin_10(:,4), crownloss_other_10(:,4));

%find which country coodinates correspond to and add country fao nbr
crownloss_tot_years=country_nbr(crownloss_tot_years,10);
crownloss_tot_years=sortrows(crownloss_tot_years,10);

%get median per country and sort by country
crownloss_tot_years_med=median_europe_sev_cols(crownloss_tot_years,10);
crownloss_tot_years_med=sortrows(crownloss_tot_years_med,8);

%calculate total central european canopy mortality rate based on "crownloss_tot_years" variable
%get EU median
crownloss_tot_years_centr_eu=median_all_europe_sev_cols(crownloss_tot_years, 10);

%% plot
%add labels (a, b, c, etc.) for corners of tiles
char_num = 7;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%create colour array
newcolors=brewermap(6,'Set1');
newcolors(1,:)=[1 0 0];
newcolors(2,:)=[0 0 1];
newcolors(3,:)=[0 1 1];
newcolors(6,:)=[0.41 0.20 0.00];

%plot canopyloss causes
tit=['AT'; 'DE'; 'CZ'; 'PL'; 'SK'; 'CH'];
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156);
tileorder=[1 2 3 5 6 7]; %plotting order
figure(1)
t=tiledlayout(2,4, 'TileSpacing', 'compact');
title(t, 'Canopy mortality in PNV simulation')
for j=1:6
    nexttile(tileorder(j))
    x = transpose(1985:2010);
    y = crownloss_tot_years_med(cntr(j,:)',2:7);
    hold on
    for i = 1:6
      plot(x,y(:,i), 'Color', newcolors(i,1:3)) %plot with specified colour
    end
    hold off    
    title(tit(j,:)) 
    %legend underneath 5th tile
    if j==5
        hL = legend('age', 'disturbance', 'fire', 'carbon balance', 'other' ,'NumColumns',3,'FontSize',9);
        legend('boxoff')
        hL.Location = 'southoutside';    
    end
    set(gca, 'XLimMode', 'manual', 'XLim', [1985 2010]);
    ylim([0 1.5])
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

%plot central European values
nexttile(4,[2 1]); %bigger tile
x = transpose(1985:2010); 
y2=crownloss_tot_years_centr_eu(:,2:7);
hold on
for i = 1:6
  plot(x,y2(:,i), 'Color', newcolors(i,1:3))
end
hold off
xlabel('year')
ylabel('canopy mortality in %/yr')
title('Central Europe');
t.TileSpacing = 'none';
xlim([1985 2010])
ylim([0 1.5])
%add letter in corner
text(0.015,0.95,chars_let{7},'Units','normalized','FontSize',11)
t.Padding = 'none';
t.TileSpacing = 'none';
