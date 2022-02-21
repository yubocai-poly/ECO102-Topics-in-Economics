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
