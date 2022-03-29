%Calculation and plotting of different mortality metrics in Central Europe
%Marieke Scheel

%% stem mortality 
% import (mortality=stemloss/diam_dens), apply threshold of 10 cm
opts = detectImportOptions('stemloss.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('stemloss.txt',opts,'ReadVariableNames',true);
stemloss=table2array(T);
stemloss_total(:,1)=sum(stemloss(:,5:19),2);
opts = detectImportOptions('diam_dens.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_dens.txt',opts,'ReadVariableNames',true);
diam_dens=table2array(T);
diam_dens_total(:,1)=sum(diam_dens(:,5:19),2);
stem_mort(:,1:3)=diam_dens(:,1:3);
stem_mort(:,4)=stemloss_total(:,1)./diam_dens_total(:,1);

%get time range 1985-2010
stem_mort_sim_years=timerange(stem_mort,3);

%find which country coodinates correspond to and add country fao nbr
stem_mort_sim_years=country_nbr(stem_mort_sim_years,5);

%transform fractions to percentage
stem_mort_sim_years(:,4)=stem_mort_sim_years(:,4).*100;

%get EU average and sort by country
stem_mort_sim_years_med=median_all_europe(stem_mort_sim_years);

%add labels (a, b, c) in corners of figure panels
char_num = 3;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%get average, trend (p from polypredci) and SE
all_av=zeros(1,3);
all_se=zeros(1,3);
SE=zeros(1,3);

%plot first panel in figure 1
figure(1)
t=tiledlayout(1,3, 'TileSpacing', 'compact','Padding','Compact');
t.TileSpacing = 'none';
nexttile
title('Stem')
x = transpose(1985:2010); 
y = stem_mort_sim_years_med(:,2);
%calculate mean and SE of mean
all_av(1,1)=mean(y);
all_se(1,1)=std(y)/sqrt(length(y));
%calculate linear regression line (p(1): trend, yhat: fitted regression line, ci: confidence interval)
[p_stem, yhat, ci ]=polypredci(x, y, 1); 
%calculate Standard Error (SE) of trend
mdl=fitlm(x,y);    
SE(1,1)=mdl.Coefficients.SE(2);
%plot stem mortality in figure
hold on
plot(x,yhat,'-','LineWidth',1.15, 'Color', [0 0 0]) %plot trend line
plot(x,yhat+ci,'--','LineWidth',1.15, 'Color', [0 0 0]) %plot confidence interval
plot(x,yhat-ci,'--','LineWidth',1.15, 'Color', [0 0 0]) %plot confidence interval
plot(x,y,'LineWidth',2,'Color', [1 0 0]); %plot time series on top
hold off
xlim=[1985,2010];
ylim1=[1.4,4.1];
%linear equation
if p_stem(2) > 0 %if intercept is positive
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x+%.1f',p_stem(1),p_stem(2))); 
else %if intercept is negative
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x%.1f',p_stem(1),p_stem(2))); 
end
set(htext,'Color',[0 0 0])
clear xlim    
xlabel('year')
ylabel('mortality (%/yr)')
clear ylim
ylim([1.4 4.1])
title(t,'Central European mortality rates (managed simulation)');
set(gca,'XTick',1985:10:2010)
xlim([1985 2010])
%letter in panel corner
text(0.015,0.95,chars_let{1},'Units','normalized','FontSize',11)

%% canopy mortality
% import files (mortality=crownloss/diam_crownarea), apply threshold of 10 cm
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

%sort canopy area and loss by longitude and latitude
closs=sortrows(closs,1);
closs=sortrows(closs,2);
closs=sortrows(closs,1);
carea=sortrows(carea,1);
carea=sortrows(carea,2);
carea=sortrows(carea,1);
%calculate canopy mortality
carea_total(:,1)=sum(carea(:,5:19),2);
closs_total(:,1)=sum(closs(:,5:19),2);
canopy_mort_sim_years(:,1:3)=carea(:,1:3);
canopy_mort_sim_years(:,4)=closs_total(:,1)./carea_total(:,1);
clear closs carea closs_total carea_total

%find which country coodinates correspond to and add country fao nbr
canopy_mort_sim_years=country_nbr(canopy_mort_sim_years,5);
canopy_mort_sim_years=sortrows(canopy_mort_sim_years,5);

%transform fractions to percentage
canopy_mort_sim_years(:,4)=canopy_mort_sim_years(:,4).*100;

%get EU average and sort by country
canopy_mort_sim_years_med=median_all_europe(canopy_mort_sim_years);

%plot second panel in figure 1
nexttile
title('Canopy')
x = transpose(1985:2010); 
y = canopy_mort_sim_years_med(:,2);
%calculate mean and SE of mean
all_av(1,2)=mean(y);
all_se(1,2)=std(y)/sqrt(length(y));
%calculate linear regression line (p(1): trend, yhat: fitted regression line, ci: confidence interval)
[p_canop, yhat, ci ]=polypredci(x, y, 1); 
%calculate Standard Error (SE) of trend
mdl=fitlm(x,y);    
SE(1,2)=mdl.Coefficients.SE(2);
%plot canopy mort in figure
hold on
d=plot(x,yhat,'-','LineWidth',1.15, 'Color', [0 0 0]); %plot trend line
e=plot(x,yhat+ci,'--','LineWidth',1.15, 'Color', [0 0 0]);  %plot confidence interval
plot(x,yhat-ci,'--','LineWidth',1.15, 'Color', [0 0 0])  %plot confidence interval
b=plot(x,y,'LineWidth',2,'Color', [0 0.5 1]); %plot time series on top
hold off
ylim1=[1.4,4.1];
xlim=[1985,2010];
%linear equation
if p_canop(2) > 0 %if intercept is positive
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x+%.1f',p_canop(1),p_canop(2))); 
else %if intercept is negative
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x%.1f',p_canop(1),p_canop(2))); 
end
set(htext,'Color',[0 0 0])
clear xlim 
clear ylim
ylim([1.4 4.1])
xlabel('year')  
%plot blank lines in colours of time series in panel a and c for legend
hold on
a=plot(nan,nan,'LineWidth',2,'Color', [1 0 0]);
c=plot(nan, nan, 'LineWidth',2,'Color', [0.3 0.1 0.4]);
hold off        
set(gca,'YTickLabel',[]);
set(gca,'XTick',1985:10:2010)
xlim([1985 2010])
%legend for entire figure
hL=legend([a,b,c,d,e], 'stem mortality', 'canopy mortality','carbon mortality','fitted line','95% confidence interval','NumColumns',3,'FontSize',9);
legend('boxoff')
hL.Location = 'southoutside'; 
%letter in panel corner
text(0.015,0.95,chars_let{2},'Units','normalized','FontSize',11)

%% carbon mortality
% import (mortality=closs/diam_cmass_wood), apply threshold of 10 cm)
opts = detectImportOptions('closs.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('closs.txt',opts,'ReadVariableNames',true);
closs=table2array(T);
closs_total(:,1)=sum(closs(:,5:19),2);
opts = detectImportOptions('diam_cmass_wood.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_cmass_wood.txt',opts,'ReadVariableNames',true);
diam_cmass=table2array(T);
diam_cmass_total(:,1)=sum(diam_cmass(:,5:19),2);
carbon_mort(:,1:3)=diam_cmass(:,1:3);
carbon_mort(:,4)=closs_total(:,1)./diam_cmass_total(:,1);

%get only time range 1985-2010
carbon_mort_sim_years=timerange(carbon_mort,3);

%find which country coodinates correspond to and add country fao nbr
carbon_mort_sim_years=country_nbr(carbon_mort_sim_years,5);

%transform fractions to percentage
carbon_mort_sim_years(:,4)=carbon_mort_sim_years(:,4).*100;

%get EU average and sort by country
carbon_mort_sim_years_med=median_all_europe(carbon_mort_sim_years);

%plot third panel in figure 1
nexttile
title('Carbon')
x = transpose(1985:2010); 
y = carbon_mort_sim_years_med(:,2);
%calculate mean and SE of mean
all_av(1,3)=mean(y);
all_se(1,3)=std(y)/sqrt(length(y));
%calculate linear regression line (p(1): trend, yhat: fitted regression line, ci: confidence interval)
[p_carbon, yhat, ci ]=polypredci(x, y, 1); 
%calculate Standard Error (SE) of trend
mdl=fitlm(x,y);    
SE(1,3)=mdl.Coefficients.SE(2);
%plot carbon mortality in figure
hold on
plot(x,yhat,'-','LineWidth',1.15, 'Color', [0 0 0]); %plot trend line
plot(x,yhat+ci,'--','LineWidth',1.15, 'Color', [0 0 0]); %plot confidence interval
plot(x,yhat-ci,'--','LineWidth',1.15, 'Color', [0 0 0]) %plot confidence interval
plot(x,y,'LineWidth',2,'Color', [0.3 0.1 0.4]); %plot time series on top
hold off
ylim1=[1.4,4.1];
xlim=[1985,2010];
if p_carbon(2) > 0 %if intercept is positive
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x+%.1f',p_carbon(1),p_carbon(2))); 
else %if intercept is negative
    htext=text(xlim(1)+12,ylim1(2)-0.05,sprintf('y= %.4f*x%.1f',p_carbon(1),p_carbon(2))); 
end
set(htext,'Color',[0 0 0])
clear xlim    
clear ylim
ylim([1.4 4.1])
xlabel('year')
set(gca,'YTickLabel',[]);
set(gca,'XTick',1985:10:2010)
xlim([1985 2010])
%letter in panel corner
text(0.015,0.95,chars_let{3},'Units','normalized','FontSize',11)