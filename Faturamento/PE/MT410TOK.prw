#Include "TOTVS.ch"

/*/{Protheus.doc} MT410TOK
    Ponto de entrada de valida��o de grava��o do Pedido de Venda
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 02/07/2021
    @return Logical, Permite ou n�o a grava��o do registro
/*/
User Function MT410TOK()
    Local lOK  := .T.                                                 // Controle de prosseguimento da grava��o
    Local nX   := 0                                                   // Controle do la�o de itens
    Local nPos := AScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"}) // Posi��o do c�digo de produto dentro aCols

    If M->C5_TIPO=='N'
    // Percorre todos os itens do vetor aCols
        For nX := 1 To Len(aCols)
            // Verifica se a linha n�o est� deletada
            If (!GDDeleted(nX, aHeader, aCols))
                // Valida a arte e a amarra��o do produto x cliente
                // Se der erro, para de percorrer o vetor
                If !(lOK := U_FFATV001(aCols[nX][nPos]))
                    EXIT
                EndIf
            EndIf
        Next nX
    EndIf
Return (lOK)
