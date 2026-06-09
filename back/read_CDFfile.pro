
id = CDF_OPEN('example.CDF')

inquire = CDF_INQUIRE(id)
  HELP, inquire, /STRUCT

varinq = CDF_VARINQ(id,'Dpt')
  HELP, varinq, /STRUCT

CDF_VARGET1, id, 'Dpt', Dpt
  PRINT, 'Dpt = ', Dpt

CDF_CLOSE, id
