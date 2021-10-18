#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

User Function FCONFTE
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
	c_Local := Space(2)
	n_Saldo := 0

	dbSelectArea("SH6")
	dbSetOrder(1)
	dbSeek(xFilial("SH6") + c_Op)
	While SH6->(!EoF()) .And. SH6->(H6_FILIAL + H6_OP) == xFilial("SH6") + c_Op
		If aScan(a_Lote, SH6->H6_LOTECTL) == 0
			AADD(a_Lote, SH6->H6_LOTECTL)
		Endif

		c_Local := SH6->H6_LOCAL
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
   	dbSeek(xFilial("SZW") + c_Op + c_Produto + c_Local + c_Lote)
   	While SZW->(!EoF()) .And. SZW->(ZW_FILIAL + ZW_OP + ZW_PRODUTO + ZW_LOCORIG + ZW_LOTECTL) == xFilial("SZW") + c_Op + c_Produto + c_Local + c_Lote
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

		If n_Quant > n_Saldo
			VTALERT("Quantidade excede o saldo produzido relacionado a ordem de produção " + AllTrim(c_Op) + ". Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
		Else
			If n_Quant > 0 .And. n_Quant <= (n_Saldo - n_QuantSZW)
				l_Quant := .T.
			Else
				VTAlert("Quantidade superior ao saldo pendente para conferência relacionada a ordem de produção " + AllTrim(c_Op) + ". Por favor verificar se a quantidade foi preenchida corretamente.", "Aviso")
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

	@ 5, 0 VTSAY "Gravar (S/N)? " VTGET c_Opcao Pict "@!"
    VTRead

	VTClear Screen

    If Upper(c_Opcao) == "S"
		VTMsg("Aguarde...")

		Begin Transaction
			RecLock("SZW", .T.)
			SZW->ZW_FILIAL  := XFILIAL("SZW")
			SZW->ZW_DOC     := Space(TamSX3("D3_DOC")[1])
			SZW->ZW_EMISSAO := DDATABASE
			SZW->ZW_OP      := c_Op
			SZW->ZW_PRODUTO := c_Produto
			SZW->ZW_LOCORIG := "TE"
			SZW->ZW_LOCDEST := "TE"
			SZW->ZW_LOTECTL := c_Lote
			SZW->ZW_QUANT   := n_Quant
			SZW->ZW_NUMSEQ  := Space(TamSX3("D3_NUMSEQ")[1])
			SZW->ZW_HORA    := SubStr(Time(), 1, 5)
			SZW->ZW_USUARIO := SubStr(UsrRetName(__CUSERID), 1, TamSX3("ZW_USUARIO")[1])
			MsUnlock()

			VTClear Screen
			VTAlert("Conferência da ordem de produção " + AllTrim(c_Op) + " no armazém TE realizada com sucesso.", "Aviso")
		End Transaction
	Else
		VTAlert("Conferência cancelada pelo usuário.", "Aviso")
	Endif

	RestArea(a_Area)

	VTClear Screen
	VTRestore(0, 0, 4, 10, a_Tela)
Return l_Ret