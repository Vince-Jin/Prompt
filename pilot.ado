qui {
	capture program drop pilot
	program define pilot
		qui {
			
			if 1 { // set up macros
				clear
				
				local des_s = 10
				local req_s = 10
				local hint_thresh = 3
				local ans_thresh = 10
				
				qui do "https://raw.githubusercontent.com/jhustata/basic/main/table1_fena.ado"
			}
			
			if 2 { // Overall description
				
				local ds1 : di "Welcome to the pilot program for user interactive programming and syntax programming"
				local ds2 : di "In this program, we will first create your own special dataset through simulation"
				local ds3 : di "and create a table 1 based on it."
				local ds4 : di " "
				local ds5 : di "If you wish to terminate the program at any time, please enter: exit"
				local ds6 : di "In the command window"
				local ds7 : di " "
				
				forvalues i = 1/7 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `des_s'
					}
					noi di ""
				}
				
			}
			
			if 3 { // Proceeding input
				
				local ds1 : di "Please hit enter to continue"
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `des_s'
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
			
			if 3 {
				
				local ds1 : di " "
				local ds2 : di "Current working directory is: "
				forvalues i = 1/2 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `des_s'
					}
					noi di ""
				}
				global root : di "`c(pwd)'"
				noi di "${root}"
				local ds1 : di " "
				local ds2 : di "If you wish to change the working directory, please enter now"
				local ds3 : di "Otherwise, please hit enter to continue"
				
				forvalues i = 1/3 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `des_s'
					}
					noi di ""
				}
				noi di "", _request(dire)
						
				global dire : di strtrim("${dire}")
				if (strupper("${dire}") == "EXIT") {
					noi di " "
					noi di as error "Program terminated"
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
				
				global data : di "${root}${slash}data${slash}pilot"
				global table_p : di "${root}${slash}table"

				capture mkdir data
				cd "${root}${slash}data"
				capture mkdir "pilot"
				cd "${root}"
				capture mkdir "${table_p}"
				
				cd "${data}"
				shell ${del} *.dta
				cd "${table_p}"
				shell ${del} *.xlsx
				
				cd "${root}"
			}
			
			if 4 { // dataset creation
				
				local ds1 : di " "
				local ds2 : di "First step: Creation of Dataset"
				local ds3 : di " "
				local ds4 : di "In this section, we will simulate the dataset for table 1"
				local ds5 : di "The program will ask for some information about how you would like"
				local ds6 : di "your dataset to be and simulate based on information provided"
				local ds7 : di " "
				local ds8 : di "Now, let's get the process started."
				local ds9 : di " "
				
				forvalues i = 1/9 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				local ds1 : di "Please enter how many observations should be in the dataset"
				local ds2 : di "(Any integer between 1 - 100,000)"
				forvalues j = 1/2 {
					foreach i in `ds`j'' {
						noi di "`i'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				noi di "", _request(obs)
				
				global obs : di strtrim("${obs}")
				
				if (strupper("${obs}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di " "
					exit
				}
				
				while (real("${obs}") == .) {
					noi di "Observation number entered not valid"
					noi di "Please check and re-enter", _request(obs)
					
					global obs : di strtrim("${obs}")
				
					if (strupper("${obs}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di " "
						exit
					}
				}
				
				while !(inrange(${obs}, 1, 100000)) {
					noi di "Observation number out of range"
					noi di "Please check and re-enter", _request(obs)
					
					global obs : di strtrim("${obs}")
				
					if (strupper("${obs}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di " "
						exit
					}
					
					while (real("${obs}") == .) {
						noi di "Observation number entered not valid"
						noi di "Please check and re-enter", _request(obs)
						
						global obs : di strtrim("${obs}")
					
						if (strupper("${obs}") == "EXIT") {
							noi di " "
							noi di as error "Program Terminated"
							noi di " "
							exit
						}
					}
				}
				
				set obs ${obs}
				capture drop id
				gen id = _n
				
				local ds1 : di "Please enter how many variables should be in the dataset"
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di ""
				
				local ds1 : di "(Any interger between 1 - 100)"
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di "", _request(var_n)
				
				global var_n : di strtrim("${var_n}")
				
				if (strupper("${var_n}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
				
				while (real("${var_n}") == .) {
					noi di "Variable number entered not valid"
					noi di "Please check and re-enter", _request(var_n)
					
					global var_n : di strtrim("${var_n}")
				
					if (strupper("${var_n}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di " "
						exit
					}
				}
				
				while !(inrange(${var_n}, 1, 100)) {
					noi di "Variable number out of range"
					noi di "Please check and re-enter", _request(var_n)
					
					global var_n : di strtrim("${var_n}")
				
					if (strupper("${var_n}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di " "
						exit
					}
					
					while (real("${var_n}") == .) {
						noi di "Variable number entered not valid"
						noi di "Please check and re-enter", _request(var_n)
						
						global var_n : di strtrim("${var_n}")
					
						if (strupper("${var_n}") == "EXIT") {
							noi di " "
							noi di as error "Program Terminated"
							noi di " "
							exit
						}
					}
				}
				
				forvalues i = 1/${var_n} {
					
					noi di "Please enter the name for variable number `i': ", _request(var_name)
					
					global var_name : di strlower(strtrim("${var_name}"))
					
					if ("${var_name}" == "exit") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in g " "
						exit
					}
					
					ds
					local varlist r(varlist)
					local exist = 0
					foreach var in `varlist' {
						if ("${var_name}" == "`var'") {
							local exist = 1
						}
					}
					
					while (`exist' != 0) {
						noi di "The variable name entered already existing"
						noi di "Please check and re-enter", _request(var_name)
						
						global var_name : di strlower(strtrim("${var_name}"))
						
						if ("${var_name}" == "exit") {
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
						}
						
						local exist = 0
						foreach var in `varlist' {
							if ("${var_name}" == "`var'") {
								local exist = 1
							}
						}
					}
					
					capture gen ${var_name} = .
					
					while (_rc) {
						noi di "Variable name is invalid."
						noi di "Variable name cannot begin with numbers or symbols."
						noi di "Spaces are also not allowed."
						noi di "Please check and re-enter", _request(var_name)
						
						global var_name : di strlower(strtrim("${var_name}"))
						
						if ("${var_name}" == "exit") {
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
						}
						
						local exist = 0
						foreach var in `varlist' {
							if ("${var_name}" == "`var'") {
								local exist = 1
							}
						}
						
						while (`exist' != 0) {
							noi di "The variable name entered already existing"
							noi di "Please check and re-enter", _request(var_name)
							
							if ("${var_name}" == "exit") {
								noi di " "
								noi di as error "Program Terminated"
								noi di in g " "
								exit
							}
							
							global var_name : di strlower(strtrim("${var_name}"))
							
							local exist = 0
							foreach var in `varlist' {
								if ("${var_name}" == "`var'") {
									local exist = 1
								}
							}
						}
						
						capture gen ${var_name} = .
					}
					
					drop ${var_name}
					
					noi di "Please indicate the type of variable: ${var_name}"
					noi di "(1-binary 2-categorical 3-continuous)", _request(var_type)
					
					global var_type : di strtrim("${var_type}")
					
					if (strupper("${var_type}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in g " "
						exit
					}
					
					while !(inlist("${var_type}", "1", "2", "3")) {
						noi di "Variable type entered is not valid"
						noi di "Please check and re-enter", _request(var_type)
						
						global var_type : di strtrim("${var_type}")
					
						if (strupper("${var_type}") == "EXIT") {
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
						}
					}
					
					noi di "Please enter how many percent of ${var_name} should be missing", _request(mis)
					
					global mis : di strtrim("$mis")
					
					if (strupper("${mis}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in g " "
						exit
					}
					
					while (real("${mis}") == .) {
						noi di "Percentage value entered is not a numeric value"
						noi di "Please check and re-enter", _request(mis)
						
						global mis : di strtrim("$mis")
					
						if (strupper("${mis}") == "EXIT") {
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
						}
					}
					
					while !(inrange(${mis}, 0, 100)) {
						
						noi di "Percentage not within 0-100, please check and re-enter", _request(mis)
						
						global mis : di strtrim("$mis")
					
						if (strupper("${mis}") == "EXIT") {
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
						}
						
						while (real("${mis}") == .) {
							noi di "Percentage value entered is not a numeric value"
							noi di "Please check and re-enter", _request(mis)
							
							global mis : di strtrim("$mis")
						
							if (strupper("${mis}") == "EXIT") {
								noi di " "
								noi di as error "Program Terminated"
								noi di in g " "
								exit
							}
						}
						
					}
					
					
					if (${var_type} == 1) {
						noi di " "
						noi di "Variable: ${var_name} is set to be binary variables"
						noi di "Values of ${var_name} is now substituted to 0 (No) and 1 (Yes)"
						
						gen ${var_name} = .
						
						val_rand, bin mis(${mis}) name(${var_name})
						noi di " "
					}
					else if (${var_type} == 2) {
						noi di " "
						noi di "Variable: ${var_name} is set to be categorical variables"
						noi di "Please enter value for each category, seperated by space"
						noi di "(e.g.: 1 2 3 or a b c)", _request(cat_val)
						
						global cat_val : di strtrim(stritrim("${cat_val}"))
						
						if (strupper("${cat_val}") == "EXIT") {
							
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
							
						}
						
						gen ${var_name} = ""
						
						local count = 0
						foreach k in ${cat_val} {
							local count = `count' + 1
						}
						val_rand, cat min(1) max(`count') mis(${mis}) name(${var_name})
						tokenize ${cat_val}
						forvalues h = 1/`count' {
							replace ${var_name} = "``h''" if ${var_name}_helper == `h'
						}
						destring ${var_name}, g(checker_${var_name})
						capture desc checker_${var_name}
						if !(_rc) {
							destring ${var_name}, replace
						}
						capture drop ${var_name}_helper
						capture drop checker_${var_name}	
						
						noi di " "
						
					}
					else if (${var_type} == 3) {
						noi di " "
						noi di "Variable: ${var_name} is set to be continuous variables"
						noi di "that follows a normal distribution"
						noi di "Please specify the mean of this variable", _request(mean)
						
						gen ${var_name} = .
						
						global mean : di strtrim("${mean}")
						
						if (strupper("${mean}") == "EXIT") {
							
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
							
						}
						
						while (real("${mean}") == .) {
							noi di "Non-numeric mean value was entered"
							noi di "Please check and re-enter", _request(mean)
							
							if (strupper("${mean}") == "EXIT") {
							
								noi di " "
								noi di as error "Program Terminated"
								noi di in g " "
								exit
								
							}
							
							global mean : di strtrim("${mean}")
						}
						
						noi di "Please specify the standard deviation of this variable", _request(sd)
						
						global sd : di strtrim("${sd}")
						
						if (strupper("${sd}") == "EXIT") {
							
							noi di " "
							noi di as error "Program Terminated"
							noi di in g " "
							exit
							
						}
						
						while (real("${sd}") == .) {
							noi di "Non-numeric sd value was entered"
							noi di "Please check and re-enter", _request(sd)
							
							if (strupper("${sd}") == "EXIT") {
							
								noi di " "
								noi di as error "Program Terminated"
								noi di in g " "
								exit
								
							}
							
							global sd : di strtrim("${sd}")
						}
						
						val_rand, con name(${var_name}) mean(${mean}) sd(${sd})
						noi di " "
					}
					
				}
				save "${data}${slash}pilot_data.dta", replace
				
			}
			
			if 5 { // table 1 user interactive
				local ds1 : di " "
				local ds2 : di "Now we will be creating our table 1 for the dataset we just created."
				local ds3 : di " "
				local ds4 : di "The first approach we will be testing is: "
				local ds5 : di "User interactive appraoch"
				
				forvalues i = 1/5 {
					foreach j in `ds`i'' {
						noi di as error "`j'", _continue
						sleep `des_s'
					}
					noi di ""
				}
				noi di in g " "
				sleep 3000
				
				// get varlist
				ds
				
				local var_list `r(varlist)'
				local var_ct = 0
				foreach i in `var_list' {
					local var_ct = `var_ct' + 1
				}
				
				local rand_n = round(runiform(1, `var_ct'))
				
				local v_list_helper
				local v_list
				forvalues i = 1/`rand_n' {
					local rand = round(runiform(1, `var_ct'))
					local check = 0
					foreach i in `v_list_helper' {
						if `i' == `rand' {
							local check = 1
						}
					}
					while (`check' == 1) {
						local rand = round(runiform(1, `var_ct'))
						local check = 0
						foreach i in `v_list_helper' {
							if `i' == `rand' {
								local check = 1
							}
						}
					}
					local v_list_helper `v_list_helper' `rand'
				}
				
				tokenize `var_list'
				foreach i in `v_list_helper' {
					local v_list `v_list' ``i''
				}
				
				// get missingness
				local mis_helper = round(runiform(0, 1))
				local missingness
				if (`mis_helper' == 1) {
					local missingness : di "missingness"
				}
				local mis = `mis_helper'
				
				// display information
				local ds1 : di "In this approach, we would like to conduct a table 1 on these variables: "
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di ""
				noi di "`v_list'"
				if (`mis_helper' == 1) {
					noi di "Please make sure to include missingness information"
				}
				else if (`mis_helper' == 0) {
					noi di "Please make sure to NOT include missingness information"
				}
				
				noi di " "
				noi di "User Interactive Table 1 Creation: "
				timer clear 1
				timer on 1
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
				local d2 : list uniq v_list
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
					local d2 : list uniq v_list
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
				
				capture mkdir "${table_p}${slash}user interactive"
				cd "${table_p}${slash}user interactive"
				shell ${del} *.xlsx
				noi table1_fena, var(${var}) `title' `excel' `missingness'
				timer off 1
				qui timer list
				global irt1 = `r(t1)'
			}
		
			if 6 {
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
				sleep 3000
				noi di in g " "
				
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
				
				timer clear 2
				timer on 2
				local ds1 : di "In this scenario, we will conduct our table 1 for following variables: "
				foreach i in `ds1' {
					noi di "`i'", _continue
					sleep `req_s'
				}
				noi di ""
				
				// get varlist
				ds
				local var_list `r(varlist)'
				local var_ct = 0
				foreach i in `var_list' {
					local var_ct = `var_ct' + 1
				}
				
				local rand_n = round(runiform(1, `var_ct'))
				
				local v_list_helper
				local v_list
				
				forvalues i = 1/`rand_n' {
					local rand = round(runiform(1, `var_ct'))
					local check = 0
					foreach i in `v_list_helper' {
						if (`i' == `rand') {
							local check = 1
						}
					}
					while (`check' == 1) {
						local rand = round(runiform(1, `var_ct'))
						local check = 0
						foreach i in `v_list_helper' {
							if (`i' == `rand') {
								local check = 1
							}
						}
					}
					local v_list_helper `v_list_helper' `rand'
				}
				
				tokenize `var_list'
				foreach i in `v_list_helper' {
					local v_list `v_list' ``i''
				}
				
				// get missingness
				local mis_helper = round(runiform(0, 1))
				local missingness
				if (`mis_helper' == 1) {
					local missingness : di "missingness"
				}
				local mis = `mis_helper'
				
				noi di "`v_list'"
				if (`mis_helper' == 1) {
					noi di "Please make sure to include missingness information"
				}
				else if (`mis_helper' == 0) {
					noi di "Please make sure to NOT include missingness information"
				}
				
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
				
				global command : di stritrim(strtrim("${command}"))
				if (strupper("${command}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in g " "
					exit
				}
				
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
							local ds_2 : list uniq v_list
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
							noi di `"creation,  var(`v_list') `missingness'"'
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
								local ds_2 : list uniq v_list
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
				global irt2 = `r(t2)'
				noi di " "
				noi di "Running Time Information: "
				noi di "Prompt Based (Q4): ${irt1}"
				noi di "Traditional (Q5): ${irt2}"
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
			capture mkdir "${table_p}${slash}syntax"
			cd "${table_p}${slash}syntax"
			shell ${del} *.xlsx
			noi table1_fena, var(`var') `missingness' excel(`excel') title(`title')
		}
	end
	
	capture program drop val_rand
	program define val_rand
		qui {
			syntax, [bin cat con min(int 1) max(int 99) mis(real 0.0) name(varname) mean(real 10.0) sd(real -2.5)]
			
			if ("`bin'" == "bin") {

				replace `name' = runiform(0, 1)

				local mis = `mis' / 100
				local mis_thr = 1 - `mis'
				local bin_thr = `mis_thr' / 2
				
				replace `name' = . if inrange(`name', `mis_thr', 1)
				replace `name' = 0 if inrange(`name', 0, `bin_thr')
				replace `name' = 1 if inrange(`name', `bin_thr', `mis_thr')	

			}
			
			if ("`cat'" == "cat") {
				capture drop __helper
				local mis_thr = 1 - (`mis' / 100)
				gen __helper = runiform(0, 1)
				
				replace __helper = . if !(__helper < `mis_thr')
				capture drop `name'_helper
				gen `name'_helper = .
				replace `name'_helper = round(runiform(`min', `max')) if __helper != .
				drop __helper
			}
			
			if ("`con'" == "con") {
				capture drop __helper
				local mis_thr = 1 - (`mis' / 100)
				gen __helper = runiform(0, 1)
				
				replace __helper = . if !(__helper < `mis_thr')
				replace `name' = rnormal(`mean', `sd') if __helper != .
				drop __helper
			}
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
						count if `by' == "`i'"
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
							count if `var' == "`j'" & `by' == "`k'"
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
							sum `var' if `by' == "`k'", detail
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