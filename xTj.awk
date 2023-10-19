BEGIN {
	LINT = 1
	out = "result.json"
	depth = -1
	items_index = 0
	nesting_index = 0
	value_index = 0
	save_value_index = 0
	#multiple
	#exists
}

{
	mode = 0
	start_index = 0
	current_line = $0
	for(ind=1;ind<=length(current_line);ind++){
		current_char = substr(current_line, ind, 1)
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
				save_value_index = items_index
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
				save_value_index = items_index
				items_index++
				if(ind != length(current_line)){
					mode = 3
					start_index = ind + 1
				}
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
				start_index = current_char + 2
				ind++
				items[items_index] = obtained_str
				value_index = items_index
				items_index++
				nesting[nesting_index] = depth
				nesting_index++
			}
			else if(current_char == "\""){
				length_of_str = ind - start_index + 1
				obtained_str = substr(current_line, start_index, length_of_str)
				value[value_index] = obtained_str
				start_index = current_char + 1
			}
			else if(current_char == ">"){
				if(ind != length(current_line)){
					mode = 3
					value_index = items_index
					start_index = ind + 1
				}
			}
		}
		else if(mode == 3){
			if(current_char == "<"){
				length_of_str = ind - start_index
				obtained_str = substr(current_line, start_index, length_of_str)
				value[save_value_index] = obtained_str
			}
			else if(current_char == "/"){
				depth--;
				mode = 0
			}
		}
	}
}

END {
	items_iter = 0
	nesting_iter = 0
	value_iter = 0
	#multiple
	#exists
	cur_depth = 0
	print "{" > out
	out_line = ""
	for(items_iter = 0; items_iter < items_ind; items_iter++){

	}
	print "}" > out
}
