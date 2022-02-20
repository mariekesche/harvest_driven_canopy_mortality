function [corrected_landcover]=correct_cover(cmass_thin, coldiv, totcol)
%%import landcover_europe
opts = detectImportOptions('landcover_eu.txt');
T = readtable('landcover_eu.txt',opts,'ReadVariableNames',false);
landcover_eu=table2array(T);
landcover_eu_new=zeros(2708,3);

%%filter only 2010
[nbrRows,~]=size(landcover_eu);
j=1;
for i=1:nbrRows
    if landcover_eu(i,3)==2010
        landcover_eu_new(j,1:2)=landcover_eu(i,1:2);
        landcover_eu_new(j,3)=landcover_eu(i,6);
        j=j+1;
    end
end

%%find simulated places in Landcover and extract forest fraction there
Lia=ismember(landcover_eu_new(:,1:2),cmass_thin(:,1:2),'rows');
[nbrRows,~]=size(landcover_eu_new);
landcover_cent_eu=zeros(474,3);
count=1;
for i=1:nbrRows
    if Lia(i,1)==1
        landcover_cent_eu(count,:)=landcover_eu_new(i,:);
        count=count+1;
    end
end

%bring cflux_new coordinates in same order as landcover_cent_eu
cmass_thin=sortrows(cmass_thin,1);
cmass_thin=sortrows(cmass_thin,2);
cmass_thin=sortrows(cmass_thin,1);

%%correct for land cover where cover > 0.1
[nbrRows_cflux,~]=size(cmass_thin);
cflux_new=zeros(nbrRows_cflux,totcol);
[nbrRows,~]=size(landcover_cent_eu);
count=1:26:nbrRows_cflux;
cntacc=1;
j=1:26:nbrRows_cflux;
for i=1:nbrRows
    if (1-landcover_cent_eu(i,3)) > 0.1
        cflux_new(count(1,cntacc):count(1,cntacc+1)-1, 1:coldiv-1)=cmass_thin(j(1,i):i*26,1:coldiv-1);
        cflux_new(count(1,cntacc):count(1,cntacc+1)-1,coldiv)=cmass_thin(j(1,i):i*26,coldiv)./(1-landcover_cent_eu(i,3));
        cflux_new(count(1,cntacc):count(1,cntacc+1)-1,coldiv+1)=cmass_thin(j(1,i):i*26,coldiv+1);
        cntacc=cntacc+1;
    end
end

%find i where zeros in cflux_new begin
for i=1:nbrRows_cflux
    if cflux_new(i,1)==0
        break
    end 
end
%delete all entries that are only 0
cflux_new(i:nbrRows_cflux,:) = [];

%sort ouput by country
cflux_new=sortrows(cflux_new,coldiv+1);

%output
corrected_landcover=cflux_new;

end