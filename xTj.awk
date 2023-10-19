BEGIN {
	LINT = 1
	out = "result.json"
	depth = -1
	items_index = 0
	nesting_index = 0
	mode = 0
	start_index = 0
	value_index = 0
	#multiple
	#exists
}

{
	current_line = $0
	for(ind=1;ind<=length(current_line);ind++){
		current_char = substr(current_line, ind, 1)
		print current_char
		if(mode == 0){
			if(current_char == "<"){
				mode = 1
				start_index = ind + 1
				depth++;
			}
		}
		else if(mode == 1){
			if(current_char == " "){
				mode = 2
				length_of_str = ind - start_index
				obtained_str = substr(current_line, start_index, length_of_str)
				items[items_index] = obtained_str
				items_index++
				nesting[nesting_index] = depth
				nesting_index++
				if(exists[obtained_str] == ""){
					exists[obtained_str] = 1
					multiple[obtained_str] = 1
				}
				else{
					multiple[obtained_str] = 1
				}
				start_index = current_char + 1
			}
			else if(current_char == ">"){
				mode = 0
				length_of_str = ind - start_index
				obtained_str = substr(current_line, start_index, length_of_str)
				items[items_index] = obtained_str
				items_index++
				nesting[nesting_index] = depth
				nesting_index++
				if(exists[obtained_str] == ""){
					exists[obtained_str] = 1
					multiple[obtained_str] = 1
				}
				else{
					multiple[obtained_str] = 1
				}
			}
		}
		else if(mode == 2){
			if(current_char == "="){
				length_of_str = ind-start_index
				obtained_str = substr(current_line, start_index, length_of_str)
				start_index = current_char + 1
				items[items_index] = obtained_str
			}
		}
	}
}

END {
	print "DONE :)"
}
