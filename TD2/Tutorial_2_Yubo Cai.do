* Yubo Cai
* 16/02/2021
* ECO102 TD2

clear all

* Exercise 1.1.a
set seed 2000

* Exercise 1.1.b
set obs 100
gen x = runiform(0,10)
gen epsilon = rnormal(0,5)

* Exercise 1.1.c
gen y = 10 + 2*x + epsilon

* Exercise 1.1.d
ssc install sutex
sutex y x epsilon, minmax

* Exercise 1.1.e
twoway scatter y x

* Exercise 1.2
reg y x
graph twoway (lfit y x) (scatter y x), note(alpha= 8.755807 beta=2.147404)

* Exercise 1.3
clear all // I restart everything to introduce you to forloops

set obs 100
set seed 2

forvalues rep = 1/2 { 
	generate x_`rep' = runiform(0,10)
	generate eps_`rep' = rnormal(0,5)
	generate y_`rep'=10+(2*x_`rep')+eps_`rep'
	
    reg y_`rep' x_`rep' 
	
	local bhat = _b[x_`rep'] // the = is necessary so that Stata evaluates (that is get the content of) of _b[x_`rep']
	local ahat = _b[_cons] // In both lines basically we store the regression coefficients in a local to use it in the note section of our graph 
	//这里的代码是什么意思//
	
	twoway (scatter y_`rep' x_`rep', msize(small)) (lfit y_`rep' x_`rep'), ///
				legend(off) ylabel(0(5)40) xtitle("Education") ytitle("Income") ///
				note("alpha = `ahat', beta = `bhat'") ///
				name(g`rep', replace)
				// name is an alternative to save, it keeps the graphs as temporary files in memory
				/// see https://www.statalist.org/forums/forum/general-stata-discussion/general/1618894-graph-save-error

			}

gr combine g1 g2, col(2) // combine the graphs in one
graph export "Graph3.pdf", replace // another way to save it as a pdf

* Exercise 1.4.1
clear all
set seed 1982
	
	*Set Locals
	
		local obs = 100
		local beta = 2
		local alpha = 10

		*set replications
	
		*help J()
		
		local replications = 1000
		matrix mat1 = J(`replications',5,.)
	
		
		forvalues i = 1/`replications'  {
	
		*Generate Data
		
			set obs `obs'

			gen y=.
			gen x=.
			gen eps=.

			replace x = 10*runiform()
			replace eps = 5*rnormal(0,1)
			replace y=`alpha'+(`beta'*x)+eps


		*ols
			
			reg y x
			mat mat1[`i',1]=_b[x]
			mat mat1[`i',2]=_se[x]
			
		*95%CI
			
			gen bhat=_b[x]
			gen se=_se[x]
			gen lowci=bhat-1.964*se
			gen highci=bhat+1.964*se
			gen cover=(lowci<`beta' & highci>`beta')
			scalar lci = lowci
			scalar hci = highci
			scalar cov = cover
			mat mat1[`i',3]=cov
			mat mat1[`i',4]=lci
			mat mat1[`i',5]=hci
		
	
	*Close loop
		drop y x eps bhat se lowci highci cover
		}

	
	*Generate dataset with regression coefficeints
		
		svmat double mat1, name(bvector)
		rename bvector1 betahat
		rename bvector2 sehat
		rename bvector3 cover
		rename bvector4 lci
		rename bvector5 hci

		egen meanb = mean(betahat)
		egen p50 = pctile(betahat), p(50)
		egen p2p5 = pctile(betahat), p(2.5)
		egen p97p5 = pctile(betahat), p(97.5)

		local p50 = p50
		local p2p5 = p2p5
		local p97p5 = p97p5

		scalar p50=round(`p50',.0001) // additional step for formatting display
		scalar meanb=round(meanb,0.0001)
		
		local p50: di %6.4f scalar(p50)
		local meanb: di %6.4f scalar(meanb)
			
			
	*Graph ditribution of regression coefficeints
	
	
		twoway (kdensity  betahat, lcolor(gs2)), ///
			xline(`p50', lcolor(gs10)) xline(`p2p5', lcolor(gs10) lpattern(-) ) ///
			xline(`p97p5', lcolor(gs10) lpattern(-) ) ///
			subtitle("median=`p50'" "mean=`meanb'", position(6)) ///
			ytitle("Density") xtitle("Beta Hat") xlabel(1.5(.1)2.6 , angle(45) )

		graph export "olshats.pdf", replace

* Exercise 1.4.2

	*LCI vs HCI
		
		egen t1 = sum(cover)
		gen double meancover=t1/1000
		scalar meanc=round(meancover,0.001)
		
		local meanc: di %6.4f scalar(meanc)

		
			twoway (kdensity  lci, lcolor(gs2) lpattern(-)) ///
				(kdensity  hci, lcolor(gs2) lpattern()), ///
				xline(2) ytitle("Density") xtitle("") xlabel(1(.5)3 , angle(45) ) ///
				subtitle("cover=`meanc'", position(6)) ///
				legend(order(1 "95 CI Lower Bound" 2 "95 CI Upper Bound"))

			graph export "lci_hci.pdf", replace
