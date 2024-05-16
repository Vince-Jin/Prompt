qui {
	capture program drop demo
	program define demo
		qui {
			
			local des_s = 10
			local req_s = 10
			
			local ds1 : di "Welcome to the demo!"
			local ds2 : di " "
			local ds3 : di "In this demo, you will be experiencing a processs that is"
			local ds4 : di "similar to running each set of programs"
			local ds5 : di " "
			
			forvalues i = 1/5 {
				foreach j in `ds`i'' {
					noi di "`j'", _continue
					sleep `des_s'
				}
				noi di ""
			}
			
			if 1 {
				local ds1 : di "In every set, we will first run the prompt-based version"
				local ds2 : di "of program, and then run the traditional syntax version"
				local ds3 : di " "
				local ds4 : di "We will begin with our analytical goal for this set"
				local ds5 : di "As demo, we will set it to: "
				
				forvalues i = 1/5 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `des_s'
					}
					noi di ""
				}
				
				noi di as error "Displaying a random text"
				noi di in g "Now, let's proceed to the programs"
				noi di " "
				noi di as error "The First Approach We Will See In Demo Is:"
				noi di as error "Prompt-based Approach"
				noi di in g " "
				local ds1 : di "Here is the analytical goal: "
				local ds2 : di "Displaying this line of string: Hello World!"
				local ds3 : di " "
				local ds4 : di "In actual programs, these analytical goals will come with"
				local ds5 : di "more complicated instruction, please read carefully"
				
				forvalues i = 1/5 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				local ds1 : di "After the goal, the program will ask for your inputs"
				local ds2 : di "This means the prompt-based program is now running"
				local ds3 : di "like this: "
				local ds4 : di " "
				local ds5 : di "Please enter the text that needs to be displayed"
				local ds6 : di " "
				
				forvalues i = 1/6 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				timer clear 1
				timer on 1
				local ds1 : di "Per analytical, we wish to display: Hello World!"
				local ds2 : di "So we need to input this string thorugh the command window"
				
				forvalues i = 1/2 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				noi di "Let's do this now - please enter the text", _request(text)
				
				global text : di strtrim(stritrim("${text}"))
				
				if (strupper("${text}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in  g " "
					exit
				}
				
				local ds1 : di "After receving your input through command window"
				local ds2 : di "The program will check it with analytical goals"
				local ds3 : di "If it is correct, then it will proceed"
				local ds4 : di "If not, it will ask you to input again"
				
				forvalues i = 1/4 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				while ("${text}" != "Hello World!") {
					noi di " "
					noi di "The text entered is not the text from analytical goal"
					noi di "Please check and re-enter", _request(text)
					
					global text : di strtrim(stritrim("${text}"))
				
					if (strupper("${text}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in  g " "
						exit
					}
				}
				
				local ds1 : di " "
				local ds2 : di "Now you have passed program's check!"
				local ds3 : di " "
				local ds4 : di "After all input and check is done, the program will run"
				local ds5 : di "to solve the analytical goals"
				local ds6 : di " "
				local ds7 : di "Text displayed: ${text}"
				
				forvalues i = 1/7 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				timer off 1
				qui timer list
				global drt1 : di "`r(t1)'"
				
				local ds1 : di " "
				local ds2 : di "Now let's proceed to traditional-syntax approach"
				local ds3 : di " "
				local ds4 : di "There will be a clear title to indicate this approach is"
				local ds5 : di "under execution"
				local ds6 : di " "
				
				forvalues i = 1/6 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				noi di as error "The Second Approach We Will See in Demo Is: "
				noi di "Syntax-based Approach"
				noi di in g " "
				
				local ds1 : di "For traditional syntax approach, you will be given a "
				local ds2 : di "program name of: creation"
				local ds3 : di "In each set, this creation program takes in different"
				local ds4 : di "options, and the list of options will be given to you"
				local ds5 : di "without clear instructions to mock a real world example"
				local ds6 : di "of a collaborator created program without instructions"
				local ds7 : di " "
				local ds8 : di "In our demo, it takes these option: "
				local ds9 : di "text(string)"
				local ds10 : di " "
				
				local ds11 : di "This time the analytical goal is:"
				local ds12 : di "Displaying: World, Hello!"
				
				forvalues i = 1/12 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				timer clear 2
				timer on 2
				noi di " "
				
				local ds1 : di "After showing the analytic goal, the program will ask"
				local ds2 : di "for your input of the program call using creation"
				local ds3 : di "This means you will need to enter things like: "
				
				forvalues i = 1/3 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				noi di as error "creation, text()"
				noi di in g "Again, the program will check on the call"
				local ds1 : di "If it is incorrect, you will be asked to re-enter"
				
				local ds2 : di "Since our analytic goal is to display: World, Hello!"
				local ds3 : di `"So we should enter: creation, text("World, Hello!")"'
				
				forvalues i = 1/3 {
					foreach j in `ds`i'' {
						noi di `"`j'"', _continue
						sleep `req_s'
					}
					noi di ""
				}
				
				noi di "Let's give it a try - please enter here", _request(command)
				
				global command : di subinstr(strtrim(stritrim(`"${command}"')), `"""', "", .)
				
				if (strupper("${command}") == "EXIT") {
					noi di " "
					noi di as error "Program Terminated"
					noi di in  g " "
					exit
				}
				
				local must text
				
				local opt : di stritrim(strtrim(substr(subinstr("${command}", `"""', "", .), (strpos("${command}", ",") + 1), .)))
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
						local ds : di "Do you wish to have a hint on mandatory option list?"
						local ds : di "(Yes - Y/1, No - N/0)", _request(hint)
						
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
							noi di "text()" 
							noi di " "
						}
					}
					
					noi di "One or more mandatory options are missing in the call."
					noi di "Please check and try again", _request(command)
					global command : di subinstr(strtrim(stritrim(`"${command}"')), `"""', "", .)
					if (strupper("${command}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in  g " "
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
			
				local var_helper : di substr("`opt'", strpos("`opt'", "text("), .)
				local var_end_pos = strpos("`var_helper'", ")")
				local var_len = (`var_end_pos' - 1 - 5)
				local var_str : di substr("`var_helper'", 6, `var_len')
				while ("`var_str'" != "World, Hello!") {
					
					noi di "The text entered to text() option is not the same as analytic goal"
					noi di "Please check and re-enter", _request(command)
					
					global command : di subinstr(strtrim(stritrim(`"${command}"')), `"""', "", .)
					if (strupper("${command}") == "EXIT") {
						noi di " "
						noi di as error "Program Terminated"
						noi di in  g " "
						exit
					}
					
					local must text
					
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
							local ds : di "Do you wish to have a hint on mandatory option list?"
							local ds : di "(Yes - Y/1, No - N/0)", _request(hint)
							
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
								noi di "text()"
								noi di " "
							}
						}
						
						noi di "One or more mandatory options are missing in the call."
						noi di "Please check and try again", _request(command)
						global command : di subinstr(strtrim(stritrim(`"${command}"')), `"""', "", .)
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
				
					local var_helper : di substr("`opt'", strpos("`opt'", "text("), .)
					local var_end_pos = strpos("`var_helper'", ")")
					local var_len = (`var_end_pos' - 1 - 5)
					local var_str : di substr("`var_helper'", 6, `var_len')
				}
				
				local ds1 : di "Now you have passed the check!"
				local ds2 : di "The creation program will be executed to achieve analytic goals: "
				forvalues i = 1/2 {
					foreach j in `ds`i'' {
						noi di "`j'", _continue
						sleep `req_s'
					}
					noi di ""
				}
				timer off 2
				qui timer list
				global drt2 : di "`r(t2)'"
				noi di " "
				noi ${command}
				local ds1 : di " "
				local ds2 : di "Now you have reached the end of programs"
				local ds3 : di "The running time info should be automatically displayed: "
				local ds4 : di "Running Time Information: "
				local ds5 : di "Prompt Based (Q1): ${drt1}"
				local ds6 : di "Traditional (Q2): ${drt2}"
				local ds7 : di " "
				local ds8 : di "Thank you for using this demo! Now please proceed to actual programs!"
				
				forvalues i = 1/8 {
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
		qui {
			syntax, text(string)
			
			noi di "Text Displayed: `text'"
		}
	end
}