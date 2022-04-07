%Calculate median in each country
%Marieke Scheel

function [fin_av]=median_europe(cmass_years)
%input file is sorted by country, now additionally sorted by year
sort_cmass_years=sortrows(cmass_years,3);
[nbrRows, ~]=size(sort_cmass_years);
cmass_europe=[];
cntr=11; %set initial country nbr
addedmort=nan(500,1);
count=1;
row_count=1;
%loop trough input file
for i=1:nbrRows
    if sort_cmass_years(i,5)==cntr 
        addedmort(row_count, 1)=sort_cmass_years(i,4); %add value of all cells in a country in a certain year
        row_count=row_count+1;
    elseif sort_cmass_years(i,5)~=cntr %when country changes get median
        cmass_europe(count,1)=sort_cmass_years(i-1,3); %year
        cmass_europe(count,2)=median(addedmort, 'omitnan'); %median value
        cmass_europe(count,3)=sort_cmass_years(i-1,5); %country nbr
        addedmort=nan(500,1);
        row_count=1;
        count=count+1;
        cntr=sort_cmass_years(i,5);
        addedmort(row_count, 1)=sort_cmass_years(i,4);
        row_count=row_count+1;
    end
end
cmass_europe(count,1)=sort_cmass_years(i-1,3);
cmass_europe(count,2)=median(addedmort,'omitnan');
cmass_europe(count,3)=sort_cmass_years(i-1,5);

fin_av=cmass_europe;
end