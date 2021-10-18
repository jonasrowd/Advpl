/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±± 
±ºPrograma  ³MTA105LIN ºAutor  ³Alexandre R. Bento  º Data ³  04/05/07   º±± 
±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±ºDesc.     ³Ponto de entrada apos confirmacao da inclusao da solicitacaoº±± 
±º          ³e antes de gravar os dados no SCP.                          º±± 
±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºUso       ³ AP10                                                       º±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
*/ 
    

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#include "msobject.ch"
#include "tbiconn.ch"  

USER FUNCTION MTA105LIN() 


Local _lRet    := .T. 
Local nCCSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CC"})   
Local nPRODSCP := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_PRODUTO"})   
Local nQTDSCP  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_QUANT"})   
Local _nLoc    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_LOCAL"})   
//Local nPeca    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_PECA"})   
//Local nCTSCP   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_CONTA"}) 
//Local nOrdem   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_ORDEM"}) 
//Local nMaquina := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_MAQUINA"}) 
//Local nTurnRet := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "CP_TURNRET"}) 
//Local _aGrupo  := pswret() 


//Local nD       := 0 


Local cCC,cProd, xS 


//If UPPER(ALLTRIM(FUNNAME()))$"NHEST151" 
//	cCC    := M->CP_CC 
//	cProd  := M->CP_PRODUTO 
//	cLoc   := M->CP_LOCAL 
//	nQuant := M->CP_QUANT 
//	cCTSCP := M->CP_CONTA 
//	cOrdem := M->CP_ORDEM 
//Else 
	cCC    := Acols[N][nCCSCP] 
	cProd  := Acols[N][nPRODSCP] 
	cLoc   := Acols[N][_nLoc] 
	nQuant := Acols[N][nQTDSCP]		 
//	cCTSCP := ACOLS[N][nCTSCP]	 
//	cOrdem := Acols[n][nOrdem] 
		 
	If Acols[n][len(aHeader)+1]  //nao pega quando a linha esta deletada 
		Return .T. 
	EndIf 
	 
//EndIf 

               
  
    If SB2->(DbSeek(xFilial("SB2")+cProd+cLoc))  
     
       //-- pega o saldo do produto 
       nSaldo := SB2->B2_QATU-SB2->B2_QEMPSA 
        
       //-- decrementa o saldo de um possivel produto igual no acols 
       For xS:=1 to Len(aCols) 
       	If n <> xS .and. aCols[xS][nPRODSCP]==aCols[n][nPRODSCP] 
       		nSaldo -= aCols[xS][nQTDSCP] 
       	EndIf 
       Next 
        
       If nQuant > nSaldo //saldo atual - qtde empenhada de S.A.(solicitacao ao almoxarifado) 
          MSGBOX('A Quantidade Solicitada é Maior que a Disponivel no Estoque, Favor Verifique!!',OemToAnsi('Atenção'),'ALERT') 
          _lRet:=.F. 
       Endif 
    Else  
       MSGBOX(OemToAnsi('Não Existe o cadastro deste Produto no Estoque, Favor Verifique !!!!'),'Estoque','ALERT') 
       _lRet:=.F. 
    Endif 

  
 Return(_lRet)   
