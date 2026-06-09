program main
!  use mpi_indices
  implicit none
  include 'mpif.h'

  integer :: ierr_mpi, my_id, num_procs

    call MPI_INIT (ierr_mpi)

    call MPI_COMM_RANK (MPI_COMM_WORLD, my_id,     ierr_mpi)
    call MPI_COMM_SIZE (MPI_COMM_WORLD, num_procs, ierr_mpi)

  write (*,*) 'my_id, num_procs = ',my_id, num_procs

    call MPI_FINALIZE (ierr_mpi)

  write (*,*) 'finished.'

end program main
