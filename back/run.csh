###
###
###           C-SHELL SCRIPT
###
###

  if (-e log)   \rm log
  if (-e a.out) \rm a.out
  limit stacksize unlimited
  
  set optl = (-I/usr/local/include -lmylib)
  set optl = ($optl -lcurl -llapack -lblas -lfftpack5)
  set optl = ($optl -lnetcdff -lnetcdf)
  
  set optg = ( -debug -O0 -Wl,-no_pie -warn unused -CB -g )
  
  set optc = ( -cpp )
  
  set include = -I/work/code/sub/mods
  
  ##
  set idir =
  
  ls -1 $idir/INPUT.dat   >  input.io
  echo  `pwd`/OUTPUT.dat  > output.io
  
  ln -s  input.io fort.21
  ln -s output.io fort.41
  
  ifort ./main.f90 $optl $optg $optc $include
  
  ./a.out >& ./log
  cat log
  
  \rm ./fort.*
  \rm ./a.out
  \rm ./*.io
  \rm *.i90
  \rm a.out.dwarf
  
  tput bel
  tput bel

