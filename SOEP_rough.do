STOP
////////////////////////////////////////////////////////////////////////////////
//							SOEP all syntax	 					
////////////////////////////////////////////////////////////////////////////////
/*
Date created: 02/06/23
Date last edited: 18/08/26
Author: Clara Mascaro
Description: All syntax for analysis of SOEP data
Sections
	1. Assembling dataset
	2. Variable management
	3. Select sample
	4. Operationalisation chapter
*/
********************************************************************************
**# 		1. ASSEMBLING DATASET							
********************************************************************************

* Open all relevant datasets and make sure they are sorted by pid and syear
// already sorted and saved

/*Start with ppathl & keep all vars
use "$path1/soep/ppathl.dta", clear

*Add variables from pgen
merge 1:1 pid syear using "$path1/soep/pgen.dta", keepusing(pid syear pgfamstd ///
	pgisco88 pgisco08 pgerljob pglabgro pglabnet pgisced11 pgisced97 pgcasmin ///
	pgemplst pglfs pgjobch pgjobend pgvebzeit pgtatzeit pgbetr pgallbet pgnace ///
	pgnace2 pgerwzeit pgoeffd) ///
	keep(master match) nogen
	// keeps unmatched from ppathl

*Add variables from pl
merge 1:1 pid syear using "$path1/soep/pl.dta", keepusing(pid syear ple0040 ple0041 ///
	ple0036 ple0009 plb0018 plb0037_v3 plb0041 plb0187_v2 plb0635 plb0049_v6 ///
	plb0211 plh0173 plb0586 plb0568_v1 plb0568_v2 plb0057_v3 plb0570 plb0064_v2 ///
	ple0031 ple0032 ple0033 ple0034 ple0030) ///
	keep(master match) nogen

* Add variables from pequiv
merge 1:1 pid syear using "$path1/soep/pequiv.dta", keepusing(pid syear d11107 m11102 ///
	m11113 m11114 m11115 m11116 m11117 m11118 m11119 m11120 m11121 m11124 m11125 m11126 ///
	m11109) keep(master match) nogen

*Add variables from hgen // many to one matching
merge m:1 hid syear using "$path1/soep/hgen.dta", keepusing(hid syear hgtyp1hh hgowner ///
	hghinc) keep(master match) nogen
	/* some from ppathl unmatched - all with netto>17 and mainly people/children in 
	'non-completed households' and ppl who have moved abroad or died. 
	
	Federal State - hgnuts1 - missing. Code is -7: Only available in less restricted edition*/

* Add variables from design (weighting variables)
	// does not have pid or syear - use cid to merge
merge m:1 cid using "$path1/soep/design.dta", keepusing(cid psu strat design) keep(master match) nogen
	/* 293 unmatched from ppathl - majority (175) in 'non-completed households' in 2018.
	Only a few with netto==10 or 12 and syear>2009, corresponding to 2 cid's only:
	213233, 2303232 and 2335460. Keep in dataset for now but drop if necessary. */
	
* Save combined datafile
compress
save "$path8/soep_assembled.dta", replace
*/

********************************************************************************
**# 		2. DATA MANAGEMENT - MISSING DATA, RE-CODING & IMPUTATION
********************************************************************************
* 	If working on new data, open sample from temp folder
	use "$path8/soep_assembled.dta", clear

* 	If making changes to clean data, open latest clean dataset
	use "$path2/soep_clean.dta", clear

* 	Declare to be panel data
	sort pid syear
	xtset pid syear
	xtdes
	xtsum syear

* 	keep survey years 2010-2019
	keep if syear>=2010 & syear<=2019
	
*-------------------------------------------------------------------------------
**# INSPECTING MISSING DATA
*-------------------------------------------------------------------------------	

* 	Chronic illness
	tab ple0036
	tab syear ple0036
	tab syear ple0036, row nofreq
		// 2011 & 2013: only aked of small propotion respondents
		// 2015, 2017, 2019: not included at all in questionnaire
		// ie only vailable 2010, 2012, 2014, 2016, 2018 (even years)
	mvdecode ple0036, mv(-1/-8)
	
* 	Officially disabled
	tab ple0040 // few missing
	mvdecode ple0040, mv(-1/-8)

* 	Degree of official disability
	tab ple0041 // 83.06 not applicable as filtered by previous Q
	mvdecode ple0041, mv(-1/-8)
	
* 	Disability Status of Individual (from pequiv)
	tab m11124, mis
	tab syear m11124, mis
	tab syear m11124, mis row nofreq
	mvdecode m11124, mv(-1/-8)

* 	Functional limitations
	tab ple0009
	tab syear ple0009, row nofreq // missing 2010, 2014, 2016, 2018
	mvdecode ple0009, mv(-1/-8)	

* 	Work Limiting Disability
	tab syear ple0030, row nofreq 
	// missing 2011, 2013, 2015, 2017, 2019; over 25% missing in 2010 & 2012
	// but NB ple0030 is about pain but doesn't mention work at all 
	tab syear ple0031, row nofreq	
	tab syear ple0032, row nofreq
	tab syear ple0033, row nofreq	
	tab syear ple0034, row nofreq
	// same for the rest
	mvdecode ple0031 ple0032 ple0033 ple0034, mv(-1/-8)
	
* 	Employed variable
	tab pgemplst 
	// 0.00-.0.01% missing
	tab plb0018
	// 2.79% [-5] Not included in this version of the questionnaire 
	tab pglfs
	// barely any mssing (14 cases, 0.00%)
	mvdecode pgemplst plb0018 pglfs, mv(-1/-10)

* 	Inspect occupation variable - isco:
	// ISCO88 (COM) 2010-2017
	sum pgisco88, detail
	mean pgisco88, over(syear)
	tab pgisco88 if syear>2017
	// 2018 & 2019: all cases = -8. Only available 2010-2017
	tab pgisco88 if syear<2018
	// 44% not applicable [-2]. Code inapplicable as .a for now. 
	mvdecode pgisco88, mv(-1 -8=. \ -2=.a)
	tab pgisco88, mis
		
	// ISCO08 2013-2019
	sum pgisco08, detail
	mean pgisco08, over(syear)
	tab pgisco08 if syear<2013
	tab pgisco08 if syear>2012
	// 45% not applicable. Code inapplicable as .a for now.  
	mvdecode pgisco08, mv(-1 -8=. \ -2=.a)
	// slightly diff values to isco88
	mean pgisco08, over(syear)

* Inspect self-employed vars
	// can derive from pgbetr
	tab pgbetr
	// 42% not applicable [-2]. Code as extended missing (.a). 
	mvdecode pgbetr, mv(-1=. \ -2=.a)
	tab pgbetr, mis
	gen sempl=.
	replace sempl=1 if pgbetr==11
	replace sempl=0 if pgbetr!=11 & pgbetr!=.
	replace sempl=.a if pgbetr==.a
	label var sempl "Self-employed status"
	label val sempl dummy
	tab sempl, mis

* Inspect working time vars and mvdecode (already done so for pgemplst)
	sum pgvebzeit pgtatzeit, detail
	tab pgvebzeit
	// 51% not applicable [-2]
	tab pgtatzeit
	// 41% not applicable
	mvdecode pgvebzeit pgtatzeit, mv(-1 -3=. \-2=.a)
	tab pgvebzeit, mis
	tab pgtatzeit, mis

* Fixed-term contract dummy
	tab plb0037_v3
	/* 	45% [-2] inapplicable
		3.6% [3] N/A no employment contract
		Code both as inapplicable. */
	mvdecode plb0037_v3, mv(-1 -6 =. \ -2 3 =.a)	

*  Temp agency
	tab plb0041
	mvdecode plb0041, mv(-1 -6 3=. \ -2 = .a)
	
* Education
	/* use isced-11 classification and collapse categories to match Kaiser (2016). 
	Doesn't distinguish between academic or vocational but create a separate
	dummy var for that using CASMIN. */
	tab pgisced11
	tab pgcasmin	// CASMIN has more missing
	mvdecode pgisced11 pgcasmin, mv(-1/-8)
	tab pgisced11 pgcasmin, mis
	
* ISIC 2010-2017
	tab pgnace
	tab syear pgnace if pgnace<0
	tab pgnace if syear<2018
	/* variable not asked in 2018 & 2019. 44% not applicable. */
	mvdecode pgnace, mv(-8 -1=. \ -2=.a)

* ISIC 2018-2019
	tab pgnace2
	tab syear pgnace2 if pgnace2<0
	/* variable asked from 2013. */
	mvdecode pgnace2, mv(-8 -1=. \ -2=.a)
	tab pgnace2, mis

* Public/private sector
	// Variable exists already
	tab pgoeffd
	// 41% inapplicable
	mvdecode pgoeffd, mv(-1 =. \ -2=.a)
	tab pgoeffd, missing

* Age
	tab piyear, mis
	tab gebjahr, mis
	mvdecode piyear gebjahr, mv(-1/-8)
	
* Gender
	tab sex
	mvdecode sex, mv(-1/-8)
	tab sex, mis

* Marital status
	tab pgfamstd
	mvdecode pgfamstd, mv(-1/-8)
	tab pgfamstd, mis

* Housing tenure
	tab hgowner
	tab syear hgowner
	mvdecode hgowner, mv(-1/-8)
	tab hgowner, mis 

* East/West
	tab sampreg
	mvdecode sampreg, mv(-2)
	tab sampreg, mis

* Houshehold income
	sum hghinc, detail
	tab hghinc if hghinc<0
	mvdecode hghinc, mv(-1/-8)

* Job satisfaction
	// 7 categories in UKHLS, scale of 1-10 in SOEP. OK as only control. 
	tab plh0173
	// 31% inapplicable
	mvdecode plh0173, mv(-1 -5=. \ -2=.a)

* Severity of impairment/functional limitation
	// For model with officially disabled use degreedis_c as control
	
	// Otherwise, use number of functional limitations reported (as in UKHLS)?
	tab m11113
	// 31% inapplicable
	tab syear m11113 // missing 2011, 2013, 2015 - impute from previous year
	tab syear m11114 // all missing
	tab syear m11115 // very small numbers
	tab syear m11116 // very small numbers
	tab syear m11117 // very small numbers
	tab syear m11118 // all missing
	tab syear m11119 // very small numbers
	tab syear m11120 // all missing
	tab syear m11121 // all missing
	// too many missing for it to work. 

* Number of nights in hospital
	tab m11102
	tab syear m11102 if m11102<0
	// more missing 2013-2019 due to question not being asked [-5]. 
	mvdecode m11102, mv(-1/-8)
	sum m11102, detail
	// OK & also included in UKHLS
	
* Current self-rated health
	tab m11126
	mvdecode m11126, mv(-1/-8)
	tab m11126, mis
	// OK & also included in UKHLS
	
* Satisfaction with health
	tab m11125
	tab syear m11125 if m11125<0
	// some inconsistencies in [-5] worth inspecting if I end up using this var
	mvdecode m11125, mv(-1/-8)
	tab m11125, mis

* Type of impairment
*	Mental health ("Psychiatric problems")
	tab m11109, mis
	tab syear m11109, mis // missing in 2010, 2012, 2014, 2016, 2018
	mvdecode m11109, mv(-1/-8)
	tab m11109, mis

save "$path8/soep_mvdecoded.dta", replace

*-------------------------------------------------------------------------------
**# RE-CODING VARS
*-------------------------------------------------------------------------------

use  "$path8/soep_mvdecoded.dta", clear 

* 	Declare to be panel data
	sort pid syear
	xtset pid syear
	xtdes
	xtsum syear

* 	Turn WLD into 4 binary measures
	label list ple0031
	/* Labels match those for UK variables
			   1 [1] Immer
			   2 [2] Oft
			   3 [3] Manchmal
			   4 [4] Fast nie
			   5 [5] Nie */

*	physical wld - amount
	recode ple0031 (1/2=1) (3/5=0), gen(physamount)
	label val physamount dummy
	label var physamount "physical health limits amount of work"
	tab ple0031 physamount

* 	physical wld - kind
	recode ple0032 (1/2=1) (3/5=0), gen(physkind)
	label val physkind dummy
	label var physkind "physical health limits kind of work"
	tab ple0032 physkind

*	mental wld - amount
	recode ple0033 (1/2=1) (3/5=0), gen(menamount)
	label val menamount dummy
	label var menamount "mental health meant accomplished less"
	tab ple0033 menamount

*	mental wld - care
	recode ple0034 (1/2=1) (3/5=0), gen(mencare)
	label val mencare dummy
	label var mencare "mental health meant worked less carefully"
	tab ple0034 mencare

/* 	Collapse into 2 binary measures
* 	WLD-physical:
	gen wld_phys=.
	replace wld_phys=1 if physamount==1 | physkind==1
	replace wld_phys=0 if physamount==0 & physkind==0
	label val wld_phys dummy
	label var wld_phys "Physical work limitation"
	tab wld_phys

*	WLD-mental:
	gen wld_men=.
	replace wld_men=1 if menamount==1 | mencare==1
	replace wld_men=0 if menamount==0 & mencare==0
	label val wld_men dummy
	label var wld_men "Mental work limitation"
	tab wld_men
*/

*	Syntax that combines the previous two steps in one - neater but cannot perform descriptives
*	WLD-physical:
	gen wld_phys=.
	replace wld_phys=1 if (ple0031!=. & ple0031<=2) | (ple0032!=. & ple0032<=2)
	replace wld_phys=0 if (ple0031!=. & ple0031>2) & (ple0032!=. & ple0032>2)
	label var wld_phys "Physical WLD"
	label val wld_phys dummy
	tab wld_phys, mis

*	WLD-mental:
	tab ple0033 ple0034, mis
	label list ple0033 // same as for physical
	gen wld_men=.
	replace wld_men=1 if (ple0033!=. & ple0033<=2) | (ple0034!=. & ple0034<=2)
	replace wld_men=0 if (ple0033!=. & ple0033>2) & (ple0034!=. & ple0034>2)
	label var wld_men "Mental/emotional WLD"
	label val wld_men dummy
	tab wld_men, mis

* 	Collapse into a single WLD measure EXCLUDING PAIN - crude approach
	gen wld_any=.
	replace wld_any=1 if wld_phys==1 | wld_men==1
	replace wld_any=0 if wld_phys==0 & wld_men==0
	label var wld_any "Any WLD"
	label val wld_any dummy
	tab wld_any, mis
	// very high missing %, over 50%
	tab syear wld_any, mis
	// due to variable only being asked every other year

* 	Chronic illness - recode to dummy var with 0 and 1 values
	label list ple0036
	recode ple0036 (1 = 1 "Yes") (2 = 0 "No") (. = .), gen(chronic) label(dummy)
	tab chronic, mis

* 	Officially disabled
	// recode to dummy var with 0 and 1 values
	recode ple0040 (1 = 1 "Yes") (2 = 0 "No") (. = .), gen(legaldis)
	tab legaldis, mis
	
* 	Degree of official disability
	rename ple0041 degreedis_c
	label var degreedis_c "Degree of officially recognised disability"

	// Severely disabled	
	gen degreedis50=. // group categories into under and over 50
	replace degreedis50=1 if degreedis_c!=. & degreedis_c<50
	replace degreedis50=2 if degreedis_c!=. & degreedis_c>=50
	replace degreedis50=3 if degreedis_c==. & legaldis==0
	label define degreedis50_lab 1 "Under 50" 2 "50 or over" 3 "No recognised disability"
	label val degreedis50 degreedis50_lab
	tab degreedis50, mis
	
	// 30% or over
	gen degreedis30=. // group categories into under and over 30
	replace degreedis30=1 if degreedis_c<30
	replace degreedis30=2 if degreedis_c>=30
	replace degreedis30=3 if degreedis_c==. & legaldis==0
	label define degreedis30_lab 1 "Under 30" 2 "30 or over" 3 "No recognised disability"
	label val degreedis30 degreedis30_lab
	tab degreedis30, mis // none missing - all degreedis_c reassigned to degreedis30=3
	
* 	Disability Status of Individual (from pequiv)
	tab m11124, mis
	tab m11124 degreedis30, mis
	tab degreedis_c m11124, mis
	rename m11124 distat

* 	Functional limitations in activities of daily life (ADL)
	rename ple0009 adl


*-------------------------------------------------------------------------------
**# Re-coding employment vars
*-------------------------------------------------------------------------------

* 	Employed variable
***********************

	*------------------------------------------------------------
	* SOEP: Employed indicator (fixed to protect sheltered)
	* Sources: pgemplst (gatekeeper) + pglfs (detail)
	* Target: employed  (0/1)
	* Design:
	*   Employed by pgemplst: {1 FT, 2 PT, 3 Vocational, 4 Marginal/mini, 7 Short-time}
	*   Employed by pglfs:    {11 Working, 12 Working but inactive past 7 days}
	*   NOT employed:         {5 Not employed, 6 Sheltered workshop}
	*   Parental/maternity leave (pglfs==4): NOT employed (conservative)
	* Precedence: Sheltered (pgemplst==6) must never be flipped to employed.
	*------------------------------------------------------------

	capture drop employed
	gen byte employed = .

	* 0) HARD RULE: Sheltered workshop is NOT employed (lock this in)
	replace employed = 0 if pgemplst == 6

	* 1) Clear not-employed per gatekeeper (but don't overwrite sheltered rule)
	replace employed = 0 if missing(employed) & pgemplst == 5

	* 2) Employed by pgemplst types
	replace employed = 1 if missing(employed) & inlist(pgemplst, 1, 2, 3, 4, 7)

	* 3) Employed by pglfs attachment (EXCLUDE sheltered from being flipped)
	replace employed = 1 if missing(employed) & inlist(pglfs, 11, 12) & pgemplst != 6

	* 4) Parental/maternity leave: NOT employed (conservative)
	replace employed = 0 if pglfs == 4

	capture label drop employed_lab
	label define employed_lab 0 "Not employed" 1 "Employed"
	label values employed employed_lab
	label var employed "Employed (SOEP; sheltered=not employed, parental leave=not employed)"

	* Checks
	tab employed, mis
	tab pgemplst pglfs, missing
	tab pgemplst employed, mis
	tab pglfs employed, mis
	
	* Checking how many employed cases overwritten by the parental leave rule
	count if pglfs==4 & inlist(pgemplst,1,2,3,4,7)
	tab pgemplst if pglfs==4, missing
	
	* Sheltered must always be employed==0
	tab pgemplst employed if pgemplst==6, m

* Non-employment variable
**************************

	/*------------------------------------------------------------
	  SOEP: Non-employment variable — UPDATED VERSION (WITH MAT/PL)
	  Sources: pgemplst (gatekeeper) + pglfs (detail)
	  Target: nonemp
	  Design choices:
		- Vocational training (pgemplst==3) -> 0 (inapplicable/employed) [unchanged]
		- Parental/Maternity leave (pglfs==4) -> NEW CATEGORY (nonemp==4)   <-- CHANGED
		- Long-term sick/disabled category not separately identified here (UK-only label dropped) 
	------------------------------------------------------------*/

	capture label drop nonemp_lab
	label define nonemp_lab ///
		0 "Inapplicable (employed / out of scope)" ///
		1 "Unemployed" ///
		2 "Education or training" ///
		3 "Care of family/home" ///
		4 "Maternity/parental leave" ///                          // <-- CHANGED (new category)
		5 "Sheltered workshop (DE-only)" ///
		6 "Other non-employed"

	capture drop nonemp
	gen byte nonemp = .

	* --- 5. Sheltered workshop (DE-only) ---
	* Primary signal: pgemplst==6 (Werkstatt). Also catch detail pglfs==7 if it exists in some waves.
	replace nonemp = 5 if pgemplst==6
	replace nonemp = 5 if missing(nonemp) & pgemplst==5 & pglfs==7

	* --- 1. Unemployed ---
	replace nonemp = 1 if missing(nonemp) & pgemplst==5 & pglfs==6

	* --- 2. Education or training ---
	replace nonemp = 2 if missing(nonemp) & pgemplst==5 & pglfs==3

	* --- 3. Care of family/home ---
	replace nonemp = 3 if missing(nonemp) & pgemplst==5 & pglfs==2

	* --- 4. Maternity/parental leave ---
	replace nonemp = 4 if missing(nonemp) & pgemplst==5 & pglfs==4       // <-- CHANGED (was -> 0)

	* --- 6. Other non-employed (residual among non-employed with a detail) ---
	replace nonemp = 6 if missing(nonemp) & pgemplst==5 & !missing(pglfs)

	* --- 0. Inapplicable (employed / out of scope) ---
	* Do NOT overwrite sheltered (pgemplst==6); guard with missing(nonemp).
	replace nonemp = 0 if missing(nonemp) & inlist(pgemplst,1,2,3,4,7)
	replace nonemp = 0 if missing(nonemp) & inlist(pglfs,11,12) & pgemplst!=6

	* NOTE: removed "pglfs==4 -> 0" line because pglfs==4 now maps to nonemp==4  <-- CHANGED

	label values nonemp nonemp_lab
	numlabel, add

	* Quick checks
	tab pgemplst nonemp, m
	tab pglfs    nonemp, m

	* Should now equal sheltered employment count (allowing for missing detail)
	count if pgemplst==6
	display r(N) " expected sheltered cases"

	tab nonemp if nonemp==5, m

	* Cross-tab to confirm nothing overwrote sheltered:
	tab pgemplst nonemp if pgemplst==6, m
	tab pglfs    nonemp if pgemplst==6, m

	/*------------------------------------------------------------
	* SOEP: Non-employment variable - OLD VERSION - NO MAT LEAVE CATEGORY
	* Sources: pgemplst (gatekeeper) + pglfs (detail)
	* Target: nonemp_re
	* Design choices:
	*   - Vocational training (pgemplst==3) -> 0 (inapplicable/employed)
	*   - Parental/Maternity leave (pglfs==4) -> 0 (inapplicable)
	*------------------------------------------------------------

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
	gen byte nonemp = .

	* --- 5. Sheltered workshop (DE-only) ---
	* Primary signal: pgemplst==6 (Werkstatt). Also catch detail pglfs==7 if it exists in some waves.
	replace nonemp = 5 if pgemplst==6
	replace nonemp = 5 if missing(nonemp) & pgemplst==5 & pglfs==7

	* --- 1. Unemployed ---
	replace nonemp = 1 if missing(nonemp) & pgemplst==5 & pglfs==6

	* --- 2. Education or training ---
	replace nonemp = 2 if missing(nonemp) & pgemplst==5 & pglfs==3

	* --- 3. Care of family/home ---
	replace nonemp = 3 if missing(nonemp) & pgemplst==5 & pglfs==2

	* --- 6. Other non-employed (residual among non-employed with a detail) ---
	replace nonemp = 6 if missing(nonemp) & pgemplst==5 & !missing(pglfs)

	* --- 0. Inapplicable (employed / out of scope) ---
	* Do NOT overwrite sheltered (pgemplst==6); guard with missing(nonemp).
	replace nonemp = 0 if missing(nonemp) & inlist(pgemplst,1,2,3,4,7)
	replace nonemp = 0 if missing(nonemp) & inlist(pglfs,11,12) & pgemplst!=6
	replace nonemp = 0 if missing(nonemp) & pglfs==4   // parental/maternity leave by design

	label values nonemp nonemp_lab
	numlabel, add

	* Quick checks
	tab pgemplst nonemp, m
	tab pglfs    nonemp, m
	
	* Should now equal sheltered employment count (allowing for missing detail)
	count if pgemplst==6
	display r(N) " expected sheltered cases"

	tab nonemp if nonemp==5, m

	* Cross-tab to confirm nothing overwrote sheltered:
	tab pgemplst nonemp if pgemplst==6, m
	tab pglfs    nonemp if pgemplst==6, m
	*/

	
* Employment loss
******************

// Between consecutive years (at-risk only; latest version)

	* Set panel structure
	xtset pid syear, yearly
	sort pid syear

	* Build explicit lags
	capture drop L_employed L_syear
	gen L_employed = L.employed
	gen L_syear  = L.syear

	* Consecutive year
	capture drop consec
	gen byte consec = (syear == L_syear + 1)

	* At risk: employed last year AND consecutive
	capture drop atrisk
	gen byte atrisk = (L_employed == 1 & consec == 1)

	* Outcome
	capture drop emploss
	gen byte emploss = .
	replace emploss = 1 if atrisk & employed == 0   // exit 1→0
	replace emploss = 0 if atrisk & employed == 1   // retain 1→1

	capture label drop emploss_lb
	label define emploss_lb 0 "Retained employment" ///
						1 "Employment loss", replace
	label values emploss emploss_lb
	label var emploss "Employment loss between consecutive years"

	* Check
	list pid syear employed L_employed consec atrisk emploss in 1/50 if netto<=19


*-------------------------------------------------------------------------------
**#		Occupation: recode to ESeC
*-------------------------------------------------------------------------------
/* 	ESeC user guide: https://www.iser.essex.ac.uk/archives/esec. See also 
	Rose and Harrison (2007). Using iscogen package: 
	https://ideas.repec.org/c/boc/bocode/s458665.html */

ssc install iscogen, replace
help iscogen

* Simplified ESeC
******************
* 	2010-2017, isco88 (com) to esec1
	tab pgisco88, mis
	iscogen esec1 = esec(pgisco88), from(isco88) emissing
	iscolbl esec esec1 // assigns labels
	tab esec1 if syear<=2017, mis 
		// same number of missing as in pgisco88
		// 9-class ESEC
		// "inapplicable" kept as .a
	tab esec1 if syear>2017 
	// no observations
	
* 	2013-2019 isco08 to esec2
	tab pgisco08, mis
	iscogen esec2 = esec(pgisco08), from(isco08) emissing
	iscolbl esec esec2
	tab esec2, mis
	tab esec2 if syear>=2013, mis 
	tab esec2 if syear<2013, mis

* 	Compare the two for overlapping years
	numlabel, add
	tab esec1 esec2 if syear==2013, row mis
	/* esec2 has no category 4 (small employers & self-employed excl agriculture) 
	OR category 5 (self-employed agrictulture). Suggests the simplified method
	does not work with ISCO08. Indeed user guide is based on ISCO88 COM. */
	
* 	Rename vars
	rename esec1 esec_sim88
	rename esec2 esec_sim08
	
* Full ESeC 
*************

* 	Use self-employed dummy already created
	
* 	Create supervisory variable (supvis)
	/* from help iscogen: supvis indicates that a respondent has supervisory status 
	and, possibly,	specifies the number of subordinates or employees. 
	If sempl!=0: relevant distinctions for supvis are 0 vs. 1-9 vs. 10 or more 
	(although note that the resulting ESEC classes will be the same for 0 and 1-9). */
 	gen supvis=.
	replace supvis=0 if (plb0570==1 | plb0570==-2) & syear>=2014
	replace supvis=9 if plb0570==2 & syear>=2014
	replace supvis=10 if plb0570==3 & syear>=2014
	replace supvis=0 if (plb0057_v3==-2 | plb0057_v3==1 | plb0057_v3==2 | ///
	plb0057_v3==3) & syear<2014
	replace supvis=9 if plb0057_v3==4 & syear<2014
	replace supvis=10 if plb0057_v3==5 & syear<2014
	tab syear supvis, mis
	label var supvis "Number of employees for ESeC"

* 2010-2017, isco88 (com) to ESeC
	tab pgisco88 if syear<=2017, mis
	iscogen esec_full88 = esec(pgisco88 sempl supvis), from(isco88) emissing
	iscolbl esec esec_full88
	tab esec_full88 if syear<=2017, mis // same missing as pgisco88	
	tab esec_full88 if syear>2017 // no observations

* 2013-2019 isco08 to ESeC
	tab pgisco08 if syear>=2013
	iscogen esec_full08 = esec(pgisco08 sempl supvis), from(isco08) emissing
	iscolbl esec esec_full08
	tab esec_full08 if syear>=2013, mis // has all categories, unlike esec_sim08
	tab esec_full08 if syear<2013, mis // 38,772 missing
	tab syear esec_full08, mis

* Compare simple & full measures
	numlabel, add
	tab esec_sim88 esec_full88, row mis
	// very high degree of consistency
	// differences are mainly for employers (as expected by more info on self-emp)
	tab esec_sim08 esec_full08, row mis
	// high consistency

* Compare full measures with isco88 and isco08 for overlapping years
	tab esec_full88 esec_full08 if syear>=2013 & syear<=2017, mis row
		// quite a lot of discrepancy, especially for category 6 (lower supervisors)
	list pid syear esec_full88 esec_full08 in 1/50, compress

* Combine into single measure, acknowledging break in series
	// User guide for ESeC based on ISCO88 (COM) so use that for 2010-2017
	// Break on 2018 (the last baseline syear)
	// Could consider dropping 2019 to make 2017 the last baseline wave.
	tab esec_full88 if syear<=2017, mis
	tab esec_full08 if syear>2017, mis
	gen esec_full=.
	replace esec_full=esec_full88 if syear<=2017
	replace esec_full=esec_full08 if syear>2017
	label values esec_full esec_full88
	label var esec_full "Final ESeC classification"
	tab esec_full, mis

* Drop full ESeC for specific years
	drop esec_full88 esec_full08
	
* Drop simple measures (but keep code)
	drop esec_sim88 esec_sim08

* Collapse categories 4 & 5 of ESeC and recode inapplicable
	tab esec_full, mis
	recode esec_full (1=1) (2=2) (3=3) (4/5=4) (6=5) (7=6) (8=7) (9=8) (.a=0) (.=.), ///
	gen(esec_short)
	label define esec_short ///
	0 "Inapplicable" ///
	1 "Large employers, higher mgrs/professionals" ///
	2 "Lower mgrs/professionals, higher supervisory/technicians" ///
	3 "Intermediate occupations" ///
	4 "Small employers and self-employed" ///
	5 "Lower supervisors and technicians" ///
	6 "Lower sales and service" ///
	7 "Lower technical" ///
	8 "Routine"
	label val esec_short esec_short
	label var esec_short "Collapsed full ESeC"
	tab esec_short, mis
	
* Re-code into 3-class ESeC
	tab esec_full, mis
	recode esec_full (.a=0) (1 2 = 1) (3/6 = 2) (7/9 = 3), gen(esec3)
	label define esec3 ///
	0 "Inapplicable" ///
	1 "Salariat" ///
	2 "Intermediate" ///
	3 "Working class"
	label val esec3 esec3
	label var esec3 "3-class ESeC"
	numlabel, add
	tab esec3, mis

*-------------------------------------------------------------------------------
**# Contract type
*-------------------------------------------------------------------------------

* Working time
***************

* Contracted hours (employees only)
	tab pgvebzeit pgemplst if employed==1, mis col
	tab pglfs if employed==1 & pgvebzeit==.a, mis
	tab sempl if employed==1 & pgvebzeit==.a, mis
	/* Quite a few 'inapplicable' in contracted working time: 17% amongst FT, 
	12% amongst regular PT,	36% amongst marginal PT. But tabulating across Labor
	Force Status show 97% of these are 'inactive'. Not sure why the inconsistency? */
	sum pgvebzeit if pgemplst==1, detail // Regular FT
	sum pgvebzeit if pgemplst==2, detail // Regular PT
	sum pgvebzeit if pgemplst==4, detail // irregular/marginal 

* Actual hours (wider range of workers, includes overtime)
	tab pgtatzeit pgemplst if employed==1, mis
	/* only 3 cases as 'inapplicable' here. A good reason to use actual hours to 
	construct the working time variable. */
	sum pgtatzeit if pgemplst==1, detail
	sum pgtatzeit if pgemplst==2, detail
	sum pgtatzeit if pgemplst==4, detail	
		
* Create var for FT, PT, Marginal employment
	/* Use marginal emp var for that category (plb0187_v2)? 
	No, pgemplst==4 captures more. */
	tab pgtatzeit, mis
	gen parttime=.
	replace parttime=0 if pgtatzeit==.a & pgtatzeit==.a
	replace parttime=1 if pgtatzeit>=35 & pgtatzeit!=. & pgtatzeit!=.a
	replace parttime=2 if pgtatzeit<35 & pgtatzeit>10 & pgtatzeit!=. & pgtatzeit!=.a
	replace parttime=3 if (pgtatzeit<=10 & pgtatzeit!=. & pgtatzeit!=.a) | pgemplst==4
	label define parttime ///
	0 "Inapplicable" ///
	1 "Full-time (>=35h)" ///
	2 " Regular part-time (11-34h)" ///
	3 "Irregular or marginal (<=10h) part-time"
	label val parttime parttime	
	tab parttime, mis 
	tab syear parttime, mis
	tab pgemplst parttime, mis col
	// roughly good match self-reported employment status

