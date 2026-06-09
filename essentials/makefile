# macro

FC    = gfortran
COPTS = -g -O2
IOPTS = -I/usr/include 
LOPTS = -lmylib -lnetcdff -lnetcdf
FOPTS = -fbounds-check -fcheck=do -fcheck=mem -Wunused

OBJ   = main.o

VPATH = ./:/work/code/sub

# rules
%.o: %.f90
	$(FC) -c -o $@ $< $(COPTS) $(IOPTS) $(FOPTS)

a.out: $(OBJ)
	$(FC) -o a.out $^ $(LOPTS) $(IOPTS)

run:
	./a.out | tee log

clean:
	\rm *.o fort.* *.mod

