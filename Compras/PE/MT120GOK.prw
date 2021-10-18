#Include "Totvs.ch"

/*/{Protheus.doc} MT120GOK
	Inclui o nome reduzido do fornecedor na inclusão do pedido de compras
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 29/07/2021
	@return variant, Nil
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085477
/*/
User Function MT120GOK

	Local 	cFornece 	:= ""
	Local 	cLoja    	:= ""
	Private cNum	:= ""
	Private	_cAlias := ""
	Private _cOrd	:= ""
	Private nReg	:= ""

	cFornece := SC7->C7_FORNECE
	cLoja 	 := SC7->C7_LOJA
	cNomeFor := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2") + cFornece + cLoja, "A2_NREDUZ"))

	If PARAMIXB[2]
		_cAlias := ALIAS()
		_cOrd   := INDEXORD()
		nReg    := RECNO()
		cNum    := SC7->C7_NUM

		GrvForne()
		
		DbSelectArea( _cAlias )
		DbSetOrder( _cOrd )
		DbGoTo( nReg )
	EndIf     

Return(.T.)

/*/{Protheus.doc} GrvForne
	Grava o nome do fornecedor
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 29/07/2021
	@return variant, Nil
/*/
Static Function GrvForne()

	DbSelectArea("SC7")		
	DbSetOrder(1)
	If DbSeek(xFilial("SC7") + cNum)
		While SC7->(!eof()) .and. cNum == alltrim(SC7->C7_NUM)
			Reclock("SC7",.F.)
				C7_BXNREDU := cNomeFor
			MsUnLock()
			SC7->(dbskip())
		enddo
	endif

Return
