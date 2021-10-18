#Include 'Totvs.ch'

#Define CRLF chr(10) + chr(13)

/*/{Protheus.doc} BXMENATR
	Fun��o respons�vel por trazer os t�tulos em aberto na tela de or�amento.
	@type Function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 21/07/2021
	@param xPar, variant, inclus�o
	@param pCliente, variant, C�digo do cliente
	@param pLoja, variant, Loja do cliente
	@return Logical, lRet
/*/
User Function BXMENATR(xPar, pCliente, pLoja)

	Local oSayTela
	Local oBtnOK
	Local oBtnCancel
	Local oBtnLiberar
	Local cBx			:= 'B'
	Local lRet 			:= .F.
	Local xLinha 		:= 10
	Local nTotal 		:= 0
	Local cJust 		:= ''
	Local cMensagem1	:= ""
	Local cMensagem2	:= ""
	Local cMensagem3	:= ""
	Public oDlg

	BEGIN SEQUENCE
		If FWCodFil() != "030101"
			If !( RetCodUsr() $ Supergetmv("BM_USERLIB",.F.,RetCodUsr(),) )
				lRet := .F.
				Help(NIL, NIL, "USR_PERM", NIL, "Usu�rio " + PswChave(RetCodUsr()) + " sem permiss�o de libera��o.",1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor comercial."})
				BREAK
			ElseIf SC5->C5_BXSTATU $ ("L|A|E")
				lRet := .F.
				Help(NIL, NIL, "PED_LIB", NIL, "Pedido de venda j� liberado.",1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor comercial."})
				BREAK
			EndIf

			DBSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(FWxFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)

			While SC6->(!Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
				nTotal += SC6->C6_VALOR
				SC6->(DBSkip())
			End

			cMensagem1 := "Deseja Liberar o pedido: "+ SC5->C5_NUM
			cMensagem2 := "Cliente: " + SA1->A1_NOME
			cMensagem3 := "Valor do Pedido R$" + AllTrim(Transform(nTotal,PesqPict("SC6","C6_VALOR")))

			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Aten��o") FROM 000,000 TO 180,650 PIXEL
			oSayTela	:= TSay():New(10,10,{||AllTrim(cMensagem1)},oDlg,,,,,,.T.,,,100,400,,,,,,)
			oSayTela	:= TSay():New(20,10,{||AllTrim(cMensagem2)},oDlg,,,,,,.T.,,,100,400,,,,,,)
			oSayTela	:= TSay():New(30,10,{||AllTrim(cMensagem3)},oDlg,,,,,,.T.,,,100,400,,,,,,)
			oBtnOK		:= TButton():New(060,010+xLinha,"Visualizar"		,oDlg,{||u_FFATG004(pCliente,pLoja)},50,20,,,,.T.,,"",,,,.F.)
			oBtnLiberar	:= TButton():New(060,070+xLinha,"Liberar Produ��o"	,oDlg,{||lRet := .T.,cBx   := libProd(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.) //P
			oBtnLiberar	:= TButton():New(060,130+xLinha,"Liberar Venda"		,oDlg,{||lRet := .T.,cBx   := libVend(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.) //L
			oBtnLiberar	:= TButton():New(060,190+xLinha,"Liberar Expedi��o"	,oDlg,{||lRet := .T.,cBx   := libExped(cBx)	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.) //E
			oBtnCancel	:= TButton():New(060,250+xLinha,"N�o Liberar"		,oDlg,{||lRet := .F.,cJust := justLibC()	,oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
			ACTIVATE MSDIALOG oDlg CENTERED

			If lRet
				RecLock("SC5",.F.)
					SC5->C5_BXSTATU := cBx
					SC5->C5_BLQ 	:= ''
					SC5->C5_LIBEROK := 'L'
					If SC5->C5_BXSTATU $ 'P'
						SC5->C5_FSSTBI 	:= "BLOQUEADO LO"
					Else
						SC5->C5_FSSTBI := 'LIBERADO'
					EndIf
				MsUnlock()

				SC6->(DbGoTop())
				If SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
					While SC6->(!Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
						DBSelectArea("SC9")
						DBSeek(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM)
						If (Found())
							RecLock("SC9", .F.)
								C9_BLCRED := ""
							MsUnlock()
						EndIf
						SC6->(DBSkip())
					End
				EndIf

				DBSelectArea("Z07")
				RecLock("Z07",.T.)
					Z07->Z07_FILIAL := SC5->C5_FILIAL
					Z07->Z07_PEDIDO := SC5->C5_NUM
					If cBx = 'P'
						Z07->Z07_JUSTIF := "Liberado Produ��o Usu�rio: " + PswChave(RetCodUsr())
						Z07_USUAR		:= RetCodUsr()
					ElseIf cBx = 'E'
						Z07->Z07_JUSTIF := "Liberado Expedi��o Usu�rio: " + PswChave(RetCodUsr())
						Z07_USUAR		:= RetCodUsr()
					ElseIf cBx = 'L'
						Z07->Z07_JUSTIF := "Liberado Venda Usu�rio: " + PswChave(RetCodUsr())
						Z07_USUAR		:= RetCodUsr()
					EndIf
					Z07->Z07_DATA := dDataBase
					Z07->Z07_HORA := SUBSTRING(TIME(),1,5)
				MsUnlock()
			Else
				RecLock("Z07",.T.)
					Z07->Z07_FILIAL := SC5->C5_FILIAL
					Z07->Z07_PEDIDO := SC5->C5_NUM
					Z07->Z07_JUSTIF := AllTrim(cJust) + ": " + PswChave(RetCodUsr())
					Z07->Z07_DATA 	:= dDataBase
					Z07->Z07_HORA 	:= SUBSTRING(TIME(),1,5)
					Z07_USUAR		:= RetCodUsr()
				MsUnlock()
			EndIf
		EndIf
	END SEQUENCE
Return  lRet

/*/{Protheus.doc} libExped
	Libera pedido para expedi��o.
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 21/07/2021
	@param _cBx, variant, Par�metro vindo da libera��o
	@return variant, Valor do status
/*/
Static Function libExped(_cBx)

	If MsgYesNo("Deseja Liberar a Expedi��o deste Pedido: "+SC5->C5_NUM +"?", 'Aten��o')
		_cBx := 'E'
	Endif

Return _cBx

/*/{Protheus.doc} libProd
	Atribui o status P para libera��o de Produ��o.
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 28/07/2021
	@param _cBx, variant, Par�metro vindo da libera��o
	@return variant, Valor do status
/*/
Static Function libProd(_cBx)
	
	If MsgYesNo("Deseja Liberar a produ��o deste Pedido: "+SC5->C5_NUM, 'Aten��o')
		_cBx := 'P'
	Endif

Return _cBx

/*/{Protheus.doc} libVend
	Libera��o da venda
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 28/07/2021
	@param _cBx, variant, Par�metro vindo da libera��o
	@return variant, Valor do status
/*/
Static Function libVend(_cBx)

	If MsgYesNo("Deseja Liberar a venda deste Pedido: "+SC5->C5_NUM+"?", 'Aten��o')
		_cBx := 'L'
	Endif

Return _cBx

/*/{Protheus.doc} justLibC
	Tela de justificativa  da libera��o de cr�dito
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 21/07/2021
	@return variant, Nil
/*/
Static Function justLibC()

	Local oGet1
	Local cGet1 := Space(254)
	Local oPanel1
	Local oSay1
	Local oSButton1
	Local oSButton2
	Local cAct := ""
	Static oDlgJust

	DEFINE MSDIALOG oDlgJust TITLE "Informe o motivo." FROM 000, 000  TO 180, 680 COLORS 0, 16777215 PIXEL

		@ 003, 004 MSPANEL oPanel1 SIZE 327, 078 OF oDlgJust COLORS 0, 16777215 RAISED
		@ 016, 010 SAY oSay1 PROMPT "Justificativa:" SIZE 063, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
		@ 033, 012 MSGET oGet1 VAR cGet1 SIZE 311, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
		DEFINE SBUTTON oSButton1 FROM 057, 295 TYPE 01 OF oPanel1 ENABLE ACTION {|| cAct := "1", oDlgJust:end() }
		DEFINE SBUTTON oSButton2 FROM 057, 264 TYPE 02 OF oPanel1 ENABLE ACTION {|| oDlgJust:end() }

	ACTIVATE MSDIALOG oDlgJust CENTERED

		If !Empty(cGet1)
			Return cGet1
		EndIf

Return Nil
