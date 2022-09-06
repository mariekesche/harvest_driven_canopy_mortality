%Plot harvest rates used in LPJ-GUESS model vs harvest rate calculated from
%FAO wood area estimates and wood removeal estimates by Ceccherini et al. 
%(2020)
%Marieke Scheel

%add path for helper functions and dependencies
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/harvest_checks');

%% harvest rate used in LPJ-GUESS model
%import landcover_europe (input to LPJ-GUESS model, showing harvest as 
%changes from "natural" to "forest")
opts = detectImportOptions('landcover_eu.txt');
T = readtable('landcover_eu.txt',opts,'ReadVariableNames',false);
landcover_eu=table2array(T);
landcover_eu_time=zeros(70408,3);

%filter only timerange 1985-2010, col4: natural, col5: forest
[nbrRows,~]=size(landcover_eu);
j=1;
for i=1:nbrRows
    if landcover_eu(i,3)>=1985 && landcover_eu(i,3) <=2010
        landcover_eu_time(j,1:2)=landcover_eu(i,1:2);
        landcover_eu_time(j,3:5)=landcover_eu(i,3:5);
        j=j+1;
    end
end

%import gridlist (coordinates and country of simulated cells)
opts = detectImportOptions('gridlist.txt');
T = readtable('gridlist.txt',opts,'ReadVariableNames',false);
gridlist=table2array(T);

%find simulated places in landcover
Lia=ismember(landcover_eu_time(:,1:2),gridlist(:,1:2),'rows');
[nbrRows,~]=size(landcover_eu_time);
landcover_cent_eu=zeros(12324,5);
count=1;
for i=1:nbrRows
    if Lia(i,1)==1
        landcover_cent_eu(count,:)=landcover_eu_time(i,:);
        count=count+1;
    end
end

%add column with harvest fraction (natural becoming forest= harvest), so
%change in natural between years is harvest fraction
[nbrRows,~]=size(landcover_cent_eu);
for i=1:nbrRows
    if landcover_cent_eu(i,3)~=1985
        change_fraction(i,1)=landcover_cent_eu(i-1,4)-landcover_cent_eu(i,4); %change between years, with "change" in 1985 being set to 0
        landcover_cent_eu(i,6)=change_fraction(i,1).*100./(landcover_cent_eu(i,4)+landcover_cent_eu(i,5)); %transform to percentage by dividing by total (natural+forest; their sum stays same over time in resp. cell)
    elseif landcover_cent_eu(i,3)==1985
        change_fraction(i,1)=0;
        landcover_cent_eu(i,6)=0;
    end
end

%find which country coodinates correspond to and add country fao nbr
landcover_cent_eu=country_nbr(landcover_cent_eu,7);

%get EU average and sort by country
landcover_cent_eu=sortrows(landcover_cent_eu,7);
landcover_cent_eu=sortrows(landcover_cent_eu,3);
harvest_med=median_europe_harvest(landcover_cent_eu, 7,6);
harvest_med=sortrows(harvest_med,3);

%% calculate harvest rate given by FAO total forest area and wood removal rates given by Ceccherini et al. (2020) 
%import FAO total forest area (order of countries same as lpjguess data)
opts = detectImportOptions('FAO_forest_area_data.xlsx');
T = readtable('FAO_forest_area_data.xlsx',opts,'ReadVariableNames',false);
FAO_area=table2array(T);
FAO_area(:,3)=FAO_area(:,3).*1000; %make unit ha

%import Ceccherini et al. (2020) harvest statistics, order of countries 
%AT, CZ, DE, PL, SK [11,167,79,173,199]
opts = detectImportOptions('harvest_removal_Ceccherini.csv');
T = readtable('harvest_removal_Ceccherini.csv',opts,'ReadVariableNames',false);

%extract year and value calculated by Ceccerini (GFC)
[rownumb,~]=size(T);
GFC_array=3:5:rownumb; %col 4, rowvalues in GFC_array to extract calc values
GFC_stat_extr=T(GFC_array,4);
harvest_stats(:,1)=repmat(2004:2018,1,5)';
harvest_stats(:,2)=table2array(GFC_stat_extr); %GFC (Ceccherini values) added to col 2

