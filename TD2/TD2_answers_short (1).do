/* 
16/02/2022
Arnault Chatelain 

Courtesy of Romain Puech for sharing his dofile with me to get you a minimal working example of a working do file 
for TD2.

*/ 

* Q1a
set seed 2 // command used to get the same random numbers everytime we run the dofile

* Q1b
set obs 100
gen e = rnormal(0,5)
gen x = runiform(0,10)
gen y=10+2*x+e

* Q1c
* ssc install sutex // only need to be typed once, afterwards sutex is already installed
sutex x y e, minmax

*Q1d
scatter y x // Don't hesitate to add graph title, axis title, etc.
	* Then save the obtained graph as a pdf or png (the floppy disk symbol at the top right of the graph)
	* Import it in Overleaf using the import button (Third button on the top of the left panel)
	* Look on the internet how to add images to a Latex document and add the graph to your latex file (Hint: you can use a figure environment)

*Q2
regress y x 
graph twoway (scatter y x) (lfit y x), note(alpha= 12.15041 beta=1.679607)
	* We don't get bhat = 2 because of the error term

	
*Q3

* Try to understand how the loop works here and how locals are used inside the loop


clear all // I restart everything to introduce you to forloops

set obs 100
set seed 2

forvalues rep = 1/2 { // notice that rep is a local 
	generate x_`rep' = 10*runiform()
	generate eps_`rep' = 5*rnormal(0,1)
	generate y_`rep'=10+(2*x_`rep')+eps_`rep'
	
	quietly reg y_`rep' x_`rep' // quietly so that it won't print the regression results
	
	local bhat = _b[x_`rep'] // the = is necessary so that Stata evaluates (that is get the content of) of _b[x_`rep']
	local ahat = _b[_cons] // In both lines basically we store the regression coefficients in a local to use it in the note section of our graph 
	
	twoway (scatter y_`rep' x_`rep', msize(small)) (lfit y_`rep' x_`rep'), ///
				legend(off) ylabel(0(5)40) xtitle("Education") ytitle("Income") ///
				note("alpha = `ahat', beta = `bhat'") ///
				name(g`rep', replace) // name is an alternative to save, it keeps the graphs as temporary files in memory
				/// see https://www.statalist.org/forums/forum/general-stata-discussion/general/1618894-graph-save-error

			}

gr combine g1 g2, col(2) // combine the graphs in one
graph export "ols_2reps.pdf", replace // another way to save it as a pdf


