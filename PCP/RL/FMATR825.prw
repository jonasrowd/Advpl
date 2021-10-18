#Include "Protheus.CH"
#Include "MATR825.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR825  ³ Autor ³ Felipe Nunes Toledo   ³ Data ³ 08/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Horas Improdutivas / Produtivas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function FMATR825()
Local oReport

Private cTpHr     := GetMV("MV_TPHR")
Private cAliasSH6 := "SH6"
Private bConv     := {|x| A680ConvHora(x,"C",cTpHr) }
                                                         
AjustaSX1()

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR825R3()
EndIf

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Felipe Nunes Toledo    ³ Data ³08/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR825			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport
Local oApont
Local aOrdem   := {STR0004,STR0005,STR0006,STR0007,STR0008}	//"Por OP"###"Por Recurso"###"Por Motivo"###"Por Data"###"Por Operador"
Local cPictH6  := If(cTpHr == "C","@R 999.99",'')
Local cPictHr  := If(cTpHr == "C","@R 99.99",'')
Local cPicTotH := If(cTpHr == "C","@R " +Replicate("9",TamSX3("H6_TEMPO")[1]-3) +".99",'')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("MATR825",OemToAnsi(STR0001),"MTR826", {|oReport| ReportPrint(oReport,aOrdem)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)) //##"Relacao  de Horas Improdutivas / Produtivas apontadas, de acordo com a ordem selecionada pelo usuario."
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.
oReport:SetTotalText(STR0023) //"Motivos que geraram horas improdutivas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas - MTR826                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Lista Horas Improdutivas / Produtivas / Ambas³
//³ mv_par02     // De  OP 					                     ³
//³ mv_par03     // Ate OP										 ³
//³ mv_par04     // De  Recurso                                  ³
//³ mv_par05     // Ate Recurso                                  ³
//³ mv_par06     // De  Motivo                                   ³
//³ mv_par07     // Ate Motivo                                   ³
//³ mv_par08     // De  Data                                     ³
//³ mv_par09     // Ate Data                                     ³
//³ mv_par10     // De  Operador                                 ³
//³ mv_par11     // Ate Operador                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1 (oApont)                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oApont := TRSection():New(oReport,STR0025,{"SH6","SH1","SH4"},aOrdem) //"Relatorio de Horas Improdutivas / Produtivas"
oApont:SetHeaderPage()
oApont:SetTotalInLine(.T.)

TRCell():New(oApont,'H6_TIPO'   ,'SH6',"TIPO"/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_OP'     ,'SH6',"O.P."/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_TEMPO'  ,'SH6',"TEMPO"/*Titulo*/,cPictH6    ,/*Tamanho*/,/*lPixel*/, {|| TimeH6(Nil,Nil,cAliasSH6) })
TRCell():New(oApont,'H6_RECURSO','SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H1_DESCRI' ,'SH1',""/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_FERRAM' ,'SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H4_DESCRI' ,'SH4',""/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_MOTIVO' ,'SH6',STR0024/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'X5_DESCRI' ,'SX5',""/*Titulo*/,/*Picture*/,35		  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_DTAPONT','SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_OPERADO','SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_DATAINI','SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_DATAFIN','SH6',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oApont,'H6_HORAINI','SH6',/*Titulo*/,cPictHr    ,/*Tamanho*/,/*lPixel*/,{|| TimeH6(Nil, 'H6_HORAINI', cAliasSH6) })
TRCell():New(oApont,'H6_HORAFIN','SH6',/*Titulo*/,cPictHr    ,/*Tamanho*/,/*lPixel*/,{|| TimeH6(Nil, 'H6_HORAFIN', cAliasSH6) })
If cTpHr == "C"
	TRCell():New(oApont,'PRODUTIVA'  ,'SH6',/*Titulo*/,cPicTotH,/*Tamanho*/,/*lPixel*/,{|| Val(StrTran(If(H6_TIPO=='P',TimeH6(Nil,Nil,cAliasSH6),"000:00"),':','.')) })
	TRCell():New(oApont,'IMPRODUTIVA','SH6',/*Titulo*/,cPicTotH,/*Tamanho*/,/*lPixel*/,{|| Val(StrTran(If(H6_TIPO=='I',TimeH6(Nil,Nil,cAliasSH6),"000:00"),':','.')) })
Else
	TRCell():New(oApont,'PRODUTIVA'  ,'SH6',/*Titulo*/,cPicTotH,/*Tamanho*/,/*lPixel*/,{|| If(H6_TIPO=='P',TimeH6(Nil,Nil,cAliasSH6),"000:00") })
	TRCell():New(oApont,'IMPRODUTIVA','SH6',/*Titulo*/,cPicTotH,/*Tamanho*/,/*lPixel*/,{|| If(H6_TIPO=='I',TimeH6(Nil,Nil,cAliasSH6),"000:00") })
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das celulas c/ base no SX5, para totalizar os motivos de hrs Improdutivas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"44")
Do While X5_FILIAL+X5_TABELA == xFilial("SX5")+"44"
 	TRCell():New(oApont,Trim(SX5->X5_CHAVE),,Trim(SX5->X5_CHAVE),cPictH6,,,)
 	dbSkip()
