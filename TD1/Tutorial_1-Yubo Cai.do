* Yubo Cai
* 09/02/2021
* ECO102 TD1

* Exercise 1

clear all
sysuse auto
describe
summarize

// EX1 Q1
sum price, d
/* mean price = 6165.257 
   median value =  5006.5 */

// EX1 Q2
codebook 
/* unique value for mileage: 21 */

// EX1 Q3
list if missing(rep78)
/* AMC Spirit / Buick Opel / Plym. Sapporo / Pont. Phoenix / Peugeot 604 */
/*
+-------------------------------------------------------------------------------------------------------------------+
     | make             price   mpg   rep78   headroom   trunk   weight   length   turn   displa~t   gear_r~o    foreign |
     |-------------------------------------------------------------------------------------------------------------------|
  3. | AMC Spirit       3,799    22       .        3.0      12    2,640      168     35        121       3.08   Domestic |
  7. | Buick Opel       4,453    26       .        3.0      10    2,230      170     34        304       2.87   Domestic |
 45. | Plym. Sapporo    6,486    26       .        1.5       8    2,520      182     38        119       3.54   Domestic |
 51. | Pont. Phoenix    4,424    19       .        3.5      13    3,420      203     43        231       3.08   Domestic |
 64. | Peugeot 604     12,990    14       .        3.5      14    3,420      192     38        163       3.58    Foreign |
     +-------------------------------------------------------------------------------------------------------------------+
*/

// EX1 Q4
list make price if (weight < 1800 | weight > 4300)
/* Cad. Deville / Linc. Continental / Linc. Mark V / Honda Civic */
/*
 | make                 price |
     |----------------------------|
 11. | Cad. Deville        11,385 |
 26. | Linc. Continental   11,497 |
 27. | Linc. Mark V        13,594 |
 62. | Honda Civic          4,499 |
     +----------------------------+
*/

// EX1 Q5
tabulate foreign
/* foreign percentage = 29.73% */

list make if (foreign & rep78 == 3)
/* there are 3 cars have a repair record of 3 */

// EX1 Q6
by foreign: sum mpg 
/* for foreign cars the mean value of mileage is 24.77273
   for domestic cars the mean value of mileage is 19.82692 */
   
 
// EX1 Q7
cor mpg price
/* correlation coefficient =  -0.4686 */

// EX1 Q8
twoway scatter mpg price 
/* I put the graph on the moodle */

// EX1 Q9
twoway scatter mpg weight, by(foreign)
/* I put the graph on the moodle */

* Exercise 2

// EX2 Q1
clear all
sysuse auto
gen expensive = 1 if price > 7000
replace expensive = 0 if price <= 7000
/*
. sysuse auto
(1978 Automobile Data)

. gen expensive = 1 if price > 7000
(58 missing values generated)

. replace expensive = 0 if price <= 7000
(58 real changes made)
*/

// EX2 Q2
label var expensive "Can I buy this car?"
label define explabel 1 "Too expensive" 0 "Yes"
label values expensive explabel

// EX2 Q3
drop if expensive == 1
generate size = 0 if length < 160
replace size = 1 if length >= 160 & length < 200
replace size = 2 if length >=200

label define sizelabel 0 "short" 1 "medium" 2 "Long"
label values size sizelabel
/*
. drop if expensive == 1
(16 observations deleted)

. generate size = 0 if length < 160
(50 missing values generated)

. replace size = 1 if length >= 160 & length < 200
(33 real changes made)

. replace size = 2 if length >=200
(17 real changes made)
*/
