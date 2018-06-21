BEGIN{IFS = "\t"; OFS = ","} FNR > 1{print "["$2,$2,$6,$7,"\"foo\"", "\"foo\"""]",""}
