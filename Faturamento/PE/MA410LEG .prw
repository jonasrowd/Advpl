#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA410LEG
	Legenda da tela do pedido de venda.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 09/08/2021
	@return Array, aLegenda, Texto das legendas customizadas
/*/
User Function MA410LEG ()

	Local aLegenda := aclone(PARAMIXB)
	If (FWCodFil() != '030101') //Se n�o for filial 03, segue o fonte
		aadd(aLegenda ,{'BR_PINK'  , 'Pedido Bloqueado por Restri��o Financeira.'  })
		aadd(aLegenda ,{'BR_MARROM', 'Pedido Liberado para Expedi��o.'  })
		aadd(aLegenda ,{'BR_PRETO' , 'Pedido Liberado para Produ��o.'  })
	EndIf

Return aLegenda
