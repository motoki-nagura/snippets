
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                    ;;;;
;;;;           PLOTTING BY IDL          ;;;;
;;;;                                    ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


openr, 1, 'out.dat'
readu, 1, 
close, 1



; ===================================================================
;                              Plotting
; ===================================================================



JUMP_PLOT:

fnameo = './fig.ps'

set_plot,'ps'
device,filename=fnameo,/color,/portrait
device,xsize=17,ysize=12,xoffset=1,yoffset=1
;device, /encapsulated
;device, decomposed=0

!p.font=0  &  !p.charsize=1.5
!x.style=1  &  !y.style=1
!p.thick=3  &  !x.thick=3  &  !y.thick=3  &  !p.charthick=3

; -------------------------------------------------------------------
; ===================================================================
; ...................................................................

!p.multi=0  &  !p.noerase=0  &  !p.region=0  &  !p.charsize=3/4
!p.thick=1  &  !p.charthick=1  &  !x.thick=1  &  !Y.thick=1
device,/close  &  set_plot,'x'


END
