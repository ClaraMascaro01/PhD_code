********************************************************************************
* 							MASTER DO-FILE 										*
********************************************************************************
/*
Date created: 01/06/2023
Date last used: 18/08/26
Author: Clara Mascaro
Description: Master file containing all do-files for the analysis of UKHLS and 
SOEP data.
*******************************************************************************/
********************************************************************************
* 	Initial settings								 
********************************************************************************

clear all
macro drop _all
set more off
set varabbrev off
/* Create a directory structure (only need to do it once at the beginning)
cd "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_raw"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_clean"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\logs"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\codebooks"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\do_files"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\tables"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\figures"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\temp"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\documentation"

* Make subdirectories for UKHLS (including special license) and SOEP data
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_raw\ukhls"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_raw\ukhls\sl"
mkdir "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_raw\soep"
*/

* Set global pathfiles - NB these work for both UK and SOEP data, no need to re-run
global path1 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_raw"
global path2 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\data_clean"
global path3 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\logs"
global path4 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\codebooks"
global path5 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\do_files"
global path6 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\tables"
global path7 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\figures"
global path8 "C:\Users\s1131414\OneDrive - University of Edinburgh\PhD_new\Data_analysis\temp"
global path9 "C:\Users\s1131414\OneDrive - University ofEdinburgh\PhD_new\Data_analysis\documentation"

/*	capture log close
	capture log using "$path3/202402206automatingoutputs.txt", replace text 
	No need to keep logs for now, I never check them anyway. */ 

********************************************************************************
* Check Stata directory configuration
sysdir
/* Have needed to change directories from M: to C: as didn't have access to M:
mkdir "C:\ado"
mkdir "C:\ado\plus"
mkdir "C:\ado\personal"
sysdir set PLUS "C:\ado\plus"
sysdir set PERSONAL "C:\ado\personal"
sysdir
*/

* Make sure external commands are installed

* estout - for exporting tables
ssc install estout, replace
which eststo

/*
*	UK data analysis

* 	Current do-file with all syntax
	do "$path5/UKHLS_all.do"
	// Harvest variables from indresp & hhresp
	// Re-code variables & inspects missing values
	// Descriptives of disvars for operationalisation chapter

* 	DE data analysis

* 	Current do-file with all SOEP syntax	
	do "$path5/SOEP_all.do"

/* ARCHIVE
do "$path5/SOEP_datamanagement.do"
do "$path5/20210525_assemble_data_v2.do" // merges datafiles and creates analytical sample
do "$path5/20210703_varmanage_v2.do" // data management
*/ */

* 	End session 
	capture log close
	exit
