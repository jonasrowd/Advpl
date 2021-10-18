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

	M->C2_FSSALDO := M->C2_QUANT //Salva o Saldo na coluna customizada por capricho do Analista de BI

Return lRet
