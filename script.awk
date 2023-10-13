BEGIN {
	depth = 0
	arr[0] = "start"
	arr_index = 1
	arr_values[0] = 0
	values_index = 1
	mode = 0
}

{
	out = FILENAME
	a = match(out, /\./)
	a -= 1
	b = substr(out, 0, a)
	c = b ".json"
	cur = $0
	print cur
	mode = 0
	start = 0
	for (i=0; i<length(cur); i++) {
		char1 = substr(cur, i, 1)
		if(char1 == "<"){
			depth++;
			start = i+1
			mode = 1
		}
		if(mode == 1){
			for(j=i; j<length(cur); j++) {
				char2 = substr(cur, j, 1)
				if(char2 == " ") {
					str_length = j-start
					str = substr(cur, start, str_length)
					arr[arr_index] = str
					arr_values[values_index] = 1
					arr_index++
					values_index++
					mode = 2
					i = j
					break
				}
				else if(char2 ==  ">"){
					mode = 0
				}
				else if(char2 == "/" && substr(cur, j+1, 1) == ">") {
					depth--;
					mode = 0
					j++
				}
			}
		}
		else if(mode == 2){

		}
	}
}

END {

}
