#!/bin/bash

  idir=""
  
  ls -1 $idir/INPUT.dat   >  input.io
  echo  `pwd`/OUTPUT.dat  > output.io

  file_name_only="${file_name##*/}"    #  remove directory name
  head="${file_name_only%.*}"          #  remove extension
  
  ln -s  input.io fort.21
  ln -s output.io fort.41
  
exit

