###
###
###           C-SHELL SCRIPT
###
###

if (-e log)   \rm log
if (-e a.out) \rm a.out
limit stacksize unlimited

      set optg = (-I/usr/local/include -lmylib)
      set optg = ($optg -lcurl -llapack -lblas -lfftpack5)
      set optg = ($optg -lnetcdf -lnetcdff)
      set optg = ($optg -fbounds-check -g -Wall)

      set include = -I/work/code/sub/mods

      set fc = gfortran
      set opt = ($optg)

########
      set idir =

      ls -1 $idir/INPUT.dat   >  input.io
      echo  `pwd`/OUTPUT.dat  > output.io

      ln -s  input.io fort.21
      ln -s output.io fort.41

      $fc -o ./a.out ./main.f90 $opt $include

      ./a.out >& ./log
      cat log

\rm ./fort.*
\rm ./a.out
\rm ./*.io

tput bel
tput bel
