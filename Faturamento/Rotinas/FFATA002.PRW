#Include "Totvs.ch"

/*/{Protheus.doc} FFATA002
	Cria tabela de histórico de liberações
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 28/07/2021
/*/
User Function FFATA002()

	If FWCodFil() != "030101"
		AxCadastro("Z07","Histórico de Liberações")
	EndIf	
Return
