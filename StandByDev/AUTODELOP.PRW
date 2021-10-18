#Include "Protheus.ch"
#include "rwmake.ch"
#include "TbiConn.ch"

//@SEE https://centraldeatendimento.totvs.com/hc/pt-br/articles/360019238311-MP-ADVPL-EXECU%C3%87%C3%83O-DA-ROTINA-AUTOMATICA-MATA650-VIA-SCHEDULE

User Function Tmata650()
    Local aMATA650  := {} //-Array com os campos
    Local DDATABASE := DATE()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ 3 - Inclusao ³
    //³ 4 - Alteracao ³
    //³ 5 - Exclusao ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    Local nOpc := 3
    Private lMsErroAuto := .F.

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
    aMATA650 := {;
                {'C2_FILIAL'    , CFILAUX   ,NIL},;
                {'C2_NUM'       , CNUMAUX   ,NIL},; 
                {'C2_ITEM'      , CITEMAUX  ,NIL},; 
                {'C2_SEQUEN'    , CSEQAUX   ,NIL},;
                {'C2_PRODUTO'   , CPRODAUX  ,NIL},;
                {'C2_LOCAL'     , CLOCALAUX ,NIL},;
                {'C2_QUANT'     , CQUANTAUX ,NIL},;
                {'C2_DATPRI'    , DDATABASE ,NIL},;
                {'C2_DATPRF'    , DDATABASE ,NIL},;
                {'AUTEXPLODE'   , "S"       ,NIL};
                }


    ConOut("Inicio : "+Time())

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se alteracao ou exclusao, deve-se posicionar no registro ³
    //³ da SC2 antes de executar a rotina automatica ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nOpc == 4 .Or. nOpc == 5
        SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
        SC2->(DbSeek(xFilial("SC2")+CNUMAUX+CITEMAUX+CSEQAUX))
    EndIf

    msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
    If !lMsErroAuto
        ConOut("Sucesso! ")
    Else
        ConOut("Erro!")
        MostraErro()
    EndIf

    ConOut("Fim : "+Time())

//RESET ENVIRONMENT

Return Nil