* Other contractual characteristics
************************************
* Self-employed
	// Already created a dummy for ESeC
	tab sempl, mis
	tab syear sempl, mis
	// re-code to keep inapplicable
	recode sempl (1=1 "Yes") (0=2 "No")(.a=0 "Inapplicable") (.=.), gen(sempl_re) label(sempl_re)
	tab sempl sempl_re, mis

* Fixed-term contract
	tab plb0037_v3
	recode plb0037_v3 (.a= 0 "Inapplicable") (1 = 1 "permanent") (2 = 2 "fixed-term") ///
	(. = .), gen(fixedterm) label(fixedterm)
	tab plb0037_v3, mis
	tab fixedterm, mis

*  Temp agency
	tab plb0041
	recode plb0041 (.a=0 "Inapplicable") (1 = 1 "Yes") (2 = 2 "No") (. = .), gen(tempagency)
	tab tempagency, mis

*-------------------------------------------------------------------------------
**# Education
*-------------------------------------------------------------------------------

/* use isced-11 classification and collapse categories to match Kaiser (2016). 
Doesn't distinguish between academic or vocational but create a separate
dummy var for that using CASMIN. */
	tab pgisced11
	tab pgcasmin	// CASMIN has more missing
	tab pgisced11 pgcasmin, mis

* Collapsing ISCED11
	/* not following Kaiser exactly as not sure how to & probably best to deviate 
	from ISCED11 as little as possible. */
	tab pgisced11, mis
	gen isced_re=.
	replace isced_re=0 if pgisced11==0 | pgisced11==1
	replace isced_re=1 if pgisced11==2
	replace isced_re=2 if pgisced11==3
	replace isced_re=3 if pgisced11==4 | pgisced11==5
	replace isced_re=4 if pgisced11>=6 & pgisced11!=.
	label define isced_re 0 "No or elementary" 1 "Lower secondary" 2 "Upper secondary" ///
	3 "Post-secondary & short-cycle tertiary" 4 "Tertiary (BA or higher"
	label val isced_re isced_re
	label var isced_re "Collapsed ISCED-11 classification"
	tab isced_re, mis
	tab pgisced11 isced_re, mis

* Create additional var for academic/vocational from CASMIN
	tab pgcasmin, mis
	/* Following Zagel (2013, p245):
	- 1a, 1b, 2b - no or lower general qualification --> 0
	- 1c, 2a, 2c - vocational --> 1
	- 2c, 3a, 3b - academic --> 0
	*/
	gen vocqual=.
	replace vocqual=0 if pgcasmin<=2 | pgcasmin==4 & pgcasmin!=.
	replace vocqual=0 if pgcasmin==6 | pgcasmin>=8 & pgcasmin!=.
	replace vocqual=1 if pgcasmin==3 | pgcasmin==5 | pgcasmin==7
	label var vocqual "Has vocational qualifications"
	label val vocqual dummy
	tab pgcasmin vocqual, mis

*-------------------------------------------------------------------------------
**# Industrial sector, public/private, size 	
*-------------------------------------------------------------------------------
	/* 
	pgnace: up to 2017. Equivalent to ISIC Rev. 3
	pgnace2: 2013-. 
	Create 2 diff vars for diff years, then merge.
	*/

* ISIC 2010-2017
	tab pgnace
	tab syear pgnace if pgnace<0
	tab pgnace if syear<2018
	/* variable not asked in 2018 & 2019. 44% not applicable. */
	tab pgnace, mis
	gen isic_agg1=.
	replace isic_agg1=0 if pgnace==.a
	replace isic_agg1=1 if pgnace<=5 & pgnace!=.
	replace isic_agg1=2 if (pgnace>=10 & pgnace<=41) | pgnace==90
	replace isic_agg1=3 if pgnace==45
	replace isic_agg1=4 if pgnace>=50 & pgnace<=63
	replace isic_agg1=5 if pgnace==64 | pgnace==72
	replace isic_agg1=6 if pgnace==65 | pgnace==66 | pgnace==67
	replace isic_agg1=7 if pgnace==70 | pgnace==71
	replace isic_agg1=8 if pgnace==73 | pgnace==74
	replace isic_agg1=9 if pgnace>=75 & pgnace<=85
	replace isic_agg1=10 if pgnace>=91 & pgnace<=99
	label define isic_agg ///
		0 "Inapplicable" ///
		1 "Agriculture, forestry, fishing" ///
		2 "Manufacturing, mining, quarry & other industry" ///
		3 "Construction" ///
		4 "Wholesale & retail trades, transport, accommodation & food services" ///
		5 "Information & communication" ///
		6 "Financial & insurance activities" ///
		7 "Real estate activities" ///
		8 "Business services" ///
		9 "Public administration, defence, education, health, social work" ///
		10 "Other services"
	label val isic_agg1 isic_agg	
	tab isic_agg1, mis

* ISIC 2018-2019
	tab pgnace2, mis
	/* variable asked from 2013. */
	// matches ISIC 4 more closely
	gen isic_agg2=.
	replace isic_agg2=0 if pgnace2==.a
	replace isic_agg2=1 if pgnace2==1 | pgnace2==2 | pgnace2==3
	replace isic_agg2=2 if pgnace2>=5 & pgnace2<=39
	replace isic_agg2=3 if pgnace2==41 | pgnace2==42 | pgnace2==43
	replace isic_agg2=4 if pgnace2>=45 & pgnace2<=56
	replace isic_agg2=5 if pgnace2>=58 & pgnace2<=63
	replace isic_agg2=6 if pgnace2==64 | pgnace2==65 | pgnace2==66
	replace isic_agg2=7 if pgnace2==68
	replace isic_agg2=8 if pgnace2>=69 & pgnace2<=82
	replace isic_agg2=9 if pgnace2>=84 & pgnace2<=88
	replace isic_agg2=10 if pgnace2>=90 & pgnace2<=99
	label val isic_agg2 isic_agg
	tab isic_agg2, mis
	tab syear isic_agg2, mis

* Combine the two - use latest (based on ISIC rev4)
	tab isic_agg1 isic_agg2, mis
	tab isic_agg1 isic_agg2 if syear==2013, mis row nofreq
	/* Not perfect match but good enough. */
	gen isic_agg=.
	replace isic_agg=isic_agg1 if syear<2013
	replace isic_agg=isic_agg2 if syear>=2013
	label val isic_agg isic_agg
	tab isic_agg, mis
	tab syear isic_agg, mis
	label var isic_agg "Industrial sector (aggregated ISIC)"
	drop isic_agg1 isic_agg2

* Create condensed 3-category version of sector (following OECD)
	tab isic_agg, mis
	recode isic_agg (0=0) (1=1) (2/3=2) (4/10=3) (.=.), gen(isic_broad)
	label define isic_broad ///
	0 "Inapplicable" ///
	1 "Agriculture, forestry, mining" ///
	2 "Industry" 3 "Services" .a "Inapplicable"
	label val isic_broad isic_broad
	label var isic_broad "Broad industrial sector"
	tab isic_broad, mis

* Create dummy variable for services sector
	tab isic_broad, mis
	gen services=.
	replace services=1 if isic_broad==3
	replace services=0 if isic_broad==0 | isic_broad==1 | isic_broad==2
	label var isic_broad "Service sector dummy"
	label val isic_broad dummy
	tab services, mis

* Public/private sector
	// Variable exists already
	tab pgoeffd, mis
	// 41% inapplicable (.a)
	// switch label values around to match UKHLS variable
	recode pgoeffd (.a=0 "Inapplicable") (1 = 2 "Public sector") ///
	(2 = 1 "Not public sector"), gen(pubsec)
	tab pubsec, mis

* Company size
	tab pgbetr, mis // already mvdecoded earlier
	gen jbsize=.
	replace jbsize=0 if pgbetr==.a
	replace jbsize=1 if pgbetr==1 | pgbetr==2 | pgbetr==11
	replace jbsize=2 if pgbetr==3 | pgbetr==6 | pgbetr==7
	replace jbsize=3 if pgbetr==9 | pgbetr==10
	label define jbsize 0 "Inapplicable" 1 "<10 incl self-employed" ///
	2 "11-200" 3 ">200"	
	label var jbsize "Company size"
	label val jbsize jbsize
	tab jbsize, mis

*-------------------------------------------------------------------------------
**# Control vars	
*-------------------------------------------------------------------------------

* Create var for age
	tab piyear, mis
	tab gebjahr, mis
	gen age=.
	replace age=piyear-gebjahr if piyear!=. & gebjahr!=.
	tab age, mis

* Gender
	tab sex, mis
	// recode to 0 and 1
	recode sex (1 = 0 "Male") (2 = 1 "Female") (. =.), gen(female)
	tab female, mis

* Marital status
	tab pgfamstd, mis
	/* Use same categories developed for UKHLS:
	- Married, civil part'ship, cohabiting
	- Widowed, divorced or separated
	- Never married or in civil partnership */
	gen mastat=.
	replace mastat=1 if pgfamstd==1 | pgfamstd==6 | pgfamstd==7 | pgfamstd==8
	replace mastat=2 if pgfamstd==2 | pgfamstd==4 | pgfamstd==5
	replace mastat=3 if pgfamstd==3
	label define mastat 1 "Married, civil partnership or cohabiting" ///
						2 "Widowed, divorced or separated" ///
						3 "Never married or in civil partnership"
	label val mastat mastat
	label var mastat "Marital status (recoded)"
	tab mastat, mis

* Housing tenure
	tab hgowner, mis
	tab syear hgowner, mis
	// SOEP does not distinguish private & social rent - collapse into homeowner/tenant. 
	gen howner=.
	replace howner=1 if hgowner==1
	replace howner=0 if hgowner==2 | hgowner==3 | hgowner==4 | hgowner==5
	label val howner dummy
	label var howner "Homeowner (recoded)"
	tab howner, mis

* East/West
	tab sampreg, mis

* Number of children in household
	tab d11107
	rename d11107 nkids

* Houshehold income
	sum hghinc, detail
	tab hghinc if hghinc<0
	histogram hghinc, normal // highly skewed, take log
	gen loghhinc=log(hghinc)
	sum loghhinc, detail
	histogram loghhinc, normal
	label var loghhinc "Log net household income"

