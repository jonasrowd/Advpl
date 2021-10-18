#Include "Totvs.ch"

/*/{Protheus.doc} MT680EST
	Ponto de entrada para validar se o estorno pode ser realizado.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return logical, l_Ret
/*/
User Function MT680EST
	Local a_AreaSD3 := SD3->(GetArea())
	Local n_Acao    := PARAMIXB[1]
	Local a_Area    := GetArea()
	Local l_Ret     := .T.
	If n_Acao == 2 		//Operador confirmou estorno
		dbSelectArea("SD3")
		SD3->(dbSetOrder(15))
		If SD3->(dbSeek(xFilial("SD3") + SH6->(H6_OP + H6_IDENT + "PR0")))
			dbSelectArea("SZW")
			SZW->(dbSetOrder(1))
			SZW->(dbSeek(xFilial("SZW") + SH6->(H6_OP + H6_PRODUTO + H6_LOCAL + H6_LOTECTL)))
			While SZW->(!EoF()) .AND. SZW->(ZW_FILIAL + ZW_OP + ZW_PRODUTO + ZW_LOCORIG + ZW_LOTECTL) == xFilial("SZW") + SH6->(H6_OP + H6_PRODUTO + H6_LOCAL + H6_LOTECTL)
				If SZW->ZW_SEQORIG == SD3->D3_NUMSEQ
					ShowHelpDlg(SM0->M0_NOME, {"Este apontamento já foi transferido para o armazém " + SZW->ZW_LOCDEST + " e não pode ser estornado"}, 5, {"Utilize esta operação somente com apontamentos que não foram transferidos"},5)
					l_Ret := .F.
					Exit
				Endif
				SZW->(dbSkip())
			End
		Endif
	Endif
	RestArea(a_AreaSD3)
	RestArea(a_Area)
Return l_Ret
