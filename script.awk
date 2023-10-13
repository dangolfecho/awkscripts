BEGIN {
}

{
	out = FILENAME
	a = match(out, /\./)
	a -= 1
	b = substr(out, 0, a)
	c = b ".json"
	cur = $0
	print cur
	for (i=0; i<length(cur); i++) {
		print substr(cur, i, 1)
	}

}

END {

}