* Job satisfaction
	// 7 categories in UKHLS, scale of 1-10 in SOEP.
	// 31% inapplicable (.a)
	label list plh0173
	recode plh0173 (.a=0 "Inapplicable") ///
	(0=1 "1 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(1=2 "2 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(2=3 "3 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(3=4 "4 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(4=5 "5 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(5=6 "6 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(6=7 "7 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(7=8 "8 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(8=9 "9 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(9=10 "10 Zufrieden: Skala 1-Niedrig bis 11-Hoch") ///
	(10=11 "11 Zufrieden: Skala 1-Niedrig bis 11-Hoch"), gen(jobsat)
	tab jobsat, mis

* Severity of impairment/functional limitation
	// For model with officially disabled use degreedis_c as control

* Number of nights in hospital
	// more missing 2013-2019 due to question not being asked [-5]. 
	sum m11102, detail
	rename m11102 nights
	// OK & also included in UKHLS
	
* Current self-rated health
	tab m11126, mis
	rename m11126 healthrate
	// OK & also included in UKHLS
	
* Satisfaction with health
	tab m11125, mis
	rename m11125 healthsat

* Type of impairment
*	Mental health ("Psychiatric problems")
	tab m11109, mis // missing in 2010, 2012, 2014, 2016, 2018
	rename m11109 mentalimp

*-------------------------------------------------------------------------------
**# 	Weights
*-------------------------------------------------------------------------------
/* SOEP don't provide longitudinal weights. These need to be produced using cross-sectional weights for each year (phrf) and remaining probability for each year (pbleib)For each observation, multiply the 2010 xsectional weight by the remaining probability for every year up to that observation. 
*/ 

* Indicator for balanced panel (from SOEPcampus)
gen participated = 1 if inrange(syear, 2010, 2019) & inrange(netto, 10, 19)
egen participationcount = total(participated) if inrange(syear, 2010, 2019), by(pid)
gen balanced = 1 if participationcount==10
xtdescribe if balanced==1

* Longitudinal weight for balanced panel (from SOEPcampus, adapting timeframe)
gen lw = phrf if syear==2010
forvalues t = 1 (1) 9 {
	bysort pid (syear): replace lw = lw * f`t'.pbleib							 
	// I have added bysort myself
}
bysort pid (lw): replace lw = lw[1] if inrange(syear, 2010, 2019)

* Inspect:
list pid syear phrf lw in 1/30
tab lw if balanced!=1, mis
// All unbalanced pids have missing (rather than zero) lw
	
*-------------------------------------------------------------------------------
* Save re-coded data
*-------------------------------------------------------------------------------
* Order
	order pid hid syear
	sort pid syear
	isid pid syear

* Save
	compress
	save "$path8/soep_recoded.dta", replace
	
*-------------------------------------------------------------------------------
**# 						IMPUTATION
*-------------------------------------------------------------------------------

/* preferable to do this BEFORE losing information by collapsing variables together
when constructing them. Also allows for more flexibility if I want to change the
way I construct variables. Skip to chapter 5 (operationalisation) to construct 
the WLD variables.  

For now I am only imputing variables with systematic or periodic missingness due
to the question not being asked every year. These are:
chronic (chronic illness) - dichotomous
adl (limitations in daily life) - ordinal, 3 values
ple0031 (Accomplished Less Due To Physical Problems) - ordinal, 5 values
ple0032 (Limitations Due To Physical Problems)
ple0033 (Accomplished Less Due To Emotional Problems)
ple0034 (Less Careful Due To Emotional Problems)
mentalimp ("Psychiatric problems") - dichotomous
*/

use "$path8/soep_recoded.dta", clear


/* 	Multiple imputation using chained equations (MICE)
**********************************************************
// code copied and adapted from genAI (ELM)

* Set up for multiple imputation
mi set wide

* Register the variables I want to impute - Nb these include dichotomous and ordinal vars
mi register imputed chronic adl ple0031 ple0032 ple0033 ple0034 mentalimp

* Register the variables I don't want to impute but want to use to impute the others
// including time as a predictor
mi register regular syear legaldis degreedis_c distat employed esec_short parttime sempl fixedterm tempagency isced_re isic_agg pubsec jbsize age sex mastat howner sampreg nkids loghhinc nights healthrate healthsat

* Impute missing data using chained equations with both logistic and ordinal regression
// taking account of panel structure
// longitudinal weight as sampling weight
 
mi impute chained ///
(logit) chronic mentalimp ///
(ologit) adl ple0031 ple0032 ple0033 ple0034 = syear legaldis distat degreedis_c employed esec_short parttime sempl fixedterm tempagency isced_re isic_agg pubsec jbsize age sex mastat howner sampreg nkids loghhinc nights healthrate healthsat [pweight=lw], ///
by(pid) add(5) rseed(12345) nolabel

/* error: "too many values for label definer". I have tried many things, including checking
for unexpected categories in each of all the variables. 
I have tried running the command only on women. This avoided the "too many values for label definer(134)" error. 

However I then had an issue with my two dichotomous variables. The error message started with "outcome does not vary". The two dichotomous were coded as 0 and 1. 

Removing them and running the imputation on ordinal variables only solved this issue but then I get another error message: "insufficient observations". Though this applies to pid=8604 it seems.
*/

mi impute chained ///
(ologit) adl ple0031 ple0032 ple0033 ple0034 = syear legaldis distat degreedis_c employed esec_short parttime sempl fixedterm tempagency isced_re isic_agg pubsec jbsize age mastat howner sampreg nkids loghhinc nights healthrate healthsat if sex==2 [pweight=lw], ///
by(pid) add(5) rseed(12345)

* Check how the imputed dataset has been stored:
mi describe
mi xeq 1: summarize adl ple0031 ple0032 ple0033 ple0034
// Not worked. 

/* Note: any subsequent analyses of data require the 'svy: mi estimate:' to be specified before. 
"This approach provides robust statistical inferences by considering the uncertainty introduced during the imputation process." (genAI). This is also true of descriptive analyses,
although that is more complicated and options limited." */
 
mi unset // removes imputed datasets

*/

**# 
* a) Imputation using LOCF
*****************************

* Imputing by feeding forward from previous variable if non-missing (LOCF)

/* Impute:
chronic (chronic illness) - dichotomous
adl (limitations in daily life) - ordinal, 3 values
ple0031 (Accomplished Less Due To Physical Problems) - ordinal, 5 values
ple0032 (Limitations Due To Physical Problems)
ple0033 (Accomplished Less Due To Emotional Problems)
ple0034 (Less Careful Due To Emotional Problems)
mentalimp ("Psychiatric problems") - dichotomous
*/

* tsset to use lag operators
	tsset pid syear


* Chronic illness
*******************

// Create a flag for missing observations
	gen chronic_obs = 0
	replace chronic_obs = 1 if chronic !=.
	label var chronic_obs "Chronic illness (whether observed)"

// Impute using LOCF
	gen chronic_imploc=.
	bysort pid (syear): replace chronic_imploc=chronic if chronic!=.
	bysort pid (syear): replace chronic_imploc=L.chronic if chronic==. & L.chronic!=.
	label val chronic_imploc dummy
	label var chronic_imploc "Chronic illness (imputed using LOCF)"
	
// Create flag for imputed observations
	gen chronic_imp = 0 
	replace chronic_imp = 1 if chronic ==. & chronic_imploc !=.
	label var chronic_imp "Value imputed using LOCF"
	
* Checks
		
	// Restrict to 16-64 sample with complete interview
		keep if netto<=19
		keep if inrange(age,16,64)

	// 1) check % of cases imputed
		tab chronic_imp, mis
		
	// 2) check for specific years when asked of a few (2011, 2013)
		tab chronic_imploc chronic_imp if syear==2011, row
		tab chronic_imploc chronic_imp if syear==2013, row

	// 3) Check stability over years prior to imputation

		tab syear chronic_obs, mis row 
		
		xtset pid syear
		gen chronic_lag = L.chronic
		
		tab chronic_lag chronic if ///
			syear==2011 & ///
			chronic !=. & ///
			chronic_lag !=., mis row
			
		// pool 2011 and 2013
		tab chronic_lag chronic if ///
			inlist(syear,2011, 2013) & ///
			chronic !=. & ///
			chronic_lag !=., mis row	


* ADL
********
// Create a flag for missing observations
	gen adl_obs = 0
	replace adl_obs = 1 if adl !=.
	label var adl_obs "Functional limitations whether observed"

// Impute using LOCF
	gen adl_imploc=.
	bysort pid (syear): replace adl_imploc=adl if adl!=.
	bysort pid (syear): replace adl_imploc=L.adl if adl==. & L.adl!=.
	label val adl_imploc ple0009
	label var adl_imploc "Limitations in activities of daily life (imputed using LOCF)"
	
// Create flag for imputed observations
	gen adl_imp = 0
	replace adl_imp = 1 if adl==. & adl_imploc !=.
	label var adl_imp "Value imputed using LOCF"

// 1) check % of cases imputed
	tab adl_imp, mis
	tab syear adl_imp, mis
	
* ple0031 (Accomplished Less Due To Physical Problems)
********************************************************

// Observation flag
	gen ple0031_obs=0
	replace ple0031_obs=1 if ple0031 !=.
	label var ple0031_obs "Whether observed (Accomplished Less Due To Physical Problems)"

// LOCF Imputation 
	gen ple0031_imploc=.
	bysort pid (syear): replace ple0031_imploc=ple0031 if ple0031!=.
	bysort pid (syear): replace ple0031_imploc=L.ple0031 if ple0031==. & L.ple0031!=.
	label val ple0031_imploc ple0031
	label var ple0031_imploc "Accomplished Less Due To Physical Problems (imputed using LOCF)"

// Imputation flag
	gen ple0031_imp = 0
	replace ple0031_imp = 1 if ple0031==. & ple0031_imploc !=.
	label var ple0031_imp "Value imputed using LOCF"

// 1) % imputed
	tab ple0031_imp, mis

// 2) comparison in year when there were some responses (2017)
	tab ple0031_imploc ple0031_imp if syear==2017, row
	
// 3) Comparison of stability in NON-IMPUTED values
	tab syear ple0031_obs, mis row

	xtset pid syear
	gen ple0031_lag = L.ple0031

	tab ple0031_lag ple0031 if ///
		syear==2017 & ///
		ple0031 !=. & ///
		ple0031_lag !=., mis row
		
// troubleshooting
count if syear==2017 & ple0031!=.
count if syear==2017 & L.ple0031!=.
count if syear==2017 & ple0031!=. & L.ple0031!=.
	
* ple0032 (Limitations Due To Physical Problems)
*************************************************

// Observation flag
	gen ple0032_obs=0
	replace ple0032_obs=1 if ple0032!=.
	label var ple0032_obs "Whether observed (Limitations Due To Physical Problems)"
	
// LOCF imputation
	gen ple0032_imploc=.
	bysort pid (syear): replace ple0032_imploc=ple0032 if ple0032!=.
	bysort pid (syear): replace ple0032_imploc=L.ple0032 if ple0032==. & L.ple0032!=.
	label val ple0032_imploc ple0032
	label var ple0032_imploc "Limitations Due To Physical Problems (imputed using LOCF)"

// Imputation flag
	gen ple0032_imp = 0
	replace ple0032_imp = 1 if ple0032==. & ple0032_imploc !=.
	label var ple0032_imp "Value imputed using LOCF"

// 1) % imputed
	tab ple0032_imp, mis

// 2) comparison in year when there were some responses (2017)
	tab ple0032_imploc ple0032_imp if syear==2017, row
		
	
* ple0033 (Accomplished Less Due To Emotional Problems)
**********************************************************
// Observation flag
	gen ple0033_obs=0
	replace ple0033_obs=1 if ple0033!=.
	label var ple0033_obs "Whether observed (Accomplished Less Due To Emotional Problems)"

// LOCF imputation
	gen ple0033_imploc=.
	bysort pid (syear): replace ple0033_imploc=ple0033 if ple0033!=.
	bysort pid (syear): replace ple0033_imploc=L.ple0033 if ple0033==. & L.ple0033!=.
	label val ple0033_imploc ple0033
	label var ple0033_imploc "Accomplished Less Due To Emotional Problems (imputed using LOCF)"

// Imputation flag
	gen ple0033_imp = 0
	replace ple0033_imp = 1 if ple0033==. & ple0033_imploc !=.
	label var ple0033_imp "Value imputed using LOCF"

// 1) % imputed
	tab ple0033_imp, mis

// 2) comparison in year when there were some responses (2017)
	tab ple0033_imploc ple0033_imp if syear==2017, row
		

* ple0034 (Less Careful Due To Emotional Problems)
***************************************************

// Observation flag
	gen ple0034_obs=0
	replace ple0034_obs=1 if ple0034!=.
	label var ple0034_obs "Whether observed (Less Careful Due To Emotional Problems)"

// LOCF imputation
	gen ple0034_imploc=.
	bysort pid (syear): replace ple0034_imploc=ple0034 if ple0034!=.
	bysort pid (syear): replace ple0034_imploc=L.ple0034 if ple0034==. & L.ple0034!=.
	label val ple0034_imploc ple0034
	label var ple0034_imploc "Less Careful Due To Emotional Problems (imputed using LOCF)"

// Imputation flag
	gen ple0034_imp = 0
	replace ple0034_imp = 1 if ple0034==. & ple0034_imploc !=.
	label var ple0034_imp "Value imputed using LOCF"

// 1) % imputed
	tab ple0034_imp, mis

// 2) comparison in year when there were some responses (2017)
	tab ple0034_imploc ple0034_imp if syear==2017, row
	

* mentalimp_imploc ("Psychiatric problems") - dichotomous
************************************************************
	tab syear mentalimp, mis // missing in 2010 as only available in odd years
	
// Observation flag
	gen mentalimp_obs=0
	replace mentalimp_obs=1 if mentalimp!=.
	label var mentalimp_obs "Whether observed (Psychiatric problems)"

// LOCf imputation
	gen mentalimp_imploc=.
	bysort pid (syear): replace mentalimp_imploc=mentalimp if mentalimp!=.
	bysort pid (syear): replace mentalimp_imploc=L.mentalimp if mentalimp==. & L.mentalimp!=.
	label val mentalimp_imploc dummy
	label var mentalimp_imploc "Psychiatric problems (imputed using LOCF)"

// Imputation flag
	gen mentalimp_imp = 0
	replace mentalimp_imp = 1 if mentalimp==. & mentalimp_imploc !=.
	label var mentalimp "Value imputed using LOCF"

// 1) % imputed
	tab mentalimp_imp, mis
	tab syear mentalimp_imp, mis

// 2) comparison in year when there were some responses (2014)
	tab mentalimp_imploc mentalimp_imp if syear==2014, row


* Construct WLD variables after imputing
************************************************
* 	Turn WLD into 4 binary measures
	label list ple0031
	/* Labels match those for UK variables
			   1 [1] Immer
			   2 [2] Oft
			   3 [3] Manchmal
			   4 [4] Fast nie
			   5 [5] Nie */

*	physical wld - amount
	recode ple0031_imploc (1/2=1) (3/5=0), gen(physamount_imploc)
	label val physamount_imploc dummy
	label var physamount_imploc "physical health limits amount of work - using imputed vars"
	tab ple0031_imploc physamount_imploc

* 	physical wld - kind
	recode ple0032_imploc (1/2=1) (3/5=0), gen(physkind_imploc)
	label val physkind_imploc dummy
	label var physkind_imploc "physical health limits kind of work - using imputed vars"
	tab ple0032_imploc physkind_imploc

*	mental wld - amount
	recode ple0033_imploc (1/2=1) (3/5=0), gen(menamount_imploc)
	label val menamount_imploc dummy
	label var menamount_imploc "mental health meant accomplished less - using imputed vars"
	tab ple0033_imploc menamount_imploc

*	mental wld - care
	recode ple0034_imploc (1/2=1) (3/5=0), gen(mencare_imploc)
	label val mencare_imploc dummy
	label var mencare_imploc "mental health meant worked less carefully - using imputed vars"
	tab ple0034_imploc mencare_imploc

/* 	Collapse into 2 binary measures
* 	WLD-physical:
	gen wld_phys=.
	replace wld_phys=1 if physamount==1 | physkind==1
	replace wld_phys=0 if physamount==0 & physkind==0
	label val wld_phys dummy
	label var wld_phys "Physical work limitation"
	tab wld_phys

*	WLD-mental:
	gen wld_men=.
	replace wld_men=1 if menamount==1 | mencare==1
	replace wld_men=0 if menamount==0 & mencare==0
	label val wld_men dummy
	label var wld_men "Mental work limitation"
	tab wld_men
*/

*	Syntax that combines the previous two steps in one - neater but cannot perform descriptives
*	WLD-physical:
	gen wld_phys_imploc=.
	replace wld_phys_imploc=1 if (ple0031_imploc!=. & ple0031_imploc<=2) ///
	| (ple0032_imploc!=. & ple0032_imploc<=2)
	replace wld_phys_imploc=0 if (ple0031_imploc!=. & ple0031_imploc>2) ///
	& (ple0032_imploc!=. & ple0032_imploc>2)
	label var wld_phys_imploc "Physical WLD (imputed)"
	label val wld_phys_imploc dummy
	tab wld_phys_imploc, mis

*	WLD-mental:
	tab ple0033_imploc ple0034_imploc, mis
	label list ple0033 // same as for physical
	gen wld_men_imploc=.
	replace wld_men_imploc=1 if (ple0033_imploc!=. & ple0033_imploc<=2) ///
	| (ple0034_imploc!=. & ple0034_imploc<=2)
	replace wld_men_imploc=0 if (ple0033_imploc!=. & ple0033_imploc>2) ///
	& (ple0034_imploc!=. & ple0034_imploc>2)
	label var wld_men_imploc "Mental/emotional WLD (imputed)"
	label val wld_men_imploc dummy
	tab wld_men_imploc, mis

* 	Collapse into a single WLD measure EXCLUDING PAIN - crude approach
	gen wld_any_imploc=.
	replace wld_any_imploc=1 if wld_phys_imploc==1 | wld_men_imploc==1
	replace wld_any_imploc=0 if wld_phys_imploc==0 & wld_men_imploc==0
	label var wld_any_imploc "Any WLD (imputed LOCF)"
	label val wld_any_imploc dummy
	tab wld_any_imploc, mis
	tab syear wld_any_imploc, mis	
	
	// STILL very high missing %, 54%. Not due to periodic missingness. 

	
* Check imputation - DO MORE
******************************

/* Compare % for imputed & non-imputed variables/ years
	tab wld_any wld_any_imploc if syear==2017, mis 
	tab wld_any if syear==2017
	tab wld_any_imploc if syear==2017
		/* wld_any non-missing in 2017 is perfectly allocated in wld_any_imploc but
		it is because they are the same responses ie not imputed. It is more meaningful
		to compare frequencies. These are roughly in line (wld_any 78/22; wld_any_imploc 82/18)
		- but how to take into account diff sample sizes? */
	tab wld_any wld_any_imploc if syear==2017, mis row nofreq chi V
		// V=0.28
		// not sure this is very meaningful as so many missing for wld_any?
		// removing missing leads to V=1.00 as one is just a subset of another
	venndiag wld_any wld_any_imploc if syear==2017
		// not sure what to make of this?
		
	// to properly compare I need a measure of WLD that ignores 2017 data
	gen wld_any_implocno2017=.
	bysort pid (syear): replace wld_any_implocno2017=wld_any if wld_any!=. & syear!=2017
	bysort pid (syear): replace wld_any_implocno2017=L.wld_any if wld_any==. & L.wld_any!=. & syear!=2017
	bysort pid (syear): replace wld_any_implocno2017=F.wld_any if wld_any==. & L.wld_any==. & syear!=2017
	list pid syear wld_any wld_any_imploc wld_any_implocno2017 in 1/100
	// mmm but then there's nothing to compare with in 2017? Compare in 2018
	tab wld_any wld_any_implocno2017 if syear!=2017, mis row nofreq chi V
	// confused about this as the point was to make use of the 2017 observations?
*/

/* Impute already-recoded vars (but I think best to construct from original AFTER imputing)

	* Physical health limits amount of work
	gen physamount_imploc=.
	bysort pid (syear): replace physamount_imploc=physamount if physamount!=.
	bysort pid (syear): replace physamount_imploc=L.physamount if physamount==. & L.physamount!=.
	label val physamount_imploc dummy
	label var physamount_imploc "Imputed physical health limits amount (LOCF)"
	tab syear physamount_imploc, mis
	list pid syear physamount physamount_imploc in 1/100
	
	* Physical health limits kind of work
	gen physkind_imploc=.
	bysort pid (syear): replace physkind_imploc=physkind if physkind!=.
	bysort pid (syear): replace physkind_imploc=L.physkind if physkind==. & L.physkind!=.
	label val physkind_imploc dummy
	label var physkind_imploc "Imputed physical health limits kind (LOCF)"
	tab syear physkind_imploc, mis
	list pid syear physamount physkind_imploc in 1/100
	
	* Mental health meant accomplished less
	gen menamount_imploc=.
	bysort pid (syear): replace menamount_imploc=menamount if menamount!=.
	bysort pid (syear): replace menamount_imploc=L.menamount if menamount==. & L.menamount!=.
	label val menamount_imploc dummy
	label var menamount_imploc "Mental health meant accomplished less (LOCF)"
	tab syear menamount_imploc, mis
	list pid syear menamount menamount_imploc in 1/100
	
	* Mental health meant worked less carefully
	gen mencare_imploc=.
	bysort pid (syear): replace mencare_imploc=mencare if mencare!=.
	bysort pid (syear): replace mencare_imploc=L.mencare if mencare==. & L.mencare!=.
	label val mencare_imploc dummy
	label var mencare_imploc "Mental health meant worked less carefully (LOCF)"
	tab syear mencare_imploc, mis
	list pid syear mencare mencare_imploc in 1/100
	
	*	Physical WLD - imputed
	gen wld_phys_imploc=.
	bysort pid (syear): replace wld_phys_imploc=wld_phys if wld_phys!=.
	bysort pid (syear): replace wld_phys_imploc=L.wld_phys if wld_phys==. & L.wld_phys!=.
	label val wld_phys_imploc dummy
	label var wld_phys_imploc "Imputed Physical WLD (LOCF)"
	tab syear wld_phys_imploc, mis
	list pid syear wld_phys wld_phys_imploc in 1/100
	
	* 	Mental health - imputed
	gen wld_men_imploc=.
	bysort pid (syear): replace wld_men_imploc=wld_men if wld_men!=.
	bysort pid (syear): replace wld_men_imploc=L.wld_men if wld_men==. & L.wld_men!=.
	label val wld_men_imploc dummy
	label var wld_men_imploc "Imputed mental WLD (LOCF)"
	tab syear wld_men_imploc, mis
	list pid syear wld_men wld_men_imploc in 1/100
*/


* b) Impute from official disability status (>30%) if WLD is missing

	// check for overlap between the two measures
	tab wld_any distat if (syear==2010 | syear==2012 | syear==2014 | ///
	syear==2016 | syear==2018), mis row nofreq chi V
	
	// Cramer's V= 0.6
	// Less than half of those with any WLD also have official disability over 30% (48.10%)
	
	// Check with any disability status
	tab wld_any legaldis if (syear==2010 | syear==2012 | syear==2014 | ///
	syear==2016 | syear==2018), mis row nofreq chi V
	
	// Cramer's V = 0.61
	// Smaller % of those with any WLD have any degree of officially recognised disability (32%).
	
	// Altogether suggests not very appropriate to use official disability to impute

	/*
	gen wld_dis=.
	bysort pid (syear): replace wld_dis=wld_any if wld_any!=.
	bysort pid (syear): replace wld_dis=distat if wld_any==.
	label val wld_dis dummy
	label var wld_dis "Imputed WLD (using official dis >30%)"
	
	tab distat, mis
	tab wld_dis, mis
	list pid syear wld_any distat wld_dis in 1/100
	*/

/*-------------------------------------------------------------------------------
**# Construct Disability change variables
*-------------------------------------------------------------------------------

* tsset to use lag operators
	tsset pid syear 
	
* Change in WLD_any
	// Use the imputed WLD as otherwise there are too many gaps. 
	gen wld_change=.
	bysort pid (syear): replace wld_change=0 if wld_any_imploc==0 & L.wld_any_imploc==0
	bysort pid (syear): replace wld_change=1 if wld_any_imploc==1 & L.wld_any_imploc==0
	bysort pid (syear): replace wld_change=2 if wld_any_imploc==1 & L.wld_any_imploc==1
	bysort pid (syear): replace wld_change=3 if wld_any_imploc==0 & L.wld_any_imploc==1
	label values wld_change dischange_var2
	tab wld_change, mis
	tab wld_any_imploc if wld_change==., mis
	list pid syear wld_any_imploc wld_change in 1/20
	*/
	
numlabel, add
compress
save "$path2/soep_clean.dta", replace

********************************************************************************
**# 		3. METHODS / EXPLORATORY ANALYSES
********************************************************************************

* Open clean dataset with recoded & imputed variables
	use "$path2/soep_clean.dta", clear

* Declare to be panel data
	xtset pid syear
	xtdes
	xtsum pid
	
*-------------------------------------------------------------------------------
* Inspect missing data after recoding (prior to case completion criterion)
*-------------------------------------------------------------------------------

* Open clean dataset with recoded & imputed variables
	use "$path2/soep_clean.dta", clear
	
* Restrict to 16-64 sample with complete interview
	keep if netto<=19
	keep if inrange(age,16,64)
	
* Inspect missing data (code from Roxanne)
	ssc install mdesc
	
/* Combined list of vars

	*Health/impairment and disability vars
	
	// Imputed: 
	chronic_imploc adl_imploc ple0031_imploc ple0032_imploc ple0033_imploc ple0034_imploc mentalimp_imploc
	
	// constructed WLD var from imputed vars
	wld_any_imploc
	
	// non-imputed
	healthsat legaldis degreedis_c 
	
	* Individual & household socio-economic vars
	age sex germborn mastat howner isced_re nkids hghinc
	
	* Employment vars
	employed sempl_re esec_short parttime fixedterm isic_broad pubsec jbsize jobsat
	
	* Region & period vars
	syear sampreg
*/	

* Table of missing data for visual inspection
	mdesc wld_any_imploc ///
	healthsat legaldis degreedis_c ///
	chronic_imploc adl_imploc ple0031_imploc ple0032_imploc ///
	ple0033_imploc ple0034_imploc mentalimp_imploc ///
	age sex germborn mastat howner isced_re nkids hghinc ///
	employed sempl_re esec_short parttime fixedterm isic_broad pubsec jbsize jobsat ///
	syear sampreg
	
* SOEP Missingness Table - Whole Sample
********************************************************

	use "$path2/soep_clean.dta", clear

	* Restrict to target sample
	keep if netto <= 19
	keep if inrange(age,16,64)

	tempfile missdata

	postfile handle ///
		str120 variable ///
		long n_nonmiss ///
		long n_miss ///
		double pct_missing ///
		using `missdata', replace

	foreach var in ///
		chronic_imploc adl_imploc ///
		legaldis degreedis_c ///
		ple0031_imploc ple0032_imploc ple0033_imploc ple0034_imploc ///
		mentalimp_imploc wld_any_imploc healthsat ///
		age sex germborn mastat howner isced_re nkids hghinc ///
		employed sempl_re esec_short parttime fixedterm ///
		isic_broad pubsec jbsize jobsat ///
		syear sampreg {

		quietly count if !missing(`var')
		local nonmiss = r(N)

		quietly count if missing(`var')
		local miss = r(N)

		local total = `nonmiss' + `miss'
		local pct = 100 * `miss' / `total'

		* Variable label
		local lbl : variable label `var'

		if "`lbl'" == "" {
			local lbl "`var'"
		}

		post handle ///
			("`lbl'") ///
			(`nonmiss') ///
			(`miss') ///
			(`pct')
	}

	postclose handle

	use `missdata', clear

	format pct_missing %6.2f

	export excel using ///
		"$path6/soep_methodschap_missingness.xlsx", ///
		firstrow(variables) replace
	
* Table of missingness by WLD status 
*************************************

	use "$path2/soep_clean.dta", clear

	* Restrict to target sample
	keep if netto <= 19
	keep if inrange(age,16,64)

	tempfile missdata

	postfile handle ///
		str120 variable ///
		long n0_nonmiss ///
		long n0_miss ///
		double pct0 ///
		long n1_nonmiss ///
		long n1_miss ///
		double pct1 ///
		using `missdata', replace

	foreach var in ///
		chronic_imploc  adl_imploc ///
		legaldis degreedis_c ///
		ple0031_imploc ple0032_imploc ple0033_imploc ple0034_imploc ///
		mentalimp_imploc wld_any_imploc healthsat ///
		age sex germborn mastat howner isced_re nkids hghinc ///
		employed sempl_re esec_short parttime fixedterm ///
		isic_broad pubsec jbsize jobsat ///
		syear sampreg {

		* -------------------------
		* Non-WLD (0)
		* -------------------------
		quietly count if wld_any_imploc == 0 & !missing(`var')
		local n0_nonmiss = r(N)

		quietly count if wld_any_imploc == 0 & missing(`var')
		local n0_miss = r(N)

		local n0_total = `n0_nonmiss' + `n0_miss'
		local pct0 = 100 * `n0_miss' / `n0_total'

		* -------------------------
		* WLD (1)
		* -------------------------
		quietly count if wld_any_imploc == 1 & !missing(`var')
		local n1_nonmiss = r(N)

		quietly count if wld_any_imploc == 1 & missing(`var')
		local n1_miss = r(N)

		local n1_total = `n1_nonmiss' + `n1_miss'
		local pct1 = 100 * `n1_miss' / `n1_total'

		* Variable label
		local lbl : variable label `var'

		if "`lbl'" == "" {
			local lbl "`var'"
		}

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
		"$path6/soep_methodscahp_missingness_by_wld.xlsx", ///
		firstrow(variables) replace

*-------------------------------------------------------------------------------
* Inspect missingness of specific variables in broad sample
*-------------------------------------------------------------------------------

	use "$path2/soep_clean.dta", clear

	* Restrict to target sample
	keep if netto <= 19
	keep if inrange(age,16,64)

* Inspect missingness in non-missing years for WLD variables

foreach n in 1 2 3 4 {
	tab syear ple003`n', mis row
}

********************************************************************************
**# 		OPERATIONALISATION CHAPTER (5)
********************************************************************************

*-------------------------------------------------------------------------------
**# Create sample for operationalisation chapter:
*-------------------------------------------------------------------------------
/* Sample criteria
	- 2010-2019 - already specified
	- ages 16-64
	- complete for all disvars
	- both balanced & unbalanced
*/

* Open clean dataset with recoded & imputed variables
	use "$path2/soep_clean.dta", clear

* Step 1: Define Core Conditions

	gen byte cond1 = (netto <= 19)  // Individual interview
	gen byte cond2 = inrange(age, 16, 64)
	gen byte cond3 = !missing( ///
		wld_any_imploc, legaldis, chronic_imploc, ple0031_imploc, ///
		ple0032_imploc, ple0033_imploc, ple0034_imploc, ///
		age, sex, germborn, mastat, howner, isced_re, nkids, hghinc, ///
		employed, ///
		syear, sampreg)
		// degreedis excluded as filtered by legaldis
		// adl_imploc mentalimp_imploc excluded as completely missing in 2010
		// employment also excluded
		tab syear cond3
			
/* Step 2: Create unbalanced sample flags

	* General unbalanced sample (cross-sectional)
	gen byte sample_16_64_u        = 0
	gen byte sample_16_64_u_wld    = 0
	gen byte sample_16_64_u_nowld  = 0

	replace sample_16_64_u       = 1 if cond1 & cond2 & cond3
	replace sample_16_64_u_wld   = 1 if sample_16_64_u == 1 & wld_any_imploc == 1
	replace sample_16_64_u_nowld = 1 if sample_16_64_u == 1 & wld_any_imploc == 0
*/

* Step 3: Condition for balanced 16-64 sample

	* Valid row-level observation
	gen byte valid_obs_all = cond1 & cond2 & cond3

	* Count valid waves per person
	egen wavecount_all = total(valid_obs_all), by(pid)

	* Balanced panel: must meet all conditions in all 10 years (2010–2019)
	gen byte cond_balanced_all = (wavecount_all == 10)

/* Step 4: Create Balanced Sample Flag

	gen byte sample_16_64_bal        = 0
	gen byte sample_16_64_bal_wld    = 0
	gen byte sample_16_64_bal_nowld  = 0

	replace sample_16_64_bal       = 1 if valid_obs_all == 1 & cond_balanced_all == 1
	replace sample_16_64_bal_wld   = 1 if sample_16_64_bal == 1 & wld_any_imploc == 1
	replace sample_16_64_bal_nowld = 1 if sample_16_64_bal == 1 & wld_any_imploc == 0
*/

* * Step 5: Count sample sizes

 // In total
	count if sample_16_64_u == 1
	count if sample_16_64_bal == 1
	
 // cases & observations
	egen tag = tag(pid)

	count if sample_16_64_u == 1 & tag
	count if sample_16_64_bal == 1 & tag

	drop tag
	
* Step 7: Clean up and Save

	drop cond1 cond2 cond3 valid_obs_all wavecount_all cond_balanced_all
	save "$path2/soep_clean.dta", replace
		
*-------------------------------------------------------------------------------
**# Construction of WLD - tables for exporting
*-------------------------------------------------------------------------------

* Open clean data
	use  "$path2/soep_clean.dta", clear	

* Declare to be panel data
	xtset pid syear
	xtdes
	xtsum pid

* Apply longitudinal weight
	svyset, clear
	svyset psu [pweight=lw], strata(strat)

* Check effective balanced sample size
	sum lw if sample_16_64_bal == 1 // there are some zeroes
	sum pid if lw==0 & sample_16_64_bal==1 // 400 obs - 40 cases
	
* Freq table of vars used to construct WLD
*******************************************

	/* reminder of varnames:
	ple0031_imploc (Accomplished Less Due To Physical Problems) - ordinal, 5 values
	ple0032_imploc (Limitations Due To Physical Problems)
	ple0033_imploc (Accomplished Less Due To Emotional Problems)
	ple0034_imploc (Less Careful Due To Emotional Problems)
	(physamount_imploc, physkind_imploc, menamount_imploc & mencare_imploc have 
	already been recoded to binary variables)
	*/

* try changing labels into english to solve issue with estpost - it solves it
	label define wld_ordinal ///
	1 "Always" 2 "Often" 3 "Sometimes" 4 "Almost never" 5 "Never"
	
	label values ple0031_imploc wld_ordinal 
	label values ple0032_imploc wld_ordinal 
	label values ple0033_imploc wld_ordinal 
	label values ple0034_imploc wld_ordinal 
	
* store table results for each variable
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate ple0031_imploc, obs percent
	estadd scalar Observations = e(N_sub)
	est store physamount
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate ple0032_imploc, obs percent
	estadd scalar Observations = e(N_sub)
	est store physlimit

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate ple0033_imploc, obs percent
	estadd scalar Observations = e(N_sub)
	est store menamount
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate ple0034_imploc, obs percent
	estadd scalar Observations = e(N_sub)
	est store mencare

* Combine into table for output
	esttab physamount physlimit menamount mencare ///
	using "$path6/soep_opchap_wldfreq.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') ///
	title("SOEP: Percentages of the physical and mental impairment variables used to construct a WLD measure") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
	
* 2x2 Table: Overlap between the binary effects of physical impairments 
************************************************************************

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate physkind_imploc physamount_imploc, obs row percent
	estadd scalar Observations = e(N_sub)
	est store table_phys
	
	esttab table_phys using "$path6/soep_opchap_physoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("SOEP: Overlap within WLD due to physical impairments") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

* 2x2 Table: Overlap between the binary effects of mental impairments 
***********************************************************************

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate mencare_imploc menamount_imploc, obs row percent
	estadd scalar Observations = e(N_sub)
	est store table_men
	
	esttab table_men using "$path6/soep_opchap_menoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("SOEP: Overlap within WLD due to mental impairments") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design. Missing test statistics because of stratum with single sampling unit.") replace

* 2x2 table: overlap between wld_phys & wld_men 
************************************************
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_phys_imploc wld_men_imploc, obs row percent
	estadd scalar Observations = e(N_sub)
	est store table_wldoverlap
	
	esttab table_wldoverlap using "$path6/soep_opchap_wldoverlap.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("SOEP: Overlap between measures for physical and mental WLD") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace

* interaction as % of total sample 
***********************************
	
* Create interaction variable
	gen wld_interaction = 10*wld_phys_imploc + wld_men_imploc
	
	label define wld_interaction_label ///
    0 "Neither" ///
    1 "Mental only" ///
    10 "Physical only" ///
    11 "Both"
	
	label values wld_interaction wld_interaction_label
	
*	Export table

	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_interaction, obs percent 
	estadd scalar Observations = e(N_sub)
	est store wld2way

	esttab wld2way using "$path6/soep_opchap_wld2way_weighted.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') ///
	title("SOEP: Interaction between measures for physical and mental WLD as a percentage of the total sample") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
	
* Add any WLD manually
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_imploc, obs percent
	

/* Venn diagram (unweighted)
******************************
	ssc install venndiag
	venndiag wld_phys wld_men, saving("$path7/soep_opchap_venn_simple.png")
	
	//	Version with SOEP label but have to update N mannually
	venndiag wld_phys wld_men show(l c p t f) t2title("SOEP") t3title(N=19,590)
*/

*-------------------------------------------------------------------------------
* Comparison with other disability vars
*-------------------------------------------------------------------------------

* Overlap WLD * official disability
*************************************
	* Prevalence of legaldis
	svy, subpop(if sample_16_64_bal == 1): tabulate legaldis, obs percent
	
	// NB use row option as interested in overlap. 
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_imploc legaldis, obs row percent
	estadd scalar Observations = e(N_sub)
	est store wld_legaldis
	
	esttab wld_legaldis using "$path6/soep_opchap_wld_legaldis.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("SOEP: Overlap between any WLD and officially recognised disability") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design. Missing standard errors because of stratum with single sampling unit. ") replace
	
* Overlap WLD * chronic illness
**********************************
	// prevalence of chronic illness
	svy, subpop(if sample_16_64_bal == 1): tabulate chronic_imploc, obs percent

	
	// overlap (as a % of any WLD) 
	
	estpost svy, subpop(if sample_16_64_bal == 1): tabulate wld_any_imploc chronic_imploc, obs row percent
	estadd scalar Observations = e(N_sub)
	est store wld_chronic
	
	esttab wld_chronic using "$path6/soep_opchap_wld_chronic.rtf", ///
	nostar nostar unstack ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') not ///
	title("SOEP: Overlap between any WLD and self-reported impairment") ///
	addnote("Note: SOEP data; pooled survey years 2010-2019; balanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using longitudinal weights. Percentages are adjusted for survey design. Missing standard errors because of stratum with single sampling unit.") replace
	
* Create impairment + activity variable
*****************************************
// equivalent to eadis in UKHLS

* Inspect impairment var: chronic_imploc
	tab syear chronic_imploc, mis
		// already binary

* Inspect activity limitation var: adl_imploc 
	tab syear adl_imploc, mis
	label list ple0009
		// ordinal, 3 values. Re-code `yes severely' (1) and `yes somewhat' (2) as `yes' 
		// missing in 2010 due to left censoring

* 1st step: recode adl_imploc as binary var
	gen adl_imploc_re =.
	replace adl_imploc_re = 0 if adl_imploc==3
	replace adl_imploc_re = 1 if adl_imploc==1 | adl_imploc==2
	label val adl_imploc_re dummy
	label var adl_imploc_re "Binary measure of activity limitation (recoded)"
	tab syear adl_imploc_re, mis

* 2nd step: combine chronic_imploc and adl_imploc_re
	// use UKHLS varname for ease
	// set all 2010 observations to missing
	gen eadis=.
	replace eadis = 1 if chronic_imploc == 1 & adl_imploc_re == 1 & syear!=2010
	replace eadis = 0 if (chronic_imploc == 0 | adl_imploc_re == 0) & syear!=2010
	label val eadis dummy
	label var eadis "Impairment and activity limitation"
	tab syear eadis, mis
	
* save recode 
save "$path2/soep_clean.dta", replace

*-------------------------------------------------------------------------------
**# Cross-sectional prevalence 
*-------------------------------------------------------------------------------
* Open clean data
	use  "$path2/soep_clean.dta", clear	
	
/* Xsectional weights in SOEP
	- design weight: phrf (named the same for each wave)
	- psu: psu
	- strata: strat 
*/

* Any WLD
***********

* Loop over the survey years and their corresponding weights
	foreach year in 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 {
    
		* Preserve and prepare for filtering 
		preserve
		
		* Filter data for the specific year
		quietly keep if syear == `year'
		
		* Set the survey design with the correct weight
		svyset, clear
		svyset psu [pweight=phrf], strata(strat)
		
		* Calculate the survey-adjusted proportion
		estpost svy, subpop(if sample_16_64_u ==1) : tabulate wld_any_imploc, percent
		
		* Add subpop n scalar and store results with unique name
		estadd scalar Observations = e(N_sub)
		estimates store Year`year'
		
		* Restore the original dataset
		restore
	}

* Check estimates stored correctly
	estimates dir

* Export all stored estimates as csv file to transpose rows and columns

	esttab Year2010 Year2011 Year2012 Year2013 Year2014 Year2015 Year2016 Year2017 Year2018 Year2019 ///
	using "$path6/soep_opchap_prevalence_wld.csv", ///
 	unstack nostar not ///
	mlabels("2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019") ///
	b(%9.1f) ///
	stats(Observations, fmt(0) labels("Observations")) ///
    title("SOEP: Cross-sectional Prevalence of Any WLD (2010-2019)") ///
    addnote("Note: SOEP data; survey years 2010-2019; unbalanced sample aged 16-64 with complete cases. Imputed values on odd years. Weighted using cross-sectional weights. Percentages are adjusted for survey design and non-response.") ///
	replace

*-------------------------------------------------------------------------------
**# Dynamics of WLD
*-------------------------------------------------------------------------------

* Use clean data and apply longitudinal weight
	use  "$path2/soep_clean.dta", clear	
	svyset, clear
	svyset psu [pweight=lw], strata(strat)	

* Keep only balanced panel
	keep if sample_16_64_bal == 1

* Create sequence variables using sq package (Brzinsky-Fay et al 2006)
	
/* 	install sq package for sequence analysis http://fmwww.bc.edu/RePEc/bocode/s
	ssc install sq
	*/	
	
*	Declare to be sequence data
	sqset wld_any_imploc pid syear
	
* 	General sequency descriptions
	// Have removed gapinclude option
	sqtab, ranks(1/10) 
	sqdes
	
*	Create vars for length of sequencies of disability & no. of episodes, then summarise
	egen wldlength = sqlength(), element(1)
	egen wldepisodes = sqepicount(), element(1)

	sqstatsum
	sqstattab1

*	Cross-tab against other vars - could be explored more. 
	sqstattabsum sex
	
* Number of episodes
***********************

* re-set xtset to run svy: tabulate
	sqset, clear
	xtset pid syear

* Episodes (including 0 episodes)
	estpost svy: tabulate wldepisodes, obs percent

* Episodes (>1)
	estpost svy: tabulate wldepisodes if wldepisodes>=1, obs percent	
	est store episodesde

* mean no. of episodes per person
	svy: mean wldepisodes if wldepisodes>=1
	
* Export SOEP-only table

	/***** NB I have MANUALLY divided the N of the table by 10 when reporting, to 
	reflect the total number of respondents / sequences with at least 1 episode of WLD, 
	rather than the person-wave observations, since the variable wldepisodes has 
	the same value for all 10 observations per respondent ******/
	
	esttab episodesde using "$path6/soep_opchap_wldepisodes.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') ///
	title("SOEP: Number of episodes of any WLD (excluding pain) per person with WLD in at least one wave") ///
	addnote("Note: UKHLS (waves 1-10) and SOEP (2010-2019) data; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace


* Length of episodes (using sq)
********************************
 // unclear interpretation - not reporting in thesis

* Mean length of episodes per person
	svy: mean wldlength if wldlength>=1
	
* Length (including 0)
	estpost svy: tabulate wldlength, obs percent
	
* Length (>1)
	estpost svy: tabulate wldlength if wldlength>=1, obs percent
	est store lengthde 

	
* Maximum consecutive WLD episode length (manually)
****************************************************
* Use clean data and apply longitudinal weight
	use  "$path2/soep_clean.dta", clear	
	svyset, clear
	svyset psu [pweight=lw], strata(strat)	

* Keep only balanced panel
	keep if sample_16_64_bal == 1

* Make sure data is sorted
	sort pid syear

* Running length of current WLD episode
	by pid: gen run_length = .

	by pid: replace run_length = ///
		cond(wld_any_imploc == 1, ///
			 cond(_n == 1, 1, ///
				  cond(wld_any_imploc[_n-1] == 1, run_length[_n-1] + 1, 1)), ///
			 0)

* Maximum episode length for each respondent
	by pid: egen max_ep_length = max(run_length)
	
* Inspect
	list pid syear wld_any_imploc run_length max_ep_length in 1/50
	// looks ok

* Table of maximum episode length per person
	estpost svy: tabulate max_ep_length if max_ep_length>=1, obs percent
	est store maxde

* Export SOEP-only data (to combine manually in table)
	esttab maxde using "$path6/soep_opchap_wldmaxlength.rtf", ///
	nostar nostar unstack not ///
	b(%9.1f) ///
	varlabels(`e(labels)') eqlabels(`e(eqlabels)') ///
	title("SOEP: Maximum consecutive length of episodes of any WLD per person with at least one episode of WLD") ///
	addnote("Note: UKHLS (waves 1-10) and SOEP (2010-2019) data; balanced sample aged 16-64 with complete cases. Weighted using longitudinal weights. Percentages are adjusted for survey design and non-response.") replace
	
*-------------------------------------------------------------------------------
**# Socio-demographic and employment characteristics
*-------------------------------------------------------------------------------	

* WLD for comparison with UK
******************************

* Open clean data & apply longitudinal weight
	use  "$path2/soep_clean.dta", clear		
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

* Balanced WLD sample
	// Table without frequencies or standard deviation

	collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal_wld == 1) ///
		factor(sex mastat howner degree employed, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		name(wld_de)

	collect label levels result wld_de "WLD GERMANY"
	
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

	collect title "Balanced SOEP sample (WLD only), Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/soep_opchap_bal_wld_descriptives.docx", ///
    as(docx) replace


* Comparison across disability sub-samples - for book chapter / appendix
********************************************

* Open clean data & apply longitudinal weight
	use  "$path2/soep_clean.dta", clear		
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

* WLD - same as above but adding germborn

	collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal_wld == 1) ///
		factor(sex germborn mastat howner degree employed, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		name(wld_de)

	collect label levels result wld_de "WLD SOEP"
	
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

	collect title "WLD; balanced SOEP sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/soep_opchap_chars_for_comparison_wld.docx", ///
    as(docx) replace


* Long-standing impairment
 
 collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal == 1 & chronic_imploc == 1) ///
		factor(sex germborn mastat howner degree employed, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		name(chronic_de)

	collect label levels result chronic_de "Long-standing impairment SOEP"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal == 1 & chronic_imploc == 1
	local subN = r(N)

	collect title "Long-standing impairment; balanced SOEP sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/soep_opchap_chars_for_comparison_chronic.docx", ///
    as(docx) replace

* Impairment + activity limitation

 collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal == 1 & eadis == 1) ///
		factor(sex germborn mastat howner degree employed, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		name(eadis_de)

	collect label levels result eadis_de "Impairment & limitation SOEP"
	
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

	collect title "Impairment & activity limitation; balanced SOEP sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/soep_opchap_chars_for_comparison_eadis.docx", ///
    as(docx) replace
 
* Officially recognised disability

 collect clear

	dtable, svy ///
		subpop(if sample_16_64_bal == 1 & legaldis == 1) ///
		factor(sex germborn mastat howner degree employed, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		name(legaldis_de)

	collect label levels result legaldis_de "Formally recognised disability SOEP"
	
	// inspect which results are stored
	collect levelsof result
	
	// specify formatting of results to be displayed
	collect style cell result[fvpercent], sformat("%s")
	collect style cell result[mean],      sformat("%s")
	
	// see preview
	collect preview
	
	// add unweighted subpop n
	count if sample_16_64_bal == 1 & legaldis == 1
	local subN = r(N)

	collect title "Formally recognised disability; balanced SOEP sample, Unweighted N = `subN'"
	
	/* remove weighted subpop (as confusing)
	collect drop result[_N]
		// remove manually for now
	*/
	
	// Export as docx
	
	collect export "$path6/soep_opchap_chars_for_comparison_legaldis.docx", ///
    as(docx) replace

	
*-------------------------------------------------------------------------------
**# Prevalence-adjusted WLD employment gap over time
*-------------------------------------------------------------------------------

/* Xsectional weights in SOEP
	- design weight: phrf (named the same for each wave)
	- psu: psu
	- strata: strat 
*/

* Table of conventional and prevalence-adjusted DEG by WLD

	use "$path2/soep_clean.dta", clear

	* Build matrix
	matrix empgap = J(10, 6, .)

	foreach y of numlist 2010/2019 {

		preserve

		local row = `y' - 2009

		keep if syear == `y'

		svyset, clear
		svyset psu [pweight=phrf], strata(strat) singleunit(centered)

		* Employment rate among WLD
		svy, subpop(if sample_16_64_u_wld == 1): mean employed
		matrix b = e(b)
		scalar p_wld = b[1,1]

		* Employment rate among non-WLD
		svy, subpop(if sample_16_64_u_nowld == 1): mean employed
		matrix b = e(b)
		scalar p_nowld = b[1,1]

		* Overall WLD prevalence
		svy, subpop(if sample_16_64_u == 1): mean wld_any_imploc
		matrix b = e(b)
		scalar prev = b[1,1]

		* Conventional and prevalence-adjusted gaps
		scalar gap = p_nowld - p_wld
		scalar gap_adj = prev * gap

		count if sample_16_64_u == 1 & !missing(employed)
		scalar N = r(N)

		matrix empgap[`row',1] = 100*p_wld
		matrix empgap[`row',2] = 100*p_nowld
		matrix empgap[`row',3] = 100*gap
		matrix empgap[`row',4] = 100*prev
		matrix empgap[`row',5] = 100*gap_adj
		matrix empgap[`row',6] = N

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
		2010 2011 2012 2013 2014 ///
		2015 2016 2017 2018 2019

	mat list empgap, format(%9.1f)

	* Export to RTF
	esttab matrix(empgap) using ///
	"$path6/soep_opchap_conventional_and_adjusted_employment_gap.rtf", ///
	title("SOEP: Employment Rates and Disability Employment Gaps") ///
	cell("fmt(1 1 1 1 1 0)") ///
	addnote("Weighted estimates using cross-sectional survey weights. Conventional gap = employment rate (non-WLD) minus employment rate (WLD). Prevalence-adjusted gap = conventional gap multiplied by annual WLD prevalence.") ///
	replace
	
	* Export to CSV
		* Convert matrix to dataset
		clear
		svmat double empgap, names(col)

		* Create year variable
		gen Year = 2009 + _n
		order Year

		* Round percentage columns to one decimal place
		foreach var of varlist Employed_WLD Employed_NoWLD Conventional_Gap ///
							WLD_Prevalence Prev_Adjusted_Gap {
			replace `var' = round(`var', 0.1)
		}

		* Export to CSV
		export delimited using ///
		"$path6/soep_opchap_conventional_and_adjusted_employment_gap.csv", ///
		replace

/* OLD: Table of conventional employment gap by WLD with SEs (using sample flags)
***************************************************************

	* Clear previous
	matrix drop _all
	scalar drop _all

	* Create matrix
	matrix empgap = J(10, 7, .)

	* Define year labels
	local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019

	* Start row counter
	local i = 1

	foreach year of local years {

		preserve

		use "$path2/soep_clean.dta", clear
		keep if syear == `year'

		svyset, clear
		svyset psu [pweight=phrf], strata(strat) singleunit(centered)

		* WLD
		svy, subpop(if sample_25_54_soep_u_wld == 1): mean employed
		matrix b1 = e(b)
		matrix V1 = e(V)
		scalar p_wld = b1[1,1]
		scalar se_wld = sqrt(V1[1,1])

		* No-WLD
		svy, subpop(if sample_25_54_soep_u_nowld == 1): mean employed
		matrix b2 = e(b)
		matrix V2 = e(V)
		scalar p_nowld = b2[1,1]
		scalar se_nowld = sqrt(V2[1,1])

		* Gap and SE
		scalar gap = p_nowld - p_wld
		scalar se_gap = sqrt(V1[1,1] + V2[1,1])

		* Sample size
		count if inlist(1, sample_25_54_soep_u_wld, sample_25_54_soep_u_nowld)
		scalar N = r(N)

		* Store in matrix
		matrix empgap[`i', 1] = 100 * p_wld
		matrix empgap[`i', 2] = 100 * p_nowld
		matrix empgap[`i', 3] = 100 * gap
		matrix empgap[`i', 4] = floor(N)
		matrix empgap[`i', 5] = 100 * se_wld
		matrix empgap[`i', 6] = 100 * se_nowld
		matrix empgap[`i', 7] = 100 * se_gap

		restore

		local ++i
	}

	matrix colnames empgap = Employed_WLD Employed_NoWLD Gap N SE_WLD SE_NoWLD SE_Gap
	matrix rownames empgap = 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019

	mat list empgap

	* Round values to 1 decimal place (exclude N)
	forvalues i = 1/10 {
		forvalues j = 1/3 {
			matrix empgap[`i', `j'] = round(empgap[`i', `j'], 0.1)
		}
		forvalues j = 5/7 {
			matrix empgap[`i', `j'] = round(empgap[`i', `j'], 0.1)
		}
	}

	* Reorder columns
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
	matrix rownames empgap_reordered = 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019

	matlist empgap_reordered

	* Export to Word
	esttab matrix(empgap_reordered) using "$path6/soep_employment_gap_ordered.rtf", ///
		replace title("SOEP: Employment by WLD Status") ///
		cell("fmt(%9.1f)") nonumber nomtitle ///
		addnote("Note: SOEP data; unbalanced sample aged 25–54 with complete cases. Percentages are adjusted for survey design and non-response. The standard error for the gap was calculated as the square root of the sum of the variances of the two employment rate estimates.")
	

* Graph trend

	* Convert matrix to dataset
	clear
	matrix list empgap_reordered

	* Create a new dataset from the matrix
	svmat empgap_reordered, names(col)
	gen year = 2010 + _n - 1  // Create a 'year' variable based on matrix rownames

	* List the data to confirm
	list in 1/10

	* Compute confidence intervals for WLD and No-WLD
	gen ci_low_wld = Employed_WLD - 1.96 * SE_WLD
	gen ci_high_wld = Employed_WLD + 1.96 * SE_WLD

	gen ci_low_nowld = Employed_NoWLD - 1.96 * SE_NoWLD
	gen ci_high_nowld = Employed_NoWLD + 1.96 * SE_NoWLD
	
	* Graph with CIs
	twoway ///
	  (rcap ci_low_wld ci_high_wld year, color(blue%50)) ///
	  (rcap ci_low_nowld ci_high_nowld year, color(red%50)) ///
	  (connected Employed_WLD year, sort msymbol(circle) lcolor(blue) mcolor(blue) lwidth(medthick) msize(medium)) ///
	  (connected Employed_NoWLD year, sort msymbol(square) lcolor(red) mcolor(red) lwidth(medthick) msize(medium)), ///
	  legend(order(3 "WLD" 4 "No WLD") rows(1) position(6)) ///
	  ytitle("Employment rate (%)") ///
	  xtitle("SOEP year") ///
	  xlabel(2010(1)2019) ///
	  ylabel(30(10)90) ///
	  yscale(range(30 90)) ///
	  graphregion(color(white))

	graph export "$path7/soep_empsitchapt_emp_gap.png", width(2000) replace
*/

********************************************************************************
**# 				LM STRATIFICATION CHAP 
********************************************************************************
*-------------------------------------------------------------------------------
**# Create sample flags 25-59
*-------------------------------------------------------------------------------

* Open dataset with recoded & imputed variables
	use "$path2/soep_clean.dta", clear

* Create unbalanced sample flags
******************************************************************************** 

* Load SOEP dataset 
***********************************
use "$path2/soep_clean.dta", clear
matrix drop _all

* Step 1: Define Core Conditions
************************************
gen byte cond1 = (netto <= 19)  // Individual interview
gen byte cond2 = inrange(age, 25, 59)
gen byte cond3 = !missing(wld_any_imploc, employed, syear, psu, strat, phrf, age, sex, ///
	mastat, isced_re, esec_short, parttime, fixedterm, pubsec, jbsize, isic_agg, ///
	nkids, sampreg, germborn)

* Step 2: Create Sample Flags
**********************************

/* General unbalanced sample (cross-sectional)
gen byte sample_25_59_soep_u        = 0
gen byte sample_25_59_soep_u_wld    = 0
gen byte sample_25_59_soep_u_nowld  = 0

replace sample_25_59_soep_u       = 1 if cond1 & cond2 & cond3
replace sample_25_59_soep_u_wld   = 1 if sample_25_59_soep_u == 1 & wld_any_imploc == 1
replace sample_25_59_soep_u_nowld = 1 if sample_25_59_soep_u == 1 & wld_any_imploc == 0

* Employed + complete outcomes (for pooled models)
gen byte sample_25_59_soep_u_emp_cc        = 0
gen byte sample_25_59_soep_u_emp_cc_wld    = 0
gen byte sample_25_59_soep_u_emp_cc_nowld  = 0

replace sample_25_59_soep_u_emp_cc = 1 if sample_25_59_soep_u == 1 & employed == 1 ///
	& !missing(prof, fulltime, permanent, smallcomp, pubsec_re, services)

replace sample_25_59_soep_u_emp_cc_wld   = 1 if sample_25_59_soep_u_emp_cc == 1 & wld_any_imploc == 1
replace sample_25_59_soep_u_emp_cc_nowld = 1 if sample_25_59_soep_u_emp_cc == 1 & wld_any_imploc == 0

* Non-employed (no restriction on outcome completeness)
gen byte sample_25_59_soep_u_nonemp        = 0
gen byte sample_25_59_soep_u_nonemp_wld    = 0
gen byte sample_25_59_soep_u_nonemp_nowld  = 0

replace sample_25_59_soep_u_nonemp = 1 if sample_25_59_soep_u == 1 & employed == 0
replace sample_25_59_soep_u_nonemp_wld   = 1 if sample_25_59_soep_u_nonemp == 1 & wld_any_imploc == 1
replace sample_25_59_soep_u_nonemp_nowld = 1 if sample_25_59_soep_u_nonemp == 1 & wld_any_imploc == 0
*/

* Step 3: Diagnostics Table (with WLD/Employment Subsamples)
***************************************************************

	matrix steps_soep = J(10, 2, .)
	local rownames_soep "Original" "Condition1_IndivInterview" "Condition2_Age2559" ///
		"Condition3_CompleteCases" ///
		"Final (u_emp_cc)" "Final (u_nonemp)" ///
		"Final (u_emp_cc_wld)" "Final (u_emp_cc_nowld)" ///
		"Final (u_nonemp_wld)" "Final (u_nonemp_nowld)"

	count
	matrix steps_soep[1,1] = r(N)

	count if cond1
	matrix steps_soep[2,1] = r(N)

	count if cond1 & cond2
	matrix steps_soep[3,1] = r(N)

	count if cond1 & cond2 & cond3
	matrix steps_soep[4,1] = r(N)

	count if sample_25_59_soep_u_emp_cc == 1
	matrix steps_soep[5,1] = r(N)

	count if sample_25_59_soep_u_nonemp == 1
	matrix steps_soep[6,1] = r(N)

	count if sample_25_59_soep_u_emp_cc_wld == 1
	matrix steps_soep[7,1] = r(N)

	count if sample_25_59_soep_u_emp_cc_nowld == 1
	matrix steps_soep[8,1] = r(N)

	count if sample_25_59_soep_u_nonemp_wld == 1
	matrix steps_soep[9,1] = r(N)

	count if sample_25_59_soep_u_nonemp_nowld == 1
	matrix steps_soep[10,1] = r(N)

	forvalues i = 2/10 {
		matrix steps_soep[`i',2] = steps_soep[`i'-1,1] - steps_soep[`i',1]
	}

	matrix rownames steps_soep = `rownames_soep'
	matrix colnames steps_soep = Remaining Excluded
	matlist steps_soep, format(%9.0g)

	putexcel set "$path6/soep_empsitchapt_25_59_unbalanced_sample_exclusions.xlsx", replace
	putexcel A1=matrix(steps_soep), names


* Step 4: Unweighted Counts by Year
*************************************

	matrix sample_year_n = J(10, 9, .)
	local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
	local i = 1

	foreach y of local years {
		count if syear == `y' & sample_25_59_soep_u == 1
		matrix sample_year_n[`i', 1] = r(N)
		count if syear == `y' & sample_25_59_soep_u_wld == 1
		matrix sample_year_n[`i', 2] = r(N)
		count if syear == `y' & sample_25_59_soep_u_nowld == 1
		matrix sample_year_n[`i', 3] = r(N)

		count if syear == `y' & sample_25_59_soep_u_emp_cc == 1
		matrix sample_year_n[`i', 4] = r(N)
		count if syear == `y' & sample_25_59_soep_u_emp_cc_wld == 1
		matrix sample_year_n[`i', 5] = r(N)
		count if syear == `y' & sample_25_59_soep_u_emp_cc_nowld == 1
		matrix sample_year_n[`i', 6] = r(N)

		count if syear == `y' & sample_25_59_soep_u_nonemp == 1
		matrix sample_year_n[`i', 7] = r(N)
		count if syear == `y' & sample_25_59_soep_u_nonemp_wld == 1
		matrix sample_year_n[`i', 8] = r(N)
		count if syear == `y' & sample_25_59_soep_u_nonemp_nowld == 1
		matrix sample_year_n[`i', 9] = r(N)

		local ++i
	}

	matrix rownames sample_year_n = y2010 y2011 y2012 y2013 y2014 y2015 y2016 y2017 y2018 y2019
	matrix colnames sample_year_n = sample_u sample_u_wld sample_u_nowld ///
		sample_emp_cc_u sample_emp_cc_u_wld sample_emp_cc_u_nowld ///
		sample_nonemp_u sample_nonemp_u_wld sample_nonemp_u_nowld

	putexcel set "$path6/soep_empsitchapt_25_59_unbalanced_counts_by_year.xlsx", replace
	putexcel A1=matrix(sample_year_n), names

* Step 5: Clean Up and Save
*****************************

drop cond1 cond2 cond3

* save "$path2/soep_clean.dta", replace


* Create balanced samples
********************************************************************************

* Step 0: Load SOEP dataset 
*************************************
use "$path2/soep_clean.dta", clear
matrix drop _all

* Step 1: Define Core Conditions
***********************************

* Condition 1: Individual interview
gen byte cond1 = (netto <= 19)

* Condition 2: Age 25–59
gen byte cond2 = inrange(age, 25, 59)

* Condition 3: Complete case on core covariates (excluding employment and outcomes)
gen byte cond3 = !missing(wld_any_imploc, employed, syear, psu, strat, phrf, age, sex, ///
	mastat, isced_re, esec_short, parttime, fixedterm, pubsec, jbsize, isic_agg, ///
	nkids, sampreg, germborn)

* Valid row-level observation
gen byte valid_obs_all = cond1 & cond2 & cond3

* Count valid waves per person
egen wavecount_all = total(valid_obs_all), by(pid)

* Balanced panel: must meet all conditions in all 10 years (2010–2019)
gen byte cond_balanced_all = (wavecount_all == 10)

/* Step 2: Create Balanced Sample Flag
*********************************************
gen byte sample_25_59_bal        = 0
gen byte sample_25_59_bal_wld    = 0
gen byte sample_25_59_bal_nowld  = 0

replace sample_25_59_bal       = 1 if valid_obs_all == 1 & cond_balanced_all == 1
replace sample_25_59_bal_wld   = 1 if sample_25_59_bal == 1 & wld_any_imploc == 1
replace sample_25_59_bal_nowld = 1 if sample_25_59_bal == 1 & wld_any_imploc == 0

* Step 3: Define Employed Analytic Sample (with complete outcome data)
*************************************************************************
gen byte sample_25_59_bal_emp_cc        = 0
gen byte sample_25_59_bal_emp_cc_wld    = 0
gen byte sample_25_59_bal_emp_cc_nowld  = 0

replace sample_25_59_bal_emp_cc = 1 if sample_25_59_bal == 1 & employed == 1 ///
	& !missing(prof, fulltime, permanent, smallcomp, pubsec_re, services)

replace sample_25_59_bal_emp_cc_wld   = 1 if sample_25_59_bal_emp_cc == 1 & wld_any_imploc == 1
replace sample_25_59_bal_emp_cc_nowld = 1 if sample_25_59_bal_emp_cc == 1 & wld_any_imploc == 0

* Step 4: Define Non-Employed Sample (no outcome restriction)
********************************************************************************
gen byte sample_25_59_bal_nonemp        = 0
gen byte sample_25_59_bal_nonemp_wld    = 0
gen byte sample_25_59_bal_nonemp_nowld  = 0

replace sample_25_59_bal_nonemp = 1 if sample_25_59_bal == 1 & employed == 0
replace sample_25_59_bal_nonemp_wld   = 1 if sample_25_59_bal_nonemp == 1 & wld_any_imploc == 1
replace sample_25_59_bal_nonemp_nowld = 1 if sample_25_59_bal_nonemp == 1 & wld_any_imploc == 0
*/

* Step 5: Diagnostics Table (with 4 analytic subsamples)
********************************************************************************
	matrix steps_bal = J(10, 2, .)

	count
	matrix steps_bal[1,1] = r(N)

	count if cond1
	matrix steps_bal[2,1] = r(N)

	count if cond1 & cond2
	matrix steps_bal[3,1] = r(N)

	count if cond1 & cond2 & cond3
	matrix steps_bal[4,1] = r(N)

	count if sample_25_59_bal == 1
	matrix steps_bal[5,1] = r(N)

	count if sample_25_59_bal_emp_cc == 1
	matrix steps_bal[6,1] = r(N)

	count if sample_25_59_bal_nonemp == 1
	matrix steps_bal[7,1] = r(N)

	count if sample_25_59_bal_emp_cc_wld == 1
	matrix steps_bal[8,1] = r(N)

	count if sample_25_59_bal_emp_cc_nowld == 1
	matrix steps_bal[9,1] = r(N)

	count if sample_25_59_bal_nonemp_wld == 1
	matrix steps_bal[10,1] = r(N)

	count if sample_25_59_bal_nonemp_nowld == 1
	matrix steps_bal = steps_bal \ (r(N), .)
	local rownames_bal = `"`rownames_bal'" "Final (sample_25_59_bal_nonemp_nowld)"'

	forvalues i = 2/11 {
		matrix steps_bal[`i',2] = steps_bal[`i'-1,1] - steps_bal[`i',1]
	}

	matrix rownames steps_bal = "Original" "Condition1_IndivInterview" "Condition2_Age2559" ///
		"Condition3_CompleteCases" "Condition4_BalancedPanel" ///
		"Final (sample_25_59_bal_emp_cc)" "Final (sample_25_59_bal_nonemp)" ///
		"Final (sample_25_59_bal_emp_cc_wld)" "Final (sample_25_59_bal_emp_cc_nowld)" ///
		"Final (sample_25_59_bal_nonemp_wld)" "Final (sample_25_59_bal_nonemp_nowld)"
	matrix colnames steps_bal = Remaining Excluded
	matlist steps_bal, format(%9.0g)

	putexcel set "$path6/soep_empsitchapt_25_59_balanced_sample_exclusions.xlsx", replace
	putexcel A1=matrix(steps_bal), names

* Step 6: Clean Up and Save
*****************************
drop cond1 cond2 cond3 valid_obs_all wavecount_all cond_balanced_all
save "$path2/soep_clean.dta", replace


*-------------------------------------------------------------------------------
**# WLD and socio-demographics
*-------------------------------------------------------------------------------

* Cross-sectional table
*************************

	* Load and restrict dataset to 2014

	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design with cross-sectional weight

	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Generate unweighted sample sizes

	count if sample_25_59_soep_u_emp_cc_wld == 1
	scalar N1 = r(N)
	count if sample_25_59_soep_u_nonemp_wld == 1
	scalar N2 = r(N)
	count if sample_25_59_soep_u_emp_cc_nowld == 1
	scalar N3 = r(N)
	count if sample_25_59_soep_u_nonemp_nowld == 1
	scalar N4 = r(N)

	* Generate dtable outputs for each subgroup

	collect clear

	* WLD employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_soep_u_emp_cc_wld == 1) ///
		name(wld_emp1)
	collect label levels result wld_emp1 "WLD employed"

	* WLD not employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_soep_u_nonemp_wld == 1) ///
		name(wld_emp2)
	collect label levels result wld_emp2 "WLD not employed"

	* No WLD employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_soep_u_emp_cc_nowld == 1) ///
		name(wld_emp3)
	collect label levels result wld_emp3 "No WLD employed"

	* No WLD not employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_soep_u_nonemp_nowld == 1) ///
		name(wld_emp4)
	collect label levels result wld_emp4 "No WLD not employed"

	* Step 3: Combine and format table
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
		(var[age nkids 1.sex 2.sex ///
			  1.germborn 2.germborn ///
			  1.mastat 2.mastat 3.mastat ///
			  0.isced_re 1.isced_re 2.isced_re 3.isced_re 4.isced_re]) ///
		(collection)

	* One decimal place
	collect style cell, nformat(%6.1f)

	* Title
	collect title "Germany: Characteristics by WLD and employment status (SOEP 2014)"
	collect note "Unweighted N: WLD emp = `=N1', WLD not emp = `=N2', No WLD emp = `=N3', No WLD not emp = `=N4'"

	collect export "$path6/soep_empsitchapt_wldemp_chars_2014.docx", replace


* Pooled descriptive table
*****************************

	* Step 1: Load data and set survey design

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Step 2: Store unweighted sample sizes

	count if sample_25_59_bal_emp_cc_wld == 1
	scalar N1 = r(N)

	count if sample_25_59_bal_nonemp_wld == 1
	scalar N2 = r(N)
	
	count if sample_25_59_bal_emp_cc_nowld == 1
	scalar N3 = r(N)

	count if sample_25_59_bal_nonemp_nowld == 1
	scalar N4 = r(N)

	* Step 3: Generate dtable results for each group

	collect clear

	* WLD employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_bal_emp_cc_wld == 1) ///
		name(wld_emp1)
	collect label levels result wld_emp1 "WLD employed"

	* WLD not employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_bal_nonemp_wld == 1) ///
		name(wld_emp3)
	collect label levels result wld_emp2 "WLD not employed"
	
	* No WLD employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_bal_emp_cc_nowld == 1) ///
		name(wld_emp2)
	collect label levels result wld_emp3 "No WLD employed"

	* No WLD not employed
	dtable, ///
		factor(sex germborn mastat isced_re, stat(fvpercent)) ///
		cont(age nkids, stat(mean)) ///
		svy subpop(if sample_25_59_bal_nonemp_nowld == 1) ///
		name(wld_emp4)
	collect label levels result wld_emp4 "No WLD not employed"

	* Step 4: Combine collections and format table

	collect combine wldemp = wld_emp1 wld_emp2 wld_emp3 wld_emp4
	
	* Reorder variables (no _N)
	collect layout ///
		(var[age nkids 1.sex 2.sex ///
			  1.germborn 2.germborn ///
			  1.mastat 2.mastat 3.mastat ///
			  0.isced_re 1.isced_re 2.isced_re 3.isced_re 4.isced_re]) ///
		(collection)

	collect style cell, nformat(%6.1f)
	collect preview

	* Step 5: Add title and note (incl. sample sizes)

	collect title "Germany 2010-2019: Comparison of characteristics across WLD × employment sub-samples (Balanced sample)"
	collect note "SOEP data (2010–2019); balanced sample aged 25–59 with complete cases. Weighted using longitudinal weights. Percentages and means are adjusted for survey design and non-response." 

	collect note "Unweighted N: WLD emp = `=N1', WLD not emp = `=N2', No WLD emp = `=N3', No WLD not emp = `=N4'"
	
	* Step 6: Export

	collect export "$path6/soep_empsitchapt_wldemp_chars_pooled.docx", replace

	
*-------------------------------------------------------------------------------
**# WLD and labour market segmentation: descriptive statistics
*-------------------------------------------------------------------------------

* Unweighted bivariate comparisons between WLD and empl vars
****************************************************************

* 2014

	* Step 0: Load SOEP data and restrict to 2014 & subpopulation
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014 & sample_25_59_soep_u_emp_cc == 1 & !missing(wld_any_imploc)

	* Step 1: Define employment variables and row names
	local vars esec3 parttime fixedterm jbsize pubsec isic_broad
	local rownames "esec3" "parttime" "fixedterm" "jbsize" "pubsec" "isic_broad"

	* Step 2: Create results matrix (6 x 3)
	matrix results = J(6, 3, .)
	matrix rownames results = `rownames'
	matrix colnames results = "Chi2" "P" "V"

	* Step 3: Loop over employment variables
	local i = 1
	foreach var of local vars {
		
		* Crosstab (unweighted) with Chi² and Cramer's V
		if "`var'" == "isic_broad" {
			tab wld_any_imploc `var' if inrange(`var', 1, 3), chi2 V
		}
		else {
			tab wld_any_imploc `var' if !missing(`var'), chi2 V
		}

		* Extract statistics
		matrix results[`i', 1] = r(chi2)
		matrix results[`i', 2] = r(p)
		matrix results[`i', 3] = r(CramersV)

		di "Done with `var'"
		local ++i
	}

	* Step 4: Export to Excel
	putexcel set "$path6/soep_empsitchapt_2014_bivariate_unweighted.xlsx", replace
	putexcel A1 = matrix(results), names

* POOLED BALANCED

	* Step 0: Load SOEP data and restrict to subpopulation
	use "$path2/soep_clean.dta", clear
	keep if sample_25_59_bal_emp_cc == 1 & !missing(wld_any_imploc)

	* Step 1: Define employment variables and row names
	local vars esec3 parttime fixedterm jbsize pubsec isic_broad
	local rownames "esec3" "parttime" "fixedterm" "jbsize" "pubsec" "isic_broad"

	* Step 2: Create results matrix (6 x 3)
	matrix results = J(6, 3, .)
	matrix rownames results = `rownames'
	matrix colnames results = "Chi2" "P" "V"

	* Step 3: Loop over employment variables
	local i = 1
	foreach var of local vars {
		
		* Crosstab (unweighted) with Chi² and Cramer's V
		if "`var'" == "isic_broad" {
			tab wld_any_imploc `var' if inrange(`var', 1, 3), chi2 V
		}
		else {
			tab wld_any_imploc `var' if !missing(`var'), chi2 V
		}

		* Extract statistics
		matrix results[`i', 1] = r(chi2)
		matrix results[`i', 2] = r(p)
		matrix results[`i', 3] = r(CramersV)

		di "Done with `var'"
		local ++i
	}

	* Step 4: Export to Excel
	putexcel set "$path6/soep_empsitchapt_pooled_bivariate_unweighted.xlsx", replace
	putexcel A1 = matrix(results), names

	
**# 3-class ESeC
******************

	* Repeated x-sectional charts
	
	* Loop over survey years 2010–2019
		forvalues year = 2010/2019 {

			di in green "Processing year `year'"

			use "$path2/soep_clean.dta", clear
			keep if syear == `year'

			* Set survey design
			svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

			* --- WLD group ---
			capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
				proportion esec3 if inrange(esec3, 1, 3)
			if _rc != 0 {
				di in red "WLD group failed for year `year'. Skipping."
				continue
			}
			matrix prop_wld = r(table)

			* --- No-WLD group ---
			capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
				proportion esec3 if inrange(esec3, 1, 3)
			if _rc != 0 {
				di in red "No-WLD group failed for year `year'. Skipping."
				continue
			}
			matrix prop_nowld = r(table)

			* Combine results into dataset
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

			* Grouped bar spacing
			gen xpos = .
			replace xpos = class - 0.15 if wld == 1
			replace xpos = class + 0.15 if wld == 0
			gen x  = xpos if wld == 1
			gen x2 = xpos if wld == 0

			* Labels
			gen wld_label     = round(prop)    if wld == 1
			gen nowld_label   = round(prop)    if wld == 0
			gen wld_label_y   = ci_high + 2    if wld == 1
			gen nowld_label_y = ci_high + 2    if wld == 0

			label define esec3_lbl 1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine"
			label values class esec3_lbl

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
				title("SOEP `year': Socio-economic classification by WLD Status") ///
				legend(order(2 "WLD" 5 "No-WLD") position(6)) ///
				xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
				ylabel(0(10)70, format(%4.0f)) ///
				yscale(range(0 70)) ///
				yline(0, lcolor(gs8)) ///
				graphregion(color(white))

			* Export
			graph export "$path7/`year'_soep_empsitchapt_esec3_25_59.png", replace
		}

* 	POOLED BALANCED ESeC3

	clear all
	set more off
	use "$path2/soep_clean.dta", clear

	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion esec3 if inrange(esec3,1,3)
	matrix prop_wld = r(table)

	* No WLD
	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion esec3 if inrange(esec3,1,3)
	matrix prop_nowld = r(table)

	* Build plotting data
	clear
	set obs 6
	gen class = cond(_n<=3,_n,_n-3)
	gen wld   = cond(_n<=3,1,0)

	gen prop = .
	gen se   = .
	forvalues i=1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}
	gen ci_low  = prop - 1.96*se
	gen ci_high = prop + 1.96*se

	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	gen wld_label     = round(prop)    if wld==1
	gen nowld_label   = round(prop)    if wld==0
	gen wld_label_y   = ci_high + 2    if wld==1
	gen nowld_label_y = ci_high + 2    if wld==0

	label define esec3_lbl 1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class esec3_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)) ///
	 , ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010-2019: Socio-economic classification by WLD status") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	 ylabel(0(10)60, format(%4.0f)) yscale(range(0 60)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_esec3_25_59.png", replace

	
**# PT employment
*******************

* SOEP part-time cross-sectional graphs, 2010–2019
local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
foreach y of local years {

    di in green "Processing year `y'"

    use "$path2/soep_clean.dta", clear
    keep if syear == `y'

    svyset, clear
    svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

    * WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
        proportion parttime if inrange(parttime, 1, 3)
    if _rc di in red "WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_wld = r(table)

    * No-WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
        proportion parttime if inrange(parttime, 1, 3)
    if _rc di in red "No-WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_nowld = r(table)

    * Build plotting dataset
    clear
    set obs 6
    gen class = cond(_n<=3,_n,_n-3)
    gen wld   = cond(_n<=3,1,0)

    gen prop = .
	gen se   = .
    forvalues i=1/3 {
        replace prop = prop_wld[1,`i']*100 in `i'
        replace se   = prop_wld[2,`i']*100 in `i'
        replace prop = prop_nowld[1,`i']*100 in `=`i'+3'
        replace se   = prop_nowld[2,`i']*100 in `=`i'+3'
    }

    gen ci_low=prop-1.96*se
    gen ci_high=prop+1.96*se

    gen xpos=.
    replace xpos = class-0.15 if wld==1
    replace xpos = class+0.15 if wld==0
    gen x=xpos if wld==1
    gen x2=xpos if wld==0

    gen wld_label=round(prop) if wld==1
    gen nowld_label=round(prop) if wld==0
    gen wld_label_y=ci_high+2 if wld==1
    gen nowld_label_y=ci_high+2 if wld==0

    label define parttime_lbl 1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)"
    label values class parttime_lbl

    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red))  ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
      xtitle("") ytitle("Percentage (%)") ///
      title("SOEP `y': Part-time employment by WLD status") ///
      legend(order(2 "WLD" 5 "No WLD") position(6)) ///
      xlabel(1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)", angle(0)) ///
      ylabel(0(10)80, format(%4.0f)) yscale(range(0 80)) ///
      yline(0, lcolor(gs8)) graphregion(color(white))

    graph export "$path7/`y'_soep_empsitchapt_parttime_25_59.png", replace
}


* Pooled balanced part-time

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion parttime if inrange(parttime, 1, 3)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion parttime if inrange(parttime, 1, 3)
	matrix prop_nowld = r(table)

	clear
	set obs 6
	gen class = cond(_n<=3,_n,_n-3)
	gen wld   = cond(_n<=3,1,0)

	gen prop = .
	gen se   = .
	forvalues i=1/3 {
		replace prop = prop_wld[1,`i']*100 in `i'
		replace se   = prop_wld[2,`i']*100 in `i'
		replace prop = prop_nowld[1,`i']*100 in `=`i'+3'
		replace se   = prop_nowld[2,`i']*100 in `=`i'+3'
	}

	gen ci_low=prop-1.96*se
	gen ci_high=prop+1.96*se

	gen xpos=.
	replace xpos=class-0.15 if wld==1
	replace xpos=class+0.15 if wld==0
	gen x=xpos if wld==1
	gen x2=xpos if wld==0

	gen wld_label=round(prop) if wld==1
	gen nowld_label=round(prop) if wld==0
	gen wld_label_y=ci_high+2 if wld==1
	gen nowld_label_y=ci_high+2 if wld==0

	label define parttime_lbl 1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)"
	label values class parttime_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010–2019: Part-time employment by WLD status") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Full-time (>=35h)" 2 "Regular part-time (11–34h)" 3 "Marginal part-time (<=10h)", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_parttime_25_59.png", replace

		
**# Fixed-term employment
****************************

* SOEP fixed-term cross-sectional graphs, 2010–2019

local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
foreach y of local years {

    di in green "Processing year `y'"

    use "$path2/soep_clean.dta", clear
    keep if syear == `y'

    svyset, clear
    svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
        proportion fixedterm if inrange(fixedterm, 1, 2)
    if _rc di in red "WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_wld = r(table)

    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
        proportion fixedterm if inrange(fixedterm, 1, 2)
    if _rc di in red "No-WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_nowld = r(table)

    clear
    set obs 4
    gen class = cond(_n<=2,_n,_n-2)
    gen wld   = cond(_n<=2,1,0)

    gen prop = .
	gen se   = .
    forvalues i=1/2 {
        replace prop = prop_wld[1,`i']*100 in `i'
        replace se   = prop_wld[2,`i']*100 in `i'
        replace prop = prop_nowld[1,`i']*100 in `=`i'+2'
        replace se   = prop_nowld[2,`i']*100 in `=`i'+2'
    }

    gen ci_low=prop-1.96*se
    gen ci_high=prop+1.96*se

    gen xpos=.
    replace xpos = class-0.15 if wld==1
    replace xpos = class+0.15 if wld==0
    gen x=xpos if wld==1
    gen x2=xpos if wld==0

    gen wld_label=round(prop) if wld==1
    gen nowld_label=round(prop) if wld==0
    gen wld_label_y=ci_high+2 if wld==1
    gen nowld_label_y=ci_high+2 if wld==0

    label define fixedterm_lbl 1 "Permanent" 2 "Non-permanent"
    label values class fixedterm_lbl

    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red))  ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
      xtitle("") ytitle("Percentage (%)") ///
      title("SOEP `y': Fixed-term employment by WLD status") ///
      legend(order(2 "WLD" 5 "No WLD") position(6)) ///
      xlabel(1 "Permanent" 2 "Non-permanent", angle(0)) ///
      ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
      yline(0, lcolor(gs8)) graphregion(color(white))

    graph export "$path7/`y'_soep_empsitchapt_fixedterm_25_59.png", replace
}


* Pooled balanced fixed term

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_nowld = r(table)

	clear
	set obs 4
	gen class = cond(_n<=2,_n,_n-2)
	gen wld   = cond(_n<=2,1,0)

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion fixedterm if inrange(fixedterm, 1, 2)
	matrix prop_nowld = r(table)

	clear
	set obs 4
	gen class = cond(_n<=2,_n,_n-2)
	gen wld   = cond(_n<=2,1,0)

	gen prop = .
	gen se   = .
	forvalues i=1/2 {
		replace prop = prop_wld[1,`i']*100 in `i'
		replace se   = prop_wld[2,`i']*100 in `i'
		replace prop = prop_nowld[1,`i']*100 in `=`i'+2'
		replace se   = prop_nowld[2,`i']*100 in `=`i'+2'
	}

	gen ci_low=prop-1.96*se
	gen ci_high=prop+1.96*se

	gen xpos=.
	replace xpos=class-0.15 if wld==1
	replace xpos=class+0.15 if wld==0
	gen x=xpos if wld==1
	gen x2=xpos if wld==0

	gen wld_label=round(prop) if wld==1
	gen nowld_label=round(prop) if wld==0
	gen wld_label_y=ci_high+2 if wld==1
	gen nowld_label_y=ci_high+2 if wld==0

	label define fixedterm_lbl 1 "Permanent" 2 "Non-permanent"
	label values class fixedterm_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010–2019: Fixed-term employment by WLD status") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Permanent" 2 "Non-permanent", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_fixedterm_25_59.png", replace


**# Company size
******************
	
* SOEP company size cross-sectional graphs, 2010–2019

local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
foreach y of local years {

    di in green "Processing year `y'"

    use "$path2/soep_clean.dta", clear
    keep if syear == `y'

    svyset, clear
    svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

    * WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
        proportion jbsize if inrange(jbsize, 1, 3)
    if _rc di in red "WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_wld = r(table)

    * No-WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
        proportion jbsize if inrange(jbsize, 1, 3)
    if _rc di in red "No-WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_nowld = r(table)

    * Build plotting dataset
    clear
    set obs 6
    gen class = cond(_n<=3,_n,_n-3)
    gen wld   = cond(_n<=3,1,0)

    gen prop=.
	gen se=.
    forvalues i=1/3 {
        replace prop = prop_wld[1,`i']*100 in `i'
        replace se   = prop_wld[2,`i']*100 in `i'
        replace prop = prop_nowld[1,`i']*100 in `=`i'+3'
        replace se   = prop_nowld[2,`i']*100 in `=`i'+3'
    }

    gen ci_low=prop-1.96*se
    gen ci_high=prop+1.96*se

    gen xpos=.
    replace xpos = class-0.15 if wld==1
    replace xpos = class+0.15 if wld==0
    gen x=xpos if wld==1
    gen x2=xpos if wld==0

    gen wld_label=round(prop) if wld==1
    gen nowld_label=round(prop) if wld==0
    gen wld_label_y=ci_high+2 if wld==1
    gen nowld_label_y=ci_high+2 if wld==0

    label define jbsize_lbl 1 "<10 incl self-emp" 2 "11–200" 3 ">200"
    label values class jbsize_lbl

    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red))  ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
      xtitle("") ytitle("Percentage (%)") ///
      title("SOEP `y': Company size by WLD status") ///
      legend(order(2 "WLD" 5 "No WLD") position(6)) ///
      xlabel(1 "<10 incl self-emp" 2 "11–200" 3 ">200", angle(0)) ///
      ylabel(0(10)80, format(%4.0f)) yscale(range(0 80)) ///
      yline(0, lcolor(gs8)) graphregion(color(white))

    graph export "$path7/`y'_soep_empsitchapt_jbsize_25_59.png", replace
}


* Pooled balanced company size 

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion jbsize if inrange(jbsize, 1, 3)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion jbsize if inrange(jbsize, 1, 3)
	matrix prop_nowld = r(table)

	clear
	set obs 6
	gen class = cond(_n<=3,_n,_n-3)
	gen wld   = cond(_n<=3,1,0)

	gen prop=.
	gen se=.
	forvalues i=1/3 {
		replace prop = prop_wld[1,`i']*100 in `i'
		replace se   = prop_wld[2,`i']*100 in `i'
		replace prop = prop_nowld[1,`i']*100 in `=`i'+3'
		replace se   = prop_nowld[2,`i']*100 in `=`i'+3'
	}

	gen ci_low=prop-1.96*se
	gen ci_high=prop+1.96*se

	gen xpos=.
	replace xpos=class-0.15 if wld==1
	replace xpos=class+0.15 if wld==0
	gen x=xpos if wld==1
	gen x2=xpos if wld==0

	gen wld_label=round(prop) if wld==1
	gen nowld_label=round(prop) if wld==0
	gen wld_label_y=ci_high+2 if wld==1
	gen nowld_label_y=ci_high+2 if wld==0

	label define jbsize_lbl 1 "<10 incl self-emp" 2 "11–200" 3 ">200"
	label values class jbsize_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010–2019: Company size by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "<10 incl self-emp" 2 "11–200" 3 ">200", angle(0)) ///
	 ylabel(0(10)80, format(%4.0f)) yscale(range(0 80)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_jbsize_25_59.png", replace

	
**# Company sector 
*******************

* SOEP company sector (pubsec) cross-sectional graphs, 2010–2019
local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
foreach y of local years {

    di in green "Processing year `y'"

    use "$path2/soep_clean.dta", clear
    keep if syear == `y'

    svyset, clear
    svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

    * WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
        proportion pubsec if inrange(pubsec, 1, 2)
    if _rc di in red "WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_wld = r(table)

    * No-WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
        proportion pubsec if inrange(pubsec, 1, 2)
    if _rc di in red "No-WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_nowld = r(table)

    * Build plotting dataset
    clear
    set obs 4
    gen class = cond(_n<=2,_n,_n-2)
    gen wld   = cond(_n<=2,1,0)

    gen prop=.
	gen se=.
    forvalues i=1/2 {
        replace prop = prop_wld[1,`i']*100 in `i'
        replace se   = prop_wld[2,`i']*100 in `i'
        replace prop = prop_nowld[1,`i']*100 in `=`i'+2'
        replace se   = prop_nowld[2,`i']*100 in `=`i'+2'
    }

    gen ci_low=prop-1.96*se
    gen ci_high=prop+1.96*se

    gen xpos=.
    replace xpos = class-0.15 if wld==1
    replace xpos = class+0.15 if wld==0
    gen x=xpos if wld==1
    gen x2=xpos if wld==0

    gen wld_label=round(prop) if wld==1
    gen nowld_label=round(prop) if wld==0
    gen wld_label_y=ci_high+2 if wld==1
    gen nowld_label_y=ci_high+2 if wld==0

    label define pubsec_lbl 1 "Not public sector" 2 "Public sector"
    label values class pubsec_lbl

    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red))  ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
      xtitle("") ytitle("Percentage (%)") ///
      title("SOEP `y': Company sector by WLD status") ///
      legend(order(2 "WLD" 5 "No WLD") position(6)) ///
      xlabel(1 "Not public sector" 2 "Public sector", angle(0)) ///
      ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
      yline(0, lcolor(gs8)) graphregion(color(white))

    graph export "$path7/`y'_soep_empsitchapt_pubsec_25_59.png", replace
}

* Pooled balanced company sector

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion pubsec if inrange(pubsec, 1, 2)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion pubsec if inrange(pubsec, 1, 2)
	matrix prop_nowld = r(table)

	clear
	set obs 4
	gen class = cond(_n<=2,_n,_n-2)
	gen wld   = cond(_n<=2,1,0)

	gen prop=.
	gen se=.
	forvalues i=1/2 {
		replace prop = prop_wld[1,`i']*100 in `i'
		replace se   = prop_wld[2,`i']*100 in `i'
		replace prop = prop_nowld[1,`i']*100 in `=`i'+2'
		replace se   = prop_nowld[2,`i']*100 in `=`i'+2'
	}

	gen ci_low=prop-1.96*se
	gen ci_high=prop+1.96*se

	gen xpos=.
	replace xpos=class-0.15 if wld==1
	replace xpos=class+0.15 if wld==0
	gen x=xpos if wld==1
	gen x2=xpos if wld==0

	gen wld_label=round(prop) if wld==1
	gen nowld_label=round(prop) if wld==0
	gen wld_label_y=ci_high+2 if wld==1
	gen nowld_label_y=ci_high+2 if wld==0

	label define pubsec_lbl 1 "Not public sector" 2 "Public sector"
	label values class pubsec_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,           barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,          barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010–2019: Company sector by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Not public sector" 2 "Public sector", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_pubsec_25_59.png", replace

**# Industrial sector
***********************

* SOEP broad industrial sector (isic_broad) cross-sectional graphs, 2010–2019

local years 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
foreach y of local years {

    di in green "Processing year `y'"

    use "$path2/soep_clean.dta", clear
    keep if syear == `y'

    svyset, clear
    svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

    * WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_wld == 1): ///
        proportion isic_broad if inrange(isic_broad, 1, 3)
    if _rc di in red "WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_wld = r(table)

    * No-WLD
    capture noisily svy, subpop(if sample_25_59_soep_u_emp_cc_nowld == 1): ///
        proportion isic_broad if inrange(isic_broad, 1, 3)
    if _rc di in red "No-WLD failed for `y'. Skipping."
    if _rc continue
    matrix prop_nowld = r(table)

    * Build plotting dataset
    clear
    set obs 6
    gen class = cond(_n <= 3, _n, _n - 3)
    gen wld   = cond(_n <= 3, 1, 0)

    gen prop = .
    gen se = .
    forvalues i = 1/3 {
        replace prop = prop_wld[1,`i'] * 100 in `i'
        replace se   = prop_wld[2,`i'] * 100 in `i'
        replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
        replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
    }

    gen ci_low = prop - 1.96 * se
    gen ci_high = prop + 1.96 * se

    gen xpos = .
    replace xpos = class - 0.15 if wld == 1
    replace xpos = class + 0.15 if wld == 0
    gen x = xpos if wld == 1
    gen x2 = xpos if wld == 0

    gen wld_label = round(prop) if wld == 1
    gen nowld_label = round(prop) if wld == 0
    gen wld_label_y = ci_high + 2 if wld == 1
    gen nowld_label_y = ci_high + 2 if wld == 0

    label define isic_broad_lbl ///
        1 "Agriculture, forestry, mining" ///
        2 "Industry" ///
        3 "Services"
    label values class isic_broad_lbl

    twoway ///
      (rcap ci_low ci_high x,  lcolor(blue)) ///
      (bar  prop x,            barwidth(0.25) color(blue%70)) ///
      (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
      (rcap ci_low ci_high x2, lcolor(red)) ///
      (bar  prop x2,           barwidth(0.25) color(red%70)) ///
      (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
      xtitle("") ytitle("Percentage (%)") ///
      title("SOEP `y': Broad industrial sector by WLD status") ///
      legend(order(2 "WLD" 5 "No WLD") position(6)) ///
      xlabel(1 "Agriculture, forestry, mining" 2 "Industry" 3 "Services", angle(0)) ///
      ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
      yline(0, lcolor(gs8)) graphregion(color(white))

    graph export "$path7/`y'_soep_empsitchapt_isicbroad_25_59.png", replace
}

* Pooled balanced broad industrial sector

	use "$path2/soep_clean.dta", clear
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_wld == 1): ///
		proportion isic_broad if inrange(isic_broad, 1, 3)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_emp_cc_nowld == 1): ///
		proportion isic_broad if inrange(isic_broad, 1, 3)
	matrix prop_nowld = r(table)

	clear
	set obs 6
	gen class = cond(_n <= 3, _n, _n - 3)
	gen wld   = cond(_n <= 3, 1, 0)

	gen prop = .
	gen se = .
	forvalues i = 1/3 {
		replace prop = prop_wld[1,`i'] * 100 in `i'
		replace se   = prop_wld[2,`i'] * 100 in `i'
		replace prop = prop_nowld[1,`i'] * 100 in `=`i'+3'
		replace se   = prop_nowld[2,`i'] * 100 in `=`i'+3'
	}

	gen ci_low = prop - 1.96 * se
	gen ci_high = prop + 1.96 * se

	gen xpos = .
	replace xpos = class - 0.15 if wld == 1
	replace xpos = class + 0.15 if wld == 0
	gen x = xpos if wld == 1
	gen x2 = xpos if wld == 0

	gen wld_label = round(prop) if wld == 1
	gen nowld_label = round(prop) if wld == 0
	gen wld_label_y = ci_high + 2 if wld == 1
	gen nowld_label_y = ci_high + 2 if wld == 0

	label define isic_broad_lbl ///
		1 "Agriculture, forestry, mining" ///
		2 "Industry" ///
		3 "Services"
	label values class isic_broad_lbl

	twoway ///
	 (rcap ci_low ci_high x,  lcolor(blue)) ///
	 (bar  prop x,            barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,  mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small)) ///
	 (rcap ci_low ci_high x2, lcolor(red)) ///
	 (bar  prop x2,           barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small)), ///
	 xtitle("") ytitle("Percentage (%)") ///
	 title("SOEP 2010–2019: Broad industrial sector by WLD") ///
	 legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	 xlabel(1 "Agriculture, forestry, mining" 2 "Industry" 3 "Services", angle(0)) ///
	 ylabel(0(10)100, format(%4.0f)) yscale(range(0 100)) ///
	 yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_empsitchapt_pooled_bal_isicbroad_25_59.png", replace
	
	
*-------------------------------------------------------------------------------
**# 6.5	Logit models
*-------------------------------------------------------------------------------

/* Re-code DV vars into dummies
********************************
	use "$path2/soep_clean.dta", clear

	* Social class: professional & managerial / other
		tab esec3, mis
		recode esec3 (0 = .) (2 3 = 0 "Intermediate/routine") ///
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
		tab jbsize, mis
		recode jbsize (0 = .) (1 = 1 "<10 or self-employed") (2 3 = 0 ">11"), ///
			gen(smallcomp) label(smallcomp_lb)
		numlabel, add
		label var smallcomp "Less than 10 employees or self-employed"
		tab smallcomp, mis

	* Public sector
		tab pubsec, mis
		recode pubsec (0 = .) (1 = 0 "Not public sector") ///
			(2 = 1 "Public sector"), gen(pubsec_re) label(pubsec_re_lb)
		label var pubsec_re "Public sector"
		numlabel, add
		tab pubsec_re, mis

	save "$path2/soep_clean.dta", replace

	* Re-code education into dummy
	********************************

	use "$path2/soep_clean.dta", clear

	tab isced_re, mis
	recode isced_re (0/3 = 0) (4 = 1), gen(degree)
	tab degree, mis
	label var degree "Has a degree (recoded ISCED)"
	save "$path2/soep_clean.dta", replace
	*/
* Table of n per variable to put into the chapter

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

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
		count if sample_25_59_soep_u_emp_cc_wld   == 1 & `var' == 1
		local n_wld_1 = r(N)
		count if sample_25_59_soep_u_emp_cc_nowld == 1 & `var' == 1
		local n_now_1 = r(N)
		count if sample_25_59_soep_u_emp_cc       == 1 & `var' == 1
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
		count if sample_25_59_soep_u_emp_cc_wld   == 1 & `var' == 0
		local n_wld_0 = r(N)
		count if sample_25_59_soep_u_emp_cc_nowld == 1 & `var' == 0
		local n_now_0 = r(N)
		count if sample_25_59_soep_u_emp_cc       == 1 & `var' == 0
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

	* Export as RTF
	esttab matrix(counts5, fmt(0 1 0 1 0)) using ///
		"$path6/soep_empsitchapt_2014_regdvs_n_pct.rtf", ///
		replace rtf nonumber noobs nomtitle ///
		title("Unweighted Frequencies and Row Percentages – SOEP 2015") ///
		note("Percentages are row % within WLD vs No WLD for each outcome value; totals are by sample.")

	* Export as Excel
	putexcel set "$path6/soep_empsitchapt_2014_regdvs_n_pct.xlsx", replace
	putexcel A1 = matrix(counts5), names

* 2015 logit models: exploration - not updated
************************************

* Loop for 5 full models + Wald tests

	* Load the dataset and keep only 2015
	use "$path2/soep_clean.dta", clear
	keep if syear == 2015

	* Set survey design
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re

	* Loop over outcome variables
	foreach yvar in `outcomes' {

		di as green "Running model for `yvar'..."

		* Run the model
		svy, subpop(sample_25_59_soep_u_emp_cc): logistic `yvar' i.wld_any_imploc age nkids ///
			i.sex i.germborn i.mastat i.isced_re

		* Store Wald test results
		matrix wald_`yvar' = J(6, 2, .)
		local row = 1

		test age
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)
		local ++row

		test nkids
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)
		local ++row

		test 2.sex
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)
		local ++row

		test 2.germborn
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)
		local ++row

		test 2.mastat 3.mastat
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)
		local ++row

		test 1.isced_re 2.isced_re 3.isced_re 4.isced_re
		matrix wald_`yvar'[`row', 1] = r(F)
		matrix wald_`yvar'[`row', 2] = r(p)

		* Label the matrix
		matrix rownames wald_`yvar' = age nkids sex germborn mastat isced
		matrix colnames wald_`yvar' = F_stat p_value

		di as text "Wald test results stored in matrix: wald_`yvar'"
	}

	* View all results 
	matlist wald_prof, format(%6.3f)
	matlist wald_fulltime, format(%6.3f)
	matlist wald_permanent, format(%6.3f)
	matlist wald_smallcomp, format(%6.3f)
	matlist wald_pubsec_re, format(%6.3f)

	* Closer inspection of model 1 (prof)- manually 
	
	use "$path2/soep_clean.dta", clear
	keep if syear == 2015
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	// empty model
	svy, subpop(sample_25_54_soep_usample_25_54_soep_u_emp_cc): logistic prof i.wld_any_imploc
	
	// socio-demographics
	svy, subpop(sample_25_54_soep_u_emp_cc): logistic prof i.wld_any_imploc age i.sex i.germborn

	// household composition
	svy, subpop(sample_25_54_soep_u_emp_cc): logistic prof i.wld_any_imploc age i.sex i.germborn ///
    nkids i.mastat

	// education
	svy, subpop(sample_25_54_soep_u_emp_cc): logistic prof i.wld_any_imploc age i.sex i.germborn ///
		nkids i.mastat i.isced_re

**# Diagnostics
******************

	* Multicollinearity - not updated for sample
	*--------------------
	
	// Run linear model without weights
	regress prof i.wld_any_imploc age i.sex i.germborn ///
		nkids i.mastat i.isced_re
	vif
	
	* Correlation between WLD and education
	tab wld_any_imploc isced_re, row col chi2
	
	* Simple model + marginal effects
	logit wld_any_imploc i.isced_re
	margins isced_re
	
	* Check again with recoded ed variable
	regress prof i.wld_any_imploc age i.sex i.germborn ///
		nkids i.mastat i.degree
	vif

* Pseudo-R2, AIC & BIC 
*-------------------------
	
// from unadjusted full models

* Cross-sectional 2014 models
	
	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run unweighted logistic regressions and store models
	foreach yvar of local outcomes {

		quietly logistic `yvar' i.wld_any_imploc age nkids ///
			i.sex i.germborn i.mastat i.degree ///
			if sample_25_59_soep_u_emp_cc == 1

		eststo diag_`yvar'
	}

	* Export model fit statistics to RTF
	esttab using "$path6/soep_empsitchapt_2014_diagstats_25_59.rtf", ///
		replace rtf ///
		scalars(r2_p aic bic) ///
		sfmt(3) ///
		title("Model Fit Statistics – Unweighted Models (SOEP 2014)")

* Pooled unadjusted models

	* Load full SOEP data
	use "$path2/soep_clean.dta", clear
	
	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re

	* Run unweighted logistic regressions and store models
	foreach yvar of local outcomes {

		quietly logistic `yvar' i.wld_any_imploc age nkids ///
			i.sex i.germborn i.mastat i.degree ///
			if sample_25_54_bal_emp_cc == 1

		eststo diag_`yvar'
	}

	* Export model fit statistics to RTF
	esttab using "$path6/soep_diagstats_pooled.rtf", ///
		replace rtf ///
		scalars(r2_p aic bic) ///
		sfmt(3) ///
		title("Model Fit Statistics – Unweighted Models (SOEP 2009-2019)")

	
**# Final models for exporting & graphing
******************************************

* 2014 with ORs & p values - full model

	// with re-coded education var
	// also changing sample to only employed
	
	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.wld_any_imploc age nkids i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_degree_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (Full Models)")


* 2014 full models for exporting - PredProbs 

	// with re-coded education var
	// sample changed to only employed
	// removing atmeans option

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	foreach yvar of local outcomes {

		* Run the full model 
		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.wld_any_imploc age nkids i.sex i.germborn i.mastat i.degree

		* Save subpopulation N before margins overwrites e()
		scalar subpopN = e(N_sub)

		* Margins for all categorical predictors, excluding any empty categories automatically
		margins wld_any_imploc sex germborn mastat degree, post

		* Store margins results
		eststo `yvar'

		* Add stored subpopulation N
		estadd scalar Observations = subpopN
	}

	* Export table with predicted probabilities
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_predprobs_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities – SOEP 2014 (full models)")


		
* Pairwise comparison of predicted probs for WLD

	// with re-coded education var
	// sample changed to only employed
	// removing atmeans option

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Define outcomes
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Clear and define results matrix (6 rows, 3 cols)
	matrix drop _all
	matrix predtable = J(6, 3, .)

	* Loop counter
	local i = 1

	foreach yvar of local outcomes {

		display "****************************************************"
		display "Outcome: `yvar'"
		display "****************************************************"

		* Run full model
		quietly svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
			i.wld_any_imploc age nkids i.sex i.germborn i.mastat i.degree

		* Predicted probabilities by WLD status (at means)
		margins wld_any_imploc, predict(pr)

		* Extract and round predicted probs
		matrix M = r(b)
		scalar p_nowld = round(M[1,1], .001)   // WLD = 0
		scalar p_wld   = round(M[1,2], .001)   // WLD = 1
		scalar diff    = round(p_nowld - p_wld, .001)

		* Store in matrix
		matrix predtable[`i',1] = p_wld
		matrix predtable[`i',2] = p_nowld
		matrix predtable[`i',3] = diff

		* Manual inspection of p-value
		pwcompare wld_any_imploc, effects post

		local ++i
	}

	* Label matrix rows/columns
	matrix rownames predtable = prof fulltime permanent smallcomp pubsec services
	matrix colnames predtable = WLD NonWLD Diff

	* Export to Word with esttab
	esttab matrix(predtable) using "$path6/soep_empsitchapt_2014_margins_25_59.rtf", ///
		replace rtf noobs ///
		title("Predicted Probabilities and Differences by WLD Status (At Means) – SOEP 2014") ///
		cells("WLD(fmt(3)) NonWLD(fmt(3)) Diff(fmt(3))") 
		
***************************
**# Sensitivity analyses
*************************** 

* A. Time-frame: pooled panel regression
********************************************

* Pooled OR table

	* Load full SOEP data
	use "$path2/soep_clean.dta", clear

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_bal_emp_cc == 1): logistic `yvar' i.wld_any_imploc age nkids ///
        i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_pooled_or_degree_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2010-2019 (Full Models)")
	
* Pooled balanced panel - Pred probs 

	* Load cleaned SOEP dataset
	use "$path2/soep_clean.dta", clear

	* Set longitudinal survey design
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	foreach yvar of local outcomes {

		* Run model for balanced panel
		svy, subpop(if sample_25_59_bal_emp_cc == 1): logistic `yvar' i.wld_any_imploc age nkids ///
			i.sex i.germborn i.mastat i.degree

		* Save subpop N before margins overwrites it
		scalar subpopN = e(N_sub)

		* Predicted probabilities (hold continuous vars at means)
		margins wld_any_imploc sex germborn mastat degree, post

		* Store margins
		eststo `yvar'

		* Add stored subpopulation N
		estadd scalar Observations = subpopN
	}

	* Export predicted probability table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_pooled_predprobs_pooled_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities – SOEP Balanced Panel (2010–2019) - full model")


* B. Removing education from models
************************************

* 2014 with ORs & p values - WITHOUT EDUCATION

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates (w/o education)
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.wld_any_imploc age nkids i.sex i.germborn i.mastat

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_NOED_25_59.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (No education)")
		
* 2014 predprobs without education - not updated

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)
	
	* Clear previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	foreach yvar of local outcomes {

		* Run the model w/o education
		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.wld_any_imploc age nkids i.sex i.germborn i.mastat

		* Save subpopulation N before margins overwrites e()
		scalar subpopN = e(N_sub)

		* Margins for all categorical predictors, excluding any empty categories automatically
		margins wld_any_imploc sex germborn mastat, post

		* Store margins results
		eststo `yvar'

		* Add stored subpopulation N
		estadd scalar Observations = subpopN
	}

	* Export table with predicted probabilities
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_predprobs_noed_25_59.rtf", replace ///
		rtf label noobs ///
		cells(b(fmt(2))) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Predicted Probabilities – SOEP 2014 (no education)")

* C. Changing the age range
*****************************

* 2014 ORs with 16-64 employed sample 

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_16_64_u == 1 & employed == 1): logistic `yvar' ///
		i.wld_any_imploc age nkids i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_degree_16_64.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (16-64)")

* D. Measures of disability
*****************************

* Long-standing impairment
	
	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.chronic_imploc age nkids i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_degree_25_59_chronic.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (Full Models)")

* Impairment and activity limitation

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.eadis age nkids i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_degree_25_59_eadis.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (Full Models)")

* Formal disability status

	* Load SOEP 2014 data
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Set survey design for SOEP
	svyset, clear
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear any previous estimates
	eststo clear

	* Define outcome variables
	local outcomes prof fulltime permanent smallcomp pubsec_re services

	* Run models and store estimates
	foreach yvar of local outcomes {

		svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logistic `yvar' ///
		i.distat age nkids i.sex i.germborn i.mastat i.degree

		eststo `yvar'

		* Store subpopulation N
		estadd scalar Observations = e(N_sub)
	}

	* Export appendix-style OR table
	esttab prof fulltime permanent smallcomp pubsec_re services using ///
		"$path6/soep_empsitchapt_2014_or_degree_25_59_distat.rtf", replace ///
		rtf eform label noobs ///
		cells(b(fmt(2) star)) ///
		stats(Observations, fmt(0)) ///
		nobaselevels gaps compress ///
		title("Odds Ratios – SOEP 2014 (Formal disability status)")
		
**# Graphs for exporting 
**************************

* WITH EDUCATION

	* Load data and restrict to 2014
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Apply survey design
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* PROF
	svy, subpop(if sample_25_59_soep_u_emp_cc== 1): logit prof i.wld_any_imploc age nkids ///
		i.sex i.mastat i.isced_re i.germborn
	margins wld_any_imploc, atmeans post
	eststo prof_soep

	* FULLTIME
	svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logit fulltime i.wld_any_imploc age nkids ///
		i.sex i.mastat i.isced_re i.germborn
	margins wld_any_imploc, atmeans post
	eststo fulltime_soep

	* PERMANENT
	svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logit permanent i.wld_any_imploc age nkids ///
		i.sex i.mastat i.isced_re i.germborn
	margins wld_any_imploc, atmeans post
	eststo permanent_soep

* Social class graph

	coefplot ///
		(prof_soep, keep(0.wld_any_imploc) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(prof_soep, keep(1.wld_any_imploc) ///
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
		title("SOEP 2014 - Professional or managerial class (full model)") ///
		legend(off) ///
		saving("$path7/2014_soep_empsitchapt_predprob_prof.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_prof.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_prof.png", width(2000) replace

* Full-time

	coefplot ///
		(fulltime_soep, keep(0.wld_any_imploc) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(fulltime_soep, keep(1.wld_any_imploc) ///
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
		title("SOEP 2014 - Full-time employment (full model)") ///
		legend(off) ///
		saving("$path7/2014_soep_empsitchapt_predprob_fulltime.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_fulltime.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_fulltime.png", width(2000) replace
	
* Permanent

	coefplot ///
		(permanent_soep, keep(0.wld_any_imploc) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(permanent_soep, keep(1.wld_any_imploc) ///
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
		title("SOEP 2014 - Permanent employment (full model)") ///
		legend(off) ///
		saving("$path7/2014_soep_empsitchapt_predprob_permanent.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_permanent.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_permanent.png", width(2000) replace

* WITHOUT EDUCATION

	* Load data and restrict to 2014
	use "$path2/soep_clean.dta", clear
	keep if syear == 2014

	* Apply survey design
	svyset psu [pweight=phrf], strata(strat) singleunit(scaled)

	* Clear previous estimates
	eststo clear

	* PROF (noed)
	svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logit prof i.wld_any_imploc age nkids ///
		i.sex i.mastat i.germborn
	margins wld_any_imploc, atmeans post
	eststo prof_soep_noed

	* FULLTIME (noed)
	svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logit fulltime i.wld_any_imploc age nkids ///
		i.sex i.mastat i.germborn
	margins wld_any_imploc, atmeans post
	eststo fulltime_soep_noed

	* PERMANENT (noed)
	svy, subpop(if sample_25_59_soep_u_emp_cc == 1): logit permanent i.wld_any_imploc age nkids ///
		i.sex i.mastat i.germborn
	margins wld_any_imploc, atmeans post
	eststo permanent_soep_noed
	
	* Prof graph (noed)
	coefplot ///
    (prof_soep_noed, keep(0.wld_any_imploc) ///
        label("No WLD") ///
        mcolor(red) msymbol(O) ///
        ciopts(recast(rcap) color(red%50)) ///
        mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
    (prof_soep_noed, keep(1.wld_any_imploc) ///
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
    title("SOEP 2014 - Professional or managerial class (no education)") ///
    legend(off) ///
    saving("$path7/2014_soep_empsitchapt_predprob_prof_noed.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_prof_noed.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_prof_noed.png", width(2000) replace

	* Fulltime graph (noed)
	coefplot ///
    (fulltime_soep_noed, keep(0.wld_any_imploc) ///
        label("No WLD") ///
        mcolor(red) msymbol(O) ///
        ciopts(recast(rcap) color(red%50)) ///
        mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
    (fulltime_soep_noed, keep(1.wld_any_imploc) ///
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
    title("SOEP 2014 - Full-time employment (no education)") ///
    legend(off) ///
    saving("$path7/2014_soep_empsitchapt_predprob_fulltime_noed.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_fulltime_noed.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_fulltime_noed.png", width(2000) replace

* Permanent graph (noed)

	coefplot ///
		(permanent_soep_noed, keep(0.wld_any_imploc) ///
			label("No WLD") ///
			mcolor(red) msymbol(O) ///
			ciopts(recast(rcap) color(red%50)) ///
			mlabel(@b) mlabposition(3) mlabcolor(black) mlabformat(%4.2f)) ///
		(permanent_soep_noed, keep(1.wld_any_imploc) ///
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
		title("SOEP 2014 - Permanent employment (no education)") ///
		legend(off) ///
		saving("$path7/2014_soep_empsitchapt_predprob_permanent_noed.gph", replace)

	graph use "$path7/2014_soep_empsitchapt_predprob_permanent_noed.gph"
	graph export "$path7/2014_soep_empsitchapt_predprob_permanent_noed.png", width(2000) replace




********************************************************************************
**# 				EMPLOYMENT EXIT CHAPTER
********************************************************************************

*-------------------------------------------------------------------------------
**# Data prep
*-------------------------------------------------------------------------------

/* Create lagged vars (t-1) incl. self-employment flag
*******************************************************
	
	use "$path2/soep_clean.dta", clear
	xtset pid syear, yearly

	* Self-employment at t-1 (keep 0/1 as valid; blank outside risk set)
	capture drop sempl_lag
	gen sempl_lag = L.sempl if consec==1
	replace sempl_lag = . if atrisk!=1
	label var sempl_lag "Self-employed (t-1 lag)"
	local vlab : value label sempl
	if "`vlab'" != "" label values sempl_lag `vlab'

	* Employees-only lagged employment characteristics (0=inapp -> .)
	local lagvars esec3 parttime fixedterm jbsize pubsec isic_broad services

	foreach v of local lagvars {
		capture drop `v'_lag
		gen `v'_lag = L.`v' if consec==1                      // t-1 for adjacent pairs
		replace `v'_lag = . if atrisk!=1                      // outside risk set -> missing
		replace `v'_lag = . if sempl_lag!=0                   // exclude self-employed (and ./.a) at t-1
		replace `v'_lag = . if `v'_lag==0 & sempl_lag==0      // 0=inapp at t-1 -> missing among employees

		// carry labels
		local vlabel : variable label `v'
		if "`vlabel'" != "" label var `v'_lag "`vlabel' (t-1 lag)"
		else                 label var `v'_lag "`v' (t-1 lag)"
		local vallab : value label `v'
		if "`vallab'" != "" label values `v'_lag `vallab'
	}

	* Quick integrity checks (optional)
	local lagvars esec3 parttime fixedterm jbsize pubsec isic_broad services
	foreach v of local lagvars {
		assert missing(`v'_lag) if atrisk!=1 | sempl_lag!=0
	}

	* Optional per-variable missing breakdown (diagnostics)
	local lagvars esec3 parttime fixedterm jbsize pubsec isic_broad services
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

	save "$path2/soep_clean.dta", replace	
	
	* Create a complete case flag on lagged vars
	**********************************************
	// excluding services as many more missing 
	
	use "$path2/soep_clean.dta", clear
	
	* Person-wave complete-case flag (employees-only risk set assumed)
	gen byte cc_lags = atrisk==1 & sempl_lag==0 ///
	  & !missing(esec3_lag, parttime_lag, fixedterm_lag, jbsize_lag, pubsec_lag, isic_broad_lag)

	* Among at-risk, count exits overall vs kept:
	quietly count if atrisk==1 & emploss==1
	di as res "Exits among all at-risk: " r(N)

	quietly count if atrisk==1 & emploss==1 & cc_lags==1
	di as res "Exits kept (complete lags): " r(N)

	quietly count if atrisk==1 & emploss==1 & cc_lags==0
	di as res "Exits dropped (incomplete lags): " r(N)
	
	* By syear
	tab syear cc_lags, mis
	quietly count if atrisk==1 & emploss==1 & cc_lags==0 & syear==2010
	di as res "Exits dropped in 2010 (incomplete lags): " r(N)

	save "$path2/soep_clean.dta", replace	
*/

* Create the risk set with correct data structure and employees only
*************************************************************************

	use "$path2/soep_clean.dta", clear

	* Panel settings: SOEP uses pid and survey year (syear)
	xtset pid syear, yearly
	sort pid syear

	* 1. Forward-looking "consecutive waves" indicator: t and t+1
	capture drop f_syear consec_f
	gen f_syear = F.syear
	gen consec_f = (f_syear == syear + 1)

	* 2. Baseline (t) and follow-up (t+1) variables for clarity
	capture drop emp_t emp_f sempl_t wld_t wld_f
	gen emp_t = employed
	gen emp_f = F.employed

	* self-employment status at baseline t
	* (assumes sempl == 0 employee, !=0 self-employed; adapt if named differently)
	gen sempl_t = sempl

	* WLD at baseline t and follow-up t+1
	gen wld_t = wld_any_imploc
	gen wld_f = F.wld_any_imploc

	* 3. Risk set at baseline t: 25–59, in sample, employed AND employee,
	*    with a valid consecutive follow-up and non-missing key vars
	capture drop risk_emp_t
	gen byte risk_emp_t = ///
		sample_25_59_soep_u == 1 & /// main 25–59 SOEP sample flag
		consec_f            == 1 & /// observe t+1 and it is exactly next year
		emp_t               == 1 & /// employed at baseline t
		sempl_t             == 0 & /// employee at baseline t (exclude self-employed)
		!missing(emp_f, wld_t, wld_f)

	label var risk_emp_t "Risk set: SOEP employees at t with follow-up at t+1"
	
	* 4. Within the employee risk set, treat 0 = inapplicable as missing
	*    for employment/job variables (mirroring old lagged setup)
	local inapp_vars esec3 parttime fixedterm jbsize pubsec isic_broad

	foreach v of local inapp_vars {
		replace `v' = . if risk_emp_t == 1 & `v' == 0
	}

	* 5. Enforce complete cases for baseline covariates at t
	*    (EDIT this list to match the final SOEP model if needed)
	local ccvars ///
		wld_any_imploc /// WLD at t
		syear          ///
		sampreg        /// region
		esec3          /// 3-class ESeC
		parttime       ///
		fixedterm      ///
		jbsize         ///
		pubsec_re      ///
		isic_broad      ///
		age            ///
		nkids          ///
		sex            ///
		mastat         ///
		degree

	foreach v of local ccvars {
		replace risk_emp_t = 0 if risk_emp_t == 1 & missing(`v')
	}

	label var risk_emp_t "Risk set: SOEP employees at t (complete cases, baseline covariates)"
	
	* 6. Define exit between t and t+1 using F.emploss
	capture drop exit_t1
	gen byte exit_t1 = .

	* Employment loss in the interval (t → t+1)
	replace exit_t1 = 1 if risk_emp_t == 1 & F.emploss == 1

	* Retained employment in the interval (t → t+1)
	replace exit_t1 = 0 if risk_emp_t == 1 & F.emploss == 0

	capture label drop exit_t1
	label define exit_t1 0 "Retained employment (t+1)" 1 "Employment loss (t+1)"
	label values exit_t1 exit_t1
	label var exit_t1 "Employment exit between t and t+1 (from F.emploss)"

	save "$path2/soep_clean.dta", replace
	
* Table of risk set size by year
**********************************
 // Updated with risk_emp_t (09/12/25)
 
	*-----------------------------------------------------------
	* SOEP: Effective model sample by year + TOTAL row (RTF)
	* Rows: 2010–2018 + Total
	* Cols: WLD n | WLD % | No WLD n | No WLD % | Total n | Total %
	* Sample: risk_emp_t == 1  (employee risk set, 25–59, complete cases)
	* WLD var: wld_any_imploc
	*-----------------------------------------------------------

	use "$path2/soep_clean.dta", clear

	* Baseline years t for which t+1 exists
	local years 2010 2011 2012 2013 2014 2015 2016 2017 2018

	matrix drop _all
	matrix results = J(`: word count `years'', 6, .)
	local r = 0

	* Accumulators for TOTAL row
	local tot_denom   = 0
	local tot_wld_n   = 0
	local tot_nowld_n = 0

	foreach y of local years {
		local ++r

		* Denominator = model-ready effective sample this year (employee risk set)
		quietly count if syear==`y' & risk_emp_t==1
		local denom = r(N)

		* WLD / no-WLD counts
		quietly count if syear==`y' & risk_emp_t==1 & wld_any_imploc==1
		local wld_n = r(N)

		quietly count if syear==`y' & risk_emp_t==1 & wld_any_imploc==0
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

		* Optional per-year sanity warning (tolerance 0.2)
		if `denom'>0 & (abs(`tot_pct_u' - 100) > 0.2) {
			di as error "Year `y': Total % = " %4.1f `tot_pct_u' " (check WLD coding/missings)"
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

	matrix rownames results = `years' Total
	matrix colnames results = "WLD n" "WLD %" "No WLD n" "No WLD %" "Total n" "Total %"

	* Optional: warn if TOTAL % deviates from ~100
	if `tot_denom'>0 & (abs(`tot_pct_u_all' - 100) > 0.2) {
		di as error "TOTAL row: Total % = " %4.1f `tot_pct_u_all' " (check WLD coding/missings)"
	}

	* Export
	esttab matrix(results) using "$path6/soep_retentionchapt_effectivesample_by_year.rtf", replace rtf ///
		title("Effective model sample by baseline year t (SOEP: employee risk set, risk_emp_t==1)") ///
		nomtitle nonumber noobs
		

*-------------------------------------------------------------------------------
**# Descriptives (I): sample descriptives
*-------------------------------------------------------------------------------

* Employees v self-employed in the general sample
*****************************************************

	*-------------------------------
	* Inclusion conditions (SOEP)
	*-------------------------------
	gen byte cond1 = (netto <= 19)          // individual interview
	gen byte cond2 = inrange(age, 25, 59)   // age 25–59

	capture drop sample_25_59_soep_gen
	gen byte sample_25_59_soep_gen = cond1 & cond2
	label var sample_25_59_soep_gen "General SOEP 25–59 sample (no CC restrictions)"

	*-------------------------------
	* Employees vs self-employed by WLD (general sample)
	*-------------------------------
	preserve

	keep if sample_25_59_soep_gen == 1 ///
		& employed == 1 ///
		& !missing(sempl, wld_any_imploc)

	* Employment status: employee vs self-employed/other
	capture drop empstatus2
	gen byte empstatus2 = .
	replace empstatus2 = 1 if sempl == 0
	replace empstatus2 = 2 if sempl != 0

	label define empstatus2 1 "Employee" 2 "Self-employed"
	label values empstatus2 empstatus2
	label var empstatus2 "Employment status"

	* Cross-tab for footnote: % employee / self-employed within each WLD group
	tab wld_any_imploc empstatus2, row

	restore

* Table of sample descriptives for employees
**********************************************

	* Load data
	use "$path2/soep_clean.dta", clear
	xtset pid syear, yearly

	*==============================================================*
	* SOEP – Descriptives for full covariate set (retention chapt) *
	*   Unweighted, risk set only (risk_emp_t == 1)                *
	*   Grouping: wld_any_imploc (0 = No WLD, 1 = WLD)             *
	*==============================================================*

	*--------------------------------------------------------------*
	* Block 1: Continuous covariates                               *
	*   - age                                                      *
	*   - nkids                                                    *
	*--------------------------------------------------------------*

	preserve

	* Restrict to risk set and non-missing WLD
	keep if risk_emp_t == 1
	drop if missing(wld_any_imploc)

	* Ensure WLD labels (just in case)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_imploc wldlab
	
	eststo clear

	* WLD = 1
	estpost tabstat age nkids if wld_any_imploc == 1, ///
		statistics(mean sd) columns(statistics)
	eststo cont_WLD

	* No WLD = 0
	estpost tabstat age nkids if wld_any_imploc == 0, ///
		statistics(mean sd) columns(statistics)
	eststo cont_noWLD

	* Total risk set
	estpost tabstat age nkids, ///
		statistics(mean sd) columns(statistics)
	eststo cont_total

	* Export to CSV (WLD, No WLD, Total)
	esttab cont_WLD cont_noWLD cont_total using ///
		"$path6/soep_retentionchapt_descr_block1_continuous.csv", ///
		replace label noobs nonumber ///
		mtitles("WLD" "No WLD" "Total") ///
		cells("mean(fmt(2)) sd(fmt(2) par(( ) ))") ///
		plain csv
	
	restore 

	*--------------------------------------------------------------*
	* SOEP – Block 2: Dummy covariates                             *
	*   - wld_any_imploc (0/1)                                     *
	*   - female (sex == 2)                                        *
	*   - degree (0 = No degree, 1 = Degree)                       *
	*   Unweighted, risk_emp_t == 1, grouped by wld_any_imploc     *
	*--------------------------------------------------------------*

	preserve
	keep if risk_emp_t == 1
	drop if missing(wld_any_imploc)

	* Ensure WLD labels (just in case)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_imploc wldlab
	eststo clear

	* Female dummy from sex (1 = male, 2 = female)
	capture drop female
	gen byte female = (sex == 2) if !missing(sex)
	label var female "Female (1 = yes)"

	* (Assuming degree is coded 0 = No degree, 1 = Degree)
	* If needed, adjust this to match your SOEP coding
	label var degree "Degree (1 = yes)"

	* Convert dummies to 0–100 so means = percentages
	foreach v in wld_any_imploc female degree {
		capture drop `v'_pct
		gen double `v'_pct = `v' * 100 if !missing(`v')
		label var `v'_pct "`: var label `v'' (percent with value = 1)"
	}

	* WLD = 1
	estpost tabstat wld_any_imploc_pct female_pct degree_pct ///
		if wld_any_imploc == 1, ///
		statistics(mean) columns(statistics)
	eststo dum_WLD

	* No WLD = 0
	estpost tabstat wld_any_imploc_pct female_pct degree_pct ///
		if wld_any_imploc == 0, ///
		statistics(mean) columns(statistics)
	eststo dum_noWLD

	* Total risk set
	estpost tabstat wld_any_imploc_pct female_pct degree_pct, ///
		statistics(mean) columns(statistics)
	eststo dum_total

	* Export to CSV (columns: WLD, No WLD, Total)
	esttab dum_WLD dum_noWLD dum_total using ///
		"$path6/soep_retentionchapt_descr_block2_dummies.csv", ///
		replace label noobs nonumber ///
		mtitles("WLD" "No WLD" "Total") ///
		cells("mean(fmt(1))") ///
		plain csv
	
	restore

	*--------------------------------------------------------------*
	* Block 3: Categorical covariates                              
	*   - mastat                                                   
	*   - germborn                                                
	*   - esec3
	*   - parttime
	*   - fixedterm                                            
	*   - jbsize                                             
	*   - pubsec_re
	*	- isic_broad
	*--------------------------------------------------------------*

	preserve
	keep if risk_emp_t == 1
	drop if missing(wld_any_imploc)

	* Ensure WLD labels (just in case)
	capture label define wldlab 0 "No WLD" 1 "WLD"
	capture label values wld_any_imploc wldlab
	eststo clear
	
	local catvars mastat germborn esec3 parttime fixedterm jbsize pubsec_re isic_broad
	tempname memhold
	tempfile cat3

	* varname, category code, label, and % for WLD / No WLD / Total
	postfile `memhold' str20 varname ///
			byte level ///
			str80 level_lab ///
			double pct_WLD pct_noWLD pct_total using `cat3', replace

	foreach v of local catvars {

		* All observed categories of this variable in the risk set
		levelsof `v' if !missing(`v'), local(levels)

		foreach L of local levels {

			* ----- WLD = 1 -----
			quietly count if wld_any_imploc == 1 & `v' == `L'
			local num1 = r(N)
			quietly count if wld_any_imploc == 1 & !missing(`v')
			local den1 = r(N)
			local pct1 = .
			if (`den1' > 0) local pct1 = 100 * `num1' / `den1'

			* ----- No WLD = 0 -----
			quietly count if wld_any_imploc == 0 & `v' == `L'
			local num0 = r(N)
			quietly count if wld_any_imploc == 0 & !missing(`v')
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

			* Value label (if defined)
			local lab : label (`v') `L'

			* Store row
			post `memhold' ("`v'") (`L') ("`lab'") ///
				(`pct1') (`pct0') (`pctT')
		}
	}

	postclose `memhold'

	use `cat3', clear

	label var varname   "Variable"
	label var level     "Category code"
	label var level_lab "Category"
	label var pct_WLD   "WLD (%)"
	label var pct_noWLD "No WLD (%)"
	label var pct_total "Total (%)"

	* Round to 1 decimal
	foreach p in pct_WLD pct_noWLD pct_total {
		replace `p' = round(`p', 0.1)
	}

	* Export – WLD, No WLD, Total
	export delimited varname level_lab pct_WLD pct_noWLD pct_total ///
		using "$path6/soep_retentionchapt_descr_block3_categorical.csv", ///
		replace

	restore
	
*-------------------------------------------------------------------------------
**# Descriptives (II): frequency of exit by WLD
*-------------------------------------------------------------------------------

* Load data
	use "$path2/soep_clean.dta", clear

* Inspect exits
*****************

	* Pooled balanced
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal==1, mis // 382 total
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal_wld==1, mis // 68
	tab exit_t1 if risk_emp_t==1 & sample_25_59_bal_nowld==1, mis // 314

* Tests of signifance and strength of association

	* Pooled unbalanced
	// with simple exit variable
	tab wld_any_imploc exit_t1 if risk_emp_t==1, chi2 V

	// with detailed destination variable
	tab wld_any_imploc dest_t1 if risk_emp_t==1, mis chi2 V
	
* Frequency tables
********************

/* POOLED BALANCED

	use "$path2/soep_clean.dta", clear

	* Survey design (pooled longitudinal weight)
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Helper dummies (emploss nonmissing = at-risk)
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

	* Total
	count if sample_25_59_bal==1 & emploss==1
	scalar exit_tot_n = r(N)
	count if sample_25_59_bal==1 & emploss==0
	scalar ret_tot_n  = r(N)
	count if sample_25_59_bal==1 & !missing(emploss)
	scalar tot_tot_n  = r(N)

	* 2) WEIGHTED COLUMN %

	* WLD
	svy, subpop(if sample_25_59_bal_wld==1): mean retain exit
	matrix bw = e(b)
	scalar ret_wld_pct  = el(bw,1,1)*100
	scalar exit_wld_pct = el(bw,1,2)*100
	scalar tot_wld_pct  = 100.0

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

	* 3) BUILD 3×6 MATRIX & EXPORT

	matrix drop _all
	matrix exit_tab_soep_bal = ///
	( exit_wld_n,  exit_wld_pct,  exit_nowld_n,  exit_nowld_pct,  exit_tot_n,  exit_tot_pct \ ///
	  ret_wld_n,   ret_wld_pct,   ret_nowld_n,   ret_nowld_pct,   ret_tot_n,   ret_tot_pct  \ ///
	  tot_wld_n,   tot_wld_pct,   tot_nowld_n,   tot_nowld_pct,   tot_tot_n,   tot_tot_pct )

	matrix rownames exit_tab_soep_bal = "Exit" "Retention" "Total"
	matrix colnames exit_tab_soep_bal = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	esttab matrix(exit_tab_soep_bal, fmt(0 1 0 1 0 1)) using ///
		"$path6/soep_retentionchapt_exit_bywld_balanced.rtf", replace rtf ///
		title("Employment exit vs retention (pooled) — SOEP balanced 25–59") ///
		nonumber noobs nomtitle
*/

/* POOLED UNBALANCED (UPDATED: exit_t1 + risk_emp_t + wld_any_imploc) - NO LONGER REPORTED
********************************************************************

	use "$path2/soep_clean.dta", clear

	* 1) UNWEIGHTED COUNTS  (Risk set only: risk_emp_t == 1)

	* WLD
	count if risk_emp_t==1 & wld_any_imploc==1 & exit_t1==1
	scalar exit_wld_n = r(N)
	count if risk_emp_t==1 & wld_any_imploc==1 & exit_t1==0
	scalar ret_wld_n  = r(N)
	count if risk_emp_t==1 & wld_any_imploc==1 & !missing(exit_t1)
	scalar tot_wld_n  = r(N)

	* No WLD
	count if risk_emp_t==1 & wld_any_imploc==0 & exit_t1==1
	scalar exit_nowld_n = r(N)
	count if risk_emp_t==1 & wld_any_imploc==0 & exit_t1==0
	scalar ret_nowld_n  = r(N)
	count if risk_emp_t==1 & wld_any_imploc==0 & !missing(exit_t1)
	scalar tot_nowld_n  = r(N)

	* Total
	count if risk_emp_t==1 & !missing(wld_any_imploc) & exit_t1==1
	scalar exit_tot_n = r(N)
	count if risk_emp_t==1 & !missing(wld_any_imploc) & exit_t1==0
	scalar ret_tot_n  = r(N)
	count if risk_emp_t==1 & !missing(wld_any_imploc) & !missing(exit_t1)
	scalar tot_tot_n  = r(N)

	* 2) COLUMN PERCENTAGES (UNWEIGHTED)

	scalar exit_wld_pct   = (exit_wld_n   / tot_wld_n)*100
	scalar ret_wld_pct    = (ret_wld_n    / tot_wld_n)*100
	scalar tot_wld_pct    = 100.0

	scalar exit_nowld_pct = (exit_nowld_n / tot_nowld_n)*100
	scalar ret_nowld_pct  = (ret_nowld_n  / tot_nowld_n)*100
	scalar tot_nowld_pct  = 100.0

	scalar exit_tot_pct   = (exit_tot_n   / tot_tot_n)*100
	scalar ret_tot_pct    = (ret_tot_n    / tot_tot_n)*100
	scalar tot_tot_pct    = 100.0

	* 3) BUILD 3×6 MATRIX & EXPORT — keep original filename (overwrites)

	matrix drop _all
	matrix exit_tab_soep_unbal = ///
	( exit_wld_n,  exit_wld_pct,  exit_nowld_n,  exit_nowld_pct,  exit_tot_n,  exit_tot_pct \ ///
	  ret_wld_n,   ret_wld_pct,   ret_nowld_n,   ret_nowld_pct,   ret_tot_n,   ret_tot_pct  \ ///
	  tot_wld_n,   tot_wld_pct,   tot_nowld_n,   tot_nowld_pct,   tot_tot_n,   tot_tot_pct )

	matrix rownames exit_tab_soep_unbal = "Exit" "Retention" "Total"
	matrix colnames exit_tab_soep_unbal = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	esttab matrix(exit_tab_soep_unbal, fmt(0 1 0 1 0 1)) using ///
		"$path6/soep_retentionchapt_exit_bywld_unbalanced.rtf", replace rtf ///
		title("Employment exit vs retention (pooled) — SOEP unbalanced 25–59") ///
		nonumber noobs nomtitle
*/

*------------------------------------------------------------
* SOEP: Transparency table — destinations at t+1 among baseline employees
* Rows: 1 Retained: employee
*       2 Retained: moved to self-employed
*       3 Exit: moved to non-employed
*       4 Missing follow-up self-employment type (among retained)
*       Total
* Cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
* Denominator (columns): full FINAL risk set with defined exit_t1
*------------------------------------------------------------

	use "$path2/soep_clean.dta", clear
	xtset pid syear, yearly
	sort pid syear

	*------------------------------------------------------------
	* 1) Follow-up self-employment (only needed to split retention)
	*------------------------------------------------------------
	* Follow-up self-employment (raw)
	capture drop sempl_f
	gen sempl_f = F.sempl if risk_emp_t==1 & exit_t1 < .
	label var sempl_f "Self-employed at t+1 (F.sempl; raw)"

	* Binary recode for classification: treat .a (inapplicable/no job) as 0
	capture drop sempl_f01
	gen byte sempl_f01 = .
	replace sempl_f01 = 0 if sempl_f==0 | sempl_f==.a
	replace sempl_f01 = 1 if sempl_f==1
	label var sempl_f01 "Self-employed at t+1 (binary; .a->0)"

	* Optional transparency checks (same style as before)
	capture drop sempl_f_inapp
	gen byte sempl_f_inapp = (sempl_f==.a) if risk_emp_t==1 & exit_t1 < .
	label var sempl_f_inapp "sempl_f is .a (no job at t+1)"

	tab sempl_f   if risk_emp_t==1 & exit_t1==0, missing
	tab sempl_f01 if risk_emp_t==1 & exit_t1==0, missing
	tab sempl_f_inapp if risk_emp_t==1 & exit_t1==0, missing

	* If you still want to inspect the "true missing" sempl_f cases:
	capture drop emp_f
	gen byte emp_f = F.employed if risk_emp_t==1 & exit_t1 < .
	label var emp_f "Employed at t+1 (F.employed) among risk set with exit_t1 observed"

	tab employed emp_f if risk_emp_t==1 & exit_t1==0 & missing(sempl_f), missing
	// 270 with missing sempl_f are all employed
	tab pgemplst pglfs if risk_emp_t==1 & exit_t1==0 & missing(sempl_f), missing
	// mostly full-time with a few part-time, irregular part-time and apprenticeships. 
	// fine to keep those as employed
	
	* Re-route those 270 cases from missing to sempl_f01==0
	// After generating sempl_f01 (and after generating emp_f = F.employed)
	replace sempl_f01 = 0 if risk_emp_t==1 & exit_t1==0 & emp_f==1 & missing(sempl_f01)

	*------------------------------------------------------------
	* 2) Destination buckets at t+1
	*------------------------------------------------------------
	capture drop dest_t1
	gen byte dest_t1 = .

	* Retained employment: split employee vs self-employed using sempl_f01
	replace dest_t1 = 1 if risk_emp_t==1 & exit_t1==0 & sempl_f01==0
	replace dest_t1 = 2 if risk_emp_t==1 & exit_t1==0 & sempl_f01==1

	* Exit to non-employment (no need for sempl_f01)
	replace dest_t1 = 3 if risk_emp_t==1 & exit_t1==1

	* Missing follow-up "type" among retained (kept for symmetry with UKHLS)
	* (this should be ~0 after your reroute, but we keep the row)
	replace dest_t1 = 4 if risk_emp_t==1 & exit_t1==0 & missing(sempl_f01)

	label define destlbl ///
		1 "Retained: employee" ///
		2 "Retained: moved to self-employed" ///
		3 "Exit: moved to non-employed" ///
		4 "Missing follow-up status", replace
	label values dest_t1 destlbl
	label var dest_t1 "Destination at t+1 among baseline employees"

	* Restrict analysis base to risk set
	keep if risk_emp_t==1 & exit_t1 < . & !missing(wld_any_imploc)
	
	* Make sure there are no missing destinations
	tab dest_t1, missing
	count if missing(dest_t1)

	*------------------------------------------------------------
	* 3) Build table matrix (4 rows + Total) × (6 columns)
	*------------------------------------------------------------
	tempname T
	matrix define `T' = J(5, 6, .)

	forvalues cat = 1/4 {
		quietly count if wld_any_imploc==1 & dest_t1==`cat'
		matrix `T'[`cat',1] = r(N)

		quietly count if wld_any_imploc==0 & dest_t1==`cat'
		matrix `T'[`cat',3] = r(N)

		matrix `T'[`cat',5] = `T'[`cat',1] + `T'[`cat',3]
	}

	quietly count if wld_any_imploc==1
	scalar tot_wld_n = r(N)

	quietly count if wld_any_imploc==0
	scalar tot_nowld_n = r(N)

	scalar tot_all_n = tot_wld_n + tot_nowld_n

	forvalues rr = 1/4 {
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100*(`T'[`rr',1]/tot_wld_n),   .)
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100*(`T'[`rr',3]/tot_nowld_n), .)
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100*(`T'[`rr',5]/tot_all_n),   .)
	}

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
	* 4) Export (RTF)
	*------------------------------------------------------------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/soep_retentionchapt_destinations_t1_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations at t+1 among baseline employees (risk set) — SOEP unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle

	*------------------------------------------------------------
	* 5) Export (CSV)
	*------------------------------------------------------------
	preserve
	clear
	svmat double `T', names(col)

	gen row = _n
	gen str25 destination = ""
	replace destination = "retained_employee"  if row==1
	replace destination = "retained_selfemp"   if row==2
	replace destination = "exit_nonemp"        if row==3
	replace destination = "missing_followup"   if row==4
	replace destination = "Total"              if row==5

	drop row
	order destination WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	format WLD_n NoWLD_n Total_n %12.0f
	format WLD_pct NoWLD_pct Total_pct %6.1f

	export delimited using ///
		"$path6/soep_retentionchapt_destinations_t1_bywld_unbalanced.csv", replace

	restore

	
* WLD and exit dynamics in the sample
****************************************
	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Follow-up WLD at t+1 (lead)
	capture drop wld_any_imploc_f
	gen byte wld_any_imploc_f = F.wld_any_imploc
	label var wld_any_imploc_f "WLD at follow-up (t+1, imploc)"

	*------------------------------------
	* 1. WLD trajectory (t -> t+1) — RISK SET ONLY
	*------------------------------------
	capture drop wld_traj
	gen byte wld_traj = .
	replace wld_traj = 1 if risk_emp_t==1 & wld_any_imploc==0 & wld_any_imploc_f==0
	replace wld_traj = 2 if risk_emp_t==1 & wld_any_imploc==0 & wld_any_imploc_f==1
	replace wld_traj = 3 if risk_emp_t==1 & wld_any_imploc==1 & wld_any_imploc_f==0
	replace wld_traj = 4 if risk_emp_t==1 & wld_any_imploc==1 & wld_any_imploc_f==1

	capture label drop wld_traj
	label define wld_traj ///
		1 "No WLD -> No WLD" ///
		2 "No WLD -> WLD"    ///
		3 "WLD -> No WLD"    ///
		4 "WLD -> WLD"
	label values wld_traj wld_traj
	label var wld_traj "WLD trajectory (t -> t+1)"

	* Optional: view table in Results window (risk set only)
	tab wld_traj exit_t1 if risk_emp_t==1 & !missing(wld_traj, exit_t1), nofreq row

	*------------------------------------
	* 2. Row percentages and N by WLD trajectory x exit — RISK SET ONLY
	*------------------------------------
	preserve
	keep if risk_emp_t==1 & !missing(wld_traj, exit_t1)

	contract wld_traj exit_t1, freq(N)

	bysort wld_traj: egen rowN = total(N)
	gen rowpct = 100 * N / rowN

	rename exit_t1 exit
	reshape wide rowpct N, i(wld_traj) j(exit)

	* Be robust if one of the exit categories is absent
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
	replace wld_traj   = 0                        in `=`oldN' + 1'
	replace pct_retain = 100*S_N0/(S_N0+S_N1)     in `=`oldN' + 1'
	replace pct_exit   = 100*S_N1/(S_N0+S_N1)     in `=`oldN' + 1'
	replace N          = (S_N0 + S_N1)            in `=`oldN' + 1'

	label define wld_traj 0 "Total", add
	label values wld_traj wld_traj

	order wld_traj pct_retain pct_exit N
	format pct_retain pct_exit %5.1f
	format N %9.0f

	export delimited using "$path6/soep_retentionchapt_descr_wld_exit.csv", replace
	restore

	
*-------------------------------------------------------------------------------
**# Descriptives (III): frequency of exit by employment chars and WLD
*-------------------------------------------------------------------------------

**# Socio-economic class (Esec3)
**********************************

	/* SOEP balanced panel (weighted) - Not updated for new risk set
	*================================

	use "$path2/soep_clean.dta", clear

	* Survey design (pooled longitudinal weight)
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Baseline ESeC3 (lagged, only for consecutive wave-pairs)
	capture drop class0
	gen class0 = L.esec3 if syear == L.syear + 1

	* Exit outcome (emploss already 0/1 among at-risk)
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	quietly svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(class0,1,3), over(class0)
	matrix prop_wld = r(table)

	quietly svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(class0,1,3), over(class0)
	matrix prop_nowld = r(table)

	* prop_* have two blocks: first exit==0 (retention), then exit==1 (exit)
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

	* Labels at CI top + 0.1 offset
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0
	
	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define esec3_lbl 1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class esec3_lbl

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
	  title("SOEP balanced panel: Employment exit by WLD and ESeC-3") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	  ylabel(0(2)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_esec3_bal.png", replace
*/
	
	* SOEP unbalanced panel: Exit by WLD × ESeC-3 (unweighted) — UPDATED for risk set + exit_t1
	*=========================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Baseline ESeC-3 at t (risk set only)                                   // *** CHANGED ***
	capture drop class0
	gen class0 = esec3 if risk_emp_t==1                                      // *** CHANGED ***

	*-----------------------------
	* Unweighted exit proportions by WLD (risk set only; use exit_t1 directly) // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(class0,1,3), over(class0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(class0,1,3), over(class0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	* prop_* have two blocks: first exit==0 (retention), then exit==1 (exit)
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

	* Labels at CI top + 0.2 offset
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define esec3_lbl 1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine"
	label values class esec3_lbl

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
	, xtitle("ESEC-3") ytitle("Exit rate (%)") ///
	  title("SOEP: Employment exit by WLD and socio-economic classification") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Management & professional" 2 "2. Intermediate" 3 "3. Routine", angle(0)) ///
	  ylabel(0(5)15, format(%4.0f)) yscale(range(0 15)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_esec3_unbal.png", replace


**# Part-time
****************

	/* SOEP balanced panel (weighted): Exit by WLD × working time - NOT UPDATED
	*===============================================================

	use "$path2/soep_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Baseline part-time status (lagged, consecutive years)
	capture drop pt0
	gen pt0 = L.parttime if syear == L.syear + 1

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
	  title("SOEP balanced panel: Employment exit by WLD and working time", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)", ///
	  angle(0) labsize(small)) ///
	  ylabel(0(5)50, format(%4.0f)) yscale(range(0 50)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_parttime_bal.png", replace
	*/
	
	* SOEP unbalanced panel (unweighted): Exit(t+1) by WLD(t) × working time(t) — RISK SET
	*====================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                         // *** CHANGED ***

	* Baseline part-time status at t (risk set only)                         // *** CHANGED ***
	capture drop pt0
	gen pt0 = parttime if risk_emp_t==1                                      // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(pt0,1,3), over(pt0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(pt0,1,3), over(pt0)   // *** CHANGED ***
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

	label define pt_lbl ///
		1 "1. Full-time (>=35h)" ///
		2 "2. Regular part-time (11–34h)" ///
		3 "3. Marginal part-time (<=10h)"
	label values class pt_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,    lcolor(blue)) ///
	 (bar  prop x,              barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,    mlabel(wld_label) msymbol(none) mlabcolor(blue) ///
								mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,   lcolor(red)) ///
	 (bar  prop x2,             barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP: Employment exit by WLD and working time") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Full-time (>=35h)" 2 "2. Regular part-time (11–34h)" 3 "3. Marginal part-time (<=10h)", ///
			 angle(0) labsize(small)) ///
	  ylabel(0(5)25, format(%4.0f)) yscale(range(0 25)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_parttime_unbal.png", replace


**# Fixed-term 
****************

	/* SOEP balanced panel (weighted): Exit by WLD × fixed-term - NOT UPDATED YET
	*===============================================================

	use "$path2/soep_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Baseline fixed-term status (lagged, consecutive years)
	capture drop ft0
	gen ft0 = L.fixedterm if syear == L.syear + 1

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

	label define ft_lbl 1 "1. Permanent" 2 "2. Non-permanent"
	label values class ft_lbl

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
	  title("SOEP balanced panel: Employment exit by WLD and fixed-term employment", size(smallmed)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Permanent" 2 "2. Non-permanent", angle(0)) ///
	  ylabel(0(5)55, format(%4.0f)) yscale(range(0 55)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_fixedterm_bal.png", replace
	*/
	
	* SOEP unbalanced panel (unweighted): Exit(t+1) by WLD(t) × fixed-term(t) — RISK SET
	*==================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                         // *** CHANGED ***

	* Baseline fixed-term status at t (risk set only)                        // *** CHANGED ***
	capture drop ft0
	gen ft0 = fixedterm if risk_emp_t==1                                    // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(ft0,1,2), over(ft0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(ft0,1,2), over(ft0)   // *** CHANGED ***
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
	  title("SOEP: Employment exit by WLD and fixed-term employment") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Permanent" 2 "2. Non-permanent", angle(0)) ///
	  ylabel(0(5)25, format(%4.0f)) yscale(range(0 25)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_fixedterm_unbal.png", replace


**# Company size
*****************

	/* SOEP balanced panel (weighted): Exit by WLD × company size
	*===============================================================

	use "$path2/soep_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Baseline company size (lagged, consecutive years)
	capture drop size0
	gen size0 = L.jbsize if syear == L.syear + 1

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
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red)  ///
							   mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP balanced panel: Employment exit by WLD and company size", size(medsmall)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200", angle(0)) ///
	  ylabel(0(2)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_jbsize_bal.png", replace
*/
		
	* SOEP unbalanced panel (unweighted): Exit(t+1) by WLD(t) × company size(t) — RISK SET
	*====================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                         // *** CHANGED ***

	* Baseline company size at t (risk set only)                             // *** CHANGED ***
	capture drop size0
	gen size0 = jbsize if risk_emp_t==1                                      // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(size0,1,3), over(size0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(size0,1,3), over(size0)   // *** CHANGED ***
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
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) ///
								 mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP: Employment exit by WLD and company size") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. <10 incl self-emp" 2 "2. 11–200" 3 "3. >200", angle(0)) ///
	  ylabel(0(5)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_jbsize_unbal.png", replace

**# Public sector
******************

	/* SOEP balanced public sector 
	*==============================

	use "$path2/soep_clean.dta", clear

	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	capture drop sector0
	gen sector0 = L.pubsec if syear == L.syear + 1

	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(sector0,1,2), over(sector0)
	matrix prop_wld = r(table)

	svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(sector0,1,2), over(sector0)
	matrix prop_nowld = r(table)
	
	/* Quick check it matches subsequent chart values
	matrix list prop_wld
	display prop_wld[1,3]*100   // exit=1, sector=1 (%)
	display prop_wld[1,4]*100   // exit=1, sector=2 (%)
	
	display prop_nowld[1,3]*100   // exit=1, sector=1 (%)
	display prop_nowld[1,4]*100   // exit=1, sector=2 (%)
	*/
	
	local K = 2   // sector0 has 2 categories

	clear
	set obs `=2*`K''
	gen class = cond(_n<=`K', _n, _n-`K')
	gen wld   = cond(_n<=`K', 1, 0)
	gen prop = .
	gen se   = .

	forvalues i = 1/`K' {
		local col_exit = `i' + `K'   // columns 3,4 are exit=1

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

	gen xpos = .
	replace xpos = class - 0.15 if wld==1
	replace xpos = class + 0.15 if wld==0
	gen x  = xpos if wld==1
	gen x2 = xpos if wld==0

	gen wld_label   = string(prop, "%4.1f") if wld==1
	gen nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2  if wld==1
	gen nowld_label_y = ci_high + 0.2  if wld==0

	label define pubsec_lbl 1 "1. Not public sector" 2 "2. Public sector"
	label values class pubsec_lbl

	twoway ///
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue)  mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP balanced panel: Employment exit by WLD and public/private sector", size(smallmed)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Not public sector" 2 "2. Public sector", angle(0)) ///
	  ylabel(0(2)20, format(%4.0f)) yscale(range(0 20)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

graph export "$path7/soep_retentionchapt_exit_pubsec_bal.png", replace
*/

	* SOEP unbalanced panel (unweighted): Exit(t+1) by WLD(t) × public/private sector(t) — RISK SET
	*==============================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                         // *** CHANGED ***

	* Baseline sector at t (risk set only)                                   // *** CHANGED ***
	capture drop sector0
	gen sector0 = pubsec if risk_emp_t==1                                   // *** CHANGED ***

	* (Removed separate exit variable; use exit_t1 directly)                 // *** CHANGED ***

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)             // *** CHANGED ***
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(sector0,1,2), over(sector0)   // *** CHANGED ***
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(sector0,1,2), over(sector0)   // *** CHANGED ***
	matrix prop_nowld = r(table)

	local K = 2   // 2 categories of pubsec (unchanged)

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
		local col_exit = `i' + `K'   // exit=1 columns are 3,4

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

	* Labels (1 decimal place)
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define pubsec_lbl 1 "1. Not public sector" 2 "2. Public sector"
	label values class pubsec_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP: Employment exit by WLD and public/private sector") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Not public sector" 2 "2. Public sector", angle(0)) ///
	  ylabel(0(5)15, format(%4.0f)) yscale(range(0 15)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_pubsec_unbal.png", replace


**# Industrial sector
**********************

	/* SOEP balanced panel (weighted): Exit by WLD × industrial sector
	*===============================================================

	use "$path2/soep_clean.dta", clear

	* Survey design
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)

	* Baseline industrial sector (lagged, consecutive years)
	capture drop ind0
	gen ind0 = L.isic_broad if syear == L.syear + 1

	* Exit outcome
	capture drop exit
	gen byte exit = (emploss == 1) if !missing(emploss)

	*-----------------------------
	* Weighted proportions by WLD
	*-----------------------------
	svy, subpop(if sample_25_59_bal_wld==1): ///
		proportion exit if inrange(ind0,1,3), over(ind0)
	matrix prop_wld = r(table)

	svy, subpop(if sample_25_59_bal_nowld==1): ///
		proportion exit if inrange(ind0,1,3), over(ind0)
	matrix prop_nowld = r(table)

	local K = 3   // 3 categories of isic_broad

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
		local col_exit = `i' + `K'   // exit=1 columns are K+1...2K

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

	* Labels (1 decimal place)
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
	 (rcap ci_low ci_high x,   lcolor(blue)) ///
	 (bar  prop x,             barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,   mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,  lcolor(red)) ///
	 (bar  prop x2,            barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2, mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP balanced panel: Employment exit by WLD and industrial sector", size(smallmed)) ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Agriculture, forestry, mining" 2 "2. Industry" 3 "3. Services", angle(0)) ///
	  ylabel(0(5)40, format(%4.0f)) yscale(range(0 40)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_isic_broad_bal.png", replace
*/
	* SOEP unbalanced panel (unweighted): Exit(t+1) by WLD(t) × industrial sector(t) — RISK SET
	*========================================================================================

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                        

	* Baseline industrial sector at t (risk set only)                         
	capture drop ind0
	gen ind0 = isic_broad if risk_emp_t==1    
	
	* Check number of exits per category
	tab ind0 exit_t1 if risk_emp_t==1 & wld_any_imploc==1, mis
	tab ind0 exit_t1 if risk_emp_t==1 & wld_any_imploc==0, mis

	*-----------------------------
	* Unweighted proportions by WLD (risk set only; use exit_t1)              
	*-----------------------------
	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==1 & inrange(ind0,1,3), over(ind0)   
	matrix prop_wld = r(table)

	proportion exit_t1 if risk_emp_t==1 & wld_any_imploc==0 & inrange(ind0,1,3), over(ind0)   
	matrix prop_nowld = r(table)

	local K = 3   

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
		local col_exit = `i' + `K'   // exit=1 columns (K+1...2K)

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

	* Labels (1 decimal place)
	gen str5 wld_label   = string(prop, "%4.1f") if wld==1
	gen str5 nowld_label = string(prop, "%4.1f") if wld==0

	gen wld_label_y   = ci_high + 0.2 if wld==1
	gen nowld_label_y = ci_high + 0.2 if wld==0

	label define ind_lbl ///
		1 "1. Agriculture, forestry, mining" ///
		2 "2. Industry" ///
		3 "3. Services"
	label values class ind_lbl

	*-----------------------------
	* Graph
	*-----------------------------
	twoway ///
	 (rcap ci_low ci_high x,     lcolor(blue)) ///
	 (bar  prop x,               barwidth(0.25) color(blue%70)) ///
	 (scatter wld_label_y x,     mlabel(wld_label) msymbol(none) mlabcolor(blue) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	 (rcap ci_low ci_high x2,    lcolor(red)) ///
	 (bar  prop x2,              barwidth(0.25) color(red%70)) ///
	 (scatter nowld_label_y x2,  mlabel(nowld_label) msymbol(none) mlabcolor(red) mlabsize(small) mlabposition(12) mlabgap(0)) ///
	, xtitle("") ytitle("Exit rate (%)") ///
	  title("SOEP: Employment exit by WLD and industrial sector") ///
	  legend(order(2 "WLD" 5 "No WLD") position(6)) ///
	  xlabel(1 "1. Agriculture, forestry, mining" 2 "2. Industry" 3 "3. Services", angle(0)) ///
	  ylabel(0(5)30, format(%4.0f)) yscale(range(0 30)) ///
	  yline(0, lcolor(gs8)) graphregion(color(white))

	graph export "$path7/soep_retentionchapt_exit_isic_broad_unbal.png", replace


*-------------------------------------------------------------------------------
**# Descriptives (IV): Destinations from employment (after exit), by WLD
*-------------------------------------------------------------------------------

	* Check: Are there any exits ending in sheltered workshop in the sample?
	count if emploss==1 & nonemp==5 & sample_25_59_soep_u==1
	display "Sheltered exits total in unbalanced panel: " r(N)

	* By WLD status
	tab wld_any_imploc if emploss==1 & nonemp==5 & sample_25_59_soep_u==1, m
		
	/*---------------------------------------------------------------*
	*  DESTINATIONS AFTER EMPLOYMENT EXIT v1 — SOEP unbalanced (unweighted)
	*  rows: SOEP-available destinations (t+1) + Total
	*  cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	*  Denominator everywhere = baseline exit cases (t) in risk set:
	*    risk_emp_t==1 & exit_t1==1, with observed destination at t+1
	*  NOTE: With these conditions, SOEP destinations observed are 1, 2, 5, 6 (no 3; no 4; exclude 0)
	*---------------------------------------------------------------*

	use "$path2/soep_clean.dta", clear
	xtset pid syear                                                          

	* Destination at follow-up (t+1), attached to baseline (t) exit row        
	capture drop nonemp_f
	gen byte nonemp_f = F.nonemp if risk_emp_t==1 & exit_t1==1               
	label var nonemp_f "Destination after exit (t+1)"

	* --- CHECK observed destination categories under the analysis conditions  
	tab nonemp_f if risk_emp_t==1 & exit_t1==1, missing                      

	* Keep only baseline exit transitions with observed SOEP destination codes 
	keep if risk_emp_t==1 & exit_t1==1                                       
	keep if inlist(nonemp_f, 1, 2, 5, 6)                                     // (dropped 3)

	tempname T
	matrix define `T' = J(5, 6, .)                                           // (4 cats + Total)

	* ---------- 1) Unweighted counts among EXIT cases (baseline), by destination at t+1 ----------
	local r = 0
	foreach cat in 1 2 5 6 {                                                 
		local ++r

		quietly count if wld_any_imploc==1 & nonemp_f==`cat'
		matrix `T'[`r',1] = r(N)      // WLD_n

		quietly count if wld_any_imploc==0 & nonemp_f==`cat'
		matrix `T'[`r',3] = r(N)      // NoWLD_n

		* Row total (WLD + NoWLD)
		matrix `T'[`r',5] = `T'[`r',1] + `T'[`r',3]
	}

	* ---------- 2) Column denominators = all EXIT cases in group ----------
	quietly count if wld_any_imploc==1 & inlist(nonemp_f,1,2,5,6)
	scalar tot_wld_n   = r(N)

	quietly count if wld_any_imploc==0 & inlist(nonemp_f,1,2,5,6)
	scalar tot_nowld_n = r(N)

	scalar tot_all_n   = tot_wld_n + tot_nowld_n

	* ---------- 3) Column percentages (unweighted, within EXIT cases) ----------
	forvalues rr = 1/4 {                                                      
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100 * (`T'[`rr',1] / tot_wld_n), .)
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100 * (`T'[`rr',3] / tot_nowld_n), .)
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100 * (`T'[`rr',5] / tot_all_n), .)
	}

	* ---------- 4) Totals row (EXIT cases) ----------
	matrix `T'[5,1] = tot_wld_n
	matrix `T'[5,2] = cond(tot_wld_n>=0,   100, .)
	matrix `T'[5,3] = tot_nowld_n
	matrix `T'[5,4] = cond(tot_nowld_n>=0, 100, .)
	matrix `T'[5,5] = tot_all_n
	matrix `T'[5,6] = cond(tot_all_n>=0,   100, .)

	* ---------- 5) Row/column names (SOEP-only; category 3 removed) ----------
	matrix rownames `T' = ///
		unemployed ///
		education_training ///
		sheltered_workshop ///
		other_non_employed ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* ---------- 6) Export (overwrite; keep original filename) ----------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/soep_retentionchapt_nonemp_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations after employment exit — SOEP unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle
	*/
	
	*---------------------------------------------------------------*
	*  DESTINATIONS AFTER EMPLOYMENT EXIT v2 — SOEP unbalanced (unweighted)
	*  rows: SOEP-available destinations (t+1) + Total
	*  cols: WLD(n) WLD(%) NoWLD(n) NoWLD(%) Total(n) Total(%)
	*  Denominator everywhere = baseline exit cases (t) in risk set:
	*    risk_emp_t==1 & exit_t1==1, with observed destination at t+1
	*  NOTE: Under these conditions, destinations observed are (typically) 1, 2, 5, 6.
	*        Maternity/parental leave is now coded as 4 in SOEP nonemp, so include it if observed.
	*---------------------------------------------------------------*

	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Destination at follow-up (t+1), attached to baseline (t) exit row
	capture drop nonemp_f
	gen byte nonemp_f = F.nonemp if risk_emp_t==1 & exit_t1==1
	label var nonemp_f "Destination after exit (t+1)"

	* --- CHECK observed destination categories under the analysis conditions
	tab nonemp_f if risk_emp_t==1 & exit_t1==1, missing

	* Keep only baseline exit transitions
	keep if risk_emp_t==1 & exit_t1==1

	* Keep only observed SOEP destination codes (UPDATED: include 4 = maternity/parental leave if present)
	keep if inlist(nonemp_f, 1, 2, 4, 5, 6)

	tempname T
	matrix define `T' = J(6, 6, .)     // UPDATED: 5 cats + Total (adds category 4)

	* ---------- 1) Unweighted counts among EXIT cases (baseline), by destination at t+1 ----------
	local r = 0
	foreach cat in 1 2 4 5 6 {         // UPDATED: add 4
		local ++r

		quietly count if wld_any_imploc==1 & nonemp_f==`cat'
		matrix `T'[`r',1] = r(N)      // WLD_n

		quietly count if wld_any_imploc==0 & nonemp_f==`cat'
		matrix `T'[`r',3] = r(N)      // NoWLD_n

		* Row total (WLD + NoWLD)
		matrix `T'[`r',5] = `T'[`r',1] + `T'[`r',3]
	}

	* ---------- 2) Column denominators = all EXIT cases in group ----------
	quietly count if wld_any_imploc==1 & inlist(nonemp_f,1,2,4,5,6)   // UPDATED: add 4
	scalar tot_wld_n   = r(N)

	quietly count if wld_any_imploc==0 & inlist(nonemp_f,1,2,4,5,6)   // UPDATED: add 4
	scalar tot_nowld_n = r(N)

	scalar tot_all_n   = tot_wld_n + tot_nowld_n

	* ---------- 3) Column percentages (unweighted, within EXIT cases) ----------
	forvalues rr = 1/5 {                                              // UPDATED: 1/5 (was 1/4)
		matrix `T'[`rr',2] = cond(tot_wld_n>0,   100 * (`T'[`rr',1] / tot_wld_n), .)
		matrix `T'[`rr',4] = cond(tot_nowld_n>0, 100 * (`T'[`rr',3] / tot_nowld_n), .)
		matrix `T'[`rr',6] = cond(tot_all_n>0,   100 * (`T'[`rr',5] / tot_all_n), .)
	}

	* ---------- 4) Totals row (EXIT cases) ----------
	matrix `T'[6,1] = tot_wld_n                                     // UPDATED: totals row is 6
	matrix `T'[6,2] = cond(tot_wld_n>=0,   100, .)
	matrix `T'[6,3] = tot_nowld_n
	matrix `T'[6,4] = cond(tot_nowld_n>=0, 100, .)
	matrix `T'[6,5] = tot_all_n
	matrix `T'[6,6] = cond(tot_all_n>=0,   100, .)

	* ---------- 5) Row/column names (SOEP-only) ----------
	matrix rownames `T' = ///
		unemployed ///
		education_training ///
		maternity_parental_leave ///      UPDATED: new row for category 4
		sheltered_workshop ///
		other_non_employed ///
		Total

	matrix colnames `T' = WLD_n WLD_pct NoWLD_n NoWLD_pct Total_n Total_pct

	* ---------- 6) Export (overwrite; keep original filename) ----------
	esttab matrix(`T', fmt(0 1 0 1 0 1)) using ///
		"$path6/soep_retentionchapt_nonemp_bywld_unbalanced.rtf", replace rtf ///
		title("Destinations after employment exit — SOEP unbalanced 25–59 (unweighted)") ///
		nonumber noobs nomtitle

*-------------------------------------------------------------------------------
**# Regression models - Preparation & exploration
*-------------------------------------------------------------------------------

	
* General model specification
************************************

use "$path2/soep_clean.dta", clear

* All employment vars together

	// without specifying categorical vars for now

	xtlogit emploss i.wld_any_imploc ///
		syear sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag i.isic_broad_lag ///
		age nkids i.sex i.mastat i.germborn i.mastat i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1, re lrmodel or

	// Checking for MC using estat vif after linear regression
	regress emploss i.wld_any_imploc ///
		syear sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag i.isic_broad_lag ///
		age nkids i.sex i.mastat i.germborn i.mastat i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1
	estat vif
	
* Try changing ref category of isic_broad from agr to services 

	xtlogit emploss i.wld_any_imploc ///
		syear sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		age nkids i.sex i.mastat i.germborn i.mastat i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1, re lrmodel or
		
	regress emploss i.wld_any_imploc ///
		syear sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		age nkids i.sex i.mastat i.germborn i.mastat i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1
	estat vif
	

* Creating group means for Mundlak correction
*********************************************

/* Creating group means of lagged vars - no longer used

	use "$path2/soep_clean.dta", clear

	* Run plain RE model first and store, to speed up computing time
	* Time-invariant: sampreg (region), sex, germborn, (degree ~ time-invariant in 25–59)
	* Time-varying: wld_any_imploc, esec3_lag, parttime_lag, fixedterm_lag,
	*                jbsize_lag, pubsec_lag, isic_broad_lag, age, nkids, mastat
	* syear not an invidividual covariate so no mean computed 

	* 0) Plain RE for starting values
	xtlogit emploss i.wld_any_imploc ///
		i.syear i.sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag ///
		i.pubsec_lag ib3.isic_broad_lag ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1, re nolog intpoints(7)
	est store RE0

	* 1) Person-means for time-varying covariates (id = pid)
	by pid: egen age_bar   = mean(age)
	by pid: egen nkids_bar = mean(nkids)
	by pid: egen wld_bar   = mean(wld_any_imploc)

	tab esec3_lag, gen(ESEC_)              // keep ESEC_2 ESEC_3
	by pid: egen ESEC_2_bar = mean(ESEC_2)
	by pid: egen ESEC_3_bar = mean(ESEC_3)

	tab parttime_lag, gen(PT_)             // keep PT_2 PT_3
	by pid: egen PT_2_bar = mean(PT_2)
	by pid: egen PT_3_bar = mean(PT_3)

	tab fixedterm_lag, gen(FT_)            // keep FT_2
	by pid: egen FT_2_bar = mean(FT_2)

	tab jbsize_lag, gen(SZ_)               // keep SZ_2 SZ_3
	by pid: egen SZ_2_bar = mean(SZ_2)
	by pid: egen SZ_3_bar = mean(SZ_3)

	tab pubsec_lag, gen(SEC_)              // keep SEC_2
	by pid: egen SEC_2_bar = mean(SEC_2)

	tab isic_broad_lag, gen(IND_)          // you set ib3., so keep IND_1 IND_2
	by pid: egen IND_1_bar = mean(IND_1)
	by pid: egen IND_2_bar = mean(IND_2)

	tab mastat, gen(MS_)                   // keep MS_2 MS_3
	by pid: egen MS_2_bar = mean(MS_2)
	by pid: egen MS_3_bar = mean(MS_3)

	* 2) Mundlak RE (reuse RE0; needs to match it exactly)
	xtlogit emploss i.wld_any_imploc ///
		i.syear i.sampreg ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag ///
		i.pubsec_lag ib3.isic_broad_lag ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree ///
		/* Mundlak means (between effects) */ ///
		c.age_bar c.nkids_bar c.wld_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		MS_2_bar MS_3_bar ///
		if sample_25_59_soep_u==1 & cc_lags==1, re nolog intpoints(7)

	* 3) Joint test: need for Mundlak?
	testparm *_bar
	
	* Can confidently reject null; use Mundlak. Save person-mean variables. 
	
	save "$path2/soep_clean.dta", replace
*/

* Creating person means - non-lagged vars
******************************************

use "$path2/soep_clean.dta", clear
xtset pid syear, yearly

	* All means are computed over the employee risk set: risk_emp_t == 1

	* ---- Continuous ----
	capture drop age_bar nkids_bar wld_bar degree_bar
	bysort pid: egen age_bar    = mean(cond(risk_emp_t==1, age, .))
	bysort pid: egen nkids_bar  = mean(cond(risk_emp_t==1, nkids, .))
	bysort pid: egen wld_bar    = mean(cond(risk_emp_t==1, wld_any_imploc, .))
	bysort pid: egen degree_bar = mean(cond(risk_emp_t==1, degree, .))

	* ---- ESeC 3-class (esec3), base = 1; keep esec_2 esec_3 ----
	* drop old upper-case vars if they exist
	capture drop ESEC_1 ESEC_2 ESEC_3 ESEC_2_bar ESEC_3_bar

	* drop any previous lower-case versions too
	capture drop esec_1 esec_2 esec_3 esec_2_bar esec_3_bar

	tab esec3 if risk_emp_t==1, gen(esec_)
	bysort pid: egen esec_2_bar = mean(cond(risk_emp_t==1, esec_2, .))
	bysort pid: egen esec_3_bar = mean(cond(risk_emp_t==1, esec_3, .))

	* ---- Part-time status (parttime), base = 1; keep pt_2 pt_3 ----
	capture drop PT_1 PT_2 PT_3 PT_2_bar PT_3_bar
	capture drop pt_1 pt_2 pt_3 pt_2_bar pt_3_bar

	tab parttime if risk_emp_t==1, gen(pt_)
	bysort pid: egen pt_2_bar = mean(cond(risk_emp_t==1, pt_2, .))
	bysort pid: egen pt_3_bar = mean(cond(risk_emp_t==1, pt_3, .))

	* ---- Contract type (fixedterm), base = 1; keep ft_2 ----
	capture drop FT_1 FT_2 FT_2_bar
	capture drop ft_1 ft_2 ft_2_bar

	tab fixedterm if risk_emp_t==1, gen(ft_)
	bysort pid: egen ft_2_bar = mean(cond(risk_emp_t==1, ft_2, .))

	* ---- Firm size (jbsize), base = 1; keep sz_2 sz_3 ----
	capture drop SZ_1 SZ_2 SZ_3 SZ_2_bar SZ_3_bar
	capture drop sz_1 sz_2 sz_3 sz_2_bar sz_3_bar

	tab jbsize if risk_emp_t==1, gen(sz_)
	bysort pid: egen sz_2_bar = mean(cond(risk_emp_t==1, sz_2, .))
	bysort pid: egen sz_3_bar = mean(cond(risk_emp_t==1, sz_3, .))

	* ---- Sector (pubsec), base = 1; keep sec_2 ----
	* (assumes pubsec == 1 "not public", 2 "public"; 0 already handled upstream)
	capture drop SEC_1 SEC_2 SEC_2_bar
	capture drop sec_1 sec_2 sec_2_bar

	tab pubsec if risk_emp_t==1, gen(sec_)
	bysort pid: egen sec_2_bar = mean(cond(risk_emp_t==1, sec_2, .))

	* ---- Industry (isic_broad), ib3. in the model; keep ind_1 ind_2 ----
	capture drop IND_1 IND_2 IND_3 IND_1_bar IND_2_bar
	capture drop ind_1 ind_2 ind_3 ind_1_bar ind_2_bar

	tab isic_broad if risk_emp_t==1, gen(ind_)
	bysort pid: egen ind_1_bar = mean(cond(risk_emp_t==1, ind_1, .))
	bysort pid: egen ind_2_bar = mean(cond(risk_emp_t==1, ind_2, .))

	* ---- Marital status (mastat), base = 1; keep ms_2 ms_3 ----
	capture drop MS_1 MS_2 MS_3 MS_2_bar MS_3_bar
	capture drop ms_1 ms_2 ms_3 ms_2_bar ms_3_bar

	tab mastat if risk_emp_t==1, gen(ms_)
	bysort pid: egen ms_2_bar = mean(cond(risk_emp_t==1, ms_2, .))
	bysort pid: egen ms_3_bar = mean(cond(risk_emp_t==1, ms_3, .))

	save "$path2/soep_clean.dta", replace

	*============================================================*
	* Create within-person deviations (x_dev = x - x_bar) — SOEP  *
	* Means computed over risk_emp_t==1                           *
	*============================================================*
	
	use "$path2/soep_clean.dta", clear
	xtset pid syear, yearly

	* ---- Continuous deviations ----
	capture drop age_dev nkids_dev wld_dev degree_dev
	gen double age_dev    = age - age_bar
	gen double nkids_dev  = nkids - nkids_bar
	gen double wld_dev    = wld_any_imploc - wld_bar
	gen double degree_dev = degree - degree_bar

	* Optional: deviations only meaningful in risk set
	replace age_dev    = . if risk_emp_t != 1
	replace nkids_dev  = . if risk_emp_t != 1
	replace wld_dev    = . if risk_emp_t != 1
	replace degree_dev = . if risk_emp_t != 1

	* ---- Dummy deviations ----

	* ESeC 3-class (base=1): esec_2 esec_3
	capture drop esec_2_dev esec_3_dev
	gen double esec_2_dev = esec_2 - esec_2_bar
	gen double esec_3_dev = esec_3 - esec_3_bar
	replace esec_2_dev = . if risk_emp_t != 1
	replace esec_3_dev = . if risk_emp_t != 1

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

	* Firm size (base=1): sz_2 sz_3
	capture drop sz_2_dev sz_3_dev
	gen double sz_2_dev = sz_2 - sz_2_bar
	gen double sz_3_dev = sz_3 - sz_3_bar
	replace sz_2_dev = . if risk_emp_t != 1
	replace sz_3_dev = . if risk_emp_t != 1

	* Sector (base=1): sec_2
	capture drop sec_2_dev
	gen double sec_2_dev = sec_2 - sec_2_bar
	replace sec_2_dev = . if risk_emp_t != 1

	* Industry (ib3. in model; keep ind_1 ind_2)
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


	* ---- Optional labels ----
	label var age_dev    "Age deviation from person-mean (risk set)"
	label var nkids_dev  "Children deviation from person-mean (risk set)"
	label var wld_dev    "WLD deviation from person-mean (risk set)"
	label var degree_dev "Degree deviation from person-mean (risk set)"

	label var esec_2_dev "ESeC=2 deviation from person-mean"
	label var esec_3_dev "ESeC=3 deviation from person-mean"
	label var pt_2_dev   "Part-time=2 deviation from person-mean"
	label var pt_3_dev   "Part-time=3 deviation from person-mean"
	label var ft_2_dev   "Fixed-term=2 deviation from person-mean"
	label var sz_2_dev   "Firm size=2 deviation from person-mean"
	label var sz_3_dev   "Firm size=3 deviation from person-mean"
	label var sec_2_dev  "Sector=2 deviation from person-mean"
	label var ind_1_dev  "Industry=1 deviation from person-mean"
	label var ind_2_dev  "Industry=2 deviation from person-mean"
	label var ms_2_dev   "Marital status=2 deviation from person-mean"
	label var ms_3_dev   "Marital status=3 deviation from person-mean"
	
	save "$path2/soep_clean.dta", replace

*-------------------------------------------------------------------------------
**# Regression models - 1st draft (stepwise, using lagged emp vars)
*-------------------------------------------------------------------------------

* SOEP Stepwise xtlogit RE — Mundlak terms added in their own block
*************************************************************************

	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Ensure estout suite
	capture which estadd
	if _rc ssc install estout, replace

	eststo clear

	*----------------------------------*
	* M0) Baseline (CRE + baseline)
	*   - within: i.wld_any_imploc
	*   - Mundlak here: c.wld_bar ONLY
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar ///
		i.syear i.sampreg ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
	eststo M0
	estadd scalar LR_prev = .
	estadd scalar df_prev = .
	estadd scalar p_prev  = .
	eststo drop M0
	eststo M0

	*----------------------------------*
	* M1) + Socio-demographics
	*   - within: c.age c.nkids i.sex i.germborn i.mastat
	*   - Mundlak added now: c.age_bar c.nkids_bar MS_2_bar MS_3_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	* M2) + Education (degree)
	*   - within: i.degree
	*   - no degree_bar (quasi time-invariant by design)
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat ///
		i.degree ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	*   - within: i.esec3_lag
	*   - Mundlak added now: ESEC_2_bar ESEC_3_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree ///
		i.esec3_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	*   - within: i.jbsize_lag i.pubsec_lag
	*   - Mundlak added now: SZ_2_bar SZ_3_bar SEC_2_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag ///
		i.jbsize_lag i.pubsec_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm i.jbsize_lag i.pubsec_lag

	*----------------------------------*
	* M6) + Industry (lagged) [base=3]
	*   - within: ib3.isic_broad_lag
	*   - Mundlak added now: IND_1_bar IND_2_bar
	*----------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar ///
		PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar ///
		IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ///
		ib3.isic_broad_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm ib3.isic_broad_lag

	*-----------------------------------*
	*  INTERACTIONS (each vs M6)
	*  (No new *_bar terms introduced here; all were added by M6)
	*-----------------------------------*

	* M7) + WLD × Occupation (lagged)
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#i.esec3_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.esec3_lag

	* M8) + WLD × Part-time (lagged)
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#i.parttime_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.parttime_lag

	* M9) + WLD × Fixed-term (lagged)
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#i.fixedterm_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.fixedterm_lag

	* M10) + WLD × Company size (lagged)
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#i.jbsize_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.jbsize_lag

	* M11) + WLD × Public/Private (lagged)
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#i.pubsec_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.pubsec_lag

	* M12) + WLD × Industry (lagged) [base=3]
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#ib3.isic_broad_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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
	testparm 1.wld_any_imploc#i.isic_broad_lag

	* M13) + ALL interactions
	xtlogit emploss i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3_lag ///
		i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag ///
		i.wld_any_imploc#(i.esec3_lag i.parttime_lag i.fixedterm_lag i.jbsize_lag i.pubsec_lag ib3.isic_broad_lag) ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
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

	*--------------------------------------------*
	* Save models as .ster files (new suffix)
	*--------------------------------------------*
	forvalues k = 0/13 {
		estimates restore M`k'
		estimates save "$path8/soep_retentionchapt_xtlogit_M`k'_barsinline.ster", replace
	}

	*----------------------------------*
	* Export fit summaries for the BARS-IN-LINE run
	*----------------------------------*
	
	* Restore estimates from .ster
	use "$path2/soep_clean.dta", clear
	xtset pid syear

	eststo clear
	forvalues k = 0/13 {
		estimates use "$path8/soep_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}
	
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


	* RTF fit table (with model titles)
	esttab M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_fit_barsinline.rtf", replace rtf ///
		title("SOEP stepwise model comparisons (xtlogit re, intpoints(7); Mundlak added in-block)") ///
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 2 0 3 2 0 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p" ///
					"LR vs M6" "df (vs M6)" "p (vs M6)")) ///
		nonotes

	* CSV fit table (with model titles)
	esttab M0 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_fit_barsinline.csv", replace csv ///
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 2 0 3 2 0 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p" ///
					"LR vs M6" "df (vs M6)" "p (vs M6)"))

* Stepwise blocks table without interactions - ORs
*****************************************************

	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* 1) Restore estimates from .ster
	eststo clear
	forvalues k = 0/6 {
		estimates use "$path8/soep_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}

	* 2) If LR vs previous wasn't saved, compute & attach now (no refitting)
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

	* ------------------------------------------------------------- *
	* 3) EXPORT WITH period (i.syear) and region (i.sampreg) effects;
	* ORs with stars only
	* ------------------------------------------------------------- *
	* Coefficient tables (ORs) WITH period/region rows — RTF
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_blocks_or_barsinline.rtf", replace rtf ///
		title("Odds Ratios – SOEP stepwise blocks (xtlogit re, intpoints(7); Mundlak added in-block)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))

	* Coefficient tables (ORs) WITH period/region rows — CSV
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_blocks_or_barsinline.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))


	* ---------------------------------------------------------------- *
	* 4) EXPORT WITHOUT period/region effect rows
	*    Drops i.syear and i.sampreg rows from the output
	* ---------------------------------------------------------------- *
	* Coefficient tables (ORs) WITHOUT period/region rows — RTF
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_blocks_or_no_periodregion_barsinline.rtf", replace rtf ///
		title("Odds Ratios – SOEP stepwise blocks (xtlogit re) — no period/region rows") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		drop(*syear* *sampreg*) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))

	* Coefficient tables (ORs) WITHOUT period/region rows — CSV
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_blocks_or_no_periodregion_barsinline.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		drop(*syear* *sampreg*) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))

* Stepwise tables of interactions
***********************************

	* Interactions (M7–M13) — WITH period/region rows — RTF
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_interactions_or_barsinline.rtf", replace rtf ///
		title("Odds Ratios – SOEP interactions (xtlogit re, intpoints(7); Mundlak added in-block)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))

	* Interactions (M7–M13) — WITH period/region rows — CSV
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_interactions_or_barsinline.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))
			 
	* Interactions (M7–M13) — WITHOUT period/region rows — RTF
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_interactions_or_no_periodregion_barsinline.rtf", replace rtf ///
		title("Odds Ratios – SOEP interactions (xtlogit re) — no period/region rows") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		drop(*syear* *sampreg*) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))

	* Interactions (M7–M13) — WITHOUT period/region rows — CSV
	esttab M7 M8 M9 M10 M11 M12 M13 ///
		using "$path6/soep_retentionchapt_stepwise_interactions_or_no_periodregion_barsinline.csv", replace csv ///
		eform label noobs nobaselevels compress ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		drop(*syear* *sampreg*) ///
		stats(modeltitle ll aic bic N LR_vs_M6 df_vs_M6 p_vs_M6, ///
			 fmt(s 3 2 2 0 3 2 3) ///
			 labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs M6" "df (vs M6)" "p (vs M6)"))

* Run a "final" model (without interactions) and save
*******************************************************

	* Ensure data & panel are set
	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* (Optional) bring back M0–M6 if you saved them earlier
	eststo clear
	forvalues k = 0/6 {
		estimates use "$path8/soep_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
		}

	*-------------------------------------------------------------------------*
	* Final model (no degree; drop within jbsize & industry, keep their means)
	*-------------------------------------------------------------------------*
	xtlogit emploss i.wld_any_imploc ///
		/* Mundlak (between-person) terms kept */ ///
		c.wld_bar c.age_bar c.nkids_bar MS_2_bar MS_3_bar ///
		ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar ///
		SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar ///
		/* Baseline controls */ ///
		i.syear i.sampreg ///
		/* WITHIN (time-varying) terms kept */ ///
		c.age c.nkids i.sex i.germborn i.mastat ///
		i.esec3_lag i.parttime_lag i.fixedterm_lag i.pubsec_lag ///
		if sample_25_59_soep_u==1 & cc_lags==1, re intpoints(7) nolog
		/* EXCLUDED within effects: i.jbsize_lag, ib3.isic_broad_lag */
		/* EXCLUDED: i.degree */ ///
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

	* Helpful model title for tables
	estadd local modeltitle "Final (− industry & size within; − degree)" , replace : Final

	* Save .ster
	estimates save "$path8/soep_retentionchapt_xtlogit_Final_barsinline.ster", replace


* Check Rho in M6
	
	use "$path2/soep_clean.dta", clear
	xtset pid syear
	
	* Restore M6
	eststo clear
	est use "$path8/soep_retentionchapt_xtlogit_M6_barsinline.ster"
	ereturn list
	display e(rho)

* Export regression tables for chapter
***************************************

capture which esttab
ssc install estout, replace


* 1. Stepwise table: models M0 to M6 - no interactions - Odds ratios
*-----------------------------------------------------------------------------
// Excluding "Final"

	* RESTORE SOEP MODELS FROM .STER (M0–M6)
	
	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Start fresh
	eststo clear

	* Restore M0–M6
	forvalues k = 0/6 {
		estimates use "$path8/soep_retentionchapt_xtlogit_M`k'_barsinline.ster"
		eststo M`k'
	}

	* (Optional) quick sanity check
	eststo dir

	*------------------------------------------
	* Table groupings 
	*------------------------------------------

	* Use a model with all the broadest terms (M6)
		capture estimates restore M6

		matrix b = e(b)

	* Get the full coefficient names that Stata actually uses
		local cols : colfullnames e(b)

		* Print one per line (strip "xb:" so they're cleaner to paste)
		display as text "Coefficient names:"
		local i = 1
		foreach c of local cols {
			local cname : subinstr local c "xb:" "", all
			di as result %3.0f `i' "  " as text "`cname'"
			local ++i
		}
		
	* Write the coefnames to a text file
		tempname fh
		file open `fh' using "$path8/soep_retentionchapt_coefnames.txt", write replace
		local cols : colfullnames e(b)
		foreach c of local cols {
			local cname : subinstr local c "xb:" "", all
			file write `fh' "`cname'" _n
		}
		file close `fh'
		di as txt "Wrote: $path8/soep_retentionchapt_coefnames.txt"
		
	/* Categorize variables by groups - didn't work so quoting directly in esttab

	// Built from $path8/soep_retentionchapt_coefnames.txt"
		
	* BETWEEN (Mundlak means)
	local BETWEEN wld_bar age_bar nkids_bar MS_2_bar MS_3_bar ESEC_2_bar ESEC_3_bar PT_2_bar PT_3_bar FT_2_bar SZ_2_bar SZ_3_bar SEC_2_bar IND_1_bar IND_2_bar

	* WITHIN (time-varying, non-Mundlak) – incl. WLD within component
	local WITHIN 0b.wld_any_imploc 1.wld_any_imploc age nkids 1b.mastat 2.mastat 3.mastat ///
				  1b.esec3_lag 2.esec3_lag 3.esec3_lag ///
				  1b.parttime_lag 2.parttime_lag 3.parttime_lag ///
				  1b.fixedterm_lag 2.fixedterm_lag ///
				  1b.jbsize_lag 2.jbsize_lag 3.jbsize_lag ///
				  1b.pubsec_lag 2.pubsec_lag ///
				  1.isic_broad_lag 2.isic_broad_lag 3b.isic_broad_lag

	* TIME-INVARIANT (as per your spec)
	local TIMEINV 1b.sex 2.sex 1b.germborn 2.germborn 0b.degree 1.degree

	* PERIOD & REGION
	local PERIODREG 2011b.syear 2012.syear 2013.syear 2014.syear 2015.syear 2016.syear ///
					2017.syear 2018.syear 2019.syear 1b.sampreg 2.sampreg

	*/

	* RTF export - WITH PERIOD & YEAR EFFECTS
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_final_OR.rtf", replace rtf ///
		mtitles("M0 Baseline" "M1 +SD +means" "M2 +Degree" "M3 +Occ +means" ///
				"M4 +Contract +means" "M5 +Firm +means" "M6 +Industry +means") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep("wld_bar" "age_bar" "nkids_bar" "MS_2_bar" "MS_3_bar" "ESEC_2_bar" "ESEC_3_bar" "PT_2_bar" ///
			"PT_3_bar" "FT_2_bar" "SZ_2_bar" "SZ_3_bar" "SEC_2_bar" "IND_1_bar" "IND_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "2.mastat" "3.mastat" ///
			"2.esec3_lag" "3.esec3_lag" ///
			"2.parttime_lag" "3.parttime_lag" ///
			"2.fixedterm_lag" ///
			"2.jbsize_lag" "3.jbsize_lag" ///
			"2.pubsec_lag" ///
			"1.isic_broad_lag" "2.isic_broad_lag" ///
			"2.sex" "2.germborn" "1.degree" ///
			"2012.syear" "2013.syear" "2014.syear" "2015.syear" "2016.syear" "2017.syear" "2018.syear" "2019.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u") ///
		order("wld_bar" "age_bar" "nkids_bar" "MS_2_bar" "MS_3_bar" "ESEC_2_bar" "ESEC_3_bar" "PT_2_bar" ///
			"PT_3_bar" "FT_2_bar" "SZ_2_bar" "SZ_3_bar" "SEC_2_bar" "IND_1_bar" "IND_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "2.mastat" "3.mastat" ///
			"2.esec3_lag" "3.esec3_lag" "2.parttime_lag" "3.parttime_lag" "2.fixedterm_lag" ///
			"2.jbsize_lag" "3.jbsize_lag" "2.pubsec_lag" "1.isic_broad_lag" "2.isic_broad_lag" ///
			"2.sex" "2.germborn" "1.degree" ///
			"2012.syear" "2013.syear" "2014.syear" "2015.syear" "2016.syear" "2017.syear" "2018.syear" "2019.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic LR_prev df_prev p_prev, ///
			 fmt(0 3 2 2 2 0 3) ///
			 labels("N" "LogLik" "AIC" "BIC" "LR vs prev" "df" "p"))

*-------------------------------------------------------------------------------
**# Regression models - 2nd draft (vars at t) - 3/12/25
*-------------------------------------------------------------------------------

// All variables measured at t 

	use "$path2/soep_clean.dta", clear
	xtset pid syear

	* Start fresh
	eststo clear
	
* Simple pooled logit: exit on WLD only (SOEP)
	logit exit_t1 i.wld_any_imploc if risk_emp_t==1, or
	eststo logit_simple_wld_soep
	
* Full pooled logit (no RE) – SOEP, WLD at t
	logit exit_t1 i.wld_any_imploc ///
		c.age c.nkids ///
		i.sex i.germborn i.mastat i.degree ///
		i.esec3 ///
		i.parttime i.fixedterm i.jbsize i.pubsec ///
		ib3.isic_broad ///
		i.syear i.sampreg ///
		if risk_emp_t==1, or

	eststo logit_full_wld_soep
	estimates save "$path8/soep_retentionchapt_logit_full_wld_t.ster", replace
	// wld OR 1.96
	
* RE logit without Mundlak person-means – SOEP
	xtset pid syear, yearly

	xtlogit exit_t1 i.wld_any_imploc ///
		c.age c.nkids ///
		i.sex i.germborn i.mastat i.degree ///
		i.esec3 ///
		i.parttime i.fixedterm i.jbsize i.pubsec ///
		ib3.isic_broad ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog

	eststo re_no_mundlak_wld_soep
	// Rho 29.3%
	// WLD OR 2.13

* RE logit with Mundlak – SOEP, WLD at t
	xtset pid syear, yearly

	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm i.jbsize i.pubsec ///
		ib3.isic_broad ///
		if risk_emp_t==1, re or intpoints(7) nolog

	eststo m6_wld_t_soep

	* Save SOEP Mundlak model
	estimates save "$path8/soep_retentionchapt_xtlogit_full_wld_at_t.ster", replace

* Full model with interactions - SOEP, WLD at t

	use "$path2/soep_clean.dta", clear
	xtset pid syear, yearly

	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm i.jbsize i.pubsec ib3.isic_broad ///
		i.wld_any_imploc#(i.esec3 i.parttime i.fixedterm i.jbsize i.pubsec ib3.isic_broad) ///
		if risk_emp_t==1, re or intpoints(7) nolog
	
	eststo interactions_wld_t_soep
	estimates save "$path8/soep_retentionchapt_xtlogit_full_wld_at_t_interactions.ster", replace

* Export full model with Mundlak (no interactions)
****************************************************

	* Check if esttab/eststo exist
	which esttab
	which eststo

	* Install (or reinstall) the estout package from SSC
	ssc install estout, replace

	* Load data & results
	use "$path2/soep_clean.dta", clear
	xtset pid syear
	estimates use "$path8/soep_retentionchapt_xtlogit_full_wld_at_t.ster"
	
	eststo m6_wld_t_soep
	estimates dir

	* Export RE logit with Mundlak specification (SOEP)

	est restore m6_wld_t_soep

	esttab m6_wld_t_soep ///
		using "$path6/soep_retentionchapt_relogit_mundlak_wldt_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak (WLD at t)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "esec_2_bar" "esec_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "1.degree" ///
			"2.mastat" "3.mastat" ///
			"2.esec3" "3.esec3" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize" "3.jbsize" ///
			"2.pubsec" ///
			"1.isic_broad" "2.isic_broad" ///
			"2.sex" "2.germborn" ///
			"2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
			"2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u" ) ///
		order( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "esec_2_bar" "esec_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"ind_1_bar" "ind_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "1.degree" ///
			"2.mastat" "3.mastat" ///
			"2.esec3" "3.esec3" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize" "3.jbsize" ///
			"2.pubsec" ///
			"1.isic_broad" "2.isic_broad" ///
			"2.sex" "2.germborn" ///
			"2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
			"2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))
			 

*-------------------------------------------------------------------------------
**# Regression models - third (Final) draft (13/01/26)
* 		- all vars at t
*		- using exit_t1 and risk_set
*-------------------------------------------------------------------------------

	use "$path2/soep_clean.dta", clear
	xtset pid syear

* Run sequential approach again for model fit stats
*****************************************************
	
	* Ensure estout suite
	capture which estadd
	if _rc ssc install estout, replace

	eststo clear

	*----------------------------------*
	* M0) Baseline
	*   - within: i.wld_any_imploc
	*   - Mundlak: c.wld_bar ONLY
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	eststo M0
	estadd scalar LR_prev = .
	estadd scalar df_prev = .
	estadd scalar p_prev  = .
	eststo drop M0
	eststo M0

	*----------------------------------*
	* M1) + Socio-demographics (+ means)
	*   - within: c.age c.nkids i.sex i.germborn i.mastat
	*   - Mundlak: c.age_bar c.nkids_bar ms_2_bar ms_3_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar ///
		ms_2_bar ms_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat ///
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
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat ///
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
	*   - within: i.esec3
	*   - Mundlak: esec_2_bar esec_3_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree ///
		i.esec3 ///
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
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
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
	*   - within: i.jbsize i.pubsec
	*   - Mundlak: sz_2_bar sz_3_bar sec_2_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm ///
		i.jbsize i.pubsec ///
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
	testparm i.jbsize i.pubsec

	*----------------------------------*
	* M6) + Industry (+ means) [base=3]
	*   - within: ib3.isic_broad
	*   - Mundlak: ind_1_bar ind_2_bar
	*----------------------------------*
	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		ind_1_bar ind_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm i.jbsize i.pubsec ///
		ib3.isic_broad ///
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
	testparm ib3.isic_broad

	*--------------------------------------------*
	* Save models as .ster files (M0–M6 only)
	*--------------------------------------------*
	forvalues k = 0/6 {
		estimates restore M`k'
		estimates save "$path8/soep_retentionchapt_xtlogit_M`k'_wld_t_exit_t1_riskemp.ster", replace
	}

	*----------------------------------*
	* Add model titles (for diagnostics table)
	*----------------------------------*
	estadd local modeltitle "M0 Baseline"             , replace : M0
	estadd local modeltitle "M1 +SD +means"           , replace : M1
	estadd local modeltitle "M2 +Degree +deg_mean"    , replace : M2
	estadd local modeltitle "M3 +Occ +means"          , replace : M3
	estadd local modeltitle "M4 +Contract +means"     , replace : M4
	estadd local modeltitle "M5 +Firm +means"         , replace : M5
	estadd local modeltitle "M6 +Industry +means"     , replace : M6

	*----------------------------------*
	* Export diagnostics CSV (M0–M6)
	*----------------------------------*
	esttab M0 M1 M2 M3 M4 M5 M6 ///
		using "$path6/soep_retentionchapt_stepwise_fit_draft3_final.csv", ///
		replace csv ///
		cells(none) ///
		stats(modeltitle ll aic bic N LR_prev df_prev p_prev, ///
			  fmt(s 3 2 2 0 2 0 3) ///
			  labels("Model title" "LogLik" "AIC" "BIC" "N" "LR vs prev" "df" "p"))
			  
**# Extra diagnostics for the final model (M5)
***********************************************************
	use "$path2/soep_clean.dta", clear
	xtset pid syear

* MC - Without person-means
	regress exit_t1 i.wld_any_imploc ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm ///
		i.jbsize i.pubsec ///
		if risk_emp_t==1
	estat vif

* MC - With person-means
	regress exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm ///
		i.jbsize i.pubsec ///
		if risk_emp_t==1
	estat vif

* Checking switchers

	* Vars: esec3 parttime fixedterm jbsize pubsec isic_broad     *
	foreach var in esec3 parttime fixedterm jbsize pubsec isic_broad {
		xttrans `var' if risk_emp_t==1, freq
	}
	
	* Saved as $path6/soep_retentionchapt_switchers_`var'.png

**# Final model to export
*****************************

* Export M5 with OR - RE logit Mundlak (before adding industry)

	* Load data & results
	use "$path2/soep_clean.dta", clear
	xtset pid syear
	
	estimates use "$path8/soep_retentionchapt_xtlogit_M5_wld_t_exit_t1_riskemp.ster"
	eststo m5_final_soep
	estimates dir

	* Export RE logit with Mundlak specification (SOEP)

	est restore m5_final_soep

	esttab m5_final_soep ///
		using "$path6/soep_retentionchapt_relogit_mundlak_v3_m5_or.rtf", replace rtf ///
		mtitles("RE logit + Mundlak (WLD at t)") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "esec_2_bar" "esec_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "1.degree" ///
			"2.mastat" "3.mastat" ///
			"2.esec3" "3.esec3" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize" "3.jbsize" ///
			"2.pubsec" ///
			"2.sex" "2.germborn" ///
			"2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
			"2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u" ) ///
		order( ///
			"wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
			"ms_2_bar" "ms_3_bar" "esec_2_bar" "esec_3_bar" ///
			"pt_2_bar" "pt_3_bar" "ft_2_bar" ///
			"sz_2_bar" "sz_3_bar" "sec_2_bar" ///
			"1.wld_any_imploc" "age" "nkids" "1.degree" ///
			"2.mastat" "3.mastat" ///
			"2.esec3" "3.esec3" ///
			"2.parttime" "3.parttime" ///
			"2.fixedterm" ///
			"2.jbsize" "3.jbsize" ///
			"2.pubsec" ///
			"2.sex" "2.germborn" ///
			"2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
			"2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
			"2.sampreg" ///
			"_cons" "/lnsig2u") ///
		coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))

* Predicted probs for WLD only
*******************************

* If first time: re-run SOEP M5 + save with estimation sample (for margins) - only ONCE

    use "$path2/soep_clean.dta", clear
    xtset pid syear

    * Re-estimate M5 (without industrial sector)
    	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm ///
		i.jbsize i.pubsec ///
		if risk_emp_t==1, re or intpoints(7) nolog

    * Create & keep an explicit sample marker
    capture drop esamp_M5_de
    gen byte esamp_M5_de = e(sample)

    * Save the estimates to .ster
    estimates save "$path8/soep_M5_wld_t_exit_t1_riskemp.ster", replace

    * Strongly recommended: save a dataset copy that includes esamp_M5
    save "$path8/soep_clean_with_esamp_M5.dta", replace

	/* If repeating in a later session: use saved esample dataset & results
	use "$path8/soep_clean_with_esamp_M5.dta", clear
	xtset pid syear

	estimates use "$path8/soep_M5_wld_t_exit_t1_riskemp.ster"

	* Reset e(sample) using the saved indicator
	estimates esample: esamp_M5_de==1
	*/

	* Run margins command
	margins, at(wld_any_imploc=(0 1)) post
	estimates store pp_m5_de

	* Export table as rtf (add stars manually)
	esttab pp_m5_de using "$path6/soep_retentionchapt_m5_predprobs.rtf", replace rtf ///
		noobs nonotes nomtitles ///
		cells(b(fmt(3)) ci(fmt(3))) ///
		coeflabels(1._at "No WLD" 2._at "WLD") ///
		collabels("Pr(exit)" "CI low" "CI high") ///
		title("SOEP Predicted probabilities of exit (Model 5) by WLD status")
		
	* Pairwise comparison of predicted probabilities
	estimates restore pp_m5_de
	pwcompare _at, effects post
		
**# Interactions (without industrial sector)
*******************************************

    use "$path2/soep_clean.dta", clear
    xtset pid syear

    * Re-estimate M5
    	xtlogit exit_t1 i.wld_any_imploc ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		i.syear i.sampreg ///
		c.age c.nkids i.sex i.germborn i.mastat i.degree i.esec3 ///
		i.parttime i.fixedterm ///
		i.jbsize i.pubsec ///
		i.wld_any_imploc#(i.esec3 i.parttime i.fixedterm i.jbsize i.pubsec) ///
		if risk_emp_t==1, re or intpoints(7) nolog	
		
	* Name & save model. Also save esample for future use with margins in temp dataset
		est store int_de
		capture drop esamp_int_de
		gen byte esamp_int_de = e(sample)
		estimates save "$path8/soep_retentionchapt_xtlogit_interactions_v3.ster", replace
		save "$path8/soep_clean_with_esamp_int.dta", replace	
		
*-------------------------------------------------------------------------------
**# Fourth draft of regression models - 26/01/26
* - with deviations instead of person means
*-------------------------------------------------------------------------------

    use "$path2/soep_clean.dta", clear
    xtset pid syear

* Hybrid / CRE model (means + deviations)
*******************************************

* Run model with odds ratios & export

	xtlogit exit_t1 ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.wld_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store v4_de	
	
	estimates save "$path8/soep_retentionchapt_xtlogit_modelv4_deviations.ster", replace
	
	est restore v4_de
	
	esttab v4_de ///
    using "$path6/soep_retentionchapt_relogit_mundlak_v4_dev_or.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (WLD at t)") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar   "Between-person effects (person means)" ///
        wld_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))

