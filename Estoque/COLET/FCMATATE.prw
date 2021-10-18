#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

/*
Função para o armazém TE
*/
User Function FCMATATE
    Local c_Op       := Space(13)
    Local c_Produto  := Space(TamSX3("B1_COD")[1])
	Local c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
    Local n_Quant    := 0
    Local n_ConfQtd  := 0
    Local c_Opcao    := Space(1)
	Local a_Area     := GetArea()
	Local l_Ret      := .T.
	Local a_Tela     := VTSave(0, 0, 4, 10)
	Local d_DtValid  := Ctod("  /  /    ")
	Local lOk	     := .T.
	Local aItem	     := {}
	Local nOpcAuto   := 3 

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
    Private INCLUI      := .T.

	VTClear Screen

	l_Op := .F.

	While l_Op == .F.
		@ 0, 0 VTSAY "OP: " VTGET c_Op Pict "@!"
	    VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif

		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2") + c_Op)
		If Found()
			If SC2->C2_STATUS == "U"
				VTAlert("Ordem de Produção " + AllTrim(c_Op) + " está suspensa. Por favor verifique se o número da ordem de produção foi digitado corretamente.", "Aviso")
			Else
				c_Produto := SC2->C2_PRODUTO
				l_Op      := .T.
			Endif
		Else
			VTAlert("Ordem de Produção " + AllTrim(c_Op) + " não foi encontrada. Por favor verifique se o número da ordem de produção foi digitado corretamente.", "Aviso")
        Endif
   	End

   	SC2->(dbCloseArea())

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + c_Produto)
   	l_Rastro := IIF(SB1->B1_RASTRO == "L", .T., .F.)

	@ 1, 0 VTSAY "Produto - " + c_Produto

	a_Lote  := {}
	n_Saldo := 0

	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6") + c_Op)
	While SH6->(!EoF()) .And. SH6->(H6_FILIAL + H6_OP) == xFilial("SH6") + c_Op
		If aScan(a_Lote, SH6->H6_LOTECTL) == 0
			AADD(a_Lote, SH6->H6_LOTECTL)
		Endif

		n_Saldo += SH6->H6_QTDPROD

		SH6->(dbSkip())
	End

   	SH6->(dbCloseArea())

	If n_Saldo == 0
		VTAlert("Não existem apontamentos de produção para a ordem de produção " + AllTrim(c_Op) + ". Por favor verifique se o número da ordem de produção foi digitado corretamente.", "Aviso")
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
    Endif

	If l_Rastro
		If Len(a_Lote) > 1
			l_Lote := .F.
	
			While l_Lote == .F.
				@ 2, 0 VTSAY "Lote: " VTGET c_Lote Pict "@!"
			    VTRead
	
			    c_Lote := Padr(c_Lote, TamSX3("D3_LOTECTL")[1])

				If VtLastKey() == 27
					RestArea(a_Area)
					VTClear Screen			
					VTRestore(0, 0, 4, 10, a_Tela)
					Return .F.
				Endif
	
				If aScan(a_Lote, c_Lote) == 0
					VTAlert("Lote " + AllTrim(c_Lote) + " inválido para a ordem de produção " + c_Op + ". Por favor verificar se o lote foi preenchido corretamente.", "Aviso")
				Else
					l_Lote := .T.
				Endif
			End
		Else
			c_Lote := a_Lote[1]
			@ 2, 0 VTSAY "Lote - " + c_Lote
		Endif

		If !Empty(c_Lote)
			dbSelectArea("SB8")
			dbSetOrder(5)
			dbSeek(xFilial("SB8") + c_Produto + c_Lote)
	
			d_DtValid := SB8->B8_DTVALID
			
		   	SB8->(dbCloseArea())
		Endif
	Else
		@ 2, 0 VTSAY "Lote - S/ CONTROLE"
	Endif

	n_QuantSZW := 0

   	dbSelectArea("SZW")
   	dbSetOrder(1)
   	dbSeek(xFilial("SZW") + c_Op + c_Produto + "P4" + c_Lote)
   	While SZW->(!EoF()) .And. SZW->(ZW_FILIAL + ZW_OP + ZW_PRODUTO + ZW_LOCORIG + ZW_LOTECTL) == xFilial("SZW") + c_Op + c_Produto + "P4" + c_Lote
		n_QuantSZW += SZW->ZW_QUANT

   		SZW->(dbSkip())
    End

    l_Quant := .F.

	While l_Quant == .F.
		@ 3, 0 VTSAY "Quantidade: " VTGET n_Quant
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
			SB2->(dbSeek(xFilial("SB2") + c_Produto + "P4"))
			n_Saldo := SaldoMov()
			If n_Quant > n_Saldo
				VTALERT("Quantidade excede o saldo disponível. Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
			Else
				If n_Quant > 0 .And. n_Quant <= (n_Saldo - n_QuantSZW)
					l_Quant := .T.
				Else
					VTAlert("Quantidade superior ao saldo pendente para transferência relacionada a ordem de produção " + c_Op + ". Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
				Endif
			Endif

		   	SB2->(dbCloseArea())
		Else
			If n_Quant > 0 .And. n_Quant <= (n_Saldo - n_QuantSZW)
				l_Quant := .T.
			Else
				VTAlert("Quantidade superior ao saldo pendente para transferência relacionada a ordem de produção " + c_Op + ". Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
			Endif
		Endif
	End

	@ 3, 0 VTSAY "Quantidade: " + Transform(n_Quant, "@E 99,999.99") + Space(25)

	l_ConfQtd := .F.

	While l_ConfQtd == .F.
		@ 4, 0 VTSAY "Confirme: " VTGET n_ConfQtd
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
			VTAlert("Confirmação da quantidade está divergente da quantidade digitada anteriormente. Por favor verificar se a confirmação da quantidade foi preenchida corretamente.", "Aviso")
		Endif
	End

	@ 4, 0 VTSAY "Confirme: " + Transform(n_ConfQtd, "@E 99,999.99") + Space(25)

	@ 5, 0 VTSAY "Transferir (S/N)? " VTGET c_Opcao Pict "@!"
    VTRead

	VTClear Screen

    If Upper(c_Opcao) == "S"
		VTMsg("Aguarde...")

		Begin Transaction
			c_Doc := NextNumero("SD3", 2, "D3_DOC", .T.)
			aAuto := {}		
			aItem := {}

			aadd(aAuto, {c_Doc, dDataBase})  

			aadd(aItem, c_Produto, Nil)  	//D3_COD		
			aadd(aItem, SB1->B1_DESC, Nil)  	//D3_DESCRI				
			aadd(aItem, SB1->B1_UM, Nil)		//D3_UM		
			aadd(aItem, "P4", Nil)      		//D3_LOCAL		
			aadd(aItem, Space(TamSX3("D3_LOCALIZ")[1]), Nil)				//D3_LOCALIZ		
			aadd(aItem, c_Produto, Nil)  	//D3_COD		
			aadd(aItem, SB1->B1_DESC, Nil)   //D3_DESCRI				
			aadd(aItem, SB1->B1_UM, Nil)		//D3_UM		
			aadd(aItem, "TE", Nil)      		//D3_LOCAL		
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
			aadd(aItem,CriaVar("D3_SERVIC"), Nil)				//D3_SERVIC
			aadd(aItem, Space(TamSX3("D3_SERVIC")[1]), Nil)				//D3_SERVIC
			aadd(aItem, Space(TamSX3("D3_ITEMGRD")[1]), Nil)				//D3_ITEMGRD

			aadd(aAuto,aItem)								

//			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
			MSExecAuto({|x| MATA261(x)},aAuto)

			VTClear Screen

			If !lMsErroAuto
				dbSelectArea("SD3")
				dbSetOrder(2)
				If !dbSeek(xFilial("SD3") + c_Doc + c_Produto)
					//Gravou a transferência com outro número de documento
				  	c_Qry := " SELECT * FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " + chr(13)
				  	c_Qry += " WHERE SD3.D_E_L_E_T_<>'*' AND D3_FILIAL = '" + xFilial("SD3") + "' "  + chr(13)
				  	c_Qry += " AND D3_COD = '" + c_Produto + "' AND D3_LOCAL = 'P4' " + chr(13)
				  	c_Qry += " AND D3_TM = '999' AND D3_CF = 'RE4' AND D3_LOTECTL = '" + c_Lote + "' AND D3_EMISSAO = '" + Dtos(DDATABASE) + "' " + chr(13)
				  	c_Qry += " AND D3_CHAVE = 'E0' AND D3_QUANT = " + cValToChar(n_Quant) + " AND D3_NUMSEQ NOT IN ( " + chr(13)
				  	c_Qry += " 	SELECT ZW_NUMSEQ FROM " + RetSqlName("SZW") + " SZW WITH(NOLOCK) " + chr(13)
				  	c_Qry += " 	WHERE SZW.D_E_L_E_T_<>'*' AND ZW_FILIAL = '" + xFilial("SZW") + "' "  + chr(13)
				  	c_Qry += " 	AND ZW_PRODUTO = '" + c_Produto + "' AND ZW_LOCORIG = 'P4' " + chr(13)
				  	c_Qry += " 	AND ZW_LOTECTL = '" + c_Lote + "' AND ZW_OP = '" + c_Op + "' " + chr(13)
				  	c_Qry += " ) "

					TCQUERY c_Qry NEW ALIAS QRY
					dbSelectArea("QRY")
					dbGoTop()

					If QRY->(EoF())
					  	QRY->(dbCloseArea())
						DisarmTransaction()
						VTAlert("Erro na inclusão da Transferência do armazém P4 para o armazém TE.", "Aviso")
						RestArea(a_Area)

						VTClear Screen
						VTRestore(0, 0, 4, 10, a_Tela)
					  	Return
					Else
						c_Doc := QRY->D3_DOC
					Endif

				  	QRY->(dbCloseArea())

					dbSelectArea("SD3")
					dbSetOrder(2)
					dbSeek(xFilial("SD3") + c_Doc + c_Produto)
				Endif

				RecLock("SZW", .T.)
				SZW->ZW_FILIAL  := XFILIAL("SZW")
				SZW->ZW_DOC     := c_Doc  
				SZW->ZW_EMISSAO := DDATABASE
				SZW->ZW_OP      := c_Op
				SZW->ZW_PRODUTO := c_Produto
				SZW->ZW_LOCORIG := "P4"
				SZW->ZW_LOCDEST := "TE"
				SZW->ZW_LOTECTL := c_Lote
				SZW->ZW_QUANT   := n_Quant
				SZW->ZW_NUMSEQ  := SD3->D3_NUMSEQ
				SZW->ZW_HORA    := SubStr(Time(), 1, 5)
				SZW->ZW_USUARIO := SubStr(UsrRetName(__CUSERID), 1, TamSX3("ZW_USUARIO")[1])
				MsUnlock()
	
				VTAlert("Transferência " + c_Doc + " do armazém P4 para o armazém TE realizada com sucesso.", "Aviso")
			Else			
				VTAlert(SubStr(MostraErro(), 1, 200), "Erro")
				DisarmTransaction()
				Break
			EndIf
		End Transaction
	Else
		VTAlert("Transferência cancelada pelo usuário.", "Aviso")
	Endif

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret