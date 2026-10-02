STOP
////////////////////////////////////////////////////////////////////////////////
//							UKHLS all syntax								  //
////////////////////////////////////////////////////////////////////////////////
/*
Date created: 20/04/23
Date last edited: 18/08/26
Author: Clara Mascaro
Description: Master file containing all syntax for analysing UK data
Sections:
	1. Harvest variables and append
	2. Variable management
	3. Create sample for analysis
	4. Operationalisation chapter
*/

********************************************************************************
**#		1. Harvest variables and append							 
********************************************************************************
* Updated to include wave 10 of data (Jan 2018 – May 2020)

* Harvesting individual variables
***********************************

* NB if adding anymore harvesting steps (new combinations of waves from which to harvest or from new datafiles), add at the end. Hwr if adding vars to any of the steps fine to add to existing steps.

* 1) Variables in waves 1-10 / all waves:
foreach w in a b c d e f g h i j {
use pidp `w'_hidp `w'_ivfio `w'_memorig `w'_month `w'_scflag_dv ///
`w'_health ///
`w'_disdif1 `w'_disdif2 `w'_disdif3 `w'_disdif4 `w'_disdif5 `w'_disdif6 ///
`w'_disdif7 `w'_disdif8 `w'_disdif9 `w'_disdif10 `w'_disdif11 ///
`w'_disdif12 `w'_disdif96 ///
`w'_jbstat `w'_jbhas `w'_jbhad ///
`w'_bendis1 `w'_bendis2 `w'_bendis3 `w'_bendis4 `w'_bendis5 `w'_bendis7 `w'_bendis8 ///
`w'_bendis10 `w'_bendis96 ///
`w'_jbbgy `w'_jbbgm `w'_jlendy `w'_jlendm `w'_julkjb ///
`w'_age_dv `w'_sex `w'_sex_dv `w'_mastat_dv `w'_hhtype_dv ///
`w'_racel_dv `w'_ukborn `w'_citzn1 ///
`w'_hiqual_dv `w'_qfhigh_dv `w'_qfhighfl_dv ///
`w'_jlnssec5_dv `w'_jbnssec5_dv `w'_jbnssec8_dv ///
`w'_jbnssec3_dv `w'_jlnssec3_dv `w'_jbisco88_cc `w'_jlisco88_cc ///
`w'_jbterm1 `w'_jbterm2 `w'_jbft_dv `w'_jbsemp `w'_jbsic07_cc ///
`w'_jbsize `w'_jbsect `w'_jbsectpub `w'_jbpl ///
`w'_prfitb ///
`w'_jbsat ///
`w'_payg_dv `w'_paygu_dv `w'_paygu_if ///
`w'_scghq1_dv `w'_scghq2_dv ///
`w'_sclfsat1 ///
`w'_jbhrs `w'_jbot ///
`w'_psu `w'_strata ///
`w'_gor_dv ///
`w'_intdatd_dv `w'_intdatm_dv `w'_intdaty_dv `w'_jboff using "$path1/ukhls/`w'_indresp.dta", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_1to10.dta", replace
} 
use "$path8/a_indresp_1to10.dta", clear
foreach w in b c d e f g h i j {
append using "$path8/`w'_indresp_1to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_1to10.dta", replace

* 2) Variables in waves 2-10:
foreach w in b c d e f g h i j {
use pidp `w'_scsf3a `w'_scsf3b `w'_scsf4a `w'_scsf4b `w'_scsf5 ///
`w'_jbsamr `w'_qualnew1 `w'_qualnew3 `w'_qualnew5 `w'_qualnew6 `w'_qualnew7 ///
`w'_qualnew8 `w'_qualnew9 `w'_qualnew10 `w'_qualnew13 `w'_qualnew15 ///
`w'_qualnew16 `w'_qualnew17 `w'_qualnew18 `w'_qualnew19 `w'_qualnew20 ///
`w'_qualnew21 `w'_qualnew22 `w'_qualnew23 `w'_qualnew24 `w'_qualnew27 ///
`w'_qualnew28 `w'_qualnew29 `w'_qualnew30 `w'_qualnew31 ///
`w'_j1none `w'_jbsic07chk `w'_jbsizechk `w'_cjbatt ///
`w'_rtfnd9 ///
`w'_ff_ivlolw `w'_ff_emplw `w'_ff_jbstat `w'_empchk ///
`w'_samejob `w'_wkplsam `w'_empstendd `w'_empstendm `w'_empstendy4 `w'_nxtst ///
`w'_nextelse1 `w'_cstat `w'_jbendd `w'_jbendm `w'_jbendy4 `w'_cjob `w'_nmpsp_dv ///
`w'_nnmpsp_dv `w'_nunmpsp_dv ///
`w'_reasend* `w'_empstendm* `w'_empstendy* ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_2to10.dta", replace
}
use "$path8/b_indresp_2to10.dta", clear
foreach w in c d e f g h i j {
append using "$path8/`w'_indresp_2to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_2to10.dta", replace

* 3) Variables in waves 2, 4, 6, 8, 10:
foreach w in b d f h j {
use pidp `w'_jbflex1 `w'_jbflex2 `w'_jbflex3 `w'_jbflex4 `w'_jbflex5 ///
`w'_jbflex6 `w'_jbflex7 `w'_jbflex8 `w'_jbflex96 `w'_jbfxinf ///
`w'_wkaut1 `w'_wkaut2 `w'_wkaut3 `w'_wkaut4 `w'_wkaut5 ///
`w'_jblkcha `w'_jblkchb `w'_jblkchc `w'_jblkchd `w'_jblkche ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_246810.dta", replace
}
use "$path8/b_indresp_246810.dta", clear
foreach w in d f h j {
append using "$path8/`w'_indresp_246810.dta"
}
sort pidp wave
isid pidp wave
save "$path8\indresp_246810.dta", replace

* 4) Variables in 1 3 5 7 9:
foreach w in a c e g i {
use pidp `w'_joblook `w'_jobdeny `w'_resjobdeny5 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghi", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_13579.dta", replace
}
use "$path8/a_indresp_13579.dta", clear
foreach w in c e g i {
append using "$path8/`w'_indresp_13579.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_13579.dta", replace

* 5) Variables in 3, 5, 7, 9:
foreach w in c e g i {
use pidp `w'_diseffects1 `w'_diseffects4 `w'_diseffects5 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghi", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_3579.dta", replace
}
use "$path8/c_indresp_3579.dta", clear
foreach w in e g i {
append using "$path8/`w'_indresp_3579.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_3579.dta", replace

* 6) Variables in 1-5 (benefits) - not needed anymore but easier to keep in 
foreach w in a b c d e {
use pidp `w'_btype1 `w'_btype2 `w'_btype3 `w'_bendis6 `w'_bendis9 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghi", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_1to5.dta", replace
}
use "$path8/a_indresp_1to5.dta", clear
foreach w in b c d e {
append using "$path8/`w'_indresp_1to5.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_1to5.dta", replace

* 7) Variables in 6-10 (benefits)
foreach w in f g h i j {
use pidp `w'_benbase1 `w'_benbase2 `w'_benbase3 `w'_benbase4 `w'_benbase96 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_6to10.dta", replace
}
use "$path8/f_indresp_6to10.dta", clear
foreach w in g h i {
append using "$path8/`w'_indresp_6to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_6to10.dta", replace

* 8) Variables in 3, 4, 5 (benefits):
foreach w in c d e {
use pidp `w'_btype10 using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghi", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_345.dta", replace
}
use "$path8/c_indresp_345.dta", clear
isid pidp wave
foreach w in d e {
append using "$path8/`w'_indresp_345.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_345.dta", replace

* 9) Variables in 3-9 (benefits):
foreach w in c d e f g h i j {
use pidp `w'_bendis12 `w'_bendis97 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_3to10.dta", replace
}
use "$path8/c_indresp_3to10.dta", clear
foreach w in d e f g h i j {
append using "$path8/`w'_indresp_3to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_3to10.dta", replace

*10) Variables in 5-10 (benefits):
foreach w in e f g h i j {
use pidp `w'_benesa using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_5to10.dta", replace
}
use "$path8/e_indresp_5to10.dta", clear
foreach w in f g h i j {
append using "$path8/`w'_indresp_5to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_5to10.dta", replace

* 11) Variables in 2-6 (reason job ended):
foreach w in b c d e f {
use pidp `w'_stendreas `w'_jbendreas ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghi", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_2to6.dta", replace
}
use "$path8/b_indresp_2to6.dta", clear
foreach w in c d e f {
append using "$path8/`w'_indresp_2to6.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_2to6.dta", replace

* 12) Variables in 7-10 (reason job ended)
foreach w in g h i j {
use pidp `w'_stendreas1 `w'_stendreas2 `w'_stendreas3 `w'_stendreas4 ///
`w'_stendreas5 `w'_stendreas6 `w'_stendreas7 `w'_stendreas8 `w'_stendreas9 ///
`w'_stendreas10 `w'_stendreas11 `w'_stendreas97 ///
`w'_jbendreas1 `w'_jbendreas2 `w'_jbendreas3 `w'_jbendreas4 `w'_jbendreas5 ///
`w'_jbendreas6 `w'_jbendreas7 `w'_jbendreas8 `w'_jbendreas9 `w'_jbendreas10 ///
`w'_jbendreas11 `w'_jbendreas97 ///
using "$path1/ukhls/`w'_indresp", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_indresp_7to10.dta", replace
}
use "$path8/g_indresp_7to10.dta", clear
foreach w in h i j {
append using "$path8/`w'_indresp_7to10.dta"
}
sort pidp wave
isid pidp wave
save "$path8/indresp_7to10.dta", replace

* 13) Variables in wave 1 only (work-limiting disability)
foreach w in a {
use pidp `w'_sf3a `w'_sf3b `w'_sf5 `w'_sf4a `w'_sf4b ///
using "$path1/ukhls/`w'_indresp", clear
gen wave=1
rename `w'_* *
sort pidp wave
isid pidp wave
save "$path8/indresp_1.dta", replace
}

* 14) Xsectional weights self-completion
// Harvesting all available for each set of waves - can choose which to use later
// though NB WLD is self-completion

* Wave 1
use pidp a_indscus_xw a_indpxus_xw a_indinus_xw using "$path1/ukhls/a_indresp", clear
gen wave = 1
* rename a_indscus_xw indscus_xw
* rename a_indpxus_xw indpxus_xw
* rename a_indinus_xw indinus_xw
// skip remaining to allow merging calendar years
sort pidp wave
isid pidp wave
save "$path8/a_xw.dta", replace

* waves 2-5
foreach w in b c d e {
	use pidp `w'_indpxub_xw `w'_indinub_xw `w'_indscub_xw ///
	using "$path1/ukhls/`w'_indresp", clear
	gen wave = strpos("abcdefghi", "`w'")
	* rename `w'_* *
	save "$path8/`w'_xw.dta", replace
}
use "$path8/b_xw.dta", clear
foreach w in c d e {
	append using "$path8/`w'_xw.dta"
}
sort pidp wave
isid pidp wave
save "$path8/2to5_xw.dta", replace

* Waves 6-10 main interview
foreach w in f g h i j {
	use pidp `w'_indpxui_xw `w'_indinui_xw `w'_indscui_xw `w'_indscub_xw ///
	using "$path1/ukhls/`w'_indresp.dta", clear
	gen wave = strpos("abcdefghij", "`w'")
	rename `w'_* *
	save "$path8/`w'_xw.dta", replace
}
use "$path8/f_xw.dta", clear
foreach w in g h i j {
append using "$path8/`w'_xw.dta"
}
sort pidp wave
isid pidp wave
save "$path8/6to10_xw.dta", replace

* Append them all
use "$path8/a_xw.dta", clear
append using "$path8/2to5_xw.dta"
append using "$path8/6to10_xw.dta"
order pidp wave
sort pidp wave
isid pidp wave
tab wave
save "$path8/xsectweights.dta", replace

*15) Longitudinal weights waves 1-10
	// harvest lw for main self-completion (indscus_lw)
	// following code from UKHLS training example 6 do file. 

	* first create a file for each wave, using isvar as Wave 1 does not contain lw
	foreach w in a b c d e f g h i j {
		use pidp `w'_strata `w'_psu `w'_indscus_*w ///
		using "$path1/ukhls/`w'_indresp.dta", clear
		gen wave = strpos("abcdefghij", "`w'")
		rename `w'_* *
		save "$path8/`w'_lw.dta", replace
	}

	* Append
	use "$path8/a_lw.dta", clear
	rename indscus_xw indscus_lw
	foreach w in b c d e f g h i j {
		append using "$path8/`w'_lw.dta"
	}
	sort pidp wave
	mvdecode _all, mv(-9/-1)
	save "$path8/lonweights.dta", replace

	* generate a new weighting variable for longitudinal analysis
	gen mylw_indscus=indscus_lw
	
	* copy the last wave's value over to previous waves
	bysort pidp (wave): replace mylw_indscus=mylw_indscus[_N]
	list pidp wave indscus_lw mylw_indscus if indscus_lw>0 in 1/500
	drop indscus_lw
	save "$path8/lonweights.dta", replace

* Merge files & save							 
* Numbers represent steps in the harvesting process
// 1 & 2
use "$path8/indresp_1to10.dta", clear
merge 1:1 pidp wave using "$path8/indresp_2to10.dta"
drop _merge
// 3
merge 1:1 pidp wave using "$path8\indresp_246810.dta"
drop _merge
//4
merge 1:1 pidp wave using "$path8/indresp_13579.dta"
drop _merge
// 5
merge 1:1 pidp wave using "$path8/indresp_3579.dta"
drop _merge
// 6
merge 1:1 pidp wave using "$path8/indresp_1to5.dta"
drop _merge
// 7 
merge 1:1 pidp wave using "$path8/indresp_6to10.dta"
drop _merge
// 8 
merge 1:1 pidp wave using "$path8/indresp_345.dta"
drop _merge
// 9 
merge 1:1 pidp wave using "$path8/indresp_3to10.dta"
drop _merge
// 10
merge 1:1 pidp wave using "$path8/indresp_5to10.dta"
drop _merge
// 11
merge 1:1 pidp wave using "$path8/indresp_2to6.dta"
drop _merge
// 12
merge 1:1 pidp wave using "$path8/indresp_7to10.dta"
drop _merge
// 13
merge 1:1 pidp wave using "$path8/indresp_1.dta"
drop _merge
// 14
merge 1:1 pidp wave using "$path8/xsectweights.dta"
drop _merge
// 15
merge 1:1 pidp wave using "$path8/lonweights.dta"
drop _merge

compress
save "$path8/indresp.dta", replace

* Harvesting household variables
**********************************
*Variables in waves 1-10
foreach w in a b c d e f g h i j {
use `w'_hidp `w'_tenure_dv `w'_nkids_dv `w'_hhsize `w'_nemp_dv `w'_hhtype_dv ///
`w'_fihhmnnet1_dv `w'_ieqmoecd_dv using "$path1/ukhls/`w'_hhresp.dta", clear
gen wave = strpos("abcdefghij", "`w'")
rename `w'_* *
save "$path8/`w'_hhresp_1to10.dta", replace
}
use "$path8/a_hhresp_1to10.dta", clear
foreach w in b c d e f g h i j {
append using "$path8/`w'_hhresp_1to10.dta"
}
order hidp wave
sort hidp wave

* Save separate file for hhresp variables
save "$path8/hhresp_1to10.dta", replace
isid hidp wave

* Merge with indresp
**********************

/*  I have bypassed 20200722_indresp_unemp_v2 as pidp wave did not identify cases
uniquely and I could not work out why. Unemployment was not significant in the models
anyway and cannot use equivalent for SOEP. */

merge 1:m hidp wave using "$path8/indresp.dta"

*Investigate unmatched
tab _merge
//unmatched from master: 928 (0.21% of total)
//some people in households will not have completed interview
sum pidp if _merge==1, detail //no observations
tab wave if _merge==1 // fairly evenly distributed
drop if _merge==1

//unmatched from using:  3,241 (0.73%)
/* There ARE some individuals without household data in waves 6-10 - see user
forum #698. */
tab wave if _merge==2 //mainly waves 6-10
misstable sum hidp if _merge==2 //non-missing
// keep

drop _merge

order pidp hidp wave
sort pidp wave
isid pidp wave // all OK

*Save combined file
compress
save "$path8/indresp_hhresp.dta", replace

**#
********************************************************************************
* 					2. Variable management			 
********************************************************************************
* If working on new data, open sample from temp folder
use "$path8/indresp_hhresp.dta", clear

* If making changes to clean data, open latest - see at bottom of section. 
use "$path2/ukhls_clean.dta", clear

* 	Basic variable management
*******************************
order pidp hidp wave
sort pidp wave

* Add numerical values to labels
numlabel, add

/*Decode all negative numbers from -10 to -1
mvdecode _all, mv(-1/-10)
	// needed in order to re-code variables
	// I've decided to do it var by var
*/

* Declare to be panel data
xtset pidp wave
xtdes
xtsum wave

* Inspect sample
// regions included
tab gor_dv, mis // currently includes NI

// instruments used
tab ivfio, mis // currently includes both full interview & proxy

// original sample member
tab memorig, mis


**#
*-------------------------------------------------------------------------------
* 	Recoding disability variables
*-------------------------------------------------------------------------------

* Self-reported impairment
***************************
// inspect missing values
tab health // OK
mvdecode health, mv(-1/-10)

// Recode health to 0/1 values
label list a_health
recode health (2=0), gen(health_re)
label define dummy 1 "Yes" 0 "No"
label value health_re dummy
tab health_re

* Functional limitations
*************************
// inspect missing values
foreach n in 1 2 3 4 5 6 7 8 9 10 11 12 96 {
    tab wave disdif`n'
} 					
tab wave disdif1 
				
/* Very high % of inapplicable - 50%. I think this is because health was used as a 
filter. It seems to have been fixed from wave 8 onwards. 
Not sure what disdif96 "None of these" represents, when there is an "other"*/

// inspect filtering by wave
foreach n in 1 2 3 4 5 6 7 8 9 10 {
	tab health disdif1 if wave==`n', mis
}

//mvdecode
foreach n in 1 2 3 4 5 6 7 8 9 10 11 12 96 {
	mvdecode disdif`n', mv(-1/-10)
}

// Create new var for number of functional limitations reported
// 0 = not mentioned, 1 = mentioned. Add them all up for simple count.
// have removed disdif96 (none of these) as it prevented there being any equal to zero
gen numfunc= disdif1+ disdif2+ disdif3+ disdif4+ disdif5+ disdif6+ disdif7+ ///
disdif8+ disdif9+ disdif10+ disdif11+ disdif12
label var numfunc "Number of functional limitations reported"
tab numfunc, missing
// recode into fewer cats
recode numfunc (0=0) (1=1) (2=2) (3/12=3) (miss=.), gen(numfunc_re)
label define a_numfunc_re 0 "None mentioned" 1 "1 mentioned" 2 "2 mentioned" ///
3 "3 or more mentioned"
label val numfunc_re a_numfunc_re
tab wave numfunc_re, mis


*Acitivities of Daily Living (ADL)
************************************
// Have already created a variable for numfunc
// Define adl if numfunc>=1
tab numfunc if wave==1, mis 
// very high missing values carried over from numfunc
gen adl=.
replace adl=1 if numfunc>=1 & numfunc!=.
replace adl=0 if numfunc==0
label var adl " Activities of Daily Living limitation"

* Equality Act disabled
*************************
// if health=1 & adl=1
gen eadisabled=.
replace eadisabled=1 if health_re==1 & adl==1
replace eadisabled=0 if health_re==0 | adl==0
rename eadisabled eadis
label var eadis "Equality Act disabled"
label val eadis dummy
tab wave eadis, mis


* Work-limiting disability
***************************
* inspect missing values & mvdecode
tab sf3a
tab scsf3a
tab sf3b
tab scsf3b
tab sf4a
tab scsf4a
tab sf4b
tab scsf4b
tab sf5
// missing: proxy respondents around 6%, inapplicable (wave 2+) around 7%
// universe: Mode is face-to-face and has agreed to self-completion OR mode is telephone or web
mvdecode sf3a scsf3a sf3b scsf3b sf4a scsf4a sf4b scsf4b sf5 scsf5, mv(-1/-10)

* Combine responses from wave 1 with waves 2-9

// 1) Physical - amount
tab wave sf3a, mis // wave 1 var
label list a_sf3a
tab wave scsf3a, mis // waves 2-9
label list b_scsf3a
/* label values are identical 
		1 1. all of the time
           2 2. most of the time
           3 3. some of the time
           4 4. a little of the time
           5 5. none of the time
*/
gen physical_amount=.
replace physical_amount=1 if sf3a==1 | scsf3a==1
replace physical_amount=2 if sf3a==2 | scsf3a==2
replace physical_amount=3 if sf3a==3 | scsf3a==3
replace physical_amount=4 if sf3a==4 | scsf3a==4
replace physical_amount=5 if sf3a==5 | scsf3a==5
label var physical_amount "physical health limits amount of work"
label val physical_amount b_scsf3a
tab wave physical_amount, mis

// 2) Physical - kind
tab wave sf3b, mis
tab wave scsf3b, mis
gen physical_kind=.
replace physical_kind=1 if sf3b==1 | scsf3b==1
replace physical_kind=2 if sf3b==2 | scsf3b==2
replace physical_kind=3 if sf3b==3 | scsf3b==3
replace physical_kind=4 if sf3b==4 | scsf3b==4
replace physical_kind=5 if sf3b==5 | scsf3b==5
label var physical_kind "physical health limits kind of work"
label val physical_kind b_scsf3b
tab wave physical_kind, mis

// 3) Mental - accomplished less
tab wave sf4a, mis
tab wave scsf4a, mis
gen mental_amount=.
replace mental_amount=1 if sf4a==1 | scsf4a==1
replace mental_amount=2 if sf4a==2 | scsf4a==2
replace mental_amount=3 if sf4a==3 | scsf4a==3
replace mental_amount=4 if sf4a==4 | scsf4a==4
replace mental_amount=5 if sf4a==5 | scsf4a==5
label var mental_amount "mental health meant accomplished less"
label val mental_amount b_scsf4a
tab wave mental_amount, mis

// 4) Mental - less carefully
tab wave sf4b, mis
tab wave scsf4b, mis
label list a_sf4b
label list b_scsf4b
gen mental_care=.
replace mental_care=1 if sf4b==1 | scsf4b==1
replace mental_care=2 if sf4b==2 | scsf4b==2
replace mental_care=3 if sf4b==3 | scsf4b==3
replace mental_care=4 if sf4b==4 | scsf4b==4
replace mental_care=5 if sf4b==5 | scsf4b==5
label var mental_care "mental health meant worked less carefully"
label val mental_care b_scsf4b
tab wave mental_care, mis

// 5) Pain interferes with work
tab wave sf5, mis
tab wave scsf5, mis
label list a_sf5
label list b_scsf5 
/* Careful as scale is inverted for this variable and a bit different as based on 'how much'
rather than 'how much time'. Do not touch here and work out how to assemble them all. */
gen pain_inter=.
replace pain_inter= 1 if sf5==1 | scsf5==1
replace pain_inter= 2 if sf5==2 | scsf5==2
replace pain_inter= 3 if sf5==3 | scsf5==3
replace pain_inter= 4 if sf5==4 | scsf5==4
replace pain_inter= 5 if sf5==5 | scsf5==5
label var pain_inter "pain interfered with work"
label val pain_inter b_scsf5
tab wave pain_inter, mis

* Collapsing WLD into binary measures for each of physical/mental/pain
*************************************************************************

// already decoded missing values
label list b_scsf3a

// Narrow/conservative approach, following CNEF:
	// 1 (all of the time) & 2 (some of the time)= 1
	// 3 (a little of the time) to 5 (none of the time) 

//physical wld - amount
recode physical_amount (1/2=1) (3/5=0), gen(physamount_re)
label val physamount_re dummy
tab physical_amount physamount_re

// physical wld - kind
recode physical_kind (1/2=1) (3/5=0), gen(physkind_re)
label val physkind_re dummy
tab physical_kind physkind_re

// mental wld - amount
recode mental_amount (1/2=1) (3/5=0), gen(menamount_re)
label val menamount_re dummy
tab mental_amount menamount_re

// mental wld - care
recode mental_care (1/2=1) (3/5=0), gen(mencare_re)
label val mencare_re dummy
tab mental_care mencare_re

// Pain WLD 
	// NB different scale from WLD-physical and WLD-mental
	label list b_scsf5
	// 4 (quite a bit) or 5 (extremely) = 1
	// 3 (moderately), 2 (a little bit) or 1 (not at all) =0
recode pain_inter (4/5=1) (1/3=0), gen(wld_pain)
label var wld_pain "Pain-related WLD"
label val wld_pain dummy
tab pain_inter wld_pain


* Collapsing into binary and combining amount/kind all in one
**************************************************************
// I have separated the steps above to run descriptives but can still use syntax
// using conservative approach

*WLD-physical:
gen wld_phys=.
replace wld_phys=1 if (physical_amount!=. & physical_amount<=2) | (physical_kind!=. & physical_kind<=2)
replace wld_phys=0 if (physical_amount!=. & physical_amount>2) & (physical_kind!=. & physical_kind>2)
label var wld_phys "Physical WLD"
label val wld_phys dummy
tab wld_phys, mis

*WLD-mental:
tab mental_amount mental_care, mis
gen wld_men=.
replace wld_men=1 if (mental_amount!=. & mental_amount<=2) | (mental_care!=. & mental_care<=2)
replace wld_men=0 if (mental_amount!=. & mental_amount>2) & (mental_care!=. & mental_care>2)
label var wld_men "Mental/emotional WLD"
label val wld_men dummy
tab wld_men, mis

*WLD-pain - already recoded above

* Collapse into an "Any WLD" measure INCLUDING PAIN - crude approach
gen wld_any_pain=.
replace wld_any_pain=1 if wld_phys==1 | wld_men==1 | wld_pain==1
replace wld_any_pain=0 if wld_phys==0 & wld_men==0 & wld_pain==0
label var wld_any_pain "Any work limitation including pain"
label val wld_any_pain dummy
tab wld_any_pain, mis

* Create "Any WLD" without no pain
gen wld_any_nopain=.
replace wld_any_nopain=1 if wld_phys==1 | wld_men==1
replace wld_any_nopain=0 if wld_phys==0 & wld_men==0
label var wld_any_nopain "Any WLD excluding pain"
label val wld_any_nopain dummy
tab wld_any_nopain, mis

* Disability change variables
*******************************
* tsset to use lag operators
	tsset pidp wave 

* Change in health_re
	tab health_re, mis
	gen health_change=.
	bysort pidp (wave): replace health_change=0 if health_re==0 & L.health_re==0
	bysort pidp (wave): replace health_change=1 if health_re==1 & L.health_re==0
	bysort pidp (wave): replace health_change=2 if health_re==1 & L.health_re==1
	bysort pidp (wave): replace health_change=3 if health_re==0 & L.health_re==1
	label var health_change "Change in self-reported long-term illness/disability"
	label define dischange_var2 0 "no disability" 1 "onset disability" ///
	2 "persistent disability" 3 "offset disability"
	label values health_change dischange_var2
	tab health_change, mis
	list pidp wave health_re health_change in 1/10
/* 	24% missing. Due to left censoring and gaps in waves. Though note the latter 
	not a problem if using a balanced panel.*/

* Change in WLD_any
	gen wld_change=.
	bysort pidp (wave): replace wld_change=0 if wld_any==0 & L.wld_any==0
	bysort pidp (wave): replace wld_change=1 if wld_any==1 & L.wld_any==0
	bysort pidp (wave): replace wld_change=2 if wld_any==1 & L.wld_any==1
	bysort pidp (wave): replace wld_change=3 if wld_any==0 & L.wld_any==1
	label values wld_change dischange_var2
	tab wld_change, mis
	tab wld_any if wld_change==., mis
	list pidp wave wld_any wld_change in 1/20	
/* 38% missing. Due to left censoring and gaps in waves, as well as missing in wld_any. */

/* Change in eadis
tab eadis, mis
gen eadis_change=.
bysort pidp (wave): replace eadis_change=0 if eadis==0 & L.eadis==0
bysort pidp (wave): replace eadis_change=1 if eadis==1 & L.eadis==0
bysort pidp (wave): replace eadis_change=2 if eadis==1 & L.eadis==1
bysort pidp (wave): replace eadis_change=3 if eadis==0 & L.eadis==1
label var eadis_change "Change in Equality Act disabled variable"
label values eadis_change dischange_var2
tab eadis_change, mis
list pidp wave eadis eadis_change in 1/20
*/

**#
*-------------------------------------------------------------------------------
* Employment status & transitions
*-------------------------------------------------------------------------------
* Check missing values
	tab jbstat, mis 
	// between 0.00-0.04% of observations
	tab jbstat wld_any if jbstat<1, col 
	// higher % of 'refused' amongst those with WLD - though very few cases (14)
	
	tab jbhas, mis 
	// 0.00-0.09% of observations
	tab jbhas wld_any if jbhas<1, col 
	// less clear pattern

	tab jboff, mis 
	// 54% inapplicable - as only asked those who are off work
	tab jboff wld_any if jboff<1, col 
	// no differences

	mvdecode jbstat jbhas jboff, mv(-1/-10)	

	*------------------------------------------------------------
	* EMPLOYED indicator (UKHLS) — STATUS FIRST, ATTACHMENT FALLBACK
	* Primary: jbstat (main status)
	* Fallback: jbhas/jboff only if jbstat is missing
	* Employed statuses by jbstat: 1 self-employed, 2 paid employment, 11 apprenticeship
	* Not employed by jbstat: all other non-missing jbstat categories (incl maternity/parental leave)
	*------------------------------------------------------------

	capture drop employed
	gen byte employed = .

	* 1) STATUS-FIRST: classify everyone with observed jbstat
	replace employed = 1 if inlist(jbstat, 1, 2, 11)
	replace employed = 0 if !missing(jbstat) & !inlist(jbstat, 1, 2, 11)

	* 2) FALLBACK ONLY IF jbstat is missing: use attachment questions
	*    jbhas: did any paid work last week? (1 yes, 2 no)
	*    jboff: asked if jbhas==2; had a job you were away from last week? (1 yes, 2 no, 3 waiting to take up job)
	replace employed = 1 if missing(jbstat) & jbhas == 1
	replace employed = 1 if missing(jbstat) & jbhas == 2 & jboff == 1
	replace employed = 0 if missing(jbstat) & jbhas == 2 & inlist(jboff, 2, 3)

	* Labels
	capture label drop employed_lab
	label define employed_lab 0 "Not employed" 1 "Employed"
	label values employed employed_lab
	label var employed "Employed (UKHLS; status-based)"

	* DIAGNOSTICS 
	
	* Basic check
	tab employed, missing
	tab jbstat employed, missing

	* Inspecting attachment fallback
	gen byte emp_from_fallback = missing(jbstat) & employed < .
	tab emp_from_fallback, missing
	tab jbhas if emp_from_fallback==1, missing 				// Only 109 cases - rarely used
	tab jboff if emp_from_fallback==1 & jbhas==2, missing
	
	* Checking for tension between jbstat and attachment vars
	gen byte attach_ok = (jbhas==1 | (jbhas==2 & jboff==1)) if !missing(jbhas)
	tab attach_ok if inlist(jbstat,1,2,11), missing
	tab jbstat jbhas if inlist(jbstat,1,2,11), missing
	tab jbstat jboff if inlist(jbstat,1,2,11) & jbhas==2, missing


/*------------------------------------------------------------
**# EMPLOYED indicator (UKHLS) - OLD APPROACH
* Includes apprentices (jbstat==11) as employed.
* Definition: employed==1 if in an employment jbstat category
*             AND either 'has a job' OR 'off work' this period.
*------------------------------------------------------------

	capture drop employed
	gen byte employed = .

	* 0) Default everyone with a valid jbstat to not employed (0)
	replace employed = 0 if !missing(jbstat)

	* 1) Mark employed when in an employment status AND attached
	*    - Employment statuses: 1 self-employed, 2 paid employment, 11 apprenticeship
	*    - Attachment signal:   jbhas==1 (has a job) OR jboff==1 (off work)
	replace employed = 1 if inlist(jbstat, 1, 2, 11) & (jbhas==1 | jboff==1)

	* IMPORTANT: Do NOT force employed back to 0 just because jboff==2.
	* jboff==2 typically means "not off work", which should not negate jbhas==1.

	* Label
	capture label drop employed_lab
	label define employed_lab 0 "Not employed" 1 "Employed"
	label values employed employed_lab
	label var employed "In employment or off work but has employment"

	* Diagnostics
	tab employed, m
	tab jbstat employed , m
	tab jbstat jboff if employed ==1, m
	tab jbstat jbhas if employed ==1, m

	* Guardrails you can keep or remove
	assert missing(jbstat) | !missing(employed )

	* If you want to see cases that look odd (employment jbstat but no attachment flags):
	list jbstat jbhas jboff if inlist(jbstat,1,2,11) & employed ==0 & !missing(jbhas) & !missing(jboff) in 1/20 // no cases shown
*/
	
**# Non-employment variable
*********************************
	
	*------------------------------------------------------------
	* Non-employment destination (UKHLS) — includes maternity/parental leave
	*------------------------------------------------------------

	tab jbstat, mis

	capture label drop nonemp_lab
	label define nonemp_lab ///
		0 "Inapplicable (employed / out of scope)" ///
		1 "Unemployed" ///
		2 "Education or training" ///
		3 "Care of family/home" ///
		4 "Long-term sick or disabled" ///
		5 "Maternity/parental leave" ///
		6 "Other non-employed"

	capture drop nonemp
	gen byte nonemp = .

	* 0. Inapplicable (still "employment" statuses)
	replace nonemp = 0 if inlist(jbstat, 1, 2, 11)
		// 1 self-emp, 2 paid emp, 11 apprenticeship

	* 1. Unemployed
	replace nonemp = 1 if jbstat == 3

	* 2. Education or training
	replace nonemp = 2 if inlist(jbstat, 7, 9)
		// 7 full-time student, 9 government training scheme

	* 3. Care of family/home
	replace nonemp = 3 if jbstat == 6

	* 4. Long-term sick or disabled (UK-only)
	replace nonemp = 4 if jbstat == 8

	* 5. Maternity/parental leave
	replace nonemp = 5 if jbstat == 5

	* 6. Other non-employed (retired should be tiny at 25–59, but include defensively)
	replace nonemp = 6 if inlist(jbstat, 4, 10, 97)
		// 4 retired, 10 unpaid family business, 97 doing something else

	label values nonemp nonemp_lab
	label var nonemp "Non-employment destination"

	* Check mapping
	tab jbstat nonemp, m
	tab jbstat nonemp if exit_t1==1, m
	
	/* Old syntax (maternity leave not included)
	tab jbstat, mis
	
	capture label drop nonemp_lab
	label define nonemp_lab ///
		0 "Inapplicable (employed / out of scope)" ///
		1 "Unemployed" ///
		2 "Education or training" ///
		3 "Care of family/home" ///
		4 "Long-term sick or disabled (UK-only)" ///
		5 "Sheltered workshop (DE-only)" ///
		6 "Other non-employed"

	capture drop nonemp
	generate byte nonemp = .

	* 0. Inapplicable (employed / out of scope)
	replace nonemp = 0 if inlist(jbstat, 1, 2, 4, 5, 11)
		// 1 self-emp, 2 paid emp, 4 retired, 5 maternity, 11 apprenticeship

	* 1. Unemployed
	replace nonemp = 1 if jbstat == 3

	* 2. Education or training
	replace nonemp = 2 if inlist(jbstat, 7, 9)
		// 7 full-time student, 9 government training scheme
		// (Apprenticeship moved to 0 by design)

	* 3. Care of family/home
	replace nonemp = 3 if jbstat == 6

	* 4. Long-term sick or disabled (UK-only)
	replace nonemp = 4 if jbstat == 8

	* 6. Other non-employed
	replace nonemp= 6 if inlist(jbstat, 10, 97)
		// 10 unpaid family business, 97 doing something else

	label values nonemp nonemp_lab

	* Quick check (negatives in jbstat are already true-missing in your data)
	tab jbstat nonemp, m

	*------------------------------------------------------------*
	* Check 1: Coverage of the recode at the SAME wave
	*    (are any jbstat values left unmapped to nonemp?)
	*------------------------------------------------------------*
	tab jbstat nonemp, m

	count if !missing(jbstat) & missing(nonemp)
	display as text "Unmapped (jbstat non-missing but nonemp missing): " r(N)

	tab jbstat if !missing(jbstat) & missing(nonemp), m   // inspect any unexpected jbstat codes
	
	*------------------------------------------------------------*
	* Timing checks: exit is recorded at t, destination/status is at t+1
	*------------------------------------------------------------*
	xtset pidp wave

	* Follow-up (t+1) versions of key variables for baseline exit rows
	capture drop emp_f
	capture drop sempl_f
	capture drop jbstat_f
	capture drop nonemp_f
	gen emp_f    = F.employed if risk_emp_t==1 & exit_t1 < .
	gen sempl_f  = F.sempl    if risk_emp_t==1 & exit_t1 < .
	gen jbstat_f = F.jbstat   if risk_emp_t==1 & exit_t1 < .
	gen nonemp_f = F.nonemp   if risk_emp_t==1 & exit_t1 < .

	label var emp_f    "employed at t+1 (F.employed)"
	label var sempl_f  "self-employed flag at t+1 (F.sempl)"
	label var jbstat_f "jbstat at t+1 (F.jbstat)"
	label var nonemp_f "nonemp at t+1 (F.nonemp)"

	label val jbstat_f a_jbstat // carry forward values for readability
	
	* Core consistency check: does exit_t1==1 actually imply not employed at t+1?
	tab exit_t1 emp_f if risk_emp_t==1, missing
	count if risk_emp_t==1 & exit_t1==1 & emp_f==1
	di as text "Potential inconsistency: exit_t1==1 but employed at t+1 (emp_f==1): " r(N)

	count if risk_emp_t==1 & exit_t1==0 & emp_f==0
	di as text "Potential inconsistency: exit_t1==0 but NOT employed at t+1 (emp_f==0): " r(N)

	/* If there are inconsistencies, list a few cases to inspect
	list pidp wave employed emp_f sempl sempl_f exit_t1 emploss F.emploss jbstat_f nonemp_f ///
		if risk_emp_t==1 & ((exit_t1==1 & emp_f==1) | (exit_t1==0 & emp_f==0)) ///
		in 1/25, sepby(pidp)
	*/

	* Now: among baseline exits, what is follow-up jbstat?
	tab jbstat_f if risk_emp_t==1 & exit_t1==1, missing

	* And how does emp_f relate to jbstat_f among exits?
	tab jbstat_f emp_f if risk_emp_t==1 & exit_t1==1, missing

	* And how does your nonemp destination relate?
	tab nonemp_f if risk_emp_t==1 & exit_t1==1, missing
	tab jbstat_f if risk_emp_t==1 & exit_t1==1 & nonemp_f==0, missing
*/

**# Employment loss variable
****************************

	// Between consecutive waves only
	
	* Ensure panel is set (allows L.)
	xtset pidp wave
	sort pidp wave
	
	* Build explicit lags
	capture drop L_employed
	gen L_employed = L.employed
	capture drop L_wave
	gen L_wave     = L.wave

	* Flag consecutive waves
	capture drop consec
	gen byte consec = (wave == L_wave + 1)

	* At-risk: employed at t-1 and consecutive
	capture drop atrisk
	gen byte atrisk = (L_employed == 1 & consec == 1)

	* Rebuild emploss cleanly
	capture drop emploss
	gen byte emploss = .
	replace emploss = 1 if atrisk & employed == 0   // employment exit
	replace emploss = 0 if atrisk & employed == 1   // retained employment

	capture label drop emploss
	label define emploss 0 "Retained employment" 1 "Employment loss"
	label values emploss emploss

	* Check specific cases
	list pidp wave employed emploss if pidp==4794685 | pidp==68029927 | ///
	pidp==68028571 | pidp==68037407 | pidp==68041487		

* DIAGNOSTICS: Why do some exits have jbstat_f in employment?
***************************************************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	preserve
	keep if risk_emp_t==1 & exit_t1==1

	* Follow-up (t+1) versions
	capture drop jbstat_f
	capture drop jbhas_f
	capture drop jboff_f
	capture drop employed_f
	capture drop nonemp_f
	gen jbstat_f   = F.jbstat
	gen jbhas_f    = F.jbhas
	gen jboff_f    = F.jboff
	gen employed_f = F.employed
	gen nonemp_f   = F.nonemp

	* Carry value labels (optional)
	label dir 										// retrieve label manually
	label values jbstat_f a_jbstat
	label values jbhas_f a_jbhas
	label values jboff_f a_jboff
	tab jbstat_f, m
	tab jbhas_f, m
	tab jboff_f, m

	* 1) Show the inconsistency
	tab jbstat_f employed_f, missing

	* 2) Focus on "employment jbstat at t+1 but employed_f==0"
	gen byte emp_jbstat_f = inlist(jbstat_f,1,2,11)			// self-emp, paid emp or apprenticeship
	count if emp_jbstat_f==1 & employed_f==0
	di as text "jbstat_f indicates employment (1/2/11) but employed_f==0: " r(N) // 3,085

	* 3) What do jbhas_f / jboff_f look like in those cases?
	tab jbhas_f if emp_jbstat_f==1 & employed_f==0, missing
	tab jboff_f if emp_jbstat_f==1 & employed_f==0, missing

	* 4) Cross-tabs by jbstat category
	tab jbstat_f jbhas_f if emp_jbstat_f==1 & employed_f==0, missing
	tab jbstat_f jboff_f if emp_jbstat_f==1 & employed_f==0, missing

	* 5) Are these "missing attachment flags" versus "explicitly not attached"?
	gen byte attach_ok_f = (jbhas_f==1 | jboff_f==1)
	gen byte attach_miss_f = (missing(jbhas_f) & missing(jboff_f))

	tab attach_ok_f attach_miss_f if emp_jbstat_f==1 & employed_f==0, missing

	* 6) Show a handful of rows for inspection
	list pidp wave jbstat_f jbhas_f jboff_f employed_f nonemp_f in 1/50, sepby(pidp)
	
	* 7) Checking routing between attachment vars:
	tab jbhas_f jboff_f if risk_emp_t==1 & exit_t1==1, missing
	
	* 8) How widespread is non-attachment amongst all exits?
	tab jbstat_f jbhas_f if risk_emp_t==1 & exit_t1==1, missing


	restore

**# Reasons for job ending
**************************
	/* 2 options:
	- stendreas: reason for latest exit
	- reasend*: tied to a particular spell
	*/

* OPTION 1 USING STENDREAS
*==============================

	* mvdecode stendreas in waves 7 to 10
	foreach n in 1 2 3 4 5 6 7 8 9 10 11 97 {
		mvdecode stendreas`n', mv(-1/-10) 
	}

	*** not continued with this for now ***
	
