#Include "Totvs.ch"

/*/{Protheus.doc} MT685TOK
	Ponto de entrada para validar os dados do Apontamento de perda.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 04/10/2021
	@return logical, l_Ret
/*/
User Function MT685TOK()
	Local lInc       := PARAMIXB[1]
	Local l_Ret      := .T.
	Local aArea      := GetArea()
	Local c_ProdSC2  := Posicione("SC2", 1, xFilial("SC2") + cOrdemP, "C2_PRODUTO")
	Local i := 0

	If lInc .And. cFilAnt == "010101"   // --- Validação na inclusao do Apontamento da Perda
		For i:=1 To Len(aCols)
			If aCols[i][Len(aHeader) + 1] == .F.
				c_Um      := ""
				n_Peso    := 0
				c_Grupo   := ""
				c_UmDest  := ""
				c_Local   := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCAL'})]
				n_QtdPer  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QUANT'})]
				cCodDest  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_CODDEST'})]
				cCodProd  := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_PRODUTO'})]
				n_QtdDest := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_QTDDEST'})]
				c_LocOrig := aCols[i][AScan(aHeader, { |x| Alltrim(x[2]) == 'BC_LOCORIG'})]

				If Empty(cCodProd) .Or. Empty(c_LocOrig) .Or. Empty(cCodDest) .Or. Empty(c_Local)
					ShowHelpDlg(SM0->M0_NOME,;
						{"Um ou alguns campos obrigatórios do item " + StrZero(i, 2) + " não foram preenchidos"},5,;
						{"Preencha os campos Produto, Armazem Orig, Prd. Destino e Armazem Dest antes de prosseguir"},5)
					l_Ret := .F.
					Exit
				Endif

				If cCodProd <> c_ProdSC2
					ShowHelpDlg(SM0->M0_NOME,;
						{"O campo Produto do item " + StrZero(i, 2) + " do Apontamento da Perda está divergente do Produto da Ordem de Produção " + cOrdemP},5,;
						{"Verifique se o valor do campo Produto do Apontamento da Perda foi digitado corretamente"},5)
					l_Ret := .F.
					Exit
				Endif

				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
					If Z7_TPMOV == 'S'
						ShowHelpDlg(SM0->M0_NOME,;
							{"O seu usuário não possui permissão para efetuar entradas no armazém " + c_Local + "."},5,;
							{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuário não possui permissão para efetuar entradas no armazém " + c_Local + "."},5,;
						{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif

				If Empty(c_Local)
					ShowHelpDlg(SM0->M0_NOME, {"O campo Armazem Dest do item " + StrZero(i, 2) + " está em branco."},5,;
											{"Preencha o campo Armazem Dest antes de prosseguir."},5)
					l_Ret := .F.
					Exit
				Endif

				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1") + cCodProd)
					c_Um   := SB1->B1_UM
					c_Grupo  := SB1->B1_GRUPO

					If cCodDest == SB1->B1_FSPRODC
						l_Ret := .T.
					Else
						ShowHelpDlg(SM0->M0_NOME, {"O campo Prd. Destino do item " + StrZero(i, 2) + " está preenchido incorretamente."},5,;
											{"Preencha o campo Prd. Destino com o Código do Produto Classe C do Produto " + AllTrim(cCodProd) + "."},5)
						l_Ret := .F.
						Exit
					Endif
				Endif

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + cCodDest))
					c_UmDest := SB1->B1_UM
				Endif

				n_QtdVal := 0
				If c_Um == c_UmDest
					n_QtdVal := n_QtdPer
				Elseif c_Um $ "UN/PC" .And. c_UmDest $ "UN/PC"
					n_QtdVal := n_QtdPer
				Elseif c_Um $ "UN/PC" .And. c_UmDest == "KG"
					dbSelectArea("SBM")
					SBM->(dbSetOrder(1))
					If SBM->(dbSeek(xFilial("SBM") + c_Grupo))
						If SubStr(SBM->BM_GRUPO, 1, 1) == "B"
							n_Peso := SBM->BM_FSPESOB/1000
						Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "A"
							n_Peso := SBM->BM_FSPALCA/1000
						Elseif SubStr(SBM->BM_GRUPO, 1, 1) == "T"
							n_Peso := SBM->BM_FSPTAMP/1000
						Endif
					Endif
					n_QtdVal := n_QtdPer * n_Peso
				Else
					n_QtdVal := n_QtdDest
				Endif

				If n_QtdDest <> n_QtdVal
					ShowHelpDlg(SM0->M0_NOME, {"O campo Qtd Destino do item " + StrZero(i, 2) + " está preenchido incorretamente."},5,;
											{"Verifique se o cálculo para preencher o campo Qtd Destino foi realizado corretamente."},5)
					l_Ret := .F.
					Exit
				Endif
			Endif
		Next
	Endif

	RestArea(aArea)
Return l_Ret
