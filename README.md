# ratingfilter
A musicbase utility to generate filtered output based on popularimeter (POPM)
rating values

Produces a rating-filtered database file (default: $HOME/.popmfiltered.dsv). It uses the database produced with musicbase.sh as FILE, and the POPMCOL (column) containing the POPM values. POPM values of zero or blank  are filtered by default. Max is 255. Users can specify different POPM minimum and/or maximum values. Output file uses headers and carat delimiter unless otherwise specified. As explained above, POPM min and max defaults can be set globally by creating a file $HOME/.musicbase.conf
