#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

#DEFINE IMP_SPOOL 2
#DEFINE __cCarteira "109"
#DEFINE __cMoeda    "9"

/*/{Protheus.doc} F060SEA2
	Ponto de entrada na geração do Borderô para gerar os boletos em Pdf e Enviar por E-mail
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 15/09/2021
/*/
User Function F060SEA2()

	Private lExec    := .F.
	Private cIndexName := ''
	Private cIndexKey  := ''
	Private cFilter    := ''

	DEFAULT cNota := Space(09)

	cAlias  := Alias()
	cOrd    := IndexOrd()
	cReg    := Recno()

	If SE1->E1_PORTADO <> "CX1"
		MontaRel(SEA->EA_PORTADO, SEA->EA_AGEDEP, SEA->EA_NUMCON)
	EndIf

	DbSelectArea(cAlias)
	DbSetOrder(cOrd)
	Dbgoto(cReg)

Return Nil

/*/{Protheus.doc} MontaRel
	Montagem do relatório que será impresso
	@type Function
	@version  12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function MontaRel(_xBco, _xAgencia,_xConta)

	Local oPrint
	Local nX		:= 0
	Local cNroDoc 	:= " "
	Local aDadosTit   := {}
	Local aDadosBanco := {}
	Local aDatSacado  := {}
	Local aBolText    := {"APÓS O VENCIMENTO COBRAR JUROS DE R$", "PROTESTAR APÓS 3 DIAS DE ATRASO. ","AO DIA"}
	Local aCB_RN_NN   := {}
	Local nVlrAbat	  := 0
	Local cMaIforn    := ''
	Local aDadosEmp    := {	SM0->M0_NOMECOM                                    ,;                        //[1]Nome da Empresa
							SM0->M0_ENDCOB                                     ,;                        //[2]Endereço
							AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
							"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
							"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
							"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ;     //[6]
							Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
							Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
							"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
							Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
	Private cStartPath       := GetSrvProfString("Startpath","")

	Tamanho  := "M"
	titulo   := "Impressão de Boleto com Código de Barras"
	cDesc1   := "Este programa destina-se a impressão do Boleto com Código de Barras."
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SE1"
	wnrel    := "BOLETO"
	lEnd     := .F.
	cPerg     := Padr("BLTITAU",10)
	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	aFile	 := {}
	nLastKey := 0
	lAdjustToLegacy := .T.
	lDisableSetup  := .T.
	cPathPDF := ""

	If EMPTY(SE1->E1_PARCELA)
		cNota := AllTrim(SE1->E1_NUM) + "-" + 1
	Else
		cNota := AllTrim(SE1->E1_NUM) + "-" + AllTrim(SE1->E1_PARCELA)
	EndIf

	//Instruções iniciais da geração dos boletos
	lAdjustToLegacy := .T.
	lDisableSetup   := .T.
	_cDiretorio  	:= 'c:\temp\' //'\boletos'
	_cNomeArq 		:= cNota + '.pdf'

	//VerIfica se existe o diretório, caso não existe irá tentar criar, caso negativo irá informar o usuário do problema
	If !ExistDir(_cDiretorio)
		If MakeDir(_cDiretorio) <> 0
			MsgAlert("O diretório " + Alltrim(_cDiretorio) + " não foi encontrado, contate o departamento de TI!")
			Return Self
		EndIf
	EndIf

	If cNota <>''
		oPrint := FWMSPrinter():New(_cNomeArq,IMP_PDF,lAdjustToLegacy,_cDiretorio,lDisableSetup)
	EndIf

	oPrint:SetPortrait()
	oPrint:SetResolution(72)
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(1,6,6,6) // nEsquerda, nSuperior, nDireita, nInferior
	oPrint:cPathPDF := _cDiretorio
	oPrint:lInJob   := .T.
	oPrint:lViewPDF := .F.

	DbSelectArea("SE1")

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek(FwXFilial("SF2") + SE1->(E1_NUM + E1_SERIE + E1_CLIENTE + E1_LOJA)))
		CCONDPAG := SF2->F2_COND
		DbSelectArea("SE4")
		SE4->(DbSetOrder(1))
		If SE4->(DbSeek(FwXFilial("SE4") + CCONDPAG))
			If (SE4->E4_TIPO == "1") .OR. (SE4->E4_TIPO == "5")
				APAGAMENTOS := STRTOKARR(SE4->E4_COND, ",")
			ElseIf (SE4->E4_TIPO == "8")
				APAGAMENTOS := STRTOKARR(STRTRAN(STRTRAN(SE4->E4_COND, "["), "]"), ",")
			EndIf
		EndIf
	EndIf

	DbSelectArea("SA6")
	DbSetOrder(1)
	//DbSeek(FwXFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21)
	If DbSeek(FwXFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
		Help(NIL, NIL, "ERROR_BANK", NIL, "Parâmetros de Banco do Banco/Agência/Conta/Sub-Conta inválidos",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"VerIfique se os parâmetros estão preenchidos corretamente."})
		Return
	EndIf
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	//DbSeek(FwXFilial("SEE")+MV_PAR19+MV_PAR20+MV_PAR21)
	If DbSeek(FwXFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) == .F.
		Help(NIL, NIL, "ERROR_BANK", NIL, "Parâmetros de Banco do Banco/Agência/Conta/Sub-Conta inválidos",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"VerIfique se os parâmetros estão preenchidos corretamente."})
		Return
	EndIf

	//posiciona no pedido
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(FwXFilial("SC5")+SE1->E1_PEDIDO,.T.)
	If !EMPTY(SC5->C5_CLIENTE+SC5->C5_LOJACLI).and.(SC5->C5_FILIAL+SC5->C5_NUM==SE1->E1_FILIAL+SE1->E1_PEDIDO)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(FwXFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.T.)
	Else
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(FwXFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	EndIf

	aAdd(aDadosBanco, Alltrim(SA6->A6_COD))     // [1]Numero do Banco
	aAdd(aDadosBanco, Alltrim(SA6->A6_NOME))    // [2]Nome do Banco
	aAdd(aDadosBanco, Alltrim(SA6->A6_AGENCIA)) // [3]Agência
	aAdd(aDadosBanco, Alltrim(SA6->A6_NUMCON))  // [4]Conta Corrente
	aAdd(aDadosBanco, Alltrim(SA6->A6_DVCTA))   // [5]Dígito da conta corrente
	aAdd(aDadosBanco, Alltrim(__cCarteira))     // [6]Codigo da Carteira

	_Nome1 := AllTrim(SA1->A1_NOME)
	_CGCCl := Subs(SA1->A1_CGC,1,2)+"."+Subs(SA1->A1_CGC,3,3)+"."+Subs(SA1->A1_CGC,6,3)+" / "+Subs(SA1->A1_CGC,9,4)+" - "+Subs(SA1->A1_CGC,13,2)

	If EMPTY(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
		SA1->A1_EST                                      ,;     	// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										 ,;         // [7]CGC
		SA1->A1_PESSOA									  }         // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
		SA1->A1_ESTC	                                    ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC											,;		// [7]CGC
		SA1->A1_PESSOA										 }		// [8]PESSOA
	EndIf

	cMaIforn := ALLTRIM(SA1->A1_EMFAT)   //valtencir
	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)

	DbSelectArea("SE1")
	RecLock("SE1",.F.)
		SE1->E1_NUMBCO 	:=	cNroDoc   // Nosso número (Ver fórmula para calculo)
		SE1->E1_PORTADO :=	aDadosBanco[1]
		SE1->E1_AGEDEP  :=	aDadosBanco[3]
		SE1->E1_CONTA   :=	aDadosBanco[4]
	MsUnlock()

	aCB_RN_NN := fLinhaDig(aDadosBanco[1]      ,;	// Numero do Banco
	__cMoeda            ,; 							// Codigo da Moeda
	aDadosBanco[6]      ,; 							// Codigo da Carteira
	aDadosBanco[3]      ,; 							// Codigo da Agencia
	aDadosBanco[4]      ,; 							// Codigo da Conta
	aDadosBanco[5]      ,; 							// DV da Conta
	(E1_VALOR-nVlrAbat) ,; 							// Valor do Titulo
	E1_VENCTO           ,; 							// Data de Vencimento do Titulo
	cNroDoc              ) 							// Numero do Documento no Contas a Receber

	dvNN := Alltrim(Str(Modulo10(aDadosBanco[3]+aDadosBanco[4]+aDadosBanco[6]+cNroDoc)))

	If EMPTY(SE1->E1_PARCELA)
		cNumTit := AllTrim(SE1->E1_NUM) + "-" + 1
		_NumTit := cNumTit
	Else
		cNumTit := AllTrim(SE1->E1_NUM)+"-"+AllTrim(SE1->E1_PARCELA)
	EndIf

	_ChvCli := E1_CLIENTE
	_ChvLoj := E1_LOJA
	_ChvNum := E1_NUM
	_ChvSer := E1_PREFIXO
	_ChvPar := E1_PARCELA
	aDadosTit	:= {cNumTit				,;  // [1] Número do título
	E1_EMISSAO                          ,;  // [2] Data da emissão do título
	dDataBase                    		,;  // [3] Data da emissão do boleto
	E1_VENCTO                           ,;  // [4] Data do vencimento
	(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do título
	aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
	E1_PREFIXO                          ,;  // [7] Prefixo da NF
	E1_TIPO	                           	}  	// [8] Tipo do Titulo

	ImpressB(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,dvNN)
	nX := nX + 1

	oPrint:Print()
	CpyT2S("C:\TEMP\"+_cNomeArq, "\BOLITAU" )

	DbSelectArea("SEA")
	DbGoTop()
	If !EMPTY(SEA->EA_NUMBOR)
		cPath	:= "\BOLITAU"//Caminho onde vai ser gerado o boleto grafico abaixo do System
		cNameArq:=cPath+'\'+_cNomeArq
		fEnvMail(cMaIforn,cNameArq,aCB_RN_NN[1],cNumTit)
		FERASE("C:\TEMP\"+_cNomeArq)
	EndIf
Return Nil

/*/{Protheus.doc} Impress
	Impressao dos dados do boleto em modo grafico
	@type function
	@version 12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function ImpressB(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,dvNN)

	Local oFont6
	Local oFont7
	Local oFont8
	Local oFont9
	Local oFont11c
	Local oFont10
	Local oFont14
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local nI := 0

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont6   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont7   := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8   := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c := TFont():New("Courier New",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,20,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,19,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,26,.T.,.T.,5,.T.,5,.T.,.F.)
	oPrint:StartPage()   // Inicia uma nova página

	//PRIMEIRA PARTE
	nRow1 := 0
	oPrint:Line (nRow1+0100,500,nRow1+0020, 500)
	oPrint:Line (nRow1+0100,710,nRow1+0020, 710)
	oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10 )	        // [2]Nome do Banco
	oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont20 )		// [1]Numero do Banco
	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0100,100,nRow1+0100,2300)
	oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ
	oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
	oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
	oPrint:Say  (nRow1+0300,100 ,aDatSacado[1],oFont9)				//Nome
	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1080,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)
	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título AAAAAAAA",oFont10)
	oPrint:Say  (nRow1+0450,0100,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)
	oPrint:Line (nRow1+0210, 100,nRow1+0210,1900 )
	oPrint:Line (nRow1+0310, 100,nRow1+0310,1900 )
	oPrint:Line (nRow1+0410,1050,nRow1+0410,1900 ) //---
	oPrint:Line (nRow1+0510, 100,nRow1+0510,2300 )
	oPrint:Line (nRow1+0510,1050,nRow1+0110,1050 )
	oPrint:Line (nRow1+0510,1400,nRow1+0310,1400 )
	oPrint:Line (nRow1+0310,1500,nRow1+0110,1500 ) //--
	oPrint:Line (nRow1+0510,1900,nRow1+0110,1900 )
	oPrint:Say  (nRow1+0165,1910,"(  )Mudou-seAAA"                              ,oFont8)
	oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
	oPrint:Say  (nRow1+0245,1910,"(  )Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325,1910,"(  )Não procurado"                            ,oFont8)
	oPrint:Say  (nRow1+0365,1910,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
	oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                	,oFont8)

	//SEGUNDA PARTE
	nRow2 := 0
	//Pontilhado separador
	/*
	For nI := 100 to 2300 step 50
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI
	*/
	oPrint:Line (nRow2+0620,100,nRow2+0620,2300)
	oPrint:Line (nRow2+0620,500,nRow2+0540, 500)
	oPrint:Line (nRow2+0620,710,nRow2+0540, 710)
	oPrint:Say  (nRow2+0614,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco
	oPrint:Say  (nRow2+0615,513,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco
	oPrint:Say  (nRow2+0614,1800,"Recibo do Pagador",oFont10)
	oPrint:Line (nRow2+0710,100,nRow2+0710,2300 )
	oPrint:Line (nRow2+0830,100,nRow2+0830,2300 )
	oPrint:Line (nRow2+0920,100,nRow2+0920,2300 )
	oPrint:Line (nRow2+1010,100,nRow2+1010,2300 )
	oPrint:Line (nRow2+0830,500,nRow2+1010,500)// linha vertical
	oPrint:Line (nRow2+0920,750,nRow2+1010,750)// linha vertical
	oPrint:Line (nRow2+0830,1000,nRow2+1010,1000)// linha vertical
	oPrint:Line (nRow2+0830,1300,nRow2+0920,1300)// linha vertical ultimoxxxxxxxxxxxxxxxxxx
	oPrint:Line (nRow2+0830,1480,nRow2+1010,1480)// linha vertical
	oPrint:Say  (nRow2+0640,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0695,100 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow2+0640,1810,"Vencimento"                                     ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0680,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0750,100 ,"Beneficiário"                                        ,oFont8)
	oPrint:Say  (nRow2+0790,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (nRow2+0750,1810,"Agência/Código Beneficiário",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0790,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0860,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0900,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4),oFont10)
	oPrint:Say  (nRow2+0860,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say (nRow2+0900,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say  (nRow2+0860,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (nRow2+0900,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	oPrint:Say  (nRow2+0860,1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0900,1400,"N"                                             ,oFont10)
	oPrint:Say  (nRow2+0860,1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0900,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
	oPrint:Say  (nRow2+0860,1810,"Nosso Número"                                   ,oFont8)
	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim(SE1->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0900,nCol,cString,oFont11c)
	oPrint:Say  (nRow2+0950,100 ,"Uso do Banco"                                   ,oFont8)
	oPrint:Say  (nRow2+0950,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+0990,555 ,aDadosBanco[6]                                  	,oFont10)
	oPrint:Say  (nRow2+0950,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow2+0990,805 ,"R$"                                             ,oFont10)
	oPrint:Say  (nRow2+0950,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0950,1485,"Valor"                                          ,oFont8)
	oPrint:Say  (nRow2+0950,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0990,nCol,cString ,oFont11c)
	oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8)
	oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*0.09)/30),"@E 99,999.99"))+" AO DIA"       ,oFont10)
	oPrint:Say  (nRow2+1200,100 ,aBolText[2]   ,oFont10)
	oPrint:Say  (nRow2+1250,100,"INSTRUÇÕES DE RESPONSABILIDADE DO BENEFICIÁRIO. QUALQUER"                        ,oFont10)
	oPrint:Say  (nRow2+1300,100,"DÚVIDA SOBRE ESTE BOLETO, CONTATE O BENEFICIÁRIO."                               ,oFont10)
	oPrint:Say  (nRow2+1040,1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)
	oPrint:Say  (nRow2+1430,100 ,"Pagador"                                        ,oFont8)
	oPrint:Say  (nRow2+1460,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	oPrint:Say  (nRow2+1513,400 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow2+1566,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	If aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1460,1750 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1460,1750 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow2+1619,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
	oPrint:Say  (nRow2+1665,1500,"Autenticação Mecânica",oFont8)
	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800)
	oPrint:Line (nRow2+1100,1800,nRow2+1100,2300)
	oPrint:Line (nRow2+1170,1800,nRow2+1170,2300)
	oPrint:Line (nRow2+1240,1800,nRow2+1240,2300)
	oPrint:Line (nRow2+1310,1800,nRow2+1310,2300)
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300)
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300)

	//TERCEIRA PARTE
	nRow3 := 0
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI
	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)
	oPrint:Say  (nRow3+1984,100,aDadosBanco[2],oFont10)	   	    // 	[2]Nome do Banco
	oPrint:Say  (nRow3+1975,513,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco
	oPrint:Say  (nRow3+1984,755,aCB_RN_NN[2],oFont15n)			//	Linha Digitavel do Codigo de Barras
	oPrint:Line (nRow3+2080,100,nRow3+2080,2300 )
	oPrint:Line (nRow3+2180,100,nRow3+2180,2300 )
	oPrint:Line (nRow3+2250,100,nRow3+2250,2300 )
	oPrint:Line (nRow3+2320,100,nRow3+2320,2300 )
	oPrint:Line (nRow3+2180,500 ,nRow3+2320,500 )
	oPrint:Line (nRow3+2250,750 ,nRow3+2320,750 )
	oPrint:Line (nRow3+2180,1000,nRow3+2320,1000)
	oPrint:Line (nRow3+2180,1300,nRow3+2250,1300)
	oPrint:Line (nRow3+2180,1480,nRow3+2320,1480)
	oPrint:Say  (nRow3+2020,100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2060,100 ,"APÓS O VENCIMENTO PAGUE SOMENTE NO ITAU",oFont10)
	oPrint:Say  (nRow3+2020,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2060,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
	oPrint:Say  (nRow3+2150,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2150,nCol,cString ,oFont11c)
	oPrint:Say (nRow3+2200,100 ,"Data do Documento"                             ,oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day(dDataBase),2) +"/"+ StrZero(Month(dDataBase),2) +"/"+ Right(Str(Year(dDataBase)),4), oFont10)
	oPrint:Say (nRow3+2200,505 ,"Nro.Documento"                                 ,oFont8)
	oPrint:Say (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Numero do Titulo
	oPrint:Say (nRow3+2200,1005,"Espécie Doc."                                  ,oFont8)
	oPrint:Say (nRow3+2230,1050,aDadosTit[8]									,oFont10) //Tipo do Titulo
	oPrint:Say (nRow3+2200,1305,"Aceite"                                        ,oFont8)
	oPrint:Say (nRow3+2230,1400,"N"                                             ,oFont10)
	oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                        ,oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao
	oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                 ,oFont8)
	cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Right(AllTrim(SE1->E1_NUMBCO),8)+"-"+dvNN)   //Substr(aDadosTit[6],4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                 ,oFont8)
	oPrint:Say  (nRow3+2270,505 ,"Carteira"                                     ,oFont8)
	oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                 ,oFont10)
	oPrint:Say  (nRow3+2270,755 ,"Espécie"                                      ,oFont8)
	oPrint:Say  (nRow3+2300,805 ,"R$"                                           ,oFont10)
	oPrint:Say  (nRow3+2270,1005,"Quantidade"                                   ,oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"                                        ,oFont8)
	oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)
	oPrint:Say  (nRow3+2350,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8)
	oPrint:Say  (nRow3+2450,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*0.09)/30),"@E 99,999.99"))+" AO DIA"      ,oFont10)
	oPrint:Say  (nRow3+2490,100 ,aBolText[2]   ,oFont10)
	oPrint:Say  (nRow3+2540,100,"INSTRUÇÕES DE RESPONSABILIDADE DO BENEFICIÁRIO. QUALQUER"                        ,oFont10)
	oPrint:Say  (nRow3+2590,100,"DÚVIDA SOBRE ESTE BOLETO, CONTATE O BENEFICIÁRIO."                               ,oFont10)
	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                       ,oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                           ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                         ,oFont8)
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                             ,oFont8)
	oPrint:Say  (nRow3+2710,100 ,"Pagador"                                      ,oFont8)
	oPrint:Say  (nRow3+2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"           ,oFont10)
	If aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2720,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2720,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow3+2773,400 ,aDatSacado[3]                                  ,oFont10)
	oPrint:Say  (nRow3+2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	oPrint:Say  (nRow3+2826,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)
	oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista"                             ,oFont8)
	oPrint:Say  (nRow3+2875,1500,"Autenticação Mecânica - Ficha de Compensação" ,oFont8)
	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2390,1800,nRow3+2390,2300 )//
	oPrint:Line (nRow3+2460,1800,nRow3+2460,2300 )//
	oPrint:Line (nRow3+2530,1800,nRow3+2530,2300 )//
	oPrint:Line (nRow3+2600,1800,nRow3+2600,2300 )//
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
	MSBAR("INT25",24.3,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.070,2.8,Nil,Nil,"A",.F.) //datasupri
	oPrint:EndPage() // Finaliza a página
