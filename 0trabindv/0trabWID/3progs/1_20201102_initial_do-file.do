

// Task: Do-file for initial capture of WID data, US 1980-2014 inequality stats on labor and capital income for bottom 50% and top 10% of income share

// Created by: Fellipe Silva
// Date: 2020-11-02

// Initial
clear all
capture log close
set more off
version 15

// Create subdirectories on current working directory (cd)
mkdir "0trabWID"
mkdir "0trabWID\1source"
mkdir "0trabWID\2data"
mkdir "0trabWID\2data\1auxiliarydata"
mkdir "0trabWID\3progs"
mkdir "0trabWID\4logs"

// Log creation
log using "0trabWID\4logs\1_first_step.log", replace

// Install WID extension - no dependencies
ssc install wid

// Gather initial data
wid, indicator(spllin spkkin) perc(p0p50 p90p100) areas(US) ages(992) pop(j) years(1980/2014) metadata clear

// Save to source directory
save "0trabWID\1source\1_wid_base_data", replace

// Describe data
des

// Close the log
log close