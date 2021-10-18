#Include "Totvs.ch"

/*/{Protheus.doc} MTA650OK
	Usado para inibir dialogo confirmando cria��o de OPs intermedi�rias e SCs.
	Para n�o gerar OPs e SCs retornar .F. (equivalente ao bot�o N�o) ou .T. (equivalente ao bot�o Sim) para gerar.
	Se por acaso desejar exibir a dialog retorne qualquer valor n�o-l�gico
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return logical, l_Ret, Respons�vel pela confirma��o antes de gerar Ops intermedi�rias e Scs.
/*/
User Function MTA650OK()

	Local l_Ret	:= .T.

Return l_Ret
