#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"


User Function valhora
choraini := M->BC_FSHRINI

msgbox(choraini)


hora = Val(Substr(cHoraini,1,2))
min  = Val(Substr(cHoraini,4,2))


If (Hora < 0 .Or. hora > 23) .Or. (min < 0 .Or. min > 59)
      MsgBox("Hora informada com erro!!! ")
      choraini="  :  "
      Return(choraini)
EndIf


return (choraini)



