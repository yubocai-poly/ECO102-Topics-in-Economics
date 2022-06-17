********************************************************************************
*                               The marriage market - TD                       *
********************************************************************************

	* Set your Working Directory
	* Example cd "C:\Users\User\Data\Documents\PhD\Divers\TD\ECO102\TD11_marriage_market"


/*----s1: Prepare the dataset -------*
    *------------------------*/

	clear all 
	cd "/Users/yubocai/Desktop/Ecole Polytechnique/Semester 2/ECO102/TD11/"
	use data_couples, clear

	* Descriptive statistics 
	label define ciy_size_label 0 "rural" 1 "small cities" 4 "medium cities" 6 "large cities" 8 "Paris region"
	label values city_size city_size_label
	est clear
	estpost tabstat education_r education_p, by(city_size) c(stat) stat(mean sd min max n)
	esttab using "./educ_sum.tex", replace ///
	cells("mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber
	* label variable city_size
	
	* On interaction terms: https://www.stata.com/features/overview/factor-variables/
	* More on interaction terms : https://stats.oarc.ucla.edu/stata/faq/what-happens-if-you-omit-the-main-effect-in-a-regression-model-with-an-interaction/

	* Regression education 
	*partner_edu= a + b0resp_edu+ b1rural+b2small+b3Medium+b4Large+b5+rep*rurel
	*gen partner_edu city_size##education_r i.year
	set more off
	*add reg
	reg education_p city_size##c.education_r age_r active_r i.year [pw=weight]
	estimates store rall
	*add reg
	reg education_p city_size##c.education_r age_r active_r i.year [pw=weight] if year<2003
	estimates store r2003
	*add reg
	reg education_p city_size##c.education_r age_r active_r i.year [pw=weight] if year>2003
	estimates store r2007


	* Graph education 

	* Simplified code 
	coefplot (rall, recast(connected)) /// 
	(r2003, recast(connected)) ///
	(r2007, recast(connected)), ///
		keep(*.city_size#*.education_r 0.city_size) base vertical nolabel yline(0) ///
		coeflabels(0.city_size ="rural" 1.city_size#c.education_r ="small cities" ///
			4.city_size#c.education_r="medium cities" 6.city_size#c.education_r= "large cities" ///
			8.city_size#c.education_r= "Paris region")
	
	* Full graph with options to comment 
	coefplot (rall, recast(connected) /// 
					lpattern(solid) lwidth(thin) lcolor(black) /// 
					msymbol(X) mcolor(black) /// 
					ciopts(lcolor(black))) /// 
			 (r2003, recast(connected) ///
					lpattern(dash) lwidth(thin) lcolor(dkgreen) ///
					mcolor(dkgreen) ///
					ciopts(lcolor(dkgreen))) ///
			 (r2007, recast(connected) ///
					lpattern(dash_dot) lwidth(thin) lcolor(orange) ///
					msymbol(d) mfcolor(white) mcolor(orange) /// 
					ciopts(lcolor(orange))), ///
		keep(*.city_size#*.education_r 0.city_size) /// 
		base /// 
		nolabel /// 
		coeflabels(0.city_size ="rural" 1.city_size#c.education_r ="small cities" /// 
			4.city_size#c.education_r="medium cities" 6.city_size#c.education_r= "large cities" ///
			8.city_size#c.education_r= "Paris region") ///
		yline(0) /// 
		vertical /// 
		legend(pos(11) ring(0) /// 
			col(2) /// 
			size(small) /// 
			symxsize(5) symysize(1) /// 
			order(2 "Average" 4 "1996-2002" 6 "2006-2013") /// 
			region(lcolor(blue))) /// 
		graphregion(color(white)) plotregion(lcolor(black) lwidth(medthin)) 
	
	graph export "mating_by_education.png", as(png) replace
	

	* Now do the regressions of question e)
	
	* Finally plot the coefplot for question f). The code is almost the same as above. 

	* Hint : to select all interaction terms between years and active_r use *.year#c.active_r. Don't forget the base level also !
	
	

