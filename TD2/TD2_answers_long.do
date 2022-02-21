/* ols monte carlo

Written June 2017.  GMB.
*/



clear all
set matsize 11000 // necessary for Q4



*Q1 - Generate Raw data for a single replication
	
	clear all

		*first case
			
			set seed 1982
			local obs = 100
			local beta = 2
			local alpha = 10
			set obs `obs'

			gen y=. // this step not necessary can also directy generate the data
			gen x=.
			gen eps=.

			replace x = 10*runiform()
			replace eps = 5*rnormal(0,1)
			replace y=`alpha'+(`beta'*x)+eps

		*export descriptive statistics
			
			sutex y x eps, lab nobs key(descstat1) replace ///
			file(descstat1.tex) title("Summary statistics 1") minmax

		*generate scatter of y on x
			
			twoway (scatter y x, msize(small)), legend(off) ///
			ylabel(0(5)40) xtitle("Education") ytitle("Income") saving("g1.gph", replace) 

			graph export "datascatter1.pdf", replace



*Q2 - Run OLS for a single replication
	
	clear all

		*first case
			
			set seed 1982
			local obs = 100
			local beta = 2
			local alpha = 10
			set obs `obs'

			gen y=.
			gen x=.
			gen eps=.

			replace x = 10*runiform()
			replace eps = 5*rnormal(0,1)
			replace y=`alpha'+(`beta'*x)+eps
			
	*Run OLS
		
		reg y x
		
		*help format display
		
		scalar bhat=round(_b[x],.01)
		local bhat: di %6.2f scalar(bhat)
			
		scalar ahat=round(_b[_cons],.01)
		local ahat: di %6.2f scalar(ahat)
			
		predict yhat, xb

		twoway (scatter y x, msize(small)) (line yhat x, ///
		text(5 8 "beta_hat=`bhat'" "alpha_hat=`ahat'")), ///
			legend(off) ylabel(0(5)40) xtitle("Education") ytitle("Income") ///
			saving("g1.gph", replace) 

		graph export "ols_1rep.pdf", replace
		
		erase "g1.gph"



*Q3 - For two replications, generate data. run OLS, make figure and put side by side
	
	
	clear all
	set seed 1982
		
		*Generate data
			
			local obs = 100
			local beta = 2
			local alpha = 10
			
			set obs `obs'
			
			gen y_1=.
			gen x_1=.
			gen eps_1=.
			
			gen y_2=.
			gen x_2=.
			gen eps_2=.
			
				
		*Genreate data
			
		foreach rep in 1 2 {
			replace x_`rep' = 10*runiform()
			replace eps_`rep' = 5*rnormal(0,1)
			replace y_`rep'=`alpha'+(`beta'*x_`rep')+eps_`rep'
		
			}
		
		*Run OLS
		
		forvalues rep=1/2 {
		
			reg y_`rep' x_`rep' 
			
			
			scalar bhat=round(_b[x_`rep'],.01)
			local bhat: di %6.2f scalar(bhat)
			
			scalar ahat=round(_b[_cons],.01)
			local ahat: di %6.2f scalar(ahat)
	
			predict yhat_`rep', xb

			twoway (scatter y_`rep' x_`rep', msize(small)) (line yhat_`rep' x_`rep', ///
				text(5 8 "beta_hat=`bhat'" "alpha_hat=`ahat'")), ///
				legend(off) ylabel(0(5)40) xtitle("Education") ytitle("Income") ///
				saving("g`rep'.gph", replace) 

			}
		
		*Combine Graphs

			gr combine "g1.gph" "g2.gph", col(2)
			graph export "ols_2reps.pdf", replace
			
			erase "g1.gph"
			erase "g2.gph"


			
			


*Q4 - For 1000 replications, generate data. run OLS, Plot Betas


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



