%Plot canopy mortality time series by Senf et al. (2018) and from LPJ-GUESS
%simulation manag_nofix
%Marieke Scheel

%add path for helper functions
addpath('../helper_functions');

%% import mortality rates by Senf et al. (2018)
opts = detectImportOptions('Senf_annual_rates_central_Europe.csv');
T = readtable('Senf_annual_rates_central_Europe.csv',opts,'ReadVariableNames',true);
%Third column in Senf is annual estimate of canopy mortality
Senf=table2array(T);

%get only time range 1985-2010
Senf_years=timerange(Senf,2);

%transform fractions to percentage
Senf_years(:,3)=Senf_years(:,3).*100;

%import canopy mortality from simulation managed_nofix
opts = detectImportOptions('crownloss_manag.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('crownloss_manag.txt',opts,'ReadVariableNames',true);
crownloss_manag=table2array(T);
closs_temp_managed(:,1:19)=crownloss_manag(:,1:19);
opts = detectImportOptions('diam_crownarea_manag.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_crownarea_manag.txt',opts,'ReadVariableNames',true);
diam_crownarea_managed=table2array(T);
carea_temp_managed(:,1:19)=diam_crownarea_managed(:,1:19);

%get only time range 1985-2010
carea_temp_years_man=timerange(carea_temp_managed,3);
closs_temp_years_man=timerange(closs_temp_managed,3);

%adjust canopy area if it reaches patch area
[closs_man,carea_man]=canopy_area_mort_adjusted(closs_temp_years_man, carea_temp_years_man, 1985,1);
for i=1:25
    [closs_man1,carea_man1]=canopy_area_mort_adjusted(closs_temp_years_man, carea_temp_years_man, 1985+i,i+1);
    closs_man=vertcat(closs_man, closs_man1);
    carea_man=vertcat(carea_man, carea_man1);
    clear carea_man1 closs_man1
end

%calculate canopy mortality exclude <10cm
carea_total_man(:,1)=sum(carea_man(:,5:19),2);
closs_total_man(:,1)=sum(closs_man(:,5:19),2);
canopy_mort_sim_years_man(:,1:3)=carea_man(:,1:3);
canopy_mort_sim_years_man(:,4)=closs_total_man(:,1)./carea_total_man(:,1);
clear closs carea
%calculate canopy mortality exclude <40cm
carea_total_man_overstory(:,1)=sum(carea_man(:,8:19),2);
closs_total_man_overstory(:,1)=sum(closs_man(:,8:19),2);
canopy_mort_sim_years_man_overstory(:,1:3)=carea_man(:,1:3);
canopy_mort_sim_years_man_overstory(:,4)=closs_total_man_overstory(:,1)./carea_total_man_overstory(:,1);
clear closs carea

%find which country coodinates correspond to and add country fao nbr
canopy_mort_sim_years_man=country_nbr(canopy_mort_sim_years_man,5);
canopy_mort_sim_years_man_overstory=country_nbr(canopy_mort_sim_years_man_overstory,5);

%get EU median and sort by country
canopy_mort_sim_years_med_man=median_europe(canopy_mort_sim_years_man);
canopy_mort_sim_years_med_man=sortrows(canopy_mort_sim_years_med_man,3);
canopy_mort_sim_years_med_man_overstory=median_europe(canopy_mort_sim_years_man_overstory);
canopy_mort_sim_years_med_man_overstory=sortrows(canopy_mort_sim_years_med_man_overstory,3);

%transform fractions to percentage
canopy_mort_sim_years_med_man(:,2)=canopy_mort_sim_years_med_man(:,2).*100;
canopy_mort_sim_years_med_man_overstory(:,2)=canopy_mort_sim_years_med_man_overstory(:,2).*100;

%% calculate Central European canopy mortality rate for managed to plot as
%function of size

%calculate mortality
central_europe_mort(:,1:3)=closs_man(:,1:3);
central_europe_mort(:,4:19)=closs_man(:,4:19)./carea_man(:,4:19);

%sort by latitude and longitude
central_europe_mort=sortrows(central_europe_mort,1);
central_europe_mort=sortrows(central_europe_mort,2);
central_europe_mort=sortrows(central_europe_mort,1);

%transform fractions to percentage
central_europe_mort(:,4:19)=central_europe_mort(:,4:19).*100;

%compile moving averages over all years by location
[nbrrows_locat,~]=size(central_europe_mort);
%start index to extract time range at one cell at a time
%(to ensure that the last addition to count does not cause an error 
%in if statement--> nbrrows_locat+1)
start_ind=1:26:nbrrows_locat+1; 
count=1;
for i=1:nbrrows_locat
    if i==start_ind(count) %if loop at first year of next cell
        central_europe_mort_smooth(i:i+25, 1:16)= movmean(central_europe_mort(i:i+25,4:19), 26, 'omitnan','SamplePoints', central_europe_mort(i:i+25,3));
        count=count+1;
    end
end

%omit inf
ind_inf=central_europe_mort_smooth==Inf;
central_europe_mort_smooth(ind_inf==1)=NaN;

%get EU median 
central_europe_mort_median(1,1:16)=median(central_europe_mort_smooth(:,1:16),1, 'omitnan');

%% plot all in figure(1)
%add labels (a, b, c) in corners of figure panels
char_num = 7;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot data from LPJ-GUESS model and Senf et al. (2018) with best fit line
%and 95% confidence interval
figure(1)
tit=['AT'; 'DE';'CZ'; 'PL'; 'SK'; 'CH']; %titles of tiles
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156); %country row indices of LPJ-GUESS
cntr_senf=vertcat(1:26, 53:78, 27:52, 79:104, 105:130, 131:156); %country row indices of Senf et al. (2018)

