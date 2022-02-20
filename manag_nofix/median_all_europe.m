%Calculate median for central europe
%Marieke Scheel

function [fin_av]=median_all_europe(cmass_years)
%input file is sorted by country, now additionally sorted by year
sort_cmass_years=sortrows(cmass_years,3);
[nbrRows, ~]=size(sort_cmass_years);
cmass_europe=[];
yr=1985; %intial year
addedmort=nan(500,1);
count=1;
row_count=1;
%loop trough input file
for i=1:nbrRows
    if sort_cmass_years(i,3)==yr 
        addedmort(row_count, 1)=sort_cmass_years(i,4); %add value of all central European cells in certain year
        row_count=row_count+1;
    elseif sort_cmass_years(i,3)~=yr %when year changes get median
        cmass_europe(count,1)=sort_cmass_years(i-1,3); %year
        cmass_europe(count,2)=median(addedmort, 'omitnan'); %median value
        addedmort=nan(500,1);
        row_count=1;
        count=count+1;
        yr=sort_cmass_years(i,3);
        addedmort(row_count, 1)=sort_cmass_years(i,4);
        row_count=row_count+1;
    end
end
cmass_europe(count,1)=sort_cmass_years(i-1,3);
cmass_europe(count,2)=median(addedmort,'omitnan');

fin_av=cmass_europe;
end