EndDo

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³Felipe Nunes Toledo  ³ Data ³08/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR825			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aOrdem)
Local oApont    := oReport:Section(1)
Local nOrdem    := oApont:GetOrder()
Local nCnt      := 3 // Variavel p/ controle dos Motivos que deveram serem impressos
Local cWhere
Local cOrderBy
Local cIndex
Local xValMot

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(STR0001+" "+aOrdem[nOrdem])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Defininco a Quebra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	oBreak := TRBreak():New(oApont,oApont:Cell("H6_OP"),STR0020+STR0012,.T.) // "Total da OP:"
Elseif nOrdem == 2
	oBreak := TRBreak():New(oApont,oApont:Cell("H6_RECURSO"),STR0020+STR0013,.T.)// "Total do Recurso:"
Elseif nOrdem == 3
	oBreak := TRBreak():New(oApont,oApont:Cell("H6_MOTIVO"),STR0020+STR0014,.T.)// "Total do Motivo:"
Elseif nOrdem == 4
	oBreak := TRBreak():New(oApont,oApont:Cell("H6_DTAPONT"),STR0020+STR0015,.T.) // "Total da Data:"
Elseif nOrdem == 5
	oBreak := TRBreak():New(oApont,oApont:Cell("H6_OPERADO"),STR0020+STR0016,.T.) // "Total do Operador:" 
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totalizando as Horas Produtivas / Improdutivas conforme a Quebra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFunction := TRFunction():New(oApont:Cell('PRODUTIVA'),'PRODUTIVA',If(cTpHr =="N","TIMESUM","SUM"),oBreak,STR0021,/*Picture*/,/*uFormula*/,.F.,.F.) //"Horas Produtivas"
oFunction := TRFunction():New(oApont:Cell('IMPRODUTIVA'),'IMPRODUTIVA',If(cTpHr =="N","TIMESUM","SUM"),oBreak,STR0022,/*Picture*/,/*uFormula*/,.F.,.F.) //"Horas Improdutivas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Totalizando a Horas Improdutivas, por Motivos, p/ impressao no Final do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"44")
Do While X5_FILIAL+X5_TABELA == xFilial("SX5")+"44"
	oFunction := TRFunction():New(oApont:Cell(Trim(SX5->X5_CHAVE)),Trim(SX5->X5_CHAVE),If(cTpHr =="N","TIMESUM","SUM"),,Padr(Trim(Upper(SX5->X5_DESCRI)),35,"-"),,,.F.,.T.)
 	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatorio da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oApont:BeginQuery()	
	
	cAliasSH6 := GetNextAlias()
	
	//cWhere := "%"
	If mv_par01 == 1 
		cWhere := " H6_TIPO = 'I' AND "
	Elseif mv_par01 == 2
		cWhere := " H6_TIPO = 'P' AND "
	EndIf
	//cWhere += "%"
	  
   	//cWhere1 := "%"
   	If mv_par12==1
  		cWhere1 := " ((H6_OP=' ') OR (H6_OP >= '"+mv_par02+"' AND H6_OP <= '"+mv_par03+"' )) AND "
  	Else
  		cWhere1 := " (H6_OP >= '"+mv_par02+"' AND H6_OP <= '"+mv_par03+"' ) AND "
 	EndIf	
	//cWhere1 += "%"	 
	
	cWhere2 := "%"	
	If !Empty(cWhere)
		cWhere2 += cWhere
	Endif 
	
	If !Empty(cWhere1)
		cWhere2 += cWhere1
	EndIf
	cWhere2 += "%"
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Order by de acordo com a ordem selecionada.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cOrderBy := "%"
	If nOrdem == 1
		cOrderBy += " H6_FILIAL, H6_OP, H6_DTAPONT " // Por OP
	ElseIf nOrdem == 2
		cOrderBy += " H6_FILIAL, H6_RECURSO, H6_DTAPONT, H6_OP " // Por Recurso
	ElseIf nOrdem == 3
		cOrderBy += " H6_FILIAL, H6_MOTIVO, H6_DTAPONT " // Por Motivo
	ElseIf nOrdem == 4
		cOrderBy += " H6_FILIAL, H6_DTAPONT, H6_MOTIVO " // Por Data
	ElseIf nOrdem == 5
		cOrderBy += " H6_FILIAL, H6_OPERADO, H6_DTAPONT " //Por Operador
	EndIf
	cOrderBy += "%"
          
	BeginSql Alias cAliasSH6

	SELECT SH6.H6_FILIAL, SH6.H6_PRODUTO, SH6.H6_OPERAC, SH6.H6_SEQ, SH6.H6_DATAINI, SH6.H6_HORAINI, 
	       SH6.H6_DATAFIN, SH6.H6_HORAFIN, SH6.H6_RECURSO, SH6.H6_OP, SH6.H6_MOTIVO, SH6.H6_DTAPONT, 
	       SH6.H6_OPERADO, SH6.H6_TEMPO, SH6.H6_TIPOTEM, SH6.H6_TIPO, SH6.H6_FERRAM

    FROM %table:SH6% SH6
	
	WHERE H6_FILIAL = %xFilial:SH6% AND
	      //H6_OP       Between %Exp:mv_par02% AND %Exp:mv_par03% AND
	 	  H6_RECURSO  Between %Exp:mv_par04% AND %Exp:mv_par05%	 AND
	 	  H6_MOTIVO   Between %Exp:mv_par06% AND %Exp:mv_par07%	 AND
		  H6_DTAPONT  Between %Exp:mv_par08% AND %Exp:mv_par09%	 AND
 		  H6_OPERADO  Between %Exp:mv_par10% AND %Exp:mv_par11%	 AND
 		  //%Exp:cWhere cWhere1% 
 		  %Exp:cWhere2% 
 		  SH6.%NotDel%
 	
 	ORDER BY %Exp:cOrderBy%
			
	EndSql 

	oApont:EndQuery()
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao ADVPL                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	dbSelectArea(cAliasSH6)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indice Condicional de acordo com a ordem selecionada.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem == 1
		cIndex:="H6_FILIAL+H6_OP+DTOS(H6_DTAPONT)"
	ElseIf nOrdem == 2
		cIndex:="H6_FILIAL+H6_RECURSO+DTOS(H6_DTAPONT)+H6_OP"
	ElseIf nOrdem == 3
		cIndex:="H6_FILIAL+H6_MOTIVO+DTOS(H6_DTAPONT)"
	ElseIf nOrdem == 4
		cIndex:="H6_FILIAL+DTOS(H6_DTAPONT)+H6_MOTIVO"
	ElseIf nOrdem == 5
		cIndex:="H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)"
	EndIf
	
	cCondicao := 'H6_FILIAL=="'+xFilial("SH6")+'".And.'
	cCondicao += 'H6_TIPO$"'+IIF(mv_par01==1,"I",IIF(mv_par01==2,"P","PI"))+'".And.'
	If mv_par01 # 2
		If mv_par12==1
			cCond += '( (H6_OP=" ") .Or. (H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'")) .And.'  
		Else
			cCond += ' H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'" .And.'  
		EndIf
		
	Else
		If mv_par12==1
			cCond += '( (H6_OP=" ") .Or. (H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'")).And.'
		Else
			cCond += 'H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'".And.'
		EndIf
	EndIf
	cCondicao += 'H6_RECURSO>="'+mv_par04+'".And.H6_RECURSO<="'+mv_par05+'".And.'
	cCondicao += 'H6_MOTIVO>="'+mv_par06+'".And.H6_MOTIVO<="'+mv_par07+'".And.'
	cCondicao += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par08)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par09)+'"'	 	

	oReport:Section(1):SetFilter(cCondicao,cIndex)

