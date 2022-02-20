%Calculate median in each country
%Marieke Scheel

function [fin_av]=median_europe_sev_cols_2(sort_cmass_years, cntrcol, medcol) %medcol is the column with the harvest fraction
%input file is sorted by country and by year
[nbrRows, ~]=size(sort_cmass_years);
cmass_europe=[];
cntr=11; %set initial country nbr
addedmort=nan(500,1);
count=1;
row_count=1;
%loop trough input file
for i=1:nbrRows
    if sort_cmass_years(i,cntrcol)==cntr
        addedmort(row_count, 1)=sort_cmass_years(i,medcol); %add value of all cells in a country in a certain year
        row_count=row_count+1;
    elseif sort_cmass_years(i,cntrcol)~=cntr %get median if country changes
        cmass_europe(count,1)=sort_cmass_years(i-1,3); %year
        cmass_europe(count,2)=median(addedmort, 'omitnan'); %median harvest fracrion
        cmass_europe(count,3)=sort_cmass_years(i-1,cntrcol); %country FAO nbr
        addedmort=nan(500,1);
        row_count=1;
        count=count+1;
        cntr=sort_cmass_years(i,cntrcol);
        addedmort(row_count, 1)=sort_cmass_years(i,medcol);
        row_count=row_count+1;
    end
end
cmass_europe(count,1)=sort_cmass_years(i-1,3);
cmass_europe(count,2)=median(addedmort,'omitnan');
cmass_europe(count,3)=sort_cmass_years(i-1,cntrcol);

fin_av=cmass_europe;
end