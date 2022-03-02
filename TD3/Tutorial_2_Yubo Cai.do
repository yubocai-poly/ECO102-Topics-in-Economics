* Yubo Cai
* 2/03/2022
* ECO102 TD3

clear all



* Exercise 1

	/* File - import - excel spreadsheet - set the import first row as variable names*/

	

	import excel "/Users/apple/Desktop/Ecole Polytechnique/Semester 2/ECO102/TD3/TD3 folder/MRW_QJE1992.xlsx", sheet("Table 3") firstrow


	
	destring GDPperadult1985, replace
	drop if Number==.
	
	
* Exercise 2 - Export Desctiptive Staistics

	* 对于 sample (non-oil, intermediate, OECD) 分别进行分析，用loop-foreach以及sutex来分析)
	foreach x in N I O {
		sutex GDPperadult1960 GDPperadult1985 GrowthinGDP PopGrpwth IY School if Sample`x' == 1, minmax 
		} 
	* minmax找到各个变量的最小值和最大值
		
		
		
* Exercise 3 - Scatter Growth agsint 1960 levels
		
	gen lnGPD1960 = ln(GDPperadult1960)
	
	twoway scatter GrowthinGDP lnGPD1960 if SampleI == 1 ///
		,legend(off) xlabel(5.5(1)10.5) ylabel(-2(2)10) ///
		xtitle("Log output per working age adult: 1960") ///
		ytitle("Growth rate: 1960 - 85") ///
	
	* 重新绘制一下图标的比如x轴y轴等
	* 图表和数据基本拟合，但是还包括有些数据paper提供我们的没办法完全拟合
	
	
	
* Exercise 4 - Estimate The Textbook model

	* First step: create variables
	
	gen ln_save = ln(IY)
	* 下面是 (n+g+δ)cis the log of population growth rate +productivity growth rate + depreciation 数据的generate
	gen ln_ngd = ln(5+PopGrpwth)
	gen ln_GDP1985 = ln(GDPperadult1985)
	gen ln_school = ln(School)
	
	
	
	* Second step: run the OLS on subsamples
	
	. ssc install estout, replace
	
	foreach x in N I O {
		reg ln_GDP1985 ln_save ln_ngd if Sample`x'==1
			estadd ysumm
			estimates store ols`x'
			}
			
		
	* Third step: establish the table
	
	esttab olsN olsI olsO using "${main}regs.tex", ///
			replace b(%10.2f) se scalars("N \# Observations" "r2 R squared" "ymean Mean Dep. Var") ///
			sfmt(%10.0f %10.3f %10.3f) ///
			star(* 0.10 ** 0.05 *** 0.01) noobs ///
			order(_cons ln_I/GDP lnsave ln_ngd)  ///
			coeflabels(_cons "Constant" lnsave "ln(I/GDP)" ln_ngd "ln(n + g + $\delta$)" ) ///
			label nonotes 
			
	* Fourth Step: Check the correlation of the omitted varibale
	
	foreach x in N I O {
		
			reg  ln_save ln_school if Sample`x'==1
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

		

	
	