#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicionamento das tabelas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oApont,"SH1",1,{|| xFilial("SH1") + (cAliasSH6)->H6_RECURSO})
TRPosition():New(oApont,"SH4",1,{|| xFilial("SH4") + (cAliasSH6)->H6_FERRAM }) 
TRPosition():New(oApont,"SX5",1,{|| xFilial("SX5")+"44"+(cAliasSH6)->H6_MOTIVO }) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inibindo celulas, utilizadas apenas para totalizadores³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oApont:Cell('PRODUTIVA'):Hide()
oApont:Cell('IMPRODUTIVA'):Hide()
oApont:Cell('PRODUTIVA'):HideHeader()
oApont:Cell('IMPRODUTIVA'):HideHeader()

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"44")
Do While X5_FILIAL+X5_TABELA == xFilial("SX5")+"44"
 	oApont:Cell(Trim(SX5->X5_CHAVE)):Hide()
	oApont:Cell(Trim(SX5->X5_CHAVE)):HideHeader()
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(SH6->(LastRec()))
oApont:Init()

dbSelectArea(cAliasSH6)
While !oReport:Cancel() .And. !(cAliasSH6)->(Eof())

	SX5->(dbSeek(xFilial("SX5")+"44"))
	dbSelectArea(cAliasSH6)
	Do While SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"44"
		If (cAliasSH6)->H6_MOTIVO == Trim(SX5->X5_CHAVE)
			//If cTpHr == "C"
			//	oApont:Cell(Trim(SX5->X5_CHAVE)):SetValue(Val(StrTran(TimeH6(Nil,Nil,cAliasSH6),':','.')))
			//Else
			//	oApont:Cell(Trim(SX5->X5_CHAVE)):SetValue(TimeH6(Nil,Nil,cAliasSH6))
			//EndIf				
			//oApont:Cell(Trim(SX5->X5_CHAVE)):SetValue((cAliasSH6)->H6_TEMPO)
			oApont:Cell(Trim(SX5->X5_CHAVE)):SetValue(Val(StrTran(TimeH6(Nil,Nil,cAliasSH6),':','.')))
		Else
			oApont:Cell(Trim(SX5->X5_CHAVE)):SetValue(0)
		Endif 		
	 	SX5->(dbSkip())
	EndDo

	oApont:PrintLine()
	(cAliasSH6)->(dbSkip())
	oReport:IncMeter()
