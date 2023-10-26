BEGIN {
	#LINT = 1
	depth = 0
	items_index = 0
	nesting_index = 0
	value_index = 0
	save_value_index = 0
	#neg
	#multiple
	#exists
	mode = 0
}

{
	cur_line = $0
	ptr = 0
	for(ptr=1;ptr<=length(cur_line);ptr++){
		cur_char = substr(cur_line, ptr, 1)
		cur_char2 = substr(cur_line, ptr, 2)
		if(cur_char2 != "</"){
			if(cur_char == "<"){
				depth++
				inner_ptr = ptr+1
				for(inner_ptr = ptr+1;inner_ptr<=length(cur_line);inner_ptr++){
					cur_char3 = substr(cur_line, inner_ptr, 1)
					if(cur_char3 == ">"){
						ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
						items[items_index] = ob_string
						items_index++
						exists_index = ob_string "," depth
						if(exists[exists_index] == 1){
							multiple[exists_index] = 1
						}
						exists[exists_index] = 1
					}
					else if(cur_char3 == " "){
						ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
						items[items_index] = ob_string
						items_index++
						exists_index = ob_string "," depth
						if(exists[exists_index] == 1){
							multiple[exists_index] = 1
						}
						exists[exists_index] = 1
						depth++
						inner_ptr2 = inner_ptr+1
					}
				}
				ptr = inner_ptr
			}
		}
		else{
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
	print "{"
	#print "{" > out
	out_line = ""
	flag = 0
	for(items_iter = 0; items_iter < items_index; items_iter++){
		out_line = ""
		flag = 0
		depth_info = nesting[items_iter]
		for(d=0;d<depth_info;d++){
			out_line = out_line "\t"
		}
		if(value[items_iter] != ""){
			if(nesting[items_iter++] < nesting[items_iter]){
				out_line = out_line "\"" items[items_iter] "\"" ": " "\"" value[items_iter] "\""
				flag = 1
			}
			else{
				out_line = out_line "\"" items[items_iter] "\"" ": "  "\"" value[items_iter] "\"" ","
			}
		}
		else{
			if(multiple[items[items_iter]] == 1){
				out_line = out_line "\"" items[items_iter] "\"" ": [{"
			}
			else{
				out_line = out_line "\"" items[items_iter] "\"" ": {"
			}
		}
		print out_line
	}
	print "}"
	#print "}" > out
	out = "debug.txt"
	print "\n" > out
	print "items" > out
	for(i in items){
		print i " " items[i] >> out
	}
	print "\n" > out
	print "nesting" > out
	for(i in nesting){
		print i " " nesting[i] >> out
	}
	print "\n" > out
	print "value" > out
	for(i in value){
		print i " " value[i] >> out
	}
	print "\n" > out
	print "multiple" > out
	for(i in multiple){
		print i " " multiple[i] >> out
	}
	print "\n" > out
	print "exists" > out
	for(i in exists){
		print i " " exists[i] >> out
	}
}
