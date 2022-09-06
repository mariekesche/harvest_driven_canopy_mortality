%Plot harvest clear-cut and thinning rates (LPJ-GUESS) in comparison with 
% NFI harvest rates Germany
%Marieke Scheel

%add path for helper functions and dependencies
addpath('../helper_functions');
addpath('../data/dependencies');
addpath('../data/manag_nofix');
addpath('../data/harvest_checks');

%% clearcut harvest rate used in LPJ-GUESS model
%import landcover_europe (input to LPJ-GUESS model, showing harvest as 
%changes from "natural" to "forest")
opts = detectImportOptions('landcover_eu.txt');
T = readtable('landcover_eu.txt',opts,'ReadVariableNames',false);
landcover_eu=table2array(T);
landcover_eu_time=zeros(70408,3);

%filter only timerange 2003-2010, col4: natural, col5: forest
[nbrRows,~]=size(landcover_eu);
j=1;
for i=1:nbrRows
    if landcover_eu(i,3)>=2003 && landcover_eu(i,3) <=2010
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
landcover_cent_eu=zeros(3792,5);
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
change_fraction=zeros(3792,1);
for i=1:nbrRows
    if landcover_cent_eu(i,3)~=2003
        change_fraction(i,1)=landcover_cent_eu(i-1,4)-landcover_cent_eu(i,4); %change between years, with "change" in 1985 being set to 0
        landcover_cent_eu(i,6)=change_fraction(i,1).*100./(landcover_cent_eu(i,4)+landcover_cent_eu(i,5)); %transform to percentage by dividing by total (natural+forest; their sum stays same over time in resp. cell)
    elseif landcover_cent_eu(i,3)==2003
        change_fraction(i,1)=0;
        landcover_cent_eu(i,6)=0;
    end
end
clear change_fraction

%find which country coodinates correspond to and add country fao nbr
landcover_cent_eu=country_nbr(landcover_cent_eu,7);

%extract Germany (FAO nbr 79)
landcover_cent_eu=sortrows(landcover_cent_eu,7);
landcover_ger=landcover_cent_eu(313:1816,:);

%get average per grid cell (in time range all have same annual values per grid cell, so
%extract 2010 from all)
[nbrRows,~]=size(landcover_ger);
landcover_ger_av=zeros(nbrRows./8,7);
count=1;
for i= 1:nbrRows
    if landcover_ger(i,3)==2010
        landcover_ger_av(count,:)=landcover_ger(i,:);
        count=count+1;
    end
end

%% thinning harvest rates biomass and stem
%import total biomass
opts = detectImportOptions('diam_cmass_wood.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_cmass_wood.txt',opts,'ReadVariableNames',true);
T=table2array(T);
%apply threshold 10 cm
cmass_10(:,1:3)=T(:,1:3);
cmass_10(:,4)=sum(T(:,5:19),2);
%import biomass loss due to harvest thinning
T = readtable('closs_harv.txt',opts,'ReadVariableNames',true);
T=table2array(T);

%timerange 2003-2010
closs_harv_10=timerange_harvest(horzcat(T(:,1:3),(sum(T(:,5:19),2)./cmass_10(:,4).*100)),3);

