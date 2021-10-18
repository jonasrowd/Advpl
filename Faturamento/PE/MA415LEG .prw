#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA415LEG
	Ponto de entrada para adicionar legenda customizada na rotina de orçamentos.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Array, Traz novas cores de status.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784276
/*/
User Function MA415LEG()

	Local aLegenda := aclone(PARAMIXB)

	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte	
		aadd(aLegenda ,{'BR_PINK'    , 'Orçamento Bloqueado por Restrição Financeira'  })
		aadd(aLegenda ,{'BR_AZUL_CLARO'    , 'Orçamento Baixado com Restrição Financeira'  })
	EndIf
	
Return aLegenda