* Run linear model and check collinearity
	regress exit_t1 ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.wld_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1
	estat vif
	
* Diagnostics: sensitivity to number of integration points

	xtlogit exit_t1 ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.wld_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store v4_de	
	
	quadchk 12 20, nofrom

* Run full model with interactions
***********************************

* Interactions for between effects only
	xtlogit exit_t1 ///
		c.wld_dev ///
		c.wld_bar##( ///
			c.esec_2_bar c.esec_3_bar ///
			c.pt_2_bar c.pt_3_bar ///
			c.ft_2_bar ///
			c.sz_2_bar c.sz_3_bar ///
			c.sec_2_bar ///
		) ///
		c.age_dev c.age_bar ///
		c.nkids_dev c.nkids_bar ///
		c.degree_dev c.degree_bar ///
		c.ms_2_dev c.ms_2_bar  c.ms_3_dev c.ms_3_bar ///
		c.esec_2_dev c.esec_3_dev ///
		c.pt_2_dev c.pt_3_dev ///
		c.ft_2_dev ///
		c.sz_2_dev c.sz_3_dev ///
		c.sec_2_dev sec_2_bar ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store int_de

* Export
	esttab int_de ///
		using "$path6/soep_retentionchapt_relogit_mundlak_v4_dev_int.rtf", replace rtf ///
		mtitles("RE logit + Mundlak: between (means) interactions only") ///
		eform label noobs nobaselevels compress gaps ///
		cells(b(fmt(2) star)) ///
		star(* 0.05 ** 0.01 *** 0.001) ///
		keep( ///
			"c.wld_bar#c.esec_2_bar" "c.wld_bar#c.esec_3_bar" ///
			"c.wld_bar#c.pt_2_bar"   "c.wld_bar#c.pt_3_bar" ///
			"c.wld_bar#c.ft_2_bar" ///
			"c.wld_bar#c.sz_2_bar"   "c.wld_bar#c.sz_3_bar" ///
			"c.wld_bar#c.sec_2_bar" ///
		) ///
		order( ///
			"c.wld_bar#c.esec_2_bar" "c.wld_bar#c.esec_3_bar" ///
			"c.wld_bar#c.pt_2_bar"   "c.wld_bar#c.pt_3_bar" ///
			"c.wld_bar#c.ft_2_bar" ///
			"c.wld_bar#c.sz_2_bar"   "c.wld_bar#c.sz_3_bar" ///
			"c.wld_bar#c.sec_2_bar" ///
		) ///
		stats(N ll aic bic, ///
			 fmt(0 3 2 2) ///
			 labels("N" "LogLik" "AIC" "BIC"))

