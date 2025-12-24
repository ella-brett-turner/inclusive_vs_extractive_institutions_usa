/***********************************************************************

Name: Ella Brett-Turner
Date: Nov. 7, 2025
Title: Assignment 1 WBES
Class: ECON 634

***********************************************************************/

clear
cap cd"/Users/matthieuchemin/Library/CloudStorage/Dropbox/teaching/ECON634/Data/WBES"

cap cd"C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Data\WBES\USA"

use "New_Comprehensive_October_6_2025.dta"

*Create treatment group
gen Treatment=1 if country=="United States2024"

/*


                        Economy |      Freq.     Percent        Cum.
--------------------------------+-----------------------------------
              United States2024 |      2,697      100.00      100.00
--------------------------------+-----------------------------------
                          Total |      2,697      100.00


*/

*Create control group	
foreach c in "Albania2007" "Albania2013" "Albania2019" "Argentina2006" "Argentina2010" "Argentina2017" ///
"Armenia2009" "Armenia2013" "Armenia2020" "Armenia2024" "Azerbaijan2009" "Azerbaijan2013" "Azerbaijan2019" "Azerbaijan2024" ///
"Bangladesh2007" "Bangladesh2013" "Bangladesh2022" "Bulgaria2007" "Bulgaria2009" "Bulgaria2013" "Bulgaria2019" "Bulgaria2023" ///
"Bosnia and Herzegovina2009" "Bosnia and Herzegovina2013" "Bosnia and Herzegovina2019" "Bosnia and Herzegovina2023" ///
"Belarus2008" "Belarus2013" "Belarus2018" "Bolivia2006" "Bolivia2010" "Bolivia2017" "Brazil2009" "Canada2024" ///
"Chile2006" "Chile2010" "China2012" "China2024" "Colombia2006" "Colombia2010" "Colombia2017" "Colombia2023" ///
"Cyprus2019" "Cyprus2024" "Czechia2009" "Czechia2013" "Czechia2019" "Czechia2024" ///
"Ecuador2006" "Ecuador2010" "Ecuador2017" "Ecuador2024" "Egypt2013" "Egypt2016" "Egypt2020" ///
"Estonia2009" "Estonia2013" "Estonia2019" "Estonia2023" "Ethiopia2011" "Ethiopia2015" "Finland2020" "France2021" ///
"United Kingdom2024" "Georgia2008" "Georgia2013" "Georgia2019" "Georgia2023" ///
"Ghana2007" "Ghana2013" "Ghana2023" "Greece2018" "Greece2023" "Guatemala2006" "Guatemala2010" "Guatemala2017" ///
"Hong Kong SAR China2023" "Croatia2007" "Croatia2013" "Croatia2019" "Croatia2023" ///
"Hungary2009" "Hungary2013" "Hungary2019" "Hungary2023" "Indonesia2009" "Indonesia2015" "Indonesia2023" ///
"India2014" "India2022" "Iraq2011" "Iraq2022" "Israel2013" "Israel2024" "Italy2019" "Italy2024" ///
"Jordan2013" "Jordan2019" "Jordan2024" "Kazakhstan2009" "Kazakhstan2013" "Kazakhstan2019" "Kazakhstan2024" ///
"Kenya2007" "Kenya2013" "Kenya2018" "Kyrgyz Republic2009" "Kyrgyz Republic2013" "Kyrgyz Republic2019" "Kyrgyz Republic2023" ///
"Korea Republic2024" "Lebanon2013" "Lebanon2019" "Lithuania2009" "Lithuania2013" "Lithuania2019" "Latvia2009" ///
"Latvia2013" "Latvia2019" "Latvia2024" "Morocco2013" "Morocco2019" "Morocco2023" "Moldova2009" "Moldova2013" "Moldova2019" ///
"Moldova2024" "Mexico2006" "Mexico2010" "Mexico2023" "North Macedonia2009" "North Macedonia2013" "North Macedonia2019" ///
"North Macedonia2023" "Mali2007" "Mali2010" "Mali2016" "Mali2024" "Myanmar2014" "Myanmar2016" "Montenegro2009" ///
"Montenegro2013" "Montenegro2019" "Montenegro2023" "Mongolia2009" "Mongolia2013" "Mongolia2019" "Malaysia2015" ///
"Malaysia2019" "Malaysia2024" "Nigeria2007" "Nigeria2014" "Nigeria2025" "Nicaragua2006" "Nicaragua2010" "Nicaragua2016" ///
"Netherlands2020" "Pakistan2007" "Pakistan2013" "Pakistan2022" "Peru2006" "Peru2010" "Peru2017" "Peru2023" ///
"Philippines2009" "Philippines2015" "Philippines2023" "Poland2009" "Poland2013" "Poland2019" "Poland2025" ///
"Romania2009" "Romania2013" "Romania2019" "Romania2023" "Russia2009" "Russia2012" "Russia2019" "Rwanda2006" ///
"Rwanda2011" "Rwanda2019" "Rwanda2023" "Saudi Arabia2022" "Singapore2023" "ElSalvador2006" "ElSalvador2010" ///
"ElSalvador2016" "ElSalvador2023" "Serbia2009" "Serbia2013" "Serbia2019" "Serbia2024" ///
"Slovak Republic2009" "Slovak Republic2013" "Slovak Republic2019" "Slovak Republic2023" "Slovenia2009" "Slovenia2013" ///
"Slovenia2019" "Slovenia2024" "Sweden2014" "Sweden2020" "Sweden2024" "Thailand2016" "Tajikistan2008" "Tajikistan2013" ///
"Tajikistan2019" "Tajikistan2024" "Trinidad and Tobago2010" "Trinidad and Tobago2025" "Tunisia2013" "Tunisia2020" ///
"Tunisia2024" "Turkiye2008" "Turkiye2013" "Turkiye2019" "Turkiye2024" "Taiwan China2024" "Tanzania2006" "Tanzania2013" ///
"Tanzania2023" "Uganda2006" "Uganda2013" "Ukraine2008" "Ukraine2013" "Ukraine2019" "Uruguay2006" "Uruguay2010" ///
"Uruguay2017" "Uruguay2024" "Uzbekistan2008" "Uzbekistan2013" "Uzbekistan2019" "Uzbekistan2024" ///
"Venezuela2006" "Venezuela2010" "Viet Nam2009" "Viet Nam2015" "Viet Nam2023" "Yemen2010" "Yemen2013" "SouthAfrica2007" ///
"SouthAfrica2020" "Zambia2007" "Zambia2013" "Zambia2019" "Zimbabwe2011" "Zimbabwe2016" {
    replace Treatment = 0 if country == "`c'"
}

