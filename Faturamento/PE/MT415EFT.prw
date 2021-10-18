#Include 'Totvs.ch'

/*/{Protheus.doc} MT415EFT
	Valida se o cliente está inadimplente.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Logical, l_Ret, se verdadeiro, deixa seguir o processo, se falso, bloqueia. //https://tdn.totvs.com/pages/releaseview.action?pageId=6784357
/*/
User Function MT415EFT()

	Local l_Ret		 := .T.
	Local nAtrasados := 0
	Local cNome 	 := ''
	Local _cAlias    := GetArea()

	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		nAtrasados := u_FFATVATR(SA1->A1_COD, SA1->A1_LOJA)
		cNome := SA1->A1_NOME

		If nAtrasados <> 0
			l_Ret := .T.
			Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Cliente " + AllTrim(cNome)  + " Pedido "+SC5->C5_NUM+", possui restrições financeiras no total de R$ ";
			+alltrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Acione o comercial para liberação."})
		EndIf
	EndIf
	RestArea(_cAlias)
Return l_Ret
