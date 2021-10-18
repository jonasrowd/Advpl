#Include 'Totvs.ch'

/*/{Protheus.doc} MA650TOK
	Rotina para preencher o número do pedido e item do pedido, quando o usuário lança uma OP manual. Caso não exista um pedido relacionado com o número e item lançado, 
	o usuário será alertado da inexistência do pedido podendo o mesmo fazer a correção caso seja a situação.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/08/2021
	@return Logical, Valida se vai gerar ou não a Op, de acordo com a regra.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089392
/*/
User Function MA650TOK()

	Local lRet := .T.

	M->C2_FSSALDO:=M->C2_QUANT //Salva o Saldo na coluna customizada.

Return lRet
/*
User Function FPCPG005()
	Local c_pedido
	Local c_itemped
	Local lRet := .T.

	c_pedido:="0"+SUBST(M->C2_NUM,2,5)
	c_itemped:=M->C2_ITEM

	If cFilAnt == "010101"
		DbSelectArea("SC6")
		DbGoTop()
		DbSetOrder(1)
		DbSeek(FWXFilial("SC6")+c_pedido+c_itemped+M->C2_PRODUTO)
		If !EOF()
			M->C2_PEDIDO:=SC6->C6_NUM
			M->C2_ITEMPV:=SC6->C6_ITEM
			M->C2_QUANT:=SC6->C6_QTDVEN
			RecLock("SC6",.F.)
				SC6->C6_NUMOP	:=   M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN
				SC6->C6_ITEMOP	:= M->C2_ITEM
			MsUnlock()
		Else
			If MsgBox("Não existe um pedido de venda que relacione com esta OP. Confirma?", "Pedido Inexistente", "YESNO")
				M->C2_PEDIDO:=""
				M->C2_ITEMPV:=""
				lRet:= .T.
			Else

				M->C2_NUM:="      	"
				//	M->C2_ITEM:=""
				M->C2_PEDIDO:=""
				M->C2_ITEMPV:=""
				//M->C2_PRODUTO:=""
				M->C2_QUANT:=0
				lRet:= .F.

			EndIf
		EndIf
	EndIf
Return lRet
*/
