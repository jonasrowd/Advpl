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
	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		aadd(aLegenda ,{'BR_PINK'  , 'Pedido Bloqueado por Restrição Financeira.'  })
		aadd(aLegenda ,{'BR_MARROM', 'Pedido Liberado para Expedição.'  })
		aadd(aLegenda ,{'BR_PRETO' , 'Pedido Liberado para Produção.'  })
	EndIf

Return aLegenda
