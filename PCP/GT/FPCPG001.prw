#Include 'Totvs.ch'

/*/{Protheus.doc} FPCPG001
	Gatilho para gerar o lote da OP no momento do apontamento.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 26/08/2021
	@return Variant, retorna o número do lote
/*/
User Function FPCPG001()

	Local cLote		:= '' //Variável utilizada para armazenar o lote
	Local cSigla	:= '' //Variável utilizada para armazenar a sigla do lote
	Private _cOrd   := IndexOrd()
	Private _nReg   := Recno()
	Private _cAlias := Alias()

	//Posiciona corretamente na SB1 para utilizar campos do produto
	DbSelectArea('SB1')
	DbSetOrder(1)
	DbSeek(FwXFilial('SB1') + M->H6_PRODUTO)
	If SB1->B1_RASTRO == 'L'	//VerIfica se o produto possui o campo de rastreabilidade preenchido
		If FwXFilial() == "020101"	// VerIfica se a empresa é SOPRO
			DbSelectArea("SA7") //Posiciona da tabela de amarração produto x cliente para verificar se o cliente precisa de nomenclatura de lote especial
			DbGoTop()
			DbSetOrder(2)
			DbSeek(xFilial("SA7") + M->H6_PRODUTO)
			While !EOF()
				If AllTrim(SA7->A7_FSSIGLA) <>'' .And. AllTrim(M->H6_PRODUTO) == AllTrim(SA7->A7_PRODUTO) .And. AllTrim(SubStr(cFilAnt,1,4)) == AllTrim(SA7->A7_FILIAL)
					cSigla := AllTrim(SA7->A7_FSSIGLA) //Armazena a sigla na variável para montar o lote
				EndIf
				DbSkip()
			End
			If cSigla <> ''
				cLote := SubStr(M->H6_OP,1,6) + SubStr(M->H6_OP,8,1) + SubStr(M->H6_OP,11,1) + AllTrim(cSigla)   // cria a estrutura do número do lote incluindo a SIGLA solicitada pelo Fornecedor
			Else
				cLote := SubStr(M->H6_OP,1,8) //Lote comum
			EndIf
		Else
			cLote := SubStr(M->H6_OP,1,8) + SubStr(M->H6_OP,10,2) //Lote dos produtos Bomix
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
