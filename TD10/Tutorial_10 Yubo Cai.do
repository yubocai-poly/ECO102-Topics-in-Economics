* Yubo Cai
* 20/04/2022
* ECO102 TD10

 clear all
 
 
* Exercise 2.a

	cd "/Users/yubocai/Desktop/Ecole Polytechnique/Semester 2/ECO102/TD10"
	use "LA2010_Blocks_forTD.dta", clear
	

* Exercise 2.b

	rename pop pop_block
	keep if pop_block > 0
	
* Exercise 2.c

	egen tot_pop = sum(pop_block)
	egen pop_tract = sum(pop_block), by(tract_ID)
	
	
