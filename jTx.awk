BEGIN{
	save_index = -1
	depth = 0
}

{
	cur_line = $0
	rec_index = 0
	brack_count = 0
	str_count = 0
	flag = 0
	for(ptr=1;ptr<=length(cur_line);ptr++){
		cur_char = substr(cur_line, ptr, 1)
		if(cur_char == "{"){
			brack_count++;
		}
		else if(cur_char == "\""){
			inner_ptr = ptr+1
			for(inner_ptr = ptr+1;inner_ptr<=length(cur_line);inner_ptr++){
				cur_char = substr(cur_line, inner_ptr, 1)
				if(cur_char == "\""){
					rec[rec_index] = substr(cur_line, ptr+1, inner_ptr-ptr-1)
					rec_index++
					break;
				}
			}
			ptr = inner_ptr
		}
		else if(cur_char == "}"){
			flag = 1
			break
		}
	}
	if(flag){
		if(save_index != -1){
			depth--
			result = ""
			for(i=0;i<depth;i++){
				result = result "\t"
			}
			result = result "</" save[save_index] ">"
			save_index--
			print result
		}
	}
	else{
		if(brack_count > 0){
			if(rec_index == 1){
				result = ""
				for(i=0;i<depth;i++){
					result = result "\t"
				}
				depth++
				result = result "<" rec[0] ">"
				save_index++
				save[save_index] = rec[0]
				print result
			}
		}
		else if(brack_count == 0){
			result =  ""
			for(i=0;i<depth;i++){
				result = result "\t"
			}
			result =  result "<" rec[0] ">" rec[1] "</" rec[0] ">"
			print result
		}
	}
}

END{
}
