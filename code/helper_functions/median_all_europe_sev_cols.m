%Calculate median in central Europe for files with several value columns
%Marieke Scheel

function [fin_av]=median_all_europe_sev_cols(cmass_years, cntrcol)
%input file is sorted by country, now additionally sorted by year
sort_cmass_years=sortrows(cmass_years,3);
[nbrRows, ~]=size(sort_cmass_years);
cmass_europe=[];
yr=1985; %initial year
addedmort=nan(500,cntrcol-4);
count=1;
row_count=1;
%loop through input file
for i=1:nbrRows
    if sort_cmass_years(i,3)==yr
        addedmort(row_count, 1:cntrcol-4)=sort_cmass_years(i,4:cntrcol-1); %add value columns of all central European cells in certain year
        row_count=row_count+1;
    elseif sort_cmass_years(i,3)~=yr %when year changes get median
        cmass_europe(count,1)=sort_cmass_years(i-1,3); %year
        cmass_europe(count,2:cntrcol-3)=median(addedmort, 'omitnan'); %median values
        addedmort=nan(500,cntrcol-4);
        row_count=1;
        count=count+1;
        yr=sort_cmass_years(i,3);
        addedmort(row_count, 1:cntrcol-4)=sort_cmass_years(i,4:cntrcol-1);
        row_count=row_count+1;
    end
end
cmass_europe(count,1)=sort_cmass_years(i-1,3);
cmass_europe(count,2:cntrcol-3)=median(addedmort, 'omitnan');

fin_av=cmass_europe;
end