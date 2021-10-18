#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA415LEG
	Ponto de entrada para adicionar legenda customizada na rotina de or�amentos.
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 09/08/2021
	@return Array, Traz novas cores de status.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784276
/*/
User Function MA415LEG()

	Local aLegenda := aclone(PARAMIXB)

	If (FWCodFil() != '030101') //Se n�o for filial 03, segue o fonte	
		aadd(aLegenda ,{'BR_PINK'    , 'Or�amento Bloqueado por Restri��o Financeira'  })
		aadd(aLegenda ,{'BR_AZUL_CLARO'    , 'Or�amento Baixado com Restri��o Financeira'  })
	EndIf
	
Return aLegenda
