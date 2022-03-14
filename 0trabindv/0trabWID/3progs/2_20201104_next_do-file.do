

// Task: Do-file for capture and treatment of WID data, US and FR 1980-2014 inequality stats on pre-tax labor and capital income and net wealth for bottom 50% and top 10% of income share

// Created by: Fellipe Silva
// Date: 2020-11-03

// Initial
clear all
capture log close
set more off
version 15

// Create subdirectories on current working directory (cd)
capture mkdir "0trabWID"
capture mkdir "0trabWID\1source"
capture mkdir "0trabWID\2data"
capture mkdir "0trabWID\2data\1auxiliarydata"
capture mkdir "0trabWID\3progs"
capture mkdir "0trabWID\4logs"

// Log creation
log using "0trabWID\4logs\5_USFR_income_wealth.log", replace

// Install WID extension - no dependencies
ssc install wid

// Gather needed data
wid, indicator(spllin spkkin shweal) perc(p0p50 p90p100) areas(US FR) ages(992) pop(j) years(1980/2014) metadata clear

// Drop unnecessary variables
drop age pop countryname shortname simpledes technicaldes shorttype longtype shortpop longpop shortage longage unit unitlabel source method data_quality imputation

// Generate "id" variable for "reshape" process
egen id = group(country year percentile)

// Do the "reshape", change shape of data from long to wide with variable "variable" as the column j
reshape wide value, i(id) j(variable) string

// Order the variables
order country year percentile valuespllin992j valuespkkin992j valueshweal992j id

// Rename new variables
rename valuespllin992j l_income
rename valuespkkin992j k_income
rename valueshweal992j net_wealth

// Insert label variables
label variable year "Year of observation"
label variable l_income "Pre-tax labor income"
label variable k_income "Pre-tax capital income"
label variable net_wealth "Net personal wealth"

// Insert notes
note l_income: "Pre-tax labor income = Compensation of employees + Labor component of net mixed income + Pensions and social insurance income (labor share)"
note k_income: "Pre-tax capital income = Housing asset income + Equity asset income + Interest income + Pensions and social insurance income (capital share) - Interest payments"
note net_wealth: "Net personal wealth = Personal non-financial assets + Personal financial assets - Personal debt"

// Notes for the data
notes: "The base unit is the individual (rather than the household) but resources are split equally within couples."
notes: "The population is comprised of individuals over age 20."
note: "Changed on `c(current_date)'"

// Save current state of affairs
save "0trabWID\2data\1auxiliarydata\3_USFR_income_wealth_placeholder", replace

// Get the ISO country codes
preserve
import delimited using "https://gist.githubusercontent.com/tadast/8827699/raw/3cd639fa34eec5067080a61c69e3ae25e3076abb/countries_codes_and_coordinates.csv", varname(1) stripquotes(yes) clear
rename country geo
gen country=strtrim(alpha2code)
rename numericcode country_num
keep country country_num
duplicates drop
save "0trabWID\2data\1auxiliarydata\3_hlp_country_codes", replace
restore

// Merge the country code data with the current dataset
merge m:1 country using "0trabWID\2data\1auxiliarydata\3_hlp_country_codes.dta", keepusing(country_num)

// Drop useless values
drop if _m==2

// Install LABUTIL package extension - no dependencies
ssc install labutil

// Run labmask and numlabel to make country variable a numeric value
labmask country_num, values(country)
numlabel country_num, add

// Drop more useless variables, rename new variable with old name
drop country id _merge
rename country_num country

// Add label variable, note, re-order
label variable country "Country of observation"
note country: "Number = ISO 3166-1 numeric code"
order country year percentile l_income k_income net_wealth

// Transform percentile into numeric value
encode percentile, gen(percentiles)
label define percs 1 "p0p50" 2 "p90p100"
label values percentiles percs

// Substitute the former percentile for the new one, add label and notes
drop percentile
rename percentiles percentile
label variable percentile "Income share percentile within the nation"
note percentile : "p0p50 = Bottom half of the income share of the nation"
note percentile : "p90p100 = Top 10% of the income share of the nation"

// Re-order
order country year percentile l_income k_income net_wealth

// More notes
note l_income : "Values are share of income by percentage points (therefore .2000 = 20%)"
note k_income : "Values are share of income by percentage points (therefore .2000 = 20%)"
note net_wealth : "Values are share of wealth by percentage points (therefore .2000 = 20%)"

// Format variables
format %8.0g l_income
format %8.0g k_income
format %8.0g net_wealth

// Compress the data
compress

// Save to source directory
save "0trabWID\2data\5_USFR_income_wealth", replace

// Describe data
des

// Close the log
log close