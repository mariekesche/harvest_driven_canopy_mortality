%Calculate the mean by country for several columns
%Marieke Scheel
function [fin_av]=mean_europe_sev_cols(cmass_years, cntrcol)
%input file is sorted by country, now additionally sorted by year
sort_cmass_years=sortrows(cmass_years,3); 
[nbrRows, ~]=size(sort_cmass_years);
cmass_europe=[];
cntr=11; %set initial country nbr
addedmort=nan(500,cntrcol-4);
count=1;
row_count=1;
%loop trough input file
for i=1:nbrRows
    if sort_cmass_years(i,cntrcol)==cntr
        addedmort(row_count, 1:cntrcol-4)=sort_cmass_years(i,4:cntrcol-1); %add value columns of all cells in a country in a certain year
        row_count=row_count+1;
    elseif sort_cmass_years(i,cntrcol)~=cntr %when country changes get mean
        cmass_europe(count,1)=sort_cmass_years(i-1,3); %year
        cmass_europe(count,2:cntrcol-3)=mean(addedmort, 'omitnan'); %median values
        cmass_europe(count,cntrcol-2)=sort_cmass_years(i-1,cntrcol); %country columns
        addedmort=nan(500,cntrcol-4);
        row_count=1;
        count=count+1;
        cntr=sort_cmass_years(i,cntrcol);
        addedmort(row_count, 1:cntrcol-4)=sort_cmass_years(i,4:cntrcol-1);
        row_count=row_count+1;
    end
end
cmass_europe(count,1)=sort_cmass_years(i-1,3);
cmass_europe(count,2:cntrcol-3)=mean(addedmort, 'omitnan');
cmass_europe(count,cntrcol-2)=sort_cmass_years(i-1,cntrcol);

fin_av=cmass_europe;
end