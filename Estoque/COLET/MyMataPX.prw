#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

User Function MyMataPX
	Local c_Usuario  := SubStr(UsrRetName(__CUSERID), 1, TamSX3("ZW_USUARIO")[1])
    Local c_Op       := Space(13)
	Local c_SeqOrig  := Space(TamSX3("D3_NUMSEQ")[1])
    Local c_Produto  := Space(TamSX3("B1_COD")[1])
	Local c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
	Local c_Local    := Space(2)
	Local c_LocDest  := Space(2)
    Local n_Quant    := 0
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
	Local a_ItensSZW := {}
	Local l_ErroSZW  := .F.
	Local n_QtdTotal := 0

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
    Private INCLUI      := .T.

	While l_Continua
	    c_Produto  := Space(TamSX3("B1_COD")[1])
		c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
		c_LocDest  := "TR"	//Space(2)
		n_QuantSD3 := 0
		aItem	   := {}
		l_Produto  := .F.
		c_SeqOrig  := Space(TamSX3("D3_NUMSEQ")[1])
		l_NumSeq   := .F.
	
		While l_NumSeq == .F.
			VTClear Screen
			@ 0, 0 VTSAY "Sequencial: " VTGET c_SeqOrig Pict "@!"
		    VTRead
		    
		    c_SeqOrig := SubStr(c_SeqOrig, 1, TamSX3("D3_NUMSEQ")[1])
			l_SeqErro := .F.

			If VtLastKey() == 27
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Endif

			c_Qry := " SELECT D3_COD, D3_LOCAL, D3_LOTECTL, D3_OP, D3_QUANT FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " + chr(13)
		  	c_Qry += " WHERE D3_FILIAL='" + XFILIAL("SD3") + "' AND D3_NUMSEQ = '" + c_SeqOrig + "' AND D3_ESTORNO <> 'S' AND D3_CF IN ('DE4', 'PR0') " + chr(13)
		  	c_Qry += " AND SD3.D_E_L_E_T_<>'*' AND D3_NUMSEQ NOT IN (SELECT ZW_SEQORIG FROM " + RetSqlName("SZW") + " SZW WITH(NOLOCK) WHERE ZW_SEQORIG<>'' AND SZW.D_E_L_E_T_<>'*' "
		  	c_Qry += " AND ZW_LOCDEST = '" + c_LocDest + "') "
		  	c_Qry += " AND D3_NUMSEQ IN (SELECT ZW_SEQORIG FROM " + RetSqlName("SZW") + " SZW WITH(NOLOCK) WHERE ZW_SEQORIG<>'' AND SZW.D_E_L_E_T_<>'*' AND ZW_LOCDEST = 'TE') "
		  	
			TCQUERY c_Qry NEW ALIAS QRY
	
			dbSelectArea("QRY")
			dbGoTop()
			If QRY->(!EoF())
				For i:=1 To Len(a_ItensSZW)
					If a_ItensSZW[i][7] == c_SeqOrig
						VTAlert("Sequencial " + AllTrim(c_SeqOrig) + " já foi lido anteriormente neste processo. Por favor verifique se o Sequencial foi digitado corretamente.", "Aviso")			
						c_SeqOrig  := Space(TamSX3("D3_NUMSEQ")[1])
						l_SeqErro := .T.
						Exit
					Endif
				Next
				
				If l_SeqErro == .F.
					c_Produto  := QRY->D3_COD
					c_Lote     := QRY->D3_LOTECTL                      
					c_Local    := "TE"
					c_Op       := QRY->D3_OP
					n_QuantSD3 := QRY->D3_QUANT
					l_NumSeq   := .T.
				Endif
			Else
				VTAlert("Sequencial " + AllTrim(c_SeqOrig) + " inválido, estornado ou já foi transferido. Por favor verifique se o Sequencial foi digitado corretamente.", "Aviso")			
			Endif
			QRY->(dbCloseArea())
		End		

		@ 1, 0 VTSAY "Produto: " + c_Produto
	   	@ 2, 0 VTSAY "Arm. Origem: " + c_Local

	   	dbSelectArea("SB1")
   		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + c_Produto)
		   	l_Rastro := IIF(SB1->B1_RASTRO == "L", .T., .F.)
			l_Produto := .T.
		Endif

		If l_Rastro
			l_Lote := .F.
			a_Lote := {}

			c_Qry := " SELECT B8_LOTECTL, B8_DTVALID FROM " + RetSqlName("SB8") + " SB8 WITH(NOLOCK) " + chr(13)
		  	c_Qry += " WHERE B8_FILIAL='" + XFILIAL("SB8") + "' AND B8_SALDO > 0 AND B8_DTVALID >= '" + DTOS(DDATABASE) + "' AND B8_LOCAL = '" + c_Local + "' " + chr(13)
		  	c_Qry += " AND B8_PRODUTO = '" + c_Produto + "' AND B8_LOTECTL = '" + c_Lote + "' AND SB8.D_E_L_E_T_<>'*' "

			TCQUERY c_Qry NEW ALIAS QRY

			dbSelectArea("QRY")
			dbGoTop()
			While QRY->(!EoF())
				If aScan(a_Lote, {|x| x[1] == QRY->B8_LOTECTL}) == 0
					AADD(a_Lote, {QRY->B8_LOTECTL, Stod(QRY->B8_DTVALID)})
				Endif

				QRY->(dbSkip())
			End
			QRY->(dbCloseArea())

			@ 3, 0 VTSAY "Lote: " + SubStr(c_Lote, 1, TamSX3("D3_LOTECTL")[1])

			If aScan(a_Lote, {|x| x[1] == c_Lote}) == 0
				VTAlert("Lote " + AllTrim(c_Lote) + " sem saldo, inválido ou vencido. Por favor verificar se o lote foi preenchido corretamente.", "Aviso")
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Else
				l_Lote := .T.
			Endif

			If !Empty(c_Lote)
				d_DtValid := a_Lote[aScan(a_Lote, {|x| x[1] == c_Lote})][2]
			Endif
		Else
			@ 3, 0 VTSAY "Lote: S/ CONTROLE"
		Endif
	
		If SuperGetMV('MV_ESTNEG')=='N'
			dbSelectArea("SB2")
			SB2->(dbSetOrder(1))
			SB2->(dbSeek(xFilial("SB2") + c_Produto + c_Local))
			n_Saldo := SaldoMov()
			If n_QuantSD3 > n_Saldo
				VTALERT("Quantidade excede o saldo disponível no armazém " + c_Local + ". Por favor verificar se há saldo para realizar essa transferência.", "Aviso")
				RestArea(a_Area)
				VTClear Screen			
				VTRestore(0, 0, 4, 10, a_Tela)
				Return .F.
			Else
				n_QtdTotal += n_QuantSD3
			Endif

		   	SB2->(dbCloseArea())
		Endif
		
	   	@ 4, 0 VTSAY "Arm. Destino: " VTGET c_LocDest Pict "@!" Valid f_VldArm(c_Local, c_LocDest)
    	VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif
        
		l_Existe := .F.

		For i:=1 To Len(a_Itens)
			If (a_Itens[i][1] == c_Produto) .And. (a_Itens[i][4] == c_Local) .And. (a_Itens[i][9] == c_LocDest) .And.(a_Itens[i][12] == c_Lote) 
            	a_Itens[i][16] += n_QuantSD3
            	l_Existe := .T.
            	Exit            	
			Endif
		Next
		
		If l_Existe == .F.
			aadd(aItem, c_Produto, Nil)  	//D3_COD		
			aadd(aItem, SB1->B1_DESC, Nil)  	//D3_DESCRI				
			aadd(aItem, SB1->B1_UM, Nil)		//D3_UM		
			aadd(aItem, c_Local, Nil)      		//D3_LOCAL		
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
			aadd(aItem, n_QuantSD3, Nil)		//D3_QUANT		
			aadd(aItem, CriaVar("D3_QTSEGUM"), Nil)				//D3_QTSEGUM		
			aadd(aItem, CriaVar("D3_ESTORNO"), Nil)   			//D3_ESTORNO		
			aadd(aItem, CriaVar("D3_NUMSEQ"), Nil)        		//D3_NUMSEQ 		
			aadd(aItem, c_Lote, Nil)			//D3_LOTECTL		
			aadd(aItem, d_DtValid, Nil)		//D3_DTVALID
