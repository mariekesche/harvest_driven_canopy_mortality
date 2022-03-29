function [corrected_closs,corrected_canopy]=canopy_area_mort_adjusted(closs_temp_years, carea_temp_years,year,yearcol)

% adjust canopy mortality rate to only take into account the part that is likely to be seen from space
%
% T. Pugh
% 20.05.21
% modified by M. Scheel

%use lpj_to_grid function and trim to europe region
carea=lpj_to_grid_func_centre(carea_temp_years,26,1);
carea=carea(270:292,365:415,:,:);

%use lpj_to_grid function and trim to europe region
closs=lpj_to_grid_func_centre(closs_temp_years,26,1);
closs=closs(270:292,365:415,:,:);

%define lon and lat and trim to europe
lon=-180:0.5:179.5; %Bottom-left referenced
lat=-90:0.5:89.5;
lon=lon(365:415);
lat=lat(270:292);

% Select one year
carea_2015=squeeze(carea(:,:,yearcol,:));
closs_2015=squeeze(closs(:,:,yearcol,:));

% Note in the figure that we have many grid cells where crown area fraction exceeds 1.0
% Therefore some trees must be in an understory or partially shaded.
% We can make the assumption that a satellite will not see understory trees.
% We can make the further (and more substantial) assumption that the largest trees will be the ones that are seen by the
% satellite and the smaller ones are only seen if crown area does not exceed 1.0

% Cumulate the crown area sum across the diameter classes, starting from the largest class, i.e. heading down through the
% canopy (hence the dimension flip)
carea_2015_csum=cumsum(flip(carea_2015,3),3);

% Now the crown area is always less than 1.0, but in some places (e.g. in the NW) it is much lower than 1.0 in the "canopy"
% array, whilst in the original array it is much greater.
% So we need to be a bit more subtle in our splitting and actually split the size class that straddles 1.0 into a fraction
% that is included and a fraction that is not.

closs_2015_canopy_v2=closs_2015;
carea_2015_canopy_v2=carea_2015;
for xx=1:length(lon)
    for yy=1:length(lat)
        for nn=1:16 %Cycle through each of the size classes
            nind=16-nn+1; %Index for non-flipped arrays
            
            % Look for the first size class where a canopy cover of 1.0 is exceeded
            if carea_2015_csum(yy,xx,nn)>1 % Remember that this array has a flipped size dimension
                % Ascertain the fraction of this class that should be included in our calculation
                inter_class_diff=carea_2015_csum(yy,xx,nn)-carea_2015_csum(yy,xx,nn-1);
                diff_to_one=1-carea_2015_csum(yy,xx,nn-1);
                class_frac_under_one=diff_to_one/inter_class_diff;
                % Adjust the values in this size class so that they only include the fraction of trees that correspond to a
                % total cumulated canopy area of less than 1.0
                closs_2015_canopy_v2(yy,xx,nind)=closs_2015_canopy_v2(yy,xx,nind)*class_frac_under_one;
                carea_2015_canopy_v2(yy,xx,nind)=carea_2015_canopy_v2(yy,xx,nind)*class_frac_under_one;

                % Set all remaining classes to zero
                if nn<16
                    closs_2015_canopy_v2(yy,xx,1:nind-1)=0;
                    carea_2015_canopy_v2(yy,xx,1:nind-1)=0;
                end
                continue
            end
        end
    end
end
clear xx yy nn nind inter_class_diff diff_to_one class_frac_under_one

%%reshape as 2D array
opts = detectImportOptions('gridlist.txt');
T = readtable('gridlist.txt',opts,'ReadVariableNames',false);
gridlist=table2array(T);
[nbrRowsGridlist, ~] = size(gridlist);

%find longitude and latitude indices of closs_2015_canopy_v2 && carea_2015_canopy_v2 
LonInd=nan(nbrRowsGridlist,2);
LatInd=nan(nbrRowsGridlist,2);

%rows of lon and lat
lon=transpose(lon);
lat=transpose(lat);
[nbrRowsX,~]=size(lon);
[nbrRowsY,~]=size(lat);

for ii=1:nbrRowsGridlist
    for i=1:nbrRowsX
        if lon(i,1)==gridlist(ii,1)-0.25
            LonInd(ii,1)=i;
            LonInd(ii,2)=gridlist(ii,1)-0.25;
        end
    end
end

for ii=1:nbrRowsGridlist
    for i=1:nbrRowsY
        if lat(i,1)==gridlist(ii,2)-0.25
            LatInd(ii,1)=i;
            LatInd(ii,2)=gridlist(ii,2)-0.25;
        end
    end
end

% get values at lat && lon indices
corrected_canopy=zeros(nbrRowsGridlist,19);
corrected_closs=zeros(nbrRowsGridlist,19);
corrected_canopy(:,1:2)=gridlist(:,1:2);
corrected_closs(:,1:2)=gridlist(:,1:2);
for ii=1:nbrRowsGridlist
    corrected_canopy(ii,3)=year;
    corrected_canopy(ii,4:19)=carea_2015_canopy_v2(LatInd(ii,1),LonInd(ii,1),1:16); 
    corrected_closs(ii,3)=year;
    corrected_closs(ii,4:19)=closs_2015_canopy_v2(LatInd(ii,1),LonInd(ii,1),1:16);
end
end