alias localip="ifconfig | sed -n -e 's/127\.0\.0\.1 //g' -e 's/ *inet \([0-9.]*\).*/\1/gp'"