*-------------------------------------------------------------------------------
**# Sensitivity analyses
*-------------------------------------------------------------------------------

* Balanced/ weighted model
*****************************

	* Load data & apply longitudinal weight (for ref, as will use iweight)
    use "$path2/soep_clean.dta", clear
    xtset pid syear
	
	svyset, clear
	svyset psu [pweight=lw], strata(strat) singleunit(scaled)
	
	* Run model with ORs
	xtlogit exit_t1 ///
		c.wld_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.wld_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		[iweight=lw] ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store de_iweight
	
	* Export results
	esttab de_iweight ///
    using "$path6/soep_retentionchapt_relogit_mundlak_sensitivity_iweight.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (WLD at t) - balanced panel with longitudinal weight") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar   "Between-person effects (person means)" ///
        wld_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Removing education from models
**********************************

// using main unbalanced / unweighted model

	* Load data
    use "$path2/soep_clean.dta", clear
    xtset pid syear
	
	* Run model with ORs, removing degree_bar and degree_dev
	xtlogit exit_t1 ///
		c.wld_bar c.age_bar c.nkids_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.wld_dev c.age_dev c.nkids_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store de_noed

	* Export table 
	esttab de_noed ///
    using "$path6/soep_retentionchapt_relogit_mundlak_sensitivity_noed.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (WLD at t) - removing education") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "wld_bar" "age_bar" "nkids_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "wld_bar" "age_bar" "nkids_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "wld_dev" "age_dev" "nkids_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        wld_bar   "Between-person effects (person means)" ///
        wld_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Sensitivity to measures of disability
