#Include 'Totvs.ch'

/*/{Protheus.doc} MA410MNU
	Adiciona ao menu do pedido de vendas a rotina customizada BXMENATR
	@type Function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@see https://tdn.totvs.com/display/public/PROT/MA410MNU
/*/
User Function MA410MNU

	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		aAdd(aRotina,{'Liberação',"u_BXMENATR(,SC5->C5_CLIENTE,SC5->C5_LOJACLI)",0,2,0,NIL})
	EndIf

Return Nil
