BEGIN {
}

{
	out = FILENAME
	a = match(out, /\./)
	a -= 1
	b = substr(out, 0, a)
	print b
	c = b ".json"
	print c
}

END {

}
