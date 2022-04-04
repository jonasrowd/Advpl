//Bibliotecas
#Include "Totvs.ch"

/*/{Protheus.doc} A410Cons
    Ponto de entrada para incluir mais botões nas rotinas de usuário no pedido de vendas
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 15/12/2021
    @return array, aBotoes
/*/
User Function A410Cons()

    Local aArea     := GetArea() //Captura a área
    Local aBotoes   := {}        //Array de retorno dos botões a serem adicionados

    //Se for inclusão de novo pedido
    If INCLUI
        aAdd(aBotoes,{"Importa SA", {||U_IMPSA()}, "Importa SA","Importa SA"} )
    EndIf

    RestArea(aArea)

Return(aBotoes)
