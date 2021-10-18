/*/{Protheus.doc} A261TOK
	Validação da Transferência Mod 2 O ponto sera disparado no inicio da chamada da funcao de validacao geral dos itens digitados. 
	Serve para validar se o movimento pode ser efetuado ou nao.
	@type function
	@version  12.1.25
	@author jonas.machado
	@since 21/07/2021
	@return variant, .T.
/*/
User Function A261TOK()
	Local l_Ret    := .T.
	Local c_Orig   := ''									//Armazem de Origem
	Local c_Dest   := ''    								//Armazem de Destino
	Local c_Menu   := Upper(NoAcento(AllTrim(FunDesc())))   //Nome do menu executado
	Local a_Area   := GetArea()
	Local c_Users  := Getmv("FS_TRANSFE")
	Local i		   := ''
	
    If INCLUI .And. c_Menu == 'TRANSF. (MOD.2)'
		For i:=1 To Len(aCols)
		   	If aCols[i][Len( aHeader )+1] == .F.
				c_Orig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM ORIG.' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
				c_Dest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'ARMAZEM DESTINO' .And. Alltrim(x[2]) == 'D3_LOCAL'})]
		
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Orig)
					If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
						dbSelectArea("SZ7")
						dbSetOrder(1)
						If dbSeek(xFilial("SZ7") + __CUSERID + c_Dest)
							If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
								l_Ret := .T.
							Else
								ShowHelpDlg(SM0->M0_NOME,;
								{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Dest + "."},5,;
								{"Contacte o administrador do sistema."},5)
								l_Ret := .F.
								Exit
							Endif
						Else
							ShowHelpDlg(SM0->M0_NOME,;
							{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Dest + "."},5,;
							{"Contacte o administrador do sistema."},5)
							l_Ret := .F.
							Exit
						Endif
					Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Orig + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
						Exit
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Orig + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
					Exit
				Endif
				
				If l_Ret

					c_LoteOrig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'LOTE'})]
					c_LoteDest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'LOTE DESTINO'})]  
					c_UMOrig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'UM ORIG.'})]
					c_UMDest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'UM DESTINO'})]
					c_DTOrig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'VALIDADE'})]
					c_DTDest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'VALIDADE DESTINO'})]  

					c_ProdOrig := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'PROD.ORIG.' .And. Alltrim(x[2]) == 'D3_COD'})]
					c_GrupoOri := Posicione("SB1", 1, xFilial("SB1") + c_ProdOrig, "B1_GRUPO")
					c_Classe_D := SB1->B1_FSPRODD

					c_ProdDest := aCols[i][AScan(aHeader,{ |x| Upper(Alltrim(x[1])) == 'PROD.DESTINO' .And. Alltrim(x[2]) == 'D3_COD'})]
					c_GrupoDes := Posicione("SB1", 1, xFilial("SB1") + c_ProdDest, "B1_GRUPO")

					If (c_GrupoOri <> c_GrupoDes) .And. (c_ProdDest <> c_Classe_D) .And. (SubStr(c_GrupoOri, 1, 1) $ "BT")
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"Não é permitido realizar transferências entre produtos de grupos diferentes."},5,;
							{"Contacte o administrador do sistema para informar sobre este problema no item " + StrZero(i, 2) + "."},5)
						l_Ret := .F.
						Exit    
					Endif
				Endif
				If (c_UMOrig <> c_UMDest) 
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"UNIDADE DE MEDIDA Origem deve ser igual a UNIDADE DE MEDIDA Destino."},5)
						l_Ret := .F.
						Exit    
				Endif	       
                If !(__CUSERID $ c_Users) // VERIFICA NO PARÂMETRO "FS_TRANSFE" SE O USUÁRIO TEM PERMISSÃO PARA TRANSFERIR ENTRE LOTES DIFERENTES
                
					If 	c_LoteOrig <> c_LoteDest .And. RTRIM(c_LoteDest)<>''
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"LOTE Origem deve ser igual ao LOTE Destino."},5)
						l_Ret := .F.
						Exit    
					Endif	
					If (c_DTOrig <> c_DTDest) 
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"DATA VALIDADE DO LOTE Origem deve ser igual a DATA VALIDADE DO LOTE Destino."},5)
						l_Ret := .F.
						Exit    
					Endif
					If (c_ProdOrig <> c_ProdDest) 
						ShowHelpDlg(AllTrim(SM0->M0_NOME),;
							{"Produto Origem deve ser igual ao Produto Destino."},5)
						l_Ret := .F.
						Exit    
					Endif	
			    Endif	 	
			Endif
		Next

		If l_Ret
			If DA261DATA <> DDATABASE
				ShowHelpDlg(SM0->M0_NOME,;
					{"Data de Emissão inválida."},5,;
					{"Preencha a Data de Emissão com a data atual do sistema."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
	RestArea(a_Area)
Return l_Ret
