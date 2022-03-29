%Extraction of time period 1985-2010 for all cells
%Marieke Scheel

function [output]=timerange(diamcmass,col) %col is column with year
[nbrRows, ~]=size(diamcmass);
diamcmass_years=[];
cnt=1;
for i=1:nbrRows
    if diamcmass(i,col) > 1984 && diamcmass(i,col) <= 2010 %if year in time period
        diamcmass_years(cnt,:)=diamcmass(i,:); %extract row to new file
        cnt=cnt+1;
    end
end
output=diamcmass_years;
end