*****************************************

// In the unbalanced and unweighted models

* Create variables for person-means and deviations

    use "$path2/soep_clean.dta", clear
    xtset pid syear

	* Drop existing person-means and deviations if they already exist
	 capture drop chronic_imploc_bar
	 capture drop eadis_bar
	 capture drop legaldis_bar
	 capture drop chronic_imploc_dev
	 capture drop eadis_dev
	 capture drop legaldis_dev
	 
	* Person-means calculated over the employee risk set
	bysort pid: egen chronic_imploc_bar = mean(cond(risk_emp_t == 1, chronic_imploc, .))
	bysort pid: egen eadis_bar     = mean(cond(risk_emp_t == 1, eadis, .))
	bysort pid: egen legaldis_bar     = mean(cond(risk_emp_t == 1, legaldis, .))

	* Personal deviations from person-mean
	gen chronic_imploc_dev = chronic_imploc - chronic_imploc_bar if risk_emp_t == 1
	gen eadis_dev = eadis - eadis_bar if risk_emp_t == 1
	gen legaldis_dev = legaldis - legaldis_bar if risk_emp_t == 1
	
	* save the new variables
	save "$path2/soep_clean.dta", replace 

* Long-standing impairment
	
	* Run model with ORs
	
    use "$path2/soep_clean.dta", clear
    xtset pid syear	
	
	xtlogit exit_t1 ///
		c.chronic_imploc_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.chronic_imploc_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store de_chronic
	
	* Export results
	esttab de_chronic ///
    using "$path6/soep_retentionchapt_relogit_mundlak_sensitivity_chronic.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (chronic_imploc at t) - long-standing impairment") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "chronic_imploc_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "chronic_imploc_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "chronic_imploc_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "chronic_imploc_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        chronic_imploc_bar   "Between-person effects (person means)" ///
        chronic_imploc_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Impairment & activity limitation

