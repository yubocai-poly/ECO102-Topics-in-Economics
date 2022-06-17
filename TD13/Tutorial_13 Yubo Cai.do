********************************************************************************
*                               Migrant segregation - TD                       *
********************************************************************************


	*cd X

	clear all

/*----s1: Prepare the dataset -------*
    *------------------------*/
	
	cd  "/Users/yubocai/Desktop/Ecole Polytechnique/Semester 2/ECO102/TD13"
	use "menlog", clear

	set more off

	*** 1) Prepare the dataset

	* variable of origin (not born in France and born outside of Europe)
	gen non_european = mnatio != "1" & mpnair > "07"

	* variable of interest: living in zone urbaine sensible
	gen deprived = zus == "1"

	* control variables
	gen employed = msitua == "1"
	gen female = msexe == "2"
	gen renter = soc3 == "4"
	gen nb_kids = mne
	gen many_kids = nb_kids > 2
	gen couple = mfam == "1"
	gen married = mmatri == "2"
	gen married_couple = couple * married
	gen diploma = mdiplo
	gen occupation = mcs8
	gen low_diploma = diploma < "5"
	gen high_occupation = occupation == "3" | occupation == "4"


	*** 2) Baseline regressions
	
	* unconditional effect
	
	reg deprived non_european
	estimates store unc
	
	* conditional on household characteristics
	
	reg deprived non_european many_kids employed female married_couple low_diploma high_occupation
	estimates store con
	
	* Export regressions
	esttab unc con  using "regs.tex", ///
		replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
		sfmt(%10.0f %10.3f %10.3f) ///
		star(* 0.10 ** 0.05 *** 0.01) noobs ///
		label nonotes 
	

	*** 3) which individual characteristic makes immigrants more likely to live in hlm
	
	reg deprived non_european#many_kids employed female married_couple low_diploma high_occupation
	reg deprived non_european##many_kids employed female married_couple low_diploma high_occupation
	
	reg deprived non_european#employed many_kids female married_couple low_diploma high_occupation
	reg deprived non_european##employed many_kids female married_couple low_diploma high_occupation
	
	reg deprived non_european#female many_kids employed married_couple low_diploma high_occupation
	reg deprived non_european##female many_kids employed married_couple low_diploma high_occupation
	
	reg deprived non_european#married_couple many_kids employed female low_diploma high_occupation
	reg deprived non_european##married_couple many_kids employed female low_diploma high_occupation
	
	reg deprived non_european#low_diploma many_kids employed female married_couple high_occupation
	reg deprived non_european##low_diploma many_kids employed female married_couple high_occupation
	
	reg deprived non_european#high_occupation many_kids employed female married_couple low_diploma 
	reg deprived non_european##high_occupation many_kids employed female married_couple low_diploma 
	
	/*non european not many kids的系数是0.14，然后相应根据每个系数去进行加上 (0,0)-0.12 (0,1)-0.11 (1,0)-0.25 (1,1)-0.41*/
	
	*** 4) the role of push and pull factors at the local level: public housing

	* location identifier
	
	egen location = group(tu2010 rg)
	
	* conditional on household characteristics and location

	reghdfe deprived non_european many_kids employed female married_couple low_diploma high_occupation, absorb(location)
	estimates store push1
	
	* calculate fraction of non-europeans living in social housing
	gen hlm = lsy1 == "1"
	gen non_european_hlm = non_european * hlm
	egen sum_non_european_hlm = sum(non_european_hlm), by(location)
	egen sum_hlm = sum(hlm), by(location)
	gen frac_non_european_hlm = (sum_non_european_hlm - non_european_hlm)/(sum_hlm - hlm)
	
	* calculate fraction of individuals living in social housing
	gen indic = 1
	egen sum_tot = sum(indic), by(location)
	gen frac_hlm = (sum_hlm - hlm)/(sum_tot - indic)
	egen sum_non_european = sum(non_european), by(location)
	gen frac_non_european = (sum_non_european - non_european)/(sum_tot - indic)

	* calculate fraction of non-europeans not living in social housing
	gen non_hlm = 1 - hlm
	gen non_european_non_hlm = non_european * (non_hlm)
	egen sum_non_european_non_hlm = sum(non_european_non_hlm), by(location)
	egen sum_non_hlm = sum(non_hlm), by(location)
	gen frac_non_european_non_hlm = (sum_non_european_non_hlm - non_european_non_hlm)/(sum_non_hlm - non_hlm)

	* calculate pull factor: you are attracted to places with more non-european migrants
	gen inter_1_non_european = non_european * frac_non_european_hlm
	gen inter_1_other = (1 - non_european) * frac_non_european_hlm

	* calculate push factor: if non-europeans don't have access to public housing, you are less likely to live in deprived areas
	gen inter_2_non_european = non_european * frac_non_european_non_hlm
	gen inter_2_other = (1 - non_european) * frac_non_european_non_hlm

	reg deprived non_european
	
	
	
	estimates store push2
	
	estimates store push3
	
	* Export regressions
	esttab push1 push2 push3 using "regs3.tex", ///
		replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
		sfmt(%10.0f %10.3f %10.3f) ///
		star(* 0.10 ** 0.05 *** 0.01) noobs ///
		label nonotes 

	*** 5) the role of past location
	
	
	*** movers

	estimates store past1

	estimates store past2

	estimates store past3


	* Export regressions
	esttab past1 past2 past3  using "regs4.tex", ///
		replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
		sfmt(%10.0f %10.3f %10.3f) ///
		star(* 0.10 ** 0.05 *** 0.01) noobs ///
		label nonotes 

	*** non_movers

	estimates store nm1

	estimates store nm2

	estimates store nm3

	* Export regressions
	esttab nm1 nm2 nm3  using "regs5.tex", ///
		replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
		sfmt(%10.0f %10.3f %10.3f) ///
		star(* 0.10 ** 0.05 *** 0.01) noobs ///
		label nonotes 
