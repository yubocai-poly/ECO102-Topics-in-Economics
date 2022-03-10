* Yubo Cai
* 09/03/2022
* ECO102 TD4

clear all



* Exercise 1

*A refresher on IVs:
	* What is an Instrumental Variable? Why do we use them?
		* See course. It is a variable used to correct endogeneity issues with one of the explanatory variable. We use them to get correct estimates when we have an endogeneity issue. 
		
	* In the case of \citet{acemoglu2001colonial}, can you recall what they study, what variable they use as an IV and why? 
		* They try to assess causaly how institutions can affect economic performance. They use log gdp per capita PPP as a dependent variable and 
		* approximate the effect of institutions using Expropriation Risk. They focus on former European colonies (broadly conceived)and use the settlers 
		* mortality rate as an IV for today's expropriation risk. ."
	* What are the two conditions that should be met when using an IV? 
		* Strong correlation with the endogenous explanatory variable.
		* Exclusion restriction: the instrument is not correlated with the error term of the explanatory equation controling on other covariates. 
		* This implies in particular that there is no omitted variable that is both correlated with the instrument and the dependent variable (see graph on board during the TD)
		* AND that the instrument has no direct effect on the dependent variable (the only effect it has is through the explanatory variable which is instrumented). 

		* If the model is y =a+bx+e and z is the instrument, the two conditions can be rewritten: 
		* cov(z,x) != 0
		* cov(z,u) == 0


* Exercise 2

	use "/Users/apple/Downloads/ajrcomment.dta"
	
	generate GDP1995 = exp(loggdp)
	
	twoway scatter mort GDP1995
	twoway scatter logmort0 loggdp
	
	/* We can tell directly from the graph that the two variable have correlation
	also we have some outliner that much higher than others which we would better to
	take log to collect and centralize the data */
	
	* Go to Moodle and download the dataset ajrcomment.dta. Let us start with a short comment on the use of log in economics. 
	* In both papers the authors use log GDP per capita in 1995. Create a variable gdp that contains the GDP per capita in 1995. (We are referring to the natural logarithm here). 

    * Create a scatter plot of mortality rates (y-axis) against GDP per capita in 1995 (x-axis). Do the same with log mortality rate and log GDP. Compare the two. What do you observe? 
		* Due to outliers the table without log values stacked in one corner of the graph.
		* What is the benefit of using log values in tables? 
		* With log the growth is multiplicative not additive. This makes tables containing variables with a large range of values much more readable. This is 
		* especially useful when the variable grows exponentially (e.g. gdp growth). 

		
* Exercise 3

	 /* 
	 1st stage: exp risk = a + b log.mortality rate + c latitude + u
	 2nd stage: log GDP = alpha + beta exp.risk hat + gama latitude + epsilon
	 */
	 
	 reg risk logmort0 latitude
	 predict riskhat
	 
	 reg loggdp riskhat latitude
	 
	 ivregress 2sls loggdp latitude (risk=logmort0), first
		
	
* Exercise 4

	/* 
	measurement error
	*/
	
	reg risk logmort0 latitude, robust cluster(logmort0)


* Exercise 5

	drop if source0==0
	ivregress 2sls loggdp campaign slave asia africa other (risk=logmort0), cluster(logmort0) first
	
	8.94/10.22
	
	
