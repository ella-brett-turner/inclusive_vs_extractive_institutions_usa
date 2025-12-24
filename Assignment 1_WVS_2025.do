/*******************************************************************************

Name: Ella Brett-Turner
Date: Nov. 7, 2025
Title: Assignment 1 WVS
Class: ECON 634

*******************************************************************************/

clear

*Import WVS data

cap cd "C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Data\World Values Survey Longitudinal"

cap cd "/Users/matthieuchemin/Library/CloudStorage/Dropbox/teaching/ECON634/Data/WVS"

use "WVS_Time_Series_1981-2022_stata_v5_0.dta"

*Generate Treatment and Control groups.
generate Treatment=1 if COUNTRY_ALPHA=="USA"

*Control group: only using countries which appear in both WVS and WBES datasets
foreach c in "ALB" "ARG" "ARM" "AZE" "BGD" "BGR" "BIH" "BLR" "BOL" "BRA" "CAN" "CHL" "CHN" "COL" "CYP" "CZE" "ECU" "EGY" "EST" "ETH" "FIN" "FRA" "GBR" "GEO" "GHA" "GRC" "GTM" "HKG" "HRV" "HUN" "IDN" "IND" "IRQ" "ISR" "ITA" "JOR" "KAZ" "KEN" "KGZ" "KOR" "LBN" "LTU" "LVA" "MAR" "MDA" "MEX" "MKD" "MLI" "MMR" "MNE" "MNG" "MYS" "NGA" "NIC" "NLD" "PAK" "PER" "PHL" "POL" "ROU" "RUS" "RWA" "SAU" "SGP" "SLV" "SRB" "SVK" "SVN" "SWE" "THA" "TJK" "TTO" "TUN" "TUR" "TWN" "TZA" "UGA" "UKR" "URY" "UZB" "VEN" "VNM" "YEM" "ZAF" "ZMB" "ZWE"{
	replace Treatment = 0 if COUNTRY_ALPHA == "`c'"
	}

***PART 1: Multiple Question Variable***

*deal with negative values!!!!
gen career_choice = 100 if X036E != V097EF
replace career_choice = 0 if X036E == V097EF

***PART 2: Single Question Variables***

*Rename the variables with descriptive names
rename (F114B E268 H008_03 E069_11 E069_17 E069_07 E069_04 E264 E069_64 E265_07) (property legal medicine gov judges parliament press voted fair_elections pluralism)

*Create a local macro of the variables with options 1-4 (good to bad) 
local WVS_raw gov judges parliament press voted fair_elections 

*Use a for loop to recode variables
foreach var of local WVS_raw {
	
	replace `var'=100 if `var'==1
	replace `var'=66.6 if `var'==2
	replace `var'=33.3 if `var'==3
	replace `var'=0 if `var'==4
}

*Create a local macro of the variables with options 1-4 (bad to good) 
local WVS_raw2 medicine legal pluralism 

*Use a for loop to recode variables
foreach var of local WVS_raw2 {
	
	replace `var'=100 if `var'==4
	replace `var'=66.6 if `var'==3
	replace `var'=33.3 if `var'==2
	replace `var'=0 if `var'==1
}

*Recode variable with options 1-10 (good to bad) (property rights)
replace property = 100 if property == 1
replace property = 88.9 if property == 2
replace property = 77.8 if property == 3
replace property = 66.7 if property == 4
replace property = 55.6 if property == 5
replace property = 44.4 if property == 6
replace property = 33.3 if property == 7
replace property = 22.2 if property == 8
replace property = 11.1 if property == 9
replace property = 0 if property == 10

***PART 3: Create a Table explaining the definition of each Variable***

/*Q179/E114B: Indicate with a score from 1-10 whether stealing property is never justifiable (1) to always justifiable (10).*/
label var property "Property rights: Index indicating whether or not population believes stealing property can be justified"

/*Q116/E268: How many civil service providers do you believe are involved in corruption?
	1 None
	2 Few
	3 Most
	4 All*/
label var legal "Legal system: Index of perceived corruption of civil service providers, proxy for unbiased legal system"

/* Q53/H008_03: In the past 12 months, how often have you or your family gone without medicine or medical treatment that you needed?
	1 Often
	2 Sometimes
	3 Rarely
	4 Never */
label var medicine "Public services: Index indicating how often a responden tor family has gone without medicine or medical treatment in the past 12 months, proxy for provision of public services"

*Create a variable indicating career choice.
/* Q281/X036E: To which of the following occupational groups do you belong?
   Q283/V097EF: To which of the following occupational groups did your father belong?
   
A higher percentage of respondents who choose different careers from their family suggests a higher degree of career choice, since societies with limited choice will be more likely to delegate careers based on nepotism.*/

label var career_choice "Career choice: Percentage of respondents who are in the same career as their father. Proxy for career choice."

/*Q71/E069_11: How much confidence do you have in the government?
	1 A great deal 
	2 Quite a lot
	3 Not very much
	4 None */
label var gov "Centralized state: Index indicating degree of confidence in the government"

/*Q70/E069_17: How much confidence do you have in the courts?
	1 A great deal 
	2 Quite a lot
	3 Not very much
	4 None */
label var judges "Courts: Index indicating degree of confidence in the judiciary, proxy for checks and balances"

/*Q73/E069_07: How much confidence do you have in parliament?
	1 A great deal 
	2 Quite a lot
	3 Not very much
	4 None */
label var parliament "Legislative assembly: Index indicating degree of confidence in parliament"

/*Q76/E069_04: How much confidence do you have in the press?
	1 A great deal 
	2 Quite a lot
	3 Not very much
	4 None */
label var press "Free press: Index indicating degree of confidence freedom of press"

/*Q222/E264: When national elections take place, do you vote always, usually, or never?
	1 Always
	2 Usually
	3 Never
	4 Not allowed to vote */
label var voted "Civil society: Index indicating degree of voter participation, proxy for civil society"

/*Q76/E069_64: How much confidence do you have in elections?
	1 A great deal 
	2 Quite a lot
	3 Not very much
	4 None */
label var fair_elections "Fair elections: Index indicating degree of confidence in elections"

/*Q230/E265_07: How often do rich people buy elections?
	1 Very often
	2 Fairly often
	3 Not often
	4 Not at all often */
label var pluralism "Pluralism: ability of powerful elite (the rich) to influence political elections"


***PART 4: Export to CSV***

**Political Institutions (Question 7)***
*Export mean of scaled variables for Treatment (USA) to a csv
eststo Treatment: estpost summarize parliament judges press voted fair_elections gov pluralism if Treatment==1

*Export mean of scaled variables for Control group to a csv
eststo Control: estpost summarize parliament judges press voted fair_elections gov pluralism if Treatment==0

*Save the csv. Add a title, remove decimals.
esttab Treatment Control using "C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Results\assignment_1_political.csv", csv plain cells("mean(label(Mean) fmt(0))") mtitles("USA" "Rest of the World") noobs replace label 


**Economic Institutions (Question 8)**
*Export mean of scaled variables for Treatment (USA) to a csv if Treatment==1

*Export mean of scaled variables for Control group to a csv
eststo Control: estpost summarize property career_choice medicine legal if Treatment==0

*Save the csv. Add a title, remove decimals.
esttab Treatment Control using "C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Results\assignment_1_economic.csv", csv plain cells("mean(label(Mean) fmt(0))") mtitles("USA" "Rest of the World") noobs replace label

*Save updated data in a different location to preserve original.
save "C:\Users\ellab\OneDrive\Desktop\ECON_634\Assignment_1\Data\World Values Survey Longitudinal/clean_data.dta", replace