EndDo


dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"44")
Do While X5_FILIAL+X5_TABELA == xFilial("SX5")+"44"
	xValMot := oApont:GetFunction(Trim(SX5->X5_CHAVE)):ReportValue()
	If ValType(xValMot) == "N" .And. xValMot == 0 // Nao imprime Motivos com Total de Horas zerado.
		oReport:aFunction[nCnt]:lEndSection := .F.
		oReport:aFunction[nCnt]:lEndReport  := .F.
		oReport:aFunction[nCnt]:lEndPage    := .F.
	EndIf
	nCnt++
	dbSkip()
EndDo

oApont:Finish()
(cAliasSH6)->(DbCloseArea())
oReport:EndPage() //-- Salta Pagina

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³              |                  ³±±
±±³      02  ³Erike Yuri da Silva       ³23/01/2006    |00000092017       ³±±
±±³      03  ³                          ³              |                  ³±±
±±³      04  ³                          ³              |                  ³±±
±±³      05  ³                          ³              |                  ³±±
±±³      06  ³                          ³              |                  ³±±
±±³      07  ³                          ³              |                  ³±±
±±³      08  ³                          ³              |                  ³±±
±±³      09  ³Erike Yuri da Silva       ³23/01/2006    |00000092017       ³±±
±±³      10  ³                          ³              |                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR825  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 09/01/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Horas Improdutivas / Produtivas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rodrigo Sart³03/11/98³XXXXXX³ Acerto p/ Bug Ano 2000                   ³±±
±±³Fernando J. ³31/03/99³XXXXXX³ Acerto na fun‡„o R825Calc para soma de   ³±±
±±³            ³        ³      ³ fra‡”es de Horas.                        ³±±
±±³CesarValadao³31/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³CesarValadao³25/05/99³21659A³Aumento do Tam. Total de Hrs Improdutivas ³±±
±±³Patricia Sal³18/04/00³003265³Imprimir Cod/Descr. da Ferramenta.        ³±±
±±³Iuspa       ³04/10/01³XXXXXX³Padronizacao para centesimal EM H6_TEMPO  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MATR825R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Relatorio de Horas Improdutivas / Produtivas"
LOCAL cDesc1   := STR0002	//"Relacao  de Horas Improdutivas / Produtivas apontadas, de acordo"
LOCAL cDesc2   := STR0003	//"com a ordem selecionada pelo usuario."
LOCAL cDesc3   := ""
LOCAL cString  := "SH6"
LOCAL aOrd     := {STR0004,STR0005,STR0006,STR0007,STR0008}	//"Por OP"###"Por Recurso"###"Por Motivo"###"Por Data"###"Por Operador"
LOCAL wnrel    := "MATR825"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn:= {STR0009,1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR826"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas - MTR826                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Lista Horas Improdutivas / Produtivas / Ambas³
//³ mv_par02     // De  OP										 ³
//³ mv_par03     // Ate OP										 ³
//³ mv_par04     // De  Recurso                                  ³
//³ mv_par05     // Ate Recurso                                  ³
//³ mv_par06     // De  Motivo                                   ³
//³ mv_par07     // Ate Motivo                                   ³
//³ mv_par08     // De  Data                                     ³
//³ mv_par09     // Ate Data                                     ³
//³ mv_par10     // De  Operador                                 ³
//³ mv_par11     // Ate Operador                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C825Imp(aOrd,@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C825IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 09/01/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR825  			                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C825Imp(aOrd,lEnd,WnRel,titulo,Tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL nTipo    := 0
LOCAL cRodaTxt := STR0011	//"REGISTRO(S)"
LOCAL nCntImpr := 0,i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na totalizacao do relatorio             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cTotProd:="0000:00",cTotImprod:="0000:00"
LOCAL cQuebra,cCampo,cMens
LOCAL cIndex
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na totalizacao dos motivos              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aMotivos:={},nProcura
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Condicao de Filtragem do SH6                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cCond := 'H6_FILIAL=="'+xFilial("SH6")+'".And.'
		cCond += 'H6_TIPO$"'+IIF(mv_par01==1,"I",IIF(mv_par01==2,"P","PI"))+'".And.'
		If mv_par01#2
			If mv_par12==1
				cCond += '( (H6_OP=" ") .Or. (H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'")) .And.'  
			Else
				cCond += ' H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'" .And.'  
			EndIf
		Else
			If mv_par12==1
				cCond += '( (H6_OP=" ") .Or. (H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'")).And.'
			Else
				cCond += 'H6_OP>="'+mv_par02+'".And.H6_OP<="'+mv_par03+'".And.'
			EndIf
		EndIf
		cCond += 'H6_RECURSO>="'+mv_par04+'".And.H6_RECURSO<="'+mv_par05+'".And.'
		cCond += 'H6_MOTIVO>="'+mv_par06+'".And.H6_MOTIVO<="'+mv_par07+'".And.'
		cCond += 'DTOS(H6_DTAPONT)>="'+DTOS(mv_par08)+'".And.DTOS(H6_DTAPONT)<="'+DTOS(mv_par09)+'"'	 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indice Condicional de acordo com a ordem selecionada.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[8] = 1
	cIndex:="H6_FILIAL+H6_OP+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_OP"
	cMens:=STR0012	//"da OP:"
ElseIf aReturn[8] = 2
	cIndex:="H6_FILIAL+H6_RECURSO+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_RECURSO"
	cMens:=STR0013	//"do Recurso:"
ElseIf aReturn[8] = 3
	cIndex:="H6_FILIAL+H6_MOTIVO+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_MOTIVO"
	cMens:=STR0014	//"do Motivo:"
ElseIf aReturn[8] = 4
	cIndex:="H6_FILIAL+DTOS(H6_DTAPONT)+H6_MOTIVO"
	cCampo:="H6_FILIAL+DTOS(H6_DTAPONT)"
	cMens:=STR0015	//"da Data:"
ElseIf aReturn[8] = 5
	cIndex:="H6_FILIAL+H6_OPERADO+DTOS(H6_DTAPONT)"
	cCampo:="H6_FILIAL+H6_OPERADO"
	cMens:=STR0016	//"do Operador:"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab("",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SH6")
IndRegua("SH6",cNomArq,cIndex,,cCond,STR0017)	//"Selecionando Registros..."
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis para controlar cursor de progressao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(LastRec())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo+=" "+aOrd[aReturn[8]]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := STR0018	//"TIPO ORDEM DE    NUMERO   RECURSO                                   FERRAMENTA                    MOTIVO                                 DATA        OPERADOR      DATA       DATA     HORA  HORA"
cabec2 := STR0019	//"     PRODUCAO    DE HORAS                                                                                                                APONTAMENTO               INICIO      FIM   INICIO   FIM"
//	   				   X    XXXXXXXXXXX  XXXXXX   XXXXXX  123456789012345678901234567890   123456 12345678901234567890   XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXX  XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX XXXXX  XXXXX
//      			   0         1         2         3         4         5         6         7         8         9        10        11        12        13
//      			   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012


Do While !Eof()
	If H6_OPERADO < mv_par10 .Or. H6_OPERADO > mv_par11
		IncRegua()
		dbSkip()
		Loop
	EndIf	
	cTotProd  :="0000:00"
	cTotImProd:="0000:00"
	cQuebra:=&(cCampo)
	Do While !Eof() .And. &(cCampo) == cQuebra
		If H6_OPERADO < mv_par10 .Or. H6_OPERADO > mv_par11
			IncRegua()
			dbSkip()
			Loop
		EndIf
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		IncRegua()
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+SH6->H6_RECURSO)		
		dbSelectArea("SH4")
		dbSeek(xFilial("SH4")+SH6->H6_FERRAM)                                        
       dbSelectArea("SH6")
		@ li,001 PSay H6_TIPO 			Picture PesqPict("SH6","H6_TIPO",1)
		@ li,005 PSay H6_OP   			Picture PesqPict("SH6","H6_OP",11)
		@ li,018 PSay TimeH6()			Picture PesqPict("SH6","H6_TEMPO",6)
		@ li,027 PSay H6_RECURSO			Picture PesqPict("SH6","H6_RECURSO",6)
		@ li,035 PSay Substr(SH1->H1_DESCRI,1,30)
		@ li,068 PSay H6_FERRAM
		@ li,075 PSay Substr(SH4->H4_DESCRI,1,20)
		@ li,098 PSay H6_MOTIVO			Picture PesqPict("SH6","H6_MOTIVO",2)
		dbSelectArea("SX5")
		dbSeek(xFilial("SX5")+"44"+SH6->H6_MOTIVO)
		@ li,101 PSay Substr(X5Descri(),1,35)
		dbSelectArea("SH6")
		@ li,137 PSay H6_DTAPONT		Picture PesqPict("SH6","H6_DTAPONT",8)
		@ li,149 PSay H6_OPERADO		Picture PesqPict("SH6","H6_OPERADO",10)
		@ li,160 PSay H6_DATAINI		Picture PesqPict("SH6","H6_DATAINI",8)
		@ li,171 PSay H6_DATAFIN		Picture PesqPict("SH6","H6_DATAFIN",8)
		@ li,182 PSay TimeH6(,"H6_HORAINI")		Picture PesqPict("SH6","H6_HORAINI",8)
		@ li,189 PSay TimeH6(,"H6_HORAFIN")		Picture PesqPict("SH6","H6_HORAFIN",8)
		If H6_TIPO == "I"
			nProcura:=ASCAN(aMotivos,{|x| x[1] == H6_MOTIVO})			
			If nProcura = 0
				AADD(aMotivos,{H6_MOTIVO,R825Calc("0000:00")})
			Else
				aMotivos[nProcura,2]:=R825Calc(aMotivos[nProcura,2])
			EndIf
			cTotImprod:=R825Calc(cTotImProd)
		Else
			cTotProd:=R825Calc(cTotProd)
		EndIf
		li++
		dbSkip()
	EndDo
	li++
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,00 PSay STR0020+cMens	//"Total "
	@ li,26 PSay STR0021+A680ConvHora(cTotProd, "C", GetMV("MV_TPHR"))	//"Horas Produtivas - "
	@ li,77 PSay STR0022+A680ConvHora(cTotImProd, "C", GetMV("MV_TPHR"))	//"Horas Improdutivas - "
	li++;li++
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime resumo por motivo em folha separada.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aMotivos) > 0
	cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	dbSelectArea("SX5")
	@ li,00 PSay STR0023;li++	//"Motivos que geraram horas improdutivas"
	@ li,00 PSay "----------------------------------------------";li++
	li++
	For i:=1 to Len(aMotivos)
		If dbSeek(xFilial("SX5")+"44"+aMotivos[i,1])
			@ li,00 PSay Substr(X5Descri(),1,35)
		EndIf
		@ li,36 PSay " - "+A680ConvHora(aMotivos[i,2], "C", GetMV("MV_TPHR"))	//"Horas Improdutivas - "
		li++
	Next i
