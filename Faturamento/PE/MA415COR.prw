//Bibliotecas necessárias
#Include 'Totvs.ch'

/*{Protheus.doc} MA415COR
	Ponto de Entrada para inclusão de novas cores de legendas na tela de orçamentos
	@type Function
	@author Rômulo Ferreira
	@since 04/01/21
	@version 12.1.25
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784274
/*/
User Function MA415COR()

	Local aCor := aClone(PARAMIXB)

	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		aCor[1]:= {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU<>'B'" , "ENABLE"}
		aCor[2]:= {"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU<>'B'" , "DISABLE"} 

		aAdd(aCor,{"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_PINK"})		//Orçamento Bloqueado por restrição de crédito
		aAdd(aCor,{"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_AZUL_CLARO"})	//Orçamento Liberado com restrição de crédito
	EndIf

Return aCor