* OPTION 2 USING REASEND 
*========================

	* mvdecode all reasend variables
	mvdecode reasend*, mv(-1/-10)

	* Inspect naming convention for all reasend variables
	tab wave reasend1, mis
	tab wave reasend1_1, mis

	foreach n in 1 2 3 4 5 6 7 8 9 10 {
		label list b_reasend`n' 
	}

	* STEP 1: Harmonise reasons into reason_spell# (works for waves 2–10)
	
	* Drop previously created variables to avoid mix-ups
	capture drop reason_spell*
	capture drop reasend_code*   // only if you created these in an earlier attempt

	* Standardise end-date names once (safe if already done)
	capture unab M : empstendm*
	if !_rc {
		foreach v of varlist empstendm* {
			local new = subinstr("`v'","empstendm","endm",.)
			rename `v' `new'
		}
		foreach v of varlist empstendy* {
			local new = subinstr("`v'","empstendy","endy",.)
			rename `v' `new'
		}
	}

	* Clean slate
	capture drop reason_spell*

	forvalues s = 1/9 {
		gen byte reason_spell`s' = .

		* Waves 2–6: if a categorical reasend`s' exists (not just 0/1), copy it
		capture confirm variable reasend`s'
		if !_rc {
			quietly summarize reasend`s' if reasend`s' < .
			if r(max) > 1 {
				replace reason_spell`s' = reasend`s' if !missing(reasend`s')
			}
		}

		* Waves 7–10: collapse dummies with HEALTH (7) top priority
		* (Exclude 1=Promoted by default; add it if you want it)
		foreach c in 7 2 3 4 5 6 8 9 10 11 97 {
			capture confirm variable reasend`c'_`s'
			if !_rc replace reason_spell`s' = `c' ///
				if missing(reason_spell`s') & reasend`c'_`s'==1
		}
	}

	* Labels (edit as needed)
	capture label define reason_lbl ///
		2 "Left for better job"      ///
		3 "Made redundant"           ///
		4 "Dismissed/sacked"         ///
		5 "Temporary job ended"      ///
		6 "Took retirement"          ///
		7 "Health reasons"           ///
		8 "Left to have baby"        ///
		9 "Look after family"        ///
		10 "Look after other person" ///
		11 "Moved area"              ///
		97 "Other reason", replace

	forvalues s=1/9 {
		capture label values reason_spell`s' reason_lbl
	}
	
	/* save if working on clean data
	compress
	save "$path2/ukhls_clean.dta", replace
	*/
	
	* STEP 2: Match the reason to the exit wave (emploss==1)
		
	* You should already have: pidp, wave, intdatm_dv, intdaty_dv,
	* reason_spell1-9, and endm1-9 / endy1-9 (or renamed/standardised earlier)

	* 0) Make sure your panel dates exist
	sort pidp wave
	gen tm_int  = ym(intdaty_dv, intdatm_dv)
	by pidp: gen tm_int_lag = tm_int[_n-1]
	format tm_int* %tm

	* 1) Work on a temp copy
	preserve
	keep pidp wave tm_int tm_int_lag intdatm_dv intdaty_dv reason_spell* endm* endy*

	* (optional) sanity: you should have only one set of end arrays
	* If you still have both empstendm* and endm*, standardise earlier or drop one.

	* 2) Drop any leftovers from previous attempts so reshape can create these names
	capture drop s_reason s_endm s_endy spell

	* 3) Reshape using mapping: new stubs on the left, existing stubs on the right
	reshape long  s_reason=reason_spell  s_endm=endm  s_endy=endy,  ///
		i(pidp wave) j(spell)

	* 4) Build spell end dates and keep matches in the inter-wave window
	gen tm_end = ym(s_endy, s_endm)
	format tm_end %tm
	keep if !missing(tm_int_lag) & !missing(tm_end) & tm_end >= tm_int_lag & tm_end <= tm_int

	* If several spells end in the window, keep the latest
	bys pidp wave (tm_end): keep if _n==_N

	* 5) Save tiny matcher and return
	keep pidp wave s_reason
	rename s_reason reasend_code
	tempfile reas_match
	save `reas_match', replace
	restore

	* 6) Merge and attach only to exit waves
	merge 1:1 pidp wave using `reas_match', nogen
	gen byte reason_exit = .
	replace reason_exit = reasend_code if emploss == 1
	label values reason_exit reason_lbl
	label var reason_exit "Reason for exit (matched to emploss wave)"

	* Quick QA
	tab emploss, m
	tab reason_exit if emploss==1, m


**#
*-------------------------------------------------------------------------------
* Occupation & education vars
*-------------------------------------------------------------------------------
/*	 How to re-code 'inapplicable': (latest update 21/11/24)
	Latest decision is to code 'inaplicable' responses where these are 
	clearly the result of filtering (eg those not in employment) as 
	.a rather than zero. Thhis is because ´'m only interested in those in employment
	at baseline and whether they leave employment or not. Including inapplicable in 
	the model makes the interpretation more confusing I think. */

* 	Occupation
/* 	Use 8 category NSSEC for now. It roughly matches ESEC categories and both are 
	used comparatively by others, eg Schad 2015, Trinh and Bukodi - see zotero. */
	tab jbnssec8_dv
	// 43% missing as inapplicable, 1% as actually missing
	tab jbstat jbnssec8_dv if jbnssec8_dv==-8, col
	// 11% unemployed, 53% retired, 13% family care or home.. 
	// recode as zero
	mvdecode jbnssec8_dv, mv(-9=.)
	recode jbnssec8_dv (-8=0 "Inapplicable") ///
	(1=1 "Large employers & higher management") ///
	(2=2 "Higher professional") ///
	(3=3 "Lower management & professional") ///
	(4=4 "Intermediate") ///
	(5=5 "Small employers & own account") ///
	(6=6 "Lower supervisory & technical") ///
	(7=7 "Semi-routine") ///
	(8=8 "Routine"), gen(jbnssec8_dv_re)
	tab jbnssec8_dv_re, mis
	
* 3-class NSSEC
	mvdecode jbnssec3_dv, mv(-9=.)
	recode jbnssec3_dv (-8=0 "Inapplicable") (1=1 "Management & professional") ///
	(2=2 "Intermediate") (3=3 "Routine"), gen(jbnssec3_re)
	tab jbnssec3_re, mis
	

* 	Level of education	
	// different from ISCED11 - see if ISCED11 can be derived. TO DO
	tab hiqual_dv, mis
	/* less than 1% missing, 1% inapplicable - not sure why inapplicable. have 
	checked it's not just children. */
	mvdecode hiqual_dv, mv(-1/-10)

* Type of education - vocational/general - To DO

**#
*-------------------------------------------------------------------------------
* Contract type
*-------------------------------------------------------------------------------

* 	Part-time
*****************
	tab jbft_dv 
	// 41% inapplicable, 6.42% proxy. 
	// Re-code -9 missing and -7 proxy as missing, -8 inapplicable as 0.
	mvdecode jbft_dv, mv(-7 -9=.)
	tab jbft_dv, mis
	recode jbft_dv (-8=0 "Inapplicable") (1=1 "FT employee") ///
	(2=2 "PT employee"), gen(jbft_dv_re)
	tab jbft_dv_re, mis

*	Normal weekly hours
	sum jbhrs, detail
	tab jbhrs
	/* 0% -9 missing, 51% -8 inapplicable, 0.08% -2 refusal, 0.40% -1 don't know. */
	// code inapplicable as .a for now as will then combine. 
	mvdecode jbhrs, mv(-9 -2 -1=. \ -8=.a)
	tab jbhrs, mis

* 	Overtime weekly
	sum jbot, detail
	tab jbot
	/* 0% -9 missing, 48% -8 inapplicable, 6% -7 proxy, 0.1% -2 refusal, 0.5% -1 don't know. */
	// code inapplicable as .a for now as will then combine. 
	mvdecode jbot, mv(-1 -2 -7 -9=. \ -8=.a)
	tab jbot, mis
	// probably won't use directly in analysis - otherwise recode as dummy

* 	Combine for total weekly hours - as in SOEP & recode inapplicable
	gen jbhrstot=.
	replace jbhrstot=jbhrs+jbot if jbhrs!=. & jbot!=.
	replace jbhrstot=0 if jbhrs==.a & jbot==.a
	tab jbhrstot, mis
	label var jbhrstot "Normal weekly hours including overtime"
	// probably won't use directly in analysis - otherwise recode as dummy
	
* 	Then use this to categorise new var
	gen parttime=.
	replace parttime=0 if jbhrstot==0
	replace parttime=1 if jbhrstot>=35 & jbhrstot!=. 
	replace parttime=2 if jbhrstot>0 & jbhrstot<35 & jbhrstot>10 & jbhrstot!=.
	replace parttime=3 if jbhrstot>0 & jbhrstot<=10 & jbhrstot!=.
	label define parttime 0 "Inapplicable" 1 "Full-time (>=35h)" ///
	2 " Regular part-time (11-34h)" 3 "Marginal part-time (<=10h)"
	label val parttime parttime
	tab parttime, mis 
	// 7% missing; 48% inapplicable
	tab jbft_dv_re parttime, mis col nofreq
	// 25% of "regular PT" counted as FT in jbft_dv_re
	// makes sense as threshold for FT in jbft_dv_re set at 30hrs (excl. overtime)
	label var parttime "Part-time employment (recoded)"
	
* 	Self-employed
	// although likely to drop as MC issues with NSSEC
	tab jbsemp 
	// 43% inapplicable
	mvdecode jbsemp, mv(-1 -2 -9=. \ -8=.a)
	tab jbsemp, mis 
	* recode to dummy var. Have kept as a dummy with inapplicable as .a, as for SOEP
	// not planning to include in models anyway
	recode jbsemp (.a=.a) (1=0) (2=1) (.=.), gen(sempl)
	label val sempl dummy
	label var sempl "Self-employed (dummy)"
	tab sempl, mis
	* recode to keep inapplicable as zero (just for missing values table)
	recode jbsemp (.a=0) (1=1) (2=2) (.=.), gen(jbsemp_re)
	label define jbsemp_re 0 "Inapplicable" 1 "employee" 2 "self-employed"
	label val jbsemp_re jbsemp_re
	label var jbsemp_re "Recode of employed or self-employed (keeps inapplicables)"
	tab jbsemp jbsemp_re, mis

* 	Fixed-term
	tab jbterm1 
	// 43% inapplicable
	mvdecode jbterm1, mv(-1 -2 -9=.)
	tab jbterm1, mis
	* recode inapplicable
	recode jbterm1 (-8=0 "Inapplicable") (1=1 "a permanent job") ///
	(2=2 "or is there some way that it is not per") (.=.), gen(fixedterm)
	label var fixedterm "Fixed-term employment"
	tab fixedterm, mis
	
* 	Type of non-permanent job
	tab jbterm2 
	/* 95% inapplicable. Filter: if JBHAS = 1 OR JBOFF = 1 (Has a job) 
	and if JBTERM1 = 2 (Job is not permanent). 
	Categories include: seasonal work, contractors, agency temping, casual, other. 
	Previously I had focused only agency temping, but maybe it makes more sense 
	given small numbers to lump all categories up. */
	mvdecode jbterm2, mv(-1 -2)
	tab jbterm2, mis
	* Re-code as dummy variable - here recode inapplicable as zero as very broad
	recode jbterm2 (-8=0 "Inapplicable") (1/97=1 "Yes") (.=.), gen(othernonperm)
	label var othernonperm "Other type of non-permanent job"
	tab othernonperm, mis

/* Temp agency specifically
	gen tempagency=.
	replace tempagency=1 if jbterm2==3
	replace tempagency=0 if jbterm2!=3 & employed==1
	label val tempagency dummy
	label var tempagency "Temp agency work"
	tab tempagency, mis */

**#
*-------------------------------------------------------------------------------
* 	Flexible employment - waves 2, 4, 6, 8, 10 only
*-------------------------------------------------------------------------------

*	Re-code formal flexible working arrangements
	foreach n in 1 2 3 4 5 6 7 8 96 {
	tab jbflex`n'
}
	/* Missing values the same for all. 47% inapplicable. Only asked of 
	employees (jbsemp==1). Proxy (-7)=6.09. Leave inapplicable as 0. */
	foreach n in 1 2 3 4 5 6 7 8 96 {
	mvdecode jbflex`n', mv(-1 -2 -7 -9 -10=.)
	}

/*	TO DO: LIKELY REQUIRES SOME SORT OF LOOP
Collapse into a single dummy for any formal flexible arrangements
	gen flexiformal=.
	replace flexiformal=0 if jbflex1==-8 | jbflex2==-8 // etc for all vars
	replace flexiformal=0 if jbflex1==-0 | jbflex2==-0
	replace flexiformal=1 if jbflex1==1 | jbflex2==1
	label val flexiformal dummy
	label var flexiformal "Formal flexible working arrangements"
	tab flexiformal, mis
	*/

*	Re-code informal flexible arrangements
	tab jbfxinf 
	tab wave jbfxinf, mis 
	/* 47% inaplicable left as -8. missing waves already coded as missing. */
	mvdecode jbfxinf, mv(-1 -2 -7 -9 -10=.)
	tab jbfxinf, mis
	tab wave jbfxinf, mis
	
* Collapse informal arrangements into a single dummy? TO DO.

**#
*-------------------------------------------------------------------------------
* Employer characteristics
*-------------------------------------------------------------------------------

* 	Industrial sector
***********************

* 	Inspect missing data
	tab jbsic07_cc
	// 43% inapplicable - keep as -8 and recode later
	mvdecode jbsic07_cc, mv(-1 -2 -9=.)
	tab jbsic07_cc, mis

*	Recode into SIC 2007 divisisons:
	// recode inapplicable as 0
	tab jbsic07_cc if employed==1, missing 
	// no inapplicable
	numlabel, add
	recode jbsic07_cc (-8=.0)  (.=.) (1/3=1) (5/9=2) (10/32=3) (33/39=4) ///
	(41/43=5) (45/53=6) (55/56=7) (58/63=8) (64/66=9) (68/82=10) (84=11) ///
	(85=12) (86/88=13) (90/96=14) (97/98=15) (99=16), gen(sic_div)
	label define a_sic_div ///
	0 "Inapplicable" ///
	1 "A.Agriculture etc" ///
	2 "B.Mining & quarrying" ///
	3 "C.Manufacturing" ///
	4 "D&E.Electricity, gas etc" ///
	5 "F.Construction" ///
	6 "G.Wholesale & retail trade etc" ///
	7 "I.Accommodation & food" ///
	8 "H&J.Transport, communication etc" ///
	9 "K.Financial & insurance" ///
	10 "L,M&N.Real estate, professional, admin" ///
	11 "O.Public admin & defence" ///
	12 "P.Education" ///
	13 "Q.Health&social work" ///
	14 "R&S.Arts & other services" ///
	15 "T.Households & undifferentiated" ///
	16 "U.Extraterritorial"
	label val sic_div a_sic_div
	label var sic_div " Current job SIC 2007 divisions"
	* check re-coding:
	tab jbsic07_cc if employed==1, mis
	tab sic_div, mis
	tab sic_div if employed==1, mis // all inapplicable disappear

* 	Re-code SIC 2007 into ISIC Rev.4 10 categories, following Cave (2006)
	// needs to be 8 categories bc some divisions in SIC07 already together
	tab sic_div, missing
	recode sic_div (1=1) (2/4=2) (5=3) (6/8=4) (9=5) (10=6) (11/13=7) ///
	(14/16=8) (0=0) (.=.), gen(isic_agg)
	label define a_isic_agg ///
	0 "Inapplicable" ///
	1 "A.Agriculture, forestry, mining" ///
	2 "BCDE.Manufacturing & other industry" ///
	3 "F.Construction" ///
	4 "GHIJ.Wholesale & retail, accommodaton & food, ICT" ///
	5 "K.Financial & insurance" ///
	6 "LMN.Real estate, professional & business services" ///
	7 "OPQ.Public services, health & social work" ///
	8 "RSTU. Other services"
	label val isic_agg a_isic_agg
	label var isic_agg "Current job aggregate ISIC"
	tab isic_agg, mis
	tab isic_agg if employed==1, mis

* 	Re-code SIC 2007 into 5 categories, following Wren (2013)
	recode sic_div (0=0) (1/2=1) (3=2) (4/7 14 15=3) (8/10=4) (11/13 16=5) ///
	(.=.), gen(sic_wren)
	label define a_sic_wren ///
	0 "Inapplicable" /// 
	1 "Agriculture, fishing & mining" ///
	2 "Manfacturing" ///
	3 "Non-dynamic services" ///
	4 "Dynamic services" ///
	5 "Welfare services"
	label val sic_wren a_sic_wren
	label var sic_wren "Current job industry Wren"
	tab sic_wren, mis
	tab sic_wren if employed==1, mis

* 	Re-code aggregated ISIC into 3 broad industrial groups
	numlabel, add
	tab isic_agg, mis
	recode isic_agg (1=1) (2/3=2) (4/8=3) (0=0) (.=.), gen(isic_agg2)
	label define a_isic_agg2 ///
	0 "Inapplicable" ///
	1 "Agriculture, forestry, mining" ///
	2 "Industry" ///
	3 "Services"
	label val isic_agg2 a_isic_agg2
	label var isic_agg2 "Current job very broad industrial sector"
	numlabel, add
	tab isic_agg2, mis
	tab isic_agg2 if employed==1, mis

* Service sector dummy
	tab isic_agg2, mis
	gen services=.
	replace services=1 if isic_agg2==3
	replace services=0 if isic_agg2==0 | isic_agg2==1 | isic_agg2==2
	label var services "Service sector dummy"
	label val services dummy
	tab services, mis

* 	Private company
*******************
/* Note change from calling var "public sector2, as this is what this
	question is asking. */
	tab jbsect, mis 
	// 48% inapplicable - recode later
	mvdecode jbsect, mv(-1 -2 -7 -9=.)
	tab jbsect, mis
	
* Recode
	recode jbsect (-8=0) (1=1) (2=2) (.=.), gen(privcomp)
	label define a_privcomp ///
	0 "Inapplicable" ///
	1 "Private company" ///
	2 "Public or third sector"
	label val privcomp a_privcomp
	label var privcomp "Works in a private company"
	numlabel, add
	tab privcomp, mis
	tab privcomp if employed==1, mis
	// still 13% inapplicable even when employed==1
	tab privcomp sempl if employed==1, mis col
	// indeed, most of the inapplicables (90%) when employed==1 are self-employed
	// does this mean all self-employed are dropped out of the model??


* 	Company size
******************
	* Re-code to match SOEP
	tab jbsize
	// 49% inapplicable
	mvdecode jbsize, mv(-1 -2 -7 -9=.)
	recode jbsize (-8=0) (1/2=1) (3/6=2) (7/9=3) (10 11 = .) ///
	(.=.), gen(jbsize_re)
	label define jbsize_re ///
	0 "Inapplicable" ///
	1 "<10 incl self-employed" ///
	2 "11-200" ///
	3 ">200"
	label var jbsize_re "Company size"
	label val jbsize_re jbsize_re
	numlabel, add
	tab jbsize_re, mis
	tab jbsize_re if employed==1, mis

/*	Previous recode (which makes more sense if using UKHLS only):
	tab jbsize, mis
	recode jbsize (1/4=1) (5 6=2) (7/9=3) (10 11=.), gen(jbsize_re)
	label define a_jbsize_re 1 "micro & small enterprise 1-49" ///
	2 "medium enterprise 50-199" 3 "large enterprise 200+"
	label val jbsize_re a_jbsize_re
	tab jbsize_re, mis
*/

**#
*-------------------------------------------------------------------------------
* Control vars
*-------------------------------------------------------------------------------
* 	Inspect age
	sum age_dv, detail
	tab age_dv if age_dv<0
	mvdecode age_dv, mv(-1/-10)
	rename age_dv age

*	Re-code sex
	// Code those with changing sex as missing
	tab sex_dv
	// 7 missing & 25 observations with 'inconsistent' sex 
	mvdecode sex_dv, mv(0 -9)
	tab sex_dv, mis
	// Recode as a dummy var called "female" to match SOEP
	recode sex_dv (1 = 0 "Male") (2 = 1 "Female"), gen(female)
	numlabel female, add
	tab female

*	Recode marital status to fewer categories:
	tab mastat_dv
	mvdecode mastat_dv, mv(-1/-10)
	recode mastat_dv (2 3 10=1) (4/9=2) (1=3) (0=0), gen(mastat_re)
	label define a_mastat_re 0 "Child under 16" ///
	1 "Married, in civil part. or cohabiting" ///
	2 "Widowed, divorced or separated" ///
	3 "Never married or in civil part."
	label values mastat_re a_mastat_re
	tab mastat_re, missing

*	Recode region
	tab gor_dv
	mvdecode gor_dv, mv(-1/-10)
	// 12  categories - do not re-code for now

*	Recode ethnicity:
	tab racel_dv // 2.86% missing
	mvdecode racel_dv, mv(-1/-10)
	gen ethnic=.
	replace ethnic=1 if racel_dv==1
	replace ethnic=2 if racel_dv>=2 & racel_dv<=4
	replace ethnic=3 if racel_dv>=5 & racel_dv!=.
	label var ethnic "Ethnicity re-coded"
	label define ethnic_lab 1 "White British" 2 "White Other" 3 "BAME"
	label values ethnic ethnic_lab
	tab ethnic, mis

*	Recode tenure into dummy for home ownership
	// Collapse private & social tenant to match SOEP
	tab tenure_dv
	// 0.57% missing
	mvdecode tenure_dv, mv(-1/-10)
	recode tenure_dv (1/2=1) (3/8 =0) (.=.), gen(howner)
	label val howner dummy
	tab howner, mis
	label var howner "Homeowner (dummy)"

*	Log of net household income
	sum fihhmnnet1_dv, detail
	histogram fihhmnnet1_dv, normal
	tab fihhmnnet1_dv if fihhmnnet1_dv<0
	// 17 missing (-9). Other negatives, presumably debt. 
	mvdecode fihhmnnet1_dv, mv(-9)
	tab fihhmnnet1_dv if fihhmnnet1_dv<0, mis
	gen loghhinc=log(fihhmnnet1_dv)
	sum loghhinc, detail
	histogram loghhinc, normal
	label var loghhinc "Log net household income"

*	Number of children in household
	tab nkids_dv
	// no missing

* 	Job satisfaction
	tab jbsat 
	// 40% inapplicable - recode as .a
	mvdecode jbsat, mv(-1 -2 -7 -9 -10=.)
	tab jbsat, mis
	// scale ranging from 1 (completely dissatisfied) to 7 (completely satisfied)
	// re-code inapplicable as 0
	recode jbsat (-8=.0 "Inapplicable") (1=1 "completely dissatisfied") ///
	(2=2 "mostly dissatisfied") (3=3 "somewhat dissatisfied") ///
	(4=4 "neither satisfied or dissatisfied") ///
	(5=5 "somewhat satisfied") ///
	(6=6 "mostly satisfied") ///
	(7=7 "completely satisfied"), gen(jbsat_re)
	numlabel, add
	tab jbsat_re, mis

*	Create var for mental impairment (GHQ>2) - based on Burchardt?? Check - TO DO
	tab scghq2_dv
	mvdecode scghq2_dv, mv(-1/-10)
	sum scghq2_dv, detail
	// ranges from zero to 12
	gen ghq2=.
	replace ghq2=1 if scghq2_dv!=. & scghq2_dv>2
	replace ghq2=0 if scghq2_dv!=. & scghq2_dv<=2
	tab ghq2, mis
	* TO DO: add meaningful value labels
	label var ghq2 "Mental illness (GHQ Caseness>2)"

*	Satisfaction with health var
	tab sclfsat1
	/* 6% inapplicable (not sure why); 6% proxy respondents; rest of missing cats
	are below 1% each. */
	mvdecode sclfsat1, mv(-1/-10)
	tab sclfsat1 health_re, mis col nofreq chi
	rename sclfsat1 healthsat

*-------------------------------------------------------------------------------
* Tidy up
*-------------------------------------------------------------------------------
* Add numerical values to labels
	numlabel, add

* Order
	order pidp hidp wave
	sort pidp wave
	isid pidp wave

* Save clean dataset
	compress
	save "$path2/ukhls_clean.dta", replace
	
/* Wave-by-wave sample sizes before imposing additional criteria

	* Initialize matrix for unweighted Ns
		matrix Unwtd_matrix = J(10, 2, .)

		forvalues w = 1/10 {
			
			use "$path2/ukhls_clean.dta", clear
			keep if wave == `w'

			count if wld_any_nopain == 1
			local n_wld = r(N)

			count if wld_any_nopain == 0
			local n_nonwld = r(N)

			matrix Unwtd_matrix[`w', 1] = `n_wld'
			matrix Unwtd_matrix[`w', 2] = `n_nonwld'
		}

		* Label matrix
		matrix rownames Unwtd_matrix = wave1 wave2 wave3 wave4 wave5 wave6 wave7 wave8 wave9 wave10
		matrix colnames Unwtd_matrix = WLD NonWLD

		* Display matrix
		matrix list Unwtd_matrix

		* Export to CSV
		clear
		svmat Unwtd_matrix, names(col)
		gen wave = _n
		order wave WLD NonWLD

		export delimited using "$path6/ukhls_wld_counts_unfiltered.csv", replace
	*/

*-------------------------------------------------------------------------------
/**# Produce codebook of recoded variables
*-------------------------------------------------------------------------------

use "$path2/ukhls_clean.dta", clear

* Full codebook
	codebook health_re numfunc_re adl wld_any wld_any_nopain employed emploss ///
	unemptrans ltsdtrans othertrans jbnssec8_dv_re hiqual_dv parttime sempl ///
	fixedterm othernonperm sic_div isic_agg privcomp jbsize_re age sex_dv ///
	mastat_re gor_dv ethnic howner loghhinc nkids_dv jbsat_re ghq2 healthsat

* Compact
	codebook health_re numfunc_re adl wld_any wld_any_nopain employed emploss ///
	unemptrans ltsdtrans othertrans jbnssec8_dv_re hiqual_dv parttime sempl ///
	fixedterm othernonperm sic_div isic_agg privcomp jbsize_re age sex_dv ///
	mastat_re gor_dv ethnic howner loghhinc nkids_dv jbsat_re ghq2 healthsat, compact

/*Export codebook using asdoc
	ssc install asdoc

	asdoc codebook health_re numfunc_re adl wld_any wld_any_nopain employed emploss ///
	unemptrans ltsdtrans othertrans jbnssec8_dv_re hiqual_dv parttime sempl ///
	fixedterm othernonperm sic_div isic_agg privcomp jbsize_re age sex_dv ///
	mastat_re gor_dv ethnic howner loghhinc nkids_dv jbsat_re ghq2 healthsat, ///
	replace compact save("`path4'\ukhls_codebook.docx")
	// issue with reading the file path 
*/

/* Export codebook using a log
	capture noisily {
		log using "$path4/ukhls_recoded.txt", replace
		describe health_re numfunc_re adl wld_any wld_any_nopain employed emploss ///
	unemptrans ltsdtrans othertrans jbnssec8_dv_re hiqual_dv parttime sempl ///
	fixedterm othernonperm sic_div isic_agg privcomp jbsize_re age sex_dv ///
	mastat_re gor_dv ethnic howner loghhinc nkids_dv jbsat_re ghq2 healthsat
		log close
	}
*/ */


********************************************************************************
**# 3. METHODS / EXPLORATORY ANALYSES
********************************************************************************
*-------------------------------------------------------------------------------
**# Inspect missing data after recoding
*-------------------------------------------------------------------------------
* 	Open dataset with recoded variables
	use "$path2/ukhls_clean.dta", clear

* 	Inspect missing data (code from Roxanne)
	ssc install mdesc

* Sample restrictions before case completion (age 16-64)
	keep if ivfio == 1 & scflag_dv == 1
	keep if inrange(age,16,64)
	drop if intdaty_dv == 2020 & intdatm_dv > 2

* 	Visual inspection
    mdesc ///
	health adl physical_amount physical_kind mental_amount mental_care ///
    pain_inter wld_any_nopain scghq2_dv healthsat ///
    age sex_dv ethnic mastat_re howner hiqual_dv nkids_dv loghhinc ///
    employed jbsemp_re ///
    jbnssec8_dv_re parttime fixedterm isic_agg privcomp jbsize_re ///
    jbsat_re wave gor_dv
	
	/* Combined list of vars
	
	* Disability vars
	health adl physical_amount physical_kind mental_amount mental_care pain_inter wld_any_nopain healthsat
	
	*Socio-economic vars
	age sex_dv ethnic mastat_re howner hiqual_dv nkids_dv loghhinc
	
	* Broad employment status
	employed
	
	* Employment-based variables
	jbnssec8_dv_re parttime fixedterm isic_agg privcomp jbsize_re jbsat_re jbsemp_re
	
	* Region and period variables
	wave gor_dv
	
	* Vars used in each chapter
	
	Ch5
	mdesc health adl ///
	physical_amount physical_kind mental_amount mental_care pain_inter ///
	emploss wave gor_dv age sex ethnic ///
	mastat_re hiqual_dv jbnssec8_dv_re parttime fixedterm isic_agg ///
	privcomp jbsize_re loghhinc nkids_dv howner healthsat jbsat_re health_re

	
	Ch6
	gen byte cond4 = !missing(wld_any, wld_any_nopain, employed, wave, gor_dv, age, sex_dv, ethnic, ///
    mastat_re, hiqual_dv, jbnssec3_re, parttime, fixedterm, isic_agg, ///
    privcomp, jbsize_re, nkids_dv)
	
	Ch7
	wld_any_nopain ///
		wave          ///
		gor_dv        ///
		jbnssec3_re   ///
		parttime      ///
		fixedterm     ///
		jbsize_re     ///
		privcomp      ///
		isic_agg2     ///
		age           ///
		nkids_dv      ///
		sex_dv        ///
		ethnic        ///
		mastat_re     ///
		degree - derived from hiqual_dv
		** also need to add self-employment variable: jbsemp_re
		(not sempl nor jbsemp which have recoded inapplicable as missing) 
	*/
	
* Missingness table - general 
*******************************
	
* Export table using postfile

	use "$path2/ukhls_clean.dta", clear

	* Restrict to target sample
	keep if ivfio == 1 & scflag_dv == 1
	keep if inrange(age,16,64)
	drop if intdaty_dv == 2020 & intdatm_dv > 2

	tempfile missdata

	postfile handle ///
		str80 variable ///
		long n_missing ///
		long n_nonmissing ///
		double pct_missing ///
		using `missdata', replace

	foreach var in ///
		health adl physical_amount physical_kind mental_amount mental_care ///
		pain_inter wld_any_nopain scghq2_dv healthsat ///
		age sex_dv ethnic mastat_re howner hiqual_dv nkids_dv loghhinc ///
		employed jbsemp_re ///
		jbnssec3_re parttime fixedterm isic_agg privcomp jbsize_re ///
		jbsat_re wave gor_dv {

		quietly count if missing(`var')
		local miss = r(N)

		quietly count if !missing(`var')
		local nonmiss = r(N)

		local total = `miss' + `nonmiss'
		local pct = 100 * `miss' / `total'

		local lbl : variable label `var'

		if "`lbl'" == "" {
			local lbl "`var'"
		}

		post handle ///
			("`lbl'") ///
			(`miss') ///
			(`nonmiss') ///
			(`pct')
	}

	postclose handle

	use `missdata', clear

	format pct_missing %6.2f

	list, noobs abbreviate(30)
	
	export excel using ///
    "$path6/ukhls_methodchap_missingness.xlsx", ///
    firstrow(variables) replace

* Missingness table - by WLD
*****************************

use "$path2/ukhls_clean.dta", clear

keep if ivfio == 1 & scflag_dv == 1
keep if inrange(age,16,64)
drop if intdaty_dv == 2020 & intdatm_dv > 2

tempfile missdata

postfile handle ///
    str80 variable ///
    long n0_nonmiss ///
    long n0_miss ///
    double pct0 ///
    long n1_nonmiss ///
    long n1_miss ///
    double pct1 ///
    using `missdata', replace
	
foreach var in ///
    health adl physical_amount physical_kind mental_amount mental_care ///
    pain_inter wld_any_nopain scghq2_dv healthsat ///
    age sex_dv ethnic mastat_re howner hiqual_dv nkids_dv loghhinc ///
    employed jbsemp_re ///
    jbnssec8_dv_re parttime fixedterm isic_agg privcomp jbsize_re ///
    jbsat_re wave gor_dv {

    * -------------------------
    * Non-WLD (0)
    * -------------------------
    quietly count if wld_any_nopain == 0 & !missing(`var')
    local n0_nonmiss = r(N)

    quietly count if wld_any_nopain == 0 & missing(`var')
    local n0_miss = r(N)

    local n0_total = `n0_nonmiss' + `n0_miss'
    local pct0 = 100 * `n0_miss' / `n0_total'

    * -------------------------
    * WLD (1)
    * -------------------------
    quietly count if wld_any_nopain == 1 & !missing(`var')
    local n1_nonmiss = r(N)

    quietly count if wld_any_nopain == 1 & missing(`var')
    local n1_miss = r(N)

    local n1_total = `n1_nonmiss' + `n1_miss'
    local pct1 = 100 * `n1_miss' / `n1_total'

    * Label
    local lbl : variable label `var'
    if "`lbl'" == "" local lbl "`var'"

    * Post in desired order
    post handle ///
        ("`lbl'") ///
        (`n0_nonmiss') ///
        (`n0_miss') ///
        (`pct0') ///
        (`n1_nonmiss') ///
        (`n1_miss') ///
        (`pct1')
}

postclose handle

use `missdata', clear

format pct0 pct1 %6.2f

export excel using ///
    "$path6/ukhls_methodschap_missingness_by_wld.xlsx", ///
    firstrow(variables) replace
	
/* Creating analytic samples
*-------------------------------------------------------------------------------

* Create main sample but also alternative samples for analyses

* Main sample
***************
/* 	
a) Create a word document to record missing cases automatically? Use to keep track of missing data as I inspect it. Save in the logs folder "$path3".
	Always specify whether UKHLS or SOEP as they will be in the same folder. 
	putdocx begin
	potdocx paragraph, style(Heading)
	putdocx text ("UKHLS creating sample") 
	putdocx textblock begin
// See Connelly (2022) do-file3 for details

b) Record manually on excel table instead
*/

* 	1. Only use observations for which full interview is available, rather than proxy, and including the self-completion questionnaire. 
	tab wave ivfio, mis
	keep if ivfio==1 & scflag_dv==1
	xtsum pidp
	save "$path8/ukhls_sample_step1_ivfio.dta", replace

* 	2. Remove interviews taking place after March 2020
	tab intdatm_dv if intdaty_dv==2020
	drop if intdaty_dv==2020 & intdatm_dv>2
	xtsum pidp
	// 18 observations deleted (no unique respondents lost ie they'd all been interviewed previously)
	save "$path8/ukhls_sample_step2_covid.dta", replace
	
* 	3. Ages 25-54 for both men and women
	* Keep respondents who are 54 or less
	keep if age<=54
	* Keep respondents who are 25 or more
	bysort pidp: keep if age>=25
	tab age
	list pidp wave age in 1/100
	xtsum pidp
	save "$path8/ukhls_sample_step3_ages.dta", replace
	
*	4. Keep only complete cases
	/* Copied from Roxanne's automation training. For now, use variables 
	included in full model previously, swapping health_re for wld_any. Note that
	this will likely delete many cases indeed. I have removed temp agency. */
	keep if !missing(wld_any, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	xtsum pidp
	save "$path8/ukhls_sample_step4_complete.dta", replace
	
*	5. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	save "$path8/ukhls_sample_step5_employed.dta", replace

*	6. Impose balanced panel
	// Create var for balanced panel
	bysort pidp: egen wavenum = sum(wave>=1)
	xtsum wavenum
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path8/ukhls_sample_step6_balanced.dta", replace
	
	/* Alternative way of deriving indicator for balanced panel
	gen participated = 1 if inrange(wave, 1, 10) & inrange(ivfio, 1, 2)
	egen participationcount = total(participated) if inrange(wave, 1, 10), by(pidp)
	gen balanced = 1 if participationcount==10 */
	
	save "$path2/ukhls_samplea.dta", replace

	* Alternative samples
	**********************

* Alternative sample B without employment criterion

	use "$path8/ukhls_sample_step4_complete.dta", clear
	bysort pidp: egen wavenum = sum(wave>=1)
	xtsum wavenum
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path2/ukhls_sample_step6b_balancednoemployment.dta", replace
	
	/* no change to the number of transitions. Keep for interest in other sample
	characteristics. */	
	
* Alternative sample C with more relaxed age criterion (16-64)
	use "$path8/ukhls_sample_step2_covid.dta", clear
	// 3c. age criterion
	keep if age<=64
	bysort pidp: keep if age>=16
	tab age
	list pidp wave age in 1/100
	xtsum pidp
	// 4c. Keep only complete cases
	keep if !missing(wld_any, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	xtsum pidp
	// 5c. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	// 6c. Balanced panel
	bysort pidp: egen wavenum = sum(wave>=1)
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path2/ukhls_samplec_16_64.dta", replace

* Alternative sample d with health_re instead of wld_any in the complete case criterion
	// while also relaxing age criterion - need to maximise number of transitions
	use  "$path8/ukhls_sample_step2_covid.dta", clear
	// 3d. age criterion
	keep if age<=64
	bysort pidp: keep if age>=16
	tab age
	list pidp wave age in 1/100
	xtsum pidp
	// 4d. Keep only complete cases with health_re
	keep if !missing(health_re, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	xtsum pidp
	// 5d. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	// 6d. Balanced panel
	bysort pidp: egen wavenum = sum(wave>=1)
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path2/ukhls_sampled_health_re.dta", replace
	
* Alternative sample E with incomplete cases
	use "$path8/ukhls_sample_step3_ages.dta", clear
	// 5e. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	// 6e. Balanced panel
	bysort pidp: egen wavenum = sum(wave>=1)
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path2/ukhls_samplee_incomplete.dta", replace
	
* Sample F: 16-64, health_re, incomplete
	use "$path8/ukhls_sample_step2_covid.dta", clear
	// 3f. age criterion
	keep if age<=64
	bysort pidp: keep if age>=16
	tab age
	list pidp wave age in 1/100
	xtsum pidp
	// 5f. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	// 6f. Balanced panel
	bysort pidp: egen wavenum = sum(wave>=1)
	gen balanced = 1 if wavenum==10
	tab wavenum if balanced==1
	keep if balanced==1
	xtsum pidp
	save "$path2/ukhls_samplef_maximum.dta", replace
	
* Sample G: 16-64, WLD, complete, unbalanced
	use "$path8/ukhls_sample_step2_covid.dta", clear
	// 3g. age criterion
	keep if age<=64
	bysort pidp: keep if age>=16
	tab age
	list pidp wave age in 1/100
	xtsum pidp
	// 4g. Keep only complete cases
	keep if !missing(wld_any, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	xtsum pidp
	// 5g. Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	xtsum pidp
	save "$path2/ukhls_sampleg_unbalanced.dta", replace
	

* Sample H: 16-64, WLD, complete, balanced from wave 2
	use "$path8/ukhls_sample_step2_covid.dta", clear
	xtset pidp wave
	xtdes
	xtsum pidp
	// remove wave 1
	keep if wave>1
	// ages
	keep if age<=64
	bysort pidp: keep if age>=16
	// complete cases
	keep if !missing(wld_any, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	// in employment
	bysort pidp: egen everemp = max(employed)
	keep if everemp==1
	// balanced
	bysort pidp: egen wavenum = sum(wave>=2)
	gen balanced2 = 1 if wavenum==9
	tab wavenum if balanced2==1
	keep if balanced2==1
	xtsum pidp
	xtdescribe
	save "$path2/ukhls_sampleh_wave2.dta", replace
	
* Sample I: from wave 2, unbalanced
	use "$path8/ukhls_sample_step2_covid.dta", clear
	xtset pidp wave
	xtdes
	xtsum pidp
	// remove wave 1
	keep if wave>1
	// ages
	keep if age<=64
	bysort pidp: keep if age>=16
	// complete cases
	keep if !missing(wld_any, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	// in employment
	bysort pidp: egen everemp = max(employed)
	keep if everemp==1
	xtsum pidp
	xtdescribe
	save "$path2/ukhls_samplei_wave2unbalanced.dta", replace

* Sample J: from wave 2, balanced, with health_re instead of WLD
	use  "$path8/ukhls_sample_step2_covid.dta", clear
	// remove wave 1
	keep if wave>1
	// relaxed age criterion
	keep if age<=64
	bysort pidp: keep if age>=16
	// Keep only complete cases with health_re
	keep if !missing(health_re, emploss, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec8_dv_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, jbsat_re, loghhinc, nkids_dv, howner, ghq2, healthsat)
	// Have been in employment at least once
	bysort pidp: egen everemp = max(employed)
	list pidp wave employed everemp in 1/50
	keep if everemp==1
	// balanced
	bysort pidp: egen wavenum = sum(wave>=2)
	gen balanced2 = 1 if wavenum==9
	tab wavenum if balanced2==1
	keep if balanced2==1
	xtsum pidp
	xtdescribe
	save "$path2/ukhls_samplej_wave2healthbalanced.dta", replace

*	No. of emploss transitions
*******************************

* Employment loss by WLD
	// sample A: complete cases and aged 25-54
	use "$path2/ukhls_samplea.dta", clear
	tabulate emploss wld_any, row mis
		
	// sample C: relaxing age criterion - 16-64
	use "$path2/ukhls_samplec_16_64.dta", clear
	tabulate emploss wld_any, row mis

* Sample D: With health_re instead of WLD and relaxing age criterion
	use "$path2/ukhls_sampled_health_re.dta", clear
	tabulate emploss health_re, row mis

* With sample E incomplete cases
	use "$path2/ukhls_samplee_incomplete.dta", clear
	tabulate emploss wld_any, row mis

* Sample F: Maximum possible sample
	use "$path2/ukhls_samplef_maximum.dta", clear
	tabulate emploss wld_any, row mis
	
* Sample G: unbalanced
	use "$path2/ukhls_sampleg_unbalanced.dta", clear
	tabulate emploss wld_any, row mis

* Sample H: balanced from wave 2
	use "$path2/ukhls_sampleh_wave2.dta", clear
	tabulate emploss wld_any, row mis
	
* Sample I: unbalanced from wave 2
	use "$path2/ukhls_samplei_wave2unbalanced.dta", clear
	tabulate emploss wld_any, row mis

* Sample J: balanced from wave 2 and using health_re
	use "$path2/ukhls_samplej_wave2healthbalanced.dta", clear
	tabulate emploss wld_any, row mis
*/
	
********************************************************************************
**# 					OPERATIONALISATION CHAPTER (5)
********************************************************************************

*-------------------------------------------------------------------------------
**# Create sample flag for 16-64
*-------------------------------------------------------------------------------

/* Sample criteria
	- from wave 1
	- excluding post covid
	- ages 16-64
	- complete for all disvars
	- both balanced & unbalanced
*/

use "$path2/ukhls_clean.dta", clear

* Step 1: Create inclusion cnditions for unbalanced sample

	* Full interview
	gen byte cond1 = (ivfio == 1 & scflag_dv == 1)

	* Pre-COVID restriction
	gen byte cond2 = !(intdaty_dv == 2020 & intdatm_dv > 2)

	* Age 16,64
	gen byte cond3 = inrange(age, 16, 64)

	* Complete cases on covariates (no ADL or employment variables included)
	gen byte cond4 = !missing( ///
    health, physical_amount, physical_kind, ///
    mental_amount, mental_care, pain_inter, wld_any_nopain, scghq2_dv, ///
    age, sex_dv, ethnic, mastat_re, howner, hiqual_dv, nkids_dv, loghhinc, ///
    employed, ///
    wave, gor_dv)
	
* Step 2: Create general unbalanced sample flags 
	// include wld and no-wld flags just in case they are useful later

	gen byte sample_16_64_u        = 0
	gen byte sample_16_64_u_wld    = 0
	gen byte sample_16_64_u_nowld  = 0

	replace sample_16_64_u       = 1 if cond1 & cond2 & cond3 & cond4
	replace sample_16_64_u_wld   = 1 if sample_16_64_u == 1 & wld_any_nopain == 1
	replace sample_16_64_u_nowld = 1 if sample_16_64_u == 1 & wld_any_nopain == 0

* Step 3: Create condition for balanced sample

	* Combine all core conditions at row level
	gen byte valid_obs_all = cond1 & cond2 & cond3 & cond4

	* Count number of waves where respondent meets all conditions
	egen wavecount_all = total(valid_obs_all), by(pidp)

	* Define Balanced Panel: Must meet all conditions in all 10 waves
	gen byte cond_balanced_all = (wavecount_all == 10)

	* Define final balanced panel sample flag (person-wave rows)
	gen byte sample_16_64_bal = (valid_obs_all == 1 & cond_balanced_all == 1)
	
	* Define flags for WLD and no WLD in the balanced panel
	gen byte sample_16_64_bal_wld 	= 0 
	gen byte sample_16_64_bal_nowld = 0
	
	replace sample_16_64_bal_wld 	= 1 if sample_16_64_bal == 1 & wld_any_nopain == 1
	replace sample_16_64_bal_nowld 	= 1 if sample_16_64_bal == 1 & wld_any_nopain == 0

* Step 4: Count sample sizes

 // In total
	count if sample_16_64_u == 1
	count if sample_16_64_bal == 1
	
 // cases & observations
	egen tag = tag(pidp)

	count if sample_16_64_u == 1 & tag
	count if sample_16_64_bal == 1 & tag

	drop tag
	
* Step 7: Clean up and Save

	drop cond1 cond2 cond3 cond4 valid_obs_all wavecount_all cond_balanced_all
	save "$path2/ukhls_clean.dta", replace
		

*-------------------------------------------------------------------------------
**# Construction of WLD
*-------------------------------------------------------------------------------

* WEIGHTED / balanced

	use "$path2/ukhls_clean.dta", clear

* Apply longitudinal weight from wave 1
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata)
	/* 	indsc: individual interview with self-completion questionnaire (as "lowest level")
	us includes GPS, EMB samples (but not BHPS or IEMB) */

/* Resources to export using esttab:
	- Ben Jann website https://repec.sowi.unibe.ch/stata/estout/estpost.html#h-2-10
	- Training from Connelly 2023 */

* Check estout already installed
	ssc install estout
	
* Simple frequency table of all 5 wld variables and resulting wld_any
**********************************************************************

* Physical and mental WLD variables
// specify balanced subpop

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate physical_amount, obs percent
	estadd scalar Observations = e(N_sub)
	est store physical_amount

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate physical_kind, obs percent
	estadd scalar Observations = e(N_sub)
	est store physical_kind

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate mental_amount, obs percent
	estadd scalar Observations = e(N_sub)
	est store mental_amount

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate mental_care, obs percent
	estadd scalar Observations = e(N_sub)
	est store mental_care

	esttab physical_amount physical_kind mental_amount mental_care ///
		using "$path6/ukhls_opchap_wldfreq.rtf", ///
		nostar unstack not ///
		b(%9.1f) ///
		stats(Observations, fmt(0) labels("Observations")) ///
		varlabels(`e(labels)') ///
		title("UKHLS: Percentages of the physical and mental impairment variables used to construct a WLD measure") ///
		addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Percentages are adjusted for survey design and non-response.") replace
	
* separate table for pain
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate pain_inter, obs percent
	estadd scalar Observations = e(N_sub)
	est store pain_inter
	
	esttab pain_inter ///
	using "$path6/ukhls_opchap_painfreq.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') ///
	title("UKHLS: Percentages of the pain variable used to construct a WLD measure") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
	
	
* 2x2 Table: Overlap between the (binary) effects of physical impairments
********************************************************************************
	
* Produce table & export		
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate physkind_re physamount_re, obs row percent
	estadd scalar Observations = e(N_sub)
	estimates store table_phys
	
	esttab table_phys using "$path6/ukhls_opchap_physoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Overlap between the effects of physical impairments") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
		
* 2x2 Table: Overlap between the effects of mental or emotional impairments 
**********************************************************************************
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate mencare_re menamount_re, obs row percent
	estadd scalar Observations = e(N_sub)
	estimates store table_men
	
	esttab table_men using "$path6/ukhls_opchap_menoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Overlap between the effects of mental impairments") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

* 2x2 table: Overlap between physical and mental WLD
*****************************************************

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_phys wld_men, obs row percent
	estadd scalar Observations = e(N_sub)
	estimates store table_phys_men
	
	esttab table_phys_men using "$path6/ukhls_opchap_physmenoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Overlap between the effects of physical and mental WLD") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace


* 3x2 table: overlap between wld_phys wld_men & wld_pain
*********************************************************
	
/* 3-way table - unweighted 
	// not for exporting
	// svy: does not support the 'table' command used for 3-way tables
	// try unweighted first as 
	table wld_phys wld_men wld_pain, stat(freq)
	table wld_phys wld_men wld_pain, stat(percent)
*/
	
* 3-way table (weighted)
	
	gen wld_interaction = 100*wld_phys + 10*wld_men + wld_pain
	
	label define wld_interaction_label ///
    0 "None" ///
    1 "Pain only" ///
    10 "Mental only" ///
    11 "Mental & Pain" ///
    100 "Physical only" ///
    101 "Physical & Pain" ///
    110 "Physical & Mental" ///
    111 "All three"
	
	label values wld_interaction wld_interaction_label
	
	estpost svy,  subpop(if sample_16_64_bal == 1): tabulate wld_interaction, obs percent 
	estadd scalar Observations = e(N_sub)
	est store wld3way

	esttab wld3way using "$path6/ukhls_opchap_wld3way_weighted.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Interaction between the 3 types of WLD as a percentage of the total sample") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
	
* Add any WLD manually to interaction table
	svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_pain, obs percent
	
* Any WLD without pain
	svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_nopain, obs percent

/* Venn diagram - unweighted 
	ssc install venndiag
	help venndiag
	
	venndiag wld_phys wld_men wld_pain // simple version with total N
	
	venndiag wld_phys wld_men wld_pain, show(l c p t f) ///
	t2title("UKHLS") ///
	t3title(n=10970) saving("$path7/ukhls_opchap_venn.png")
	// update N manually with each version
	// saved as stata graph as copies better into word (white background)
	// replace option not allowed but happens anyway
*/
	
*-------------------------------------------------------------------------------
* Comparison of WLD with other available measures
*-------------------------------------------------------------------------------
* Frequency of health
	svy, subpop(if sample_16_64_bal == 1): tabulate health_re, obs percent

* health * WLD including pain
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_pain health_re, obs percent row
	estadd scalar Observations = e(N_sub)
	est store health_wld
	
	esttab health_wld using "$path6/ukhls_opchap_health_wld.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Overlap between any WLD (incl. pain) and self-reported impairment") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

* health * WLD excluding pain

	estpost svy, subpop(if sample_16_64_bal == 1): ///
		tabulate wld_any_nopain health_re, obs percent row
	estadd scalar Observations = e(N_sub)
	est store health_wldnopain
	
	esttab health_wldnopain using "$path6/ukhls_opchap_health_wldnopain.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("UKHLS: Overlap between any WLD (excl. pain) and self-reported impairment") ///
	addnote("Note: UKHLS data; pooled waves 1-10; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

	

*-------------------------------------------------------------------------------
**# PREVALENCE
*-------------------------------------------------------------------------------

* 	Open clean data
	use "$path2/ukhls_clean.dta", clear
	
/* List of xsectweights:
wave 1: a_indscus_xw (excluding BHPS)
waves 2-5: w_inscub_xw, where w=b to e (including BHPS)
waves 6-10: w_inscui_xw where w=f to j (including IEMB)
*/

* Any WLD INCLUDING pain
**************************

* Loop over the survey waves and their corresponding weights using letters
foreach w in a b c d e f g h i j {
    
    * Preserve and prepare for filtering 
    preserve
    
    * Determine wave number correctly
    local wave = strpos("abcdefghij", "`w'")

    * Assign the correct weight variable based on the wave
    local wght
    if `wave' == 1 local wght = "a_indscus_xw"
    if `wave' == 2 local wght = "b_indscub_xw"
    if `wave' == 3 local wght = "c_indscub_xw"
    if `wave' == 4 local wght = "d_indscub_xw"
    if `wave' == 5 local wght = "e_indscub_xw"
    if `wave' == 6 local wght = "f_indscui_xw"
    if `wave' == 7 local wght = "g_indscui_xw"
    if `wave' == 8 local wght = "h_indscui_xw"
    if `wave' == 9 local wght = "i_indscui_xw"
    if `wave' == 10 local wght = "j_indscui_xw"
    
    * Filter data for the specific wave
    quietly keep if wave == `wave'
    
    * Set the survey design with the correct weight
	svyset, clear
    svyset psu [pweight=`wght'], strata(strata)
    
    * Calculate the survey-adjusted proportion for the unbalanced sub-sample
	// note this is WLD including pain
    estpost svy, subpop(if sample_16_64_u ==1): tabulate wld_any_pain, percent
    
    * Add subpop n as a scalar and store results
	estadd scalar Observations = e(N_sub)
    est store Wave`wave'
    
    * Restore the original dataset
    restore
}

* 	Check estimates stored correctly
	estimates dir

* Export table
	esttab Wave1 Wave2 Wave3 Wave4 Wave5 Wave6 Wave7 Wave8 Wave9 Wave10 ///
	using "$path6/ukhls_opchap_prevalence_wld.rtf", /// 
	unstack nostar not ///
    mlabels("Wave 1" "Wave 2" "Wave 3" "Wave 4" "Wave 5" "Wave 6" "Wave 7" "Wave 8" "Wave 9" "Wave 10") ///
    b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("UKHLS: Cross-sectional Prevalence of Any WLD including pain") ///
    addnote("Note: UKHLS data; waves 1-10; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design.") ///
	replace

* Export as an Excel table - so that I can transpose manually
	esttab Wave1 Wave2 Wave3 Wave4 Wave5 Wave6 Wave7 Wave8 Wave9 Wave10 ///
	using "$path6/ukhls_opchap_prevalence_wld.csv", /// 
	unstack nostar not ///
    mlabels("Wave 1" "Wave 2" "Wave 3" "Wave 4" "Wave 5" "Wave 6" "Wave 7" "Wave 8" "Wave 9" "Wave 10") ///
    b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("UKHLS: Cross-sectional Prevalence of Any WLD including pain") ///
    addnote("Note: UKHLS data; waves 1-10; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design. Missing standard errors because of stratum with single sampling unit") ///
	replace

* Any WLD EXCLUDING pain
**************************

* Loop over the survey waves and their corresponding weights using letters
	foreach w in a b c d e f g h i j {
    
		* Preserve and prepare for filtering 
		preserve
    
		* Determine wave number correctly
		local wave = strpos("abcdefghij", "`w'")

		* Assign the correct weight variable based on the wave
		local wght
		if `wave' == 1 local wght = "a_indscus_xw"
		if `wave' == 2 local wght = "b_indscub_xw"
		if `wave' == 3 local wght = "c_indscub_xw"
		if `wave' == 4 local wght = "d_indscub_xw"
		if `wave' == 5 local wght = "e_indscub_xw"
		if `wave' == 6 local wght = "f_indscui_xw"
		if `wave' == 7 local wght = "g_indscui_xw"
		if `wave' == 8 local wght = "h_indscui_xw"
		if `wave' == 9 local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"
		
		* Filter data for the specific wave
		quietly keep if wave == `wave'
		
		* Set the survey design with the correct weight
		svyset, clear
		svyset psu [pweight=`wght'], strata(strata)
		
		* Calculate the survey-adjusted proportion
		estpost svy, subpop(if sample_16_64_u ==1): tabulate wld_any_nopain, percent
		
		*Add subpop n as a scalar and store results with a unique name
		estadd scalar Observations = e(N_sub)
		estimates store Wave`wave'_np
		
		* Restore the original dataset
		restore
}

* 	Check estimates stored correctly
	estimates dir

* Export table
	esttab Wave1_np Wave2_np Wave3_np Wave4_np Wave5_np Wave6_np Wave7_np Wave8_np Wave9_np Wave10_np ///
	using "$path6/ukhls_opchap_prevalence_wld_np.rtf", /// 
	unstack nostar not ///
    mlabels("Wave 1" "Wave 2" "Wave 3" "Wave 4" "Wave 5" "Wave 6" "Wave 7" "Wave 8" "Wave 9" "Wave 10") ///
    b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("UKHLS: Cross-sectional Prevalence of Any WLD (excluding pain)") ///
    addnote("Note: UKHLS data; waves 1-10; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design and non-response.") ///
	replace

* Export as an Excel table - so that I can transpose manually
	esttab Wave1_np Wave2_np Wave3_np Wave4_np Wave5_np Wave6_np Wave7_np Wave8_np Wave9_np Wave10_np ///
	using "$path6/ukhls_opchap_prevalence_wld_np.csv", /// 
	unstack nostar not ///
    mlabels("Wave 1" "Wave 2" "Wave 3" "Wave 4" "Wave 5" "Wave 6" "Wave 7" "Wave 8" "Wave 9" "Wave 10") ///
    b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("UKHLS: Cross-sectional Prevalence of Any WLD (excluding pain)") ///
    addnote("Note: UKHLS data; waves 1-10; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design and non-response.") ///
	replace

* Health 
**********

* Loop over the survey waves and their corresponding weights using letters
	foreach w in a b c d e f g h i j {
    
		* Preserve and prepare for filtering 
		preserve
    
		* Determine wave number correctly
		local wave = strpos("abcdefghij", "`w'")

		* Assign the correct weight variable based on the wave
		local wght
		if `wave' == 1 local wght = "a_indscus_xw"
		if `wave' == 2 local wght = "b_indscub_xw"
		if `wave' == 3 local wght = "c_indscub_xw"
		if `wave' == 4 local wght = "d_indscub_xw"
		if `wave' == 5 local wght = "e_indscub_xw"
		if `wave' == 6 local wght = "f_indscui_xw"
		if `wave' == 7 local wght = "g_indscui_xw"
		if `wave' == 8 local wght = "h_indscui_xw"
		if `wave' == 9 local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"
		
		* Filter data for the specific wave
		quietly keep if wave == `wave'
		
		* Set the survey design with the correct weight
		svyset, clear
		svyset psu [pweight=`wght'], strata(strata)
		
		* Calculate the survey-adjusted proportion
		estpost svy, subpop(if sample_16_64_u ==1): tabulate health_re, percent
		
		*Add subpop n as a scalar and store results with a unique name
		estadd scalar Observations = e(N_sub)
		estimates store Wave`wave'_h
		
		* Restore the original dataset
		restore
}

* 	Check estimates stored correctly
	estimates dir

* Export as an Excel table - so that I can transpose manually
	esttab Wave1_h Wave2_h Wave3_h Wave4_h Wave5_h Wave6_h Wave7_h Wave8_h Wave9_h Wave10_h ///
	using "$path6/ukhls_opchap_prevalence_health.csv", /// 
	unstack nostar not ///
    mlabels("Wave 1" "Wave 2" "Wave 3" "Wave 4" "Wave 5" "Wave 6" "Wave 7" "Wave 8" "Wave 9" "Wave 10") ///
    b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("UKHLS: Cross-sectional Prevalence of self-reported impairment)") ///
    addnote("Note: UKHLS data; waves 1-10; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design. Missing standard errors because of stratum with single sampling unit") ///
	replace
*/

/* Using calendar years/quarters - have decided not worth 
// Trying to follow Kaminska and Lynn 2019; skip first step as Ive already merged my data, keeping the prefix on weights
* 2014
tab wave if intdaty_dv==2014 // check which waves include data from 2014 // waves 4,5 & 6
tab intdatm_dv wave if intdaty_dv==2014 // 2014 interviews in wave 4 were all at the start of the year, but maybe they were sampled in 2013?
tab month wave if intdaty_dv==2014 // 2014 interviews from wave 4 were all sampled in 2nd year
ge weight2014=0
HAVE DECIDED NOT WORTH IT
*/	

*-------------------------------------------------------------------------------
**# DYNAMICS - using wld_nopain
*-------------------------------------------------------------------------------

* Preparing data
******************

* Open clean data and apply longitudinal weight
	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata)
	
* Create sequence variables using sq package (Brzinsky-Fay et al 2006)
	
	* install sq package for sequence analysis http://fmwww.bc.edu/RePEc/bocode/s
	ssc install sq
	help sqset
	
	* Need to use balanced panel only for sqset to work well
	keep if sample_16_64_bal == 1
	
	* Declare to be sequence data
		// wld_any_nopain: element var (dummy) used to identify sequences
		// pidp: idvar
		// wave: order var - used to determine the order of sequences
	sqset wld_any_nopain pidp wave

	* Inspect patterns
	// 1306 sequences, which matches sample number of unique cases
	sqtab, ranks(1/10) 
	sqdes
	
	* Inspect structure of dataset after sqset
	count
	duplicates report pidp
	
	* Create vars for number of episodes, length of episodes & inspect
	
	help sqegen // need to type egen not sqegen
	
 	egen wldlength = sqlength(), element(1)
	egen wldepisodes = sqepicount(), element(1)	
	
	sqstatsum
	sqstattab1	
	
* Number of episodes
***********************

	* Use xttab and tabulate to describe and export tables
	sqset, clear
	xtset pidp wave

	* Episodes (including 0 episodes)
	estpost svy: tabulate wldepisodes, obs percent
	
	// Note this already shows number of episodes PER PERSON

	* Episodes (>1)
	estpost svy: tabulate wldepisodes if wldepisodes>=1, obs percent	
	est store episodesuk
	
	* mean no. of episodes per person
	svy: mean wldepisodes if wldepisodes>=1
	
	* Export UK table only
	
	/***** NB I have MANUALLY divided the N of the table by 10 when reporting, to 
	reflect the total number of respondents / sequences with at least 1 episode of WLD, 
	rather than the person-wave observations, since the variable wldepisodes has 
	the same value for all 10 observations per respondent ******/
	
	esttab episodesuk using "$path6/ukhls_opchap_wldepisodes.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') ///
	title("UKHKS: Number of episodes of any WLD (excluding pain) per person with WLD in at least one wave") ///
	addnote("Note: UKHLS (waves 1-10) and SOEP (2010-2019) data; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

	
/* Length of espisodes (using sq) - unclear about interpretation - alternative approach below
*********************************
	
* Mean length of episodes per person
	svy: mean wldlength if wldlength>=1
	
* Length (including 0)
	estpost svy: tabulate wldlength, obs percent

* Length (>1)
	estpost svy: tabulate wldlength if wldlength>=1, obs percent
	est store lengthuk

* Resolving some doubts on interpretation:

* is it max length per person, if they have more than one episode, or the mean?
	// Create specific vars for max and mean
	bysort pidp: egen max_length = max(wldlength)
	bysort pidp: egen mean_length = mean(wldlength)
	
	estpost svy: tabulate max_length if wldlength>=1, obs percent
	estpost svy: tabulate mean_length if wldlength>=1, obs percent
	
	// identical - inspect a few cases

	list pidp wave wld_any_nopain wldlength max_length mean_length in 1/100, compress
	
	list wave wld_any_nopain wldepisodes wldlength if pidp==68072087
	
	/* pidp=68072087:
	- no. of episodes: 3 - correct 
	- max length: 8 - incorrect. Should be 4, is number of observations where wld=1
	*/
*/

* Maximum consecutive WLD episode length (manually)
****************************************************

* Open clean data and apply longitudinal weight
	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata)

* Keep only balanced panel
	keep if sample_16_64_bal == 1

* Make sure data is sorted
	sort pidp wave

* Running length of current WLD episode
	by pidp: gen run_length = .

	by pidp: replace run_length = ///
		cond(wld_any_nopain == 1, ///
			 cond(_n == 1, 1, ///
				  cond(wld_any_nopain[_n-1] == 1, run_length[_n-1] + 1, 1)), ///
			 0)

* Maximum episode length for each respondent
	by pidp: egen max_ep_length = max(run_length)

* Inspect
	list pidp wave wld_any_nopain run_length max_ep_length in 1/50
	// looks ok
	
* Table of maximum episode length per person
	estpost svy: tabulate max_ep_length if max_ep_length>=1, obs percent
	est store maxuk

* Export UK only table, combine manually
	esttab maxuk using "$path6/ukhls_opchap_wldmaxlength.rtf", ///
		nostar nostar unstack not ///
		b(%9.1f) ///
		varlabels(`e(labels)') eqlabels(`e(eqlabels)') ///
		title("UKHLS: Maximum length of episodes of any WLD per person with at least one episode of WLD") ///
		addnote("Note: UKHLS (waves 1-10) and SOEP (2010-2019) data; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace	
		
*-------------------------------------------------------------------------------
**# Socio-demographic and employment characteristics
*-------------------------------------------------------------------------------		

* Open clean data and apply longitudinal weight
	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

* WLD (no pain) for UK/DE comparison
*************************************

// Using balanced WLD sample

	collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal_wld == 1) ///
		factor(sex_dv mastat_re howner degree employed, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		name(wld_uk)

	collect label levels result wld_uk "WLD UK"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal_wld == 1
	local subN = r(N)

	collect title "Balanced UKHLS sample (WLD only), Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/ukhls_opchap_bal_wld_descriptives.docx", ///
    as(docx) replace

* Comparing across dismeasures within UK (for book chapter/ thesis appendix)
*****************************************

* UK data & weights 
	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)
	
* WLD excluding pain

// adding ethnicity variable for UK-only table

	collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal_wld == 1) ///
		factor(sex_dv ethnic mastat_re howner degree employed, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		name(wld_uk)

	collect label levels result wld_uk "WLD UK"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal_wld == 1
	local subN = r(N)

	collect title "WLD (no pain); balanced UKHLS sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/ukhls_opchap_chars_for_comparison_wld.docx", ///
    as(docx) replace
	
* Long-standing impairment

	collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal == 1 & health_re ==1) ///
		factor(sex_dv ethnic mastat_re howner degree employed, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		name(health_uk)

	collect label levels result health_uk "Long-standing impairment UK"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal == 1 & health_re == 1
	local subN = r(N)

	collect title "Long-standing impairment; balanced UKHLS sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/ukhls_opchap_chars_for_comparison_health.docx", ///
    as(docx) replace
	
* Impairment + activity limitation (my "Equality Act" measure)

collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal == 1 & eadis ==1) ///
		factor(sex_dv ethnic mastat_re howner degree employed, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		name(eadis_uk)

	collect label levels result eadis_uk "Impairment & activity limitation"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal == 1 & eadis == 1
	local subN = r(N)

	collect title "Impairment & activity limitation; balanced UKHLS sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/ukhls_opchap_chars_for_comparison_eadis.docx", ///
    as(docx) replace
	

*-------------------------------------------------------------------------------
**# Prevalence-adjusted WLD employment gap over time
*-------------------------------------------------------------------------------

/* List of xsectweights:
wave 1: a_indscus_xw (excluding BHPS)
waves 2-5: w_inscub_xw, where w=b to e (including BHPS)
waves 6-10: w_inscui_xw where w=f to j (including IEMB)
*/

* Weighted conventional DEG by WLD
*************************************

// without SEs - see version below

use "$path2/ukhls_clean.dta", clear

* Build matrix
matrix empgap = J(10, 4, .)

foreach w in a b c d e f g h i j {

    preserve

    local wave = strpos("abcdefghij", "`w'")

    local wght
    if `wave' == 1 local wght = "a_indscus_xw"
    if `wave' == 2 local wght = "b_indscub_xw"
    if `wave' == 3 local wght = "c_indscub_xw"
    if `wave' == 4 local wght = "d_indscub_xw"
    if `wave' == 5 local wght = "e_indscub_xw"
    if `wave' == 6 local wght = "f_indscui_xw"
    if `wave' == 7 local wght = "g_indscui_xw"
    if `wave' == 8 local wght = "h_indscui_xw"
    if `wave' == 9 local wght = "i_indscui_xw"
    if `wave' == 10 local wght = "j_indscui_xw"

    quietly keep if wave == `wave'

    svyset, clear
    svyset psu [pweight=`wght'], strata(strata) singleunit(centered)

    * Get WLD employment
    svy, subpop(if sample_16_64_u_wld == 1): mean employed
    matrix b = e(b)
    scalar p_wld = b[1,1]

    * Get no-WLD employment
    svy, subpop(if sample_16_64_u_nowld == 1): mean employed
    matrix b = e(b)
    scalar p_nowld = b[1,1]

    scalar gap = p_nowld - p_wld

    count if !missing(employed, wld_any_nopain)
    scalar N = r(N)

    matrix empgap[`wave', 1] = 100 * p_wld
    matrix empgap[`wave', 2] = 100 * p_nowld
    matrix empgap[`wave', 3] = 100 * gap
    matrix empgap[`wave', 4] = floor(N)

    restore
}

matrix colnames empgap = Employed_WLD Employed_NoWLD Gap N
matrix rownames empgap = Wave1 Wave2 Wave3 Wave4 Wave5 Wave6 Wave7 Wave8 Wave9 Wave10

mat list empgap, format(%9.1f)

* Export using esttab
	esttab matrix(empgap) using "$path6/ukhls_opchap_conventional_employment_gap.rtf", ///
	title("UKHLS: Employment Rate and Gap by WLD Status") ///
	cell("fmt(%9.1f)") ///
	addnote("Note: UKHLS data; unbalanced sample aged 16-64 with complete cases. Weighted using cross-sectional weights. Percentages are adjusted for survey design and non-response.") ///
	replace

* Prevalence-adjusted gap reported alongside conventional one
****************************************************************

	use "$path2/ukhls_clean.dta", clear

	* Build matrix
	matrix empgap = J(10, 6, .)

	foreach w in a b c d e f g h i j {

		preserve

		local wave = strpos("abcdefghij", "`w'")

		local wght
		if `wave' == 1 local wght = "a_indscus_xw"
		if `wave' == 2 local wght = "b_indscub_xw"
		if `wave' == 3 local wght = "c_indscub_xw"
		if `wave' == 4 local wght = "d_indscub_xw"
		if `wave' == 5 local wght = "e_indscub_xw"
		if `wave' == 6 local wght = "f_indscui_xw"
		if `wave' == 7 local wght = "g_indscui_xw"
		if `wave' == 8 local wght = "h_indscui_xw"
		if `wave' == 9 local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		keep if wave == `wave'

		svyset, clear
		svyset psu [pweight=`wght'], strata(strata) singleunit(centered)

		* Employment rate among WLD
		svy, subpop(if sample_16_64_u_wld == 1): mean employed
		matrix b = e(b)
		scalar p_wld = b[1,1]

		* Employment rate among non-WLD
		svy, subpop(if sample_16_64_u_nowld == 1): mean employed
		matrix b = e(b)
		scalar p_nowld = b[1,1]

		* Overall WLD prevalence
		svy, subpop(if sample_16_64_u == 1): mean wld_any_nopain
		matrix b = e(b)
		scalar prev = b[1,1]

		* Conventional and prevalence-adjusted gaps
		scalar gap = p_nowld - p_wld
		scalar gap_adj = prev * gap

		count if sample_16_64_u == 1 & !missing(employed)
		scalar N = r(N)

		matrix empgap[`wave',1] = 100*p_wld
		matrix empgap[`wave',2] = 100*p_nowld
		matrix empgap[`wave',3] = 100*gap
		matrix empgap[`wave',4] = 100*prev
		matrix empgap[`wave',5] = 100*gap_adj
		matrix empgap[`wave',6] = N

		restore
	}

	matrix colnames empgap = ///
		Employed_WLD ///
		Employed_NoWLD ///
		Conventional_Gap ///
		WLD_Prevalence ///
		Prev_Adjusted_Gap ///
		N

	matrix rownames empgap = ///
		Wave1 Wave2 Wave3 Wave4 Wave5 ///
		Wave6 Wave7 Wave8 Wave9 Wave10

	mat list empgap, format(%9.1f)
	
	* Export to RTF
		esttab matrix(empgap) using ///
		"$path6/ukhls_opchap_conventional_and_adjusted_employment_gap.rtf", ///
		title("UKHLS: Employment Rates and Disability Employment Gaps") ///
		cell("fmt(%9.1f)") ///
		addnote("Weighted estimates using cross-sectional survey weights. Conventional gap = employment rate (non-WLD) minus employment rate (WLD). Prevalence-adjusted gap = conventional gap multiplied by annual WLD prevalence.") ///
		replace
	
	* Export as csv
	
	* Convert matrix to dataset
		clear
		svmat double empgap, names(col)

		* Create wave labels
		gen Wave = _n
		order Wave

		* Round to one decimal place
		foreach var of varlist Employed_WLD Employed_NoWLD Conventional_Gap ///
							WLD_Prevalence Prev_Adjusted_Gap {
			replace `var' = round(`var', 0.1)
		}

		* Export to CSV
		export delimited using ///
		"$path6/ukhls_opchap_conventional_and_adjusted_employment_gap.csv", ///
		replace

/* Conventional gap table with SEs
**********************************************
	use "$path2/ukhls_clean.dta", clear

* Load data

	matrix drop _all
	
	matrix empgap = J(10, 7, .)

	foreach w in a b c d e f g h i j {

		preserve

		local wave = strpos("abcdefghij", "`w'")

		local wght
		if `wave' == 1 local wght = "a_indscus_xw"
		if `wave' == 2 local wght = "b_indscub_xw"
		if `wave' == 3 local wght = "c_indscub_xw"
		if `wave' == 4 local wght = "d_indscub_xw"
		if `wave' == 5 local wght = "e_indscub_xw"
		if `wave' == 6 local wght = "f_indscui_xw"
		if `wave' == 7 local wght = "g_indscui_xw"
		if `wave' == 8 local wght = "h_indscui_xw"
		if `wave' == 9 local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		use "$path2/ukhls_clean.dta", clear
		keep if wave == `wave'

		svyset, clear
		svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

		* WLD group
		svy, subpop(if sample_16_64_u_wld == 1): mean employed
		matrix b1 = e(b)
		matrix V1 = e(V)
		scalar p_wld = b1[1,1]
		scalar se_wld = sqrt(V1[1,1])

		* No-WLD group
		svy, subpop(if sample_16_64_u_nowld == 1): mean employed
		matrix b2 = e(b)
		matrix V2 = e(V)
		scalar p_nowld = b2[1,1]
		scalar se_nowld = sqrt(V2[1,1])

		* Gap and SE of gap
		scalar gap = p_nowld - p_wld
		scalar se_gap = sqrt(V1[1,1] + V2[1,1])

		* Sample size
		count if inlist(1, sample_16_64_u_wld, sample_16_64_u_nowld)
		scalar N = r(N)

		* Store in matrix (scaled to percentage points)
		matrix empgap[`wave', 1] = 100 * p_wld
		matrix empgap[`wave', 2] = 100 * p_nowld
		matrix empgap[`wave', 3] = 100 * gap
		matrix empgap[`wave', 4] = floor(N)
		matrix empgap[`wave', 5] = 100 * se_wld
		matrix empgap[`wave', 6] = 100 * se_nowld
		matrix empgap[`wave', 7] = 100 * se_gap

		restore
	}

	matrix colnames empgap = Employed_WLD Employed_NoWLD Gap N SE_WLD SE_NoWLD SE_Gap
	matrix rownames empgap = Wave1 Wave2 Wave3 Wave4 Wave5 Wave6 Wave7 Wave8 Wave9 Wave10

	mat list empgap

	* Round values to 1 decimal place (exclude N column)
	forvalues i = 1/10 {
		forvalues j = 1/3 {
			matrix empgap[`i', `j'] = round(empgap[`i', `j'], 0.1)
		}
		forvalues j = 5/7 {
			matrix empgap[`i', `j'] = round(empgap[`i', `j'], 0.1)
		}
	}

	mat list empgap

	* Reorder columns for export
	matrix empgap_reordered = J(10, 7, .)
	forvalues i = 1/10 {
		matrix empgap_reordered[`i', 1] = empgap[`i', 1]   // Employed_WLD
		matrix empgap_reordered[`i', 2] = empgap[`i', 5]   // SE_WLD
		matrix empgap_reordered[`i', 3] = empgap[`i', 2]   // Employed_NoWLD
		matrix empgap_reordered[`i', 4] = empgap[`i', 6]   // SE_NoWLD
		matrix empgap_reordered[`i', 5] = empgap[`i', 3]   // Gap
		matrix empgap_reordered[`i', 6] = empgap[`i', 7]   // SE_Gap
		matrix empgap_reordered[`i', 7] = empgap[`i', 4]   // N
	}

	matrix colnames empgap_reordered = Employed_WLD SE_WLD Employed_NoWLD SE_NoWLD Gap SE_Gap N
	matrix rownames empgap_reordered = Wave1 Wave2 Wave3 Wave4 Wave5 Wave6 Wave7 Wave8 Wave9 Wave10

	matlist empgap_reordered

	* Export to Word using esttab
	esttab matrix(empgap_reordered) using "$path6/ukhls_opchap_gap_conventional.rtf", ///
		replace title("UKHLS: Conventional Employment Gap by WLD Status") ///
		cell("fmt(%9.1f)") nonumber nomtitle ///
		addnote("Note: UKHLS data; unbalanced sample aged 16-64 with complete cases. Percentages are adjusted for survey design and non-response. The standard error for the gap was calculated as the square root of the sum of the variances of the two employment rate estimates.")
	

* Graph trend

	* Step 1: Convert matrix to dataset
	clear // this erases data from memory but not matrices, scalars or macros 
	svmat empgap_reordered, names(col)

	gen wave = _n
	label define wave_lbl 1 "Wave 1" 2 "Wave 2" 3 "Wave 3" 4 "Wave 4" 5 "Wave 5" 6 "Wave 6" ///
						  7 "Wave 7" 8 "Wave 8" 9 "Wave 9" 10 "Wave 10"
	label values wave wave_lbl
	
	* Step 2: Compute confidence intervals
	gen ci_low_wld = Employed_WLD - 1.96 * SE_WLD
	gen ci_high_wld = Employed_WLD + 1.96 * SE_WLD

	gen ci_low_nowld = Employed_NoWLD - 1.96 * SE_NoWLD
	gen ci_high_nowld = Employed_NoWLD + 1.96 * SE_NoWLD

	* Step 3: Graph with CIs
	twoway ///
	  (rcap ci_low_wld ci_high_wld wave, color(blue%50)) ///
	  (rcap ci_low_nowld ci_high_nowld wave, color(red%50)) ///
	  (connected Employed_WLD wave, sort msymbol(circle) lcolor(blue) mcolor(blue) lwidth(medthick) msize(medium)) ///
	  (connected Employed_NoWLD wave, sort msymbol(square) lcolor(red) mcolor(red) lwidth(medthick) msize(medium)), ///
	  legend(order(3 "WLD" 4 "No WLD") rows(1) position(6)) ///
	  ytitle("Employment rate (%)") ///
	  xtitle("UKHLS wave") ///
	  xlabel(1(1)10) ///
	  ylabel(30(10)90) ///
	  yscale(range(30 90)) ///
	  graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_emp_gap.png", width(2000) replace
*/

********************************************************************************
**# 					LM STRATIFICATION CHAPTER (6)
********************************************************************************

*-------------------------------------------------------------------------------
**# Create sample flags 25-59 & count sample sizes
*-------------------------------------------------------------------------------
use "$path2/ukhls_clean.dta", clear

**# Create unbalanced sample flags
*************************************

* Step 0: Load Data

use "$path2/ukhls_clean.dta", clear
matrix drop _all

* Step 1: Create Inclusion Conditions (Temporary Flags) - create each time

* Full interview
gen byte cond1 = (ivfio == 1 & scflag_dv == 1)

* Pre-COVID restriction
gen byte cond2 = !(intdaty_dv == 2020 & intdatm_dv > 2)

* Age 25–59
gen byte cond3 = inrange(age, 25, 59)

* Complete cases on covariates (no employment or outcomes)
gen byte cond4 = !missing(wld_any, wld_any_nopain, employed, wave, gor_dv, age, sex_dv, ethnic, ///
    mastat_re, hiqual_dv, jbnssec3_re, parttime, fixedterm, isic_agg, ///
    privcomp, jbsize_re, nkids_dv)

/* Step 2: Create General Unbalanced Sample Flag

gen byte sample_25_59_u        = 0
gen byte sample_25_59_u_wld    = 0
gen byte sample_25_59_u_nowld  = 0

replace sample_25_59_u       = 1 if cond1 & cond2 & cond3 & cond4
replace sample_25_59_u_wld   = 1 if sample_25_59_u == 1 & wld_any_nopain == 1
replace sample_25_59_u_nowld = 1 if sample_25_59_u == 1 & wld_any_nopain == 0

* Step 3: Create Employed Analytic Sample (with complete outcomes)

gen byte sample_25_59_emp_cc_u        = 0
gen byte sample_25_59_emp_cc_u_wld    = 0
gen byte sample_25_59_emp_cc_u_nowld  = 0

replace sample_25_59_emp_cc_u = 1 if sample_25_59_u == 1 & employed == 1 ///
    & !missing(prof, fulltime, permanent, smallcomp, pubsec, services)

replace sample_25_59_emp_cc_u_wld   = 1 if sample_25_59_emp_cc_u == 1 & wld_any_nopain == 1
replace sample_25_59_emp_cc_u_nowld = 1 if sample_25_59_emp_cc_u == 1 & wld_any_nopain == 0

* Step 4: Create Non-Employed Sample (no outcome restriction)

gen byte sample_25_59_nonemp_u        = 0
gen byte sample_25_59_nonemp_u_wld    = 0
gen byte sample_25_59_nonemp_u_nowld  = 0

replace sample_25_59_nonemp_u       = 1 if sample_25_59_u == 1 & employed == 0
replace sample_25_59_nonemp_u_wld   = 1 if sample_25_59_nonemp_u == 1 & wld_any_nopain == 1
replace sample_25_59_nonemp_u_nowld = 1 if sample_25_59_nonemp_u == 1 & wld_any_nopain == 0
*/

* Step 5: Diagnostics Table (Separate Block)

	matrix steps_unbal = J(12, 2, .)

	count
	matrix steps_unbal[1,1] = r(N)

	count if cond1
	matrix steps_unbal[2,1] = r(N)

	count if cond1 & cond2
	matrix steps_unbal[3,1] = r(N)

	count if cond1 & cond2 & cond3
	matrix steps_unbal[4,1] = r(N)

	count if cond1 & cond2 & cond3 & cond4
	matrix steps_unbal[5,1] = r(N)

	count if sample_25_59_u == 1
	matrix steps_unbal[6,1] = r(N)

	count if sample_25_59_emp_cc_u == 1
	matrix steps_unbal[7,1] = r(N)

	count if sample_25_59_nonemp_u == 1
	matrix steps_unbal[8,1] = r(N)

	count if sample_25_59_emp_cc_u_wld == 1
	matrix steps_unbal[9,1] = r(N)

	count if sample_25_59_emp_cc_u_nowld == 1
	matrix steps_unbal[10,1] = r(N)

	count if sample_25_59_nonemp_u_wld == 1
	matrix steps_unbal[11,1] = r(N)

	count if sample_25_59_nonemp_u_nowld == 1
	matrix steps_unbal[12,1] = r(N)

	forvalues i = 2/12 {
		matrix steps_unbal[`i',2] = steps_unbal[`i'-1,1] - steps_unbal[`i',1]
	}

	matrix rownames steps_unbal = "Original" "Condition1_FullInterview" "Condition2_PreCOVID" ///
		"Condition3_Age2559" "Condition4_CompleteCases" "Condition5_UnbalancedSample" ///
		"Final (sample_25_59_emp_cc_u)" "Final (sample_25_59_nonemp_u)" ///
		"Final (sample_25_59_emp_cc_u_wld)" "Final (sample_25_59_emp_cc_u_nowld)" ///
		"Final (sample_25_59_nonemp_u_wld)" "Final (sample_25_59_nonemp_u_nowld)"
	matrix colnames steps_unbal = Remaining Excluded

	putexcel set "$path6/ukhls_empsitchapt_25_59_unbalanced_sample_exclusions.xlsx", replace
	putexcel A1=matrix(steps_unbal), names

* Step 6: Unweighted Sample Counts by Wave

matrix sample_wave_n = J(10, 9, .)
forvalues w = 1/10 {
    count if wave == `w' & sample_25_59_u == 1
    matrix sample_wave_n[`w', 1] = r(N)
    count if wave == `w' & sample_25_59_u_wld == 1
    matrix sample_wave_n[`w', 2] = r(N)
    count if wave == `w' & sample_25_59_u_nowld == 1
    matrix sample_wave_n[`w', 3] = r(N)

    count if wave == `w' & sample_25_59_emp_cc_u == 1
    matrix sample_wave_n[`w', 4] = r(N)
    count if wave == `w' & sample_25_59_emp_cc_u_wld == 1
    matrix sample_wave_n[`w', 5] = r(N)
    count if wave == `w' & sample_25_59_emp_cc_u_nowld == 1
    matrix sample_wave_n[`w', 6] = r(N)

    count if wave == `w' & sample_25_59_nonemp_u == 1
    matrix sample_wave_n[`w', 7] = r(N)
    count if wave == `w' & sample_25_59_nonemp_u_wld == 1
    matrix sample_wave_n[`w', 8] = r(N)
    count if wave == `w' & sample_25_59_nonemp_u_nowld == 1
    matrix sample_wave_n[`w', 9] = r(N)
}

matrix rownames sample_wave_n = wave1 wave2 wave3 wave4 wave5 wave6 wave7 wave8 wave9 wave10
matrix colnames sample_wave_n = sample_25_59_u sample_25_59_u_wld sample_25_59_u_nowld ///
    sample_25_59_emp_cc_u sample_25_59_emp_cc_u_wld sample_25_59_emp_cc_u_nowld ///
    sample_25_59_nonemp_u sample_25_59_nonemp_u_wld sample_25_59_nonemp_u_nowld

putexcel set "$path6/ukhls_empsitchapt_25_59_unbalancedsample_counts_by_wave.xlsx", replace
putexcel A1=matrix(sample_wave_n), names

* Step 7: Clean up and Save

drop cond1 cond2 cond3 cond4
save "$path2/ukhls_clean.dta", replace


**# Create balanced Panel Sample Flags
****************************************
* Load dataset
use "$path2/ukhls_clean.dta", clear

* Drop any previous matrices
matrix drop _all

* Step 1: Define Core Conditions for Balanced Panel Universe (Person-level)

* Condition 1: Full productive interview + valid sample flag (no proxies)
gen byte cond1 = (ivfio == 1 & scflag_dv == 1)

* Condition 2: Exclude COVID-affected interviews (March 2020 onwards)
gen byte cond2 = !(intdaty_dv == 2020 & intdatm_dv > 2)

* Condition 3: Age between 25–59 (at wave level)
gen byte cond3 = inrange(age, 25, 59)

* Condition 4: Complete cases on core covariates (excluding outcome vars)
gen byte cond4 = !missing(wld_any, wld_any_nopain, employed, wave, gor_dv, age, sex, ethnic, ///
	mastat_re, hiqual_dv, jbnssec3_re, parttime, fixedterm, isic_agg, ///
	privcomp, jbsize_re, nkids_dv, degree)

* Combine all core conditions at row level
gen byte valid_obs_all = cond1 & cond2 & cond3 & cond4

* Count number of waves where respondent meets all conditions
egen wavecount_all = total(valid_obs_all), by(pidp)

* Define Balanced Panel: Must meet all conditions in all 10 waves
gen byte cond_balanced_all = (wavecount_all == 10)

/* Step 2: Analytic Sample Flags (Employed & Non-Employed) – Row-level Conditions

* Define final balanced panel sample flag (person-wave rows)
gen byte sample_25_59_bal = (valid_obs_all == 1 & cond_balanced_all == 1)

* WLD breakdowns within balanced sample
gen sample_25_59_bal_wld   = (sample_25_59_bal == 1 & wld_any_nopain == 1)
gen sample_25_59_bal_nowld = (sample_25_59_bal == 1 & wld_any_nopain == 0)

* Employed & Complete Cases on Outcomes (analytic sample for logistic models)
gen byte sample_25_59_bal_emp_cc = (sample_25_59_bal == 1 & employed == 1 ///
	& !missing(prof, fulltime, permanent, smallcomp, pubsec, services))

* Non-Employed (for descriptives): NO complete case restriction
gen byte sample_25_59_bal_nonemp = (sample_25_59_bal == 1 & employed == 0)

* WLD breakdowns of Employed Analytic Sample
gen sample_25_59_bal_emp_cc_wld   = (sample_25_59_bal_emp_cc == 1 & wld_any_nopain == 1)
gen sample_25_59_bal_emp_cc_nowld = (sample_25_59_bal_emp_cc == 1 & wld_any_nopain == 0)

* WLD breakdowns of Non-Employed Sample
gen sample_25_59_bal_nonemp_wld   = (sample_25_59_bal_nonemp == 1 & wld_any_nopain == 1)
gen sample_25_59_bal_nonemp_nowld = (sample_25_59_bal_nonemp == 1 & wld_any_nopain == 0)
*/
* Step 3: Diagnostics Table – Balanced Panel Sample Exclusions (UKHLS)

* Create 12×2 matrix
matrix steps_bal = J(12, 2, .)

* Fill in rows 1–12
count
matrix steps_bal[1,1] = r(N)

count if cond1
matrix steps_bal[2,1] = r(N)

count if cond1 & cond2
matrix steps_bal[3,1] = r(N)

count if cond1 & cond2 & cond3
matrix steps_bal[4,1] = r(N)

count if cond1 & cond2 & cond3 & cond4
matrix steps_bal[5,1] = r(N)

count if sample_25_59_bal == 1
matrix steps_bal[6,1] = r(N)

count if sample_25_59_bal_emp_cc == 1
matrix steps_bal[7,1] = r(N)

count if sample_25_59_bal_nonemp == 1
matrix steps_bal[8,1] = r(N)

count if sample_25_59_bal_emp_cc_wld == 1
matrix steps_bal[9,1] = r(N)

count if sample_25_59_bal_emp_cc_nowld == 1
matrix steps_bal[10,1] = r(N)

count if sample_25_59_bal_nonemp_wld == 1
matrix steps_bal[11,1] = r(N)

count if sample_25_59_bal_nonemp_nowld == 1
matrix steps_bal[12,1] = r(N)

* Now calculate exclusions
forvalues i = 2/12 {
    matrix steps_bal[`i',2] = steps_bal[`i'-1,1] - steps_bal[`i',1]
}

* Assign 12 row names
matrix rownames steps_bal = ///
    "Original" "Condition1_FullInterview" "Condition2_PreCOVID" "Condition3_Age2559" ///
    "Condition4_CompleteCases" "Condition5_BalancedPanel" ///
    "Final (sample_25_59_bal_emp_cc)" "Final (sample_25_59_bal_nonemp)" ///
    "Final (sample_25_59_bal_emp_cc_wld)" "Final (sample_25_59_bal_emp_cc_nowld)" ///
    "Final (sample_25_59_bal_nonemp_wld)" "Final (sample_25_59_bal_nonemp_nowld)"
matrix colnames steps_bal = Remaining Excluded

* Export
putexcel set "$path6/ukhls_empsitchapt_25_59_balanced_sample_exclusions.xlsx", replace
putexcel A1=matrix(steps_bal), names


* Step 4: Clean-up Temporary Variables

drop cond1 cond2 cond3 cond4 valid_obs_all wavecount_all cond_balanced_all

* Step 5: Save Dataset with Balanced Sample Flags

save "$path2/ukhls_clean.dta", replace

*-------------------------------------------------------------------------------
**# WLD and socio-demographic chars
*-------------------------------------------------------------------------------

* Wave 5 cross-sectional table
*********************************

	use "$path2/ukhls_clean.dta", clear

	* Step 1. Set survey design & restrict waves

	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	keep if wave==5

	* Step 2. Generate tables for each WLD × employment group

	collect clear

	* WLD employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_emp_cc_u_wld == 1) ///
		name(wld_emp1)

	collect label levels result wld_emp1 "WLD employed"

	* WLD not employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_nonemp_u_wld == 1) ///
		name(wld_emp2)

	collect label levels result wld_emp2 "WLD not employed"

	* No WLD employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_emp_cc_u_nowld == 1) ///
		name(wld_emp3)

	collect label levels result wld_emp3 "No WLD employed"

	* No WLD not employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_nonemp_u_nowld == 1) ///
		name(wld_emp4)

	collect label levels result wld_emp4 "No WLD not employed"


	* Step 3. Combine and format the table
	collect dims
	collect levelsof var

	collect combine wldemp = wld_emp1 wld_emp2 wld_emp3 wld_emp4

	* Label the four columns
	collect label levels collection wld_emp1 "WLD employed"
	collect label levels collection wld_emp2 "WLD not employed"
	collect label levels collection wld_emp3 "No WLD employed"
	collect label levels collection wld_emp4 "No WLD not employed"

	* Reorder variables (no _N)
	collect layout ///
		(var[age nkids_dv 1.sex 2.sex ///
			  1.ethnic 2.ethnic 3.ethnic ///
			  1.mastat_re 2.mastat_re 3.mastat_re ///
			  1.hiqual_dv 2.hiqual_dv 3.hiqual_dv 4.hiqual_dv 5.hiqual_dv 9.hiqual_dv]) ///
		(collection)

	* One decimal place
	collect style cell, nformat(%6.1f)

	* Title
	collect title "UKHLS wave 5: Characteristics by WLD and employment status"


	* Step 4. Add unweighted sample sizes to the note

	count if sample_25_59_emp_cc_u_wld == 1
	scalar n_wld_emp = r(N)

	count if sample_25_59_nonemp_u_wld == 1
	scalar n_wld_nonemp = r(N)

	count if sample_25_59_emp_cc_u_nowld == 1
	scalar n_nowld_emp = r(N)

	count if sample_25_59_nonemp_u_nowld == 1
	scalar n_nowld_nonemp = r(N)

	local note_text "Unweighted N: WLD employed = `=n_wld_emp'; WLD not employed = `=n_wld_nonemp'; No WLD employed = `=n_nowld_emp'; No WLD not employed = `=n_nowld_nonemp'"

	collect note "UKHLS wave 5 data; sample aged 25-59 with complete cases. Percentages are adjusted for survey design and non-response."
	collect note "`note_text'"

	* Step 5. Export to Word

	collect export "$path6/ukhls_empsitchapt_wldemp_chars_w5.docx", replace

* Pooled balanced table
************************

	* Step 1. Load data and set up

	use "$path2/ukhls_clean.dta", clear

	* Set survey design with longitudinal weight
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Step 2. Generate tables for each group

	collect clear

	* WLD employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_bal_emp_cc_wld == 1) ///
		name(wld_emp1)
	collect label levels result wld_emp1 "WLD employed"

	* WLD not employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_bal_nonemp_wld == 1) ///
		name(wld_emp2)
	collect label levels result wld_emp2 "WLD not employed"

	* No WLD employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_bal_emp_cc_nowld == 1) ///
		name(wld_emp3)
	collect label levels result wld_emp3 "No WLD employed"

	* No WLD not employed
	dtable, ///
		factor(sex ethnic mastat_re hiqual_dv, stat(fvpercent)) ///
		cont(age nkids_dv, stat(mean)) ///
		svy subpop(if sample_25_59_bal_nonemp_nowld == 1) ///
		name(wld_emp4)
	collect label levels result wld_emp4 "No WLD not employed"

	* Step 3. Combine and format table
	collect dims
	collect levelsof var

	collect combine wldemp = wld_emp1 wld_emp2 wld_emp3 wld_emp4

	* Label the four columns
	collect label levels collection wld_emp1 "WLD employed"
	collect label levels collection wld_emp2 "WLD not employed"
	collect label levels collection wld_emp3 "No WLD employed"
	collect label levels collection wld_emp4 "No WLD not employed"

	* Reorder variables (no _N)
	collect layout ///
		(var[age nkids_dv 1.sex 2.sex ///
			  1.ethnic 2.ethnic 3.ethnic ///
			  1.mastat_re 2.mastat_re 3.mastat_re ///
			  1.hiqual_dv 2.hiqual_dv 3.hiqual_dv 4.hiqual_dv 5.hiqual_dv 9.hiqual_dv]) ///
		(collection)

	* One decimal place
	collect style cell, nformat(%6.1f)

	* Title
	collect title "UKHLS pooled waves 1-10 balanced: Characteristics by WLD and employment status"

	* Step 4. Add unweighted sample sizes to note

	count if sample_25_59_bal_emp_cc_wld == 1
	scalar n_wld_emp = r(N)

	count if sample_25_59_bal_nonemp_wld == 1
	scalar n_wld_nonemp = r(N)

	count if sample_25_59_bal_emp_cc_nowld == 1
	scalar n_nowld_emp = r(N)

	count if sample_25_59_bal_nonemp_nowld == 1
	scalar n_nowld_nonemp = r(N)

	local note_text "Unweighted N: WLD employed = `=n_wld_emp'; WLD not employed = `=n_wld_nonemp'; No WLD employed = `=n_nowld_emp'; No WLD not employed = `=n_nowld_nonemp'"

	collect title "UKHLS (pooled, balanced sample): Characteristics by WLD and employment status"
	collect note "Weighted means and percentages; UKHLS waves 1–10, balanced panel aged 25–59. Longitudinal weights applied."
	collect note "`note_text'"

	* Step 5. Export to Word

	collect export "$path6/ukhls_empsitchapt_wldemp_chars_pooled.docx", replace


*-------------------------------------------------------------------------------
**# WLD and labour market segmentation: descriptive statistics
*-------------------------------------------------------------------------------

* Load dataset
	use "$path2/ukhls_clean.dta", clear
	
/* 
- Restrict to employed sub-samples
- List of xsectweights:
	wave 1: a_indscus_xw (excluding BHPS)
	waves 2-5: w_inscub_xw, where w=b to e (including BHPS)
	waves 6-10: w_inscui_xw where w=f to j (including IEMB)
*/

**# Tables of bivariate comparisons
*************************************
// Neither chi2 nor V are available from weighted results so running unweighted. 

* WAVE 5

* Step 0: Load data and restrict
use "$path2/ukhls_clean.dta", clear
keep if wave == 5 & sample_25_59_emp_cc_u == 1 & !missing(wld_any_nopain)

* Step 1: Define variables and rownames
local vars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
local rownames "jbnssec3_re" "parttime" "fixedterm" "jbsize_re" "privcomp" "isic_agg2"

* Step 2: Create results matrix (6 x 3)
matrix results = J(6, 3, .)
matrix rownames results = `rownames'
matrix colnames results = "Chi2" "P" "V"

* Step 3: Loop
local i = 1
foreach var of local vars {
    
    * Crosstab with Chi2 and Cramer's V
    if "`var'" == "isic_agg2" {
        tab wld_any_nopain `var' if inrange(`var', 1, 3), chi2 V
    }
    else {
        tab wld_any_nopain `var' if !missing(`var'), chi2 V
    }

    * Extract statistics
    matrix results[`i', 1] = r(chi2)
    matrix results[`i', 2] = r(p)
    matrix results[`i', 3] = r(CramersV)

    di "Done with `var'"
    local ++i
}

* Step 4: Export
putexcel set "$path6/ukhls_empsitchapt_e_bivariate_unweighted.xlsx", replace
putexcel A1 = matrix(results), names


* POOLED BALANCED (unweighted)

* Step 0: Load data and restrict
use "$path2/ukhls_clean.dta", clear
keep if sample_25_59_bal_emp_cc == 1 & !missing(wld_any_nopain)

* Step 1: Define variables and rownames
local vars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
local rownames "jbnssec3_re" "parttime" "fixedterm" "jbsize_re" "privcomp" "isic_agg2"

* Step 2: Create results matrix (6 x 3)
matrix results = J(6, 3, .)
matrix rownames results = `rownames'
matrix colnames results = "Chi2" "P" "V"

* Step 3: Loop
local i = 1
foreach var of local vars {
    
    * Crosstab with Chi2 and Cramer's V
    if "`var'" == "isic_agg2" {
        tab wld_any_nopain `var' if inrange(`var', 1, 3), chi2 V
    }
    else {
        tab wld_any_nopain `var' if !missing(`var'), chi2 V
    }

    * Extract statistics
    matrix results[`i', 1] = r(chi2)
    matrix results[`i', 2] = r(p)
    matrix results[`i', 3] = r(CramersV)

    di "Done with `var'"
    local ++i
}

* Step 4: Export
putexcel set "$path6/ukhls_empsitchapt_pooled_bivariate_unweighted.xlsx", replace
putexcel A1 = matrix(results), names


**# Social class: 3-class NSSEC
*********************************
	label list jbnssec3_re

	
	* ESeC cross-sectional graphs, waves 1-10
	
	foreach w in a b c d e f g h i j {

		local wave = strpos("abcdefghij", "`w'")
		di in green "Processing wave `wave' (`w')"

		* Load full dataset
		use "$path2/ukhls_clean.dta", clear
		keep if wave == `wave'

		* Assign correct weight variable
		local wght
		if `wave' == 1  local wght = "a_indscus_xw"
		if `wave' == 2  local wght = "b_indscub_xw"
		if `wave' == 3  local wght = "c_indscub_xw"
		if `wave' == 4  local wght = "d_indscub_xw"
		if `wave' == 5  local wght = "e_indscub_xw"
		if `wave' == 6  local wght = "f_indscui_xw"
		if `wave' == 7  local wght = "g_indscui_xw"
		if `wave' == 8  local wght = "h_indscui_xw"
		if `wave' == 9  local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

		* --- WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
			proportion jbnssec3_re if inrange(jbnssec3_re, 1, 3)
		if _rc != 0 {
			di in red "WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_wld = r(table)

		* --- No-WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
			proportion jbnssec3_re if inrange(jbnssec3_re, 1, 3)
		if _rc != 0 {
			di in red "No-WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_nowld = r(table)

		* Combine into graphing dataset
		clear
		set obs 6
		gen class = cond(_n <= 3, _n, _n - 3)
		gen wld   = cond(_n <= 3, 1, 0)

		gen prop = .
		gen se   = .
		forvalues i = 1/3 {
			replace prop = prop_wld[1,`i'] * 100 in `i'
			replace se   = prop_wld[2,`i'] * 100 in `i'
			replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
			replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
		}

		gen ci_low  = prop - 1.96 * se
		gen ci_high = prop + 1.96 * se

		* Assign grouped x positions: WLD left, No-WLD right
		gen xpos = .
		replace xpos = class - 0.15 if wld == 1
		replace xpos = class + 0.15 if wld == 0
		gen x  = xpos if wld == 1
		gen x2 = xpos if wld == 0

		* Label text and vertical positions
		gen wld_label     = round(prop)    if wld == 1
		gen nowld_label   = round(prop)    if wld == 0
		gen wld_label_y   = ci_high + 2    if wld == 1
		gen nowld_label_y = ci_high + 2    if wld == 0

		* Label values
		label define jbnssec3_lbl 1 "1. Mgmt & prof" 2 "2. Intermediate" 3 "3. Routine"
		label values class jbnssec3_lbl

		* Chart
		twoway ///
			(rcap ci_low ci_high x, lcolor(blue)) ///
			(bar prop x, barwidth(0.25) color(blue%70)) ///
			(scatter wld_label_y x, mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
			(rcap ci_low ci_high x2, lcolor(red)) ///
			(bar prop x2, barwidth(0.25) color(red%70)) ///
			(scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
			, ///
			xtitle("") ///
			ytitle("Percentage (%)") ///
			title("UKHLS Wave `wave': Socio-economic classification by WLD status") ///
			legend(order(2 "WLD" 5 "No-WLD") position(6)) ///
			xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
			ylabel(0(10)60, format(%4.0f)) ///
			yscale(range(0 60)) ///
			yline(0, lcolor(gs8)) ///
			graphregion(color(white))

		* Export figure
		graph export "$path7/`w'_ukhls_empsitchapt_nssec3_25_59.png", replace
	}

	* NSSEC3 POOLED BALANCED CHART
		
	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion jbnssec3_re if inrange(jbnssec3_re,1,3)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion jbnssec3_re if inrange(jbnssec3_re,1,3)
	matrix prop_nowld = r(table)

	* --- build the plotting dataset ---
	clear
	set obs 6
	gen class = cond(_n <= 3, _n, _n - 3)
	gen wld   = cond(_n <= 3, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop)    if wld == 1
	gen nowld_label   = round(prop)    if wld == 0
	gen wld_label_y   = ci_high + 2    if wld == 1
	gen nowld_label_y = ci_high + 2    if wld == 0

	label define jbnssec3_lbl 1 "1. Mgmt & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class jbnssec3_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Socio-economic classification by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	 ylabel(0(10)60, format(%4.0f)) yscale(range(0 60)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_nssec3_25_59.png", replace

**# PT employment
******************

* Part-time cross-sectional graphs, waves 1-10

foreach w in a b c d e f g h i j {

    local wave = strpos("abcdefghij", "`w'")
    di in green "Processing wave `wave' (`w')"

    * Load full dataset
    use "$path2/ukhls_clean.dta", clear
    keep if wave == `wave'

    * Assign correct weight variable
    local wght
    if `wave' == 1  local wght = "a_indscus_xw"
    if `wave' == 2  local wght = "b_indscub_xw"
    if `wave' == 3  local wght = "c_indscub_xw"
    if `wave' == 4  local wght = "d_indscub_xw"
    if `wave' == 5  local wght = "e_indscub_xw"
    if `wave' == 6  local wght = "f_indscui_xw"
    if `wave' == 7  local wght = "g_indscui_xw"
    if `wave' == 8  local wght = "h_indscui_xw"
    if `wave' == 9  local wght = "i_indscui_xw"
    if `wave' == 10 local wght = "j_indscui_xw"

    svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

    * --- WLD group ---
    capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
        proportion parttime if inrange(parttime, 1, 3)
    if _rc != 0 {
        di in red "WLD group failed for wave `wave'. Skipping."
        continue
    }
    matrix prop_wld = r(table)

    * --- No-WLD group ---
    capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
        proportion parttime if inrange(parttime, 1, 3)
    if _rc != 0 {
        di in red "No-WLD group failed for wave `wave'. Skipping."
        continue
    }
    matrix prop_nowld = r(table)

    * Combine into graphing dataset
    clear
    set obs 6
    gen class = cond(_n <= 3, _n, _n - 3)
    gen wld   = cond(_n <= 3, 1, 0)

    gen prop = .
    gen se   = .
    forvalues i = 1/3 {
        replace prop = prop_wld[1,`i'] * 100 in `i'
        replace se   = prop_wld[2,`i'] * 100 in `i'
        replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
        replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
    }

    gen ci_low  = prop - 1.96 * se
    gen ci_high = prop + 1.96 * se

    * Assign grouped x positions: WLD left, No-WLD right
    gen xpos = .
    replace xpos = class - 0.15 if wld == 1
    replace xpos = class + 0.15 if wld == 0
    gen x  = xpos if wld == 1
    gen x2 = xpos if wld == 0

    * Label text and vertical positions
    gen wld_label     = round(prop)    if wld == 1
    gen nowld_label   = round(prop)    if wld == 0
    gen wld_label_y   = ci_high + 2    if wld == 1
    gen nowld_label_y = ci_high + 2    if wld == 0

    * Value labels for categories
    label define parttime_lbl ///
        1 "Full-time (>=35h)" ///
        2 "Regular part-time (11–34h)" ///
        3 "Marginal part-time (<=10h)"
    label values class parttime_lbl

    * Chart
    twoway ///
        (rcap ci_low ci_high x,  lcolor(blue)) ///
        (bar  prop x,            barwidth(0.25) color(blue%70)) ///
        (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
        (rcap ci_low ci_high x2, lcolor(red)) ///
        (bar  prop x2,           barwidth(0.25) color(red%70)) ///
        (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
        , ///
        xtitle("") ///
        ytitle("Percentage (%)") ///
        title("UKHLS Wave `wave': Part-time employment by WLD status") ///
        legend(order(2 "WLD" 5 "No WLD") position(6)) ///
        xlabel(1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)", angle(0)) ///
        ylabel(0(10)80, format(%4.0f)) ///
        yscale(range(0 80)) ///
        yline(0, lcolor(gs8)) ///
        graphregion(color(white))

    * Export figure
    graph export "$path7/`w'_ukhls_empsitchapt_parttime_updated_25_59.png", replace
}

	* PARTTIME POOLED BALANCED CHART

	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion parttime if inrange(parttime,1,3)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion parttime if inrange(parttime,1,3)
	matrix prop_nowld = r(table)

	* --- build the plotting dataset ---
	clear
	set obs 6
	gen class = cond(_n <= 3, _n, _n - 3)
	gen wld   = cond(_n <= 3, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop)    if wld == 1
	gen nowld_label   = round(prop)    if wld == 0
	gen wld_label_y   = ci_high + 2    if wld == 1
	gen nowld_label_y = ci_high + 2    if wld == 0

	label define parttime_lbl ///
		1 "Full-time (>=35h)" ///
		2 "Regular part-time (11–34h)" ///
		3 "Marginal part-time (<=10h)"
	label values class parttime_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Part-time employment by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)", angle(0)) ///
	 ylabel(0(10)80, format(%4.0f)) yscale(range(0 80)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_parttime_25_59.png", replace


**# Fixed-term
*****************

* FIXED-TERM cross-sectional graphs, waves 1-10

foreach w in a b c d e f g h i j {

    local wave = strpos("abcdefghij", "`w'")
    di in green "Processing wave `wave' (`w')"

    * Load full dataset
    use "$path2/ukhls_clean.dta", clear
    keep if wave == `wave'

    * Assign correct weight variable
    local wght
    if `wave' == 1  local wght = "a_indscus_xw"
    if `wave' == 2  local wght = "b_indscub_xw"
    if `wave' == 3  local wght = "c_indscub_xw"
    if `wave' == 4  local wght = "d_indscub_xw"
    if `wave' == 5  local wght = "e_indscub_xw"
    if `wave' == 6  local wght = "f_indscui_xw"
    if `wave' == 7  local wght = "g_indscui_xw"
    if `wave' == 8  local wght = "h_indscui_xw"
    if `wave' == 9  local wght = "i_indscui_xw"
    if `wave' == 10 local wght = "j_indscui_xw"

    svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

    * --- WLD group ---
    capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
        proportion fixedterm if inrange(fixedterm, 1, 2)
    if _rc != 0 {
        di in red "WLD group failed for wave `wave'. Skipping."
        continue
    }
    matrix prop_wld = r(table)

    * --- No-WLD group ---
    capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
        proportion fixedterm if inrange(fixedterm, 1, 2)
    if _rc != 0 {
        di in red "No-WLD group failed for wave `wave'. Skipping."
        continue
    }
    matrix prop_nowld = r(table)

    * Combine into graphing dataset
    clear
    set obs 4
    gen class = cond(_n <= 2, _n, _n - 2)
    gen wld   = cond(_n <= 2, 1, 0)

    gen prop = .
    gen se   = .
    forvalues i = 1/2 {
        replace prop = prop_wld[1,`i'] * 100 in `i'
        replace se   = prop_wld[2,`i'] * 100 in `i'
        replace prop = prop_nowld[1,`i'] * 100 in `=`i'+2'
        replace se   = prop_nowld[2,`i'] * 100 in `=`i'+2'
    }

    gen ci_low  = prop - 1.96 * se
    gen ci_high = prop + 1.96 * se

    * Grouped x positions
    gen xpos = .
    replace xpos = class - 0.15 if wld == 1
    replace xpos = class + 0.15 if wld == 0
    gen x  = xpos if wld == 1
    gen x2 = xpos if wld == 0

    * Labels on bars
    gen wld_label     = round(prop) if wld == 1
    gen nowld_label   = round(prop) if wld == 0
    gen wld_label_y   = ci_high + 2 if wld == 1
    gen nowld_label_y = ci_high + 2 if wld == 0

    * Value labels
    label define fixedterm_lbl 1 "Permanent" 2 "Non-permanent"
    label values class fixedterm_lbl

    * Chart
    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red)) ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
      , ///
      xtitle("") ///
      ytitle("Percentage (%)") ///
      title("UKHLS Wave `wave': Fixed term employment by WLD status") ///
      legend(order(2 "WLD" 5 "No-WLD") position(6)) ///
      xlabel(1 "Permanent" 2 "Non-permanent", angle(0)) ///
      ylabel(0(10)100, format(%4.0f)) ///
      yscale(range(0 100)) ///
      yline(0, lcolor(gs8)) ///
      graphregion(color(white))

    graph export "$path7/`w'_ukhls_empsitchapt_fixedterm_25_59.png", replace
}

	* FIXED-TERM POOLED BALANCED CHART

	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_nowld = r(table)

	* Build plotting dataset (2 categories × 2 groups)
	clear
	set obs 4
	gen class = cond(_n <= 2, _n, _n - 2)
	gen wld   = cond(_n <= 2, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/2 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+2'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+2'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop) if wld == 1
	gen nowld_label   = round(prop) if wld == 0
	gen wld_label_y   = ci_high + 2 if wld == 1
	gen nowld_label_y = ci_high + 2 if wld == 0

	label define fixedterm_lbl 1 "Permanent" 2 "Non-permanent"
	label values class fixedterm_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Fixed term employment by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Permanent" 2 "Non-permanent", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_fixedterm_25_59.png", replace

**# Company size
*******************

	* COMPANY SIZE cross-sectional graphs, waves 1-10

	foreach w in a b c d e f g h i j {

		local wave = strpos("abcdefghij", "`w'")
		di in green "Processing wave `wave' (`w')"

		* Load full dataset
		use "$path2/ukhls_clean.dta", clear
		keep if wave == `wave'

		* Assign correct weight variable
		local wght
		if `wave' == 1  local wght = "a_indscus_xw"
		if `wave' == 2  local wght = "b_indscub_xw"
		if `wave' == 3  local wght = "c_indscub_xw"
		if `wave' == 4  local wght = "d_indscub_xw"
		if `wave' == 5  local wght = "e_indscub_xw"
		if `wave' == 6  local wght = "f_indscui_xw"
		if `wave' == 7  local wght = "g_indscui_xw"
		if `wave' == 8  local wght = "h_indscui_xw"
		if `wave' == 9  local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

		* --- WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
			proportion jbsize_re if inrange(jbsize_re, 1, 3)
		if _rc != 0 {
			di in red "WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_wld = r(table)

		* --- No-WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
			proportion jbsize_re if inrange(jbsize_re, 1, 3)
		if _rc != 0 {
			di in red "No-WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_nowld = r(table)

		* Combine into graphing dataset
		clear
		set obs 6
		gen class = cond(_n <= 3, _n, _n - 3)
		gen wld   = cond(_n <= 3, 1, 0)

		gen prop = .
		gen se   = .
		forvalues i = 1/3 {
			replace prop = prop_wld[1,`i'] * 100 in `i'
			replace se   = prop_wld[2,`i'] * 100 in `i'
			replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
			replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
		}

		gen ci_low  = prop - 1.96 * se
		gen ci_high = prop + 1.96 * se

		* Grouped x positions
		gen xpos = .
		replace xpos = class - 0.15 if wld == 1
		replace xpos = class + 0.15 if wld == 0
		gen x  = xpos if wld == 1
		gen x2 = xpos if wld == 0

		* Labels on bars
		gen wld_label     = round(prop) if wld == 1
		gen nowld_label   = round(prop) if wld == 0
		gen wld_label_y   = ci_high + 2 if wld == 1
		gen nowld_label_y = ci_high + 2 if wld == 0

		* Value labels
		label define jbsize_lbl 1 "<10 incl self-emp" 2 "11–200" 3 ">200"
		label values class jbsize_lbl

		* Chart
		twoway ///
		  (rcap ci_low ci_high x,  lcolor(blue)) ///
		  (bar  prop x,            barwidth(0.25) color(blue%70)) ///
		  (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
		  (rcap ci_low ci_high x2, lcolor(red)) ///
		  (bar  prop x2,           barwidth(0.25) color(red%70)) ///
		  (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
		  , ///
		  xtitle("") ///
		  ytitle("Percentage (%)") ///
		  title("UKHLS Wave `wave': Company size by WLD status") ///
		  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
		  xlabel(1 "<10 incl self-emp" 2 "11–200" 3 ">200", angle(0)) ///
		  ylabel(0(10)60, format(%4.0f)) ///
		  yscale(range(0 60)) ///
		  yline(0, lcolor(gs8)) ///
		  graphregion(color(white))

		graph export "$path7/`w'_ukhls_empsitchapt_jbsize_25_59.png", replace
	}

	* COMPANY SIZE POOLED BALANCED CHART

	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion jbsize_re if inrange(jbsize_re, 1, 3)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion jbsize_re if inrange(jbsize_re, 1, 3)
	matrix prop_nowld = r(table)

	* Build plotting dataset (3 categories × 2 groups)
	clear
	set obs 6
	gen class = cond(_n <= 3, _n, _n - 3)
	gen wld   = cond(_n <= 3, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop) if wld == 1
	gen nowld_label   = round(prop) if wld == 0
	gen wld_label_y   = ci_high + 2 if wld == 1
	gen nowld_label_y = ci_high + 2 if wld == 0

	label define jbsize_lbl 1 "<10 incl self-emp" 2 "11–200" 3 ">200"
	label values class jbsize_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Company size by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "<10 incl self-emp" 2 "11–200" 3 ">200", angle(0)) ///
	 ylabel(0(10)60, format(%4.0f)) yscale(range(0 60)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_jbsize_25_59.png", replace


**# Public sector
*******************

 * PRIVATE COMPANY cross-sectional graphs, waves 1-10

	foreach w in a b c d e f g h i j {

		local wave = strpos("abcdefghij", "`w'")
		di in green "Processing wave `wave' (`w')"

		* Load full dataset
		use "$path2/ukhls_clean.dta", clear
		keep if wave == `wave'

		* Assign correct weight variable
		local wght
		if `wave' == 1  local wght = "a_indscus_xw"
		if `wave' == 2  local wght = "b_indscub_xw"
		if `wave' == 3  local wght = "c_indscub_xw"
		if `wave' == 4  local wght = "d_indscub_xw"
		if `wave' == 5  local wght = "e_indscub_xw"
		if `wave' == 6  local wght = "f_indscui_xw"
		if `wave' == 7  local wght = "g_indscui_xw"
		if `wave' == 8  local wght = "h_indscui_xw"
		if `wave' == 9  local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

		* --- WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
			proportion privcomp if inrange(privcomp, 1, 2)
		if _rc != 0 {
			di in red "WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_wld = r(table)

		* --- No-WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
			proportion privcomp if inrange(privcomp, 1, 2)
		if _rc != 0 {
			di in red "No-WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_nowld = r(table)

		* Combine into graphing dataset
		clear
		set obs 4
		gen class = cond(_n <= 2, _n, _n - 2)
		gen wld   = cond(_n <= 2, 1, 0)

		gen prop = .
		gen se   = .
		forvalues i = 1/2 {
			replace prop = prop_wld[1,`i'] * 100 in `i'
			replace se   = prop_wld[2,`i'] * 100 in `i'
			replace prop = prop_nowld[1,`i'] * 100 in `=`i'+2'
			replace se   = prop_nowld[2,`i'] * 100 in `=`i'+2'
		}

		gen ci_low  = prop - 1.96 * se
		gen ci_high = prop + 1.96 * se

		* Grouped x positions
		gen xpos = .
		replace xpos = class - 0.15 if wld == 1
		replace xpos = class + 0.15 if wld == 0
		gen x  = xpos if wld == 1
		gen x2 = xpos if wld == 0

		* Labels on bars
		gen wld_label     = round(prop) if wld == 1
		gen nowld_label   = round(prop) if wld == 0
		gen wld_label_y   = ci_high + 2 if wld == 1
		gen nowld_label_y = ci_high + 2 if wld == 0

		* Value labels
		label define privcomp_lbl 1 "Private sector" 2 "Public/Third sector"
		label values class privcomp_lbl

		* Chart
		twoway ///
		  (rcap ci_low ci_high x,  lcolor(blue)) ///
		  (bar  prop x,            barwidth(0.25) color(blue%70)) ///
		  (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
		  (rcap ci_low ci_high x2, lcolor(red)) ///
		  (bar  prop x2,           barwidth(0.25) color(red%70)) ///
		  (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
		  , ///
		  xtitle("") ///
		  ytitle("Percentage (%)") ///
		  title("UKHLS Wave `wave': Company sector by WLD status") ///
		  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
		  xlabel(1 "Private sector" 2 "Public/Third sector", angle(0)) ///
		  ylabel(0(10)100, format(%4.0f)) ///
		  yscale(range(0 100)) ///
		  yline(0, lcolor(gs8)) ///
		  graphregion(color(white))

		graph export "$path7/`w'_ukhls_empsitchapt_privcomp_25_59.png", replace
	}

	* PRIVATE COMPANY POOLED BALANCED CHART

	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion privcomp if inrange(privcomp, 1, 2)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion privcomp if inrange(privcomp, 1, 2)
	matrix prop_nowld = r(table)

	* Build plotting dataset (2 categories × 2 groups)
	clear
	set obs 4
	gen class = cond(_n <= 2, _n, _n - 2)
	gen wld   = cond(_n <= 2, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/2 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+2'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+2'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop) if wld == 1
	gen nowld_label   = round(prop) if wld == 0
	gen wld_label_y   = ci_high + 2 if wld == 1
	gen nowld_label_y = ci_high + 2 if wld == 0

	label define privcomp_lbl 1 "Private sector" 2 "Public/Third sector"
	label values class privcomp_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Company sector by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Private sector" 2 "Public/Third sector", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_privcomp_25_59.png", replace
	
**# Industrial sector
***********************
* BROAD INDUSTRIAL SECTOR cross-sectional graphs, waves 1-10

	foreach w in a b c d e f g h i j {

		local wave = strpos("abcdefghij", "`w'")
		di in green "Processing wave `wave' (`w')"

		* Load full dataset
		use "$path2/ukhls_clean.dta", clear
		keep if wave == `wave'

		* Assign correct weight variable
		local wght
		if `wave' == 1  local wght = "a_indscus_xw"
		if `wave' == 2  local wght = "b_indscub_xw"
		if `wave' == 3  local wght = "c_indscub_xw"
		if `wave' == 4  local wght = "d_indscub_xw"
		if `wave' == 5  local wght = "e_indscub_xw"
		if `wave' == 6  local wght = "f_indscui_xw"
		if `wave' == 7  local wght = "g_indscui_xw"
		if `wave' == 8  local wght = "h_indscui_xw"
		if `wave' == 9  local wght = "i_indscui_xw"
		if `wave' == 10 local wght = "j_indscui_xw"

		svyset psu [pweight=`wght'], strata(strata) singleunit(scaled)

		* --- WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_wld == 1): ///
			proportion isic_agg2 if inrange(isic_agg2, 1, 3)
		if _rc != 0 {
			di in red "WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_wld = r(table)

		* --- No-WLD group ---
		capture noisily svy, subpop(if sample_25_59_emp_cc_u_nowld == 1): ///
			proportion isic_agg2 if inrange(isic_agg2, 1, 3)
		if _rc != 0 {
			di in red "No-WLD group failed for wave `wave'. Skipping."
			continue
		}
		matrix prop_nowld = r(table)

		* Combine into graphing dataset
		clear
		set obs 6
		gen class = cond(_n <= 3, _n, _n - 3)
		gen wld   = cond(_n <= 3, 1, 0)

		gen prop = .
		gen se   = .
		forvalues i = 1/3 {
			replace prop = prop_wld[1,`i'] * 100 in `i'
			replace se   = prop_wld[2,`i'] * 100 in `i'
			replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
			replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
		}

		gen ci_low  = prop - 1.96 * se
		gen ci_high = prop + 1.96 * se

		* Grouped x positions
		gen xpos = .
		replace xpos = class - 0.15 if wld == 1
		replace xpos = class + 0.15 if wld == 0
		gen x  = xpos if wld == 1
		gen x2 = xpos if wld == 0

		* Labels on bars
		gen wld_label     = round(prop) if wld == 1
		gen nowld_label   = round(prop) if wld == 0
		gen wld_label_y   = ci_high + 2 if wld == 1
		gen nowld_label_y = ci_high + 2 if wld == 0

		* Value labels
		label define isic_agg2_lbl ///
			1 "Agriculture, forestry, mining" ///
			2 "Industry" ///
			3 "Services"
		label values class isic_agg2_lbl

		* Chart
		twoway ///
		  (rcap ci_low ci_high x,  lcolor(blue)) ///
		  (bar  prop x,            barwidth(0.25) color(blue%70)) ///
		  (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
		  (rcap ci_low ci_high x2, lcolor(red)) ///
		  (bar  prop x2,           barwidth(0.25) color(red%70)) ///
		  (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
		  , ///
		  xtitle("") ///
		  ytitle("Percentage (%)") ///
		  title("UKHLS Wave `wave': Broad industrial sector by WLD status") ///
		  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
		  xlabel(1 "Agriculture, forestry, mining" 2 "Industry" 3 "Services", angle(0)) ///
		  ylabel(0(10)100, format(%4.0f)) ///
		  yscale(range(0 100)) ///
		  yline(0, lcolor(gs8)) ///
		  graphregion(color(white))

		graph export "$path7/`w'_ukhls_empsitchapt_isicagg2_25_59.png", replace
	}

* BROAD INDUSTRIAL SECTOR POOLED BALANCED CHART

	use "$path2/ukhls_clean.dta", clear
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion isic_agg2 if inrange(isic_agg2, 1, 3)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion isic_agg2 if inrange(isic_agg2, 1, 3)
	matrix prop_nowld = r(table)

	* Build plotting dataset (3 categories × 2 groups)
	clear
	set obs 6
	gen class = cond(_n <= 3, _n, _n - 3)
	gen wld   = cond(_n <= 3, 1, 0)

	gen prop = .
	gen se   = .
	forvalues i = 1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}

	gen ci_low  = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x  = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label     = round(prop) if wld == 1
	gen nowld_label   = round(prop) if wld == 0
	gen wld_label_y   = ci_high + 2 if wld == 1
	gen nowld_label_y = ci_high + 2 if wld == 0

	label define isic_agg2_lbl ///
		1 "Agriculture, forestry, mining" ///
		2 "Industry" ///
		3 "Services"
	label values class isic_agg2_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,            barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,           barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , xtitle("") ytitle("Percentage (%)") ///
	 title("UKHLS waves 1-10: Broad industrial sector by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Agriculture, forestry, mining" 2 "Industry" 3 "Services", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_empsitchapt_pooled_bal_isicagg2_25_59.png", replace
	
*-------------------------------------------------------------------------------
**# WLD and LM segmentation: logit models
*-------------------------------------------------------------------------------

/**# Data prep for models: recoding vars into dummies
******************************************************

use "$path2/ukhls_clean.dta", clear

* Social class: professional & managerial / other

	tab jbnssec3_re, mis
	recode jbnssec3_re (0 = .) (2 3 = 0 "Intermediate/routine") ///
		(1 = 1 "Management & professional"), gen(prof) label(prof_lb)
	numlabel, add
	label var prof "Management & professional"
	tab prof, mis
	
* Full-time

	tab parttime, mis
	recode parttime (0 = .) (1 = 1 "Full-time") (2 3 = 0 "Part-time"), ///
		gen(fulltime) label(fulltime_lb)
	numlabel, add
	label var fulltime "Full-time contract"
	tab fulltime, mis

* Permanent

	tab fixedterm, mis
	recode fixedterm (0 = .) (1 = 1 "Permanent") (2 = 0 "Fixed-term"), ///
		gen(permanent) label(fixedterm_lb)
	numlabel, add
	label var permanent "Permanent contract"
	tab permanent, mis

* Small company or self-employed
	
	tab jbsize_re, mis
	recode jbsize_re (0 = .) (1 = 1 "<10 or self-employed") (2 3 = 0 ">11"), ///
		gen(smallcomp) label(smallcomp_lb)
	numlabel, add
	label var smallcomp "Less than 10 employees or self-employed"
	tab smallcomp, mis
		
* Public sector
	tab privcomp, mis
	recode privcomp (0 = .) (1 = 0 "Private company") ///
		(2 = 1 "Public or third sector"), gen(pubsec) label(pubsec_lb)
	label var pubsec "Public or third sector"
	numlabel, add
	tab pubsec, mis
	
save "$path2/ukhls_clean.dta", replace

* Re-code education into dummy

	use "$path2/ukhls_clean.dta", clear

	tab hiqual_dv, mis
	recode hiqual_dv (1=1) (2/9=0) (.=.), gen(degree)
	tab degree, mis
	label var degree "Has a degree (recoded hiqual_dv)"
	
	save "$path2/ukhls_clean.dta", replace
	
* Services 

* services var created for Ch7 then used retrospectively here
*/

* Table of Ns:

	* Load UKHLS wave 5 data
	use "$path2/ukhls_clean.dta", clear
	keep if wave == 5

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	* Prepare matrix: 3 rows per outcome, 5 columns
	* 1 = WLD N, 2 = WLD %, 3 = No WLD N, 4 = No WLD %, 5 = Total N
	matrix drop _all
	matrix counts5 = J(18, 5, .)
	local rownames
	local r = 1

	foreach var of local outcomes {

		* Label row
		matrix counts5[`r',1] = .
		matrix counts5[`r',2] = .
		matrix counts5[`r',3] = .
		matrix counts5[`r',4] = .
		matrix counts5[`r',5] = .
		local rownames `rownames' "`var'"
		local ++r

		* ---------- Value = 1 ----------
		count if sample_25_59_emp_cc_u_wld   == 1 & `var' == 1
		local n_wld_1 = r(N)
		count if sample_25_59_emp_cc_u_nowld == 1 & `var' == 1
		local n_now_1 = r(N)
		count if sample_25_59_emp_cc_u       == 1 & `var' == 1
		local n_tot_1 = r(N)

		* Fill Ns
		matrix counts5[`r',1] = `n_wld_1'
		matrix counts5[`r',3] = `n_now_1'
		matrix counts5[`r',5] = `n_tot_1'

		* Row % across WLD vs No WLD
		scalar den1 = `n_wld_1' + `n_now_1'
		matrix counts5[`r',2] = cond(den1>0, 100*`n_wld_1'/den1, .)
		matrix counts5[`r',4] = cond(den1>0, 100*`n_now_1'/den1, .)

		local rownames `rownames' "  = 1"
		local ++r

		* ---------- Value = 0 ----------
		count if sample_25_59_emp_cc_u_wld   == 1 & `var' == 0
		local n_wld_0 = r(N)
		count if sample_25_59_emp_cc_u_nowld == 1 & `var' == 0
		local n_now_0 = r(N)
		count if sample_25_59_emp_cc_u       == 1 & `var' == 0
		local n_tot_0 = r(N)

		* Fill Ns
		matrix counts5[`r',1] = `n_wld_0'
		matrix counts5[`r',3] = `n_now_0'
		matrix counts5[`r',5] = `n_tot_0'

		* Row % across WLD vs No WLD
		scalar den0 = `n_wld_0' + `n_now_0'
		matrix counts5[`r',2] = cond(den0>0, 100*`n_wld_0'/den0, .)
		matrix counts5[`r',4] = cond(den0>0, 100*`n_now_0'/den0, .)

		local rownames `rownames' "  = 0"
		local ++r
	}

	* Row/column names
	matrix rownames counts5 = `rownames'
	matrix colnames counts5 = "WLD N" "WLD %" "No WLD N" "No WLD %" "Total N"

	* Export: ints for Ns, 1dp for %
	esttab matrix(counts5, fmt(0 1 0 1 0)) using ///
		"$path6/ukhls_empsitchapt_w5_regdvs_n_pct.rtf", ///
		replace rtf nonumber noobs nomtitle ///
		title("Unweighted Frequencies and Row Percentages – UKHLS Wave 5") ///
		note("Percentages are row % within WLD vs No WLD for each outcome value; totals are by sample.")

	* Export to Excel
	putexcel set "$path6/ukhls_empsitchapt_w5_regdvs_n_pct.xlsx", replace
	putexcel A1 = matrix(counts5), names

**# Exploratory models & diagnostics
***************************************

* Model comparison using Wald tests - does not include services model
*-------------------------------------

use "$path2/ukhls_clean.dta", clear

* Specify wave & apply weights
		keep if wave==5
		svyset, clear
		svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)

* Model 1: Professional

		* Basic model
		svy, subpop(sample_25_59_u): logistic prof wld_any_nopain
		
		* Full model
		svy, subpop(sample_25_59_u): logistic prof i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.hiqual_dv
		
		*Full model minus mastat_re
		svy, subpop(sample_25_59_u): logistic prof i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.hiqual_dv
		
			
	* Wald test for model GOF excluding one control at a time

			* Re-run the full model
			svy, subpop(sample_25_59_u): logistic prof i.wld_any_nopain age nkids_dv ///
				i.sex_dv i.ethnic i.mastat_re i.hiqual_dv

			* Initialize results matrix
			matrix wald_results = J(6, 2, .)

			* Sequential Wald tests for each control variable
			local row = 1

			test age
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)
			local ++row

			test nkids_dv
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)
			local ++row

			test 2.sex_dv
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)
			local ++row

			test 1.ethnic 2.ethnic
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)
			local ++row

			test 1.mastat_re 2.mastat_re
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)
			local ++row

			test 1.hiqual_dv 2.hiqual_dv 3.hiqual_dv 4.hiqual_dv 5.hiqual_dv 9.hiqual_dv
			matrix wald_results[`row', 1] = r(F)
			matrix wald_results[`row', 2] = r(p)

			* Label the matrix
			matrix rownames wald_results = age nkids_dv sex_dv ethnic mastat_re hiqual_dv
			matrix colnames wald_results = F_stat p_value

			* Display results
			matlist wald_results, format(%6.3f)

	* All 5 models + Wald tests

		* Define outcome variables
		local outcomes prof fulltime permanent smallcomp pubsec 

		* Define control variables for Wald tests (update as needed)
		local controls age nkids_dv 2.sex_dv ///
			1.ethnic 2.ethnic ///
			1.mastat_re 2.mastat_re ///
			1.hiqual_dv 2.hiqual_dv 3.hiqual_dv 4.hiqual_dv 5.hiqual_dv 9.hiqual_dv

		* Loop over outcomes
		foreach yvar in `outcomes' {
			
			di as green "Running model for `yvar'..."

			* Step 1: Run svy logistic model
			svy, subpop(sample_25_59_u): logistic `yvar' i.wld_any_nopain age nkids_dv ///
				i.sex_dv i.ethnic i.mastat_re i.hiqual_dv

			* Step 2: Run Wald tests and store results
			matrix wald_`yvar' = J(6, 2, .)
			local row = 1

			test age
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)
			local ++row

			test nkids_dv
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)
			local ++row

			test 2.sex_dv
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)
			local ++row

			test 1.ethnic 2.ethnic
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)
			local ++row

			test 1.mastat_re 2.mastat_re
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)
			local ++row

			test 1.hiqual_dv 2.hiqual_dv 3.hiqual_dv 4.hiqual_dv 5.hiqual_dv 9.hiqual_dv
			matrix wald_`yvar'[`row', 1] = r(F)
			matrix wald_`yvar'[`row', 2] = r(p)

			matrix rownames wald_`yvar' = age nkids_dv sex_dv ethnic mastat_re hiqual_dv
			matrix colnames wald_`yvar' = F_stat p_value

			di as text "Stored Wald results in matrix wald_`yvar'"
		}

		* Viewing result matrices
			matrix list wald_prof
			matrix list wald_fulltime
			matrix list wald_permanent
			matrix list wald_smallcomp
			matrix list wald_pubsec

* Pseudo-R2, AIC & BIC 
*-------------------------

// from unadjusted full models

* Cross-sectional wave 5 models

	* Load UKHLS Wave 5 data
	use "$path2/ukhls_clean.dta", clear
	keep if wave == 5

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	* Clear any previously stored models
	eststo clear

	* Loop over outcome variables
	foreach yvar of local outcomes {
		
		* Run unweighted logistic regression
		quietly logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree if sample_25_59_emp_cc_u == 1

		* Store the model using eststo
		eststo diag_`yvar'
	}

	* Export model fit statistics to RTF
	esttab using "$path6/ukhls_diagstats_w5_25_59.rtf", ///
		replace rtf ///
		scalars(r2_p aic bic) ///
		sfmt(3) ///
		title("Model Fit Statistics – Unweighted Models (UKHLS Wave 5)")

* Pooled models - not updated 

	* Load full UKHLS data
	use "$path2/ukhls_clean.dta", clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec

	* Clear any previously stored models
	eststo clear

	* Loop over outcome variables
	foreach yvar of local outcomes {
		
		* Run unweighted logistic regression
		quietly logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree if sample_25_59_bal_emp_cc == 1

		* Store the model using eststo
		eststo diag_`yvar'
	}

	* Export model fit statistics to RTF
	esttab using "$path6/ukhls_diagstats_pooled.rtf", ///
		replace rtf ///
		scalars(r2_p aic bic) ///
		sfmt(3) ///
		title("Model Fit Statistics – Unweighted Models (UKHLS Waves 1-10)")


	
* Multicollinearity
*--------------------

/* Using collin

* Install user-written collin package
net describe collin, from(https://stats.idre.ucla.edu/stat/stata/ado/analysis)
net install collin

/* Collin doesn't allow for factor vars, so these need to be turned into dummy
vars first: https://www.statalist.org/forums/forum/general-stata-discussion/general/1691359-how-to-estimate-multicollinearity-among-factor-variables-after-logit-regression?utm_source=chatgpt.com */

* Load data and restrict to relevant sample
use "$path2/ukhls_clean.dta", clear
keep if wave == 5 & sample_25_59_emp_cc_u == 1

* Define RHS variables
local contvars age nkids_dv
local catvars wld_any_nopain sex_dv ethnic mastat_re degree

* Step 1: Generate dummies for each categorical variable
foreach var of local catvars {
    tab `var', gen(d_`var')
}

ds d_*

* Step 2: identify the ref categories for each var (manually). 
// d_wld_any_nopain1 d_sex_dv1 d_ethnic1 d_mastat_re1 d_degree1

* Step 3: Run collin on continuous + dummy predictors (excluding reference categories)
collin age nkids_dv ///
	d_wld_any_nopain2 ///
	d_sex_dv2 ///
	d_ethnic2 d_ethnic3 ///
	d_mastat_re2 d_mastat_re3 ///
	d_degree2
*/

* Using estat vif after linear regression

	* Load data and restrict to relevant sample
	use "$path2/ukhls_clean.dta", clear
	keep if wave == 5 & sample_25_59_emp_cc_u == 1

	regress prof i.wld_any_nopain age nkids_dv i.sex_dv i.ethnic i.mastat_re
	estat vif


**# Final models for exporting & graphing
*******************************************

* Wave 5 with ORs & p values

	// with re-coded education var
	// also changing sample to only employed

	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model with correct subpopulation
		svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_w5_or_pvalues_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS wave 5 (Full Models)")
		

* Wave 5 predicted probs

	// with re-coded education var
	// changed sample to only employed
	// removing atmeans option
	
	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model
		quietly svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store subpopulation N *before* running margins
		scalar subpopN = e(N_sub)

		* Run margins (overwrites e())
		margins wld_any_nopain sex_dv ethnic mastat_re degree, post

		* Store margins results
		eststo `yvar'

		* Attach saved subpop N
		estadd scalar Observations = subpopN
	}

	* Export table
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_e_predprobs_noci_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities – UKHLS wave 5")
		


**# Pairwise comparison of predicted probs by WLD

* Load UKHLS wave 5 data
use "$path2/ukhls_clean.dta", clear
keep if wave == 5

* Set survey design
svyset, clear
svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)

* Define outcomes (UKHLS version: use pubsec, not pubsec_re)
local outcomes prof fulltime permanent smallcomp pubsec services

* Clear previous matrices and define new one
matrix drop _all
matrix predtable = J(6, 3, .)

* Loop counter
local i = 1

foreach yvar of local outcomes {

    display "****************************************************"
    display "Outcome: `yvar'"
    display "****************************************************"

    * Run full model
    quietly svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' ///
        i.wld_any_nopain age nkids_dv i.sex_dv i.ethnic ///
        i.mastat_re i.degree

    * Predicted probabilities by WLD status
    margins wld_any_nopain, predict(pr)

    * Extract and round predicted probs
    matrix M = r(b)
    scalar p_nowld = round(M[1,1], .001)    // WLD = 0 
    scalar p_wld   = round(M[1,2], .001)    // WLD = 1 
    scalar diff    = round(p_nowld - p_wld, .001)  // difference 

    * Store in matrix
    matrix predtable[`i',1] = p_wld
    matrix predtable[`i',2] = p_nowld
    matrix predtable[`i',3] = diff

    * Manual inspection of p-value
    pwcompare wld_any_nopain, effects post

    local ++i
}

* Label matrix
matrix rownames predtable = prof fulltime permanent smallcomp pubsec services
matrix colnames predtable = WLD NonWLD Diff

* Export to Word
esttab matrix(predtable) using "$path6/ukhls_empsitchapt_e_margins_25_59.rtf", ///
    replace rtf noobs ///
    title("Predicted Probabilities and Differences by WLD Status – UKHLS Wave 5") ///
    cells("WLD(fmt(2)) NonWLD(fmt(2)) Diff(fmt(3))")

*******************************
**# Ch6 Sensitivity analyses 
*******************************

* A. Time-frame: pooled balanced panel
*****************************************
	* OR table

	* Load data
	use "$path2/ukhls_clean.dta", clear

	* Set longitudinal survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run full pooled model using balanced panel
		svy, subpop(if sample_25_59_bal_emp_cc == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree
	
		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_pooled_or_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS waves 1-10 (Full model))")


* Pooled panel redicted probs table 

	* Load data
	use "$path2/ukhls_clean.dta", clear

	* Set longitudinal survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run full pooled model using balanced panel
		svy, subpop(if sample_25_59_bal_emp_cc == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store subpop N before margins (margins will overwrite e(N_sub))
		scalar subpopN = e(N_sub)

		* Predicted probabilities
		margins wld_any_nopain sex_dv ethnic mastat_re ///
			degree if sample_25_59_bal == 1 & inlist(degree, 1, 2, 3, 4, 5), post

		* Store margins results
		eststo `yvar'

		* Attach correct subpop N
		estadd scalar Observations = subpopN
	}

	* Export predicted probabilities table
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_pooled_predprobs_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2) star) ci(fmt(2) par("(" " " ")"))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities with 95% Confidence Intervals – UKHLS Pooled Balanced Panel (Waves 1–10)")

		
* B: removing education from models
*************************************

* Wave 5 with ORs & p values - NO EDUCATION
	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model with correct subpopulation
		svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re

		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_w5_or_pvalues_NOED_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS wave 5 (Without education)")
		
* Wave 5 predicted probs - NO EDUCATION

	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model
		quietly svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re 

		* Store subpopulation N *before* running margins
		scalar subpopN = e(N_sub)

		* Run margins (overwrites e())
		margins wld_any_nopain sex_dv ethnic mastat_re, post

		* Store margins results
		eststo `yvar'

		* Attach saved subpop N
		estadd scalar Observations = subpopN
	}

	* Export table
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_e_predprobs_noci_noed_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities – UKHLS wave 5 (no education)")	
		
* C. Changing the age range
*****************************

* Wave 5 ORs with 16-64 employed sample 

	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model with correct subpopulation
		svy, subpop(if sample_16_64_u == 1 & employed == 1): ///
		logistic `yvar' i.wld_any_nopain age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_w5_or_pvalues_16_64.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS wave 5, 16-64 ")

* D. Alternative measures of disability
****************************************

* Long-standing impairment 

	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model with correct subpopulation
		svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.health_re age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_w5_or_pvalues_25_59_health.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS wave 5 (Long-standing impairment)")
		
* Impairment and activity limitation

	* Load data & restrict to wave 5
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	
	* Svyset data
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec services

	foreach yvar of local outcomes {

		* Run model with correct subpopulation
		svy, subpop(if sample_25_59_emp_cc_u == 1): logistic `yvar' i.eadis age nkids_dv ///
			i.sex_dv i.ethnic i.mastat_re i.degree

		* Store model
		eststo `yvar'

		* Add subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export OR table with correct subpopulation Ns only
	esttab prof fulltime permanent smallcomp pubsec services using ///
		"$path6/ukhls_empsitchapt_w5_or_pvalues_25_59_eadis.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		gaps nobaselevels compress ///
		title("Odds Ratios – UKHLS wave 5 (Equality Act)")
		
****************************
**# Predicted probs graphs
*****************************
	// with re-coded education var
	// changed sample to only employed
	// removing atmeans option

	* Load data, specify wave and apply weights
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* PROF
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit prof i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree
	margins wld_any_nopain, post
	eststo prof

	* FULLTIME
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit fulltime i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree
	margins wld_any_nopain, post
	eststo fulltime

	* PERMANENT
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit permanent i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree
	margins wld_any_nopain, post
	eststo permanent

	* Check what is stored
	esttab prof, se // same for all three models

	* Prof graph
	coefplot ///
		(prof, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(prof, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Professional or managerial class (full model)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_prof.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_prof.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_prof.png", width(2000) replace
	
	
	* Full-time graph
	coefplot ///
		(fulltime, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(fulltime, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Full-time employment (full model)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_fulltime.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_fulltime.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_fulltime.png", width(2000) replace
	
	* Permanent graph
	coefplot ///
		(permanent, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(permanent, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Permanent employment (full model)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_permanent.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_permanent.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_permanent.png", width(2000) replace

**# Predicted probabilities graphs (no education)

	* Load data, specify wave and apply weights
	use "$path2/ukhls_clean.dta", clear
	keep if wave==5
	svyset, clear
	svyset psu [pweight=e_indscub_xw], strata(strata) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* PROF
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit prof i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re
	margins wld_any_nopain, post
	eststo prof_noed

	* FULLTIME
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit fulltime i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re
	margins wld_any_nopain, post
	eststo fulltime_noed

	* PERMANENT
	svy, subpop(if sample_25_59_emp_cc_u == 1): logit permanent i.wld_any_nopain age nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re
	margins wld_any_nopain, post
	eststo permanent_noed

	* Check what is stored
	esttab prof_noed, se

	* Prof graph (noed)
	coefplot ///
		(prof_noed, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(prof_noed, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Professional or managerial class (no education)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_prof_noed.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_prof_noed.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_prof_noed.png", width(2000) replace

	* Full-time graph (noed)
	coefplot ///
		(fulltime_noed, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(fulltime_noed, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Full-time employment (no education)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_fulltime_noed.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_fulltime_noed.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_fulltime_noed.png", width(2000) replace

	* Permanent graph (noed)
	coefplot ///
		(permanent_noed, keep(0.wld_any_nopain) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(permanent_noed, keep(1.wld_any_nopain) ///
			label("WLD") ///
			mcolor(blue) msymbol(0) ///
			ciopts(recast(rcap) color(blue%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "No WLD" 2 "WLD", labsize(small)) ///
		xscale(range(0.5 2.5)) ///
		ylabel(, angle(horizontal)) ///
		title("UKHLS Wave 5 - Permanent employment (no education)") ///
		legend(off) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob_permanent_noed.gph", replace)

	graph use "$path7/w5_ukhls_empsitchapt_predprob_permanent_noed.gph"
	graph export "$path7/e_ukhls_empsitchapt_predprob_permanent_noed.png", width(2000) replace


	/* Plot graph with WLD predprobs from the three models 
	coefplot ///
		(prof,     keep(0.wld_any_nopain) label("Professional – No WLD")   msymbol(O) mcolor(red)  ciopts(color(red%50))) ///
		(prof,     keep(1.wld_any_nopain) label("Professional – WLD")      msymbol(D) mcolor(blue) ciopts(color(blue%50))) ///
		(fulltime, keep(0.wld_any_nopain) label("Full-time – No WLD")      msymbol(O) mcolor(red)  ciopts(color(red%50))) ///
		(fulltime, keep(1.wld_any_nopain) label("Full-time – WLD")         msymbol(D) mcolor(blue) ciopts(color(blue%50))) ///
		(permanent, keep(0.wld_any_nopain) label("Permanent – No WLD")     msymbol(O) mcolor(red)  ciopts(color(red%50))) ///
		(permanent, keep(1.wld_any_nopain) label("Permanent – WLD")        msymbol(D) mcolor(blue) ciopts(color(blue%50))), ///
		vertical ///
		ytitle("Predicted probability") ///
		xtitle("") ///
		xlabel(1 "Professional – No WLD" ///
			   2 "Professional – WLD" ///
			   3 "Full-time – No WLD" ///
			   4 "Full-time – WLD" ///
			   5 "Permanent – No WLD" ///
			   6 "Permanent – WLD", labsize(small) angle(45)) ///
		xscale(range(0.5 6.5)) ///
		ylabel(, angle(horizontal)) ///
		title("Predicted Probabilities by Disability Status – UKHLS Wave 5") ///
		legend(order(1 "No WLD" 2 "WLD") row(1)) ///
		saving("$path7/w5_ukhls_empsitchapt_predprob.gph", replace)

	*** attempt to plot all three outcomes together didn't work */
	

********************************************************************************
**# 					Ch7 EMPLOYMENT EXIT CHAPTER
********************************************************************************
*-------------------------------------------------------------------------------
**# Data prep
*-------------------------------------------------------------------------------

/* Creating the risk set (first attempt)
***************************************************
// anoched at time t-1

		use "$path2/ukhls_clean.dta", clear
		xtset pidp wave, yearly
		sort pidp wave
		assert !missing(wave, pidp)
		
		* 'consec' and 'atrisk' assumed already built as in your code:
		* consec = (wave == L.wave + 1)
		* atrisk = (L.employed == 1 & consec == 1)
		* sempl: 0=employee (not self-employed), 1=self-employed, .a=inapp, .=missing

		* 0) Build self-employment lag (t-1)
		capture drop sempl_lag
		gen sempl_lag = L.sempl if consec==1
		replace sempl_lag = . if atrisk!=1                // only meaningful within risk set
		label var sempl_lag "Self-employed (t-1 lag)"
		local sempl_lab : value label sempl
		if "`sempl_lab'" != "" label values sempl_lag `sempl_lab'

		* 1) Create lagged job-characteristics for employees only
		local lagvars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
		
		foreach v of local lagvars {
			capture drop `v'_lag
			gen `v'_lag = L.`v' if consec==1                      // take t-1 for adjacent pairs
			replace `v'_lag = . if atrisk!=1                      // outside risk set -> missing
			replace `v'_lag = . if sempl_lag!=0                   // EXCLUDE non-employees at t-1
			replace `v'_lag = . if `v'_lag==0 & sempl_lag==0      // 0=inapplicable at t-1 -> missing

			// carry over labels
			local vlabel : variable label `v'
			if "`vlabel'" != "" label var `v'_lag "`vlabel' (t-1 lag)"
			else                 label var `v'_lag "`v' (t-1 lag)"
			local vallab : value label `v'
			if "`vallab'" != "" label values `v'_lag `vallab'
		}

		* 2) Quick audit: how many at-risk rows are excluded by self-employment?
		quietly count if atrisk==1
		di as txt "At-risk total (all): " r(N)
		quietly count if atrisk==1 & sempl_lag!=0
		di as txt "Excluded by sempl_lag!=0: " r(N)

		* 3) Optional per-variable missing breakdown (diagnostics)
		local lagvars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
		foreach v of local lagvars {
			di as txt "== Missing `v'_lag among atrisk==1 =="
			quietly count if atrisk==1
			local N = r(N)
			quietly count if atrisk==1 & missing(`v'_lag)
			local Nmiss = r(N)
			quietly count if atrisk==1 & sempl_lag!=0
			local N_s = r(N)
			quietly count if atrisk==1 & sempl_lag==0 & L.`v'==0
			local N0 = r(N)
			quietly count if atrisk==1 & sempl_lag==0 & missing(L.`v')
			local Ndot = r(N)

			di as res "Total at-risk:                 " %9.0g `N'
			di as res "Missing `v'_lag (overall):     " %9.0g `Nmiss' " (" %5.1f 100*`Nmiss'/`N' "%)"
			di as res "  Due to sempl_lag!=0:         " %9.0g `N_s'
			di as res "  Among employees (sempl=0):"
			di as res "    0→. recode (L.`v'==0):     " %9.0g `N0'
			di as res "    item-missing (L.`v'==.):   " %9.0g `Ndot'
		}

		* 4) (Nice-to-have) assert: no non-missing lag outside employee risk set
		local lagvars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
		foreach v of local lagvars {
			assert missing(`v'_lag) if atrisk!=1 | sempl_lag!=0
		}

	save "$path2/ukhls_clean.dta", replace
	
	* Create a complete case flag on lagged vars
	**********************************************
	use  "$path2/ukhls_clean.dta", clear
	
	* Person-wave complete-case flag (employees-only risk set assumed)
	gen byte cc_lags = atrisk==1 & sempl_lag==0 ///
	  & !missing(jbnssec3_re_lag, parttime_lag, fixedterm_lag, jbsize_re_lag, privcomp_lag, isic_agg2_lag)

	* Among at-risk, count exits overall vs kept:
	quietly count if atrisk==1 & emploss==1
	di as res "Exits among all at-risk: " r(N)

	quietly count if atrisk==1 & emploss==1 & cc_lags==1
	di as res "Exits kept (complete lags): " r(N)

	quietly count if atrisk==1 & emploss==1 & cc_lags==0
	di as res "Exits dropped (incomplete lags): " r(N)
	
	save "$path2/ukhls_clean.dta", replace
*/

/* Creating the new risk set (2nd attempt)
******************************************
// anchored at time t but still includes inapplicable on employment vars

	use "$path2/ukhls_clean.dta", clear

	* Ensure panel is set
	xtset pidp wave, yearly
	sort pidp wave

	* 1. Forward-looking "consecutive waves" indicator: t and t+1
	capture drop F_wave consec_f
	gen F_wave   = F.wave
	gen consec_f = (F_wave == wave + 1)

	* 2. Baseline (t) and follow-up (t+1) variables for clarity
	capture drop emp_t emp_f sempl_t wld_t wld_f
	gen emp_t   = employed
	gen emp_f   = F.employed

	gen sempl_t = sempl          // self-employment status at baseline t
	gen wld_t   = wld_any_nopain // WLD at baseline t
	gen wld_f   = F.wld_any_nopain  // WLD at follow-up t+1

	* 3. Risk set at baseline t: 25–59, in sample, employed AND employee,
	*    with a valid consecutive follow-up and non-missing key vars
	capture drop risk_emp_t
	gen byte risk_emp_t = ///
		sample_25_59_u == 1 & /// in your main age/sample flag
		consec_f       == 1 & /// we observe t+1 and it is exactly next wave
		emp_t          == 1 & /// employed at baseline t
		sempl_t        == 0 & /// employee at baseline t (exclude self-employed)
		!missing(emp_f, wld_t, wld_f)
	label var risk_emp_t "Risk set: employees at t with follow-up at t+1"

	* 4. Define exit between t and t+1 using F.emploss
	capture drop exit_t1
	gen byte exit_t1 = .

	* Employment loss in the interval (t → t+1)
	replace exit_t1 = 1 if risk_emp_t == 1 & F.emploss == 1

	* Retained employment in the interval (t → t+1)
	replace exit_t1 = 0 if risk_emp_t == 1 & F.emploss == 0

	label define exit_t1 0 "Retained employment (t+1)" 1 "Employment loss (t+1)"
	label values exit_t1 exit_t1
	label var exit_t1 "Employment exit between t and t+1 (from F.emploss)"

	* 5. Enforce complete cases for baseline covariates at t
	*  The sample created earlier should already match this but double-check
	* (EDIT this list to match the planned model)
	local ccvars ///
		wld_any_nopain /// WLD at t (already checked above, but harmless to include)
		wave 			///
		gor_dv			///
		jbnssec3_re    ///
		parttime       ///
		fixedterm      ///
		jbsize_re      ///
		privcomp       ///
		isic_agg2      ///
		age            ///
		nkids_dv       ///
		sex_dv         ///
		mastat_re      ///
		degree

	foreach v of local ccvars {
		replace risk_emp_t = 0 if risk_emp_t == 1 & missing(`v')
	}

	label var risk_emp_t "Risk set: employees at t (complete cases, baseline covariates)"

	save "$path2/ukhls_clean.dta", replace
*/
	
/* Creating the final risk set (3rd attempt)
*********************************************
// this now excludes inapplicable for employment vars
// complete cases enforced across all vars in the model

	use "$path2/ukhls_clean.dta", clear

	* Ensure panel is set
	xtset pidp wave, yearly
	sort pidp wave

	* 1. Forward-looking "consecutive waves" indicator: t and t+1
	capture drop f_wave 
	capture drop consec_f
	
	gen f_wave   = f.wave
	gen consec_f = (f_wave == wave + 1)

	* 2. Baseline (t) and follow-up (t+1) variables for clarity
	capture drop emp_t emp_f sempl_t wld_t wld_f
	gen emp_t   = employed
	gen emp_f   = f.employed

	gen sempl_t = sempl              // self-employment status at baseline t
	gen wld_t   = wld_any_nopain     // WLD at baseline t
	gen wld_f   = f.wld_any_nopain   // WLD at follow-up t+1

	* 3. Initial risk set at baseline t: 25–59, in sample, employed AND employee,
	*    with a valid consecutive follow-up and non-missing key follow-up WLD/emp
	capture drop risk_emp_t
	gen byte risk_emp_t = ///
		sample_25_59_u == 1 & /// in your main age/sample flag
		consec_f       == 1 & /// we observe t+1 and it is exactly next wave
		emp_t          == 1 & /// employed at baseline t
		sempl_t        == 0 & /// employee at baseline t (exclude self-employed)
		!missing(emp_f, wld_t, wld_f)

	label var risk_emp_t "Risk set: employees at t with follow-up at t+1 (pre-CC)"

	* 4. Within the employee risk set, treat 0 = inapplicable as missing
	*    for employment/job variables (mirroring old lagged setup)
	local inapp_vars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2

	foreach v of local inapp_vars {
		replace `v' = . if risk_emp_t == 1 & `v' == 0
	}

	* 5. Define exit between t and t+1 using F.emploss
	capture drop exit_t1
	gen byte exit_t1 = .

	* Employment loss in the interval (t → t+1)
	replace exit_t1 = 1 if risk_emp_t == 1 & f.emploss == 1

	* Retained employment in the interval (t → t+1)
	replace exit_t1 = 0 if risk_emp_t == 1 & f.emploss == 0

	capture label drop exit_t1
	label define exit_t1 0 "Retained employment (t+1)" 1 "Employment loss (t+1)"
	label values exit_t1 exit_t1
	label var exit_t1 "Employment exit between t and t+1 (from F.emploss)"

	* 6. Enforce complete cases for baseline covariates at t
	*    (all baseline variables that enter the model, measured at t)
	local ccvars ///
		wld_any_nopain /// WLD at t (already checked above, but harmless to include) ///
		wave          ///
		gor_dv        ///
		jbnssec3_re   ///
		parttime      ///
		fixedterm     ///
		jbsize_re     ///
		privcomp      ///
		isic_agg2     ///
		age           ///
		nkids_dv      ///
		sex_dv        ///
		ethnic        ///
		mastat_re     ///
		degree

	foreach v of local ccvars {
		replace risk_emp_t = 0 if risk_emp_t == 1 & missing(`v')
	}

	label var risk_emp_t "Risk set: employees at t (complete cases, baseline covariates)"
*/

* Creating the final risk set + exit variable (UKHLS) — FINAL
******************************************************************
	* - Build risk_emp_t first (incl. complete-case enforcement)
	* - THEN generate exit_t1 (so it is defined ONLY for the final risk set)

	use "$path2/ukhls_clean.dta", clear

	* Ensure panel is set
	xtset pidp wave, yearly
	sort pidp wave

	* 1) Forward-looking "consecutive waves" indicator: t and t+1
	capture drop f_wave consec_f
	gen f_wave   = F.wave
	gen consec_f = (f_wave == wave + 1)

	* 2) Baseline (t) and follow-up (t+1) variables for clarity
	capture drop emp_t emp_f sempl_t wld_t wld_f
	gen emp_t   = employed
	gen emp_f   = F.employed

	gen sempl_t = sempl              // self-employment status at baseline t
	gen wld_t   = wld_any_nopain     // WLD at baseline t
	gen wld_f   = F.wld_any_nopain   // WLD at follow-up t+1

	* 3) Initial risk set at baseline t: 25–59, in sample, employed AND employee,
	*    with a valid consecutive follow-up and non-missing key follow-up WLD/emp
	capture drop risk_emp_t
	gen byte risk_emp_t = ///
		sample_25_59_u == 1 & /// in your main age/sample flag
		consec_f       == 1 & /// we observe t+1 and it is exactly next wave
		emp_t          == 1 & /// employed at baseline t
		sempl_t        == 0 & /// employee at baseline t (exclude self-employed)
		!missing(emp_f, wld_t, wld_f)

	label var risk_emp_t "Risk set: employees at t with follow-up at t+1 (pre-CC)"

	* 4) Within the employee risk set, treat 0 = inapplicable as missing
	*    for employment/job variables (mirroring old lagged setup)
	local inapp_vars jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
	foreach v of local inapp_vars {
		replace `v' = . if risk_emp_t == 1 & `v' == 0
	}

	* 5) Enforce complete cases for baseline covariates at t
	*    (all baseline variables that enter the model, measured at t)
	local ccvars ///
		wld_any_nopain ///
		wave          ///
		gor_dv        ///
		jbnssec3_re   ///
		parttime      ///
		fixedterm     ///
		jbsize_re     ///
		privcomp      ///
		isic_agg2     ///
		age           ///
		nkids_dv      ///
		sex_dv        ///
		ethnic        ///
		mastat_re     ///
		degree

	foreach v of local ccvars {
		replace risk_emp_t = 0 if risk_emp_t == 1 & missing(`v')
	}

	label var risk_emp_t "Risk set: employees at t (complete cases, baseline covariates)"

	* 6) NOW define exit between t and t+1 using F.emploss
	*    (exit_t1 is defined ONLY for the FINAL risk set)
	capture drop exit_t1
	gen byte exit_t1 = .

	replace exit_t1 = 1 if risk_emp_t == 1 & F.emploss == 1
	replace exit_t1 = 0 if risk_emp_t == 1 & F.emploss == 0

	capture label drop exit_t1
	label define exit_t1 0 "Retained employment (t+1)" 1 "Employment loss (t+1)"
	label values exit_t1 exit_t1
	label var exit_t1 "Employment exit between t and t+1 (from F.emploss)"

* Diagnostics
***************

	* Confirm risk_emp_t really is the "employee baseline" population 
	tab risk_emp_t, missing
	tab sempl if risk_emp_t==1, missing
	tab employed if risk_emp_t==1, missing
	// yes
	
	* Check the joint distribution of employed at t and t+1 within the risk set
	capture drop emp_f
	gen emp_f = F.employed
	tab employed emp_f if risk_emp_t==1, missing
	
	* Validate that exit_t1 matches transitions in employed
	tab exit_t1, missing
	tab exit_t1 if risk_emp_t==1, missing				// now matching
	tab exit_t1 employed if risk_emp_t==1, missing
	tab exit_t1 emp_f if risk_emp_t==1, missing

	save "$path2/ukhls_clean.dta", replace 

* Categorise follow-up destinations
*************************************

	* In UKHLS after you have risk_emp_t and exit_t1
	xtset pidp wave, yearly

	* Follow-up main status
	capture drop jbstat_f
	gen jbstat_f = F.jbstat if risk_emp_t==1 & exit_t1 < .
	label values jbstat_f a_jbstat
	label var jbstat_f "Follow-up employment status"

	* Follow-up categories
	capture drop sempl_f
	capture drop employee_f 
	capture drop nonemp_f
	gen byte sempl_f  = (jbstat_f==1) if jbstat_f < .
	gen byte employee_f = inlist(jbstat_f,2,11) if jbstat_f < .
	gen byte nonemp_f   = (!inlist(jbstat_f,1,2,11)) if jbstat_f < .

	* Quick headline check
	tab jbstat_f if risk_emp_t==1 & exit_t1 < ., missing
	tab jbstat_f if risk_emp_t==1 & exit_t1==1, mis

	
	* Show where the transitions sit relative to exit_t1
	tab exit_t1 sempl_f if risk_emp_t==1 & exit_t1 < ., row missing

	* And a more detailed breakdown
	tab jbstat_f exit_t1 if risk_emp_t==1 & exit_t1 < ., row missing
	
	save "$path2/ukhls_clean.dta", replace 

* Table of risk set by year 
****************************

	*-----------------------------------------------------------
	* UKHLS: Effective model sample by wave + TOTAL row (RTF)
	* Rows: 1–9 + Total
	* Cols: WLD n | WLD % | No WLD n | No WLD % | Total n | Total %
	* Sample: risk_emp_t == 1  (employee risk set, 25–59, complete cases)
	* WLD var: wld_any_nopain
	*-----------------------------------------------------------

	use "$path2/ukhls_clean.dta", clear

	* Baseline waves t for which t+1 exists
	local waves 1 2 3 4 5 6 7 8 9

	matrix drop _all
	matrix results = J(`: word count `waves'', 6, .)
	local r = 0

	* Accumulators for TOTAL row
	local tot_denom   = 0
	local tot_wld_n   = 0
	local tot_nowld_n = 0

	foreach w of local waves {
		local ++r

		* Denominator = model-ready effective sample this wave (employee risk set)
		quietly count if wave==`w' & risk_emp_t==1
		local denom = r(N)

		* WLD / no-WLD counts
		quietly count if wave==`w' & risk_emp_t==1 & wld_any_nopain==1
		local wld_n = r(N)

		quietly count if wave==`w' & risk_emp_t==1 & wld_any_nopain==0
		local nowld_n = r(N)

		* Percentages (unrounded), then rounded to 1 dp
		local wld_pct_u   = cond(`denom'>0, 100*`wld_n'/`denom', .)
		local nowld_pct_u = cond(`denom'>0, 100*`nowld_n'/`denom', .)
		local tot_pct_u   = `wld_pct_u' + `nowld_pct_u'

		local wld_pct   = round(`wld_pct_u', .1)
		local nowld_pct = round(`nowld_pct_u', .1)
		local tot_pct   = round(`tot_pct_u', .1)

		* Store row
		matrix results[`r',1] = `wld_n'
		matrix results[`r',2] = `wld_pct'
		matrix results[`r',3] = `nowld_n'
		matrix results[`r',4] = `nowld_pct'
		matrix results[`r',5] = `denom'
		matrix results[`r',6] = `tot_pct'

		* Accumulate totals
		local tot_denom   = `tot_denom'   + `denom'
		local tot_wld_n   = `tot_wld_n'   + `wld_n'
		local tot_nowld_n = `tot_nowld_n' + `nowld_n'

		* Optional: per-wave sanity warning
		if `denom'>0 & (abs(`tot_pct_u' - 100) > 0.2) {
			di as error "Wave `w': Total % = " %4.1f `tot_pct_u' " (check WLD coding/missings)"
		}
	}

	* ---------- Append TOTAL row ----------
	local tot_wld_pct_u   = cond(`tot_denom'>0, 100*`tot_wld_n'/`tot_denom', .)
	local tot_nowld_pct_u = cond(`tot_denom'>0, 100*`tot_nowld_n'/`tot_denom', .)
	local tot_pct_u_all   = `tot_wld_pct_u' + `tot_nowld_pct_u'

	local tot_wld_pct   = round(`tot_wld_pct_u', .1)
	local tot_nowld_pct = round(`tot_nowld_pct_u', .1)
	local tot_pct_all   = round(`tot_pct_u_all', .1)

	matrix totalrow = (`tot_wld_n', `tot_wld_pct', `tot_nowld_n', `tot_nowld_pct', `tot_denom', `tot_pct_all')
	matrix results = results \ totalrow

	matrix rownames results = `waves' Total
	matrix colnames results = "WLD n" "WLD %" "No WLD n" "No WLD %" "Total n" "Total %"

	* Optional: warn if TOTAL % deviates from ~100
	if `tot_denom'>0 & (abs(`tot_pct_u_all' - 100) > 0.2) {
		di as error "TOTAL row: Total % = " %4.1f `tot_pct_u_all' " (check WLD coding/missings)"
	}

	* Export
	esttab matrix(results) using "$path6/ukhls_retentionchapt_effectivesample_by_wave.rtf", replace rtf ///
		title("Effective model sample by baseline wave t (UKHLS: employee risk set, risk_emp_t==1)") ///
		nomtitle nonumber noobs


*-------------------------------------------------------------------------------
**# Descriptives (I): sample descriptives
*-------------------------------------------------------------------------------

* Load data and set panel structure
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

* Employees v self-employed in the employed unbalanced sample
****************************************************************

	* Find the self-employed in the sample BEFORE imposing complete cases
	
	*-------------------------------
	* Inclusion conditions 
	*-------------------------------
	gen byte cond1 = (ivfio == 1 & scflag_dv == 1)                // full interview
	gen byte cond2 = !(intdaty_dv == 2020 & intdatm_dv > 2)       // pre-COVID
	gen byte cond3 = inrange(age, 25, 59)                         // age 25–59

	* Combine into a single general-sample flag
	capture drop sample_25_59_gen
	gen byte sample_25_59_gen = cond1 & cond2 & cond3
	label var sample_25_59_gen "General UKHLS 25–59 sample (no CC restrictions)"

	*-------------------------------
	* Employees vs self-employed by WLD
	*-------------------------------
	preserve

	* General sample, employed, non-missing WLD + sempl
	keep if sample_25_59_gen == 1 ///
		& employed == 1 ///
		& !missing(sempl, wld_any_nopain)

	* Employment status: employee vs self-employed/other
	capture drop empstatus2
	gen byte empstatus2 = .
	replace empstatus2 = 1 if sempl == 0
	replace empstatus2 = 2 if sempl != 0

	capture label drop empstatus2
	label define empstatus2 1 "Employee" 2 "Self-employed"
	label values empstatus2 empstatus2
	label var empstatus2 "Employment status"

	* Cross-tab: this is what you'll quote in the footnote
	tab wld_any_nopain empstatus2, row

	restore


* General covariate descriptives
************************************

	* Load data and set panel structure
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	*--------------------------------------------------------------*
	* Descriptives for full covariate set – risk set only         *
	* Unweighted, stratified by WLD (wld_any_nopain)              *
	*--------------------------------------------------------------*

	*--------------------------------------------------------------*
	* Block 1: Continuous covariates                               *
	*   - age                                                      *
	*   - nkids_dv                                                 *
	*--------------------------------------------------------------*

	* Just to be safe, start clean
	eststo clear

	* Work on a preserved copy so we don't touch your main data
	preserve

	* Restrict to the risk set for exit model
	keep if risk_emp_t == 1

	* Optional: ensure WLD labels (adjust if already defined)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_nopain wldlab

	* 1a. Total risk set
	estpost tabstat age nkids_dv, ///
		statistics(mean sd) columns(statistics)
	eststo cont_total

	* 1b. No WLD
	estpost tabstat age nkids_dv if wld_any_nopain == 0, ///
		statistics(mean sd) columns(statistics)
	eststo cont_noWLD

	* 1c. WLD
	estpost tabstat age nkids_dv if wld_any_nopain == 1, ///
		statistics(mean sd) columns(statistics)
	eststo cont_WLD

	* 1d. Export – export to Excel-readable CSV (WLD, No WLD, Total)
	esttab cont_WLD cont_noWLD cont_total using ///
		"$path6/ukhls_retentionchapt_descr_block1_continuous.csv", ///
		replace label noobs nonumber ///
		mtitles("WLD" "No WLD" "Total") ///
		cells("mean(fmt(2)) sd(fmt(2) par(( ) ))") ///
		plain csv

	restore 
	
	*--------------------------------------------------------------*
	* Block 2: Dummy covariates                                    *
	*   - wld_any_nopain (0/1)                                     *
	*   - sex_dv      -> Female dummy                              *
	*   - degree (0/1)                                             *
	*--------------------------------------------------------------*

	eststo clear
	preserve
	keep if risk_emp_t == 1

	* Optional: ensure WLD labels (adjust if already defined)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_nopain wldlab

	* Recode sex_dv into a 0/1 "female" dummy
	capture drop female
	gen byte female = (sex_dv == 2) if !missing(sex_dv)
	label var female "Female (1 = yes)"

	* Check degree coding (you confirmed: 0 No degree, 1 Degree)
	* We will treat it directly as a 0/1 dummy

	* Convert dummies to 0–100 scale so means = percentages
	foreach v in wld_any_nopain female degree {
		capture drop `v'_pct
		gen double `v'_pct = `v' * 100 if !missing(`v')
		label var `v'_pct "`: var label `v'' (percent with value = 1)"
	}

	* 2a. Total risk set
	estpost tabstat wld_any_nopain_pct female_pct degree_pct, ///
		statistics(mean) columns(statistics)
	eststo dum_total

	* 2b. No WLD
	estpost tabstat wld_any_nopain_pct female_pct degree_pct ///
		if wld_any_nopain == 0, ///
		statistics(mean) columns(statistics)
	eststo dum_noWLD

	* 2c. WLD
	estpost tabstat wld_any_nopain_pct female_pct degree_pct ///
		if wld_any_nopain == 1, ///
		statistics(mean) columns(statistics)
	eststo dum_WLD

	* 2d. Export – export to Excel-readable CSV (WLD, No WLD, Total)
	esttab dum_WLD dum_noWLD dum_total using ///
		"$path6/ukhls_retentionchapt_descr_block2_dummies.csv", ///
		replace label noobs nonumber ///
		mtitles("WLD" "No WLD" "Total") ///
		cells("mean(fmt(1))") ///
		plain csv

	restore 
	
	*--------------------------------------------------------------*
	* Block 3: Categorical covariates (risk set, unweighted)       *
	*   - mastat_re                                              
	*	- ethnic
	*	- jbnssec3_re
	*   - parttime                                                 
	*   - fixedterm                                                
	*   - jbsize_re                                                
	*   - privcomp                                                 
	*   - isic_agg2                                                
	*--------------------------------------------------------------*

	eststo clear
	preserve
	keep if risk_emp_t == 1

	* Optional: ensure WLD labels (adjust if already defined)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_nopain wldlab
	
	* List of categorical predictors in the full model
	local catvars mastat_re ethnic jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2
	
	* Create a temporary file to hold the summary
	tempname memhold
	tempfile cat3

	* We will store: variable name, category code, category label,
	* and percentages for WLD, No WLD, and Total.
	postfile `memhold' str20 varname ///
			byte level ///
			str80 level_lab ///
			double pct_WLD pct_noWLD pct_total using `cat3', replace

	* Loop over each categorical variable
	foreach v of local catvars {

		* Get all observed categories for this variable in the risk set
		levelsof `v' if !missing(`v'), local(levels)

		foreach L of local levels {

			* ----- WLD = 1 -----
			quietly count if wld_any_nopain == 1 & `v' == `L'
			local num1 = r(N)
			quietly count if wld_any_nopain == 1 & !missing(`v')
			local den1 = r(N)
			local pct1 = .
			if (`den1' > 0) local pct1 = 100 * `num1' / `den1'

			* ----- No WLD = 0 -----
			quietly count if wld_any_nopain == 0 & `v' == `L'
			local num0 = r(N)
			quietly count if wld_any_nopain == 0 & !missing(`v')
			local den0 = r(N)
			local pct0 = .
			if (`den0' > 0) local pct0 = 100 * `num0' / `den0'

			* ----- Total (risk set) -----
			quietly count if `v' == `L'
			local numT = r(N)
			quietly count if !missing(`v')
			local denT = r(N)
			local pctT = .
			if (`denT' > 0) local pctT = 100 * `numT' / `denT'

			* Get value label for this category (if defined)
			local lab : label (`v') `L'

			* Store a row
			post `memhold' ("`v'") (`L') ("`lab'") ///
				(`pct1') (`pct0') (`pctT')
		}
	}

	postclose `memhold'

	* Use the summary dataset
	use `cat3', clear

	* Make it a bit prettier
	label var varname   "Variable"
	label var level     "Category code"
	label var level_lab "Category"
	label var pct_WLD   "WLD (%)"
	label var pct_noWLD "No WLD (%)"
	label var pct_total "Total (%)"

	* (Optional) Round percentages to 1 decimal place
	foreach p in pct_WLD pct_noWLD pct_total {
		replace `p' = round(`p', 0.1)
	}

	* Export – columns ordered: WLD first, then No WLD, then Total
	export delimited varname level_lab pct_WLD pct_noWLD pct_total ///
    using "$path6/ukhls_retentionchapt_descr_block3_categorical.csv", ///
    replace

	restore
	
*-------------------------------------------------------------------------------
**# Descriptives (II): frequency of exit by WLD
*-------------------------------------------------------------------------------

* Load data
	use "$path2/ukhls_clean.dta", clear

* INSPECT EXIT RATES

* Pooled balanced - for data & methods section
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal==1, mis // 226
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal_wld==1, mis // Only 36 
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal_nowld==1, mis // 190

* BIVARIATE UNWEIGHTED ASSOCIATION

* Pooled unbalanced
	// with simple exit variable
	tab wld_any_nopain exit_t1 if risk_emp_t==1, mis chi2 V
	
	// with detailed destination variable
	tab wld_any_nopain dest_t1 if risk_emp_t==1, mis chi2 V

/* POOLED BALANCED FREQUENCY TABLE

	* Load data
	use "$path2/ukhls_clean.dta", clear
	
	* Set longitudinal weight
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Helper dummies for weighted proportions (missing outside at-risk)
	capture drop retain exit
	gen byte retain = (emploss == 0) if !missing(emploss)
	gen byte exit   = (emploss == 1) if !missing(emploss)
	
	* 1) UNWEIGHTED COUNTS

	* WLD
	count if sample_25_59_bal_wld==1 & emploss==1
	scalar exit_wld_n = r(N)
	count if sample_25_59_bal_wld==1 & emploss==0
	scalar ret_wld_n  = r(N)
	count if sample_25_59_bal_wld==1 & !missing(emploss)
	scalar tot_wld_n  = r(N)

	* No WLD
	count if sample_25_59_bal_nowld==1 & emploss==1
	scalar exit_nowld_n = r(N)
	count if sample_25_59_bal_nowld==1 & emploss==0
	scalar ret_nowld_n  = r(N)
	count if sample_25_59_bal_nowld==1 & !missing(emploss)
	scalar tot_nowld_n  = r(N)

	* Total (WLD + No WLD)
	count if sample_25_59_bal==1 & emploss==1
	scalar exit_tot_n = r(N)
	count if sample_25_59_bal==1 & emploss==0
	scalar ret_tot_n  = r(N)
	count if sample_25_59_bal==1 & !missing(emploss)
	scalar tot_tot_n  = r(N)

	
	* 2) WEIGHTED COLUMN %

	* Column percentages within subpopulations of at-risk cases

	* WLD
	svy, subpop(if sample_25_59_bal_wld==1): mean retain exit
	matrix bw = e(b)
	scalar ret_wld_pct  = el(bw,1,1)*100
	scalar exit_wld_pct = el(bw,1,2)*100
	scalar tot_wld_pct  = 100.0   // force to 100.0

	* No WLD
	svy, subpop(if sample_25_59_bal_nowld==1): mean retain exit
	matrix bn = e(b)
	scalar ret_nowld_pct  = el(bn,1,1)*100
	scalar exit_nowld_pct = el(bn,1,2)*100
	scalar tot_nowld_pct  = 100.0

	* Total
	svy, subpop(if sample_25_59_bal==1): mean retain exit
	matrix bt = e(b)
	scalar ret_tot_pct  = el(bt,1,1)*100
	scalar exit_tot_pct = el(bt,1,2)*100
	scalar tot_tot_pct  = 100.0


	* 3) BUILD 3×6 MATRIX

	matrix drop _all
	matrix exit_tab = ///
	( exit_wld_n,  exit_wld_pct,  exit_nowld_n,  exit_nowld_pct,  exit_tot_n,  exit_tot_pct \ ///
	  ret_wld_n,   ret_wld_pct,   ret_nowld_n,   ret_nowld_pct,   ret_tot_n,   ret_tot_pct  \ ///
	  tot_wld_n,   tot_wld_pct,   tot_nowld_n,   tot_nowld_pct,   tot_tot_n,   tot_tot_pct )

	matrix rownames exit_tab = "Exit" "Retention" "Total"
	matrix colnames exit_tab = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	esttab matrix(exit_tab, fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_exit_bywld_balanced.rtf", replace rtf ///
		title("Employment exit vs retention (pooled) — UKHLS balanced 25–59") ///
		nonumber noobs nomtitle
*/

 /* Pooled unbalanced table of WLD x exit - NO LONGER REPORTED AS DETAILED DESTINATIONS INSTEAD
 ********************************************
 // (UPDATED: exit_t1 + risk_emp_t + wld_any_nopain)

	use "$path2/ukhls_clean.dta", clear

	* 1) UNWEIGHTED COUNTS  (Risk set only: risk_emp_t == 1)

	* WLD
	count if risk_emp_t==1 & wld_any_nopain==1 & exit_t1==1
	scalar exit_wld_n = r(N)
	count if risk_emp_t==1 & wld_any_nopain==1 & exit_t1==0
	scalar ret_wld_n  = r(N)
	count if risk_emp_t==1 & wld_any_nopain==1 & !missing(exit_t1)
	scalar tot_wld_n  = r(N)

	* No WLD
	count if risk_emp_t==1 & wld_any_nopain==0 & exit_t1==1
	scalar exit_nowld_n = r(N)
	count if risk_emp_t==1 & wld_any_nopain==0 & exit_t1==0
	scalar ret_nowld_n  = r(N)
	count if risk_emp_t==1 & wld_any_nopain==0 & !missing(exit_t1)
	scalar tot_nowld_n  = r(N)

	* Total
	count if risk_emp_t==1 & !missing(wld_any_nopain) & exit_t1==1
	scalar exit_tot_n = r(N)
	count if risk_emp_t==1 & !missing(wld_any_nopain) & exit_t1==0
	scalar ret_tot_n  = r(N)
	count if risk_emp_t==1 & !missing(wld_any_nopain) & !missing(exit_t1)
	scalar tot_tot_n  = r(N)

	* 2) COLUMN PERCENTAGES (unweighted)

	scalar exit_wld_pct   = (exit_wld_n   / tot_wld_n)*100
	scalar ret_wld_pct    = (ret_wld_n    / tot_wld_n)*100
	scalar tot_wld_pct    = 100.0

	scalar exit_nowld_pct = (exit_nowld_n / tot_nowld_n)*100
	scalar ret_nowld_pct  = (ret_nowld_n  / tot_nowld_n)*100
	scalar tot_nowld_pct  = 100.0

	scalar exit_tot_pct   = (exit_tot_n   / tot_tot_n)*100
	scalar ret_tot_pct    = (ret_tot_n    / tot_tot_n)*100
	scalar tot_tot_pct    = 100.0

	* 3) BUILD 3×6 MATRIX

	matrix drop _all
	matrix exit_tab_unbal = ///
	( exit_wld_n,  exit_wld_pct,  exit_nowld_n,  exit_nowld_pct,  exit_tot_n,  exit_tot_pct \ ///
	  ret_wld_n,   ret_wld_pct,   ret_nowld_n,   ret_nowld_pct,   ret_tot_n,   ret_tot_pct  \ ///
	  tot_wld_n,   tot_wld_pct,   tot_nowld_n,   tot_nowld_pct,   tot_tot_n,   tot_tot_pct )

	matrix rownames exit_tab_unbal = "Exit" "Retention" "Total"
	matrix colnames exit_tab_unbal = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* 4) EXPORT TO WORD (RTF) — keep original filename (overwrites)

	esttab matrix(exit_tab_unbal, fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_exit_bywld_unbalanced.rtf", replace rtf ///
		title("Employment exit vs retention (pooled) — UKHLS unbalanced 25–59") ///
		nonumber noobs nomtitle
*/

**# Table of exit/retention by employment status & WLD (for transparency)
*********************************************************************

	*------------------------------------------------------------
	* UKHLS: Transparency table — destinations at t+1 among baseline employees
	* Rows: 1 Retained (employee/apprentice)
	*       2 Retained (moved to self-employed)
	*       3 Exit (moved to non-employed)
	*       4 Missing follow-up status
	*       Total
	* Cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	* Denominator (columns): all baseline risk-set observations with defined exit_t1
	*------------------------------------------------------------

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	* Follow-up status attached to baseline row
	capture drop jbstat_f
	gen jbstat_f = F.jbstat if risk_emp_t==1 & exit_t1 < .
	label var jbstat_f "Main economic status at t+1 (F.jbstat)"

	* Destination buckets at t+1
	capture drop dest_t1
	gen byte dest_t1 = .

	replace dest_t1 = 1 if risk_emp_t==1 & exit_t1==0 & inlist(jbstat_f, 2, 11)   // still employee/apprentice
	replace dest_t1 = 2 if risk_emp_t==1 & exit_t1==0 & jbstat_f==1        		  // moved to self-employed
	replace dest_t1 = 3 if risk_emp_t==1 & exit_t1==1 & jbstat_f < . ///
						& !inlist(jbstat_f, 1, 2, 11)                       	  // non-employed
	replace dest_t1 = 4 if risk_emp_t==1 & exit_t1 < . & missing(jbstat_f)        // missing follow-up

	label define destlbl ///
		1 "Retained: employee/apprentice" ///
		2 "Retained: moved to self-employed" ///
		3 "Exit: moved to non-employed" ///
		4 "Missing follow-up status", replace
	label values dest_t1 destlbl
	label var dest_t1 "Destination at t+1 among baseline employees"
	
	* save destination variable in clean dataset
	save "$path2/ukhls_clean.dta", replace

	* Keep analysis base
	keep if risk_emp_t==1 & exit_t1 < . & !missing(wld_any_nopain)

	*------------------------------------------------------------
	* Build table matrix (4 rows + Total) × (6 columns)
	*------------------------------------------------------------
	tempname T
	matrix define `T' = J(5, 6, .)

	* 1) Counts by destination
	forvalues cat = 1/4 {
		quietly count if wld_any_nopain==1 & dest_t1==`cat'
		matrix `T'[`cat',1] = r(N)

		quietly count if wld_any_nopain==0 & dest_t1==`cat'
		matrix `T'[`cat',3] = r(N)

		matrix `T'[`cat',5] = `T'[`cat',1] + `T'[`cat',3]
	}

	* 2) Column denominators (all baseline risk-set obs with defined exit_t1)
	quietly count if wld_any_nopain==1
	scalar tot_wld_n = r(N)

	quietly count if wld_any_nopain==0
	scalar tot_nowld_n = r(N)

	scalar tot_all_n = tot_wld_n + tot_nowld_n

	* 3) Column percentages
	forvalues rr = 1/4 {
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100*(`T'[`rr',1]/tot_wld_n),   .)
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100*(`T'[`rr',3]/tot_nowld_n), .)
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100*(`T'[`rr',5]/tot_all_n),   .)
	}

	* 4) Total row
	matrix `T'[5,1] = tot_wld_n
	matrix `T'[5,2] = cond(tot_wld_n>=0,   100, .)
	matrix `T'[5,3] = tot_nowld_n
	matrix `T'[5,4] = cond(tot_nowld_n>=0, 100, .)
	matrix `T'[5,5] = tot_all_n
	matrix `T'[5,6] = cond(tot_all_n>=0,   100, .)

	matrix rownames `T' = ///
		retained_employee ///
		retained_selfemp ///
		exit_nonemp ///
		missing_followup ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	*------------------------------------------------------------
	* Export (RTF)
	*------------------------------------------------------------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_destinations_t1_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations at t+1 among baseline employees (risk set) — UKHLS unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle
		
	*------------------------------------------------------------
	* Export the destinations-by-WLD table to CSV (denominator = full risk set)
	* Assumes the matrix `T' has already been created as in the RTF block.
	*------------------------------------------------------------

	* Convert matrix to dataset
	preserve
	clear
	svmat double `T', names(col)

	* Add row identifier (5 rows: 1..4 + Total)
	gen row = _n
	label define rowlbl ///
		1 "retained_employee" ///
		2 "retained_selfemp" ///
		3 "exit_nonemp" ///
		4 "missing_followup" ///
		5 "Total", replace
	label values row rowlbl

	* Put row label into a string variable for clean CSV output
	gen str25 destination = ""
	replace destination = "retained_employee"  if row==1
	replace destination = "retained_selfemp"   if row==2
	replace destination = "exit_nonemp"        if row==3
	replace destination = "missing_followup"   if row==4
	replace destination = "Total"              if row==5

	drop row
	order destination WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* Tidy formats (optional)
	format WLD_n NoWLD_n Total_n %12.0f
	format WLD_pct NoWLD_pct Total_pct %6.1f

	* Export
	export delimited using ///
		"$path6/ukhls_retentionchapt_destinations_t1_bywld_unbalanced.csv", replace

	restore
		
* WLD and exit dynamics in the sample
****************************************

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave  

	* Follow-up WLD at t+1 (lead)
	capture drop wld_any_nopain_f
	gen byte wld_any_nopain_f = F.wld_any_nopain
	label var wld_any_nopain_f "WLD at follow-up (t+1, nopain)"

	* Create trajectory ONLY within the employee risk set
	capture drop wld_traj
	gen byte wld_traj = .
	replace wld_traj = 1 if risk_emp_t==1 & wld_any_nopain==0 & wld_any_nopain_f==0
	replace wld_traj = 2 if risk_emp_t==1 & wld_any_nopain==0 & wld_any_nopain_f==1
	replace wld_traj = 3 if risk_emp_t==1 & wld_any_nopain==1 & wld_any_nopain_f==0
	replace wld_traj = 4 if risk_emp_t==1 & wld_any_nopain==1 & wld_any_nopain_f==1

	capture label drop wld_traj
	label define wld_traj ///
		1 "No WLD -> No WLD" ///
		2 "No WLD -> WLD"    ///
		3 "WLD -> No WLD"    ///
		4 "WLD -> WLD"
	label values wld_traj wld_traj
	label var wld_traj "WLD trajectory (t -> t+1)"
	
	* View table (risk set only, complete on traj + exit)
	tab wld_traj exit_t1 if risk_emp_t==1 & !missing(wld_traj, exit_t1), nofreq row

	*------------------------------------
	* Export table to CSV (risk set only)
	*------------------------------------
	preserve
	keep if risk_emp_t==1 & !missing(wld_traj, exit_t1)

	contract wld_traj exit_t1, freq(N)

	bysort wld_traj: egen rowN = total(N)
	gen rowpct = 100 * N / rowN

	rename exit_t1 exit
	reshape wide rowpct N, i(wld_traj) j(exit)

	capture confirm variable rowpct0
		if _rc {
			gen rowpct0 = .
			gen N0 = 0
		}

		capture confirm variable rowpct1
		if _rc {
			gen rowpct1 = .
			gen N1 = 0
		}

	egen total_N0 = total(N0)
	egen total_N1 = total(N1)
	gen N_total = N0 + N1

	keep wld_traj rowpct0 rowpct1 N_total total_N0 total_N1
	rename rowpct0 pct_retain
	rename rowpct1 pct_exit
	rename N_total N

	quietly summarize total_N0
	scalar S_N0 = r(max)
	quietly summarize total_N1
	scalar S_N1 = r(max)
	drop total_N0 total_N1

	local oldN = _N
	set obs `=`oldN' + 1'
	replace wld_traj   = 0                          in `=`oldN' + 1'
	replace pct_retain = 100*S_N0/(S_N0+S_N1)       in `=`oldN' + 1'
	replace pct_exit   = 100*S_N1/(S_N0+S_N1)       in `=`oldN' + 1'
	replace N          = (S_N0 + S_N1)              in `=`oldN' + 1'

	label define wld_traj 0 "Total", add
	label values wld_traj wld_traj

	order wld_traj pct_retain pct_exit N
	format pct_retain pct_exit %5.1f
	format N %9.0f

	export delimited using "$path6/ukhls_retentionchapt_descr_wld_exit.csv", replace
	restore


* Create a WLD in either t or t+1 dummy
*****************************************

	use  "$path2/ukhls_clean.dta", clear
	* make sure panel is set (if not already)
	xtset pidp wave

	* drop old versions if you re-run
	capture drop wld_any

	* wld_any: wld in either t OR t+1, for the risk set with valid follow-up
	gen byte wld_any = .
	replace wld_any = (wld_any_nopain == 1 | wld_any_nopain_f == 1) ///
		if risk_emp_t == 1 & consec_f == 1

	label var wld_any "WLD in either t or t+1 (risk set only)"
	label define wld_any_lbl 0 "no WLD in t or t+1" 1 "WLD in t and/or t+1"
	label values wld_any wld_any_lbl


*-------------------------------------------------------------------------------
**# Descriptives (III): frequency of exit by employment chars and WLD
*-------------------------------------------------------------------------------


**# Socio-economic classification
***********************************

	/* UKHLS balanced panel - NOT UPDATED
	*========================

	* - Outcome: exit (emploss==1) among at-risk (emploss non-missing)
	* - Baseline class = L.jbnssec3_re, restricted to consecutive waves & values 1-3
	* - Weighted (pooled longitudinal design), subpop() for WLD/NoWLD
	* - 2 bars per class: WLD (blue) vs No WLD (red), with 95% CIs + labels

	use "$path2/ukhls_clean.dta", clear

	* Survey design (pooled, balanced 25–59)
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline NSSEC-3 at t-1, only for consecutive wave-pairs
	capture drop class0
	gen class0 = L.jbnssec3_re if wave == L.wave + 1

	* Exit outcome (emploss already 0/1 among at-risk)
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Proportions (weighted) by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(class0,1,3), over(class0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(class0,1,3), over(class0)
	matrix prop_nowld = r(table)

	* prop_* have two blocks of columns: first exit==0 (retention), then exit==1 (exit).
	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''   // 6 rows when K=3
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD rows 1..K: use exit==1 block
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD rows K+1..2K: exit==1 block
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions (blue left, red right)
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels: rounded %; place centered at CI top with tiny +0.1 offset
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	* Value labels
	label define jbnssec3_lbl 1 "1. Mgmt & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class jbnssec3_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and NSSEC-3") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	  ylabel(0(2)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_bynssec3_bal.png", replace
*/	
	* UKHLS UNBALANCED (unweighted): Exit(t+1) by WLD(t) × NSSEC-3(t) — RISK SET
	*============================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                        // *** CHANGED ***

	* Baseline NSSEC-3 at t (risk set only)                                 // *** CHANGED ***
	capture drop class0
	gen class0 = jbnssec3_re if risk_emp_t==1                               // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)            // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(class0,1,3), over(class0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(class0,1,3), over(class0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	* prop_* have two blocks: first exit==0 (retention), then exit==1 (exit)
	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''   // 6 rows when K=3
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD rows 1..K
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD rows K+1..2K
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions (blue left, red right)
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels: rounded %, centered at CI top with +0.1 offset
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.1 if wld==1
	gen nowld_label_y = ci_high + 0.1 if wld==0

	label define jbnssec3_lbl 1 "1. Mgmt & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class jbnssec3_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)), ///
	xtitle("NSSEC-3") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and socio-economic classification") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	  ylabel(0(5)15, format(%4.0f)) yscale(range(0 15)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_bynssec3_unbal.png", replace



**# PART-TIME
****************

	/* UKHLS balanced panel (weighted): Exit by WLD × part-time work - NOT UPDATED
	*===============================================================

	use "$path2/ukhls_clean.dta", clear

	* Survey design (pooled balanced 25–59)
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline part-time status (lagged, only for consecutive waves)
	capture drop pt0
	gen pt0 = L.parttime if wave == L.wave + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(pt0,1,3), over(pt0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(pt0,1,3), over(pt0)
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2   // first block retention, second block exit

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD rows 1..K
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD rows K+1..2K
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define pt_lbl 1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)"
	label values class pt_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and working time", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)", ///
	  angle(0) labsize(small)) ///
	  ylabel(0(5)25, format(%4.0f)) yscale(range(0 25)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_parttime_bal.png", replace
*/
	
	* UKHLS unbalanced panel (unweighted): Exit(t+1) by WLD(t) × part-time(t) — RISK SET
	*==================================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                         // *** CHANGED ***

	* Baseline part-time status at t (risk set only)                         // *** CHANGED ***
	capture drop pt0
	gen pt0 = parttime if risk_emp_t==1                                     // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(pt0,1,3), over(pt0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(pt0,1,3), over(pt0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define pt_lbl 1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)"
	label values class pt_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and working time") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)", ///
			 angle(0) labsize(small)) ///
	  ylabel(0(5)35, format(%4.0f)) yscale(range(0 35)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_parttime_unbal.png", replace


**# FIXED-TERM
*****************

/* UKHLS balanced panel (weighted): Exit by WLD × fixed-term - NOT UPDATED
*===============================================================

	use "$path2/ukhls_clean.dta", clear

	* Survey design (balanced 25–59)
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline fixed-term status (lagged, consecutive waves)
	capture drop ft0
	gen ft0 = L.fixedterm if wave == L.wave + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(ft0,1,2), over(ft0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(ft0,1,2), over(ft0)
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2   // first block retention, second block exit

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define ft_lbl 1 "1. Permanent" 2 "2. Non-permanent"
	label values class ft_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue) ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and fixed-term employment", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Permanent" 2 "2. Non-permanent", angle(0)) ///
	  ylabel(0(5)40, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_fixedterm_bal.png", replace
*/	
	* UKHLS unbalanced panel (unweighted): Exit(t+1) by WLD(t) × fixed-term(t) — RISK SET
	*===================================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                         // *** CHANGED ***

	* Baseline fixed-term status at t (risk set only)                         // *** CHANGED ***
	capture drop ft0
	gen ft0 = fixedterm if risk_emp_t==1                                    // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(ft0,1,2), over(ft0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(ft0,1,2), over(ft0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define ft_lbl 1 "1. Permanent" 2 "2. Non-permanent"
	label values class ft_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and fixed-term employment") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Permanent" 2 "2. Non-permanent", angle(0)) ///
	  ylabel(0(5)25, format(%4.0f)) yscale(range(0 25)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_fixedterm_unbal.png", replace
	

**# COMPANY SIZE

	/* UKHLS balanced panel (weighted): Exit by WLD × company size - NOT UPDATED
	*===============================================================

	use "$path2/ukhls_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline company size (lagged, consecutive waves)
	capture drop size0
	gen size0 = L.jbsize_re if wave == L.wave + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(size0,1,3), over(size0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(size0,1,3), over(size0)
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define size_lbl 1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200"
	label values class size_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and company size", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200", angle(0)) ///
	  ylabel(0(5)30, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_jbsize_bal.png", replace
	*/	
	* UKHLS unbalanced panel (unweighted): Exit(t+1) by WLD(t) × company size(t) — RISK SET
	*====================================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                         // *** CHANGED ***

	* Baseline company size at t (risk set only)                             // *** CHANGED ***
	capture drop size0
	gen size0 = jbsize_re if risk_emp_t==1                                  // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(size0,1,3), over(size0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(size0,1,3), over(size0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define size_lbl 1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200"
	label values class size_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and company size") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200", angle(0)) ///
	  ylabel(0(5)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_jbsize_unbal.png", replace


**# PUBLIC/PRIVATE SECTOR

	/* UKHLS balanced panel (weighted): Exit by WLD × public/private sector - NOT UPDATED
	*===============================================================

	use "$path2/ukhls_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline sector (lagged, consecutive waves)
	capture drop sector0
	gen sector0 = L.privcomp if wave == L.wave + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(sector0,1,2), over(sector0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(sector0,1,2), over(sector0)
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define sector_lbl 1 "1. Private sector" 2 "2. Public/Third sector"
	label values class sector_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and public/private sector", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Private sector" 2 "2. Public/Third sector", angle(0)) ///
	  ylabel(0(5)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_privcomp_bal.png", replace
*/

	* UKHLS unbalanced panel (unweighted): Exit(t+1) by WLD(t) × public/private(t) — RISK SET
	*=====================================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                         // *** CHANGED ***

	* Baseline sector at t (risk set only)                                   // *** CHANGED ***
	capture drop sector0
	gen sector0 = privcomp if risk_emp_t==1                                 // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(sector0,1,2), over(sector0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(sector0,1,2), over(sector0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define sector_lbl 1 "1. Private sector" 2 "2. Public/Third sector"
	label values class sector_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and public/private sector") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Private sector" 2 "2. Public/Third sector", angle(0)) ///
	  ylabel(0(5)15, format(%4.0f)) yscale(range(0 15)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_privcomp_unbal.png", replace



**# INDUSTRIAL SECTOR

	/* UKHLS balanced panel (weighted): Exit by WLD × industrial sector
	*===============================================================

	use "$path2/ukhls_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* Baseline industry (lagged, consecutive waves)
	capture drop ind0
	gen ind0 = L.isic_agg2 if wave == L.wave + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(ind0,1,3), over(ind0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(ind0,1,3), over(ind0)
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define ind_lbl 1 "1. Agriculture, forestry, mining" ///
						2 "2. Industry" ///
						3 "3. Services"
	label values class ind_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
							  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS balanced panel: Employment exit by WLD and industrial sector", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Agriculture, forestry, mining" 2 "2. Industry" 3 "3. Services", angle(0)) ///
	  ylabel(0(5)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_industry_bal.png", replace
*/	
	

	* UKHLS unbalanced panel (unweighted): Exit(t+1) by WLD(t) × industrial sector(t) — RISK SET
	*=======================================================================================

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                         
	
	* Baseline industry at t (risk set only)                                 
	capture drop ind0
	gen ind0 = isic_agg2 if risk_emp_t==1                                   
	
* Check number of exits per categories 
	tab ind0 exit_t1 if risk_emp_t==1 & wld_any_nopain==1, mis // WLD
	tab ind0 exit_t1 if risk_emp_t==1 & wld_any_nopain==0, mis // no WLD 

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==1 & inrange(ind0,1,3), over(ind0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_nopain==0 & inrange(ind0,1,3), over(ind0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = colsof(prop_wld)/2

	*-----------------------------
	* Build plotting dataset
	*-----------------------------
	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)

	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'

		* WLD
		replace prop = prop_wld[1,`col_exit'] * 100 in `i'
		replace se   = prop_wld[2,`col_exit'] * 100 in `i'

		* No WLD
		local j = `i' + `K'
		replace prop = prop_nowld[1,`col_exit'] * 100 in `j'
		replace se   = prop_nowld[2,`col_exit'] * 100 in `j'
	}

	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	* Bar positions
	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	* Labels
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define ind_lbl 1 "1. Agriculture, forestry, mining" ///
						 2 "2. Industry" ///
						 3 "3. Services"
	label values class ind_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue)  ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("UKHLS: Employment exit by WLD and industrial sector") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Agriculture, forestry, mining" 2 "2. Industry" 3 "3. Services", angle(0)) ///
	  ylabel(0(5)35, format(%4.0f)) yscale(range(0 35)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/ukhls_retentionchapt_exit_industry_unbal.png", replace
		

*-------------------------------------------------------------------------------
**# Descriptives (IV): Destinations from employment, by WLD
*-------------------------------------------------------------------------------

	/*---------------------------------------------------------------*
	*  DESTINATIONS AFTER EMPLOYMENT EXIT v1 — UKHLS balanced (weighted) - v1 NOT UPDATED
	*  rows: nonemp 1..6 + Total; cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	*  Denominator everywhere = exit cases (emploss==1)
	*---------------------------------------------------------------*

	use "$path2/ukhls_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

	* ---------- Unweighted counts per category & group (exit cases only) ----------
	tempname T
	matrix define `T' = J(7,6,.)

	forvalues cat = 1/6 {
		quietly count if sample_25_59_bal_wld==1   & emploss==1 & nonemp==`cat'
		matrix `T'[`cat',1] = r(N)     // WLD_n
		quietly count if sample_25_59_bal_nowld==1 & emploss==1 & nonemp==`cat'
		matrix `T'[`cat',3] = r(N)     // NoWLD_n
		matrix `T'[`cat',5] = `T'[`cat',1] + `T'[`cat',3]   // Total_n (unweighted)
	}

	* ---------- Weighted column percentages (exit-only, robust via dummies) ----------
	* Dummies defined for ALL exit cases; zero when not the category; missing outside exit
	capture drop ne1-ne6
	forvalues k = 1/6 {
		gen byte ne`k' = (nonemp==`k') if emploss==1
		replace ne`k' = 0 if emploss==1 & missing(ne`k')   // ensure all exit cases are 0/1
	}

	* WLD & NoWLD within-exit percentages
	svy, subpop(if sample_25_59_bal_wld==1   & emploss==1): mean ne1 ne2 ne3 ne4 ne5 ne6
	matrix b1 = e(b)*100
	svy, subpop(if sample_25_59_bal_nowld==1 & emploss==1): mean ne1 ne2 ne3 ne4 ne5 ne6
	matrix b0 = e(b)*100

	* Total (across all balanced exit cases)
	svy, subpop(if sample_25_59_bal==1 & emploss==1): mean ne1 ne2 ne3 ne4 ne5 ne6
	matrix bt = e(b)*100

	forvalues cat = 1/6 {
		matrix `T'[`cat',2] = b1[1,`cat']   // WLD_%
		matrix `T'[`cat',4] = b0[1,`cat']   // NoWLD_%
		matrix `T'[`cat',6] = bt[1,`cat']   // Total_%
	}

	* ---------- Totals row (exit cases) ----------
	quietly count if sample_25_59_bal_wld==1   & emploss==1 & inrange(nonemp,1,6)
	matrix `T'[7,1] = r(N)
	matrix `T'[7,2] = 100

	quietly count if sample_25_59_bal_nowld==1 & emploss==1 & inrange(nonemp,1,6)
	matrix `T'[7,3] = r(N)
	matrix `T'[7,4] = 100

	matrix `T'[7,5] = `T'[1,5] + `T'[2,5] + `T'[3,5] + `T'[4,5] + `T'[5,5] + `T'[6,5]
	matrix `T'[7,6] = 100

	* ---------- Row/column names (valid identifiers; pretty up in Word if needed) ----------
	matrix rownames `T' = ///
		unemployed ///
		education_training ///
		care_of_family_home__UK ///
		LT_sick_disabled__UK ///
		sheltered_workshop__DE ///
		other_non_employed ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* ---------- Export ----------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_nonemp_bywld_balanced.rtf", replace rtf ///
		title("Destinations after employment exit — UKHLS balanced 25–59") ///
		nonumber noobs nomtitle
*/

	/*---------------------------------------------------------------*
	*  DESTINATIONS AFTER EMPLOYMENT EXIT v2 — UKHLS unbalanced (unweighted)
	*  rows: UKHLS-available destinations (t+1) + Total
	*  cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	*  Denominator everywhere = baseline exit cases (t) in risk set:
	*    risk_emp_t==1 & exit_t1==1, with observed destination at t+1
	*---------------------------------------------------------------*

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave                                                           

	* Destination at follow-up (t+1), attached to baseline (t) exit row        
	capture drop nonemp_f
	gen byte nonemp_f = F.nonemp if risk_emp_t==1 & exit_t1==1                
	label var nonemp_f "Destination after exit (t+1)"

	* Keep only baseline exit transitions with valid UKHLS destinations         
	keep if risk_emp_t==1 & exit_t1==1                                        
	keep if inlist(nonemp_f, 1, 2, 3, 4, 6)                                   // (drop DE-only 5)

	tempname T
	matrix define `T' = J(6, 6, .)                                             // (5 cats + Total)

	* ---------- 1) Unweighted counts among EXIT cases (baseline), by destination at t+1 ----------
	local r = 0
	foreach cat in 1 2 3 4 6 {                                                 // (skip 5)
		local ++r

		quietly count if wld_any_nopain==1 & nonemp_f==`cat'                   
		matrix `T'[`r',1] = r(N)      // WLD_n

		quietly count if wld_any_nopain==0 & nonemp_f==`cat'                   
		matrix `T'[`r',3] = r(N)      // NoWLD_n

		* Row total (WLD + NoWLD)
		matrix `T'[`r',5] = `T'[`r',1] + `T'[`r',3]
	}

	* ---------- 2) Column denominators = all EXIT cases in group ----------
	quietly count if wld_any_nopain==1 & inlist(nonemp_f,1,2,3,4,6)            
	scalar tot_wld_n   = r(N)

	quietly count if wld_any_nopain==0 & inlist(nonemp_f,1,2,3,4,6)            
	scalar tot_nowld_n = r(N)

	scalar tot_all_n   = tot_wld_n + tot_nowld_n

	* ---------- 3) Column percentages (unweighted, within EXIT cases) ----------
	forvalues rr = 1/5 {                                                       
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100 * (`T'[`rr',1] / tot_wld_n), .)    // WLD_%
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100 * (`T'[`rr',3] / tot_nowld_n), .)  // NoWLD_%
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100 * (`T'[`rr',5] / tot_all_n), .)    // Total_%
	}

	* ---------- 4) Totals row (EXIT cases) ----------
	matrix `T'[6,1] = tot_wld_n
	matrix `T'[6,2] = cond(tot_wld_n>=0,   100, .)
	matrix `T'[6,3] = tot_nowld_n
	matrix `T'[6,4] = cond(tot_nowld_n>=0, 100, .)
	matrix `T'[6,5] = tot_all_n
	matrix `T'[6,6] = cond(tot_all_n>=0,   100, .)

	* ---------- 5) Row/column names (UKHLS-only; remove country suffixes) ----------
	matrix rownames `T' = ///
		unemployed ///
		education_training ///
		care_of_family_home ///                                                // (removed __UK)
		LT_sick_disabled ///                                                   // (removed __UK)
		other_non_employed ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* ---------- 6) Export (overwrite; keep original filename) ----------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_nonemp_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations after employment exit — UKHLS unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle
*/
	*---------------------------------------------------------------*
	*  DESTINATIONS AFTER EMPLOYMENT EXIT v3 — UKHLS unbalanced (unweighted)
	*  rows: UKHLS-available destinations (t+1) + Total  [UPDATED: add maternity]
	*  cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	*  Denominator everywhere = baseline exit cases (t) in risk set:
	*    risk_emp_t==1 & exit_t1==1, with observed destination at t+1
	*---------------------------------------------------------------*

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Destination at follow-up (t+1), attached to baseline (t) exit row
	capture drop nonemp_f
	gen byte nonemp_f = F.nonemp if risk_emp_t==1 & exit_t1==1
	label var nonemp_f "Destination after exit (t+1)"

	* Keep only baseline exit transitions with valid UKHLS destinations (UPDATED: include maternity=5)
	keep if risk_emp_t==1 & exit_t1==1
	keep if inlist(nonemp_f, 1, 2, 3, 4, 5, 6)   // UPDATED: add 5 (maternity/parental leave)

	tempname T
	matrix define `T' = J(7, 6, .)               // UPDATED: 6 cats + Total

	* ---------- 1) Unweighted counts among EXIT cases (baseline), by destination at t+1 ----------
	local r = 0
	foreach cat in 1 2 3 4 5 6 {                 // UPDATED: add 5
		local ++r

		quietly count if wld_any_nopain==1 & nonemp_f==`cat'
		matrix `T'[`r',1] = r(N)      // WLD_n

		quietly count if wld_any_nopain==0 & nonemp_f==`cat'
		matrix `T'[`r',3] = r(N)      // NoWLD_n

		* Row total (WLD + NoWLD)
		matrix `T'[`r',5] = `T'[`r',1] + `T'[`r',3]
	}

	* ---------- 2) Column denominators = all EXIT cases in group ----------
	quietly count if wld_any_nopain==1 & inlist(nonemp_f,1,2,3,4,5,6)   // UPDATED: add 5
	scalar tot_wld_n   = r(N)

	quietly count if wld_any_nopain==0 & inlist(nonemp_f,1,2,3,4,5,6)   // UPDATED: add 5
	scalar tot_nowld_n = r(N)

	scalar tot_all_n   = tot_wld_n + tot_nowld_n

	* ---------- 3) Column percentages (unweighted, within EXIT cases) ----------
	forvalues rr = 1/6 {                                                // UPDATED: 1/6 (was 1/5)
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100 * (`T'[`rr',1] / tot_wld_n), .)    // WLD_%
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100 * (`T'[`rr',3] / tot_nowld_n), .)  // NoWLD_%
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100 * (`T'[`rr',5] / tot_all_n), .)    // Total_%
	}

	* ---------- 4) Totals row (EXIT cases) ----------
	matrix `T'[7,1] = tot_wld_n                    // UPDATED: totals row is 7 (was 6)
	matrix `T'[7,2] = cond(tot_wld_n>=0,   100, .)
	matrix `T'[7,3] = tot_nowld_n
	matrix `T'[7,4] = cond(tot_nowld_n>=0, 100, .)
	matrix `T'[7,5] = tot_all_n
	matrix `T'[7,6] = cond(tot_all_n>=0,   100, .)

	* ---------- 5) Row/column names (UKHLS-only; remove country suffixes) ----------
	matrix rownames `T' = ///
		unemployed ///
		education_training ///
		care_of_family_home ///
		LT_sick_disabled ///
		maternity_parental_leave ///              // UPDATED: new row label for category 5
		other_non_employed ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* ---------- 6) Export (overwrite; keep original filename) ----------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/ukhls_retentionchapt_nonemp_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations after employment exit — UKHLS unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle

* Check why we lose 3 transitions
**********************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Destination at t+1 for baseline exits
	gen byte nonemp_f = F.nonemp if risk_emp_t==1 & exit_t1==1

	* Total baseline exits (denominator from exit table)
	count if risk_emp_t==1 & exit_t1==1
	scalar N_exits = r(N)

	* Exits with observed destination at t+1
	count if risk_emp_t==1 & exit_t1==1 & !missing(nonemp_f)
	scalar N_dest = r(N)

	display "Exits total: " N_exits
	display "Exits with observed destination: " N_dest
	display "Difference (missing destination): " (N_exits - N_dest)

	// They have a missing non-employment status - that's Ok. 


*-------------------------------------------------------------------------------
**# Exploring model specification: collinearity & other issues
*-------------------------------------------------------------------------------

use  "$path2/ukhls_clean.dta", clear

* Simple RE logit model

	xtlogit emploss i.wld_any_nopain ///
		wave gor_dv ///
		i.jbnssec3_re_lag i.parttime_lag i.fixedterm_lag i.jbsize_re_lag ///
		i.privcomp_lag ib3.isic_agg2_lag ///
		age nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree ///
		if sample_25_59_u==1 & cc_lags==1, re lrmodel or
		

/* Auditing discrepancy in n (of 2 between model n and expected n)
	** Issue now solved - had to do with sample_25_59_u using sex instead of sex_dv

	* 1) How many obs were actually used?
	count if e(sample)          // should show 88,320
	display e(N) e(N_g)         // obs and number of panels (groups)

	* 2) Tag expected vs. used, to find the 2 dropped obs
	gen byte expected = (sample_25_59_u==1 & cc_lags==1)
	gen byte used = e(sample)
	tab expected used, mis

	* 3) List the rows you expected but Stata dropped
	list pidp wave atrisk consec cc_lags emploss if expected==1 & used==0

	* 4) Identify why they were dropped (missing in y or any regressor)
	local y emploss
	local X wld_any_nopain wave gor_dv ///
		jbnssec3_re_lag parttime_lag fixedterm_lag jbsize_re_lag privcomp_lag isic_agg2_lag ///
		age nkids_dv sex_dv ethnic mastat_re degree

	foreach v of varlist `y' `X' {
		count if expected & !e(sample) & missing(`v')
		if r(N) {
			di as txt "`v' is missing for " %9.0f r(N) " dropped obs"
			list pidp wave `v' if expected & !e(sample) & missing(`v'), noobs
			}
		}
	
	list pidp wave sex if pidp==890521286
*/

/* Mundlak correction to RE - with lagged vars - no longer used

	* --- Person means for time-varying regressors ---

	* continuous
	by pidp: egen age_bar   = mean(age)
	by pidp: egen nkids_bar = mean(nkids_dv)

	* binary/time-varying
	by pidp: egen wld_bar = mean(wld_any_nopain)

	* factor vars: create dummies (omit the base) then person means
	tab jbnssec3_re_lag, gen(NS_)           // base is 1; keep NS_2 NS_3
	by pidp: egen NS_2_bar = mean(NS_2)
	by pidp: egen NS_3_bar = mean(NS_3)

	tab parttime_lag, gen(PT_)              // base is 1; keep PT_2 PT_3
	by pidp: egen PT_2_bar = mean(PT_2)
	by pidp: egen PT_3_bar = mean(PT_3)

	tab fixedterm_lag, gen(FT_)             // base is 1; keep FT_2
	by pidp: egen FT_2_bar = mean(FT_2)

	tab jbsize_re_lag, gen(SZ_)             // base is 1; keep SZ_2 SZ_3
	by pidp: egen SZ_2_bar = mean(SZ_2)
	by pidp: egen SZ_3_bar = mean(SZ_3)

	tab privcomp_lag, gen(SEC_)             // base is 1=private; keep SEC_2
	by pidp: egen SEC_2_bar = mean(SEC_2)

	tab isic_agg2_lag, gen(IND_)            // you used ib3., so omit IND_3 as base
	by pidp: egen IND_1_bar = mean(IND_1)
	by pidp: egen IND_2_bar = mean(IND_2)

	tab mastat_re, gen(MS_)                 // pick a base (e.g., 1); keep others
	by pidp: egen MS_2_bar = mean(MS_2)
	by pidp: egen MS_3_bar = mean(MS_3)

	* --- Mundlak RE logit (wave kept; no means for wave) ---
	xtlogit emploss i.wld_any_nopain ///
		i.wave i.gor_dv ///
		i.jbnssec3_re_lag i.parttime_lag i.fixedterm_lag i.jbsize_re_lag ///
		i.privcomp_lag ib3.isic_agg2_lag ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree ///
		/* Mundlak between-person terms: */ ///
		c.age_bar c.nkids_bar c.wld_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar MS_2_bar MS_3_bar ///
		if sample_25_59_u==1 & cc_lags==1, re lrmodel or

	* Joint test: do we need Mundlak?
	testparm *_bar

	* Can confidently reject null; use Mundlak. Save person-mean variables. 
	save "$path2/ukhls_clean.dta", replace
*/

* New person-means (non-lagged)
**************************************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	* --- Person-means (Mundlak) for time-varying regressors ---
	* All person-means computed over the employee risk set:
	*   risk_emp_t == 1

	* continuous
	capture drop age_bar 
	capture drop nkids_bar
	capture drop wld_bar
	capture drop degree_bar
	bysort pidp: egen age_bar    = mean(cond(risk_emp_t==1, age, .))
	bysort pidp: egen nkids_bar  = mean(cond(risk_emp_t==1, nkids_dv, .))
	bysort pidp: egen wld_bar = mean(cond(risk_emp_t==1, wld_any_nopain, .))
	bysort pidp: egen degree_bar = mean(cond(risk_emp_t==1, degree, .))

	* dummies: create from NON-LAGGED vars, then person means over risk_emp_t==1

	* NS: jbnssec3_re (base = 1; keep ns_2 ns_3)
	capture ds ns_*
	capture drop `r(varlist)'
	tab jbnssec3_re, gen(ns_)
	bysort pidp: egen ns_2_bar = mean(cond(risk_emp_t==1, ns_2, .))
	bysort pidp: egen ns_3_bar = mean(cond(risk_emp_t==1, ns_3, .))

	* PT: parttime (base = 1; keep pt_2 pt_3)
	capture drop pt_*
	tab parttime, gen(pt_)
	bysort pidp: egen pt_2_bar = mean(cond(risk_emp_t==1, pt_2, .))
	bysort pidp: egen pt_3_bar = mean(cond(risk_emp_t==1, pt_3, .))

	* FT: fixedterm (base = 1; keep ft_2)
	capture drop ft_*
	tab fixedterm, gen(ft_)
	bysort pidp: egen ft_2_bar = mean(cond(risk_emp_t==1, ft_2, .))

	* SZ: jbsize_re (base = 1; keep sz_2 sz_3)
	capture drop sz_*
	tab jbsize_re, gen(sz_)
	bysort pidp: egen sz_2_bar = mean(cond(risk_emp_t==1, sz_2, .))
	bysort pidp: egen sz_3_bar = mean(cond(risk_emp_t==1, sz_3, .))

	* SEC: privcomp (base = 1; keep sec_2)
	capture drop sec_*
	tab privcomp, gen(sec_)
	bysort pidp: egen sec_2_bar = mean(cond(risk_emp_t==1, sec_2, .))

	* IND: isic_agg2 (ib3. in model; keep ind_1 ind_2)
	capture drop ind_*
	tab isic_agg2, gen(ind_)
	bysort pidp: egen ind_1_bar = mean(cond(risk_emp_t==1, ind_1, .))
	bysort pidp: egen ind_2_bar = mean(cond(risk_emp_t==1, ind_2, .))

	* MS: mastat_re (base = 1; keep ms_2 ms_3)
	capture drop ms_*
	tab mastat_re, gen(ms_)
	bysort pidp: egen ms_2_bar = mean(cond(risk_emp_t==1, ms_2, .))
	bysort pidp: egen ms_3_bar = mean(cond(risk_emp_t==1, ms_3, .))

	save "$path2/ukhls_clean.dta", replace

	*============================================================*
	* Create within-person deviations (x_dev = x - x_bar)         *
	* Means already computed over risk_emp_t==1                   *
	*============================================================*

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	*------------------------------------------------------------*
	* Continuous variables                                        *
	*------------------------------------------------------------*
	capture drop age_dev 
	capture drop nkids_dev 
	capture drop wld_dev 
	capture drop degree_dev
	gen double age_dev    = age        - age_bar
	gen double nkids_dev  = nkids_dv    - nkids_bar
	gen double wld_dev    = wld_any_nopain - wld_bar
	gen double degree_dev = degree     - degree_bar

	* Deviations only meaningful in risk set
	replace age_dev    = . if risk_emp_t != 1
	replace nkids_dev  = . if risk_emp_t != 1
	replace wld_dev    = . if risk_emp_t != 1
	replace degree_dev = . if risk_emp_t != 1

	*------------------------------------------------------------*
	* Dummy deviations                                            *
	* (using the dummy vars already generated: ns_*, pt_*, etc.)*
	*------------------------------------------------------------*

	* NS-SEC (base=1): ns_2 ns_3
	capture drop ns_2_dev ns_3_dev
	gen double ns_2_dev = ns_2 - ns_2_bar
	gen double ns_3_dev = ns_3 - ns_3_bar
	replace ns_2_dev = . if risk_emp_t != 1
	replace ns_3_dev = . if risk_emp_t != 1

	* Part-time (base=1): pt_2 pt_3
	capture drop pt_2_dev pt_3_dev
	gen double pt_2_dev = pt_2 - pt_2_bar
	gen double pt_3_dev = pt_3 - pt_3_bar
	replace pt_2_dev = . if risk_emp_t != 1
	replace pt_3_dev = . if risk_emp_t != 1

	* Fixed-term (base=1): ft_2
	capture drop ft_2_dev
	gen double ft_2_dev = ft_2 - ft_2_bar
	replace ft_2_dev = . if risk_emp_t != 1

	* Company size (base=1): sz_2 sz_3
	capture drop sz_2_dev sz_3_dev
	gen double sz_2_dev = sz_2 - sz_2_bar
	gen double sz_3_dev = sz_3 - sz_3_bar
	replace sz_2_dev = . if risk_emp_t != 1
	replace sz_3_dev = . if risk_emp_t != 1

	* Sector (base=1): sec_2
	capture drop sec_2_dev
	gen double sec_2_dev = sec_2 - sec_2_bar
	replace sec_2_dev = . if risk_emp_t != 1

	* Industry (model uses ib3.; keep ind_1 ind_2)
	capture drop ind_1_dev ind_2_dev
	gen double ind_1_dev = ind_1 - ind_1_bar
	gen double ind_2_dev = ind_2 - ind_2_bar
	replace ind_1_dev = . if risk_emp_t != 1
	replace ind_2_dev = . if risk_emp_t != 1

	* Marital status (base=1): ms_2 ms_3
	capture drop ms_2_dev ms_3_dev
	gen double ms_2_dev = ms_2 - ms_2_bar
	gen double ms_3_dev = ms_3 - ms_3_bar
	replace ms_2_dev = . if risk_emp_t != 1
	replace ms_3_dev = . if risk_emp_t != 1

	*------------------------------------------------------------*
	* Labels                                           *
	*------------------------------------------------------------*
	label var age_dev    "Age deviation from person-mean (risk set)"
	label var nkids_dev  "Children deviation from person-mean (risk set)"
	label var wld_dev    "WLD deviation from person-mean (risk set)"
	label var degree_dev "Degree deviation from person-mean (risk set)"

	label var ns_2_dev "NS-SEC=2 deviation from person-mean"
	label var ns_3_dev "NS-SEC=3 deviation from person-mean"
	label var pt_2_dev "Part-time=2 deviation from person-mean"
	label var pt_3_dev "Part-time=3 deviation from person-mean"
	label var ft_2_dev "Fixed-term=2 deviation from person-mean"
	label var sz_2_dev "Firm size=2 deviation from person-mean"
	label var sz_3_dev "Firm size=3 deviation from person-mean"
	label var sec_2_dev "Sector=2 deviation from person-mean"
	label var ind_1_dev "Industry=1 deviation from person-mean"
	label var ind_2_dev "Industry=2 deviation from person-mean"
	label var ms_2_dev "Marital status=2 deviation from person-mean"
	label var ms_3_dev "Marital status=3 deviation from person-mean"

	save "$path2/ukhls_clean.dta", replace

*-------------------------------------------------------------------------------
**# First draft of regression models 
*-------------------------------------------------------------------------------

* UKHLS Stepwise xtlogit RE — Mundlak terms added in their own block
*****************************************************************************

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Ensure estout suite
	capture which estadd
	if _rc ssc install estout, replace

	eststo clear

	*----------------------------------*
	* M0) Baseline (CRE + baseline)
	*   - within: i.wld_any_nopain
	*   - Mundlak here: c.wld_bar ONLY
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar ///
		i.wave i.gor_dv ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M0
	estadd scalar LR_prev = .
	estadd scalar df_prev = .
	estadd scalar p_prev  = .
	eststo drop M0
	eststo M0

	*----------------------------------*
	* M1) + Socio-demographics
	*   - within: c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re
	*   - Mundlak added now: c.age_bar c.nkids_bar MS_2_bar MS_3_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M1

	lrtest M0 M1
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M1
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M1
	eststo M1
	display e(LR_prev) e(df_prev) e(p_prev)

	*----------------------------------*
	* M2) + Education
	*   - within: i.degree
	*   - (no degree_bar; quasi time-invariant)
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re ///
		i.degree ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M2

	lrtest M1 M2
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M2
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M2
	eststo M2

	*----------------------------------*
	* M3) + Occupation (lagged)
	*   - within: i.jbnssec3_re_lag
	*   - Mundlak added now: NS_2_bar NS_3_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M3

	lrtest M2 M3
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M3
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M3
	eststo M3

	*----------------------------------*
	* M4) + Contract type (lagged)
	*   - within: i.parttime_lag i.fixedterm_lag
	*   - Mundlak added now: PT_2_bar PT_3_bar FT_2_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M4

	lrtest M3 M4
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M4
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M4
	eststo M4
	testparm i.parttime_lag i.fixedterm_lag

	*----------------------------------*
	* M5) + Company size & sector (lagged)
	*   - within: i.jbsize_re_lag i.privcomp_lag
	*   - Mundlak added now: SZ_2_bar SZ_3_bar SEC_2_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag ///
		i.jbsize_re_lag i.privcomp_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M5

	lrtest M4 M5
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M5
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M5
	eststo M5
	testparm i.jbsize_re_lag i.privcomp_lag

	*----------------------------------*
	* M6) + Industry (lagged) [base = 3]
	*   - within: ib3.isic_agg2_lag
	*   - Mundlak added now: IND_1_bar IND_2_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar ///
		IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ///
		ib3.isic_agg2_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M6

	lrtest M5 M6
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M6
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M6
	eststo M6
	testparm ib3.isic_agg2_lag

	*-----------------------------------*
	*  INTERACTIONS (each vs M6)
	*  (No new *_bar terms; all added by M6)
	*-----------------------------------*

	* M7) + WLD × Occupation (lagged)
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#i.jbnssec3_re_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M7

	lrtest M6 M7
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M7
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M7
	eststo M7
	testparm 1.wld_any_nopain#i.jbnssec3_re_lag

	* M8) + WLD × Part-time (lagged)
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#i.parttime_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M8

	lrtest M6 M8
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M8
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M8
	eststo M8
	testparm 1.wld_any_nopain#i.parttime_lag

	* M9) + WLD × Fixed-term (lagged)
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#i.fixedterm_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M9

	lrtest M6 M9
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M9
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M9
	eststo M9
	testparm 1.wld_any_nopain#i.fixedterm_lag

	* M10) + WLD × Company size (lagged)
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#i.jbsize_re_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M10

	lrtest M6 M10
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M10
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M10
	eststo M10
	testparm 1.wld_any_nopain#i.jbsize_re_lag

	* M11) + WLD × Public/Private (lagged)
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#i.privcomp_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M11

	lrtest M6 M11
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M11
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M11
	eststo M11
	testparm 1.wld_any_nopain#i.privcomp_lag

	* M12) + WLD × Industry (lagged) [base = 3]
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#ib3.isic_agg2_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M12

	lrtest M6 M12
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M12
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M12
	eststo M12
	testparm 1.wld_any_nopain#i.isic_agg2_lag

	* M13) + ALL interactions
	xtlogit emploss i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		NS_2_bar NS_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag ///
		i.wld_any_nopain#(i.jbnssec3_re_lag i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag) ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M13

	lrtest M6 M13
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M13
	estadd scalar LR_vs_M6 = `chi2', replace
	estadd scalar df_vs_M6 = `df',   replace
	estadd scalar p_vs_M6  = `p',    replace
	eststo drop M13
	eststo M13
	testparm 1.wld_any_nopain#(i.jbnssec3_re_lag i.parttime_lag i.fixedterm_lag i.jbsize_re_lag i.privcomp_lag ib3.isic_agg2_lag)

	*--------------------------------------------*
	* Save models as .ster files (new suffix)
	*--------------------------------------------*
	forvalues k = 0/13 {
		estimates restore M`k'
		estimates save "$path8/ukhls_retentionchapt_xtlogit_M`k'_barsinline.ster", replace
	}

* Restore estimates

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Load stored models into the eststo set
	eststo clear
	forvalues k = 0/13 {
		estimates use "$path8/ukhls_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}

	* If LR vs previous wasn't saved, compute & attach now (no refitting)
	forvalues k = 1/6 {
		estimates restore M`k'
		scalar _has = e(LR_prev)
		if missing(_has) {
			local km1 = `k' - 1
			lrtest M`km1' M`k'
			local chi2 = r(chi2)
			local df   = r(df)
			local p    = r(p)
			estimates restore M`k'
			estadd scalar LR_prev = `chi2', replace
			estadd scalar df_prev = `df',   replace
			estadd scalar p_prev  = `p',    replace
			eststo drop M`k'
			eststo M`k'
		}
		scalar drop _has
	}

	* Export fit summaries (renamed)
	*----------------------------------*
	
	* Add model titles
	estadd local modeltitle "M0 Baseline" , replace : M0
	estadd local modeltitle "M1 +SD +means" , replace : M1
	estadd local modeltitle "M2 +Degree" , replace : M2
	estadd local modeltitle "M3 +Occ +means" , replace : M3
	estadd local modeltitle "M4 +Contract +means" , replace : M4
	estadd local modeltitle "M5 +Firm +means" , replace : M5
	estadd local modeltitle "M6 +Industry +means" , replace : M6
	estadd local modeltitle "M7 +WLD×Occ" , replace : M7
	estadd local modeltitle "M8 +WLD×PT" , replace : M8
	estadd local modeltitle "M9 +WLD×FT" , replace : M9
	estadd local modeltitle "M10 +WLD×Size" , replace : M10
	estadd local modeltitle "M11 +WLD×Sector" , replace : M11
	estadd local modeltitle "M12 +WLD×Industry" , replace : M12
	estadd local modeltitle "M13 +ALL interactions" , replace : M13
	
	*RTF
	esttab M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/ukhls_retentionchapt_stepwise_fit_barsinline.rtf", replace rtf ///
		title("UKHLS stepwise model comparisons — xtlogit re, intpoints(7); Mundlak added in-block") ///
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 2 0 3 2 0 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p" ///
					"LR vs M6" "df (vs M6)" "p (vs M6)")) ///
		nonotes

	*CSV
	esttab M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/ukhls_retentionchapt_stepwise_fit_barsinline.csv", replace csv ///					 
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 2 0 3 2 0 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p" ///
					"LR vs M6" "df (vs M6)" "p (vs M6)"))
	
	
	* Export coefficient tables - no interactions
	*-----------------------------
	* WITH region and period effects
	
	* RTF (no period/region rows)
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/ukhls_rentionchapt_stepwise_blocks_or_no_periodregion.rtf", replace rtf ///
		title("Odds Ratios – UKHLS stepwise blocks (xtlogit, re) — no period/region rows") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))

	* CSV (no period/region rows)
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/ukhls_rentionchapt_stepwise_blocks_or_no_periodregion.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))
			  
	* Stepwise tables of interactions
	*--------------------------------

	* Interactions (M7–M13) — WITH period/region rows — RTF
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/ukhls_retentionchapt_stepwise_interactions_or_barsinline.rtf", replace rtf ///
		title("Odds Ratios – UKHLS interactions (xtlogit re, intpoints(7); Mundlak added in-block)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))

	* Interactions (M7–M13) — WITH period/region rows — CSV
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/ukhls_retentionchapt_stepwise_interactions_or_barsinline.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))


/* Run a "final" model (without interactions) and save
*******************************************************

	*--------------------------------------------------------------*
	* Final model — UKHLS
	*  - EXCLUDE within: i.jbsize_re_lag, ib3.isic_agg2_lag
	*  - EXCLUDE: i.degree
	*  - KEEP their Mundlak means (SZ_*_bar, IND_*_bar)
	*--------------------------------------------------------------*
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave
	
	* Clear all models in memory (to avoid using SOEP ones by accident)
	eststo clear
	capture estimates clear

	* Restore saved UKHLS models M0-M6
	forvalues k = 0/6 {
		estimates use "$path8/ukhls_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}
	
	* Fit Final (no interactions)
	xtlogit emploss i.wld_any_nopain ///
		/* Mundlak (between-person) terms kept */ ///
		c.wld_bar c.age_bar c.nkids_bar NS_2_bar NS_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar ///
		SEC_2_bar IND_1_bar IND_2_bar MS_2_bar MS_3_bar ///
		/* Baseline controls */ ///
		i.wave i.gor_dv ///
		/* WITHIN (time-varying) terms kept */ ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re ///
		i.jbnssec3_re_lag i.parttime_lag i.fixedterm_lag i.privcomp_lag ///
		if sample_25_59_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo Final

	* LR test: Final vs full non-interaction model (M6)
	lrtest M6 Final
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)

	* Attach LR vs previous (for Final, "previous" is M6)
	estimates restore Final
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace

	* Title to show in tables
	estadd local modeltitle "Final (− industry & size within; − degree)" , replace : Final

	* Save .ster for later restore
	estimates save "$path8/ukhls_retentionchapt_xtlogit_Final_barsinline.ster", replace
*/

* Check Rho in M6
	
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave	
	
	* Restore M6
	eststo clear
	est use "$path8/ukhls_retentionchapt_xtlogit_M6_barsinline.ster"
	ereturn list
	display e(rho)


* (Optional) make sure estout is available
capture which esttab
ssc install estout, replace

*Export models
***********************

	* 1. Restore models from .ster (M0–M6 + Final)
	*----------------------------------------------
	
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Start fresh
	eststo clear

	* Restore M0–M6
	forvalues k = 0/6 {
		estimates use "$path8/ukhls_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}

	* Restore Final
	estimates use "$path8/ukhls_retentionchapt_xtlogit_Final_barsinline.ster"
	eststo Final

	* (Optional) quick sanity check
	eststo dir

	* 2. Find exact coefficient names & write them to a txt file
	*------------------------------------------------------------
	
	* Try to get a rich model into memory (M6 or Final).
	capture estimates restore M6
	if _rc {
		capture estimates restore Final
		if _rc {
			* Fallback: load from .ster files if not already loaded
			capture estimates use "$path8/ukhls_retentionchapt_xtlogit_M6_barsinline.ster"
			if _rc estimates use "$path8/ukhls_retentionchapt_xtlogit_Final_barsinline.ster"
		}
	}

	* Sanity check
	ereturn list

	* --- Print all coefficient names, one per line (cleaning prefixes) ---
	local cols : colfullnames e(b)
	display as text "Coefficient names:"
	local i = 1
	foreach c of local cols {
		local cname : subinstr local c "xb:"       "", all
		local cname : subinstr local cname "emploss:" "", all
		di as result %3.0f `i' "  " as text "`cname'"
		local ++i
	}

	* --- Write the same list to a TXT file (for copy/paste later) ---
	tempname fh
	file open `fh' using "$path8/ukhls_retentionchapt_coefnames.txt", write replace
	foreach c of local cols {
		local cname : subinstr local c "xb:"       "", all
		local cname : subinstr local cname "emploss:" "", all
		file write `fh' "`cname'" _n
	}
	file close `fh'
	di as txt "Wrote: $path8/ukhls_retentionchapt_coefnames.txt"
	
	* 3. Export to RTF file
	*-----------------------------
	esttab M0 M1 M2 M3 M4 M5 M6 Final ///
    using "$path6/ukhls_retentionchapt_stepwise_final_OR.rtf", replace rtf ///
    mtitles("M0 Baseline" "M1 +SD +means" "M2 +Degree" "M3 +Occ +means" ///
            "M4 +Contract +means" "M5 +Firm +means" "M6 +Industry +means" "Final") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" "MS_2_bar" "MS_3_bar" "NS_2_bar" "NS_3_bar" ///
        "PT_2_bar" "PT_3_bar" "FT_2_bar" "SZ_2_bar" "SZ_3_bar" "SEC_2_bar" "IND_1_bar" "IND_2_bar" ///
        "1.wld_any_nopain" "age" "nkids_dv" "2.mastat_re" "3.mastat_re" ///
        "2.jbnssec3_re_lag" "3.jbnssec3_re_lag" ///
        "2.parttime_lag" "3.parttime_lag" ///
        "2.fixedterm_lag" ///
        "2.jbsize_re_lag" "3.jbsize_re_lag" ///
        "2.privcomp_lag" ///
        "1.isic_agg2_lag" "2.isic_agg2_lag" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" "1.degree" ///
        "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" "10.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" "MS_2_bar" "MS_3_bar" "NS_2_bar" "NS_3_bar" ///
        "PT_2_bar" "PT_3_bar" "FT_2_bar" "SZ_2_bar" "SZ_3_bar" "SEC_2_bar" "IND_1_bar" "IND_2_bar" ///
        "1.wld_any_nopain" "age" "nkids_dv" "2.mastat_re" "3.mastat_re" ///
        "2.jbnssec3_re_lag" "3.jbnssec3_re_lag" ///
        "2.parttime_lag" "3.parttime_lag" ///
        "2.fixedterm_lag" ///
        "2.jbsize_re_lag" "3.jbsize_re_lag" ///
        "2.privcomp_lag" ///
        "1.isic_agg2_lag" "2.isic_agg2_lag" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" "1.degree" ///
        "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" "10.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u") ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic LR_prev df_prev p_prev, ///
         fmt(0 3 2 2 2 0 3) ///
         labels("N" "LogLik" "AIC" "BIC" "LR vs prev" "df" "p"))

*-------------------------------------------------------------------------------
**# Second draft of regression models 28-29/11/25
*-------------------------------------------------------------------------------

// Exit modelled as occurring between t and t+1
// With all covariates measured at t, except WLD which is either t or t+1
// New risk set defined using risk_emp_t and exit as exit_t1
// Degree conceptualised as time-varying

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

* Create Mundlak terms & run model - no convergence (28/11/25)
************************************
	// measuring all vars at t
	// using wld_any
	// including degree 
	
	* --- Person means for time-varying regressors ---
	* All person means are computed over the risk set:
	*   risk_emp_t == 1  (employees at t with follow-up at t+1)
	*   consec_f   == 1  (forward-looking consecutive waves)

	*--------------------------------------------------
	* continuous
	*--------------------------------------------------
	capture drop age_bar
	by pidp: egen age_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, age, .))

	capture drop nkids_bar
	by pidp: egen nkids_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, nkids_dv, .))

	*--------------------------------------------------
	* binary / time-varying
	*   - wld_any: wld in either t or t+1 (new timing)
	*   - degree: has degree (time-varying)
	*--------------------------------------------------
	capture drop wld_any_bar
	by pidp: egen wld_any_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, wld_any, .))

	capture drop degree_bar
	by pidp: egen degree_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, degree, .))

	*--------------------------------------------------
	* factor vars: create dummies (omit the base) then person means
	* Now use NON-LAGGED versions:
	*   jbnssec3_re, parttime, fixedterm, jbsize_re, privcomp, isic_agg2, mastat_re
	* Each dummy's person-mean is computed over the risk set only.
	*--------------------------------------------------

	* NS: 3-class NS-SEC (jbnssec3_re), base is 1; keep NS_2 NS_3
	capture drop ns_1 ns_2 ns_3
	tab jbnssec3_re, gen(ns_)                   // base is 1; keep ns_2 ns_3
	by pidp: egen ns_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ns_2, .))
	by pidp: egen ns_3_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ns_3, .))

	* PT: part-time status (parttime), base is 1; keep PT_2 PT_3
	*   1 = full-time, 2 = regular part-time, 3 = marginal part-time
	capture drop pt_1 pt_2 pt_3
	tab parttime, gen(pt_)                      // base is 1; keep pt_2 pt_3
	by pidp: egen pt_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, pt_2, .))
	by pidp: egen pt_3_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, pt_3, .))

	* FT: contract type (fixedterm), base is 1; keep FT_2
	*   1 = permanent, 2 = non-permanent/fixed-term
	capture drop ft_1 ft_2
	tab fixedterm, gen(ft_)                     // base is 1; keep ft_2
	by pidp: egen ft_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ft_2, .))

	* SZ: firm size (jbsize_re), base is 1; keep SZ_2 SZ_3
	*   1 = <10, 2 = 11–200, 3 = >200
	capture drop sz_1 sz_2 sz_3
	tab jbsize_re, gen(sz_)                     // base is 1; keep sz_2 sz_3
	by pidp: egen sz_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, sz_2, .))
	by pidp: egen sz_3_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, sz_3, .))

	* SEC: sector (privcomp), base is 1=private; keep SEC_2
	*   1 = private, 2 = public/third sector
	capture drop sec_1 sec_2
	tab privcomp, gen(sec_)                     // base is 1=private; keep sec_2
	by pidp: egen sec_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, sec_2, .))

	* IND: industry (isic_agg2), you used ib3., so omit IND_3 as base
	capture drop ind_1 ind_2 ind_3
	tab isic_agg2, gen(ind_)                    // base is 3; keep ind_1 ind_2
	by pidp: egen ind_1_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ind_1, .))
	by pidp: egen ind_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ind_2, .))

	* MS: marital status (mastat_re), pick base (e.g., 1); keep others
	*   1 = married, 2 = cohabiting, 3 = single/widowed/divorced  (check your coding)
	capture drop ms_1 ms_2 ms_3
	tab mastat_re, gen(ms_)                     // base is 1; keep ms_2 ms_3
	by pidp: egen ms_2_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ms_2, .))
	by pidp: egen ms_3_bar = ///
		mean(cond(risk_emp_t == 1 & consec_f == 1, ms_3, .))
		
	save "$path2/ukhls_clean.dta", replace
	
* Updated M6 (the full model without interactions)

	xtlogit exit_t1 i.wld_any ///
		c.wld_any_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		if risk_emp_t==1, re intpoints(7) nolog
	eststo M6_updated
	
	estadd local modeltitle "Full model without interactions" , replace : Final

	* Save .ster for later restore
	estimates save "$path8/ukhls_retentionchapt_xtlogit_full_wld_any.ster", replace
	
/* Model has 2 issues:
- non-convergence
- ind_1_bar and  2.privcompomitted because of collinearity.
*/

*/
	
* Troubleshooting non-convergence and collinearity issues
**********************************************************

* Step 1: Confirm category loss is the reason for collinearity

	* Old sample 
	tab privcomp_lag if sample_25_59_u==1 & cc_lags==1, missing
	tab isic_agg2_lag if sample_25_59_u==1 & cc_lags==1, missing

	* New risk set sample
	tab privcomp  if risk_emp_t==1, missing
	tab isic_agg2 if risk_emp_t==1, missing

// Issue was indeed with the old v new sample - now fixed

* Sanity checks on the new risk set

	use "$path2/ukhls_clean.dta", clear

	* Panel + risk set
	xtset pidp wave, yearly

	* Check WLD_any vs exit in the new risk set
	tab wld_any exit_t1 if risk_emp_t==1, row

	* Check sector & industry coding in the new risk set
	tab privcomp if risk_emp_t==1, missing
	tab isic_agg2 if risk_emp_t==1, missing


* Building up the model slowly I (WLD at either t or t+1)
***********************************************************
// Measuring WLD at time t OR time t+1

* Simple pooled logit: exit on WLD_any only
	logit exit_t1 i.wld_any if risk_emp_t==1, or
	eststo logit_simple
	// looks fine: no large ORs or SEs for 1.wld_any

* Full pooled logit (no RE, no Mundlak yet)
	logit exit_t1 i.wld_any ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, or
	eststo logit_full
	// also fine

* RE logit without Mundlak person-means

	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_any ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, re intpoints(7) nolog

	eststo re_no_mundlak
	// It converged
	// Rho=0.16
	// But strange result for wld_any: OR=0.89 (.75, .90)
	
* RE logit with Mundlak (version I)

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_any ///
		c.wld_any_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		if risk_emp_t==1, re intpoints(7) nolog

	eststo re_mundlak
	//  ind_1_bar omitted because of collinearity.
	// it did converge. 
	// wld_any_bar: OR 0.45
	// wld_any: OR 0.577

* Building up the model II (WLD at t)
***************************************

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

* Simple pooled logit: exit on wld_any_nopain only
	logit exit_t1 i.wld_any_nopain if risk_emp_t==1, or
	eststo logit_simple_wld
	// WLD OR 2.15

* Full pooled logit (no RE)
	logit exit_t1 i.wld_any_nopain ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, or
	eststo logit_full_wld
	// WLD OR 1.97
	
	est save "$path8/ukhls_retentionchapt_xtlogit_full_logit_wld_t.ster", replace
	
* RE logit without Mundlak person-means

	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_any_nopain ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, re or intpoints(7) nolog
		
	// WLD OR 0.71
	// Rho 0.166
		
* RE logit with Mundlak - WLD measured at t

	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		if risk_emp_t==1, re or intpoints(7) nolog

	eststo m6_wld_t
	// wld_bar OR 1.95
	// wld_any_nopain OR 1.5
	
	* Save
	estimates save "$path8/ukhls_retentionchapt_xtlogit_full_wld_at_t.ster", replace

/* Building up the model III (WLD at t+1)
********************************************	

	* 1. Create WLD at t+1 and its person-mean

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	* wld at t+1 (follow-up)
	capture drop wld_t1
	gen byte wld_t1 = . 
	replace wld_t1 = wld_f if risk_emp_t == 1   // wld_f = f.wld_any_nopain from earlier
	label var wld_t1 "wld at t+1 (follow-up)"

	* (optional) quick check
	tab wld_t1 if risk_emp_t==1, missing

	* person-mean of wld_t1 over the risk set
	capture drop wld_t1_bar
	bysort pidp: egen wld_t1_bar = ///
		mean(cond(risk_emp_t==1, wld_t1, .))
	label var wld_t1_bar "person-mean of wld at t+1 (risk set)"
	
	save "$path2/ukhls_clean.dta", replace
	
	* 2. Simple pooled logit: exit on wld_t1 only
	logit exit_t1 i.wld_t1 if risk_emp_t==1, or
	eststo logit_t1_simple
	// WLD OR 2.65
	
	* 3. Full pooled logit with wld at t+1
	logit exit_t1 i.wld_t1 ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, or
		
	eststo logit_t1_full
	// WLD OR 2.49

	* 3. RE logit (No Mundlak) with wld_t1
	
	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_t1 ///
		c.age c.nkids_dv ///
		i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, re intpoints(7) nolog

		eststo re_t1_no_mundlak
		// wld_t1 OR  (.8647541    1.039667) - unclear direction

	* 4. Full Mundlak/CRE model with WLD_t1
	
	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_t1 ///
		c.wld_t1_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_2_bar ind_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		if risk_emp_t==1, re intpoints(7) nolog

	eststo re_t1_mundlak
	// wld_t1 (within): 0.52
	// wld_t1_bar (between): (0.74, 1.14) - unclear direction
	
		* Save  
	estimates save "$path8/ukhls_retentionchapt_xtlogit_full_wld_at_t1.ster", replace
	
	
	* 5. Full Mundlak model with interactions
	
	xtset pidp wave, yearly

	xtlogit exit_t1 i.wld_t1 ///
		c.wld_t1_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_2_bar ind_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ib3.isic_agg2 ///
		i.wld_t1#(i.jbnssec3_re i.parttime i.fixedterm i.jbsize_re i.privcomp ib3.isic_agg2) ///
		if risk_emp_t==1, re intpoints(7) nolog

	eststo re_t1_mundlak_int
	// WLD*routine and WLD*regular parttime both have p<0.05, but the OR<1. 
	
		* Save  
	estimates save "$path8/ukhls_retentionchapt_xtlogit_full_wld_at_t1_int.ster", replace
	*/
	
* Export final models (WLD at t) 
***********************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

* Pooled logit

	eststo clear
	estimates use "$path8/ukhls_retentionchapt_xtlogit_full_logit_wld_t.ster"

	est restore logit_full_wld

	esttab logit_full_wld ///
		using "$path6/ukhls_retentionchapt_pooled_wldt_or.rtf", replace rtf ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star) ci(fmt(2) par("(" " "))) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		mtitles("Pooled logit (WLD at t)") ///
		stats(N ll aic bic, ///
			  fmt(0 3 2 2) ///
			  labels("N" "LogLik" "AIC" "BIC")) ///
		title("Pooled logistic regression of employment exit t→t+1 (ORs) – UKHLS, WLD at t")

* Export RE logit with Mundlak specification (UKHLS)

	eststo clear
	estimates use "$path8/ukhls_retentionchapt_xtlogit_full_wld_at_t.ster"
	eststo m6_wld_t
	estimates dir
	
	esttab m6_wld_t ///
		using "$path6/ukhls_retentionchapt_relogit_mundlak_wldt_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak (WLD at t)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"1.isic_agg2" "2.isic_agg2" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u" ) ///
		order( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"1.isic_agg2" "2.isic_agg2" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))

*-------------------------------------------------------------------------------
**# Third draft of regression models (13/01/26)
* 	- all vars measured at t
* 	- exit var measured between t and t+1
*	- runs sequential approach (Mundlak terms added in-block)
*	- Exports: 	1) diagnostics csv for all models
*				2) coefficients for full model only
*-------------------------------------------------------------------------------

**# Sequential approach to test model fit
*****************************************

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Ensure estout suite
	capture which estadd
	if _rc ssc install estout, replace

	eststo clear

	*----------------------------------*
	* M0) Baseline
	*   - within: i.wld_any_nopain
	*   - Mundlak: c.wld_bar ONLY
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar ///
		i.wave i.gor_dv ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M0
	estadd scalar LR_prev = .
	estadd scalar df_prev = .
	estadd scalar p_prev  = .
	eststo drop M0
	eststo M0

	*----------------------------------*
	* M1) + Socio-demographics (+ means)
	*   - within: c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re
	*   - Mundlak: c.age_bar c.nkids_bar ms_2_bar ms_3_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar ms_2_bar ms_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M1

	lrtest M0 M1
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M1
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M1
	eststo M1

	*----------------------------------*
	* M2) + Education (+ degree mean)
	*   - within: i.degree
	*   - Mundlak: c.degree_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re ///
		i.degree ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M2

	lrtest M1 M2
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M2
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M2
	eststo M2

	*----------------------------------*
	* M3) + Occupation (+ means)
	*   - within: i.jbnssec3_re
	*   - Mundlak: ns_2_bar ns_3_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree ///
		i.jbnssec3_re ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M3

	lrtest M2 M3
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M3
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M3
	eststo M3

	*----------------------------------*
	* M4) + Contract type (+ means)
	*   - within: i.parttime i.fixedterm
	*   - Mundlak: pt_2_bar pt_3_bar ft_2_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M4

	lrtest M3 M4
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M4
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M4
	eststo M4
	testparm i.parttime i.fixedterm

	*----------------------------------*
	* M5) + Company size & sector (+ means)
	*   - within: i.jbsize_re i.privcomp
	*   - Mundlak: sz_2_bar sz_3_bar sec_2_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm ///
		i.jbsize_re i.privcomp ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M5

	lrtest M4 M5
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M5
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M5
	eststo M5
	testparm i.jbsize_re i.privcomp

	*----------------------------------*
	* M6) + Industry (+ means) [base = 3]
	*   - within: ib3.isic_agg2
	*   - Mundlak: ind_1_bar ind_2_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		ib3.isic_agg2 ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M6

	lrtest M5 M6
	local chi2 = r(chi2)
	local df   = r(df)
	local p    = r(p)
	estimates restore M6
	estadd scalar LR_prev = `chi2', replace
	estadd scalar df_prev = `df',   replace
	estadd scalar p_prev  = `p',    replace
	eststo drop M6
	eststo M6
	testparm ib3.isic_agg2

	*--------------------------------------------*
	* Save models as .ster files (M0–M6 only)
	*--------------------------------------------*
	forvalues k = 0/6 {
		estimates restore M`k'
		estimates save "$path8/ukhls_retentionchapt_xtlogit_M`k'_wld_t_exit_t1_riskemp.ster", replace
	}

	*----------------------------------*
	* Add model titles (for diagnostics table)
	*----------------------------------*
	estadd local modeltitle "M0 Baseline"             , replace : M0
	estadd local modeltitle "M1 +Socdem +means"       , replace : M1
	estadd local modeltitle "M2 +Education +deg_mean" , replace : M2
	estadd local modeltitle "M3 +Occupation +means"   , replace : M3
	estadd local modeltitle "M4 +Contract +means"     , replace : M4
	estadd local modeltitle "M5 +Firm +means"         , replace : M5
	estadd local modeltitle "M6 +Industry +means"     , replace : M6

	*----------------------------------*
	* Export diagnostics CSV
	*----------------------------------*
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/ukhls_retentionchapt_stepwise_fit_wld_t_exit_t1_riskemp.csv", ///
		replace csv ///
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))

**# Final model to export
*****************************

* Export M5 with OR - RE logit Mundlak (before adding industry)

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave
	
	eststo clear
	estimates use "$path8/ukhls_retentionchapt_xtlogit_M5_wld_t_exit_t1_riskemp.ster"
	eststo m5_final_ukhls
	estimates dir
	
	esttab m5_final_ukhls ///
		using "$path6/ukhls_retentionchapt_relogit_mundlak_v3_m5_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak (Final)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u" ) ///
		order( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))
			 
			 
* M5 - Predicted probs for WLD only
************************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

/* If first time: re-run UKHLS M5 + save with estimation sample (for margins) - only ONCE

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	* Re-estimate M5
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm ///
		i.jbsize_re i.privcomp ///
		if risk_emp_t==1, re or intpoints(7) nolog

	* Create & keep an explicit sample marker
	capture drop esamp_M5
	gen byte esamp_M5 = e(sample)

	* Save the estimates to .ster
	estimates save "$path8/ukhls_M5_wld_t_exit_t1_riskemp.ster", replace

	* Strongly recommended: save a dataset copy that includes esamp_M5
	save "$path8/ukhls_clean_with_esamp_M5.dta", replace
	*/
	
	* If repeating in a later session: use saved esample dataset & results

	use "$path8/ukhls_clean_with_esamp_M5.dta", clear
	xtset pidp wave

	estimates use "$path8/ukhls_M5_wld_t_exit_t1_riskemp.ster"
	
	/* Rename sample to make it clear it is UKHLS
	gen byte esamp_M5_uk = esamp_M5   if !missing(esamp_M5)
	* (optional) check they match
	assert esamp_M5_uk == esamp_M5   if !missing(esamp_M5)
	save "$path8/ukhls_clean_with_esamp_M5_uk.dta", replace
	*/

	* Reset e(sample) using the saved indicator
	estimates esample: esamp_m5_uk==1
	
	* Run margins command
	margins, at(wld_any_nopain=(0 1)) post
	estimates store pp_m5_uk
	
	* Export table as rtf (add stars manually)
	esttab pp_m5_uk using "$path6/ukhls_retentionchapt_m5_predprobs.rtf", replace rtf ///
		noobs nonotes nomtitles ///
		cells(b(fmt(3)) ci(fmt(3))) ///
		coeflabels(1._at "No WLD" 2._at "WLD") ///
		title("UKHLS predicted probabilities of exit (Model 5) by WLD status")
	
	* Pairwise comparison of pred probs (add manually to table)
	 estimates restore pp_m5_uk 
	 pwcompare _at, effects post

**# Troubleshooting strange results in M5 (21/01/26)
****************************************************
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave
	
*	1. Inspect full model (including industry)

	estimates use "$path8/ukhls_retentionchapt_xtlogit_M6_wld_t_exit_t1_riskemp.ster"
	eststo m6_uk
	estimates dir
	
	estimates restore m6_uk
	esttab m6_uk ///
		using "$path6/ukhls_retentionchapt_relogit_mundlak_m6_v3_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak (M6 incl industry)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"1.isic_agg2" "2.isic_agg2" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u" ) ///
		order( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "ns_2_bar" "ns_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_nopain" "age" "nkids_dv" "1.degree" ///
			"2.mastat_re" "3.mastat_re" ///
			"2.jbnssec3_re" "3.jbnssec3_re" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize_re" "3.jbsize_re" ///
			"2.privcomp" ///
			"1.isic_agg2" "2.isic_agg2" ///
			"2.sex_dv" "2.ethnic" "3.ethnic" ///
			"2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
			"2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
			"8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))
			 
*	2. Check for MC in model 5
	
	* Without person-means
	regress exit_t1 i.wld_any_nopain ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm ///
		i.jbsize_re i.privcomp ///
		if risk_emp_t==1
		estat vif
		
	* With person-means
		regress exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm ///
		i.jbsize_re i.privcomp ///
		if risk_emp_t==1
		estat vif
		
* 3. Checking number of switchers in the risk set

	* Vars: jbnssec3_re parttime fixedterm jbsize_re privcomp     *
	*       isic_agg2 (industry; not in final model, diagnostic)  *

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave
	
	xttab jbnssec3_re if risk_emp_t==1 // unclear interpretation of within element
	
	/* xttrans seems like a best approach. It only looks at the transitions among
	"stayers" in the risk set - i.e. those who don't exit employment. But that is 
	an appropriate way to approximate change in the employment variables, as it is 
	change PRIOR to an exit that matters anyway. */
	
	foreach v in jbnssec3_re parttime fixedterm jbsize_re privcomp isic_agg2 {
		xttrans `v' if risk_emp_t==1, freq
	}

	* Saved tables manually as "$path6/ukhls_retentionchapt_switchers_`v'.png"
		
**# Interactions
*******************

	use "$path8/ukhls_clean_with_esamp_M5.dta", clear
	xtset pidp wave
	
* Run full model with interactions
	xtlogit exit_t1 i.wld_any_nopain ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		ns_2_bar ns_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.wave i.gor_dv ///
		c.age c.nkids_dv i.sex_dv i.ethnic i.mastat_re i.degree i.jbnssec3_re ///
		i.parttime i.fixedterm i.jbsize_re i.privcomp ///
		i.wld_any_nopain#(i.jbnssec3_re i.parttime i.fixedterm i.jbsize_re i.privcomp) ///
		if risk_emp_t==1, re or intpoints(7) nolog
	
* Name & save model. Also save esample for future use with margins in temp dataset
	est store int_uk
	capture drop esamp_int_uk
	gen byte esamp_int_uk = e(sample)
	estimates save "$path8/ukhls_retentionchapt_xtlogit_interactions_v3.ster", replace
	save "$path8/ukhls_clean_with_esamp_int.dta", replace
	
*-------------------------------------------------------------------------------
**# Fourth draft of regression models - 26/01/26
* - with deviations instead of person means
*-------------------------------------------------------------------------------

* Hybrid / CRE model (means + deviations)
*******************************************
	
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave
	est clear
	
* Run model with odds ratios & export

	xtlogit exit_t1 ///
		c.wld_dev c.wld_bar ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
		ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
		pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
		ft_2_dev ft_2_bar ///
		sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
		sec_2_dev sec_2_bar ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store v4_uk
	
	estimates save "$path8/ukhls_retentionchapt_xtlogit_modelv4_deviations.ster", replace
	
	est restore v4_uk
	esttab v4_uk ///
    using "$path6/ukhls_retentionchapt_relogit_mundlak_v4_dev_or.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (means + deviations)") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar  "Between-person effects (person means)" ///
        wld_dev  "Within-person effects (deviations from person means)" ///
        2.sex_dv "Time-invariant covariates" ///
        2.wave   "Period effects" ///
        2.gor_dv "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))


/* Run predicted probs on WLD while the esample is active
	** doesn't work as wld_any_nopain is no longer in the model 

	* Run margins command
	est restore v4_uk
	margins, at(wld_any_nopain=(0 1)) post
	estimates store pp_v4_uk
	
	* Export table as rtf (add stars manually)
	esttab pp_v4_uk using "$path6/ukhls_retentionchapt_v4_predprobs.rtf", replace rtf ///
		noobs nonotes nomtitles ///
		cells(b(fmt(3)) ci(fmt(3))) ///
		coeflabels(1._at "No WLD" 2._at "WLD") ///
		title("UKHLS predicted probabilities of exit by WLD status (Final model with deviations)")
	
	* Pairwise comparison of pred probs (add manually to table)
	 estimates restore pp_v4_uk
	 pwcompare _at, effects post
*/ 


* Run full model with interactions
***********************************

* Interactions for between effects only
	xtlogit exit_t1 ///
		c.wld_dev ///
		c.wld_bar##( ///
			c.ns_2_bar c.ns_3_bar ///
			c.pt_2_bar c.pt_3_bar ///
			c.ft_2_bar ///
			c.sz_2_bar c.sz_3_bar ///
			c.sec_2_bar) ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		c.ms_2_dev c.ms_2_bar  c.ms_3_dev c.ms_3_bar ///
		c.ns_2_dev c.ns_3_dev ///
		c.pt_2_dev c.pt_3_dev ///
		c.ft_2_dev ///
		c.sz_2_dev c.sz_3_dev ///
		c.sec_2_dev ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store int_uk

* Export only coefficients 	
	esttab int_uk ///
		using "$path6/ukhls_retentionchapt_relogit_mundlak_dev_int_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak: interaction terms") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"c.wld_bar#c.ns_2_bar" "c.wld_bar#c.ns_3_bar" ///
			"c.wld_bar#c.pt_2_bar" "c.wld_bar#c.pt_3_bar" ///
			"c.wld_bar#c.ft_2_bar" ///
			"c.wld_bar#c.sz_2_bar" "c.wld_bar#c.sz_3_bar" ///
			"c.wld_bar#c.sec_2_bar" ///
		) ///
		order( ///
			"c.wld_bar#c.ns_2_bar" "c.wld_bar#c.ns_3_bar" ///
			"c.wld_bar#c.pt_2_bar" "c.wld_bar#c.pt_3_bar" ///
			"c.wld_bar#c.ft_2_bar" ///
			"c.wld_bar#c.sz_2_bar" "c.wld_bar#c.sz_3_bar" ///
			"c.wld_bar#c.sec_2_bar" ///
		) ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))
			 
*********************************************			 
**# Ch7 Diagnostics & Sensitivity analyses 
*********************************************

// Based on 4th iteration of models

* Collinearity
	regress exit_t1 ///
		c.wld_dev c.wld_bar ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
		ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
		pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
		ft_2_dev ft_2_bar ///
		sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
		sec_2_dev sec_2_bar ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		if risk_emp_t==1
	estat vif
	// Looks OK

* Sensitivity to number of integration points 

	xtlogit exit_t1 ///
		c.wld_dev c.wld_bar ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
		ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
		pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
		ft_2_dev ft_2_bar ///
		sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
		sec_2_dev sec_2_bar ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store v4_uk
	
	quadchk 12 20, nofrom

* Sensitivity to weighting / balanced panel
*********************************************

/* 
- Rather than creating a separate risk set from the balanced panel, I just apply
longitudinal weights for waves 1-10 in the (tested) assumption that this will 
impose a balanced panel. 
- However, it is not possible to combine svyset with xtlogit, so I can only use 
probability weights, not for complex survey design (clustering or strata)
- In fact, the random effects option in xtlogit only allows "importance weights" 
(iweights)
*/

* Load data & apply longtiudinal weights
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

	svyset, clear
	svyset psu [pweight=mylw_indscus], strata(strata) singleunit(scaled)

* Run model with odds ratios & export

	xtlogit exit_t1 ///
		c.wld_dev c.wld_bar ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
		ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
		pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
		ft_2_dev ft_2_bar ///
		sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
		sec_2_dev sec_2_bar ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		[iweight=mylw_indscus] ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store uk_iweight
	
* Export table with same format as main analyses
	esttab uk_iweight ///
    using "$path6/ukhls_retentionchapt_relogit_mundlak_sensitivity_iweight.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (means + deviations) with iweights") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar  "Between-person effects (person means)" ///
        wld_dev  "Within-person effects (deviations from person means)" ///
        2.sex_dv "Time-invariant covariates" ///
        2.wave   "Period effects" ///
        2.gor_dv "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Sensitivity to removing education from models
**************************************************

// In the unbalanced and unweighted models

* Load data
	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave

* Run model with odds ratios removing education

	xtlogit exit_t1 ///
		c.wld_dev c.wld_bar ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
		ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
		pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
		ft_2_dev ft_2_bar ///
		sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
		sec_2_dev sec_2_bar ///
		i.wave i.gor_dv ///
		i.sex_dv i.ethnic ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store uk_noed
	
* Export table
	esttab uk_noed ///
    using "$path6/ukhls_retentionchapt_relogit_mundlak_sensitivity_noed.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (means + deviations) without education") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar  "Between-person effects (person means)" ///
        wld_dev  "Within-person effects (deviations from person means)" ///
        2.sex_dv "Time-invariant covariates" ///
        2.wave   "Period effects" ///
        2.gor_dv "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Sensitivity to measures of disability
*****************************************

// In the unbalanced and unweighted models

* First need to create variables for person-means and deviations

	use "$path2/ukhls_clean.dta", clear
	xtset pidp wave, yearly

	* Drop existing person-means and deviations if they already exist
	capture drop health_re_bar
	capture drop eadis_bar
	capture drop health_re_dev
	capture drop eadis_dev

	* Person-means calculated over the employee risk set
	bysort pidp: egen health_re_bar = mean(cond(risk_emp_t == 1, health_re, .))
	bysort pidp: egen eadis_bar     = mean(cond(risk_emp_t == 1, eadis, .))

	* Personal deviations from person-mean
	gen health_re_dev = health_re - health_re_bar if risk_emp_t == 1
	gen eadis_dev     = eadis - eadis_bar if risk_emp_t == 1

	* save variables for future ref
	save "$path2/ukhls_clean.dta", replace
	
* Long-standing impairment

	* Load data 
		use "$path2/ukhls_clean.dta", clear
		xtset pidp wave

	* Run model with odds ratios & export

		xtlogit exit_t1 ///
			c.health_re_dev c.health_re_bar ///
			c.age_dev c.age_bar ///
			c.nkids_dev c.nkids_bar ///
			c.degree_dev c.degree_bar ///
			ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
			ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
			pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
			ft_2_dev ft_2_bar ///
			sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
			sec_2_dev sec_2_bar ///
			i.wave i.gor_dv ///
			i.sex_dv i.ethnic ///
			if risk_emp_t==1, re or intpoints(7) nolog
		est store uk_health
		
	* Export table
	esttab uk_health ///
    using "$path6/ukhls_retentionchapt_relogit_mundlak_sensitivity_health.rtf", replace rtf ///
    mtitles("RE logit + Mundlak with long-standing impairment") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "health_re_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "health_re_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "health_re_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "health_re_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        health_re_bar  "Between-person effects (person means)" ///
        health_re_dev  "Within-person effects (deviations from person means)" ///
        2.sex_dv "Time-invariant covariates" ///
        2.wave   "Period effects" ///
        2.gor_dv "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
	
* Impairment & activity limitation ("Equality Act")

	* Load data 
		use "$path2/ukhls_clean.dta", clear
		xtset pidp wave

	* Run model with odds ratios & export

		xtlogit exit_t1 ///
			c.eadis_dev c.eadis_bar ///
			c.age_dev c.age_bar ///
			c.nkids_dev c.nkids_bar ///
			c.degree_dev c.degree_bar ///
			ms_2_dev ms_2_bar  ms_3_dev ms_3_bar ///
			ns_2_dev ns_2_bar  ns_3_dev ns_3_bar ///
			pt_2_dev pt_2_bar  pt_3_dev pt_3_bar ///
			ft_2_dev ft_2_bar ///
			sz_2_dev sz_2_bar  sz_3_dev sz_3_bar ///
			sec_2_dev sec_2_bar ///
			i.wave i.gor_dv ///
			i.sex_dv i.ethnic ///
			if risk_emp_t==1, re or intpoints(7) nolog
		est store uk_eadis
		
	* Export table
	esttab uk_eadis ///
    using "$path6/ukhls_retentionchapt_relogit_mundlak_sensitivity_eadis.rtf", replace rtf ///
    mtitles("RE logit + Mundlak with impairment & activity limitation") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "eadis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "eadis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "eadis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "ns_2_bar" "ns_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "eadis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "ns_2_dev" "ns_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex_dv" "2.ethnic" "3.ethnic" ///
        "2.wave" "3.wave" "4.wave" "5.wave" "6.wave" "7.wave" "8.wave" "9.wave" ///
        "2.gor_dv" "3.gor_dv" "4.gor_dv" "5.gor_dv" "6.gor_dv" "7.gor_dv" ///
        "8.gor_dv" "9.gor_dv" "10.gor_dv" "11.gor_dv" "12.gor_dv" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        eadis_bar  "Between-person effects (person means)" ///
        eadis_dev  "Within-person effects (deviations from person means)" ///
        2.sex_dv "Time-invariant covariates" ///
        2.wave   "Period effects" ///
        2.gor_dv "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
	