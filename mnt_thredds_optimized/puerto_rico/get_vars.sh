#process ncdump output to strip it down to just variable names

 ncdump -h KFmods_inner_CESM/1985/wrfextr_d01_1985-12  | grep "("  | grep -v "description" | grep -v "UNLIMITED" | awk '{print $2}' | cut -f1 -d"("
