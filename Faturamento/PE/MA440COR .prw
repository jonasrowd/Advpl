#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA440COR
	Adiciona novas cores de status na tela de preparação do documento de saída
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Array, Adiciona novas cores de status.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784501
/*/
User Function MA440COR()
	
Local aCor := aclone(PARAMIXB)

	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		aCor[1][1] := "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU<>'B'" 
		AADD(aCor,{"SC5->C5_BXSTATU=='B'" , "BR_PINK"   })
		AADD(aCor,{"SC5->C5_BXSTATU=='P'" , "BR_PRETO"   })
		AADD(aCor,{"SC5->C5_BXSTATU=='E'" , "BR_MARROM"   })
	EndIf

Return aCor
