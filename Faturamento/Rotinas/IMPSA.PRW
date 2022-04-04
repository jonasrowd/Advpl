// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} IMPSA
    Abre a Consulta Padrão e importa os itens da solicitação ao armazém para o pedido de vendas.
    @type Function
    @version 12.1.25
    @author Jonas Machado
    @since 16/12/2021
    @return Variant, Retorno nulo
/*/
User Function IMPSA()

    Local aArea    := FwGetArea()                   // Área de trabalho anteriormente posicionada
    Local aColsBkp := CreateaCols()
    Local lFirst   := .T.                           // Variável para controle de primeira execução, pois o aCols já vem inicializado zerado, ou seja, com a linha 1 preenchida.
    Local aAux     := {}                            // Array para auxiliar a montagem das próximas linhas do aCols
    Local aParamb  := {}                            // Array para armazenar as informações da Parambox
    Local aRet     := {}                            // Retorno da Parambox
    Local cFieldSA := Space(TamSX3("CP_NUM")[01])   // Campo para entrada de dados da Parambox
    Local j        := 0
    Local c_Tes    := Space(TamSX3("C6_TES")[01])
    Local cMensagem:= "Selecione a TES"
    // Local cFieldA1 := Space(TamSX3("CP_NUM")[01])

    aAdd(aParamb, {1, "Solicitação Armazém: ", cFieldSA, "", ".T.", "SCPSD3", ".T.", 80,  .F.})
    // aAdd(aParamb, {1, "Cliente:",  cFieldA1,  "", ".T.", "SA1", ".T.", 80,  .F.})

    ParamBox(aParamb ,"Pressione F3 para Buscar.",aRet)

    If !EMPTY(aRet)

        // Preenche o cabeçalho do pedido
        If !Empty(aRet[1])
            M->C5_MENNOTA := "PEDIDO EMITIDO A PARTIR DA SA: " + aRet[1]
        EndIf

        //M->C5_NATUREZA := "0201002" Verificar se há uma natureza padrão para o processo

        //Se o usuário clicar na rotina novamente eu reinicializo o aCols para evitar ficar adicionando linhas ao infinito e além
        aCols := AClone(aColsBkp)

        // Fecha o alias caso esteja em uso
        If (Select("SEARCHD3") > 0)
            DBSelectArea("SEARCHD3")
            DBCloseArea()
        EndIf

        // Pesquisa os registros na tabela de movimentos internos
        BEGINSQL ALIAS "SEARCHD3"
            SELECT
                D3_NUMSA,
                D3_COD,
                D3_ITEMSA,
                D3_TM,
                D3_UM,
                D3_QUANT,
                D3_LOCAL,
                D3_TBAPLIC,
                D3_TBDAPLI,
                D3_CC,
                D3_CF,
                D3_EMISSAO,
                D3_CUSTO1,
                D3_CUSTO2,
                D3_TIPO,
                D3_SEGUM,
                D3_USUARIO,
                D3_RATEIO
            FROM
                %TABLE:SD3%
            WHERE
                D3_NUMSA = %EXP:aRet[1]%
                AND D3_ESTORNO!='S'
                AND %NOTDEL%
                AND D3_FILIAL=%XFILIAL:SD3%
        ENDSQL

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atenção!") FROM 000,000 TO 170,495 PIXEL
        oFntDlg := TFont():New('Courier new',,-16,,.T.)
		oSayDlg	:= TSay():New(20,90,{||AllTrim(cMensagem)},oDlg,,oFntDlg,,,,.T.,,,80,400,,,,,,)
		oBtn612	:= TButton():New(050,20,"612 - Remessa p/ reparo.", oDlg, {||c_Tes := "612",oDlg:End()},90,20,,,,.T.,,"",,,,.F.) //P
		oBtn630	:= TButton():New(050,140,"630 - Remessa p/ indust.", oDlg, {||c_Tes := "630",oDlg:End()},90,20,,,,.T.,,"",,,,.F.) //L
		ACTIVATE MSDIALOG oDlg CENTERED

        // Percorre a tabela em busca dos itens da solicitação ao armazém e preenche no pedido de vendas
        While (!EOF())
            aAux := AClone(aColsBkp)
            j := j + 1
            If j < 10
                GDFieldPut("C6_ITEM"   , "0" + cValToChar(j)        , 1, aHeader, aAux, .F.)
            Else
                GDFieldPut("C6_ITEM"   , cValToChar(j)        , 1, aHeader, aAux, .F.)
            EndIf
            GDFieldPut("C6_PRODUTO", SEARCHD3->D3_COD     , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_UM"     , SEARCHD3->D3_UM      , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_QTDVEN" , SEARCHD3->D3_QUANT   , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_QTDLIB" , SEARCHD3->D3_QUANT   , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_VALOR"  , SEARCHD3->D3_CUSTO1  , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_SEGUM"  , SEARCHD3->D3_SEGUM   , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_TES"    , c_Tes                , 1, aHeader, aAux, .F.)
            If c_Tes == "612"
                GDFieldPut("C6_CF"     , "5915"           , 1, aHeader, aAux, .F.)
            Else
                GDFieldPut("C6_CF"     , "5901"           , 1, aHeader, aAux, .F.)
            EndIf
            GDFieldPut("C6_ENTREG" , DATE()               , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_LOCAL"  , SEARCHD3->D3_LOCAL   , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_CC"     , SEARCHD3->D3_CC      , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_PRCVEN" , (SEARCHD3->D3_CUSTO1 / SEARCHD3->D3_QUANT)  , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_DESCRI" , Posicione("SB1", 1, FwXFilial("SB1") + SEARCHD3->D3_COD, "B1_DESC") , 1, aHeader, aAux, .F.)
            GDFieldPut("C6_CONTA" , Posicione("SB1", 1, FwXFilial("SB1") + SEARCHD3->D3_COD, "B1_CONTA") , 1, aHeader, aAux, .F.)

            //Controle de criação da primeira linha
            If (lFirst)
                lFirst := .F.
                aCols[1] := AClone(aAux[1])
            Else
                AAdd(aCols, AClone(aAux[1]))
            EndIf

            // Vai para o próximo registro
            DBSkip()
        End
    Else
        If MsgYesNo("Deseja desfazer o preenchimento dos itens?", "Apagar Linhas")
            aCols := AClone(aColsBkp)
        EndIf
    EndIf

    // Restaura a tabela anteriomente posicionada
    FwRestArea(aArea)

    // Limpa os arrays da memória
    If !EMPTY(aAux)
        FwFreeArray(aAux)
        FwFreeArray(aColsBkp)
    EndIf

    FwFreeArray(aArea)

Return (NIL)

/*/{Protheus.doc} CreateaCols
    Cria uma estrutura de aCols com base no aCols privado da rotina
    @type Function
    @version 12.1.33
    @author Jonas Machado
    @since 20/12/2021
    @return Array, Estrutura do vetor aCols sem preenchimento
/*/
Static Function CreateaCols()
    // Variáveis locais para facilitar a leitura e manutenção
    Local nCounter // Contador para os campos do aHeader
    Local aBuilder  // Vetor backup da variável aCols

    // Inicialização das variáveis
    nCounter   := 1
    aBuilder  := {AClone(aCols[1])}

    aBuilder[1][nCounter] := "01"

    // Percorre cada um dos campos do cabeçalho e cria a estrutura inicializada com criavar
    For nCounter := 2 To Len(aHeader)
        If (!aHeader[nCounter][2] $ "C6_ALI_WT|C6_REC_WT")
            aBuilder[1][nCounter] := CriaVar(aHeader[nCounter][2], .T.)
        EndIf
    Next nCounter

    // Desfaz a deleção caso a linha esteja deletada, vai que o cidadão deletou a linha
    If (GDDeleted(1, aHeader, aBuilder))
        aBuilder[1][Len(aHeader) + 1] := .F.
    EndIf
Return (aBuilder)