//			aadd(aItem, Space(TamSX3("D3_SERVIC")[1]), Nil)				//D3_SERVIC
			aadd(aItem, Space(TamSX3("D3_ITEMGRD")[1]), Nil)				//D3_ITEMGRD
	
			aadd(a_Itens, aItem)
	
			aadd(a_ItensSZW, {c_Op, c_Produto, c_Local, c_LocDest, c_Lote, n_QuantSD3, c_SeqOrig, n_QuantSD3})
		Else
			n_QtdSZW := n_QuantSD3
			
			For i:=1 To Len(a_ItensSZW)
				If (a_ItensSZW[i][2] == c_Produto) .And. (a_ItensSZW[i][3] == c_Local) .And. (a_ItensSZW[i][4] == c_LocDest) .And.(a_ItensSZW[i][5] == c_Lote) 
	            	n_QtdSZW += a_ItensSZW[i][6]
	            	a_ItensSZW[i][8] += n_QuantSD3
				Endif
			Next
			
			aadd(a_ItensSZW, {c_Op, c_Produto, c_Local, c_LocDest, c_Lote, n_QuantSD3, c_SeqOrig, n_QtdSZW})
		Endif
		
		@ 5, 0 VTSAY Replicate("-", 30)

		While (c_Opcao $ "SN") == .F.
			@ 6, 0 VTSAY "Nova leitura (S/N)? " VTGET c_Opcao Pict "@!"
	    	VTRead
	    End

	    If Upper(c_Opcao) == "N"
			l_Continua := .F.
	    Endif

		c_Opcao := Space(1)
	End

	VTClear Screen

	l_Quant := .F.
	
	While l_Quant == .F.
		@ 1, 0 VTSAY "Quantidade: " VTGET n_Quant
	    VTRead
	
		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif
	
		If n_Quant == n_QtdTotal
			l_Quant := .T.
		Else
			VTAlert("Quantidade incorreta para efetuar a transferência. Por favor verificar se a quantidade foi digitada corretamente.", "Aviso")
		Endif
	End
		
	@ 1, 0 VTSAY "Quantidade:" + Transform(n_Quant, "@E 99,999.99") + Space(25)
	@ 2, 0 VTSAY Replicate("-", 30)

	While (c_Opcao $ "SN") == .F.
		@ 3, 0 VTSAY "Transferir (S/N)? " VTGET c_Opcao Pict "@!"
    	VTRead
    End

	VTClear Screen

    If Upper(c_Opcao) == "S"
		c_NumSeq := Space(TamSX3("D3_NUMSEQ")[1])

		VTMsg("Aguarde...")

		Begin Transaction
			c_Doc := Getmv("BM_SEQEXPE")

			dbSelectArea("SZW")
			dbSetOrder(4)
			While dbSeek(xFilial("SZW") + c_Doc)
				c_Doc := Upper(Soma1(c_Doc))
			End

			c_SeqProd := c_Doc
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

		For i:=1 To Len(a_ItensSZW)
	        l_Update := .F.

			dbSelectArea("SD3")
			dbSetOrder(2)
			If dbSeek(xFilial("SD3") + c_Doc + a_ItensSZW[i][2])
				While SD3->(!EoF()) .And. SD3->(D3_FILIAL + D3_DOC + D3_COD) == xFilial("SD3") + c_Doc + a_ItensSZW[i][2]
					If SD3->D3_EMISSAO == DDATABASE .AND. SD3->D3_LOCAL == a_ItensSZW[i][3] .AND. SD3->D3_TM == '999' .AND. SD3->D3_CF == 'RE4' .AND. ;
					   SD3->D3_LOTECTL == a_ItensSZW[i][5] .AND. SD3->D3_CHAVE == 'E0' .AND. SD3->D3_QUANT == IIF(a_ItensSZW[i][6] < a_ItensSZW[i][8],;
					   a_ItensSZW[i][8], a_ItensSZW[i][6]) 

						dbSelectArea("SZW")
						dbSetOrder(4)
						If !dbSeek(xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ) .Or. (a_ItensSZW[i][6] < a_ItensSZW[i][8])
				            l_Update := .T.
							c_Doc    := SD3->D3_DOC
							c_NumSeq := SD3->D3_NUMSEQ
							Exit
				   		Endif
					Endif
	
					SD3->(dbSkip())
				End
			Else
				//Gravou a transferência com outro número de documento
			  	c_Qry := " SELECT * FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " + chr(13)
			  	c_Qry += " WHERE SD3.D_E_L_E_T_<>'*' AND D3_FILIAL = '" + xFilial("SD3") + "' "  + chr(13)
			  	c_Qry += " AND D3_COD = '" + a_ItensSZW[i][2] + "' AND D3_LOCAL = '" + a_ItensSZW[i][3] + "' " + chr(13)
			  	c_Qry += " AND D3_TM = '999' AND D3_CF = 'RE4' AND D3_LOTECTL = '" + a_ItensSZW[i][5] + "' AND D3_EMISSAO = '" + Dtos(DDATABASE) + "' " + chr(13)
			  	c_Qry += " AND D3_CHAVE = 'E0' AND D3_QUANT = " + cValToChar(IIF(a_ItensSZW[i][6] < a_ItensSZW[i][8], a_ItensSZW[i][8], a_ItensSZW[i][6]) ) + chr(13)
			  	c_Qry += " AND D3_NUMSEQ NOT IN ( " + chr(13)
			  	c_Qry += " 	SELECT ZW_NUMSEQ FROM " + RetSqlName("SZW") + " SZW WITH(NOLOCK) " + chr(13)
			  	c_Qry += " 	WHERE SZW.D_E_L_E_T_<>'*' AND ZW_FILIAL = '" + xFilial("SZW") + "' "  + chr(13)
			  	c_Qry += " 	AND ZW_PRODUTO = '" + a_ItensSZW[i][2] + "' AND ZW_LOCORIG = '" + a_ItensSZW[i][3] + "' " + chr(13)
			  	c_Qry += " 	AND ZW_LOTECTL = '" + a_ItensSZW[i][5] + "') " + chr(13)
			  	c_Qry += " AND D3_USUARIO = '" + SubStr(cUserName, 1, TamSX3("D3_USUARIO")[1]) + "' ORDER BY R_E_C_N_O_ DESC "
	
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

					dbSelectArea("SZW")
					dbSetOrder(4)
					If !dbSeek(xFilial("SZW") + c_Doc + c_NumSeq) .Or. (a_ItensSZW[i][6] < a_ItensSZW[i][8])
						RecLock("SZW", .T.)
						SZW->ZW_FILIAL  := XFILIAL("SZW")
						SZW->ZW_DOC     := c_Doc  
						SZW->ZW_EMISSAO := DDATABASE
						SZW->ZW_OP      := a_ItensSZW[i][1]	//c_Op
						SZW->ZW_PRODUTO := a_ItensSZW[i][2]
						SZW->ZW_LOCORIG := a_ItensSZW[i][3]	//c_Local
						SZW->ZW_LOCDEST := a_ItensSZW[i][4]
						SZW->ZW_LOTECTL := a_ItensSZW[i][5]
						SZW->ZW_QUANT   := a_ItensSZW[i][6]
						SZW->ZW_NUMSEQ  := c_NumSeq
						SZW->ZW_HORA    := c_Hora
						SZW->ZW_USUARIO := c_Usuario
						SZW->ZW_SEQORIG := a_ItensSZW[i][7]	//c_SeqOrig
						MsUnlock()
					Endif
				End Transaction

				dbSelectArea("SZW")
				dbSetOrder(4)
				If !dbSeek(xFilial("SZW") + c_Doc + c_NumSeq)
					l_ErroSZW := .T.
				Endif
			Endif
		Next

		If l_ErroSZW
			VTAlert("Transferência " + c_Doc + " foi realizada, porém houve falha no processo de gravação do registro na tabela SZW.", "Aviso")
		Else
			VTAlert("Transferência " + c_Doc + " realizada com sucesso.", "Aviso")
		Endif

		c_Seq := Upper(Soma1(c_SeqProd))

		While Getmv("BM_SEQEXPE") <> c_Seq
			Putmv("BM_SEQEXPE", c_Seq)
		End
	Else
		VTAlert("Transferência cancelada pelo usuário.", "Aviso")
	Endif

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret



Static Function f_VldArm(c_Local, c_LocDest)
	Local l_Ret := .F.

	If Empty(c_LocDest)
		VTAlert("Armazém inválido.", "Aviso")
	Else
		dbSelectArea("NNR")
		dbSetOrder(1)
		If dbSeek(xFilial("NNR") + c_LocDest)
			dbSelectArea("SZ7")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
				If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
					dbSelectArea("SZ7")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ7") + __CUSERID + c_LocDest)
						If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
							l_Ret := .T.
						Else
							VTAlert("O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_LocDest + ".")
						Endif
					Else
						VTAlert("O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_LocDest + ".")
					Endif
				Else
					VTAlert("O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Local + ".")
				Endif
			Else
				VTAlert("O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Local + ".")
			Endif
		Else
			VTAlert("Armazém " + AllTrim(c_LocDest) + " inválido para essa operação. Por favor verifique se o código do armazém foi digitado corretamente.", "Aviso")
		Endif
	Endif
Return l_Ret