//Bibliotecas necessáras
#Include 'Totvs.ch'

/*/{Protheus.doc} M410PVNF
	Ponto de entrada para validar restrições financeiras
	@type Function
	@version 12.1.25 
	@author Rômulo Ferreira
	@since 04/08/2021
	@return Logical, lOK Variável de Controle
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784152
/*/
User Function M410PVNF
	Local lOK := .T.

	If (FWCodFil() != "030101" .And. SC5->C5_BXSTATU $ "B|P")
		lOK := .F.
		Help(NIL, NIL, "PED_BLOCKED", NIL, "Pedido com restrições financeiras.",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicitar a liberação do setor comercial."})
	EndIf

Return (lOK)