***PART 1: Recoding variables***

/*k17: What was the main reason why this establishment did not apply for any line of credit or loan? 

1 No need for a loan - establishment had enough capital

2 Application procedures were complex

3 Interest rates were not favorable

4 Collateral requirements were too high

5 Size of loan and maturity were insufficient

6 Did not think it would be approved
*/

*Will code as indicator: 0 = needed loan, did not apply; 100 = did not need loan
gen new_biz = 0 if k17 == 2 | k17 == 3 | k17 == 4 | k17 == 5 | k17 == 6
replace new_biz = 100 if k17 == 1

/*k20: Referring only to the most recent application for a line of credit or loan, what was the outcome of that application?

1 Application was approved in full

2 Application was approved in part

3 Application was rejected

4 Application was withdrawn

-6 APPLICATION STILL IN PROCESS

-9 DON'T KNOW (SPONTANEOUS)

*/
gen credit_access =100 if k20 == 1
replace credit_access = 50 ==2
*Withdrawn and rejection deserve a similar valuation
replace credit_access = 0 if k20 == 3 | k20 == 4

*NOTE: credit_access had too many missing entries so I chose not to use it.

*Copy/paste to excel tables
sum new_biz if Treatment==1
sum new_biz if Treatment==0

sum credit_access if Treatment==1
sum credit_access if Treatment==0

*Save updated data in a different location to preserve original.
save "C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Data\WBES\Data WBES Clean.dta", replace