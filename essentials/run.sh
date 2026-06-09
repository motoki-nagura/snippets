#!/bin/bash
###
###
###           BASH SCRIPT
###
###

  if [ -e log ]  ; then \rm log   ; fi 
  if [ -e a.out ]; then \rm a.out ; fi

  #----- Compile ------#
  fc="gfortran"
  optl="-g -O2 -I/usr/include -L/usr/lib"
  optl="$optl -lmylib -lnetcdff -lnetcdf"
  optg="-fbounds-check -fcheck=do -fcheck=mem"
  opte=""

  #  fc="ifort-14.0"
  #  optl="-I/usr/local/include -L/Users/nagura/lib -lmylib"
  #  optl="$optl -lmylib -lnetcdff -lnetcdf"
  #  optl="$optl  -llapack -lblas -lfftpack5"
  #  optg="-warn unused -CB -g"
  #   #  optg="-debug -O0 -Wl,-no_pie -warn unused -CB -g"
  #  opte="-assume byterecl"  #  for consistency with gfortran

  optc="-cpp"
  include="-I/work/code/sub/mods"

  ${fc} ./main.f90 $optl $optg $optc $opte $include

  #----- Run ------#
  idir=""
  
  ls -1 $idir/INPUT.dat   >  input.io
  echo  `pwd`/OUTPUT.dat  > output.io

  only_file_name="${file_name##*/}"    #  remove directory name
  head="${only_file_name%.*}"          #  remove extension
  
  ln -s  input.io fort.21
  ln -s output.io fort.41
  
  ./a.out | tee log
  
  #----- Clear files & notify ------#
  \rm ./fort.*
  \rm ./a.out
  \rm ./*.io
#  \rm *.i90 a.out.dwarf
  
  tput bel
  tput bel

