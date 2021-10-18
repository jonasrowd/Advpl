//Bibliotecas necess�ras
#Include 'Totvs.ch'

/*/{Protheus.doc} M410PVNF
	Ponto de entrada para validar restri��es financeiras
	@type Function
	@version 12.1.25 
	@author R�mulo Ferreira
	@since 04/08/2021
	@return Logical, lOK Vari�vel de Controle
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784152
/*/
User Function M410PVNF
	Local lOK := .T.

	If (FWCodFil() != "030101" .And. SC5->C5_BXSTATU $ "B|P")
		lOK := .F.
		Help(NIL, NIL, "PED_BLOCKED", NIL, "Pedido com restri��es financeiras.",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicitar a libera��o do setor comercial."})
	EndIf

Return (lOK)
