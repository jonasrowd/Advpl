#Include "Totvs.ch"

/*/{Protheus.doc} MTA650OK
	Usado para inibir dialogo confirmando criação de OPs intermediárias e SCs.
	Para não gerar OPs e SCs retornar .F. (equivalente ao botão Não) ou .T. (equivalente ao botão Sim) para gerar.
	Se por acaso desejar exibir a dialog retorne qualquer valor não-lógico
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return logical, l_Ret, Responsável pela confirmação antes de gerar Ops intermediárias e Scs.
/*/
User Function MTA650OK()

	Local l_Ret	:= .T.

Return l_Ret