%arrays for statistical values
SE=zeros(3,6);
SEs_mean=zeros(3,6);
all_avs=zeros(3,6);
p_senf=zeros(6,2);
p_mod_man10=zeros(6,2);
p_mod_man40=zeros(6,2);

%initiate figure(1)
t=tiledlayout(2,4, 'TileSpacing', 'compact');
ColorSpec = [0.2 0.1 0.9;
            0.7 0 0.4
            0.9 0.5 0.1];
tileorder=[1 2 3 5 6 7];
for j=1:6
    x = 1985:2010;
    y=[Senf_years(cntr_senf(j,:),3)';canopy_mort_sim_years_med_man(cntr(j,:),2)';canopy_mort_sim_years_med_man_overstory(cntr(j,:),2)'];
    %get mean and SE of mean
    for i=1:3
        SEs_mean(i,j)=std((y(i,:)))/sqrt(length((y(i,:))));
        all_avs(i,j)=mean(y(i,:));
    end
    %calculate trend and confidence interval managed<10
    pop=canopy_mort_sim_years_med_man(cntr(j,:),2)';
    [p_mod_man10(j,1:2), yhat, ci ]=polypredci(x, pop, 1); %linear regression (yhat: fitted regression line, ci: confidence interval)
    yhat=yhat';
    ci=ci';    
    %calculate Standard Error (SE) of trend
    mdl=fitlm(x,pop);    
    SE(1,j)=mdl.Coefficients.SE(2);
    %plot trend and confidence interval managed<10
    nexttile(tileorder(j))
    hold on
    plot(x,yhat,'Color', [169 169 169]/255) %fitted line
    plot(x,yhat+ci,'Color', [169 169 169]/255) %confidence interval
    plot(x,yhat-ci, 'Color', [169 169 169]/255) %confidence interval
    hline = findobj(gcf, 'type', 'line');
    set(hline(1),'LineStyle','--')
    set(hline(2),'LineStyle','--')
    hold off
    %calculate trend and confidence interval managed<40
    pop=canopy_mort_sim_years_med_man_overstory(cntr(j,:),2)';
    [p_mod_man40(j,1:2), yhat, ci ]=polypredci(x, pop, 1); %linear regression (yhat: fitted regression line, ci: confidence interval)
    yhat=yhat';
    ci=ci';    
    %calculate Standard Error (SE) of trend
    mdl=fitlm(x,pop);    
    SE(2,j)=mdl.Coefficients.SE(2);
    %plot trend and confidence interval managed<40
    hold on
    plot(x,yhat,'Color', [169 169 169]/255) %fitted line
    plot(x,yhat+ci,'Color', [169 169 169]/255) %confidence interval
    plot(x,yhat-ci, 'Color', [169 169 169]/255) %confidence interval
    hline = findobj(gcf, 'type', 'line');
    set(hline(1),'LineStyle','--')
    set(hline(2),'LineStyle','--')
    hold off
    %calculate trend and confidence interval senf et al. (2018)
    pop=Senf_years(cntr_senf(j,:),3)';
    [p_senf(j,1:2), yhat, ci ]=polypredci(x, pop, 1); %linear regression (yhat: fitted regression line, ci: confidence interval)
    yhat=yhat';
    ci=ci';
    %calculate Standard Error (SE) of trend
    mdl=fitlm(x,pop);    
    SE(3,j)=mdl.Coefficients.SE(2);
    %plot trend and confidence interval senf et al. (2018)   
    hold on
    c=plot(x,yhat,'Color', [169 169 169]/255); %fitted line
    plot(x,yhat+ci,'Color', [169 169 169]/255) %confidence interval
    d=plot(x,yhat-ci, 'Color', [169 169 169]/255); %confidence interval
    hline = findobj(gcf, 'type', 'line');
    set(hline(1),'LineStyle','--')
    set(hline(2),'LineStyle','--')
    %plot all time series
    a1=plot(x,y(1,:), 'Color', ColorSpec(1,1:3)); %Senf
    a2=plot(x,y(2,:), 'Color', ColorSpec(2,1:3)); %mortality (10 cm threshold)
    a3=plot(x,y(3,:), 'Color', ColorSpec(3,1:3)); %mortality (40 cm threshold)
    hold off
    %set surrounding, add legend, text, colours, labels, etc.
    title(tit(j,:))
    if j==5
        hL = legend([a1,a2,a3,c,d],{'Estimated Canopy Mortality by Senf et al. (2018)',strcat('Canopy Mortality in managed simulation', string(newline), 'excluding trees DBH<10cm'),strcat('Canopy Mortality in managed simulation', string(newline), 'excluding trees DBH<40cm'),'fitted line', '95% confidence interval'},'NumColumns',3,'FontSize',9);
        legend('boxoff')
        hL.Location = 'southoutside';
    end
    ylim([0 3.5])
    xlim([1985 2010])
    %remove y and x label of middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('canopy mortality in %/yr');
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

%add larger tile with Central European median canopy mortality as a
%function of stem size
nexttile(4,[2 1]);
x=10:10:80;
plot(x,central_europe_mort_median(1:8), 'k');
xlim([10 80])
diam_cate=categorical({'0-10' '20-30' '40-50' '60-70'});
set(gca,'XTick',10:20:80,'XTickLabel',diam_cate)
xlabel('stem diameter (cm)')
ylabel('canopy mortality in %/yr')
title({'Central European median canopy', 'mortality as a function of stem size'});
%add letter in corner
text(0.015,0.95,chars_let{7},'Units','normalized','FontSize',11)
t.Padding = 'none';
t.TileSpacing = 'none';
