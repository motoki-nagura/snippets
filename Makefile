# macro
OPTIONS = -Dread_sbc -Dlinear
FC      = gfortran
CFLAGS  = -g -O2 -L/usr/lib -I/usr/include -fbounds-check -fcheck=do -fcheck=mem
LFLAGS  = -lnetcdff -lnetcdf -L/usr/lib -I/usr/include 
OBJ = param.o dyn.o init.o adv.o check.o input.o obc.o ave_out.o output.o sub.o main.o

#   For Fortran NetCDF library
# FC    = gfortran
# COPTS = -I/usr/local/Cellar/netcdf-fortran/4.6.2/include  -g -Wall -Wno-unused-variable -Wno-unused-parameter -O2
# IOPTS = -I/usr/local/Cellar/netcdf-fortran/4.6.2/include -I/usr/local/Cellar/netcdf-fortran/4.6.2/include
# LOPTS = -L/usr/local/Cellar/netcdf-fortran/4.6.2/lib -lnetcdff
# FOPTS = -fbounds-check -fcheck=do -fcheck=mem -Wunused

# rules
%.o: %.f90
	$(FC) -c $(CFLAGS) $(OPTIONS) -o $@ $<

%.o: %.F90
	$(FC) -c $(CFLAGS) -cpp $(OPTIONS) -o $@ $<

a.out: $(OBJ)
	$(FC) -o a.out $^ $(LFLAGS) 

clean:
	\rm *.o *.mod

