#Include "Totvs.ch"

/*/{Protheus.doc} FPCPG02A
Gatilho para Sopro
@type function
@version 12.1.25
@author Jonas Machado
@since 07/10/2021
@return character, MREC
/*/
User Function FPCPG02A

	Local MREC := M->H6_RECURSO

	DbSelectArea("SC2")
	DbSetOrder(6)
	If (DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)))
		MROT  = SC2->C2_ROTEIRO
		MPROD = SC2->C2_PRODUTO
		DbSelectArea("SG2")
		DbSetOrder(1)
		If (DbSeek(xFilial("SG2")+ MPROD + MROT))
			MREC = SG2->G2_RECURSO
		EndIf
	EndIf

Return MREC