Return Nil

/*/{Protheus.doc} fLinhaDig
	Obtencao da linha digitavel/codigo de barras
	@type function
	@version 12.1.25
	@author Microsiga
	@since 21/11/05
/*/
Static Function fLinhaDig (cCodBanco, ; // Codigo do Banco (341)
	cCodMoeda, ; // Codigo da Moeda (9)
	cCarteira, ; // Codigo da Carteira
	cAgencia , ; // Codigo da Agencia
	cConta   , ; // Codigo da Conta
	cDvConta , ; // Digito verIficador da Conta
	nValor   , ; // Valor do Titulo
	dVencto  , ; // Data de vencimento do titulo
	cNroDoc   )  // Numero do Documento Ref ao Contas a Receber

	Local cValorFinal   := StrZero(int(nValor*100),10)
	Local cFator        := StrZero(dVencto - CtoD("07/10/97"),4)
	Local cCodBar   	:= Replicate("0",43)
	Local cCampo1   	:= Replicate("0",05)+"."+Replicate("0",05)
	Local cCampo2   	:= Replicate("0",05)+"."+Replicate("0",06)
	Local cCampo3   	:= Replicate("0",05)+"."+Replicate("0",06)
	Local cCampo4   	:= Replicate("0",01)
	Local cCampo5   	:= Replicate("0",14)
	Local cTemp     	:= ""
	Local cNossoNum 	:= Right(AllTrim(SE1->E1_NUMBCO),8) // Nosso numero
	Local cDV			:= "" // Digito verIficador dos campos
	Local cLinDig		:= ""

	//Definicao do NOSSO NUMERO
	If At("-",cConta) > 0
		cDig   := Right(AllTrim(cConta),1)
		cConta := AllTrim(Str(Val(Left(cConta,At('-',cConta)-1) + cDig)))
	Else
		cConta := Val(cConta)
	EndIf
	cConta = StrZero(cConta,5)
	cNossoNum   := Alltrim(cAgencia) + Left(Alltrim(cConta),5) + cCarteira + Right(AllTrim(SE1->E1_NUMBCO),8) //cNroDoc
	cDvNN 		:= Alltrim(Str(Modulo10(cNossoNum)))
	cNossoNum   := cCarteira + cNroDoc + cDvNN
	
	//Definicao do CODIGO DE BARRAS
	cTemp := Alltrim(cCodBanco)   			+ ; // 01 a 03
	Alltrim(cCodMoeda)            			+ ; // 04 a 04
	Alltrim(cFator)               			+ ; // 06 a 09
	Alltrim(cValorFinal)          			+ ; // 10 a 19
	Alltrim(cCarteira)            			+ ; // 20 a 22
	Right(AllTrim(SE1->E1_NUMBCO),8) 		+ ; // 23 A 30
	Alltrim(cDvNN)                			+ ; // 31 a 31
	Alltrim(cAgencia)             			+ ; // 32 a 35
	Alltrim(Left(cConta,5))               	+ ; // 36 a 40
	Alltrim(cDvConta)             			+ ; // 41 a 41
	"000"                             			// 42 a 44
	cDvCB  := Alltrim(Str(modulo11(cTemp)))	// Digito VerIficador CodBarras
	cCodBar:= SubStr(cTemp,1,4) + cDvCB + SubStr(cTemp,5)// + cDvNN + SubStr(cTemp,31)
	/*
	-----------------------------------------------------
	Definicao da LINHA DIGITAVEL (Representacao Numerica)
	-----------------------------------------------------
	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
	CAMPO 1:
	AAA = Codigo do banco na Camara de Compensacao
	B = Codigo da moeda, sempre 9
	CCC = Codigo da Carteira de Cobranca
	DD = Dois primeiros digitos no nosso numero
	X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp   := cCodBanco + cCodMoeda + cCarteira + Substr(Right(AllTrim(SE1->E1_NUMBCO),8),1,2)
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo1 := SubStr(cTemp,1,5) + '.' + Alltrim(SubStr(cTemp,6)) + cDV + Space(2)
	/*
	CAMPO 2:
	DDDDDD = Restante do Nosso Numero
	E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	FFF = Tres primeiros numeros que identIficam a agencia
	Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp	:= Substr(Right(AllTrim(SE1->E1_NUMBCO),8),3) + cDvNN + Substr(cAgencia,1,3)
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo2 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(3)
	/*
	CAMPO 3:
	F = Restante do numero que identIfica a agencia
	GGGGGG = Numero da Conta + DAC da mesma
	HHH = Zeros (Nao utilizado)
	Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	*/
	cTemp   := Substr(cAgencia,4,1) + Strzero(Val(cConta),5) + Alltrim(cDvConta) + "000"
	cDV		:= Alltrim(Str(Modulo10(cTemp)))
	cCampo3 := Substr(cTemp,1,5) + '.' + Substr(cTemp,6) + cDV + Space(2)
	/*
	CAMPO 4:
	K = DAC do Codigo de Barras
	*/
	cCampo4 := cDvCB + Space(2)
	/*
	CAMPO 5:
	UUUU = Fator de Vencimento
	VVVVVVVVVV = Valor do Titulo
	*/
	cCampo5 := cFator + StrZero(int(nValor * 100),14 - Len(cFator))
	cLinDig := cCampo1 + cCampo2 + cCampo3 + cCampo4 + cCampo5
