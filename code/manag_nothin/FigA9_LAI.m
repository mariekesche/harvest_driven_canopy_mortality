%Plotting LAI of different European species and PFTs over the time period
%1985-2010 in six Central European countries
%Marieke Scheel

%import lai file
opts = detectImportOptions('lai.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('lai.txt',opts,'ReadVariableNames',true);
lai(:,1:25)=table2array(T(:,1:25));

%get only time range 1985-2010
lai_sim_years=timerange(lai,3);

%find which country the coodinates correspond to and add country fao nbr
lai_sim_years=country_nbr(lai_sim_years,26);

%get EU median and sort by country
lai_sim_years_med=median_europe_sev_cols(lai_sim_years,26);
lai_sim_years_med=sortrows(lai_sim_years_med,24);

%add labels (a, b, c) in corners of figure panels
char_num = 6;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot LAI in a cumulative area graph
figure(6)
tit=['AT'; 'DE';'CZ'; 'PL'; 'SK'; 'CH']; %subfigure titles (country names)
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156); %range of values of resp. countries
t=tiledlayout(2,3, 'TileSpacing', 'compact'); %figure layout
%create colour pallett for figure
newcolors=vertcat(brewermap(9,'Set1'),brewermap(6,'Set2'),brewermap(6,'Dark2')); %colours
newcolors(1,:)=[1 0 0];
newcolors(4,:)=[0.9 0.9 1];
newcolors(6,:)=[1 1 0.7];
newcolors(8,:)=[0.5 0.8 1];
newcolors(15,:)=[1 1 0];
newcolors(16,:)=[0.6 0.2 0.9];
newcolors(22,:)=[0.6350 0.0780 0.1840];
%plot for each country
for j=1:6
    nexttile
    x = transpose(1985:2010); %timerange
    y = lai_sim_years_med(cntr(j,:)',2:23); %lai of PFTs and species
    a=area(x,y);
    %edge and area colours
    for n=1:22
        a(n).EdgeColor= 'none';
    end
    colororder(newcolors(1:22,:))
    %titles of subfigures
    title(tit(j,:)) 
    xlim([1985 2010])
    %add legend
    if j==5
        hL = legend('Abi\_alb','BES','Bet\_pen', 'Bet\_pub', 'Car\_bet', 'Cor\_ave', 'Fag\_syl', 'Fra\_exc', 'Jun\_oxy', 'Lar\_dec', 'MRS', 'Pic\_abi', 'Pin\_syl', 'Pin\_hal', 'Pop\_tre', 'Que\_coc', 'Que\_ile', 'Que\_pub', 'Que\_rob', 'Til\_cor', 'Ulm\_gla', 'C3\_gr' ,'NumColumns',6,'FontSize',9);
        legend('boxoff')
        hL.Location = 'southoutside';    
    end
    %remove y and x label in middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('LAI')
    end
    if j~=4 && j~=5 && j~=6
        set(gca,'XTickLabel',[]);
    else
        xlabel('year')
    end
    ylim([0 9])    
    %add letter in corner
    text(0.015,0.95,chars_let{j},'Units','normalized','FontSize',11)
end
%overall figure title
title(t, {'LAI composition in Central European'},{'countries (managed no thinning)'});
%padding and spacing
t.Padding = 'none';
t.TileSpacing = 'none';