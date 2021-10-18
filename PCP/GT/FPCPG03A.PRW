#Include "Totvs.ch"

/*/{Protheus.doc} FPCPG03A
	Gatilho para Sopro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return numeric, MOPE
/*/
User Function FPCPG03A

	Local MOPE := M->H6_OPERAC

	DbSelectArea("SC2")
	DbSetOrder(6)
	If (DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3)))
		MROT  = SC2->C2_ROTEIRO
		MPROD = SC2->C2_PRODUTO
		DbSelectArea("SG2")
		DbSetOrder(1)
		If (DbSeek(xFilial("SG2")+ MPROD + MROT))
			MOPE  = SG2->G2_OPERAC
		EndIf
	EndIf

Return MOPE
