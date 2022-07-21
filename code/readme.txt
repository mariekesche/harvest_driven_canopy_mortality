# Increased Central European forest mortality explained by higher harvest rates driven by enhanced productivity

## Code authors
Marieke Scheel, Lund University, Sweden, marieke.scheel@gmail.com
Thomas A. M. Pugh, Lund University, Sweden, thomas.pugh@nateko.lu.se

## Description
Scripts underlying analysis in:
Marieke Scheel, Mats Lindeskog, Benjamin Smith, Thomas A. M. Pugh, Susanne Suvanto
Increased Central European forest mortality explained by higher harvest rates driven by enhanced productivity

Folder: harvest_checks
- FigS1_harvest_rates_LPJGUESS.m, Plot harvest rates used in LPJ-GUESS model vs. harvest rate calculated from FAO wood area estimates and wood removeal estimates by Ceccherini et al. (2020)
- FigS2_NFI_harvest.m, Plot LPJ-GUESS clear-cut and thinning harvest rates vs. harvest rate calculated from NFI data (Germany)
- FigS3_NFI_total_mort.m, Plot LPJ-GUESS total mortality rates vs. total mortality rates from NFI data (Germany)

Folder: manag_climfix (S_man,clim)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_co2fix (S_man,CO2)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_ndepfix (S_man,N)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_nofix (S_man)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- Fig2_central_europe_mortality_metrics.m, Calculation and plotting of different mortality metrics in Central Europe
- Fig4_Mortality_causes_and_causes_vs_stem_diam.m, Calculation and plotting of canopy mortality causes in countries
- FigS5_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigS6_Mortality_causes_cntrs_grouped_causes.m, Calculation and plotting of canopy mortality causes in countries
- FigS8_forest_biomass.m, Calculation and plotting of biomass by diameter in countries over time
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_nothin (S_nothin)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- FigS11_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigS10_LAI.m, Plotting LAI of different European species and PFTs over the time period 1985-2010 in six Central European countries
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: PNV (S_PNV)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- FigS4_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigS7_Mortality_causes_additional_central_europe.m, Calculation and plotting of canopy mortality causes in countries and in Central Europe
- NPP_contributes_FigS9.m, Calculation of forest NPP and export of trend and uncertainty

Folder: sims_plotted_together
- Folder: Mortality_bar_plots
    - Fig3_Canopy_mortality_bar_plots.m, Canopy mortality trends in different simulations plotted
- Folder: NPP_bar_plots
    - FigS9_NPP_bar_plots.m, NPP trends in different simulations plotted
- Folder: Senf_managed
    - Fig1_Senf_managed_and_central_Europe.m, Plot canopy mortality time series by Senf et al. (2018) and from LPJ-GUESS simulation manag_nofix

Folder: helper_functions
- canopy_area_mort_adjusted.m, adjust canopy mortality rate to only take into account the part that is likely to be seen from space
- country_nbr.m, add FAO country number to cells in Central Europe
- lpj_tp_grid_func_centre.m, Function to read in a LPJ-GUESS output file and reformat it into a multi-dimensional array suitable for making Matlab plots with
- mean_europe_sev_cols.m, Calculate the mean by country for several columns
- median_all_europe.m, calculate median for Central Europe
- median_all_europe_sev_cols.m, calculate median for Central Europe for files with several value columns
- median_europe.m, calculate median for Central European countries
- median_europe_harvest.m, calculate median of clear-cut harvest rates for Central European countries 
- median_europe_sev_cols.m, calculate median for Central European countries for files with several value columns
- timerange.m, extraction of time period 1985-2010 for all cells 
- timerange_harvest.m, extraction of time period used for NFI data comparison (2004-2010) for all cells 

Dependencies
- "ColorBrewer: Attractive and Distinctive Colormaps", v. 3.2.1, https://www.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps
-  "polypredci", v. 1.0.0.0, https://www.mathworks.com/matlabcentral/fileexchange/57630-polypredci