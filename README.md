# Increased Central European forest mortality explained by higher harvest rates driven by enhanced productivity

## Authors
Marieke Scheel, Lund University, Sweden, marieke.scheel@gmail.com
Thomas A. M. Pugh, Lund University, Sweden, thomas.pugh@nateko.lu.se

## Description
Scripts underlying analysis in:
Marieke Scheel, Mats Lindeskog, Benjamin Smith, Thomas A. M. Pugh, Increased Central European forest mortality explained by higher harvest rates driven by enhanced productivity

Folder: harvest_checks
- harvest_rate_LPJGUESS.m, Plot harvest rates used in LPJ-GUESS model vs. harvest rate calculated from FAO wood area estimates and wood removeal estimates by Ceccherini et al. (2020)
- median_europe_sev_cols_2.m, calculate median in each country (helper function)

Folder: manag_climfix (simulation IVa)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_co2fix (simulation IVb)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_ndepfix (simulation IVc)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_nofix (simulation III)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- Fig2_central_europe_mortality_metrics.m, Calculation and plotting of different mortality metrics in Central Europe
- Fig4_Mortality_causes_and_causes_vs_stem_diam.m, Calculation and plotting of canopy mortality causes in countries
- FigA3_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigA5_Mortality_causes_cntrs_grouped_causes.m, Calculation and plotting of canopy mortality causes in countries
- FigA7_forest_biomass.m, Calculation and plotting of biomass by diameter in countries over time
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: manag_nothin (simulation II)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- FigA4_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigA9_LAI.m, Plotting LAI of different European species and PFTs over the time period 1985-2010 in six Central European countries
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: PNV (simulation I)
- canopy_mort_trend_contributes_Fig3.m, Canopy mortality trend and SE exported for all countries and Central Europe
- FigA2_Biomass_vs_diameter.m, Calculation and plotting of biomass by diameter in countries over time
- FigA6_Mortality_causes_additional_central_europe.m, Calculation and plotting of canopy mortality causes in countries and in Central Europe
- NPP_contributes_FigA8.m, Calculation of forest NPP and export of trend and uncertainty

Folder: sims_plotted_together
- Folder: Mortality_bar_plots
    - Fig3_Canopy_mortality_bar_plots.m, Canopy mortality trends in different simulations plotted
- Folder: NPP_bar_plots
    - FigA8_NPP_bar_plots.m, NPP trends in different simulations plotted
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
- median_europe_sev_cols.m, calculate median for Central European countries for files with several value columns
- timerange.m, extraction of time period 1985-2010 for all cells 

Dependencies
- "ColorBrewer: Attractive and Distinctive Colormaps", v. 3.2.1, https://www.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps
-  "polypredci", v. 1.0.0.0, https://www.mathworks.com/matlabcentral/fileexchange/57630-polypredci
