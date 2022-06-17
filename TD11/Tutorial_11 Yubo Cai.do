* Yubo Cai
* 20/04/2022
* ECO102 TD10

 clear all
 
 
* Exercise 2.a

	cd "/Users/yubocai/Desktop/Ecole Polytechnique/Semester 2/ECO102/TD11"
	use "data_couples.dta", clear
	
* Exercise 2.b

	label define city_size_label 0 "rural" 1 "small cities" 4 "medium cities" 6 "large cities" 8 "paris region"
	label values city_size city_size_label
 	
	est clear // clear the est locals
	estpost tabstat education_r education_p age_r age_p, by(city_size) c(stat) stat(mean sd min max n)
	esttab using "./educ_sum.tex", replace ///
	cells("mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber ///
	nomtitle nonote noobs label collabels("Mean" "SD" "Min" "Max" "N")
	
* Exercise 2.c

	/* parter education = \alpha + \gama0 * resp education + \gama1 * rural + \gama2 * small + \gama3 * medium + \gama4 * large + \gama5 * large
								    \beta2 * age respondent + 
									\beta3 * active + 
									\beta4 * 2002 +
									\beta5 * 2006 +
									\beta6 * 2013 + 
	