EndIf
IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SH6")
Set Filter to

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq += OrdBagExt()
Delete File &(cNomArq)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R825Calc ³ Autor ³Rodrigo Sart¢rio       ³ Data ³ 30/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Soma as Horas Enviadas (cHoraOri) com as Horas do H6_TEMPO ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Iuspa       ³04/10/01³XXXXXX³ Alteracao no calculo usando H6_TEMPO     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R825Calc(cHoraOri)

Local nHor1      := Val(StrTran(cHoraOri,':','.'))
Local nHor2      := Val(StrTran(TimeH6("C"),':','.'))   // Uso H6_TEMPO que esta sempre no formato centesimal
Local cHoraDest  := '0000:00'
Local nTamHora	 := If(TamSX3("H6_TEMPO")[1]>7,TamSX3("H6_TEMPO")[1],7)

If !Empty(cHoraOri)
	cHoraDest := StrTran(StrZero(nHor1+nHor2, nTamHora, 2),'.',':')
EndIf

Return(cHoraDest)        

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1  ³ Autor ³ Michele Girardi      ³ Data ³ 02/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta Grupo de Perguntas e Help                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR825                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
Local aHlpP := {}
Local aHlpS := {}
Local aHlpE := {}     

/*---------------Parametro ---------------*/
Aadd( aHlpP, "Considerar as horas improdutivas que não" )
Aadd( aHlpP, "possuem ordem de produção relacionada?" ) 

PutSx1( "MTR826","12","Cons. horas improd sem OP?","","","mv_chc",;
		"N",1,0,1,"C","","","","","mv_par12","Sim","","","","Nao","","","","","","","","","","","",;
		aHlpP,aHlpE,aHlpS)
/*----------------------------------------*/			

Return Nil