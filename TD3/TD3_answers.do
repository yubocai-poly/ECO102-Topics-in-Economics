/* 

TD3:
Author: Geoffrey Barrows
Date: Feb 1, 2022


*/



clear all
set matsize 11000

global main "~/Dropbox/Courses/TopicsCourse/2022/TD3/"

	
	import excel "${main}/MRW_QJE1992.xlsx", ///
		sheet("Table 3") firstrow clear


	
	destring GDPperadult1985, replace
	drop if Number==.
	
	
	
*Q2 - Export Desctiptive Staistics
	
		
		foreach x in N I O {
		
			sutex GDPperadult1960 GDPperadult1985 GrowthinGDP PopGrpwth IY School if Sample`x'==1, ///
				lab nobs key(descstat1) replace ///
				file("${main}/descstat`x'.tex") title("Summary statistics `x'") minmax
			
				}
			

*Q3 - Scatter Growth agsint 1960 levels
	
		gen lnGDP60=ln(GDPperadult1960)
		
		twoway scatter GrowthinGDP lnGDP60 if SampleI==1 ///
			,legend(off) xlabel(5.5(1)10.5) ylabel(-2(2)10) ///
			xtitle("Log output per working age adult: 1960") ///
			ytitle("Growth rate: 1960 - 85") ///
			saving("${main}g1.gph", replace) 
	

		graph export "${main}scatter1.pdf", replace
		
		erase "${main}g1.gph"


			

*Q4 - Estimate The Textbook model

	*Build Regression terms
		
		gen lnsave=ln(IY)
		gen ln_ngd=ln(5+PopGrpwth)
		gen lnGDP85=ln(GDPperadult1985)
		gen lnschool=ln(School)
	
		foreach x in N I O {
		
			reg lnGDP85 lnsave ln_ngd if Sample`x'==1
				estadd ysumm
				estimates store ols`x'
				
				}

		esttab olsN olsI olsO using "${main}regs.tex", ///
			replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
			sfmt(%10.0f %10.3f %10.3f) ///
			star(* 0.10 ** 0.05 *** 0.01) noobs ///
			order(_cons lnsave ln_ngd)  ///
			coeflabels(_cons "Constant" lnsave "ln(I/GDP)" ln_ngd "ln(n + g + $\delta$)"  ) ///
			label nonotes 

	

*Q4 - Check the correlation of the omitted varibale

		
		foreach x in N I O {
		
			reg  lnsave lnschool if Sample`x'==1
				estadd ysumm
				estimates store ols`x'
				
				}
				
			esttab olsN olsI olsO using "${main}regs2.tex", ///
			replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
			sfmt(%10.0f %10.3f %10.3f) ///
			star(* 0.10 ** 0.05 *** 0.01) noobs ///
			order(_cons lnschool)  ///
			coeflabels(_cons "Constant" lnschool "ln(school)"  ) ///
			label nonotes 
	
		
		

*Q5 - estimate the Full Model
			
		
		foreach x in N I O {
		
			reg  lnGDP85 lnsave ln_ngd lnschool if Sample`x'==1
				estadd ysumm
				estimates store ols`x'
				
				}
				
		esttab olsN olsI olsO using "${main}regs3.tex", ///
			replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
			sfmt(%10.0f %10.3f %10.3f) ///
			star(* 0.10 ** 0.05 *** 0.01) noobs ///
			order(_cons lnsave ln_ngd lnschool)  ///
			coeflabels(_cons "Constant" lnsave "ln(I/GDP)" ln_ngd "ln(n + g + $\delta$)"  lnschool "ln(school)" ) ///
			label nonotes 

		
	


*Q6 - Find a new variable.  Merge in.  Add to regression Table
	
	
	
	
	
	
	
