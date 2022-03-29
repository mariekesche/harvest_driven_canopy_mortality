%Plotting of forest biomass in the countries over time
%Marieke Scheel

%import forest biomass (cpool)
opts = detectImportOptions('cpool_forest_rel.txt');
opts.VariableNamingRule= 'preserve';
T = readtable('cpool_forest_rel.txt',opts,'ReadVariableNames',true);
cpool_forest(:,1:4)=table2array(T(:,1:4)); %1,2 col: lon,lat; 3: year; 4: Vegetation
[nbrRows, ~] = size(cpool_forest);

%get only time range 1985-2010
cpool_forest_years=timerange(cpool_forest,3);

%find which country coodinates correspond to and add country fao nbr
cpool_forest_years=country_nbr(cpool_forest_years,5);

%get EU average and sort by country
cpool_forest_years_med=median_europe(cpool_forest_years);
cpool_forest_years_med=sortrows(cpool_forest_years_med,3);

%add labels (a, b, c) in corners of figure panels
char_num = 6;
alph = ('a':'z').';
characts = num2cell(alph(1:char_num));
characts = characts.';
chars_let = strcat('(',characts,')'); %letters with brackets

%plot biomass
figure(1)
tit=['AT'; 'DE';'CZ'; 'PL'; 'SK'; 'CH']; %titles of tiles
cntr=vertcat(1:26, 27:52, 53:78, 79:104, 105:130, 131:156); %rows of respective country values
cntr_numb=vertcat(11,79,167,173,199,211); %FAO numbers
t=tiledlayout(2,3, 'TileSpacing', 'compact');
for j=1:6
    nexttile
    x =transpose(1985:2010); 
    y = cpool_forest_years_med(cntr(j,:)',2);
    %linear regression (p(1):trend, yhat: fitted regression line, ci:
    %confidence interval)
    [p, yhat, ci ]=polypredci(x, y, 1); 
    title(tit(j,:)) 
    ylim1=([4 7.7]);
    hold on
    b=plot(x,yhat,'-','LineWidth',1.15, 'Color', [0 0 0]); %trend line
    c=plot(x,yhat+ci,'--','LineWidth',1.15, 'Color', [0 0 0]); %confidence interval
    plot(x,yhat-ci,'--','LineWidth',1.15, 'Color', [0 0 0]); %confidence interval
    a=plot(x,y,'LineWidth',2,'Color', [1 0 0]); %biomass time series
    hold off
    xlim=[1985,2010];
    if p(2) > 0 %if intercept is positive
        htext=text(xlim(1)+12,ylim1(2),sprintf('y= %.4f*x+%.1f',p(1),p(2))); 
    else %if intercept is negative
        htext=text(xlim(1)+12,ylim1(2),sprintf('y= %.4f*x%.1f',p(1),p(2))); 
    end
    set(htext,'Color',[0 0 0])
    clear xlim
    xlim([1985 2010])
    ylim([4 8])    
    %legend underneath 5th tile
    if j==5
        hL = legend([a b c],'forest biomass in kg [C]/m^2', 'fitted line', '95% confidence interval', 'NumColumns',2,'FontSize',9);
        legend('boxoff')
        hL.Location = 'southoutside';    
    end
    %remove y and x label in middle tiles
    if j~=1 && j~=4
        set(gca,'YTickLabel',[]);
    else
        ylabel('Forest biomass in kg[C]/m^2')
    end
    if j~=4 && j~=5 && j~=6
        set(gca,'XTickLabel',[]);
    else
        set(gca,'XTick',1985:10:2010)
        xlabel('year');
    end    
    %add letter in corner of tiles
    text(0.015,0.95,chars_let{j},'Units','normalized','FontSize',11)
end
t.TileSpacing = 'none';
t.Padding= 'none';