#INCLUDE "Totvs.ch"

/*/{Protheus.doc} FPCPG002
	Gatilho SH6 para Sopro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return numeric, n_Ciclo
/*/
User Function FPCPG002

	Local n_Ciclo := 0.0

	DbSelectArea("SG2")
	DbSetOrder(3)
	If (DbSeek(xFilial("SG2")+ M->H6_PRODUTO+m->H6_OPERAC))
		n_Ciclo := SG2->G2_FSCICLO
	EndIf

Return n_Ciclo
