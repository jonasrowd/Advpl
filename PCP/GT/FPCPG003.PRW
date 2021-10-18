#INCLUDE "Totvs.ch"

/*/{Protheus.doc} FPCPG003
	Gatilho para Sopro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return numeric, n_cavi
/*/
User Function FPCPG003

	Local n_cavi := 0.00

	DbSelectArea("SG2")
	DbSetOrder(3)
	If (DbSeek(xFilial("SG2")+ M->H6_PRODUTO+m->H6_OPERAC))
		n_cavi :=  SG2->G2_FSCAVI
	EndIf

Return n_cavi
