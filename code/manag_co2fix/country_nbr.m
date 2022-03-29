%Add FAO country number to cells in Central Europe
%Marieke Scheel

function [country]=country_nbr(cflux_sim_years, freecol)
%import list with coordinates and country numbers
opts = detectImportOptions('gridlist.txt');
T = readtable('gridlist.txt',opts,'ReadVariableNames',true);
gridlist=table2array(T);

%if coordinates match, add respective FAO country number to the input file
[nbrRowsMort, ~]=size(cflux_sim_years);
[nbrRowsGrid, ~]=size(gridlist);
for i=1:nbrRowsMort
    for ii=1:nbrRowsGrid
        if cflux_sim_years(i,1)==gridlist(ii,1) && cflux_sim_years(i,2)==gridlist(ii,2)
            cflux_sim_years(i,freecol)=gridlist(ii,3); %country nbr
        end
    end
end

country=cflux_sim_years;
end