Return {cCodBar, cLinDig, cNossoNum}

/*/{Protheus.doc} Modulo10
	Cálculo do Modulo 10 para obtenção do DV dos campos do
	@type Function
	@version  12.1.25
	@author Microsoga
	@since 21/11/05
/*/
Static Function Modulo10(cData)
	Local  L,D,P := 0
	Local B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
			If (B)
				P := P * 2
					If P > 9
						P := P - 9
				End
			End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
		If D = 10
			D := 0
		End
Return D

/*/{Protheus.doc} Modulo11
	Calculo do Modulo 11 para obtencao do DV do Codigo de Barras
	@type function
	@version  12.1.25
	@author Microsoga
	@since 21/11/05
/*/
Static Function Modulo11(cData)
	Local L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	// Some o resultado de cada produto efetuado e determine o total como (D);
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
		L := L - 1
	End
	// DAC = 11 - Mod 11(D)
	D := 11 - (mod(D,11))
	// OBS: Se o resultado desta for igual a 0, 1, 10 ou 11, considere DAC = 1.
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return D

Static Function fEnvMail(_Par1,_Par2,_Par3,_Par4,_NumTit)
	Local _cServer   	:= Alltrim(GETMV("MV_RELSERV"))	//Servidor smtp
	Local _cAccount  	:= Alltrim(GETMV("BM_BOLMAIL"))	//Conta de e-mail
	Local _cPassword	:= Alltrim(GETMV("BM_BOLSNH"))	//Senha da conta de e-mail
	Local _cEnvia    	:= Alltrim(GETMV("BM_BOLMAIL"))	//Endereco de e-mail
	Local _cTo			:= "jonas.machado@bomix.com.br"// _Par1+";"+ALLTRIM(UsrRetMail(__cUserID))			//Destinatario
	Local _cMsg			:= NIL			//Corpo da Mensagem
	Local _cSubj		:= OemToAnsi('BOMIX - Boleto para Pagamento - ')+ _ChvNum	//Assunto
	Local cAttach       := _Par2

	//Se o terceiro parametro nao for passado o Subject sera padrao
	If _cSubj == NIL
		_cSubj	:= "Mensagem enviada pelo Protheus - Totvs"
	EndIf

	//Se o segundo parametro nao for passado a Mensagem sera padrao
	cQ  := " SELECT  convert(varchar, cast(E1_EMISSAO as date), 103) AS EMISSAO, E1_NUM AS NOTA,IIf( E1_PARCELA = '', 'UNICA', E1_PARCELA ) AS PARCELA, convert(varchar, cast(E1_VENCTO as date), 103) AS VENCIMENTO,E1_VALOR AS VALOR "
	cQ  += " FROM " + RetSQLName("SE1")
	cQ  += " WHERE D_E_L_E_T_ = ' ' "
	cQ  += " AND E1_SERIE   = '"+_ChvSer+"'
	cQ  += " AND E1_NUM     = '"+_ChvNum+"'
	cQ  += " AND E1_PARCELA = '"+_ChvPar+"'
	cQ  += " AND E1_CLIENTE = '"+_ChvCli+"'
	cQ  += " AND E1_LOJA = '"+_ChvLoj+"'
	cQ  += " ORDER BY E1_EMISSAO "

	TCQUERY cQ New Alias "TABTR"

	DbSelectArea("TABTR")
	DbGoTop()
	While TABTR->(!EOF())
		_cMsg := '<html>'
		_cMsg += '<body>'
		_cMsg += '<font face="arial" size="2"><p><b>Prezado Cliente</b><br>'
		_cMsg += '<font face="arial" size="2"><p><b>Razão Social: </b>'+ _Nome1+'<br>'
		_cMsg += '<font face="arial" size="2"><p><b>CNPJ/CPF: </b>'+ _CGCCl+'<br>'
		_cMsg += '<font face="arial" size="2"><p> <br>'
		_cMsg += '<b>Segue em anexo o boleto do titulo abaixo:</b><br>'
		_cMsg += '<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#F0FFFF background="" '
		_cMsg += 'border=1>'
		_cMsg += '<TBODY>'
		_cMsg +=  "<TR><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Data Emissão'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Nota Fiscal'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Parcela'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Vencimento'+"</B></TD><TD style=text-align:center; bgcolor=#FF7F50><B>"+'Valor'+"</B></TD>"
		_cMsg +=  "<TR><TD style=text-align:center>"+AllTrim(TABTR->EMISSAO)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->NOTA)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->PARCELA)+"</TD><TD style=text-align:center>"+AllTrim(TABTR->VENCIMENTO)+"</TD><TD style=text-align:center>"+TRANSFORM(TABTR->VALOR, "@E 99,999,999.99")+"</TD>"
		_cMsg += '</TBODY></TABLE>'
		_cMsg += '<font face="arial" size="2"><p> <br>'
		_cMsg += '<font face="arial" size="2"><p> <br>'
		_cMsg += '<b>ATENÇÃO - Este e-mail foi disparado automaticamente pelo nosso sistema, favor não responder.</b><br>'
		_cMsg += 'Caso não tenha recebido o boleto bancário, favor entrar em contato, através do e-mail creditocobranca@bomix.com.br, ou através do telefone abaixo:<br>'
		_cMsg += '+55 (71) 3215-8600 - Falar com Setor Financeiro<br>'
		_cMsg += '<font face="arial" size="2"><p> <br>'
		_cMsg += 'Atenciosamente,<br>'
		_cMsg += '<font face="arial" size="2"><p><b>'+alltrim(SM0->M0_NOMECOM)+'</b><br>'
		_cMsg += '<font face="arial" size="2"><p><b>CNPJ: '+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+Subs(SM0->M0_CGC,6,3)+" / "+Subs(SM0->M0_CGC,9,4)+" - "+Subs(SM0->M0_CGC,13,2)+'</b><br>'
		_cMsg += '</font>'
		_cMsg += '</body></html>'

		TABTR->(dbSkip())
	End

	TABTR->(DBCLOSEAREA())

	//Se o primeiro parametro nao for passado nao sera enviado o email|
	If _cTo == NIL .Or. EMPTY(_cTo)
		Aviso(SM0->M0_NOMECOM,"O e-mail não pôde ser enviado, pois o primeiro parâmetro (DESTINATÁRIO) não foi preenchido.",{"Ok"},2,"Erro de envio!")
		Return(.F.)
	EndIf
	//Conecta ao servidor de SMTP
	CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result lConectou
	//Caso o servidor SMTP do cliente necessite de autenticacao
	//sera necessario habilitar o parametro MV_RELAUTH.
	If GETMV("MV_RELAUTH")
		If !MailAuth( _cAccount, _cPassword )
			Aviso(SM0->M0_NOMECOM,"Falha na autenticação do Usuário!",{"Ok"},1,"Atenção")
			DISCONNECT SMTP SERVER RESULT lDisConectou
			Return(.F.)
		EndIf
	EndIf
	//Verifica se houve conexao com o servidor SMTP
	If !lConectou
		Aviso(SM0->M0_NOMECOM,"Erro ao conectar servidor de E-Mail (SMTP) - " + _cServer+CHR(10)+CHR(13)+;
		"Solicite ao Administrador que seja verIficado os parâmretros e senhas do servidor de E-Mail (SMTP)",{"Ok"},3,"Atenção!")
		Return(.F.)
	EndIf
	//Envia o e-mail
	SEND MAIL FROM _cEnvia TO Alltrim(_cTo) SUBJECT _cSubj BODY _cMsg ATTACHMENT  cAttach RESULT lEnviado
	//Verifica possiveis erros durante o envio do e-mail
	If lEnviado
		Aviso(SM0->M0_NOMECOM,"Foi enviado e-mail para "+_cTo+" com sucesso!",{"Ok"},3,"Informação!")
	Else
		_cMsg := ""
		GET MAIL ERROR _cMsg
		Aviso(SM0->M0_NOMECOM,_cMsg,{"Ok"},3,"Atenção!")
		Return(.F.)
	EndIf
	//Desconecta o servidor de SMTP
	DISCONNECT SMTP SERVER Result lDisConectou
Return (.T.)
