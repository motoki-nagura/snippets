  open (io, file='out.dat', status='unknown', &
    &     form='unformatted', access='direct',&
    &     recl=(imax*jmax)*4)
  write(io,rec=1)   data(1:imax,1:jmax)
  close(io)