%add factor of normalization of nat_stats (see Ceccerini figure extended
%6), add factor of normalization
GFC_array=2:5:rownumb;
GFC_norm=T(GFC_array,1); %extract col 1 with GFC norm vals
GFC_norm=join(erase(string(GFC_norm{:, :}), "'"), '', 2); %make string array
GFC_norm=regexprep(GFC_norm,'"','','ignorecase'); %remove " after number
GFC_norm=regexprep(GFC_norm,'=','','ignorecase'); %remove =
[rownum,~]=size(GFC_norm);
for i=1:rownum
    GFC_norm_temp = strsplit(GFC_norm{i,1}); %split text
    harv_norm(i,1) = str2num(GFC_norm_temp{3}); %GFC stat_norm col1
end

%denormalize values of forest loss (originally area values normalized by max area (unit kha, so *1000 to make ha)) 
harvest_stats(:,2)=harvest_stats(:,2).*harv_norm(:,1).*1000;

%assign country number to values by Ceccherini et al. (2020)
cntr_numb=vertcat(repmat(11,1,15)',repmat(167,1,15)',repmat(79,1,15)',repmat(173,1,15)',repmat(199,1,15)');
harvest_stats(:,3)=cntr_numb;
harvest_stats=sortrows(harvest_stats,3); %sorted same as lpj_guess values

%extract available timerange 2004-2010
[rownumb,~]=size(harvest_stats);
harvest_stats_years=[];
cnt=1;
for i=1:rownumb
    if harvest_stats(i,1) > 2003 && harvest_stats(i,1) <= 2010
        harvest_stats_years(cnt,:)=harvest_stats(i,:);
        cnt=cnt+1;
    end
end

%calculate forest loss values and transform to percentage by dividing by
%total area of forest (FAO)
harvest_stats_years(:,2)=harvest_stats_years(:,2)./FAO_area(:,3).*100;

%add 0 for CH since no data was available
harvest_stats_years(36:42,1:3)=0;

%% plot
%add labels (a, b, c) in corners of figure panels
char_num = 6;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot
figure(1)
tit=['AT'; 'DE';'CZ'; 'PL'; 'SK'; 'CH'];
cntr=vertcat(1:25, 26:50, 51:75, 76:100, 101:125, 126:150);  %LPJ-GUESS model harvest percentage
cntr2=vertcat(1:7, 8:14, 15:21, 22:28, 29:35, 36:42); %harvest percentage Ceccherini/FAO
t=tiledlayout(2,3, 'TileSpacing', 'compact');
cnt1=1;
cnt2=1;
for j=1:6
    %LPJ-GUESS values
    x = 1986:2010;
    pop=harvest_med(cntr(j,:),2)'; 
    [p, ~, ~ ]=polypredci(x, pop, 1);
    nexttile
    hold on
    plot(x',pop);
    hold off
    %Ceccherini/FAO harvest values
    x2=2004:2010;
    y=harvest_stats_years(cntr2(j,:),2);
    [p2, ~, ~ ]=polypredci(x2, y, 1);
    if j~=6 %no values for Switzerland
        hold on
        plot(x2,y);
        hold off
    end
    title(tit(j,:))
    ylim([0 1.5])
    xlim([1986 2010])
    %legend underneath 5th tile
    if j==5
        hL = legend('LPJ-GUESS input', 'Ceccherini et al. (2020) harvested area/FAO forest area', 'NumColumns',2,'FontSize',9); %Ceccherini calc values of forest loss/FAO forest area values
        legend('boxoff')
        hL.Location = 'southoutside';
    end
    %remove y and x label in middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('harvest %/yr')
    end
    if j~=4 && j~=5 && j~=6
        set(gca,'XTickLabel',[]);
    else
        xlabel('year')
    end
    %add letter in corner of tile
    text(0.015,0.95,chars_let{j},'Units','normalized','FontSize',11)
end
t.TileSpacing = 'none';
t.Padding = 'none';
