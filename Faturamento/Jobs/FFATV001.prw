#Include "Totvs.ch"
//Colocar no campo CK_PRODUTO VALIDACAO u_FFATV001(M->CK_PRODUTO)
/*/{Protheus.doc} FFATV001
	Valida a arte e a amarração do produto x cliente
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, Código do produto do campo atualmente posicionado
	@return Logical, Retorno lógico para validação do item
/*/
User Function FFATV001(cProduto)
	Local lOK   := .T. 		 // Controle de validação
	Local aArea := GetArea() // Tabela e seu estado para posterior restauração

	// Valida o bloqueio da arte do produto
	lOK := ValidaArte(cProduto)
	
	// Se a arte estiver desbloqueada, valida a amarração do produto x cliente
	If (lOK)
		lOK := ValidaSA7(cProduto)
	EndIf

	// Se a amarração do produto x cliente estiver OK,
	// valida se o campo C5_FSESPEC está preenchido.
	//If (lOk)
	//	lOK := jFSESPEC(cProduto)
	//Endif

	// Restaura a área e seu estado anterior
	RestArea(aArea)
Return (lOK)

/*/{Protheus.doc} ValidaArte
	Validações específicas da arte do produto
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, Código do produto do campo atualmente posicionado
	@return Logical, Retorno lógico para validação do item
/*/
Static Function ValidaArte(cProduto)
	Local lOK := .T. // Controle de validação da arte

	// Executa as validações apenas na rotina de orçamentos ou pedido de venda
	If (FwIsInCallStack("MATA415") .Or. FwIsInCallStack("MATA410") .Or. FwIsInCallStack("MATA416")) 
		// Pesquisa pelo produto na tabela SB1
		DBSelectArea("SB1")
		DBGoTop()
		DBSetOrder(1)
		DBSeek(FwXFilial("SB1") + cProduto)

		// Caso encontrado, verifica se o produto possui arte, se a mesma está desbloqueada e se é diferente de 99999
		If (Found() .And. !Empty(SB1->B1_FSARTE) .And. SB1->B1_FSARTE <> "99999")
			// Pesquisa pelo produto na tabela SZ2
			DBSelectArea("SZ2")
			DBGoTop()
			DBSetOrder(1)
			DBSeek(FwXFilial("SZ2") + SB1->B1_FSARTE)

			// Verifica se a arte do produto é nova, bloqueada ou em desenvolvimento
			If (Found() .And. SZ2->Z2_BLOQ $ "1|2|3")
				// Se for um orçamento, libera para gravação
				// Se for um pedido de venda, não permite a gravação
				lOK := IIf(FwIsInCallStack("MATA415"), .T., .F.)

				Help(NIL, NIL, "ART_BLOCKED", NIL, "A arte produto " + AllTrim(cProduto) + " não está disponível para utilização.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contate o setor de Computação Gráfica."})
			EndIf
		EndIf
	EndIf
Return (lOK)

/*/{Protheus.doc} ValidaSA7
	Valida a amarração do produto x cliente
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 25/06/2021
	@param cProduto, Character, Código do produto do campo atualmente posicionado
	@return Logical, Retorno lógico para validação do item
/*/
Static Function ValidaSA7(cProduto)
	Local lOK      := .T. // Controle da amarração cliente x produto
	Local cCliente := ""  // Código do cliente
	Local cLoja    := ""  // Código da loja

	// Verifica se está executando em qualquer outra filial que não seja a 030101
	If (FwCodFil() != "030101") .AND. M->C5_TIPO=='N'
		// Captura o código do cliente e loja
		If (FwIsInCallStack("MATA410")) 
			cCliente := M->C5_CLIENTE
			cLoja    := M->C5_LOJACLI
		ElseIf (FwIsInCallStack("MATA415"))
			cCliente := M->CJ_CLIENTE
			cLoja    := M->CJ_LOJA
		ElseIf (FwIsInCallStack("MATA416"))
			cCliente := M->CJ_CLIENTE
			cLoja    := M->CJ_LOJA
		EndIf

		// VerIfica se existe amarração Produto x Cliente
		DBSelectArea("SA7")
		DBGoTop()
		DBSetOrder(2)
		DBSeek(FwXFilial("SA7") + cProduto + cCliente + cLoja)

		// Caso não exista, retorna falso para a validação e exibe uma mensagem de erro
		If (!Found())
			// Se for um orçamento, libera para gravação
			// Se for um pedido de venda, não permite a gravação
			lOK := .F. // IIf(FwIsInCallStack("MATA415"), .T., .F.)
			Help(NIL, NIL, "ERROR: PRODUTO X CLIENTE", NIL, "Amarração Produto x Cliente inválida.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"O produto " + AllTrim(cProduto) + " não possui amarração Produto x Cliente."})
		EndIf
	EndIf
Return (lOK)

/*{Protheus.doc} jFSESPEC
	Valida se o campo Especificidade está preenchido.
	@type Function
	@version  12.1.25
	@author Jonas Machado
	@since 15/07/2021
	@param cProduto, character, Produto passado por parâmetro para função.
	@return Logical, Retorno lógico para validação do item


Static Function jFSESPEC(cProduto)
	Local lOK      := .T.           // Controle de validação da função
	Local aArea    := GetArea()     // Área de trabalho anterior
	Local cLoja    := M->C5_LOJACLI // Código da loja
	Local cCliente := M->C5_CLIENTE // Código do cliente

	// Se for a rotina MATA410
	If (FwIsInCallStack("MATA410"))
		// Posiciona no cabeçalho do pedido de vendas
		DBSelectArea("SC5")
		DBSetOrder(1)
		DBGoTop()
		DBSeek(FwXFilial("SC5") + cProduto + cCliente + cLoja)

		// Verifica se o campo C5_FSESPEC estiver vázio e a filial é diferente de 030101 
		If (Empty(M->C5_FSESPEC) .And. FwXFilial("SC5") != "030101")
			lOK := .F.
			Help(NIL, NIL, "ERROR: C5_FSESPEC", NIL, "O campo (Especifidade) deve ser preenchido.",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha o pedido corretamente."})
		EndIf
	EndIf

	// Restaura área de trabalho anterior
	RestArea(aArea)
Return (lOK)
*/
