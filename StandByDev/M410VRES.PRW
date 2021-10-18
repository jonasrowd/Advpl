#Include "Totvs.ch"

/*/{Protheus.doc} M410VRES
    Ponto de entrada na confirmação da eliminação de resíduos do pedido de venda.
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 06/10/2021
    @return logical, lConfirma
/*/
User Function M410VRES()

    Local lConfirma := .T.

    MsgAlert("cText", "cTitle")

Return (lConfirma)
