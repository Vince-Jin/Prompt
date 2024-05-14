capture program drop program753
program define program753
	qui {
		
		macro drop all
		cls
		
		local des_s = 10
		local req_s = 10
		local hint_thresh = 3
		local ans_thresh = 9
		
		qui do "https://raw.githubusercontent.com/jhustata/basic/main/table1_fena.ado"
		
		local d1 : di "Thank you for piloting the user interactive programming approach in Stata"
		local d2 : di " "
		local d3 : di "In this pilot program, both traditional and user interactive approach will be"
		local d4 : di "tested to generate a table 1 on variables from part of NHANES survey dataset."
		local d5 : di " "
		local d6 : di "If you wish to exit the program at anytime, please enter exit at the command window."
		forvalues i = 1/6 {
			foreach j in `d`i'' {
				noi di "`j'", _continue
				sleep `des_s'
			}
			noi di ""
		}
		
		noi di " "
		noi di "Current working directory: `c(pwd)'"
		noi di "If you wish to change the working directory, please enter now"
		noi di "Otherwise, please hit enter to continue", _request(dire)
				
		global dire : di strtrim("${dire}")
		if (strupper("${dire}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		global slash
		if ("`c(os)'" == "Windows") {
			global slash : di "\"
			global del : di "del"
		}
		else if ("`c(os)'" != "Windows") {
			global slash : di "/"
			global del : di "rm"
		}
		
		if ("${dire}" == "") {
			global root : di "`c(pwd)'"
		}
		else if ("${dire}" != "") {
			capture cd "${dire}"
			while (_rc) {
				noi di as error "The directory entered: "
				noi di "${dire}"
				noi di "Does not exist and cannot be set as working directory"
				noi di in g "Please check and re-enter", _request(dire)
				capture cd "${dire}"
			}
			global root : di "`c(pwd)'"
		}
		
		capture mkdir "${root}${slash}data"
		capture mkdir "${root}${slash}table"
		
		global data_p : di "${root}${slash}data"
		global table_p : di "${root}${slash}table"
		
		noi di " "
		
		local d8 : di "The first approach that will be tested is: User Interactive Approach"
		foreach j in `d8' {
			noi di as error "`j'", _continue
			sleep `req_s'
		}
		noi di ""
		noi di in g " "
		sleep 3000
		local d9 : di "For this approach, we will create the NHANES dataset for survey cycle: "
		foreach j in `d9' {
			noi di "`j'", _continue
			sleep `req_s'
		}
		noi di ""
		local ys_helper = (round(runiform(0, ((2017 - 1999) / 2))) * 2) + 1999
		local ye_helper = (round(runiform(0, ((2018 - (`ys_helper' + 1)) / 2))) * 2) + (`ys_helper' + 1)
		noi di "`ys_helper' (start year) - `ye_helper' (end year)"
		local d10 : di "We will conduct our table 1 for following variables: "
		foreach j in `d10' {
			noi di "`j'", _continue
			sleep `req_s'
		}
		noi di ""
		// riagendr ridageyr ridreth1 indhinc - demo
		// bpxsy1 bpxdi1 bmxwt bmxht bmxbmi lbxgh urxuma urxucr lbxsch lbxsgl lbxtr - exam
		// diq010 kiq020 bpq020 smq020 mcq010 - questionnaire
		dict_new, name(vars) ///
					ind(riagendr ridageyr ridreth1 bpxsy1 bpxdi1 bmxwt bmxht bmxbmi lbxgh urxuma urxucr lbxsch lbxsgl lbxtr diq010 bpq020 smq020 mcq010) ///
					val(demographic demographic demographic examination examination examination examination examination examination examination examination examination examination examination questionnaire questionnaire questionnaire questionnaire)
		local r_max = round(runiform(1, 18))
		local vars_target
		forvalues i = 1 / `r_max' {
			local r_var = round(runiform(1, 18))
			local r_exist = 0
			foreach j in `vars_target' {
				if (`r_var' == `j') {
					local r_exist = 1
				}
			}
			/*
			local vars_target_list : di (`"""' + subinstr("`vars_target'", " ", `"", ""', .) + `"""')
			
			while (inlist("`r_var'", `vars_target_list')) {
			*/
		
			while (`r_exist' == 1) {
				local r_var = round(runiform(1, 18))
				local r_exist = 0
				foreach j in `vars_target' {
					if (`r_var' == `j') {
						local r_exist = 1
					}
				}
			}
			local vars_target `vars_target' `r_var'
		}
		local vars_list
		foreach i in `vars_target' {
			tokenize ${vars_index}
			local vars_list `vars_list' ``i''
		}
		noi di "`vars_list'"
		local d11 : di "These varaibles comes from these following dataset type: "
		foreach j in `d11' {
			noi di "`j'", _continue
			sleep `req_s'
		}
		noi di ""
		local type_list
		foreach i in `vars_list' {
			dict_call, name(vars) ind(`i')
			local type_str : di (`"""' + subinstr("`type_list'", " ", `"", ""', .) + `"""')
			if !inlist("${dict_call}", `type_str') {
				local type_list `type_list' ${dict_call}
			}
		}
		noi di "`type_list'"
		local ds
		dict_new, name(ds_val) ind(demographic examination dietary questionnaire) val(1 2 3 4)
		foreach i in `type_list' {
			dict_call, name(ds_val) ind(`i')
			local ds `ds' ${dict_call}
		}
		local mis = round(runiform(0, 1))
		if (`mis' == 0) {
			noi di as error "Please make sure to NOT include missingness information for variables."
		}
		else if (`mis' == 1) {
			noi di as error "Please make sure to include missingness information for variables"
		}
		
		noi di in g " "
		noi di "Please press enter to proceed", _request(proceed)
		global proceed : di strtrim(stritrim("${proceed}"))
		if (strupper("${proceed}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		
		timer clear 1
		timer on 1
		noi di "First step: Creating the NHANES Dataset"
		noi di "Please enter the start year of the survey cycle of NHANES requested: ", _request(ys)
		global ys : di strtrim(stritrim("${ys}"))
		if (strupper("${ys}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		while ("${ys}" != "`ys_helper'") {
			noi di "Start year entered does not match designated scenario"
			noi di "Please check and re-enter", _request(ys)
			global ys : di strtrim(stritrim("${ys}"))
			if (strupper("${ys}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
		}
		noi di "Please enter the end year of the survey cycle of NHANES requested: ", _request(ye)
		global ye : di strtrim(stritrim("${ye}"))
		if (strupper("${ye}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		while ("${ye}" != "`ye_helper'") {
			noi di "End year entered does not match designated scenario"
			noi di "Please check and re-enter", _request(ye)
			global ye : di strtrim(stritrim("${ye}"))
			if (strupper("${ye}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
		}
		noi di "Please enter the dataset type of survey cycle of NHANES requested: "
		noi di "1 - demographic"
		noi di "2 - examination"
		noi di "3 - dietary"
		noi di "4 - questionnaire"
		noi di "For multiple inputs, use space for separation", _request(data_list)
		
		local exception = 0
		global data_list : di strtrim(stritrim("${data_list}"))
		if (strupper("${data_list}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		foreach i in ${data_list} {
			if !(inlist("`i'", "1", "2", "3", "4")) {
				local exception = 1
			}
		}
		
		while (`exception' != 0) {
			noi di "Dataset type out of range, please re-enter", _request(data_list)
			local exception = 0
			global data_list : di strtrim(stritrim("${data_list}"))
			if (strupper("${data_list}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
			foreach i in ${data_list} {
				if !(inlist("`i'", "1", "2", "3", "4")) {
					local exception = 1
				}
				else if (strupper("${data_list}") == "EXIT") {
					exit
				}
			}
		}
		
		local dl_helper ${data_list}
		local d1 : list uniq dl_helper
		local d1 : list sort d1
		local d2 : list uniq ds
		local d2 : list sort d2

		while ("`d1'" != "`d2'") {
			noi di "Please re-check the dataset requirement and try again.", _request(data_list)
			global data_list : di stritrim(strtrim("${data_list}"))
			if (strupper("${data_list}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}

			foreach i in ${data_list} {
				if !(inlist("`i'", "1", "2", "3", "4")) {
					local exception = 1
				}
			}

			while (`exception' != 0) {
				noi di "Dataset type out of range, please re-enter", _request(data_list)
				local exception = 0
				global data_list : di strtrim(stritrim("${data_list}"))
				if (strupper("${data_list}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
				foreach i in ${data_list} {
					if !(inlist("`i'", "1", "2", "3", "4")) {
						local exception = 1
					}
					else if (strupper("${data_list}") == "EXIT") {
						exit
					}
				}
			}

			local dl_helper ${data_list}
			local d1 : list uniq dl_helper
			local d1 : list sort d1

		}
		
		local ds_n = 0
		capture mkdir "${data_p}${slash}user interactive"
		cd "${data_p}${slash}user interactive"
		shell ${del} NHANES*.dta
		foreach i in ${data_list} {
			local ds_n = `ds_n' + 1
			noi nhanes_fena, ys(${ys}) ye(${ye}) ds(`i') pro s2017
			tempfile ds`ds_n'
			save `ds`ds_n'', replace
		}
		
		if (`ds_n' > 1) {
			use `ds1', clear
			forvalues i = 2/`ds_n' {
				merge 1:1 seqn using `ds`i'', nogen
			}
		}
		
		tempfile nh_set
		save `nh_set', replace
		noi di " "
		noi di "User Interactive Dataset Created"
		noi di " "
		noi di "User Interactive Table 1 Creation: "
		noi di "Please enter variables to be included in: "
		noi di "Separated by space"
		noi di "(E.g.: to enter variable aaa and bbb and ccc -> aaa bbb ccc)", _request(var)
		global var : di stritrim(strtrim("${var}"))
		if (strupper("${var}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		local var_helper ${var}
		local d1 : list uniq var_helper
		local d1 : list sort d1
		local d2 : list uniq vars_list
		local d2 : list sort d2

		while ("`d1'" != "`d2'") {
			noi di "Please re-check the variable requirement and try again.", _request(var)
			global var : di stritrim(strtrim("${var}"))
			if (strupper("${var}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
			local var_helper ${var}
			local d1 : list uniq var_helper
			local d1 : list sort d1
			local d2 : list uniq vars_list
			local d2 : list sort d2
		}
		noi di "Please specify a title for table 1: "
		noi di "(Hit enter to skip)", _request(title)
		global title : di stritrim(strtrim("${title}"))
		if (strupper("${title}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		local title
		if ("${title}" != "") {
			local title: di "title(${title})"
		}
		else if ("${title}" == "") {
			local title
		}
		noi di "Please specify a name for excel file holding the output table 1: "
		noi di "(Hit enter to skip)", _request(excel)
		global excel : di stritrim(strtrim("${excel}"))
		if (strupper("${excel}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		local excel
		if ("${excel}" != "") {
			local excel: di "excel(${excel})"
		}
		else if ("${excel}" == "") {
			local excel
		}
		noi di "Including missingness information for variables?"
		noi di "(1/Y - Yes, 0/N - No)", _request(mis)
		global mis : di stritrim(strtrim("${mis}"))
		if (strupper("${mis}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		local missingness
		local missingness_helper = 0
		global mis_helper: di strupper(substr(strtrim(stritrim("${mis}")), 1, 1))
		if (("${mis_helper}" == "1") | ("${mis_helper}" == "Y")) & (`mis' == 1) {
			local missingness_helper = 1
		}
		else if !(("${mis_helper}" == "1") | ("${mis_helper}" == "Y")) & (`mis' == 0) {
			local missingness_helper = 1
		}
		while (`missingness_helper' != 1) {
			noi di "Please check the scenario requirement and re-enter", _request(mis)
			global mis : di stritrim(strtrim("${mis}"))
			if (strupper("${mis}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
			local missingness_helper = 0
			global mis_helper: di strupper(substr(strtrim(stritrim("${mis}")), 1, 1))
			if (("${mis_helper}" == "1") | ("${mis_helper}" == "Y")) & (`mis' == 1) {
				local missingness_helper = 1
			}
			else if !(("${mis_helper}" == "1") | ("${mis_helper}" == "Y")) & (`mis' == 0) {
				local missingness_helper = 1
			}
		}
		
		if ("${mis_helper}" == "1") | ("${mis_helper}" == "Y") {
			local missingness : di "missingness"
		}
		else {
			local missingness
		}
		
		capture mkdir "${table_p}${slash}user interactive"
		cd "${table_p}${slash}user interactive"
		shell ${del} *.xlsx
		noi table1_fena, var(${var}) `title' `excel' `missingness'
		timer off 1
		qui timer list
		global crt1 = `r(t1)'
		local ds1 : di "Now you have reached the end of the user interactive approach."
		local ds2 : di "We will switch back to the traditional syntax approach."
		forvalues i = 1/2 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `req_s'
			}
			noi di ""
		}
		noi di " "
		local ds1 : di "The second approach that will be tested is: Traditional Syntax Approach"
		foreach i in `ds1' {
			noi di as error "`i'", _continue
			sleep `des_s'
		}
		noi di ""
		noi di in g " "
		sleep 3000
		local ds1 : di "Imagine that you are a collaborator who have never worked with this project before"
		local ds2 : di "One day you want to reproduce the table 1 for this project," 
		local ds3 : di "and obtained the associated script and program, which is called: "
		local ds4 : di "creation"
		local ds5 : di " "
		local ds6 : di "Now you just need to call the program in console, but you have to specify all appropriate optional syntax options"
		local ds7 : di "just like: creation, ys(...) ye(...) ..."
		local ds8 : di " "
		local ds9 : di "Unfortunately you were not offered information about these syntax optinos."
		local ds10 : di "You only know that this program has these following syntaxes and options: "
		local ds11 : di "ys() ye() var() ds() s2017 pro missingness excel() title()"
		local ds12 : di "Let's see how it goes."
		local ds13 : di "(Please hit enter for continue)"
		
		forvalues i = 1/13 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `des_s'
			}
			noi di ""
		}
		noi di "", _request(proceed)
		global proceed : di strtrim(stritrim("${proceed}"))
		if (strupper("${proceed}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		
		local ds1 : di " "
		local ds2 : di "In this scenario, we are still creating the table 1 for NHANES datasets."
		local ds3 : di " "
		local ds4 : di "For this approach, we will create the NHANES dataset for survey cycle: "
		forvalues i = 1/4 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `req_s'
			}
			noi di ""
		}
		local ys_helper = (round(runiform(0, ((2017 - 1999) / 2))) * 2) + 1999
		local ye_helper = (round(runiform(0, ((2018 - (`ys_helper' + 1)) / 2))) * 2) + (`ys_helper' + 1)
		noi di "`ys_helper' (start year) - `ye_helper' (end year)"
		local ds1 : di "We will conduct our table 1 for following variables: "
		foreach i in `ds1' {
			noi di "`i'", _continue
			sleep `req_s'
		}
		noi di ""
		// riagendr ridageyr ridreth1 indhinc - demo
		// bpxsy1 bpxdi1 bmxwt bmxht bmxbmi lbxgh urxuma urxucr lbxsch lbxsgl lbxtr - exam
		// diq010 kiq020 bpq020 smq020 mcq010 - questionnaire
		dict_new, name(vars) ///
					ind(riagendr ridageyr ridreth1 bpxsy1 bpxdi1 bmxwt bmxht bmxbmi lbxgh urxuma urxucr lbxsch lbxsgl lbxtr diq010 bpq020 smq020 mcq010) ///
					val(demographic demographic demographic examination examination examination examination examination examination examination examination examination examination examination questionnaire questionnaire questionnaire questionnaire)
		local r_max = round(runiform(1, 18))
		local vars_target
		forvalues i = 1 / `r_max' {
			local r_var = round(runiform(1, 18))
			local r_exist = 0
			foreach j in `vars_target' {
				if (`r_var' == `j') {
					local r_exist = 1
				}
			}
			/*
			local vars_target_list : di (`"""' + subinstr("`vars_target'", " ", `"", ""', .) + `"""')
			
			while (inlist("`r_var'", `vars_target_list')) {
			*/
		
			while (`r_exist' == 1) {
				local r_var = round(runiform(1, 18))
				local r_exist = 0
				foreach j in `vars_target' {
					if (`r_var' == `j') {
						local r_exist = 1
					}
				}
			}
			local vars_target `vars_target' `r_var'
		}
		local vars_list
		foreach i in `vars_target' {
			tokenize ${vars_index}
			local vars_list `vars_list' ``i''
		}
		noi di "`vars_list'"
		local ds1 : di "These varaibles comes from these following dataset type: "
		foreach i in `ds1' {
			noi di "`i'", _continue
			sleep `req_s'
		}
		noi di ""
		local type_list
		foreach i in `vars_list' {
			dict_call, name(vars) ind(`i')
			local type_str : di (`"""' + subinstr("`type_list'", " ", `"", ""', .) + `"""')
			if !inlist("${dict_call}", `type_str') {
				local type_list `type_list' ${dict_call}
			}
		}
		noi di "`type_list'"
		local mis = round(runiform(0, 1))
		local missingness
		if (`mis' == 0) {
			noi di as error "Please make sure to NOT include missingness information for variables."
		}
		else if (`mis' == 1) {
			noi di as error "Please make sure to include missingness information for variables"
			local missingness missingness
		}
		noi di in g " "
		noi di "Please press enter to proceed", _request(proceed)
		global proceed : di strtrim(stritrim("${proceed}"))
		if (strupper("${proceed}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		
		timer clear 2
		timer on 2
		
		noi di in g " "
		local ds1 : di "Please enter the correct call for the program with all appropriate syntax options: "

		
		forvalues i = 1/1 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `req_s'
			}
			noi di ""
		}

		noi di "(creation, ...)"
		noi di "syntax and options for creation: "
		noi di as error "ys() ye() var() ds() s2017 pro missingness excel() title()", _continue
		noi di in g, _request(command)
		
		global command : di stritrim(strtrim("${command}"))
		if (strupper("${command}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		
		// pool all correct information to appropriate names
		local ys `ys_helper'
		local ye `ye_helper'
		local ds
		dict_new, name(ds_val) ind(demographic examination dietary questionnaire) val(1 2 3 4)
		foreach i in `type_list' {
			dict_call, name(ds_val) ind(`i')
			local ds `ds' ${dict_call}
		}
		local pro pro
		local s2017 s2017
		local var `vars_list'

		local must ys ye ds var pro s2017
		if ("`missingness'" == "missingness") {
			local must `must' missingness
		}
		local opt_list `must' title excel
		
		// processing command to check
		// 1. remove program name
		local opt : di stritrim(strtrim(substr("${command}", (strpos("${command}", ",") + 1), .)))
		
		// get a error counter
		local err_ct = 0
		// check if all must options got called
		local called = 1
		foreach i in `must' {
			if (strpos("`opt'", "`i'") == 0) {
				local called = 0
			}
		}
		while (`called' == 0) {
			local err_ct = `err_ct' + 1
			
			if (`err_ct' > `hint_thresh') {
				noi di " "
				/*
				noi di "Do you wish to have a hint on mandatory option list?"
				noi di "(Yes - Y/1, No - N/0)", _request(hint)
				
				global hint : di strtrim(stritrim("${hint}"))
				*/
				global hint : di "Y"
				if (strupper("${hint}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di " "
					exit
				}
				
				if ((strupper(substr("${hint}", 1, 1)) == "Y") | real("${hint}") == 1) {
					noi di " "
					noi di "Here is a list of mandatory options:"
					noi di "ys()"
					noi di "ye()"
					noi di "ds()"
					noi di "var()"
					noi di "pro - this one is a special option that makes program operate"
					noi di "s2017 - this one is a special option for proper dataset creation"
					if ("`missingness'" == "missingness") {
						noi di "missingness - this tells the program to include missingness info in table 1"
					}
					noi di " "
				}
			}
			
			noi di "One or more mandatory options are missing in the call."
			noi di "Please check and try again", _request(command)
			global command : di stritrim(strtrim("${command}"))
			if (strupper("${command}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
			local opt : di stritrim(strtrim(substr("${command}", (strpos("${command}", ",") + 1), .)))
			local called = 1
			foreach i in `must' {
				if (strpos("`opt'", "`i'") == 0) {
					local called = 0
				}
			}
		}
		
		// now opt is all syntax options
		// conduct checks among each of them
		// first condense var and ds
		local var_helper : di substr("`opt'", strpos("`opt'", "var("), .)
		local var_end_pos = strpos("`var_helper'", ")")
		local var_len = (`var_end_pos' - 1 - 5)
		local var_str : di substr("`var_helper'", 5, `var_len')
		local var_con : di subinstr("`var_str'", " ", ",", .)
		local opt : di subinstr("`opt'", "`var_str'", "`var_con'", .)
		local ds_helper : di substr("`opt'", strpos("`opt'", "ds("), .)
		local ds_end_pos = strpos("`ds_helper'", ")")
		local ds_len = (`ds_end_pos' - 1 - 3)
		local ds_str : di substr("`ds_helper'", 4, `ds_len')
		local ds_con : di subinstr("`ds_str'", " ", ",", .)
		local opt : di subinstr("`opt'", "`ds_str'", "`ds_con'", .)

		local errors
		foreach i in `opt' {
			// check if opt is taking in parameters
			local pos = strpos("`i'", "(")
			if (`pos' != 0) {
				// parameters taking in
				local opt_name : di substr("`i'", 1, (`pos' - 1))
				local opt_val : di stritrim(strtrim(substr("`i'", (`pos' + 1), (strlen("`i'") - 1 - `pos'))))
				// check if option needed
				local opt_err = 1
				foreach j in `opt_list' {
					if "`j'" == "`opt_name'" {
						local opt_err = 0
					}
				}
				if (`opt_err' == 1) {
					local errors `errors' `i'
					continue
				}
				if (inlist("`opt_name'", "ys", "ye")) {
					if (`opt_val' != ``opt_name'') {
						loca opt_err = 1
					}
				}
				if (`opt_err' == 1) {
					local errors `errors' `i'
					continue
				}
				if ("`opt_name'" == "ds") {
					local opt_val : di subinstr("`opt_val'", ",", " ", .)
					local ds_1 : list uniq opt_val
					local ds_1 : list sort ds_1

					local ds_2 : list uniq ds
					local ds_2 : list sort ds_2
	
					if ("`ds_1'" != "`ds_2'") {
						loca opt_err = 1
					}
				}
				if (`opt_err' == 1) {
					local i : di subinstr("`i'", ",", " ", .)
					local errors `errors' `i'
					continue
				}
				if ("`opt_name'" == "var") {
					
					local opt_val2 : di subinstr("`opt_val'", ",", " ", .)
					local ds_1 : list uniq opt_val2
					local ds_12 : list sort ds_1
					local ds_2 : list uniq vars_list
					local ds_2 : list sort ds_2
					if ("`ds_12'" != "`ds_2'") {
						loca opt_err = 1
					}
				}
				if (`opt_err' == 1) {
					
					local i : di subinstr("`i'", ",", " ", .)
					local errors `errors' `i'
					continue
				}
			}
			else if (`pos' == 0) {
				local opt_err = 0
				if !inlist("`i'", "pro", "s2017", "missingness") {
					local opt_err = 1
				}
				else if ("`i'" != "``i''") {
					local opt_err = 1
				}
				if (`opt_err' == 1) {
					local errors `errors' `i'
					continue
				}				
			}
			
		}
		
		local err_ct = 0
		while ("`errors'" != "") {
			
			local err_ct = `err_ct' + 1
			
			if (`err_ct' > `hint_thresh') {
				noi di " "
				noi di "Here are some hints for syntax options: "
				noi di "ys() - start year of NHANES survey needed"
				noi di "ye() - end year of NHANES survey needed"
				noi di "ds() - dataset needed from NHANES survey"
				noi di "(1 - demographic, 2 - examination, 3 - dietary, 4 - questionnaire)"
				noi di "var() - variables need to be included in table 1"
				noi di "title() - title of table 1 (not mandatory in our scenario)"
				noi di "excel() - excel name of table 1 output (not mandatory in our scenario)"
				noi di " "
			}
			
			if (`err_ct' > `ans_thresh') {
				noi di "Do you wish to see the answer?"
				noi di "(Yes - Y/1, No - N/0)", _request(answer)
				
				global answer : di strtrim(stritrim("${answer}"))
				
				if (strupper("${answer}") == "EXIT") {
					noi di " "
					noi di "Program Terminated"
					noi di " "
					exit
				}
				
				if (substr((strupper("${answer}")), 1, 1) == "Y" | real("${answer}") == 1) {
					noi di " "
					noi di "The answer for this scenario is: "
					noi di `"creation, ys(`ys') ye(`ye') ds(`ds') var(`var') pro s2017 `missingness'"'
					noi di "You may also specify title() and excel() for your own preference"
					noi di " "
				}
			}
			
			noi di "These following syntax options may have mistakes: "
			noi di "`errors'"
			noi di "Please try again", _request(command)
			
			global command : di stritrim(strtrim("${command}"))
			if (strupper("${command}") == "EXIT") {
				noi di " "
				noi di as error "Program Terminated"
				noi di in g " "
				exit
			}
			
			local opt : di stritrim(strtrim(substr("${command}", (strpos("${command}", ",") + 1), .)))
			// check if all must options got called
			local called = 1
			foreach i in `must' {
				if (strpos("`opt'", "`i'") == 0) {
					local called = 0
				}
			}

			while (`called' == 0) {
				
				local err_ct = `err_ct' + 1
			
				if (`err_ct' > `hint_thresh') {
					noi di " "
					/*
					noi di "Do you wish to have a hint on mandatory option list?"
					noi di "(Yes - Y/1, No - N/0)", _request(hint)
					
					global hint : di strtrim(stritrim(hint))
					*/
					global hint : di "Y"
					if (strupper("${hint}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di " "
						exit
					}
					
					if ((strupper(substr("${hint}", 1, 1)) == "Y") | real("${hint}") == 1) {
						noi di " "
						noi di "Here is a list of mandatory options:"
						noi di "ys()"
						noi di "ye()"
						noi di "ds()"
						noi di "var()"
						noi di "pro - this one is a special option that makes program operate"
						noi di "s2017 - this one is a special option for proper dataset creation"
						if ("`missingness'" == "missingness") {
							noi di "missingness - this tells the program to include missingness info in table 1"
						}
						noi di " "
					}
				}
				
				noi di "One or more mandatory options are missing in the call."
				noi di "Please check and try again", _request(command)
				
				
				global command : di stritrim(strtrim("${command}"))
				if (strupper("${command}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
				
				local opt : di stritrim(strtrim(substr("${command}", (strpos("${command}", ",") + 1), .)))
				local called = 1
				foreach i in `must' {
					if (strpos("`opt'", "`i'") == 0) {
						local called = 0
					}
				}
			}

			// now opt is all syntax options
			// conduct checks among each of them
			// first condense var and ds
			local var_helper : di substr("`opt'", strpos("`opt'", "var("), .)
			local var_end_pos = strpos("`var_helper'", ")")
			local var_len = (`var_end_pos' - 1 - 5)
			local var_str : di substr("`var_helper'", 5, `var_len')
			local var_con : di subinstr("`var_str'", " ", ",", .)
			local opt : di subinstr("`opt'", "`var_str'", "`var_con'", .)
			local ds_helper : di substr("`opt'", strpos("`opt'", "ds("), .)
			local ds_end_pos = strpos("`ds_helper'", ")")
			local ds_len = (`ds_end_pos' - 1 - 3)
			local ds_str : di substr("`ds_helper'", 4, `ds_len')
			local ds_con : di subinstr("`ds_str'", " ", ",", .)
			local opt : di subinstr("`opt'", "`ds_str'", "`ds_con'", .)
			macro list
			local errors

			foreach i in `opt' {
				// check if opt is taking in parameters
				local pos = strpos("`i'", "(")
				if (`pos' != 0) {
					// parameters taking in
					local opt_name : di substr("`i'", 1, (`pos' - 1))
					local opt_val : di stritrim(strtrim(substr("`i'", (`pos' + 1), (strlen("`i'") - 1 - `pos'))))
					// check if option needed
					local opt_err = 1
					foreach j in `opt_list' {
						if "`j'" == "`opt_name'" {
							local opt_err = 0
						}
					}
					if (`opt_err' == 1) {
						local errors `errors' `i'
						continue
					}
					if (inlist("`opt_name'", "ys", "ye")) {
						if (`opt_val' != ``opt_name'') {
							loca opt_err = 1
						}
					}
					if (`opt_err' == 1) {
						local errors `errors' `i'
						continue
					}
					if ("`opt_name'" == "ds") {
						local opt_val : di subinstr("`opt_val'", ",", " ", .)
						local ds_1 : list uniq opt_val
						local ds_1 : list sort ds_1

						local ds_2 : list uniq ds
						local ds_2 : list sort ds_2
		
						if ("`ds_1'" != "`ds_2'") {
							loca opt_err = 1
						}
					}
					if (`opt_err' == 1) {
						local i : di subinstr("`i'", ",", " ", .)
						local errors `errors' `i'
						continue
					}
					if ("`opt_name'" == "var") {
						
						local opt_val2 : di subinstr("`opt_val'", ",", " ", .)
						local ds_1 : list uniq opt_val2
						local ds_12 : list sort ds_1
						local ds_2 : list uniq vars_list
						local ds_2 : list sort ds_2
						if ("`ds_12'" != "`ds_2'") {
							loca opt_err = 1
						}
					}
					if (`opt_err' == 1) {
						
						local i : di subinstr("`i'", ",", " ", .)
						local errors `errors' `i'
						continue
					}
				}
				else if (`pos' == 0) {
					local opt_err = 0
					if !inlist("`i'", "pro", "s2017", "missingness") {
						local opt_err = 1
					}
					else if ("`i'" != "``i''") {
						local opt_err = 1
					}
					if (`opt_err' == 1) {
						local errors `errors' `i'
						continue
					}				
				}
				
			}
		}
		noi di " "
		local ds1 : di "Congratulations! You have correctly specify the program syntaxes."
		local ds2 : di "Now let's run the actual program and get the table!"
		local ds3 : di " "
		
		forvalues i = 1/3 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `req_s'
			}
			noi di ""
		}
		
		noi ${command}
		
		timer off 2
		qui timer list
		global crt2 = `r(t2)'
		noi di " "
		noi di "Running Time Information: "
		noi di "Prompt Based (Q7): ${crt1}"
		noi di "Traditional (Q8): ${crt2}"
		noi di " "
		local ds1 : di "This is the end of this piloting program."
		local ds2 : di "Thank you so much for your participation!"
		local ds3 : di "Please be sure to let us know your experiences."
		forvalues i = 1/3 {
			foreach j in `ds`i'' {
				noi di "`j'", _continue
				sleep `req_s'
			}
			noi di ""
		}	
	}
end

qui {
	capture program drop creation
	program define creation
		qui {
			syntax, ys(int) ye(int) [ds(string) var(string) s2017 pro missingness excel(string) title(string)]
			
			// get sets
			local ds_n = 0
			capture mkdir "${data_p}${slash}syntax"
			cd "${data_p}${slash}syntax"
			shell ${del} NHANES*.dta
			foreach i in `ds' {
				local ds_n = `ds_n' + 1
				noi nhanes_fena, ys(`ys') ye(`ye') ds(`i') `s2017' `pro'
				tempfile ds`ds_n'
				save `ds`ds_n'', replace
			}
			if `ds_n' > 1 {
				use `ds1', clear
				forvalues i = 2/`ds_n' {
					merge 1:1 seqn using `ds`i'', nogen
				}
			}
			tempfile syntax_set
			save `syntax_set', replace
			
			capture mkdir "${table_p}${slash}syntax"
			cd "${table_p}${slash}syntax"
			shell ${del} *.xlsx
			noi table1_fena, var(`var') excel(`excel') title(`title') `missingness'
			 
		}
	end
}

