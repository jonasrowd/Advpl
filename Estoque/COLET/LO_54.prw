#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

User Function LO_54  

	Local c_Usuario  := SubStr(UsrRetName(__CUSERID), 1, TamSX3("ZW_USUARIO")[1])
    Local c_Op       := Space(13)
    Local c_Produto  := Space(TamSX3("B1_COD")[1])
	Local c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
	Local c_LocDest  := "54"
    Local n_Quant    := 0
    Local n_ConfQtd  := 0
    Local c_Opcao    := Space(1)
	Local a_Area     := GetArea()
	Local l_Ret      := .T.
	Local a_Tela     := VTSave(0, 0, 4, 10)
	Local d_DtValid  := Ctod("  /  /    ")
	Local lOk	     := .T.
	Local aItem	     := {}
	Local a_Itens    := {}
	Local nOpcAuto   := 3 
	Local l_Continua := .T.

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
    Private INCLUI      := .T.

	While l_Continua
		VTClear Screen
	    c_Produto  := Space(TamSX3("B1_COD")[1])
		c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
		c_LocDest  := "54"
	    n_Quant    := 0
	    n_ConfQtd  := 0
		aItem	   := {}
		l_Produto  := .F.
	
		While l_Produto == .F.
			@ 0, 0 VTSAY "Produto: " VTGET c_Produto Pict "@!"
		    VTRead
	
			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif
	
		   	dbSelectArea("SB1")
	   		dbSetOrder(1)
			If dbSeek(xFilial("SB1") + c_Produto)
			   	l_Rastro := IIF(SB1->B1_RASTRO == "L", .T., .F.)
				l_Produto := .T.
			Else
				VTAlert("Produto " + AllTrim(c_Produto) + " n�o foi encontrado no Cadastro de Produtos. Por favor verifique se o c�digo do produto foi digitado corretamente.", "Aviso")
			Endif
	   	End
	
		If l_Rastro
			l_Lote := .F.
			a_Lote := {}
		
			c_Qry := " SELECT B8_LOTECTL, B8_DTVALID FROM " + RetSqlName("SB8") + " SB8 " + chr(13)
		  	c_Qry += " WHERE B8_FILIAL='" + XFILIAL("SB8") + "' AND B8_SALDO > 0 AND B8_DTVALID >= '" + DTOS(DDATABASE) + "' AND B8_LOCAL = 'LO' AND B8_PRODUTO = '" + c_Produto + "' AND SB8.D_E_L_E_T_<>'*' " + chr(13)
	
			TCQUERY c_Qry NEW ALIAS QRY
	
			dbSelectArea("QRY")
			dbGoTop()
			While QRY->(!EoF())
//				If aScan(a_Lote, c_Lote) == 0
				If aScan(a_Lote, {|x| x[1] == QRY->B8_LOTECTL}) == 0
					AADD(a_Lote, {QRY->B8_LOTECTL, Stod(QRY->B8_DTVALID)})
				Endif

				QRY->(dbSkip())
			End
	
			QRY->(dbCloseArea())
	
			While l_Lote == .F.
				@ 1, 0 VTSAY "Lote: " VTGET c_Lote Pict "@!"
			    VTRead
			    
			    c_Lote := Padr(c_Lote, TamSX3("D3_LOTECTL")[1])
	
				If VtLastKey() == 27
					RestArea(a_Area)
					VTClear Screen			
					VTRestore(0, 0, 4, 10, a_Tela)
					Return .F.
				Endif
	
//				If aScan(a_Lote, c_Lote) == 0
				If aScan(a_Lote, {|x| x[1] == c_Lote}) == 0
					VTAlert("Lote " + AllTrim(c_Lote) + " inv�lido ou vencido. Por favor verificar se o lote foi preenchido corretamente.", "Aviso")
				Else
					l_Lote := .T.
				Endif
			End

			If !Empty(c_Lote)
				d_DtValid := a_Lote[aScan(a_Lote, {|x| x[1] == c_Lote})][2]

