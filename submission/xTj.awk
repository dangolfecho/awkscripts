BEGIN {
	depth = 0
	items_index = 0
	save_value_index = 0
	#neg
	#multiple
	#exists
}

{
	flag = 0
	value_flag = 0
	cur_line = $0
	ptr = 0
	val = 1
	for(val = 1; val<=length(cur_line); val++){
		cur_char = substr(cur_line, val , 1)
		if(cur_char != " "){
			break
		}
	}
	for(ptr=val;ptr<=length(cur_line);ptr++){
		cur_char = substr(cur_line, ptr, 1)
		cur_char2 = substr(cur_line, ptr, 2)
		if(flag == 1){
			inner_ptr = ptr
			for(inner_ptr = ptr; inner_ptr<=length(cur_line); inner_ptr++){
				cur_char3 = substr(cur_line, inner_ptr, 1)
				if(cur_char3 == "="){
					ob_string = substr(cur_line, ptr, inner_ptr-ptr)
					items[items_index] = ob_string
					nesting[items_index] = depth
					items_index++
					exists_index = ob_string "," depth
					if(exists[exists_index] == 1){
						multiple[exists_index] = 1
					}
					exists[exists_index] = 1
					ptr = inner_ptr	
					break
				}
				else if(cur_char3 == ">"){
					ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-2)
					ind=items_index-1
					value[ind] = ob_string
					ptr=inner_ptr
					items[items_index] = items[ind]
					nesting[items_index] = depth
					items_index++
					depth--
					flag = 0
					break
				}
			}
		}
		else if(cur_char2 != "</"){
			if(cur_char == "<"){
				depth++
				inner_ptr = ptr+1
				for(inner_ptr = ptr+1;inner_ptr<=length(cur_line);inner_ptr++){
					cur_char3 = substr(cur_line, inner_ptr, 1)
					if(cur_char3 == ">"){
						if(value_flag == 0){
							ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
							items[items_index] = ob_string
							nesting[items_index] = depth
							if(items[items_index-1] == ob_string){
								multiple[ob_string] = 1
							}
							items_index++
							exists_index = ob_string "," depth
							if(exists[exists_index] == 1){
								multiple[exists_index] = 1
							}
							exists[exists_index] = 1
						}
						else if(value_flag == 1){
							ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
							ind = items_index-1
							value[ind] = ob_string
							depth--
						}
						ptr = inner_ptr
						break
					}
					else if(cur_char3 == " "){
						ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
						items[items_index] = ob_string
						nesting[items_index] = depth
						if(items[items_index-1] == ob_string){
							multiple[ob_string] = 1
						}
						items_index++
						exists_index = ob_string "," depth
						if(exists[exists_index] == 1){
							multiple[exists_index] = 1
						}
						exists[exists_index] = 1
						depth++
						inner_ptr2 = inner_ptr+1
						ptr = inner_ptr
						flag = 1
						break
					}
					else if(cur_char3 == "="){
						ob_string = substr(cur_line, ptr+1, inner_ptr-ptr-1)
						items[items_index] = ob_string
						nesting[items_index] = ob_string
						nesting[items_index] = depth
						items_index++
						exists_index = ob_string "," depth
						if(exists[exists_index] == 1){
							multiple[exists_index] = 1
						}
						exists[exists_index] = 1
						inner_ptr2 = inner_ptr+1
						value_flag = 1
						ptr = inner_ptr
						break
					}
				}
			}
			else{
				inner_ptr = ptr
				for(inner_ptr = ptr;inner_ptr<=length(cur_line);inner_ptr++){
					cur_char3 = substr(cur_line, inner_ptr, 1)
					if(cur_char3 == "<"){
						len = inner_ptr - ptr
						ob_string = substr(cur_line, ptr, len)
						ind = items_index-1
						value[ind] = ob_string
						ptr = inner_ptr-1
						break
					}
				}
			}
		}
		else{
			inner_ptr = ptr+2
			for(inner_ptr = ptr+2;inner_ptr<=length(cur_line);inner_ptr++){
				cur_char3 = substr(cur_line, inner_ptr, 1)
				if(cur_char3 == ">"){
					ob_string = substr(cur_line, ptr+2, inner_ptr-ptr-2)
					items[items_index] = ob_string
					nesting[items_index] = depth
					neg[items_index] = 1
					items_index++
					depth--
				}
			}
			ptr = inner_ptr
		}
	}
}

END {
	nesting[items_index] = 0
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
	mul_flag = 0
	for(items_iter = 0; items_iter < items_index; items_iter++){
		out_line = ""
		flag = 0
		depth_info = nesting[items_iter]
		for(d=0;d<depth_info;d++){
			out_line = out_line "\t"
		}
		if(value[items_iter] != ""){
			if(nesting[items_iter+2] < nesting[items_iter]){
				out_line = out_line "\"" items[items_iter] "\"" ": "  "\"" value[items_iter] "\""
			}
			else{
				out_line = out_line "\"" items[items_iter] "\"" ": "  "\"" value[items_iter] "\"" ","
				items_iter++
			}
		}
		else{
			if(neg[items_iter] == 1){
				if(mul_flag==1 && items[items_iter+1] == mul_item && items[items_iter] == mul_item){
					out_line = out_line "},"
				}
				else if(mul_flag == 1 && items[items_iter+1] != mul_item && items[items_iter] == mul_item){
					out_line = out_line "}]"
					mul_flag = 0
				}
				else if(nesting[items_iter+1] < nesting[items_iter] && mul_flag == 0){
					out_line = out_line "}"
				}
			}
			else if(nesting[items_iter+1] < nesting[items_iter]){
				print "HERE"
				out_line = out_line "}"
			}
			else{
				if(multiple[items[items_iter]] == 1 && mul_flag == 0){
					out_line = out_line "\"" items[items_iter] "\": [{"
					mul_flag = 1
					mul_item = items[items_iter]
				}
				else{
					if(items[items_iter] == mul_item){
						out_line = out_line "{"
					}
					else{
						cur_depth = nesting[items_iter]
						next_depth = nesting[items_iter]
						out_line = out_line "\"" items[items_iter] "\"" ": {"
					}
				}
			}
		}
		print out_line
	}
	print "}"
}