/*
qui {
	capture program drop table1_fena
	program define table1_fena

		qui {
			
			syntax [if] [, var(string) by(varname) title(string) excel(string) catt(int 15) missingness]
			
			// first detect varaible type
			if 1 {
				noi di "Detecting Variable Types"
				// in case only by variable was specified
				if (("`by'" != "") & ("`var'" == "")) {
					ds
					local var_helper = r(varlist)
					local var : di stritrim(subinstr("`var_helper'", "`by'", "", .))
				}
				noi var_type, var(`var') catt(`catt')
				if (strupper("${terminator}") == "EXIT") {
					exit
				}				
				if (strupper("${terminator}") != "EXIT") {
					noi missing_detect, v(${terminator})
				}
				
				// double verify the variable types 
				// ask for user input
				noi di "Please indicate variables to modify, separated by space (e.g.: aaa bbb ccc)"
				noi di "Press enter to skip modification", _request(var_change)
				if ("${var_change}" != "") {
					local bstring : di "${bin}"
					local castring : di "${cat}"
					local costring : di "${con}"
					foreach i in ${var_change} {
						
						noi di "Please enter the correct variable type for" " variable " "`i'" " (1-binary 2-categorical 3-continuous):", _request(vtype)
						
						local bstring : di subinstr("`bstring'", "`i'", "", 1)
						local castring : di subinstr("`castring'", "`i'", "", 1)
						local costring : di subinstr("`costring'", "`i'", "", 1)
						
						if (${vtype} == 1) {
							local bstring : di "`bstring'" " " "`i'"
						}
						else if (${vtype} == 2) {
							local castring : di "`castring'" " " "`i'"
						}
						else if (${vtype} == 3) {
							local costring : di "`costring'" " " "`i'"
						}
						
						local bstring : di stritrim(strtrim("`bstring'"))
						local castring : di stritrim(strtrim("`castring'"))
						local costring : di stritrim(strtrim("`costring'"))

						
					}
					global bin `bstring'
					global cat `castring'
					global con `costring'
					noi di "Current Variable Types: "
					noi di "Binary Variables:"
					noi di "${bin}"
					noi di "Categorical Variables: "
					noi di "${cat}"
					noi di "Continuous Variables: "
					noi di "${con}"
				}
				
				// call the table1 program generate table 1
				noi di as error "Generating Table1"
				noi table1_creation `if', bin(${bin}) cat(${cat}) con(${con}) title(`title') excel(`excel') by(`by') `missingness'
				noi di ""
				noi di as error "Table 1 saved as `excel' to the following directory:"
				noi di in g "`c(pwd)'"
			}
			
		}

	end
}

qui {
	
	capture program drop var_type
	program define var_type
	
		qui {
			
			// determine the type of each variable being taken in
			// should take list of variables
			// default should be everything
			// end product:
			// three global macro to for binary, categorical, continuous variables
			syntax [, var(string) catt(int 15)]
			
			// sets up proper variable list for action
			if ("`var'" != "") {
				local vlist `var'
			} 
			else if ("`var'" == "") {
				ds
				local vlist `r(varlist)'
			}
			
			// determine if any of the variable specified is not in the dataset
			noi missing_detect, v(`vlist')

			if (strupper("${terminator}") == "EXIT") {
				noi di as error "WARNING: User Requested To Terminate The Program"
				exit
			}
			else {
				local vlist ${terminator}
			}

			// create returning global macros
			global bin
			global cat
			global con
			global tran
			
			// start to detect
			foreach i in `vlist' {
				
				levelsof `i', local(l1) s("!*!")
				local l2 : di subinstr(`"`l1'"', "!*!", "", .)
				local ln1 = strlen(`"`l1'"')
				local ln2 = strlen(`"`l2'"')
				local ln_diff = (`ln1' - `ln2') / 3

				if (`ln_diff' == 1) {
					global bin : di "${bin}" " " "`i'"
				}
				else if (`ln_diff' > 1 & `ln_diff' < (`catt')) {
					global cat : di "${cat}" " " "`i'"
				}
				else if (inrange(`ln_diff', (`catt' - 1), (`catt' - 1 + 15))) {
					global tran : di "${tran}" " " "`i'"
					global cat : di "${cat}" " " "`i'"
				}
				else {
					global con : di "${con}" " " "`i'"
				}
				
			}
			
			// display results
			noi di "Detected binary variables: "
			noi di "${bin}"
			noi di "Detected categorical variables: "
			noi di "${cat}"
			noi di "Detected continuous variables: "
			noi di "${con}"
			
			if ("${tran}" != "") {
				noi di as error "WARNING: Variables Require User Attention"
				noi di in g "${tran}"
			}
			
			
		}
	
	end
	
	capture program drop missing_detect
	program define missing_detect
		qui {
			syntax, v(string)
			ds
			local testing `r(varlist)'
			local missing
			foreach i in `v'{	
				if (strpos("`testing'", "`i'") == 0) {
					local missing : di "`missing'" " " "`i'"
					
				}
			}
			
			if ("`missing'" == "") {
				noi di in g "Variable check cleared"
				global terminator `v'
			}
			else if ("`missing'" != "") {				
				noi di ""
				noi di in g "Variables below not found in current dataset: "
				noi di "`missing'"
				noi di "Please re-enter variable list for the program"
				noi di "(Enter exit to terminate the program)", _request(terminator)
				
				if (strupper("${terminator}") == "EXIT") {
					exit
				}				
				if (strupper("${terminator}") != "EXIT") {
					noi missing_detect, v(${terminator})
				}
				
			}
		}
	end
	
}

qui {
	capture program drop ind_translator
	program define ind_translator
		syntax, row(int) col(int)

		// tokenize the alphabet
		local alphabet "`c(ALPHA)'"
		tokenize `alphabet'
		// now translate col
		local col_helper = `col'
		
		
		while (`col_helper' > 0) {
			local temp_helper2 = (`col_helper' - 1)
			local temp_helper = mod(`temp_helper2', 26) + 1
			local col_name : di "``temp_helper''" "`col_name'"
			local col_helper = (`col_helper' - `temp_helper') / 26
		} 
		
		
		// generate a global macro that can be used in main program
		global ul_cell "`col_name'`row'"
		
	end
}

qui {
	capture program drop table1_creation
	program define table1_creation

		syntax [if] [, title(string) bin(string) cat(string) con(string) foot(string) by(varname) excel(string) missingness]
		
		qui {
			
			preserve
			
			// check if
			if ("`if'" != "") {
				keep `if'
			}
			
			// grant default value to excel and title
			if 2 {
				if ("`title'" == "") {
					local title : di "Table 1: Demographics"
				}
				if ("`excel'" == "") {
					local excel : di "Table 1 Outputs"
				}
			}
			
			// generate excel file
			if 3 {
				putexcel set "`excel'", replace
			}
			
			// prepare excel row/col
			if 4 {
				local erc = 1
				local ecc = 1
				global ind : di "ind_translator, row(" "`" "erc" "'" ") col(" "`" "ecc" "'" ")"
			}
			
			// prepare indentation
			if 5 {
				local col1: di "_col(40)"
				local col2: di "_col(50)"
				local cfac = 20
				local csep = 60
			}
			
			// run byvar checker
			if 7 {
				local dual_screener = 0
				local var_screener `con' `bin' `cat'
				foreach var in `var_screener' {
					if ("`by'" == "`var'") {
						local dual_screener = 1
					}
				}
				if (`dual_screener' == 1) {
					noi di as error "ERROR: The stratifying variable should not be inputted as table 1 variable"
					noi di in g " "
					exit
				}
			}
			
			// get title line and total N
			if 6 {
				noi di in g "`title'"
				ind_translator, row(`erc') col(`ecc')
				putexcel ${ul_cell} = "`title'"
				noi di "N=" "`c(N)'"
				local erc = `erc' + 1
				${ind}
				putexcel ${ul_cell} = "N=`c(N)'"
			}
			
			// deal with byvar
			local by01 = 1
			if ("`by'" == "") {
				// capture drop byvar_helper
				gen byvar_helper = 1
				local by byvar_helper
				local by01 = 0
			}

			// run through byvar
			if 8 {
				levelsof `by'
				local b_vals = r(levels)
				/* for now:
				if no byvar - b_vals = 1
				if byvar - b_vals = r(levels)
				*/
				// gather label information to print out byvar line
				local by_l : value label `by'
				// print out by line
				local cheader = 0
				if ("`by'" != "byvar_helper") {
					local erc = `erc' + 1
					foreach i in `b_vals' {
						local cheader = `cheader' + 1
						local ctemp = `csep' +  `cfac' * (`cheader' - 1)
						local col_s : di "_col(`ctemp')"
						local ecc = `ecc' + 1
						// detect if value label exist
						// if yes, label value i
						// if no, keep i
						if ("`by_l'" == "") {
							local val_lab : di "`i'"
						}
						else if ("`by_l'" != "") {
							local val_lab : label `by_l' `i'
						}
						count if `by' == `i'
						local total = r(N)
						noi di `col_s'  "`val_lab'" " " "(n=`total')", _continue
						${ind}
						putexcel ${ul_cell} = "`val_lab' (n=`total')"
					}
					noi di ""
				}
				local ecc = 1
				local cheader = 0
				// get some constant for byvar
				foreach i in `b_vals' {
					count if `by'  == `i'
					local cnt`i' = r(N)
				}
			}
			
			// run through binary and categorical variable
			if 9 {
				local bincat `bin' `cat'
				foreach var in `bincat' {
					
					// print out the variable
					// first detect if variable label exist
					local var_l : variable label `var'
					if ("`var_l'" == "") {
						local var_lab : di "`var'"
					}
					else if ("`var_l'" != "") {
						local var_lab : di "`var_l'"
					}
					// then detect if value label exist
					local val_l01 = 0
					local val_l : value label `var'
					if ("`val_l'" != "") {
						local val_l01 = 1
					}
					else if ("`val_l'" == "") {
						local val_l01 = 0
					}
					noi di "`var_lab'" ", n(%)"
					local erc = `erc' + 1
					${ind}
					putexcel ${ul_cell} = "`var_lab', n(%)"
					// print out each value line
					levelsof `var'
					local var_levels = r(levels)
					foreach j in `var_levels' {
						// zero out column counter to ensure columns align appropriately
						local cheader = 0
						if (`val_l01' == 1) {
							local val_lab : label `val_l' `j'
						}
						else if (`val_l01' == 0) {
							local val_lab : di "`j'"
						}
						// print j value
						noi di _col(4) "`val_lab'", _continue
						local erc = `erc' + 1
						${ind}
						putexcel ${ul_cell} = "    `val_lab'"
						// count and percentage
						foreach k in `b_vals' {
							count if `var' == `j' & `by' == `k'
							local cnt = r(N)
							local per = `cnt' / `cnt`k'' * 100
							// assemble count and per
							local cp : di "`cnt'(" %2.1f `per' ")"
							// print out cnt and per
							local cheader = `cheader' + 1
							local ctemp = `csep' +  `cfac' * (`cheader' - 1)
							local col_s : di "_col(`ctemp')"
							noi di `col_s' "`cp'", _continue
							local ecc = `ecc' + 1
							${ind}
							putexcel ${ul_cell} = "`cp'"
						}
						noi di ""
						local ecc = 1
					}
				}
				
				// run through continuous variable
				if 10 {
					foreach var in `con' {
						// print out the variable
						// first detect if variable label exist
						local var_l : variable label `var'
						if ("`var_l'" == "") {
							local var_lab : di "`var'"
						}
						else if ("`var_l'" != "") {
							local var_lab : di "`var_l'"
						}
						// no need to detect value label since it is continuous
						noi di "`var_lab'" ", median[IQR]", _continue
						local erc = `erc' + 1
						${ind}
						putexcel ${ul_cell} = "`var_lab', median[IQR]"
						local cheader = 0
						// loop through byvar is enough
						foreach k in `b_vals' {
							local cheader = `cheader' + 1
							sum `var' if `by' == `k', detail
							local med = r(p50)
							local lq = r(p25)
							local hq = r(p75)
							local m_iqr : di %2.1f `med' "[" %2.1f `lq' ", " %2.1f `hq' "]"
							local ctemp = `csep' + `cfac' * (`cheader' - 1)
							local col_s : di "_col(`ctemp')"
							noi di `col_s' "`m_iqr'", _continue
							local ecc = `ecc' + 1
							${ind}
							putexcel ${ul_cell} = "`m_iqr'"
						}
						noi di ""
						local ecc = 1
					}
				}
			}
			
			// missingness
			if ("`missingness'" == "missingness") {
				noi di ""
				local erc = `erc' + 1
				noi di in g "Missingness Information: "
				local erc = `erc' + 1
				local ecc = 1
				${ind}
				putexcel ${ul_cell} = "Missingness Information: "
				local mis_var `bin' `cat' `con'
				foreach var in `mis_var' {
					// display variable name
					local var_l : variable label `var'
					if ("`var_l'" == "") {
						local var_lab : di "`var'"
					}
					else if ("`var_l'" != "") {
						local var_lab : di "`var_l'"
					}
					noi di "`var_lab'", _continue
					local erc = `erc' + 1
					local ecc = 1
					${ind}
					putexcel ${ul_cell} = "`var_lab'"
					// display missingness
					count if missing(`var')
					local mis = r(N)
					local mis_per = `mis' / `c(N)' * 100
					local mis_per : di %3.2f `mis_per' "% missing"
					noi di _col(`csep') "`mis_per'"
					local ecc = `ecc' + 1
					${ind}
					putexcel ${ul_cell} = "`mis_per'"
				}
			}
		
		capture restore
		
		}
		
	end
}
*/

*! NHANES Dataset Fast Creation
*! By Zhenghao(Vincent) Jin and Abimereki Muzaale

qui {
	
	capture program drop nhanes_fena
	program define nhanes_fena
	
		syntax , [ys(int 1999) ye(int 999999) ex(numlist) ds(int 0) format(int 0) timeout(int 1000) help mort inf(int 99999) pro s2017]
		
		qui {
			
			global display : di "noi di"
			
			// check if in program mode
			if ("`pro'" == "pro") {
				
				// modify all checkers to 1 to proceed automatically
				// substitute the macro to turn off confirmation
				global display : di "capture"
				global confirmation : di "1"
				
			}
			
			
			if 1 { // basic checks
				
				local op_list : di substr("`0'", 2, .)
				
				// check ys
				if ((`ys' < 1988) | (inrange(`ys', 1995, 1998)) | (`ys' > 2020)) {
					noi di as error "************************ERROR***************************"
					noi di as error "*******No Data Available For Requested Start Year*******"
					noi di as error "********************************************************"
					exit
				} 
				
				//check if ds is in range
				if !(inrange(`ds', 0, 4)) {
					
					noi di as error "************************ERROR***************************"
					noi di as error "*********No Data Available For Requested Dataset********"
					noi di as error "********************************************************"
					exit
					
				}
				
				// replace ye to default value
				if (`ye' == 999999) {
					local ye = `ys' + 1
				}
				
				// check if ye is greater than ys
				if !(`ye' > `ys') {
					noi di as error "************************ERROR***************************"
					noi di as error "******Requested End Year is Smaller Than Start Year*****"
					noi di as error "********************************************************"
					exit
				}
				
				// check ye
				if ((`ye' < 1988) | (inrange(`ye', 1996, 1999)) | (`ye' > 2021)) {
					noi di as error "************************ERROR***************************"
					noi di as error "*******No Data Available For Requested End Year*********"
					noi di as error "********************************************************"
					exit
				} 
				
				// modify ys for ys that starts in second year
				if (`ys' > 1998 & mod(`ys', 2) == 0) {
					local ys = `ys' - 1

					noi di as error "WARNING: Start Year Automatically Adjusted To `ys', Since Start Year Should Be An Uneven Year"

				}
				
				// modify ys to later years if requested diet or questionnaire dataset_counter
				// and ye is later than NHANES III years
				if (inrange(`ys', 1988, 1994) & (inlist(`ds', 3, 4))) {
					
					if (`ye' < 1999) {
						noi di as error "***********************ERROR*****************************"
						noi di as error "**NHANES III Data Does Not Contain Requested Information*"
						noi di as error "******************For Requested Start Year***************"
						noi di as error "*********************************************************"
						exit
					} 
					else {

						noi di as error "WARNING: NHANES III Data Does Not Contain Requested Information For Requested Start Year, Start Year Automatically Changed To 1999"

						local ys = 1999
						if (`ye' == 1999) {
							local ye = 2000
						}
					} 
					
				}
				
				// check if output format is in list
				/*
				0 - dta
				1 - excel
				2 - csv
				3 - sasxport5
				4 - sasxport8
				5 - text
				*/
				if !(inlist(`format', 0, 1, 2, 3, 4, 5)) {
					noi di as error "************************ERROR***************************"
					noi di as error "*****************Unknown Output Format******************"
					noi di as error "********************************************************"
					exit
				}
				
				// check income inflation year
				if (`inf' != 99999 & !inrange(`inf', 1913, 2023)) {
					noi di as error "************************ERROR***************************"
					noi di as error "***********No CPI Information For Year `inf'************"
					noi di as error "********************************************************"
					exit
				}
				
				if (`inf' != 99999 & `ds' != 1) {
					noi di as error "WARNING: Inflation Adjustment Will NOT Be Executed As Requested Dataset Does Not Contain Income Information"
				}
				
				// check if exclusion year is in NHANES III
				foreach i in `ex' {
					if ((inrange(`i', 1988, 1994)) & (`i' > `ys')) {

						noi di as error "WARNING: Exclusion For Year `i' Will NOT Be Executed Due To The Request Of NHANES III DATA"

					}
				}
				
				// warning for NHANES III then modify ys to 1988
				if (inrange(`ys', 1988, 1994)) {

					noi di as error "WARNING: Data For Year Between 1988 To 1994 Requested, NHANES III Data For That Period Will Be Loaded"

					local ys = 1988
				}
				
				// warning for time gap
				if (`ys' < 1995 & `ye' > 1999) {

					noi di as error "WARNING: No Data Between 1995 And 1999 Available"

				}
				
				// warning for pre-pandemic
				if ((`ys' < 2017 & `ye' > 2017) | inrange(`ys', 2017, 2020)) {
					
					if ("`s2017'" == "s2017") {
						noi di "WARNING: User Requested Data for Survey Cycle 2017-2018, Pre-Pandemic Data Will Not Be Loaded. Request End Year Will Be Modified To 2018"
						local ye = 2018
					}
					noi di as error "WARNING: Data For Year Between 2017 To 2020 Requested, NHANES Pre-Pandemic Data For That Period Will Be Load"

				}
				
				// warning for 2020
				if (inrange(2020, `ys', `ye')) {

					noi di as error "WARNING: Only Data Until March Was Included For 2020"

				}
				
				// warning for mortality
				if ((inrange(2019, `ys', `ye') | (inrange(2020, `ys', `ye')))) {
					
					noi di as error "WARNING: No mortality information available for 2019 to 2020."
					
				}
				
				// warning for harmonization of NHANES III and later datasets
				local har = 0
				if ((inrange(`ys', 1988, 1994)) & (`ye' > 1999)) {
					
					noi di as error "WARNING: " ustrtitle("Automatic harmonization will be performed to aggregate ") "NHANES III " ustrtitle("variables and later ") "NHANES " ustrtitle("dataset variables")
					local har = 1
					
				}
				
				// current ds:
				/* 
				base          1
				demographic   2
				exam          3
				diet          4
				questionnaire 5
				
				*/
				local ds_helper base demographic exam diet questionnaire
				tokenize `ds_helper'
				local ds = `ds' + 1
				macro drop ds_helper2
				global ds_helper2 : di "``ds''"
				if ("`mort'" == "mort") {
					global ds_helper3 : di "${ds_helper2}" " with mortality"
				} 
				else {
					global ds_helper3 : di "${ds_helper2}"
				}
				
				// check if help option is called
				if ("`help'" == "help") {
					
					noi nhanes1_helper
					
					noi di "Continue the inquiry? (Y/N)", _request(help_ter)
					if !((strupper(substr("${help_ter}", 1, 1)) == "Y") | (substr("${help_ter}", 1, 1) == "1")) {
						noi di as error "***********************WARNING**************************"
						noi di as error "***********User Requested To Abort Creation*************"
						noi di as error "********************************************************"
						exit
					}
					
				}
				
			}
			
			if 2 { // print out summary for dataset creation and ask for confirmation
				
				// also prepare a list for exclusion to be tested
				// screen if ex_helper contains even years
				macro drop ex_helper
				macro drop ex_helper2
				foreach i in `ex' {
					local disp_helper : di "`disp_helper'" " " `i'
					if (`i' > 1998 & mod(`i', 2) == 0) {
						local ex_helper = `i' - 1
					}
					else {
						local ex_helper = `i'
					}
					global ex_helper2 : di "`ex_helper'" ", " "${ex_helper2}"
				}
				global ex_helper2 : di substr("${ex_helper2}", 1, strlen("${ex_helper2}") - 2)

				noi di as text " "
				noi di "NHANES Dataset Creation Summary"
				noi di "Requested Start Year: `ys'"
				noi di "Requested End Year: `ye'"
				if ("`disp_helper'" != "") {
					noi di "Requested Year To Be Excluded: `disp_helper'"
				}
				else {
					noi di "Requested Year To Be Excluded: None"
				}
				noi di "Requested Dataset Information: ${ds_helper3}"
				noi di "Current Saving Directory: `c(pwd)'"
				noi di "Timeout Setting: `timeout'"
				${display} "Please Confirm To Proceed (Y/N)", _request(confirmation)
				if !((strupper(substr("${confirmation}", 1, 1)) == "Y") | (substr("${confirmation}", 1, 1) == "1")) {
					noi di as error "***********************WARNING**************************"
					noi di as error "***********User Requested To Abort Creation*************"
					noi di as error "********************************************************"
					exit
				}	
				set timeout1 `timeout'
			}
			
			if 3 { // pulling dataset
				
				local ye_helper = `ye' - 1
				forvalues i = `ys'(1)`ye_helper' {
						if ("`ex'" != "") {
							if !(inlist(`i', ${ex_helper2})) {
								local year_helper `i' `year_helper'
							}
						}
						else {
							local year_helper `i' `year_helper'
						}
				}

				foreach i in `year_helper' {
					if (`i' > 1998 & mod(`i', 2) != 0) {
						local ys_2 `i' `ys_2'
					}
					else if (`i' < 1995 & `i' > 1987) {
						local ys_1 `i' `ys_1'
					}
				}

				local dataset_counter = 0
				
				// loading the NHANES III Data
				if ("`ys_1'" != "") {
					
					local dataset_counter = `dataset_counter' + 1
					
					noi di "Loading NHANES III Data For 1988-1994...................", _continue
					
					macro drop nh3
					global nh3 https://wwwn.cdc.gov/nchs/data/nhanes3/1a/
					
					// base dataset
					*** PERHAPS CONDENSE DS CONDITIONS TO ONE MACRO ****
					*** WORK ON THIS LATER ***
					if (`ds' == 1) {
						noi infix seqn 1-5 ///
									dmarethn 12 ///
									dmaracer 13 ///
									dmaethnr 14 ///
									hssex 15 ///
									hsageir 18-19 ///
									using ${nh3}adult.DAT, clear
						tempfile demo1
						save `demo1'
						
					}
					
					// demographic dataset
					if (`ds' == 2) {
						
						noi infix seqn 1-5 ///
									dmpstat 11 /// 
									dmarethn 12 ///
									dmaethnr 14 ///
									hssex 15 ///
									hsageir	18-19 ///
									hfa8r 1256-1257 ///
									hff19r 1409-1410 ///
									sdpphase 42 ///
									using ${nh3}adult.DAT, clear
													
					}
					
					// exam dataset
					if (`ds' == 3) {
						
						infix seqn 1-5 pepmnk1r 1423-1425 pepmnk5r 1428-1430 bmpbmi 1524-1527 /// 
						 using ${nh3}exam.dat, clear
						tempfile exam
						save `exam'

						infix seqn 1-5 ghp 1861-1864 ubp 1965-1970 urp 1956-1960 sgpsi 1761-1765 /// 
						 cep 1784-1787 using ${nh3}lab.dat, clear
						tempfile lab
						save `lab'
						 
						infix seqn 1-5 hae4d2 1605 had1 1561 had6 1568 had10 1578 hak1 1855 /// 
						 hae2 1598 hae5a 1610 hat1met 2393-2395 har1 2281 ///
						 using ${nh3}adult.DAT, clear
							 
						tempfile qa 
						save `qa'  
						 
						use `exam', clear 
						merge 1:1 seqn using `lab', nogen
						merge 1:1 seqn using `qa', nogen 
						
						noi di "(`c(N)' observations read)"
						
					}					
					
					// save to a tempfile for future appending
					tempfile ds`dataset_counter'
					capture drop year_start
					gen year_start = 1988
					save `ds`dataset_counter'', replace

				}
				
				// loading NHANES Data in other years
				// having prepan_counter to ensure 2017-2020 only loaded once
				if ("`ys_2'" != "") {
					
					local prepan_counter = 0
					
					macro drop nhanes
					global nhanes "https://wwwn.cdc.gov/Nchs/Nhanes"
					
					foreach i of numlist `ys_2' {
						
						local ye_helper2 = `i' + 1
						
						local name_helper = `i' - 1999
						if (`name_helper' > 0) {
							local name_helper2 = 2 + ((`name_helper' - 2) / 2)
							tokenize "`c(ALPHA)'"
							local name_helper3 : di "_" "``name_helper2''"
							if ("`s2017'" != "s2017") {
								if (("`name_helper3'" == "_J") | ("`name_helper3'" == "_K")) {
									local name_helper3 : di "P_"
								}
							}
						}

						if (!(inrange(`i', 2017, 2020)) | (inrange(`i', 2017, 2020) & `prepan_counter' == 0)) {
								
							local dataset_counter = `dataset_counter' + 1
							if (inrange(`i', 2017, 2020)) {
								local prepan_counter = `prepan_counter' + 1
							}
							
							if (`ds' == 1) {
								
								local ds_name : di "DEMO`name_helper3'"
								local period : di "`i'" "-" "`ye_helper2'"
								if ("`s2017'" != "s2017") {
									if (inrange(`i', 2017, 2020)) {
										local ds_name : di "`name_helper3'DEMO"
										local period : di "2017-2020"
									}
								}
								noi di "Loading NHANES Data For " "`period'...................", _continue
								import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'.XPT", clear
								tempfile ds`dataset_counter'
								keep seqn ///
										riagendr ///
										ridageyr ///
										ridreth1
								capture drop year_start
								gen year_start = `i'
								save `ds`dataset_counter'', replace
								noi di "(" "`c(N)'" " " "observations read)"
								
							}
							
							if (`ds' == 2) {
								
								local ds_name : di "DEMO`name_helper3'"
								local period : di "`i'" "-" "`ye_helper2'"
								if ("`s2017'" != "s2017") {
									if (inrange(`i', 2017, 2020)) {
										local ds_name : di "`name_helper3'DEMO"
										local period : di "2017-2020"
									}
								}
								noi di "Loading NHANES Data For " "`period'...................", _continue
								import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'.XPT", clear
								tempfile ds`dataset_counter'
								capture drop year_start
								gen year_start = `i'
								drop wtm* wti*
								save `ds`dataset_counter'', replace
								noi di "(" "`c(N)'" " " "observations read)"
								
							}
							
							if (`ds' == 3) {
								
								// 1999
								local DATA1 BPX BMX LAB10 LAB13 LAB13AM LAB16  LAB18	
								// 2001 2003
								local DATA2 BPX BMX L10 L13 L13AM  L16    L40  
								// 2005+
								local DATA3 BPX BMX GHB   ALB_CR BIOPRO TCHOL TRIGLY HDL
								// 2017-2020.3
								local DATA4 BPXO BMX GHB   ALB_CR BIOPRO TCHOL TRIGLY HDL
								
								if (`i' == 1999) {
									local ex_name `DATA1'
								} 
								else if (inlist(`i', 2001, 2003)) {
									local ex_name `DATA2'
								}
								else if ((inrange(`i', 2004,9999)) & !(inrange(`i', 2017, 2020))) { // leave as 9999 for future datasets
									local ex_name `DATA3'
								}
								else if (inrange(`i', 2017, 2020)) {
									local ex_name `DATA4'
								}
								
								local period : di "`i'" "-" "`ye_helper2'"
								if ("`s2017'" != "s2017") {
									if (inrange(`i', 2017, 2020)) {
										local period : di "2017-2020"
									}
								}
								noi di "Loading NHANES Data For " "`period'...................", _continue
								
								// combine to get dataset name
								local j_helper = 0
								foreach j in `ex_name' {
									
									local j_helper = `j_helper' + 1

									local ds_name : di "`j'" "`name_helper3'"

									if ("`s2017'" != "s2017") {
										if (inrange(`i', 2017, 2020)) {
											local ds_name : di "`name_helper3'" "`j'"
										}
									}
									
									import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'.XPT", clear
									tempfile ex_`j_helper'
									save `ex_`j_helper'', replace
									
								}
								
								// merge exam and lab data together
								use `ex_1', clear

								forvalues k = 2/`j_helper' {
									
									merge 1:1 seqn using `ex_`k'', gen(merge`k')
									
								}
								
								// save each survey year dataset
								tempfile ds`dataset_counter'
								capture drop year_start
								gen year_start = `i'
								save `ds`dataset_counter'', replace
								noi di "(" "`c(N)'" " " "observations read)"
								
							}

							if (`ds' == 4) {
								
								// 1999 & 2001 DRXTOT
								// 2003+ DR1TOT DR2TOT
								

								local period : di "`i'" "-" "`ye_helper2'"

								if ("`s2017'" != "s2017") {
									if (inrange(`i', 2017, 2020)) {
										local period : di "2017-2020"
									}
								}
								noi di "Loading NHANES Data For " "`period'...................", _continue
								
								if ((`i' == 1999) | (`i' == 2001)) {
									local ds_name : di "DRXTOT`name_helper3'"
									import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'.XPT", clear
								} 
								else if (inrange(`i', 2017, 2020)) {
									forvalues j = 1/2 {
										if ("`s2017'" != "s2017") {										
											local ds_name : di "`name_helper3'" "DR" "`j'" "TOT"
										}
										else if ("`s2017'" == "s2017") {
											local ds_name : di "DR" "`j'" "TOT" "`name_helper3'"
										}
										import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'", clear
										
										tempfile diet_`j'
										save `diet_`j'', replace
									}
									use `diet_1', clear
									merge 1:1 seqn using `diet_2'
								}
								else if (`i' > 2002) {
									forvalues j = 1/2 {
										local ds_name : di "DR" "`j'" "TOT" "`name_helper3'"
										import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'", clear
										
										tempfile diet_`j'
										save `diet_`j'', replace
									}
									use `diet_1', clear
									merge 1:1 seqn using `diet_2'
								}
								
								tempfile ds`dataset_counter'
								capture drop year_start
								gen year_start = `i'
								save `ds`dataset_counter'', replace
								noi di "(" "`c(N)'" " " "observations read)"
							}
							
							if (`ds' == 5) {
								
								// 1999
								local DATA1 ALQ DIQ KIQ   BPQ PAQ SMQ MCQ BPQ
								// 2001+
								local DATA2 ALQ DIQ KIQ_U BPQ PAQ SMQ MCQ BPQ
								
								if (`i' == 1999) {
									local qs_name `DATA1'
								}
								else if ((inrange(`i', 2001,9999))) { // leave as 9999 for future datasets
									local qs_name `DATA2'
								}
								
								local period : di "`i'" "-" "`ye_helper2'"
								if ("`s2017'" != "s2017") {
									if (inrange(`i', 2017, 2020)) {
										local period : di "2017-2020"
									}
								}
							
								noi di "Loading NHANES Data For " "`period'...................", _continue
								
								// combine to get dataset name
								local j_helper = 0
								foreach j in `qs_name' {
									
									local j_helper = `j_helper' + 1
									
									local ds_name : di "`j'" "`name_helper3'"
									
									if ("`s2017'" != "s2017") {
										if (inrange(`i', 2017, 2020)) {
											local ds_name : di "`name_helper3'" "`j'"
										}
									}
									
									import sasxport5 "$nhanes/`i'-`ye_helper2'/`ds_name'.XPT", clear
									tempfile qs_`j_helper'
									save `qs_`j_helper'', replace
									
								}
								
								// merge exam and lab data together
								use `qs_1', clear

								forvalues k = 2/`j_helper' {
									
									merge 1:1 seqn using `qs_`k'', gen(merge`k')
									
								}
								
								// save each survey year dataset
								tempfile ds`dataset_counter'
								capture drop year_start
								gen year_start = `i'
								save `ds`dataset_counter'', replace
								noi di "(" "`c(N)'" " " "observations read)"
								
							}
						
						}
						
					}
					
				}
				
				local ds_max = `dataset_counter' - 1
				
				noi di "Appending All Datasets..............................", _continue
				forvalues i = 1/`ds_max' {
					
					append using `ds`i''
					
				}
				
				compress
				noi di "Done"
				tempfile master_dataset
				save `master_dataset', replace
		
				if ("`mort'" == "mort") {
					
					local mort_counter = 0
					
					global nchs https://ftp.cdc.gov/pub/Health_Statistics/NCHS/
					global linkage datalinkage/linked_mortality/
					capture macro drop nh3
					global nh3 NHANES_III
					global mort_end _MORT_2019_PUBLIC.dat
					
					global mort_var ///
							 seqn 1-6 ///
							 eligstat 15 ///
							 mortstat 16 ///
							 ucod_leading 17-19 ///
							 diabetes 20 ///
							 hyperten 21 ///
							 permth_int 43-45 ///
							 permth_exm 46-48
					
					noi di "Loading Mortality Information.......................", _continue
					
					if ("`ys_1'" != "") {
						
						local mort_counter = `mort_counter' + 1
						
						infix ${mort_var} using ${nchs}${linkage}${nh3}${mort_end}, clear
						// replace seqn=-1*seqn
						tempfile mort`mort_counter'
						save `mort`mort_counter''
						
					}
					
					if ("`ys_2'" != "") {
						
						foreach i of numlist `ys_2' {
							if !(inrange(`i', 2019, 2020)) {
								local mort_counter = `mort_counter' + 1
								local ye_helper2 = `i' + 1
								local nhanes NHANES_`i'_`ye_helper2'
								infix ${mort_var} using ${nchs}${linkage}`nhanes'${mort_end}, clear
								tempfile mort`mort_counter'
								save `mort`mort_counter''
							}
						}
						
					}
					
					local mort_max = `mort_counter' - 1
					forvalues i = 1/`mort_max' {
						append using `mort`i''
					}
					
					capture lab def premiss .z "Missing"
					capture lab def eligfmt 1 "Eligible" 2 "Under age 18, not available for public release" 3 "Ineligible" 
					capture lab def mortfmt 0 "Assumed alive" 1 "Assumed deceased" .z "Ineligible or under age 18"
					capture lab def flagfmt 0 "No - Condition not listed as a multiple cause of death" ///
									  1 "Yes - Condition listed as a multiple cause of death"	///
									  .z "Assumed alive, under age 18, ineligible for mortality follow-up, or MCOD not available"
					capture lab def qtrfmt 1 "January-March" ///
									 2 "April-June" ///
									 3 "July-September" ///
									 4 "October-December" ///
									 .z "Ineligible, under age 18, or assumed alive"
					capture lab def dodyfmt .z "Ineligible, under age 18, or assumed alive"
					capture lab def ucodfmt 1 "Diseases of heart (I00-I09, I11, I13, I20-I51)"                           
					capture lab def ucodfmt 2 "Malignant neoplasms (C00-C97)"                                            , add
					capture lab def ucodfmt 3 "Chronic lower respiratory diseases (J40-J47)"                             , add
					capture lab def ucodfmt 4 "Accidents (unintentional injuries) (V01-X59, Y85-Y86)"                    , add
					capture lab def ucodfmt 5 "Cerebrovascular diseases (I60-I69)"                                       , add
					capture lab def ucodfmt 6 "Alzheimer's disease (G30)"                                                , add
					capture lab def ucodfmt 7 "Diabetes mellitus (E10-E14)"                                              , add
					capture lab def ucodfmt 8 "Influenza and pneumonia (J09-J18)"                                        , add
					capture lab def ucodfmt 9 "Nephritis, nephrotic syndrome and nephrosis (N00-N07, N17-N19, N25-N27)"  , add
					capture lab def ucodfmt 10 "All other causes (residual)"                                             , add
					capture lab def ucodfmt .z "Ineligible, under age 18, assumed alive, or no cause of death data"      , add
					
					
					replace mortstat = .z if mortstat >=.
					replace ucod_leading = .z if ucod_leading >=.
					replace diabetes = .z if diabetes >=.
					replace hyperten = .z if hyperten >=.
					replace permth_int = .z if permth_int >=.
					replace permth_exm = .z if permth_exm >=.
					
					label var seqn "NHANES Respondent Sequence Number"
					label var eligstat "Eligibility Status for Mortality Follow-up"
					label var mortstat "Final Mortality Status"
					label var ucod_leading "Underlying Cause of Death: Recode"
					label var diabetes "Diabetes flag from Multiple Cause of Death"
					label var hyperten "Hypertension flag from Multiple Cause of Death"
					label var permth_int "Person-Months of Follow-up from NHANES Interview date"
					label var permth_exm "Person-Months of Follow-up from NHANES Mobile Examination Center (MEC) Date"

					label values eligstat eligfmt
					label values mortstat mortfmt
					label values ucod_leading ucodfmt
					label values diabetes flagfmt
					label values hyperten flagfmt
					label value permth_int premiss
					label value permth_exm premiss
					
					//eligibility
					drop if inlist(eligstat,2,3)
					duplicates drop 

					keep seqn mortstat permth_int permth_exm
					tempfile mort_dataset
					save `mort_dataset', replace
					
					use `master_dataset', clear
					merge 1:1 seqn using `mort_dataset', nogen
					
					//variable labels derived from wwwn.cdc.gov/nchs/nhanes/
					capture lab var seqn "Sequence number (seqn x -1 for NHANES III)"
					capture lab var dmpstat "Examinmation/interview status"
					capture lab var dmarethn "Race/ethnicity"
					capture lab var hssex "Sex"
					capture lab var hsageir "Age at interview (screener) -qty"
					capture lab var hfa8r "Education level"
					capture lab var hff19r "Total family 12 month income group"
					capture lab var pepmnk1r "Overall average K1, systolic, BP(age 5+)"
					capture lab var pepmnk5r "Overall average K5, diastolic, BP(age5+)"
					capture lab var bmpbmi "Body mass index"
					capture lab var ghp "Glycated hemoglobin: %"
					capture lab var ubp "Urinary albumin (ug/mL)"
					capture lab var urp "Urinary creatinine (mg/dL)"
					capture lab var sgpsi "serum glucose: SI (mmol/L)"
					capture lab var cep "Serum creatine (mg/dL)"
					capture lab var had1 "Ever been told you have sugar/diabetes"
					capture lab var hae2 "Doctor ever told had hypertension/HBP"
					capture lab var har1 "Have tiy snijed 100_ cigarettes in life"
					
					noi di "Done"
					
				}
				
				// harmonization process for NHANES III and other NHANES datasets
				if (`har' == 1) {

					// base - only race needs recode
					if (`ds' == 1) {
						replace riagendr = hssex if year_start == 1988
						replace ridageyr = hsageir if year_start == 1988
						replace ridreth1 = 1 if dmarethn == 3 & year_start == 1988
						replace ridreth1 = 3 if dmarethn == 1 & year_start == 1988
						replace ridreth1 = 4 if dmarethn == 2 & year_start == 1988
						replace ridreth1 = 5 if dmarethn == 4 & year_start == 1988
						rename (riagendr ridageyr ridreth1) (gender age ethn)
						
						keep seqn age gender ethn dmaracer dmaethnr
						
						label variable dmaracer "Race information for NHANES III"
						label variable dmaethnr "Ethnicity information for NHANES III"
					}
					
					// demographic 
					/* 
					seqn
					dmpstat Examination/interview status:
					1 - interviewed, not examed
					2 - interviewed, MEC-examed
					3 - interviewed, home-examed
					dmarethn - race-ethnicity
					dmaethnr - race
					hssex Sex
					hsageir age at interview
					hfa8r Highest grade
					00 never attend
					01 - 17 grades
					01 - 05 elementary
					06 - 08 middle high
					09 - 12 high school
					13 - 16 bachelor
					17 - college graduate or above
					88 blank but applicable
					99 - unknown
					hff19r income groups:
					0 - no income
					1 - less than 1000
					2 - 1999
					3 - 2999
					4 - 3999
					...
					21 - 24999
					22 - 29999
					23 - 34999
					24 - 39999
					25 - 44999
					26 - 49999
					27 - 50000 and over
					88 blank but applicable
					99 - unknown
					sdpphase phase of nhanes iii survey
					1 - phase 1
					2 - phase 2
					*/
					if (`ds' == 2) {
						
						// dmpstat
						replace ridstatr = 1 if dmpstat == 1 & year_start == 1988
						replace ridstatr = 2 if ((dmpstat == 2 | dmpstat == 3) & year_start == 1988)
						
						// hssex
						replace riagendr = hssex if year_start == 1988
						
						// hsageir
						replace ridageyr = hsageir if year_start == 1988
						
						// dmarethn
						replace ridreth1 = 1 if dmarethn == 3 & year_start == 1988
						replace ridreth1 = 3 if dmarethn == 1 & year_start == 1988
						replace ridreth1 = 4 if dmarethn == 2 & year_start == 1988
						replace ridreth1 = 5 if dmarethn == 4 & year_start == 1988
						
						// hfa8r
						/* code to dmdeduc3, dmdeduc2, dmdeduc
						dmdeduc3 - education level - children/youth 6-19:
						0 - never attened / kindergarten only
						1 - 1th grade
						...
						12 - 12th grade, no diploma
						13 - high school graduate
						14 - GED or equivalent
						15 - more than high school
						55 - less than 5th grade
						66 - less than 9th grade
						77 - refused
						99 - don't know
						
						dmdeduc2 - education - adults 20+:
						1 - less than 9th grade
						2 - 9-11th grade
						3 - high school grad / ged or equivalent
						4 - some college or aa degree
						5 - college graduate or above
						7 - refused
						9 - unknown
						
						dmdeduc - education recode:
						1 - less than high school
						2 - high school diploma
						3 - more than high school
						7 - refused
						9 - unkown
						*/
						
						replace dmdeduc3 = 0 if ((hfa8r == 0 & inrange(ridageyr, 6, 19) & year_start == 1988))
						replace dmdeduc3 = hfa8r if (inrange(hfa8r, 1, 11) & inrange(ridageyr, 6, 19) & year_start == 1988)
						replace dmdeduc3 = 13 if (hfa8r == 12 & inrange(ridageyr, 6, 19) & year_start == 1988)
						replace dmdeduc3 = 15 if (hfa8r > 12 & inrange(ridageyr, 6, 19) & year_start == 1988)
						replace dmdeduc3 = 77 if (hfa8r == 88 & inrange(ridageyr, 6, 19) & year_start == 1988)
						replace dmdeduc3 = 99 if (hfa8r == 99 & inrange(ridageyr, 6, 19) & year_start == 1988)
						
						replace dmdeduc2 = 1 if (hfa8r < 9 & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 2 if (inrange(hfa8r, 9 , 11) & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 3 if (hfa8r == 12 & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 4 if (inrange(hfa8r, 13, 15) & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 5 if (hfa8r > 15 & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 7 if (hfa8r == 88 & ridageyr > 19 & year_start == 1988)
						replace dmdeduc2 = 9 if (hfa8r == 99 & ridageyr > 19 & year_start == 1988)
						
						replace dmdeduc = 1 if (hfa8r < 12 & year_start == 1988)
						replace dmdeduc = 2 if (hfa8r == 12 & year_start == 1988)
						replace dmdeduc = 3 if (hfa8r > 12 & year_start == 1988)
						replace dmdeduc = 7 if (hfa8r == 88 & year_start == 1988)
						replace dmdeduc = 9 if (hfa8r == 99 & year_start == 1988)
						
						// hff19r - recode to indfminc
						/* temporary turned off due to vague definition of 50000+
						replace indfminc = 1 if (hff19r == 0 & year_start == 1988)
						forvalues i = 1/4 {
							/*
							999 - 4999 1-5
							5999 - 9999 6-10
							10999 - 14999 11-15
							15999 - 19999 16-20
							*/
							local min = 1 + 5 * (`i' - 1)
							local max = 0 + 5 * `i'
							replace indfminc = `i' if inrange(hff19r, `min', `max') 
						}
						
						replace indfminc = 5 if hff19r == 21
						replace indfminc = 6 if inrange(hff19r, 22, 23)
						replace indfminc = 7 if inrange(hff19r, 24, 25)
						*/
						
					}
					
				}
				
				// adjusting inflation for income
				if (`inf' != 99999 & `ds' == 2) {
				
					noi di "Adjusting income for inflation......................", _continue
					global inf_yr = `inf'
					tempfile income
					save `income', replace
		
					// use "https://github.com/jhurepos/projectbeta/blob/main/nh_projectbeta_5/yearly_cpi", clear
					use yearly_cpi, clear
					capture drop cpi_helper
					gen cpi_helper = cpi if year_start == ${inf_yr}
					capture drop cpi_t
					egen cpi_t = min(cpi_helper)
					drop cpi_helper
					capture drop ifr
					gen ifr = cpi_t / cpi
					keep  year_start ifr
					tempfile cpi
					save `cpi', replace
					
					use `income', replace
					joinby year_start using `cpi', unmatched(none)

					
					// switch categories to numeric incomes
					capture drop income_n
					gen income_n = .
					/*
					indfminc:
					1 - 0-4999
					2 - 5000-9999
					3 - 10000-14999
					4 - 15000-19999
					5 - 20000-24999
					6 - 25000-34999
					7 - 35000-44999
					8 - 45000-54999
					9 - 55000-64999
					10 - 65000-74999
					11 - 75000
					12 - 20000
					13 - 20000
					treat > 20000 as 20001
					use 10000 for < 20000 assuming normal distribution
					*/
					local inc_vars indhhinc indhhin2
					foreach r in `inc_vars' {
						capture forvalues i = 1/6 {
							local inc = 5000 * (`i' - 1)
							capture replace income_n = `inc' if  `r' == `i'
						}
						capture forvalues i = 7/11 {
							local inc = 35000 + (`i' - 7) * 10000
							capture replace income_n = `inc' if  `r' == `i'
						}
						capture replace income_n = 20000 if  `r' == 12
						capture replace income_n = 10000 if  `r' == 13
						capture replace income_n = 7777777 if  `r' == 77
						capture replace income_n = 9999999 if  `r' == 99
						capture replace income_n = 75000 if `r' == 14
						capture replace income_n = 100000 if `r' == 15
					}
					/*
					hff19r income groups:
					0 - no income
					1 - less than 1000
					2 - 1999
					3 - 2999
					4 - 3999
					...
					21 - 24999
					22 - 29999
					23 - 34999
					24 - 39999
					25 - 44999
					26 - 49999
					27 - 50000 and over
					88 blank but applicable
					99 - unknown
					using 500 for 0 - 1000 assuming a normal distribution
					*/
					capture replace income_n = 0 if hff19r == 0
					capture replace income_n = 500 if hff19r == 1
					capture forvalues i = 2/21 {
						capture local inc = 1000 * (`i' - 1)
						capture replace income_n = `inc' if hff19r == `i'
					}
					capture forvalues i = 22/27 {
						capture local inc = 25000 + 5000 * (`i' - 22)
						capture replace income_n = `inc' if hff19r == `i'
					}
					capture replace income_n = 7777777 if hff19r == 88
					capture replace income_n = 9999999 if hff19r == 99
					
					capture drop inf_n
					gen inf_n = ifr * income_n
					
					
					// recode back - using new codes
					/*
					indfminc:
					1 - 0-4999
					2 - 5000-9999
					3 - 10000-14999
					4 - 15000-19999
					5 - 20000-24999
					6 - 25000-34999
					7 - 35000-44999
					8 - 45000-54999
					9 - 55000-64999
					10 - 65000-74999
					11 - 75000
					12 - 20000
					13 - 20000
					*/
					capture drop income_adjusted
					gen income_adjusted = .

					forvalues i = 1/5 {
						local min = 5000 * (`i' - 1)
						local max = 5000 * `i' - 1
						replace income_adjusted = `i' if inrange(inf_n, `min', `max')
					}
					forvalues i = 6/10 {
						local min = 25000 + 10000 * (`i' - 6)
						local max = 35000 + 10000 * (`i' - 6) - 1
						replace income_adjusted = `i' if inrange(inf_n, `min', `max')
					}
					
					replace income_adjusted = 14 if (inrange(inf_n, 75000, 99999))
					replace income_adjusted = 15 if (inf_n > 100000 & inf_n != .)
					replace income_adjusted = 12 if (income_n == 20001 & inf_n > 19999) | (income_n == 10000 & inf_n > 19999)
					replace income_adjusted = 13 if (income_n == 20001 & inf_n < 20001) | (income_n == 10000 & inf_n < 20001)
					replace income_adjusted = 77 if (income_n == 7777777)
					replace income_adjusted = 99 if income_n == 9999999
					
					// capture drop inf_n 
					// capture drop income_n
					// capture drop ifr
					
					noi di "Done"
					
				}
				
				// labeling Variables
				if inrange(`ds', 1, 2) {
					
					noi di "Labeling Demographic Variables......................", _continue
					
					if (`ds' == 1) {
						
						// gender
						capture label drop gender
						label define gender 1 "Male" 2 "Female"
						capture label values gender gender
						
						// ethn
						capture label drop ethn
						label define ethn 1 "Mexican American" 2 "Other Hispanic" ///
							3 "Non-Hispanic White" 4 "Non-Hispanic Black" 5 "Other Race - Including Multiracial"
						capture label values ethn ethn
						
					}
					
					if (`ds' == 2) {
						
						// gender
						capture label drop gender
						label define gender 1 "Male" 2 "Female"
						capture label values gender gender
						
						// ethn
						capture label drop ethn
						label define ethn 1 "Mexican American" 2 "Other Hispanic" ///
							3 "Non-Hispanic White" 4 "Non-Hispanic Black" 5 "Other Race - Including Multiracial"
						capture label values ethn ethn
						
						// veteran
						capture label drop veteran
						label define veteran 1 "Yes" 2 "No" 7 "Refused" 9 "Don't Know"
						capture label values dmqilit veteran
						
						// country of birth
						capture label drop birth
						label define birth 1 "50 US States/Washington D.C." ///
							2 "Mexico" 3 "Elsewhere" 7 "Refused" 9 "Don't Know"
						capture label values dmdborn birth
						
						// citizenship
						capture label drop citi
						label define citi 1 "Citizen By Birht or Naturalization" ///
							2 "Not a Citizen of the US" 7 "Refused" 9 "Don't Know"
						capture label values dmdcitzn citi
						
						// length of time in US
						capture label drop stay
						label define stay ///
							1 "<1 year" ///
							2 "1-5 years" ///
							3 "5-10 years" ///
							4 "10-15 years" ///
							5 "15-20 years" ///
							6 "20-30 years" ///
							7 "30-40 years" ///
							8 "40-50 years" ///
							9 ">50 years" ///
							77 "Refused" ///
							88 "Could Not Determine" ///
							99 "Don't Know"
						capture label values dmdyrsus stay
						
						// education
						capture label drop educ
						label define educ ///
							1 "Less Than High School" ///
							2 "High School Diploma (Including GED)" ///
							3 "More Than High School" ///
							7 "Refused" ///
							9 "Don't Know"
						capture label values dmdeduc educ
						
						// marital status
						capture label drop marital
						label define marital ///
							1 "Married" ///
							2 "Widowed" ///
							3 "Divorced" ///
							4 "Separated" ///
							5 "Never Married" ///
							6 "Living with Partner" ///
							77 "Refused" ///
							99 "Don't Know"
							
						// income
						capture label drop income
						label define income ///
							1 "0-4999" ///
							2 "5000-9999" ///
							3 "10000-14999" ///
							4 "15000-19999" ///
							5 "20000-24999" ///
							6 "25000-34999" ///
							7 "35000-44999" ///
							8 "45000-54999" ///
							9 "55000-64999" ///
							10 "65000-74999" ///
							11 ">75000" ///
							12 ">20000" ///
							13 "<20000" ///
							77 "Refused" ///
							99 "Don't Know"
						capture label values income_adjusted income
					}
					
					noi di "Done"
				}
				
				noi di "Saving Dataset......................................", _continue
				/*
				0 - dta
				1 - excel
				2 - csv
				3 - sasxport5
				4 - sasxport8
				5 - text
				*/
				if (`format' == 0) {
					save NHANES_${ds_helper2}_`ys'_`ye', replace
				}
				else if (`format' == 1) {
					export excel using NHANES_${ds_helper2}_`ys'_`ye', replace
				}
				else if (`format' == 2) {
					export delimited using NHANES_${ds_helper2}_`ys'_`ye'.csv, replace
				}
				else if (`format' == 3) {
					export sasxport5 NHANES_${ds_helper2}_`ys'_`ye', replace
				}
				else if (`format' == 4) {
					export sasxport8 NHANES_${ds_helper2}_`ys'_`ye', replace
				}
				else if (`format' == 5) {
					outfile using NHANES_${ds_helper2}_`ys'_`ye', replace
					outfile using NHANES_${ds_helper2}_`ys'_`ye', replace dictionary
				}
				noi di "Dataset Saved!"
				
			}
			
		}
	end
	
	capture program drop nhanes1_helper
	program define nhanes1_helper
	
		qui {
			
			cls
			noi di in g "You have entered the help option of nhanes1 program"
			noi di "Please specify the help information you would like to access: "
			noi di "0 - For general information"
			noi di "1 - For ys option"
			noi di "2 - For ye option"
			noi di "3 - For ex option"
			noi di "4 - For ds option"
			noi di "5 - For format option"
			noi di "6 - For timeout option"
			noi di "7 - For mort option"
			noi di "To request multiple information at the same time"
			noi di "Please using space to separate each number"
			noi di "(e.g. 0 1 2 3 - Accessing information for general, ys, ye, ex at the same time)"
			noi di "If you would like to terminate the help option, please enter 99", _request(help_list)
			if ("${help_list}" == "") {
				
				local option
				
			}
			else if (strpos("${help_list}", "99") != 0){
				
				noi di "The help option is terminated."
				/*
				noi di "Please confirm to proceed (Y/N)"
				noi di "Current start year: " "`ys'"
				noi di "Current end year: " "`ye'", _request(help_terminator)
				if !((strupper(substr("${help_terminator}", 1, 1)) == "Y") | (substr("${help_terminator}", 1, 1) == "1")) {
					noi di as error "***********************WARNING**************************"
					noi di as error "***********User Requested To Abort Creation*************"
					noi di as error "********************************************************"
					exit
				}
				*/
				exit
				
			}
			else {
				local help_num
				foreach i in ${help_list} {
					if (inrange(`i', 0, 7)) {
						local help_num : di "`help_num'" " " "`i'"
					}
				}
				local option `help_num'
				
				/* temporary closure for structural change
				noi di "The help option is terminated."
				noi di "Please confirm to proceed (Y/N)"
				noi di "Current start year: " "`ys'"
				noi di "Current end year: " "`ye'", _request(help_terminator)
				if !((strupper(substr("${help_terminator}", 1, 1)) == "Y") | (substr("${help_terminator}", 1, 1) == "1")) {
					noi di as error "***********************WARNING**************************"
					noi di as error "***********User Requested To Abort Creation*************"
					noi di as error "********************************************************"
					exit
				}
				*/
				
			}
			
			if 1 {
				// display the title of help page
				
				noi di ""
				noi di "NHANES Dataset Creation Program Helper"
				noi di ""
			}
			
			if ("`option'" == "") {
			
				noi di as error "General Information:"
				
				// display the general help information
				noi di in g "This is a program written by Zhenghao (Vincent) Jin and Abimereki Muzaale."
				noi di "The purpose of this program is to produce a dataset based on US NHANES Data."
				noi di "This program downloads and combines data from NHANES website."
				noi di "For more information, please visit NHANES official website at: "
				noi di "https://www.cdc.gov/nchs/nhanes/index.htm"
				noi di ""
				noi di "If you would like to know more about us, please visit our website FENA at: "
				noi di "https://jhutrc.github.io/beta/intro.html" // waiting for the FENA website
				noi di ""
				
				// basic information
				noi di "Basic Program Information:"
				noi di "Current program version: v2.1"
				noi di "This version is developed under Stata v17"
				noi di ""
				
				// option information
				noi di as error "Basic Instructions of Operation:"
				noi di in g " "
				noi di in g "To call the program in Stata:"
				noi di "nhanes1"
				noi di ""
				noi di "To ask for instructions in Stata for this program:"
				noi di "Call for help option as below:"
				noi di "nhanes1, help"
				noi di ""
				noi di "To regulate the start year of data inquiry:"
				noi di "Call for ys option (year start) as below:"
				noi di "nhanes1, ys(year_you_want)"
				noi di ""
				noi di "To regulate the end year of data inquiry:"
				noi di "Call for ye option (year end) as below:" 
				noi di "nhanes1, ye(year_you_want)"
				noi di ""
				noi di "To regulate years to be excluded from inquiry:"
				noi di "Call for ex option (exclude) as below:"
				noi di "nhanes1, ex(list_of_years_you_want)"
				noi di "***each year should be separated by space***"
				noi di ""
				noi di "To regulate the information that is being inquired:"
				noi di "Call for ds option (dataset) as below:"
				noi di "nhanes1, ds(number_of_information_set_you_want)"
				noi di ""
				noi di "To regulate type of dataset produced by the inquiry:"
				noi di "Call for format option:"
				noi di "nhanes1, format(number_of_dataset_type_you_want)"
				noi di ""
				noi di "To regulate timeout time for the inquiry:"
				noi di "Call for timeout option as below:"
				noi di "nhanes1, timeout(time_you_want_to_set)"
				noi di ""
				noi di "***For Detail Information Of Each Option***"
				noi di "Please choose corresponding option name when calling help option."
				noi di ""
			
			}
			else {
			
				/*
					noi di "1 - For ys option"
					noi di "2 - For ye option"
					noi di "3 - For ex option"
					noi di "4 - For ds option"
					noi di "5 - For format option"
					noi di "6 - For timeout option"
				*/
				
				foreach i in `option' {
					
					if (`i' == 0) {
						noi di as error "General Information:"
				
						// display the general help information
						noi di in g "This is a program written by Zhenghao (Vincent) Jin and Abimereki Muzaale."
						noi di "The purpose of this program is to produce a dataset based on US NHANES Data."
						noi di "This program downloads and combines data from NHANES website."
						noi di "For more information, please visit NHANES official website at: "
						noi di "https://www.cdc.gov/nchs/nhanes/index.htm"
						noi di ""
						noi di "If you would like to know more about us, please visit our website FENA at: "
						noi di "https://jhutrc.github.io/beta/intro.html" // waiting for the FENA website
						noi di ""
						
						// basic information
						noi di "Basic Program Information:"
						noi di "Current program version: v2.1"
						noi di "This version is developed under Stata v17"
						noi di ""
						
						// option information
						noi di as error "Basic Instructions of Operation:"
						noi di in g " "
						noi di in g "To call the program in Stata:"
						noi di "nhanes1"
						noi di ""
						noi di "To ask for instructions in Stata for this program:"
						noi di "Call for help option as below:"
						noi di "nhanes1, help"
						noi di ""
						noi di "To regulate the start year of data inquiry:"
						noi di "Call for ys option (year start) as below:"
						noi di "nhanes1, ys(year_you_want)"
						noi di ""
						noi di "To regulate the end year of data inquiry:"
						noi di "Call for ye option (year end) as below:" 
						noi di "nhanes1, ye(year_you_want)"
						noi di ""
						noi di "To regulate years to be excluded from inquiry:"
						noi di "Call for ex option (exclude) as below:"
						noi di "nhanes1, ex(list_of_years_you_want)"
						noi di "***each year should be separated by space***"
						noi di ""
						noi di "To regulate the information that is being inquired:"
						noi di "Call for ds option (dataset) as below:"
						noi di "nhanes1, ds(number_of_information_set_you_want)"
						noi di ""
						noi di "To regulate type of dataset produced by the inquiry:"
						noi di "Call for format option:"
						noi di "nhanes1, format(number_of_dataset_type_you_want)"
						noi di ""
						noi di "To regulate timeout time for the inquiry:"
						noi di "Call for timeout option as below:"
						noi di "nhanes1, timeout(time_you_want_to_set)"
						noi di ""
						noi di "***For Detail Information Of Each Option***"
						noi di "Please choose corresponding option name when calling help option."
						noi di ""
					}
					
					if (`i' == 1) {
						// help for ys option
						noi di ""
						noi di as error "Help Page: ys option"
						noi di in g "The ys option, stands for year start, is the option "
						noi di "regulates the start year of the inquiry."
						noi di ""
						noi di "The range of value for ys option for this version is: "
						noi di "1988 to 2019"
						noi di "The default value for ys option if not specified by user is: "
						noi di "1999"
						noi di ""
						noi di "There are several years are special in NHANES study and ys option: "
						noi di "1." _col(10) "For any year start that is between 1988 - 1994, "
						noi di _col(10) "the whole NHANES III dataset (1988-1994) will be included"
						noi di "2." _col(10) "There is no information in NHANES datasets for"
						noi di "3." _col(10) "Data for pandemic period (NHANES 2019 - 2020) has been"
						noi di _col(10) "aggregated with the prior dataset (NHANES 2017 - 2019)"
						noi di ""
						noi di as error "Example of use: "
						noi di in g "To request information that starts at 1988: "
						noi di "nhanes1, ys(1988)"
						noi di "To request information that starts at 2002: "
						noi di "nhanes1, ys(2002)"
						noi di ""
					
					}
					
					if (`i' == 2) {
						// help for ye option
						noi di ""
						noi di as error "Help Page: ye option"
						noi di in g "The ye option, stands for year end, is the option "
						noi di "regulates the end year of inquiry. The end year should"
						noi di "always be larger than the start year (ys). "
						noi di "In addition, since NHANES datasets are aggregated into"
						noi di "two year periods, all end year in odds number will be"
						noi di "modified to 1 year later (e.g.: 2001 -> 2002)"
						noi di ""
						noi di "The range of value for ye option for this version is: "
						noi di "1989 to 2020"
						noi di "The default value for ye option is not specified by user is: "
						noi di "One year after year start"
						noi di "(E.g.: If ys is 1999, then default for ye will be 2000)"
						noi di "(E.g.: If ys is 2011, then default for ye will be 2012)"
						noi di ""
						noi di "There are several years are special in NHANES study and ye option: "
						noi di "1." _col(10) "For any end year that is between 1989-1994, "
						noi di _col(10) "ye option will be modified to 1995 to include NHANES III."
						noi di "2." _col(10) "For any end year that is between 2017-2020, "
						noi di _col(10) "ye option will be modified to 2020 to include pandemic dataset."
						noi di ""
						noi di as error "Example of use: "
						noi di in g "To request information that ends at 2012"
						noi di "nhanes1, ye(2012)"
						noi di "To request information that ends at 2016"
						noi di "nhanes1, ye(2016)"
						noi di ""
						
					}
					
					if (`i' == 3) {
						// help for ex option
						noi di ""
						noi di as error "Help Page: ex option"
						noi di in g "The ex option, stands for exclusion, is the option "
						noi di "speficies specific years to be excluded from the inquiry."
						noi di "Exclusion of multiple years in one inquiry is ok."
						noi di "To exclude mutilple years at the same time, use space (" ")"
						noi di "to separate years in ex option."
						noi di "Since NHANES datasets are aggregated into two year periods,"
						noi di "excluding one single year will result in excluding the whole"
						noi di "dataset for the two year period."
						noi di "E.g.: excluding year of 1999 will results in exluding all"
						noi di "information for 1999 - 2000"
						noi di ""
						noi di "The ex option takes any positive integers as years"
						noi di "No default value was set for ex option"
						noi di "No actions will be taken for years specified in ex option that "
						noi di "are not between the inquiry start (ys) and end (ye) period"
						noi di ""
						noi di "There are several years are special in NHANES study and ex option: "
						noi di "1." _col(10) "For any year between 1988 - 1994 specified in ex option, "
						noi di _col(10) "the whole NHANES III dataset will be excluded"
						noi di "2." _col(10) "For any year between 2017 - 2020 specified in ex option, "
						noi di _col(10) "The whole dataset for pandemic period (2017 - 2020) will be excluded"
						noi di ""
						noi di as error "Example of use: "
						noi di in g "To exclude year of 2014 in an inqury between 2009 - 2016"
						noi di "nhanes1, ys(2009) ye(2016) ex(2014)"
						noi di "To exclude year of 2004, 2007, 2010 in an inqury between 1999 - 2016"
						noi di "nhanes1, ys(1999) ye(2016) ex(2004 2007 2010)"
						
					}
					
					if (`i' == 4) {
						// help for ds option
						noi di ""
						noi di as error "Help Page: ds option"
						noi di in g "The ds option, stands for dataset, is th option "
						noi di "specifies the type of information requested by the inqury."
						noi di ""
						noi di "The range of value for ds option is:"
						noi di "1 to 5"
						noi di "The default value for ds option if not specified by user is:"
						noi di "1 (base dataset)"
						noi di ""
						noi di "Coding for ds option: "
						noi di "0" _col(20) "base dataset"
						noi di "1" _col(20) "demographic dataset"
						noi di "2" _col(20) "exam dataset"
						noi di "3" _col(20) "diet dataset"
						noi di "4" _col(20) "questionnaire dataset"
						noi di ""
						noi di "Information included for each dataset:"
						noi di "base dataset:"
						noi di _col(20) "age"
						noi di _col(20) "sex"
						noi di _col(20) "race"
						noi di "demographic dataset:"
						noi di _col(20) "Please refer to NHANES website for specific list at" 
						noi di _col(20) "https://wwwn.cdc.gov/nchs/nhanes/default.aspx"
						noi di "exam dataset:"
						noi di _col(20) "blood pressure"
						noi di _col(20) "body measures"
						noi di _col(20) "glycohemoglobin"
						noi di _col(20) "albumin & creatinine - urine"
						noi di _col(20) "standard biochemistry profile"
						noi di "diet dataset:"
						noi di _col(20) "dietary intake - total nutrients intake"
						noi di "questionnaire dataset"
						// ALQ DIQ KIQ_U BPQ PAQ SMQ 
						noi di _col(20) "alcohol use"
						noi di _col(20) "diabetes"
						noi di _col(20) "kidney condition - urology"
						noi di _col(20) "blood pressure & cholesterol"
						noi di _col(20) "physical activity"
						noi di _col(20) "smoking - cigarette use"
						noi di ""
						noi di as error "Example of use: "
						noi di in g "To request the base dataset for age/sex/race:"
						noi di "nhanes1, ds(1)"
						noi di "To request the exam dataset for examination and lab information:"
						noi di "nhanes1, ds(3)"
						noi di ""
					}
					
					if (`i' == 5) {
						// help for format option
						noi di ""
						noi di as error "Help Page: format option"
						noi di in g "The format option regulates the type of output file"
						noi di ""
						noi di "The range of value for format option is:"
						noi di "0 to 5"
						noi di "The default value for format option if not specified by user is:"
						noi di "0 (dta dataset)"
						noi di ""
						/*
						0 - dta
						1 - excel
						2 - csv
						3 - sasxport5
						4 - sasxport8
						5 - text
						*/
						noi di "Coding for format option:"
						noi di "0" _col(10) "dta (Stata) file"
						noi di "1" _col(10) "excel file"
						noi di "2" _col(10) "csv file"
						noi di "3" _col(10) "sasxport5 file"
						noi di "4" _col(10) "sasxport8 file"
						noi di "5" _col(10) "text data file with dictionary"
						noi di ""
						noi di as error "Example of use:"
						noi di in g "To output a csv file for the inquiry:"
						noi di "nhanes1, format(2)"
						noi di "To output a sas dataset (sasxport5) for the inquiry:"
						noi di "nhanes1, format(3)"
						noi di ""
						
					}
					
					if (`i' == 6) {
						// help for timeout option
						noi di ""
						noi di as error "Help Page: timeout option"
						noi di in g "The timeout option regulates the time limit for Stata"
						noi di "to initial connection with NHANES database in seconds."
						noi di ""
						noi di "The timeout option takes any positive integers."
						noi di "The default value for timeout option if not specified by user is:"
						noi di "1000"
						noi di ""
						noi di as error "Example of use:"
						noi di in g "To set time limit for initiate connection to be 500 seconds:"
						noi di "nhanes1, timeout(500)"
						noi di "To set time limit for initiate connection to be 2000 seconds:"
						noi di "nhanes1, timeout(2000)"
						noi di ""
					}
					
					if (`i' == 7) {
						// help for mort option
						noi di ""
						noi di as error "Help Page: mort option"
						noi di in g "The mort option allows user to add mortality information to the inquiry."
						noi di "The mort option can be combined with any requested information."
						noi di ""
						noi di as error "Example of use:"
						noi di in g "To request mortality information additional to demographic information"
						noi di "for year between 1999 to 2008"
						noi di "nhanes1, ys(1999) ye(2008) mort ds(2)"
					}
					
				}
				
			}
			
			noi di as error "Do you need further help? (Y/N)", _request(f_help)
			if ((substr(strupper("${f_help}"), 1, 1) == "Y") | (substr("${f_help}", 1, 1) == "1")) {
				noi nhanes1_helper
			} 
			else {
				noi di "The help option is terminated."
				exit
			}
			
		}
	
	end
}

capture program drop dict_new
program define dict_new
	qui {
		syntax, name(string) ind(string) val(string)
		
		// detect if ind num equals val num
		if 1 {
			local ind : di strtrim(stritrim("`ind'"))
			local ind_helper : di subinstr("`ind'", " ", "", .)
			local ind_len = strlen("`ind'") - strlen("`ind_helper'")
			
			local val : di strtrim(stritrim("`val'"))
			local val_helper : di subinstr("`val'", " ", "", .)
			local val_len = strlen("`val'") - strlen("`val_helper'")
			
			if (`val_len' != `ind_len') {
				noi di as error "DICT ERROR: Index does not match value, please check."
				exit
			}
		}
		
		// establish macros for storage
		global `name'_index `ind'
		global `name'_value `val'
		local dict_list : di (`"""' + subinstr("${dict_list}", " ", `"", ""', .) + `"""')
		if !(inlist("`name'", `dict_list')) {
			global dict_list $dict_list `name'
		}
		else {
			noi di "WARNING: dict: `name' was replaced by this new dict generation"
		}
	}
end

capture program drop dict_display
program define dict_display
	qui {
		
		syntax, name(string) [col_factor(int 15)]
		
		foreach i in `name' {
			local dicts : di (`"""' + subinstr("$dict_list", " ", `"", ""', .) + `"""')
			if !(inlist("`i'", `dicts')) {
				noi di ""
				noi di as error `"DICT ERROR: dict "`i'" is not defined"' 
				noi di in g " "
				continue
			}
			
			noi di "`i'"
			local count = 0
			foreach j in ${`i'_index} {
				local indent = `count' * `col_factor'
				noi di _col(`indent') "`j'", _continue
				local count = `count' + 1
			}
			noi di ""
			local count = 0
			foreach j in ${`i'_value} {
				local indent = `count' * `col_factor'
				noi di _col(`indent') "`j'", _continue
				local count = `count' + 1
			}
			noi di ""
		}
	}
end

capture program drop dict_call
program define dict_call
	qui {
		syntax, name(string) [ind(string) ind_n(int 999999)] 

		// check if index is in dict
		// check if name is in dict list
		// check if only 1 index is called
		if 1 {

			local dict_list : di (`"""' + subinstr("${dict_list}", " ", `"", ""', .) + `"""')
			if !(inlist("`name'", `dict_list')) {
				noi di as error "Dict name: `name' was not found in established dict list"
				noi di in g " "
				exit
			}
			// local space_n = strlen(strtrim("`ind'")) - strlen(subinstr(stritrim("`ind'"), " ", "", .))
			if ("`ind'" != "") {
				local space_n = strlen(strtrim("`ind'")) - strlen(subinstr(stritrim("`ind'"), " ", "", .))
			}
			if ("`ind_n'" != "") {
				local space_n2 = strlen(strtrim("`ind_n'")) - strlen(subinstr(stritrim("`ind_n'"), " ", "", .))
			}
			if (("`space_n'" != "" & "`space_n'" != "0") | ("`space_n2'" != "" & "`space_n2'" != "0")) {
				noi di as error "Multiple index cannot be called at the same time"
				noi di in g " "
				exit
			}

			// first translate ind_n to ind if available
			// detect if ind_n is within range
			if (`ind_n' != 999999) {
				tokenize ${`name'_index}
				local index : di "``ind_n''"
				if ("`index'" == "") {
					noi di as error "Numeric index: `ind_n' is not within the numeric index range for dict: `name'"
					noi di in g " "
					exit
				}
			}

			// check if only one index is called
			if ("`ind'" != "" & "`ind_n'" != "999999" & "`index'" != "`ind'") {
				noi di as error "Index name and numeric index referred to different elements in dict: `name'"
				noi di as error "Please only specify one index to call"
				exit
			}
									
			if ("`index'" == "") {
				local index : di "`ind'"
			}
			
			local ind_exist = 0
			foreach i in ${`name'_index} {
				if ("`ind'" == "`i'") {
					local ind_exist = 1
				}
			}
			
			/*
			local ind_list : di (`"""' + subinstr("${`name'_index}", " ", `"",""', .) + `"""')
			noi di `"`ind_list'"'
			if !(inlist("`index'", `ind_list')) {
			*/
			if (`ind_exist' == 0) {
				noi di as error "Index: `ind' was not found in established dict: `name'"
				noi di in g " "
				exit
			}
		}

		// call the value
		// allow display
		// create a global macro dict_call to store called value
		if 2 {
			// cut the index string to the index first character
			local ind_helper1 : di substr("${`name'_index}", 1, strpos("${`name'_index}", "`index'"))

			// count space
			local ind_num = strlen("`ind_helper1'") - strlen(subinstr("`ind_helper1'", " ", "", .))
			local ind_num = `ind_num' + 1
			tokenize ${`name'_value}
			global dict_call : di "``ind_num''"
			noi di "${dict_call}"
		}
	}
end

capture program drop dict_append
program define dict_append
	qui {
		syntax, name(string) ind(string) val(string)
		
		// detect if ind num equals val num
		if 1 {
			
			local dicts : di (`"""' + subinstr("$dict_list", " ", `"", ""', .) + `"""')
			if !(inlist("`name'", `dicts')) {
				noi di as error `"DICT ERROR: dict "`name'" is not defined"' 
				noi di in g " "
				exit
			}
			
			local ind : di strtrim(stritrim("`ind'"))
			local ind_helper : di subinstr("`ind'", " ", "", .)
			local ind_len = strlen("`ind'") - strlen("`ind_helper'")
			
			local val : di strtrim(stritrim("`val'"))
			local val_helper : di subinstr("`val'", " ", "", .)
			local val_len = strlen("`val'") - strlen("`val_helper'")
			
			if (`val_len' != `ind_len') {
				noi di as error "DICT ERROR: Index does not match value, please check."
				exit
			}
			
			// detect if ind was already existing in the dict
			local ind_list : di (`"""' + subinstr("${`name'_index}", " ", `"", ""', .) + `"""')
			foreach i in `ind' {
				if (inlist("`i'", `ind_list')) {
					noi di as error "Index: `i' is already specified in established dict: `name'"
					noi di in g " "
					exit
				}
			}
		}
		
		// establish macros for storage
		global `name'_index ${`name'_index} `ind'
		global `name'_value ${`name'_value} `val'

	}
end

capture program drop dict_replace
program define dict_replace
	qui {
		
		syntax, name(string) ind(string) val(string)
		
		// detect potential error
		if 1 {
			// check if name is in list
			local dicts : di (`"""' + subinstr("$dict_list", " ", `"", ""', .) + `"""')
			if !(inlist("`name'", `dicts')) {
				noi di as error `"DICT ERROR: dict "`name'" is not defined"' 
				noi di in g " "
				exit
			}
			
			// check the length of ind and val
			local ind : di strtrim(stritrim("`ind'"))
			local ind_helper : di subinstr("`ind'", " ", "", .)
			local ind_len = strlen("`ind'") - strlen("`ind_helper'")
			
			local val : di strtrim(stritrim("`val'"))
			local val_helper : di subinstr("`val'", " ", "", .)
			local val_len = strlen("`val'") - strlen("`val_helper'")
			
			if (`val_len' != `ind_len') {
				noi di as error "DICT ERROR: Index does not match value, please check."
				noi di in g " "
				exit
			}
			
			// check if all index are in index list
			local error
			local ind_list : di (`"""' + subinstr("${`name'_index}", " ", `"", ""', .) + `"""')
			foreach i in `ind' {
				if !(inlist("`i'", `ind_list')) {
					local error `error' `i'
				}
			}
			if ("`error'" != "") {
				local error : di (`"""' + subinstr("`error'", " ", `"", ""', .) + `"""')
				noi di as error `"Index: `error' not found in dict: `name'"'
				noi di in g " "
				exit
			}
		} 

		// actual replacing process
		// detect the place in val list
		// creat a temp val list
		// for each val in val list
		// add to the temp val list
		// if place, add new value not the original one
		if 2 {
			local place = 0
			foreach i in `ind' {
				local place = `place' + 1
				// cut the index string to the index first character
				local ind_helper1 : di substr("${`name'_index}", 1, strpos("${`name'_index}", "`i'"))
				// count space
				local ind_num = strlen("`ind_helper1'") - strlen(subinstr("`ind_helper1'", " ", "", .))
				local ind_num = `ind_num' + 1
				
				// get new value
				tokenize `val'
				local new_val : di "``place''"
				
				local temp_vals
				local val_count = 0
				foreach j in ${`name'_value} {
					local val_count = `val_count' + 1
					if !(`val_count' == `ind_num') {
						local temp_vals `temp_vals' `j'
					}
					else if (`val_count' == `ind_num') {
						local temp_vals `temp_vals' `new_val'
					}
					
				}
				global `name'_value `temp_vals'
				
			}
		}
		
	}
	
end