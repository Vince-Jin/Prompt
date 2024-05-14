qui {
	capture program drop prompt_v1
	program define prompt_v1
		qui {
			if 1 {
				cls
				clear
				set varabbrev on
				set more off
			}
			
			if 2 { // basic settings
				local des_s = 10 // description text displaying speed
				local req_s = 10 // request prompt related text displaying speed
				local hint_thresh = 3 // display hints after how many tries
				local ans_thresh = 9 // display answer after how many tries for traditional
			}
			
			if 3 { // display the description and instructions
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
			}
			
			if 4 { // working directory
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
			}
			
			if 5 { // importing dataset
				local ds1 : di "Importing Datasets Now"
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `des_s'
				}
				noi di ""
				import delimited "https://jhustata.github.io/book/_downloads/884b9e06eb29f89b1b87da4eab39775d/hw1.txt", clear
				cd "${data_p}"
				capture mkdir v1
				cd "${data_p}${slash}v1"
				save "v1_data.dta", replace
				noi di "`c(N)' Data Successfully Read In"
				cd "${root}"
			}
			
			if 6 { // aggregate scenario information
				local id_var : di "fake_id"
				ds
				local vars : di strtrim(subinstr("`r(varlist)'", "`id_var'", "", .)) // vars for random selection
				local r_max_helper = 0
				foreach i in `vars' {
					local r_max_helper = `r_max_helper' + 1
				}
				local r_max = round(runiform(1, `r_max_helper'))
				local vars_target
				forvalues i = 1 / `r_max' {
					local r_var = round(runiform(1, `r_max_helper'))
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
						local r_var = round(runiform(1, `r_max_helper'))
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
					tokenize `vars'
					local vars_list `vars_list' ``i''
				}
				
				// get missingness
				local mis_helper = round(runiform(0, 1))
				local missingness
				if (`mis_helper' == 1) {
					local missingness : di "missingness"
				}
				local mis = `mis_helper'
			}
			
			if 7 { // display scenario information
				local ds1 : di "The first approach we will be testing is: "
				local ds2 : di "User interactive appraoch"
				forvalues i = 1/2 {
					foreach j in `ds`i'' {
						noi di as error "`j'", _continue
						sleep `req_s'
					}
				}
				noi di in g " "
				sleep 3000
				timer clear 1
				timer on 1
				local ds4 : di "In this approach, we would like to conduct a table 1 on these variables: "
				local ds5 : di "`vars_list'"
				forvalues i = 4/5 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				if (`mis_helper' == 1) {
					noi di "Please make sure to include missingness information"
				}
				else if (`mis_helper' == 0) {
					noi di "Please make sure to NOT include missingness information"
				}
				
				local ds1 : di "(Please hit enter for continue)"				
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di ""
				
				noi di "", _request(proceed)
				global proceed : di strtrim(stritrim("${proceed}"))
				if (strupper("${proceed}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
			}
			
			if 8 { // creation
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
				
				// missingness
				noi di "Do you want to incluide missingness information in table 1?"
				noi di "(Yes - 1/Y No - 0/N)", _request(mis)
				
				global mis : di strlower(strtrim(stritrim("${mis}")))
				
				if ("${mis}" == "exit") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
				
				local mis_input = 0
				if (substr("${mis}", 1, 1) == "1") | (substr("${mis}", 1, 1) == "y") {
					local mis_input = 1
				}
				
				while ("`mis_input'" != "`mis_helper'") {
					
					noi di "Missingness information does not match scenario requirement"
					noi di "Please check and re-enter", _request(mis)
					
					global mis : di strlower(strtrim(stritrim("${mis}")))
				
					if ("${mis}" == "exit") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in g " "
						exit
					}
					
					local mis_input = 0
					if (substr("${mis}", 1, 1) == "1") | (substr("${mis}", 1, 1) == "y") {
						local mis_input = 1
					}
					
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
				
				cd "${table_p}"
				capture mkdir "v1"
				cd "${table_p}${slash}v1"
				capture mkdir "user interactive"
				cd "${table_p}${slash}v1${slash}user interactive"
				shell ${del} *.xlsx
				qui do "https://raw.githubusercontent.com/jhustata/basic/main/table1_fena.ado"
				noi table1_fena, var(${var}) `title' `excel' `missingness'
				cd "${root}"
				timer off 1
				qui timer list
				global srt1 = `r(t1)'
			}
			
			if 8 { // transition
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
				timer clear 2
				timer on 2
			}
			
			if 9 { // description for traditional
				local ds1 : di "Imagine that you are a collaborator who have never worked with this project before"
				local ds2 : di "One day you want to reproduce the table 1 for this project," 
				local ds3 : di "and obtained the associated script and program, which is called: "
				local ds4 : di "creation"
				local ds5 : di " "
				local ds6 : di "Now you just need to call the program in console, but you have to specify all appropriate optional syntax options"
				local ds7 : di "just like: creation, var(...) title(...) ..."
				local ds8 : di " "
				local ds9 : di "Unfortunately you were not offered information about these syntax optinos."
				local ds10 : di "You only know that this program has these following syntaxes and options: "
				local ds11 : di "var() missingness excel() title()"
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
			}
			
			if 10 { // scenario information
				local id_var : di "fake_id"
				ds
				local vars : di strtrim(subinstr("`r(varlist)'", "`id_var'", "", .)) // vars for random selection
				local r_max_helper = 0
				foreach i in `vars' {
					local r_max_helper = `r_max_helper' + 1
				}
				local r_max = round(runiform(1, `r_max_helper'))
				local vars_target
				forvalues i = 1 / `r_max' {
					local r_var = round(runiform(1, `r_max_helper'))
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
						local r_var = round(runiform(1, `r_max_helper'))
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
					tokenize `vars'
					local vars_list `vars_list' ``i''
				}
				
				// get missingness
				local mis_helper = round(runiform(0, 1))
				local missingness
				if (`mis_helper' == 1) {
					local missingness : di "missingness"
				}
				local mis = `mis_helper'
			}
			
			if 11 { // req information
				local ds4 : di "In this approach, we would like to conduct a table 1 on these variables: "
				local ds5 : di "`vars_list'"
				forvalues i = 4/5 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				if (`mis_helper' == 1) {
					noi di "Please make sure to include missingness information"
				}
				else if (`mis_helper' == 0) {
					noi di "Please make sure to NOT include missingness information"
				}
				
				local ds1 : di "(Please hit enter for continue)"				
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di ""
				
				noi di "", _request(proceed)
				global proceed : di strtrim(stritrim("${proceed}"))
				if (strupper("${proceed}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
			}
			
			if 12 { // ask for creation
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
				noi di as error "var() missingness excel() title()", _continue
				noi di in g, _request(command)
				
				global command : di strtrim(stritrim("${command}"))
				if (strupper("${command}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
			}
			
			if 13 { // check creation input
				local must var
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
							noi di "var()"
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
						if !inlist("`i'", "missingness") {
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
							noi di `"creation,  var(`vars_list') `missingness'"'
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
							if !inlist("`i'", "missingness") {
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
			}
		
			if 14 { // run creation
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
				global srt2 = `r(t2)'
			}
			
			if 15 { // ending desc
				noi di " "
				noi di "Running Time Information: "
				noi di "Prompt Based (Q1): ${srt1}"
				noi di "Traditional (Q2): ${srt2}"
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
		}
	end
	
	capture program drop creation
	program define creation
		syntax, var(string) [missingness excel(string) title(string)]
		
		qui {
			cd "${table_p}"
			capture mkdir "v1"
			cd "${table_p}${slash}v1"
			capture mkdir "syntax"
			cd "${table_p}${slash}v1${slash}syntax"
			shell ${del} *.xlsx
			noi table1_fena, var(`var') `missingness' excel(`excel') title(`title')
			cd "${root}"
		}
	end
}