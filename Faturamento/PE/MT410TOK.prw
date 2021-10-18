#Include "TOTVS.ch"

/*/{Protheus.doc} MT410TOK
    Ponto de entrada de validação de gravação do Pedido de Venda
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 02/07/2021
    @return Logical, Permite ou não a gravação do registro
/*/
User Function MT410TOK()
    Local lOK  := .T.                                                 // Controle de prosseguimento da gravação
    Local nX   := 0                                                   // Controle do laço de itens
    Local nPos := AScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"}) // Posição do código de produto dentro aCols

    If M->C5_TIPO=='N'
    // Percorre todos os itens do vetor aCols
        For nX := 1 To Len(aCols)
            // Verifica se a linha não está deletada
            If (!GDDeleted(nX, aHeader, aCols))
                // Valida a arte e a amarração do produto x cliente
                // Se der erro, para de percorrer o vetor
                If !(lOK := U_FFATV001(aCols[nX][nPos]))
                    EXIT
                EndIf
            EndIf
        Next nX
    EndIf
Return (lOK)