/*
				dbSelectArea("SB8")
				dbSetOrder(5)
				dbSeek(xFilial("SB8") + c_Produto + c_Lote)

				d_DtValid := SB8->B8_DTVALID

			   	SB8->(dbCloseArea())
*/
			Endif
		Else
			@ 1, 0 VTSAY "Lote: S/ CONTROLE"
		Endif
	
		l_Quant := .F.
	
		While l_Quant == .F.
			@ 2, 0 VTSAY "Quantidade: " VTGET n_Quant
		    VTRead
	
			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif
	
			If SuperGetMV('MV_ESTNEG')=='N'
				dbSelectArea("SB2")
				SB2->(dbSetOrder(1))
				SB2->(dbSeek(xFilial("SB2") + c_Produto + "LO"))
				n_Saldo := SaldoMov()
				If n_Quant > n_Saldo
					VTALERT("Quantidade excede o saldo dispon�vel no armaz�m TE. Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
				Else
					If n_Quant > 0
						l_Quant := .T.
					Else
						VTAlert("Quantidade inv�lida para efetuar transfer�ncia. Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
					Endif
				Endif

			   	SB2->(dbCloseArea())
			Else
				If n_Quant > 0
					l_Quant := .T.
				Else
					VTAlert("Quantidade inv�lida para efetuar transfer�ncia. Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
				Endif
			Endif
		End
		
		@ 2, 0 VTSAY "Quantidade:" + Transform(n_Quant, "@E 99,999.99") + Space(25)
	
		l_ConfQtd := .F.
	
		While l_ConfQtd == .F.
			@ 3, 0 VTSAY "Confirme: " VTGET n_ConfQtd
		    VTRead
	
			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif
	
			If n_Quant == n_ConfQtd
				l_ConfQtd := .T.
			Else
				VTAlert("Confirma��o da quantidade est� divergente da quantidade digitada anteriormente. Por favor verificar se a confirma��o da quantidade foi preenchida corretamente.", "Aviso")
			Endif
		End
	
		@ 3, 0 VTSAY "Confirme: " + Transform(n_ConfQtd, "@E 99,999.99") + Space(25)
	
		l_LocDest := .F.
	
		While l_LocDest == .F.
			@ 4, 0 VTSAY "Local Destino: " VTGET c_LocDest Pict "@!"
		    VTRead
	
			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif
	
			dbSelectArea("NNR")
			dbSetOrder(1)
			If dbSeek(xFilial("NNR") + c_LocDest) .And. c_LocDest $ "54"
				l_LocDest := .T.
			Else
				VTAlert("Armazem de destino inv�lido para esta opera��o. Por favor verificar se o c�digo do armaz�m foi preenchido corretamente.", "Aviso")
			Endif
		End
	
		aadd(aItem, c_Produto, Nil)  	//D3_COD		
		aadd(aItem, SB1->B1_DESC, Nil)  	//D3_DESCRI				
		aadd(aItem, SB1->B1_UM, Nil)		//D3_UM		
		aadd(aItem, "LO", Nil)      		//D3_LOCAL		
		aadd(aItem, Space(TamSX3("D3_LOCALIZ")[1]), Nil)				//D3_LOCALIZ		
		aadd(aItem, c_Produto, Nil)  	//D3_COD		
		aadd(aItem, SB1->B1_DESC, Nil)   //D3_DESCRI				
		aadd(aItem, SB1->B1_UM, Nil)		//D3_UM		
		aadd(aItem, c_LocDest, Nil) 		//D3_LOCAL		
		aadd(aItem, Space(TamSX3("D3_LOCALIZ")[1]), Nil)				//D3_LOCALIZ		
		aadd(aItem, Space(TamSX3("D3_NUMSERI")[1]), Nil)          	//D3_NUMSERI		
		aadd(aItem, c_Lote, Nil)			//D3_LOTECTL  		
		aadd(aItem, Space(TamSX3("D3_NUMLOTE")[1]), Nil)        		//D3_NUMLOTE		
		aadd(aItem, d_DtValid, Nil)		//D3_DTVALID
		aadd(aItem, CriaVar("D3_POTENCI"), Nil)				//D3_POTENCI		
		aadd(aItem, n_Quant, Nil)		//D3_QUANT		
		aadd(aItem, CriaVar("D3_QTSEGUM"), Nil)				//D3_QTSEGUM		
		aadd(aItem, CriaVar("D3_ESTORNO"), Nil)   			//D3_ESTORNO		
		aadd(aItem, CriaVar("D3_NUMSEQ"), Nil)        		//D3_NUMSEQ 		
		aadd(aItem, c_Lote, Nil)			//D3_LOTECTL		
		aadd(aItem, d_DtValid, Nil)		//D3_DTVALID
//			aadd(aItem, Space(TamSX3("D3_SERVIC")[1]), Nil)				//D3_SERVIC
		aadd(aItem, Space(TamSX3("D3_ITEMGRD")[1]), Nil)				//D3_ITEMGRD

		aadd(a_Itens, aItem)

		@ 5, 0 VTSAY Replicate("-", 30)
/*
		While (c_Opcao $ "SN") == .F.
			@ 6, 0 VTSAY "Continuar (S/N)? " VTGET c_Opcao Pict "@!"
	    	VTRead
	    End

	    If Upper(c_Opcao) == "N"
			l_Continua := .F.
	    Endif
*/
		l_Continua := .F.
		c_Opcao    := Space(1)
	End

//	VTClear Screen
//	@ 0, 0 VTSAY "Transferir (S/N)? " VTGET c_Opcao Pict "@!"

	While (c_Opcao $ "SN") == .F.
		@ 6, 0 VTSAY "Transferir (S/N)? " VTGET c_Opcao Pict "@!"
    	VTRead
    End

	VTClear Screen

    If Upper(c_Opcao) == "S"
		c_NumSeq := Space(TamSX3("D3_NUMSEQ")[1])

		VTMsg("Aguarde...")

		Begin Transaction
			c_Doc := Getmv("BM_SEQV2LO")

			dbSelectArea("SZW")
			dbSetOrder(4)
			While dbSeek(xFilial("SZW") + c_Doc)
				c_Doc := Upper(Soma1(c_Doc))
			End

			c_SeqExpe := c_Doc
			aAuto     := Array(Len(a_Itens) + 1)

			aAuto[1] := {c_Doc, dDataBase}

			For i:=1 To Len(a_Itens)
				aAuto[i+1]:=  {{"D3_COD"     , a_Itens[i][1]				,NIL}}
				aAdd(aAuto[i+1],{"D3_DESCRI" , a_Itens[i][2]				,NIL})
				aAdd(aAuto[i+1],{"D3_UM"     , a_Itens[i][3]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOCAL"  , a_Itens[i][4]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOCALIZ", a_Itens[i][5]				,NIL})
				aAdd(aAuto[i+1],{"D3_COD"    , a_Itens[i][6]				,NIL})
				aAdd(aAuto[i+1],{"D3_DESCRI" , a_Itens[i][7]				,NIL})
				aAdd(aAuto[i+1],{"D3_UM"     , a_Itens[i][8]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOCAL"  , a_Itens[i][9]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOCALIZ", a_Itens[i][10]				,NIL})
				aAdd(aAuto[i+1],{"D3_NUMSERI", a_Itens[i][11]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOTECTL", a_Itens[i][12]				,NIL})
				aAdd(aAuto[i+1],{"D3_NUMLOTE", a_Itens[i][13]				,NIL})
				aAdd(aAuto[i+1],{"D3_DTVALID", a_Itens[i][14]				,NIL})
				aAdd(aAuto[i+1],{"D3_POTENCI", a_Itens[i][15]				,NIL})
				aAdd(aAuto[i+1],{"D3_QUANT"  , a_Itens[i][16]				,NIL})
				aAdd(aAuto[i+1],{"D3_QTSEGUM", a_Itens[i][17]				,NIL})
				aAdd(aAuto[i+1],{"D3_ESTORNO", a_Itens[i][18]				,NIL})
				aAdd(aAuto[i+1],{"D3_NUMSEQ" , a_Itens[i][19]				,NIL})
				aAdd(aAuto[i+1],{"D3_LOTECTL", a_Itens[i][20]				,NIL})
				aAdd(aAuto[i+1],{"D3_DTVALID", a_Itens[i][21]				,NIL})
				aAdd(aAuto[i+1],{"D3_ITEMGRD", a_Itens[i][22]				,NIL})
			Next

			MSExecAuto({|x| MATA261(x)},aAuto)

			VTClear Screen

			If lMsErroAuto
				VTAlert(SubStr(MostraErro(), 1, 200), "Erro")
				DisarmTransaction()
				RestArea(a_Area)

				VTClear Screen
				VTRestore(0, 0, 4, 10, a_Tela)
			  	Return
			EndIf
		End Transaction

        l_Update := .F.

		dbSelectArea("SD3")
		dbSetOrder(2)
		If dbSeek(xFilial("SD3") + c_Doc + c_Produto)
			While SD3->(!EoF()) .And. SD3->(D3_FILIAL + D3_DOC + D3_COD) == xFilial("SD3") + c_Doc + c_Produto
				If SD3->D3_EMISSAO == DDATABASE .AND. SD3->D3_LOCAL == 'LO' .AND. SD3->D3_TM == '999' .AND. SD3->D3_CF == 'RE4' .AND. SD3->D3_LOTECTL == c_Lote .AND. SD3->D3_CHAVE == 'E0' .AND. SD3->D3_QUANT == n_Quant
					dbSelectArea("SZW")
					dbSetOrder(4)
					If !dbSeek(xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ)
			            l_Update := .T.
						c_Doc    := SD3->D3_DOC
						c_NumSeq := SD3->D3_NUMSEQ
						Exit
			   		Endif
				Endif

				SD3->(dbSkip())
			End
		Else
			//Gravou a transfer�ncia com outro n�mero de documento
		  	c_Qry := " SELECT * FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " + chr(13)
		  	c_Qry += " WHERE SD3.D_E_L_E_T_<>'*' AND D3_FILIAL = '" + xFilial("SD3") + "' "  + chr(13)
		  	c_Qry += " AND D3_COD = '" + c_Produto + "' AND D3_LOCAL = 'LO' " + chr(13)
		  	c_Qry += " AND D3_TM = '999' AND D3_CF = 'RE4' AND D3_LOTECTL = '" + c_Lote + "' AND D3_EMISSAO = '" + Dtos(DDATABASE) + "' " + chr(13)
		  	c_Qry += " AND D3_CHAVE = 'E0' AND D3_QUANT = " + cValToChar(n_Quant) + " AND D3_NUMSEQ NOT IN ( " + chr(13)
		  	c_Qry += " 	SELECT ZW_NUMSEQ FROM " + RetSqlName("SZW") + " SZW WITH(NOLOCK) " + chr(13)
		  	c_Qry += " 	WHERE SZW.D_E_L_E_T_<>'*' AND ZW_FILIAL = '" + xFilial("SZW") + "' "  + chr(13)
		  	c_Qry += " 	AND ZW_PRODUTO = '" + c_Produto + "' AND ZW_LOCORIG = 'LO' " + chr(13)
		  	c_Qry += " 	AND ZW_LOTECTL = '" + c_Lote + "' " + chr(13)
		  	c_Qry += " ) AND D3_USUARIO = '" + SubStr(cUserName, 1, TamSX3("D3_USUARIO")[1]) + "' ORDER BY R_E_C_N_O_ DESC "

			TCQUERY c_Qry NEW ALIAS QRY

			dbSelectArea("QRY")
			dbGoTop()
			If QRY->(!EoF())
				While QRY->(!EoF())
					dbSelectArea("SZW")
					dbSetOrder(4)
					If !dbSeek(xFilial("SZW") + QRY->D3_DOC + QRY->D3_NUMSEQ)
			            l_Update := .T.
						c_Doc    := QRY->D3_DOC
						c_NumSeq := QRY->D3_NUMSEQ
						Exit
			   		Endif

		            QRY->(dbSkip())
		   		End
			Endif

		  	QRY->(dbCloseArea())
		Endif

		If l_Update
			Begin Transaction
				c_Hora    := SubStr(Time(), 1, 5)

				For i:=1 To 1
					dbSelectArea("SZW")
					dbSetOrder(4)
					While !dbSeek(xFilial("SZW") + c_Doc + c_NumSeq)
						RecLock("SZW", .T.)
						SZW->ZW_FILIAL  := XFILIAL("SZW")
						SZW->ZW_DOC     := c_Doc  
						SZW->ZW_EMISSAO := DDATABASE
						SZW->ZW_OP      := c_Op
						SZW->ZW_PRODUTO := a_Itens[i][1]
						SZW->ZW_LOCORIG := "LO"
						SZW->ZW_LOCDEST := a_Itens[i][9]
						SZW->ZW_LOTECTL := a_Itens[i][12]
						SZW->ZW_QUANT   := a_Itens[i][16]
						SZW->ZW_NUMSEQ  := c_NumSeq
						SZW->ZW_HORA    := c_Hora
						SZW->ZW_USUARIO := c_Usuario
						MsUnlock()
					End
				Next
			End Transaction
		Else
			VTAlert("Transfer�ncia do armaz�m LO para o armaz�m " + c_LocDest + " foi realizada, por�m houve falha no processo de grava��o do registro na tabela SZW.", "Aviso")
			RestArea(a_Area)

			VTClear Screen
			VTRestore(0, 0, 4, 10, a_Tela)
		  	Return
		Endif

		dbSelectArea("SZW")
		dbSetOrder(4)
		If dbSeek(xFilial("SZW") + c_Doc + c_NumSeq)
			VTAlert("Transfer�ncia " + c_Doc + " do armaz�m LO para o armaz�m " + c_LocDest + " realizada com sucesso.", "Aviso")
		Else
			VTAlert("Transfer�ncia " + c_Doc + " do armaz�m LO para o armaz�m " + c_LocDest + " foi realizada, por�m houve falha no processo de grava��o do registro na tabela SZW.", "Aviso")
		Endif

		c_Seq := Upper(Soma1(c_SeqExpe))

		While Getmv("BM_SEQV2LO") <> c_Seq
			Putmv("BM_SEQV2LO", c_Seq)
		End
	Else
		VTAlert("Transfer�ncia cancelada pelo usu�rio.", "Aviso")
	Endif

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret
