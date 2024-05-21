qui {
	
	if 1 {
		cls
		clear
		set more off
		set varabbrev on
		timer clear
		macro drop _all
	}
	
	if 3 {
		noi di "Thank you so much for participating in the piloting program for prompt based programming approach!"
		noi di " "
		noi di "In this program, we will run  programs to complete certain "
		noi di "analytic goals. You will first experience a prompt-based program "
		noi di "and then experience a traditional syntax based program. "
		noi di "They are exactly the same programs, just with different approaches."
		noi di "Please read carefully about the instructions in each scenario."
		noi di " "
		noi di "At anytime you wish to exit the program, please just enter: EXIT"
		noi di "Through the command window/console."
		noi di " "
		noi di "Thank you again for your participation!"
		noi di "Please hit enter to proceed", _request(proceed)
		
		global proceed : di strtrim("${proceed}")
		if (strupper("${proceed}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
	}
	
	if 2 {
		noi di "Now loading dofiles for piloting: "
		noi di "Demostration....................................................", _continue
		qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/demo.ado"
		noi di "Done"
		noi di "Piloting Program................................................", _continue
		qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/prompt_v1.ado"
		noi di "Done"
		/*
		noi di "Intermediate Level..............................................", _continue
		qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/pilot.ado"
		noi di "Done"
		noi di "Advanced Level..................................................", _continue
		qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/program753.ado"
		noi di "Done"
		*/
		noi di " "
	}
	
	if 3 { // ask for levels to exclude
		noi di "Before we actually get to real of programs, "
		noi di "do you wish to try a demo to experience what is going to happen?"
		noi di "(1/Y - Yes, 0/N - No)", _request(confirm)
		
		global confirm : di strtrim(stritrim("${confirm}"))
		
		if (strupper("${confirm}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		else {
			local c_helper : di strupper(substr("${confirm}", 1, 1))
			if (("`c_helper'" == "Y") | ("`c_helper'" == "1")) {
				qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/demo.ado"
				noi demo
			}
			else {
				noi di "Ok! Let's skip demo."
			}
		}
		noi di " "
	}
	
	if 4 {
		noi di as error "Pilot Program: "
		/*
		noi di in g "Do you wish to skip this level?"
		noi di "(1/Y - Yes, 0/N - No)", _request(skip)
		*/
		global skip : di "N"
		noi di in g " "
		if (strupper("${skip}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		else {
			local c_helper : di strupper(substr("${skip}", 1, 1))
			if (("`c_helper'" != "Y") & ("`c_helper'" != "1")) {
				qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/prompt_v1.ado"
				noi prompt_v1
			}
			else {
				noi di "Ok! Let's skip this level."
			}
		}
		noi di " "
	}
	
	if 0 {
		noi di as error "Intermediate Level: "
		noi di in g "Do you wish to skip this level?"
		noi di "(1/Y - Yes, 0/N - No)", _request(skip)
		if (strupper("${skip}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		else {
			local c_helper : di strupper(substr("${skip}", 1, 1))
			if (("`c_helper'" != "Y") & ("`c_helper'" != "1")) {
				qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/pilot.ado"
				noi pilot
			}
			else {
				noi di "Ok! Let's skip this level."
			}
		}
		noi di " "
	}
	
	if 0 {
		noi di as error "Advanced Level: "
		noi di in g "Do you wish to skip this level?"
		noi di "(1/Y - Yes, 0/N - No)", _request(skip)
		if (strupper("${skip}") == "EXIT") {
			noi di " "
			noi di as error "Program Terminated"
			noi di in g " "
			exit
		}
		else {
			local c_helper : di strupper(substr("${skip}", 1, 1))
			if (("`c_helper'" != "Y") & ("`c_helper'" != "1")) {
				qui do "https://raw.githubusercontent.com/Vince-Jin/Prompt/main/program753.ado"
				noi program753
			}
			else {
				noi di "Ok! Let's skip this level."
			}
		}
		noi di " "
	}
	
	if 7 {
		noi di "Now you completed this pilot program!"
		noi di "Generating the log file for running time: "
		capture log close
		log using pilot_log.txt, text replace
		noi di "Running time for Pilot Programs: "
		noi di "Prompt Based (Q1): ${srt1}"
		noi di "Traditional (Q2): ${srt2}"
		noi di " "
		/*
		noi di "Running time for Intermediate Level: "
		noi di "Prompt Based (Q4): ${irt1}"
		noi di "Traditional (Q5): ${irt2}"
		noi di " "
		noi di "Running time for Advanced Level: "
		noi di "Prompt Based (Q7): ${crt1}"
		noi di "Traditional (Q8): ${crt2}"
		*/
		noi di " "
		capture log close
		noi di "Log file succesfully generated!"
		noi di "Thank you again for you participation! "
		noi di "Please fill our user experience survey at: "
		noi di "https://docs.google.com/spreadsheets/d/1oQxx83eX7sIIDbyV8frowY8EXuYpRAuudRxnVdfNSQg/edit?usp=sharing"
	}
}