%Calculation and plotting of biomass by diameter in countries over time
%Marieke Scheel

%add path for helper functions and data
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/PNV');

%plot canopy area vs tree diameter
%import variable
opts = detectImportOptions('diam_cmass_wood.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_cmass_wood.txt',opts,'ReadVariableNames',true);
diam_biomass=table2array(T);

%get only time range 1985-2010
diam_biomass_yrs=timerange(diam_biomass,3);

%find which country coodinates correspond to and add country fao nbr
diam_biomass_yrs=country_nbr(diam_biomass_yrs,20);

%sort by country
diam_biomass_yrs=sortrows(diam_biomass_yrs,20);

%get EU average and sort by country
diam_biomass_yrs_av=mean_europe_sev_cols(diam_biomass_yrs, 20);

%extract 1985, 1997 and 2010
diam_biomass_1985=diam_biomass_yrs_av(1:6,:);
diam_biomass_1997=diam_biomass_yrs_av(73:78,:);
diam_biomass_2010=diam_biomass_yrs_av(151:156,:);

%add labels (a, b, c, etc.) for corners
char_num = 6;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot
figure(1)
tit=['AT'; 'DE';'CZ'; 'PL'; 'SK'; 'CH']; %titles
t=tiledlayout(2,3, 'TileSpacing', 'compact');
for j=1:6
    nexttile
    x=10:10:140; %diameter
    hold on
    plot(x,diam_biomass_1985(j,2:15), 'k');
    plot(x,diam_biomass_1997(j,2:15), 'b');
    plot(x,diam_biomass_2010(j,2:15), 'r');
    hold off
    xlim([10 80])
    ylim([0 3])
    diam_cate=categorical({'0-10' '20-30' '40-50' '60-70'});
    title(tit(j,:))
    %add letter in corner
    text(0.015,0.95,chars_let{j},'Units','normalized','FontSize',11)
    %add legend
    if j==5
        hL = legend('1985','1997', '2010', 'NumColumns',3,'FontSize',10);
        legend('boxoff')
        hL.Location = 'southoutside';    
    end
    %remove y and x label in middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('biomass (kg[C]/m^2)');
    end
    if j~=4 && j~=5 && j~=6
        set(gca,'XTickLabel',[]);
    else
        set(gca,'XTick',10:20:80,'XTickLabel',diam_cate)
        xlabel('stem diameter (cm)');
    end
end
t.Padding = 'none';
t.TileSpacing = 'none';
title(t,{'Mean biomass vs. stem diameter in Central'}, {'European countries (PNV)'});