%import total nbr stems
opts = detectImportOptions('diam_dens.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('diam_dens.txt',opts,'ReadVariableNames',true);
T=table2array(T);
%apply threshold 10 cm
stem_10(:,1:3)=T(:,1:3);
stem_10(:,4)=sum(T(:,5:19),2);
%import stem loss due to harvest thinning
T = readtable('stemloss_harv.txt',opts,'ReadVariableNames',true);
T=table2array(T);

%timerange 2003-2010
stemloss_harv_10=timerange_harvest(horzcat(T(:,1:3),(sum(T(:,5:19),2)./stem_10(:,4).*100)),3);

%add FAO country nbr
closs_harv_cntr=country_nbr(closs_harv_10,5);
stemloss_harv_cntr=country_nbr(stemloss_harv_10,5);

%extract cells in Germany
closs_harv_Germany=closs_harv_cntr(561:1876,:);
stemloss_harv_Germany=stemloss_harv_cntr(561:1876,:);

%mean over time period
[nbrRows,~]=size(closs_harv_Germany);
thin_bio_Germ_av=zeros(nbrRows./7,3);
thin_stem_Germ_av=zeros(nbrRows./7,3);
yr=0;
added_rates_bio=zeros(7,5);
added_rates_stem=zeros(7,5);
count1=1;
count2=1;
for i=1:nbrRows
    if closs_harv_Germany(i,3)~=yr
        added_rates_bio(count1,:)=closs_harv_Germany(i,:);
        added_rates_stem(count1,:)=stemloss_harv_Germany(i,:);
        yr=2004;
        count1=count1+1;
    else
        thin_bio_Germ_av(count2,1:2)=added_rates_bio(1,1:2);
        thin_bio_Germ_av(count2,3)=mean(added_rates_bio(:,4));
        thin_stem_Germ_av(count2,1:2)=added_rates_stem(1,1:2);
        thin_stem_Germ_av(count2,3)=mean(added_rates_stem(:,4));
        count1=1;
        count2=count2+1;
        added_rates_bio(count1,:)=closs_harv_Germany(i,:);
        added_rates_stem(count1,:)=stemloss_harv_Germany(i,:);  
        yr=0;
    end
end
thin_bio_Germ_av(count2,1:2)=added_rates_bio(1,1:2);
thin_bio_Germ_av(count2,3)=mean(added_rates_bio(:,4));
thin_stem_Germ_av(count2,1:2)=added_rates_stem(1,1:2);
thin_stem_Germ_av(count2,3)=mean(added_rates_stem(:,4));

%% NFI data
%import
opts = detectImportOptions('NFI_Germany.txt');
T = readtable('NFI_Germany.txt',opts,'ReadVariableNames',false);
NFI_Germany=table2array(T);

%threshold n<50
[nbrRows,~]=size(NFI_Germany);
NFI_Germany_thresh=zeros(186,16);
count=1;
for i= 1:nbrRows
    if NFI_Germany(i,3)>=50
        NFI_Germany_thresh(count,:)=NFI_Germany(i,:);
        count=count+1;
    end
end

%% extract same cells from NFI and LPJ
[nbrRowsLPJ,~]=size(thin_stem_Germ_av);
[nbrRowsNFI,~]=size(NFI_Germany_thresh);
LPJ_thin_bio_loc=zeros(175,3);
LPJ_thin_stem_loc=zeros(175,3);
NFI_Germany_loc=zeros(175,16);
landcover_ger_av_loc=zeros(175,7);
count1=1;
count2=1;
for i=1:nbrRowsLPJ
    for j=1:nbrRowsNFI
        if thin_stem_Germ_av(i,1)==NFI_Germany_thresh(j,2) && thin_stem_Germ_av(i,2)==NFI_Germany_thresh(j,1)
            LPJ_thin_bio_loc(count1,:)=thin_bio_Germ_av(i,:);
            landcover_ger_av_loc(count1,:)=landcover_ger_av(i,:);
            LPJ_thin_stem_loc(count1,:)=thin_stem_Germ_av(i,:);
            NFI_Germany_loc(count2,:)=NFI_Germany_thresh(j,:);
            count1=count1+1;
            count2=count2+1;
        end
    end
end

%make NFI lat lon in same cols as LPJ output (is in same order!)
NFI_Germany_loc(:,1:2)=LPJ_thin_bio_loc(:,1:2);


%% plot NFI vs LPJ-GUESS

%add labels (a, b, c) in corners of figure panels
char_num = 2;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

figure(1)
%boxplot groups
g1 = repmat({'NFI biomass'},175,1);
g2 = repmat({'LPJ-GUESS biomass'},175,1);
g3 = repmat({'NFI stem'},175,1);
g4 = repmat({'NFI biomass'},175,1);
g5 = repmat({'LPJ-GUESS biomass'},175,1);
g6 = repmat({'NFI stem'},175,1);
g7 = repmat({'LPJ-GUESS stem'},175,1);

%two subtiles
t=tiledlayout(2,1, 'TileSpacing', 'compact');

%clear-cut tile
nexttile
boxplot([NFI_Germany_loc(:,12).*100,  landcover_ger_av_loc(:,6), NFI_Germany_loc(:,11).*100], [g1; g2; g3], 'Notch','on'); %NFI from fraction to perc
ylabel('harvest %/yr')
title('Clear-cut')
ylim([0 4])

%change colors of boxes
colors = flipud([0, 76/256, 153/256; 102/256, 178/256, 255/256; 255/256, 128/256, 0]);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
end

%change colors of median line
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');

%change colors of outliers
n = findobj(gcf,'tag','Outliers');
for j = 1:numel(n)
       n(j).MarkerEdgeColor = 'k';
end

%add letter in corner of tile
text(0.015,0.95,chars_let{1},'Units','normalized','FontSize',11)

%thinning tiles
nexttile
boxplot([NFI_Germany_loc(:,15).*100, LPJ_thin_bio_loc(:,3), NFI_Germany_loc(:,14).*100, LPJ_thin_stem_loc(:,3)], [g4; g5; g6; g7], 'Notch','on'); %NFI from fraction to perc
title('Thinning')
ylabel('harvest %/yr')
ylim([0 4])

%change colors of boxes
colors = flipud([0, 76/256, 153/256; 102/256, 178/256, 255/256; 255/256, 128/256, 0; 255/256, 178/256, 102/256]);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
end

%change colors of median line
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'k');

%change colors of outliers
n = findobj(gcf,'tag','Outliers');
for j = 1:numel(n)
       n(j).MarkerEdgeColor = 'k';
end

%add letter in corner of tile
text(0.015,0.95,chars_let{2},'Units','normalized','FontSize',11)

%add general title
title(t,'Comparison of German harvest rates 2004-2010')
t.TileSpacing = 'compact';
t.Padding = 'none';
