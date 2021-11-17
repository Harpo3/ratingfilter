# ratingfilter
A musicbase utility to generate filtered output based on POPM rating values

Usage: ratingfilter.sh [option] FILE POPMCOL

options:

-d specify delimiter (default: ^)

-h display this help file

-n exclude output file header where input file contains header

-o specify output file and path (default: $HOME/.popmfiltered.dsv)

-p specify lowest POPM rating number for output (default: 64)

-r specify highest POPM rating number for output (default: 255)

Uses awk to filter music library tracks by POPM field when POPM is 
included in the input database. Output is a data-separated-values
(DSV) file with carat "^" (or other specified) delimiter.

Specify input database FILE (musicbase db) and POPMCOL (column number 
containing POPM values).

POPM values of zero or blank, and less than 64 are filtered by default. 
Specify a different POPM minimum value and/or a lower maximum value 
than the default of 255.

Output file uses headers and carat delimiter unless otherwise specified. 
Output is $HOME/.popmfiltered.dsv unless otherwise specified.
