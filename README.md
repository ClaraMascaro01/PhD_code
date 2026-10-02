# PhD_code
Publicly available Stata code for my PhD thesis, titled 'Work-disability, Labour Market Stratification and Employment Retention in the United Kingdom and Germany, 2010-2020'.

This code uses data from the UK Household Longitudinal Panel (UKHLS) and the German Socio-Economic Panel (SOEP). 

The code for the thesis consists of three files. 

MASTER_UKHLS_SOEP_rough.do is the master do-file. This contains initial settings to create directories and directory paths. Creating directory paths is strongly recommended since the commands in the other do-files rely on these. 

UKHLS_rough.do contains all the syntax for data harvesting, management and analysis using UKHLS.

SOEP_rough.do contains all the syntax for data harvesting, management and analysis using SOEP. 

The do-files for UKHLS and SOEP are intended to be used in parallel, switching from one to the other as needed. The global paths in the master do-file apply to both datasets. This means that the UKHLS and SOEP files (raw data, clean data, tables, figures, etc.) should be saved together in the same folders for the global paths to work correctly. 
