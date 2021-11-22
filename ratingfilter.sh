#!/bin/bash
set -e
print_help(){
cat << 'EOF'

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

The default ranges for popularimeter (POPM) rating categories, used by
Kid3, Windows Media Player, and Winamp, are:

Group        Rating Stars    POPM Val  POPM Range Assumed
1            One             1         1-32
2            Two             64        33-96 
3            Three           128       97-160
4            Four            196       161-228
5            Five            255       229-255

POPM values of zero or blank are filtered by default. Revise POPM min
and max values as needed to make output fit the POPM rating scheme for
your library. This can be done with a configuration file or by adding 
-p and -r option flags to override defaults and/or configuration file 
settings. Custom POPM min and max values (and custom POPM rating group
ranges) can be applied globally by creating a local file 
$HOME/.musicbase.conf and using this format example (do not add 
anything else):

group1low=1
group2low=33 
group3low=97 
group4low=161
group5low=229
group1high=32
group2high=96
group3high=160
group4high=228
group5high=255
popmmin=1
popmmax=255

EOF
}
# default variable values that can be stored in config file
popmmin=1
popmmax=255
popmcolnum=""
# If configuration file exists, secure file & override default values
configfile=$"$HOME/.musicbase.conf"
if [[ -f "$configfile" ]]
then
    # run security checks on config file and remove any potential malicious code
    # remove any character in file not specific to letters, numbers and equal sign used
    sed -i 's/[^a,c,e,g,h,i,l,m,n,o,p,r,t,u,w,x,=,0-9]//g' $configfile
    sed -i -e '/^[^gpt]/d' $configfile # remove all lines with a first letter not g,p, or t     
    sed -i -r '/^.{,8}$/d' $configfile # remove all lines that are not 9-17 characters long
    sed -i '/^.\{17\}./d' $configfile   
    sed -i '/=[0-9]/!d' $configfile # remove all lines w/ no equal sign followed by a number 
    . $configfile # override default POPM min and max values using config variable values
fi
# default variable values that can be changed using option flags
musicdb=$"$HOME/.musiclib.dsv"
outputfile=$"$HOME/.popmfiltered.dsv"
mydelimiter="^"
excludeheader="no"
# Use getops to set any user-assigned options; can override config file value(s)
while getopts ":d:hi:no:p:r:s:" opt; do
  case $opt in
    d)
      mydelimiter=$OPTARG 
      ;;
    h) 
      print_help
      exit 0;;
    i)      
      musicdb=$OPTARG
      ;;
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
    s)
      popmcolnum=$OPTARG
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
#Look up column number for Rating from musicbase db if not stored in config file
if [ -n "$musicdb" ] && [[ $popmcolnum == "" ]]
then
    popmcolnum=$(echo $(head -1 $musicdb | tr '^' '\n' | cat -n | grep "Rating") | sed -r 's/^([^.]+).*$/\1/; s/^[^0-9]*([0-9]+).*$/\1/')
fi
popmcolnum2="\$""$popmcolnum"
cat /dev/null > "$outputfile"
if [[ $excludeheader == "no" ]] 
then
    awk -F "$mydelimiter" '{if (NR==1) { print }}' "$musicdb" > "$outputfile"
fi
awk -F "$mydelimiter" "{ if (""$popmcolnum2"" >= ""$popmmin"" && ""$popmcolnum2"" <= ""$popmmax"") { print } }" "$musicdb" >> "$outputfile"
