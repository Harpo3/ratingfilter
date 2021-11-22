# ratingfilter
A musicbase utility to generate filtered output based on popularimeter (POPM)
rating values

Usage: ratingfilter.sh [option]

options:
-d specify delimiter (default: ^)
-h display this help file
-i specify input file and path (default: $HOME/.musiclib.dsv)
-n exclude file header in output file where input file contains header
-o specify output file and path (default: $HOME/.popmfiltered.dsv)
-p specify lowest POPM rating number for output (default: 1)
-r specify highest POPM rating number for output (default: 255)
-s specify POPM column number of input file (default: automatic 
   lookup using header containing the title "Rating") 

Uses awk to filter music library tracks by POPM field when POPM is 
included in the input database. Default input file is $HOME/.musiclib.dsv.
Output is a data-separated-values (DSV) file with carat "^" (or other 
specified) delimiter. Output file, by default, uses uses headers and carat
delimiter. Default output file is $HOME/.popmfiltered.dsv.
