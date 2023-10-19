BEGIN {
	out = "result.json"
	items_index = 0
	nesting_index = 0
	#attributes
	#multiple
}

{
	current_line = $0
	for(ind=0;ind<length(current_line);ind++){
		current_char = substr(current_line, 0, 1)
		if(current_char == "<"){
			print current_char
		}
	}
}

END {
	print "DONE :)"
}
