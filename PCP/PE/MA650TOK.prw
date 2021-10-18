#Include 'Totvs.ch'

/*/{Protheus.doc} MA650TOK
	Rotina para preencher o n�mero do pedido e item do pedido, quando o usu�rio lan�a uma OP manual. Caso n�o exista um pedido relacionado com o n�mero e item lan�ado, 
	o usu�rio ser� alertado da inexist�ncia do pedido podendo o mesmo fazer a corre��o caso seja a situa��o.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/08/2021
	@return Logical, Valida se vai gerar ou n�o a Op, de acordo com a regra.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6089392
/*/
User Function MA650TOK()

	Local lRet := .T.

	M->C2_FSSALDO := M->C2_QUANT //Salva o Saldo na coluna customizada por capricho do Analista de BI

Return lRet
