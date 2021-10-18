#Include 'Totvs.ch'

/*/{Protheus.doc} FPCPG01A
	Retorna a ferramenta
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 26/08/2021
	@return Variant, Ferramenta.
/*/
User Function FPCPG01A()

	Local FERRAM := M->H6_FERRAM

	DbSelectArea("SC2")
	DbSetOrder(6)
	If (DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)))
		MROT  = SC2->C2_ROTEIRO
		MPROD = SC2->C2_PRODUTO

		DbSelectArea("SG2")
		DbSetOrder(1)
		If (DbSeek(xFilial("SG2")+ MPROD + MROT))
			FERRAM = SG2->G2_FERRAM
		EndIf
	EndIf

Return FERRAM
