;**********************************************
;
;   Examples for procedures and functions
;
;**********************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;--------------------
;  procedure "pro1"
;--------------------
procedure pro1(in1,in2)
local tmp1,tmp2
begin
;  ... do some calculation
end

;--------------------
;  function "func1"
;--------------------
function func1(in1,in2)
local tmp3,tmp4
begin
;  ... do some calculation
  return(tmp3)
end

;--------------------
;  main body
;--------------------
pro1( in1, in2 )

result = func1( in1, in2 )

end
