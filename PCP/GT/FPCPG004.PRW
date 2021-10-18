#Include "Totvs.ch"

/*/{Protheus.doc} FPCPG004
	Gatilho para Sopro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return character, DESC
/*/
User Function FPCPG004

	Local MPROD := ""
	Local DESC	:= ""

	DbSelectArea("SC2")
	DbSetOrder(6)
	If (DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)))
		MPROD = SC2->C2_PRODUTO
		DbSelectArea("SB1")
		DbSetOrder(1)
		If (DbSeek(xFilial("SB1")+ MPROD))
			DESC = SB1->B1_DESC
		EndIf

	EndIf

Return DESC
