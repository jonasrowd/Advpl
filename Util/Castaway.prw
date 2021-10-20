#include "TOTVS.CH"
                                                                          

User Function Navegador()

Private aPages := {}
Private nPgVist := -1

Private aSize := MsAdvSize()
Private oDlg1, oTIBrw
Private cNavegado := Space(80)                                   
Private lcont := .T.

DEFINE MSDIALOG oDlg1 TITLE "Navegador" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

cNavegado := "http://www.google.com"
oNav:= TGet():New(10,10,{|u| if(PCount()>0,cNavegado:=u,cNavegado)}, oDlg1,340,5,,,,,,,,.T.,,,,,,,,,,)   

@ 010, 350 Button oBtnIr PROMPT "Ir" Size 40,10 Action(Processa({||Navegar()},"Abrindo","Aguarde...")) Of oDlg1 Pixel     
@ 010, 390 Button oBtnImp PROMPT "Imprimir" Size 40,10 Action oTIBrw:Print() Of oDlg1 Pixel



@ 010, 430 Button oBtnAnte PROMPT "Anterior" Size 40,10 Action (Retorna()) Of oDlg1 Pixel
@ 010, 470 Button oBtnDep PROMPT "Avançar" Size 40,10 Action(Avanca()) Of oDlg1 Pixel   
@ 010, 510 Button oBtnSair PROMPT "Sair" Size 40,10 Action(Sair()) Of oDlg1 Pixel       



oTIBrw:= TIBrowser():New( 025,010,aSize[5]-640, 270, "http://www.google.com", oDlg1 )    

aaDD(aPages,"http://www.google.com")

oNav:bLostFocus := { || Valido()}


Activate MsDialog oDlg1 Centered

Return      

Static Function Valido()

Ir()

Return .T.                                                                                                         



Static Function Navegar()
     
Ir()

Return


Static Function Ir()

     oTIBrw:Navigate(AllTrim(cNavegado),oDlg1)
     aaDD(aPages,AllTrim(cNavegado))
     nPgVist := Len(aPages)

Return   
           


Static Function Avanca()

if(Len(aPages) >      nPgVist .and. Len(aPages) > 1 )
           nPgVist++   
           oTIBrw:Navigate(aPages[nPgVist],oDlg1)   
           cNavegado := aPages[nPgVist]
           oNav:Refresh()
EndIf   

Return     

Static Function Retorna()
if(nPgVist>1)
           nPgVist--
           oTIBrw:Navigate(aPages[nPgVist],oDlg1)
           cNavegado := aPages[nPgVist]
           oNav:Refresh()          
EndIf   

Return



Static Function Sair()
oDlg1:End()
Return