#!/bin/bash
set -e
print_help(){
cat << 'EOF'

A musicbase utility to generate filtered output based on POPM rating values

Usage: removebypopm.sh [option] FILE POPMCOL

options:
-d specify delimiter (default: ^)
-h display this help file
-n exclude output file header where input file contains header
-o specify output file and path (default: $HOME/.popmfiltered.dsv)
-p specify lowest POPM rating number for output (default: 1)
-r specify highest POPM rating number for output (default: 255)

Uses awk to filter music library tracks by POPM field when POPM is 
included in the input database. Output is a data-separated-values
(DSV) file with carat "^" (or other specified) delimiter. 

Specify input database FILE (musicbase db) and POPMCOL (column number 
containing POPM values). 

POPM values of zero or blank are filtered by default. 
Specify a different POPM minimum value and/or a lower maximum value 
than the default of 255. 

Output file uses headers and carat delimiter unless otherwise specified. 
Output is $HOME/.popmfiltered.dsv unless otherwise specified.

Some suggested ranges for popularimeter (POPM) rating categories, used by
Kid3, Windows Media Player, and Winamp:

Group        Rating Stars    POPM Val  POPM Range Assumed
1            One             1         1-32
2            Two             64        33-96 
3            Three           128       97-160
4            Four            196       161-228
5            Five            255       229-255

EOF
}
outputfile=$"$HOME/.popmfiltered.dsv"
popmmin=1
popmmax=255
mydelimiter="^"
excludeheader="no"
# Use getops to set any user-assigned options
while getopts ":d:hno:p:r:" opt; do
  case $opt in
    d)
      mydelimiter=$OPTARG 
      ;;
    h) 
      print_help
      exit 0;;
    n)
      excludeheader="yes" 
      ;;
    o)      
      outputfile=$OPTARG
      ;;
    p)      
      popmmin=$OPTARG
      ;;
    r)      
      popmmax=$OPTARG
      ;;
    \?)
      printf 'Invalid option: -%s\n' "$OPTARG"
      exit 1
      ;;
    :)
      printf 'Option requires an argument: %s\n' "$OPTARG"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

## Verify user provided required, valid path and time argument
if [[ -z "$1" ]] || [[ -z "$2" ]]
then
    printf  '\n%s\n' "Missing positional argument(s)"
    print_help
    exit 1
fi

# positional variables
musicdb=$1
popmcolnum="\$""$2"
cat /dev/null > "$outputfile"
if [[ $excludeheader == "no" ]] 
then
awk -F "$mydelimiter" '{if (NR==1) { print }}' "$musicdb" > "$outputfile"
fi
awk -F "$mydelimiter" "{ if (""$popmcolnum"" >= ""$popmmin"" && ""$popmcolnum"" <= ""$popmmax"") { print } }" "$musicdb" >> "$outputfile"
