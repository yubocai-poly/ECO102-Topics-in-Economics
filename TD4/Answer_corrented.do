/* 
ECO102: Topics in Economics
Ecole Polytechnique, Spring 2022

TD4: Instrumental Variables

*/

********************************************************************************
* Exercise 
 
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

* Go to Moodle and download the dataset ajrcomment.dta. Let us start with a short comment on the use of log in economics. 
	* In both papers the authors use log GDP per capita in 1995. Create a variable gdp that contains the GDP per capita in 1995. (We are referring to the natural logarithm here). 
		generate gdp = exp(loggdp)
    * Create a scatter plot of mortality rates (y-axis) against GDP per capita in 1995 (x-axis). Do the same with log mortality rate and log GDP. Compare the two. What do you observe? 
		twoway scatter mort gdp
		twoway scatter logmort0 loggdp
		* Due to outliers the table without log values stacked in one corner of the graph.
	* What is the benefit of using log values in tables? 
		* With log the growth is multiplicative not additive. This makes tables containing variables with a large range of values much more readable. This is 
		* especially useful when the variable grows exponentially (e.g. gdp growth). 

* Exercise 3
		
* Let us now reproduce the results of \citet{acemoglu2001colonial}.
	* Write down the two equations you will use in your 2 Stage Least Square (2SLS) regression (include a single control for Latitude).
		* First stage: risk = B0 + B1*logmort0 + B2*Latitude + error1
		* Second stage: loggdp = A0 + A1*riskHat + A2*Latitude + error2, riskHat being the predicted value of risk derived from the first stage.
	* Run the first stage equation. Does the instrument seem valid?
		reg risk logmort0 latitude
		* Yes the p-value is below 1%.
	* Using the command \textbf{predict}, generate a variable riskhat containing the fitted values of this first stage.
		predict riskHat 
	* Run the second stage regression. Comment on the results. Are the standard errors correct here? 
		reg loggdp riskHat latitude
		* Not the SE are wrong because they don't take into account that riskHat is a predicted value.
    * Run the IV regression using the \textbf{ivregress} command this time. Compare with your previous results. 
        ivregress 2sls loggdp latitude (risk = logmort0), first 
		* Same point estimates but with correct SE this time.
		
* We can now turn to \citet{albouy2012colonial}'s critic. Albouy's first critic concerns \citet{acemoglu2001colonial}' standard errors.
	* Albouy notices that our authors make conjectures about mortality rates for some countries. Notably, using mortality rate for some countries they extrapolate the mortality rate of neighbouring countries - in fact they even reuse the same rates sometimes. This violates one of the basic assumptions of OLS regression. Which one?   
        * This violates the iid assumption since several countries are not independent anymore.
	* To make up for this, it is possible to cluster data, that is to consider that different groups of data (say continents) are independent but the observations composing them (countries here) are not. Albouy also suggest to run an regression robust to heteroskedasticity. Do you know what this is? Can you give an example of what it corresponds to? 
        * Heteroskedasticity is when the variance of the error term varies between observations (this is common).
		* An example: The variance of wage for a given education level is higher for higher levels of education than for lower levels. 
	* Rerun the first stage equation with standard errors (SE) that are robust (\textit{i.e.} allowing for heteroskedasticity) and clustered at the mortality rate level. How does it change?
		reg risk logmort0 latitude, robust cluster(logmort0)

* Albouy's second critic concern the validity of the data for some countries. Not only is the data for some countries simply extrapolated from neighbouring countries but also all data sources are not comparable, some rates concerning soldiers living in barracks, some concerning soldiers during campaign and some concerning forced labor. 
	* Retaining only countries for which the mortality rate is not extrapolated and including dummies for data sources (campaign and slave variables) and for continents rerun a 2SLS regression. Comment on the first stage. What value do you find for the expropriation risk coefficient? 
		drop if source0 == 0
		ivregress 2sls loggdp latitude campaign slave asia africa other (risk = logmort0), cluster(logmort0) first
		
	* Compute the GDP ratio of Mexico on the US. Now using the previous coefficient what would be the new value of this ratio were Mexico to have the same property right  as the US? 
		* The coefficient for expropriation risk is 1.44
		* Difference between expropriation risk is 2.5. So this implies an increase of log GDP of 2.5*1.44=3.6 for Mexico. 
		* Current ratio is exp(log(Mexico) - log(US))= 0.28
		* New ratio is exp(log(Mexico)+3.6 - log(US)= 10.18
		* This would mean that Mexico GDP would be 10 times that of the US. 