* Run model with ORs
	
    use "$path2/soep_clean.dta", clear
    xtset pid syear	
	
	xtlogit exit_t1 ///
		c.eadis_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.eadis_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store de_eadis
	
	* Export results
	esttab de_eadis ///
    using "$path6/soep_retentionchapt_relogit_mundlak_sensitivity_eadis.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (eadis at t) - Impairment & activity limitation") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "eadis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "eadis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "eadis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "eadis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        eadis_bar   "Between-person effects (person means)" ///
        eadis_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))
		 
* Formal disability status

* Run model with ORs
	
    use "$path2/soep_clean.dta", clear
    xtset pid syear	
	
	xtlogit exit_t1 ///
		c.legaldis_bar c.age_bar c.nkids_bar c.degree_bar ///
		ms_2_bar ms_3_bar ///
		esec_2_bar esec_3_bar ///
		pt_2_bar pt_3_bar ft_2_bar ///
		sz_2_bar sz_3_bar sec_2_bar ///
		c.legaldis_dev c.age_dev c.nkids_dev c.degree_dev ///
		ms_2_dev ms_3_dev ///
		esec_2_dev esec_3_dev ///
		pt_2_dev pt_3_dev ft_2_dev ///
		sz_2_dev sz_3_dev sec_2_dev ///
		i.sex i.germborn ///
		i.syear i.sampreg ///
		if risk_emp_t==1, re or intpoints(7) nolog
	est store de_legaldis
	
	* Export results
	esttab de_legaldis ///
    using "$path6/soep_retentionchapt_relogit_mundlak_sensitivity_legaldis.rtf", replace rtf ///
    mtitles("RE logit + Mundlak (legaldis at t) - Formal disability status") ///
    eform label noobs nobaselevels compress gaps ///
    cells(b(fmt(2) star)) ///
    star(* 0.05 ** 0.01 *** 0.001) ///
    keep( ///
        "legaldis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "legaldis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    order( ///
        "legaldis_bar" "age_bar" "nkids_bar" "degree_bar" ///
        "ms_2_bar" "ms_3_bar" ///
        "esec_2_bar" "esec_3_bar" ///
        "pt_2_bar" "pt_3_bar" "ft_2_bar" ///
        "sz_2_bar" "sz_3_bar" "sec_2_bar" ///
        "legaldis_dev" "age_dev" "nkids_dev" "degree_dev" ///
        "ms_2_dev" "ms_3_dev" ///
        "esec_2_dev" "esec_3_dev" ///
        "pt_2_dev" "pt_3_dev" "ft_2_dev" ///
        "sz_2_dev" "sz_3_dev" "sec_2_dev" ///
        "2.sex" "2.germborn" ///
        "2011.syear" "2012.syear" "2013.syear" "2014.syear" ///
        "2015.syear" "2016.syear" "2017.syear" "2018.syear" ///
        "2.sampreg" ///
        "_cons" "/lnsig2u" ) ///
    refcat( ///
        legaldis_bar   "Between-person effects (person means)" ///
        legaldis_dev   "Within-person effects (deviations from person means)" ///
        2.sex     "Time-invariant covariates" ///
        2011.syear "Period effects" ///
        2.sampreg "Region effects", nolabel ) ///
    coeflabels(/lnsig2u "σ_u^2 (RE variance)") ///
    stats(N ll aic bic, ///
         fmt(0 3 2 2) ///
         labels("N" "LogLik" "AIC" "BIC"))