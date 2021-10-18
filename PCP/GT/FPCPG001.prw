#Include 'Totvs.ch'

/*/{Protheus.doc} FPCPG001
	Gatilho para gerar o lote da OP.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 26/08/2021
	@return Variant, retorna o número do lote
/*/
User Function FPCPG001()
	Local cLote	 := ''   // cria o número do lote baseado na OP
	Local cSigla := ''
	_cAlias := Alias()
	_cOrd   := IndexOrd()
	_nReg   := Recno()

	DbSelectArea('SB1')
	DbSetOrder(1)
	DbSeek(FwXFilial('SB1') + M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'	//VerIfica se o produto possui rastreabilidade
		If cFilAnt == "020101"	// VerIfica se a empresa é SOPRO
			DbSelectArea("SA7")
			DbGoTop()
			DbSetOrder(2)
			DbSeek(xFilial("SA7") + M->H6_PRODUTO)
			While !EOF()
				If AllTrim(SA7->A7_FSSIGLA) <>'' .And. AllTrim(M->H6_PRODUTO) == AllTrim(SA7->A7_PRODUTO) .And. AllTrim(SubStr(cFilAnt,1,4)) == AllTrim(SA7->A7_FILIAL)
					cSigla=AllTrim(SA7->A7_FSSIGLA)
				EndIf
				DbSkip()
			End
			If cSigla <> ''
				cLote := SubStr(M->H6_OP,1,6) + SubStr(M->H6_OP,8,1) + SubStr(M->H6_OP,11,1) + AllTrim(cSigla)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor
			Else
				cLote := SubStr(M->H6_OP,1,8)
			EndIf
		Else
			cLote := SubStr(M->H6_OP,1,8)+SubStr(M->H6_OP,10,2)
		EndIf
	EndIf
	
	//Inclui a descrição do produto da OP
	M->H6_FSPRODU := SB1->B1_DESC
	M->H6_FSPESOI := Round((SB1->B1_PESO - SB1->B1_BRPEAL),2)
	M->H6_FSPESO  := CValToChar(Round((M->H6_QTDPROD + M->H6_QTDPERD) * (SB1->B1_PESO - SB1->B1_BRPEAL),4))
	
	// If !("TOTVSMES" $ M->H6_OBSERVA)

	// 	M->H6_OPERADO := CUSERNAME

	// EndIf

	DbSelectArea(_cAlias)
	DbSetOrder(_cOrd)
	DbGoTo(_nReg)

Return(cLote)
