#INCLUDE "RWMAKE.CH"
#Include "PROTHEUS.CH"
#INCLUDE "Report.CH"
#INCLUDE "topconn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTFATR001  บAutor  ณ                    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Itens do Pedido de Venda					      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    A T U A L I Z A C O E S                            บฑฑ
ฑฑฬออออออออออัออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      |PROGRAMADOR       |ALTERACOES                               บฑฑ
ฑฑบ          |                  |                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TFATR001()
 	Local oReport

 	oReport := ReportDef()
	oReport:PrintDialog()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ                    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por montagem da estrutura do relatorio   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    A T U A L I Z A C O E S                            บฑฑ
ฑฑฬออออออออออัออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      |PROGRAMADOR       |ALTERACOES                               บฑฑ
ฑฑบ          |                  |                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(nRegImp)
	Local cTitulo  := OemToAnsi("Itens do Pedido de Venda")
	Local cDesc1   := "Itens do Pedido de Venda"
	Local cDesc2   := ""
	Local oSection1
	Local c_Perg  := "TFATR001"
 	Local aOrdem    := {}
	Local a_Tables  := {"SC6"}

	f_ValidPerg(c_Perg)

	Pergunte(c_Perg,.F.)

	oReport := TReport():New("TFATR001",cTitulo,c_Perg, {|oReport| f_GeraCarga(oReport)},cDesc1+" "+cDesc2)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oSection1 := TRSection():New(oReport,"Itens do Pedido de Venda",a_Tables,aOrdem)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"C5_NUM" 		,"TRB",,,,.F.,{|| TRB->C5_NUM})
	TRCell():New(oSection1,"c_Status"  		,"TRB","Status","@!",15,.F.,{|| c_Status})	
	TRCell():New(oSection1,"C5_EMISSAO"  	,"TRB",,,,.F.,{|| TRB->C5_EMISSAO})
	TRCell():New(oSection1,"C6_ENTREG"  	,"TRB",,,,.F.,{|| TRB->C6_ENTREG})
	TRCell():New(oSection1,"D4_OP"  		,"TRB",,,,.F.,{|| TRB->(C2_NUM + C2_ITEM + C2_SEQUEN)})
	TRCell():New(oSection1,"c_C6OP"  		,"TRB","Status do Item","@!",35,.F.,{|| c_C6OP})
	TRCell():New(oSection1,"C5_FECENT"  	,"TRB",,,,.F.,{|| TRB->C5_FECENT})
	TRCell():New(oSection1,"ZL_DESC"  		,"TRB","Grupo BMX",,,.F.,{|| TRB->ZL_DESC})
	TRCell():New(oSection1,"B1_GRUPO"  		,"TRB",,,,.F.,{|| TRB->B1_GRUPO})
	TRCell():New(oSection1,"BM_DESC"  		,"TRB",,,,.F.,{|| TRB->BM_DESC})
	TRCell():New(oSection1,"C6_PRODUTO"  	,"TRB",,,,.F.,{|| TRB->C6_PRODUTO})
	TRCell():New(oSection1,"B1_DESC"  		,"TRB",,,,.F.,{|| TRB->B1_DESC})	
	TRCell():New(oSection1,"c_Arte"  		,"TRB","Status da Arte","@!",25,.F.,{|| c_Arte})
	TRCell():New(oSection1,"B1_QB"  		,"TRB",,,,.F.,{|| TRB->B1_QB})
	TRCell():New(oSection1,"B1_PESO"  		,"TRB",,,,.F.,{|| TRB->B1_PESO})
	TRCell():New(oSection1,"A1_COD"  		,"TRB","Cliente",,,.F.,{|| TRB->A1_COD})
	TRCell():New(oSection1,"A1_NOME"  		,"TRB",,,,.F.,{|| TRB->A1_NOME})
	TRCell():New(oSection1,"A1_MUN"  		,"TRB",,,,.F.,{|| TRB->A1_MUN})
	TRCell():New(oSection1,"A1_EST"  		,"TRB",,,,.F.,{|| TRB->A1_EST})
	TRCell():New(oSection1,"C6_QTDVEN"  	,"TRB",,,,.F.,{|| TRB->C6_QTDVEN})
	TRCell():New(oSection1,"A3_GEREN"  		,"TRB",,,,.F.,{|| TRB->A3_GEREN})
	TRCell():New(oSection1,"c_Gerente" 		,"TRB","Nome","@!",TamSX3("A3_NOME")[1],.F.,{|| c_Gerente})
	TRCell():New(oSection1,"n_SaldoE2"  	,"TRB","Saldo Atual E2",X3Picture("B2_QATU"),TamSX3("B2_QATU")[1],.F.,{|| n_SaldoE2})
	TRCell():New(oSection1,"n_SaldoTP"  	,"TRB","Saldo Atual TP",X3Picture("B2_QATU"),TamSX3("B2_QATU")[1],.F.,{|| n_SaldoTP})
	TRCell():New(oSection1,"n_SaldoTE"  	,"TRB","Saldo Atual TE",X3Picture("B2_QATU"),TamSX3("B2_QATU")[1],.F.,{|| n_SaldoTE})
	TRCell():New(oSection1,"n_SaldoTR"  	,"TRB","Saldo Atual TR",X3Picture("B2_QATU"),TamSX3("B2_QATU")[1],.F.,{|| n_SaldoTR})
Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_GeraCargบAutor  ณ                    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por gerar carga no arquivo de trabalho   บฑฑ
ฑฑบ          ณque sera impresso posteriormente                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    A T U A L I Z A C O E S                            บฑฑ
ฑฑฬออออออออออัออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      |PROGRAMADOR       |ALTERACOES                               บฑฑ
ฑฑบ          |                  |                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_GeraCarga(oReport)
	Local oSection1 := oReport:Section(1)

	f_SelectDados(oReport)

	dbSelectArea("TRB")
	IF MV_PAR13 == 1
		SET FILTER TO (EMPTY(TRB->C5_LIBEROK) .AND. EMPTY(TRB->C5_NOTA))
	ELSEIF MV_PAR13 == 2
		SET FILTER TO (!EMPTY(TRB->C5_LIBEROK) .AND. EMPTY(TRB->C5_NOTA))
	ELSEIF MV_PAR13 == 3
		SET FILTER TO (EMPTY(TRB->C5_NOTA))
	ELSEIF MV_PAR13 == 4
		SET FILTER TO (TRB->C5_LIBEROK == "E" .OR. !EMPTY(TRB->C5_NOTA))
	ENDIF

	TRB->(DBGOTOP())
	oSection1:Init()
	While TRB->(!EOF()) .AND. !oReport:Cancel()
		c_Gerente := Posicione("SA3", 1, XFILIAL("SA3") + TRB->A3_GEREN, "A3_NOME")
		n_SaldoE2 := 0
		n_SaldoTP := 0
		n_SaldoTE := 0
		n_SaldoTR := 0
		c_Status  := ""
		c_C6OP    := ""
		c_Arte    := ""

		If TRB->Z2_BLOQ == "1"
			c_Arte := "Arte Nova"
		Elseif TRB->Z2_BLOQ == "2
			c_Arte := "Bloqueada"
		Elseif TRB->Z2_BLOQ == "3"
			c_Arte := "Fotolito a Desenvolver"
		Elseif TRB->Z2_BLOQ == "4"
			c_Arte := "Pronta para Impressใo"
		Endif

		If Empty(TRB->C5_LIBEROK) .And. Empty(TRB->C5_NOTA)
			c_Status := "Pedido em Aberto"
		Elseif !Empty(TRB->C5_NOTA) .Or. TRB->C5_LIBEROK=='E'
		 	c_Status := "Pedido Encerrado"
		Elseif !Empty(TRB->C5_LIBEROK).And.Empty(TRB->C5_NOTA)
		 	c_Status := "Pedido Liberado"
		Endif
		
		If TRB->C6_OP == "01"
			c_C6OP := "OP Gerada"
		Elseif TRB->C6_OP == "05"
			c_C6OP := "OP nใo gerada, pois hแ quantidade em Estoque"
		Endif

		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2") + TRB->C6_PRODUTO + "E2"))
//			n_SaldoE2 := SaldoSB2(.T., , ,.F.,.F.)
			n_SaldoE2 := SB2->B2_QATU
		Endif
		
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2") + TRB->C6_PRODUTO + "TP"))
//			n_SaldoTP := SaldoSB2(.T., , ,.F.,.F.)
			n_SaldoTP := SB2->B2_QATU
		Endif
		
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2") + TRB->C6_PRODUTO + "TE"))
//			n_SaldoTE := SaldoSB2(.T., , ,.F.,.F.)
			n_SaldoTE := SB2->B2_QATU
		Endif
		
		dbSelectArea("SB2")
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2") + TRB->C6_PRODUTO + "TR"))
//			n_SaldoTR := SaldoSB2(.T., , ,.F.,.F.)
			n_SaldoTR := SB2->B2_QATU
		Endif						

		oSection1:PrintLine()
		oReport:IncMeter()
	  	TRB->(DBSKIP())

		If oReport:Cancel()
			Exit
		EndIf
	ENDDO

	oSection1:Finish()
	TRB->(DBCLOSEAREA())
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_SelectDaบAutor  ณ                    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por selecionar os dados a serem impresso บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    A T U A L I Z A C O E S                            บฑฑ
ฑฑฬออออออออออัออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      |PROGRAMADOR       |ALTERACOES                               บฑฑ
ฑฑบ          |                  |                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_SelectDados(oReport)
	Local c_Query := ""

	MakeSqlExpr(oReport:uParam)
	oReport:Section(1):BeginQuery()

	BeginSql Alias "TRB"
		SELECT C5_NUM, C5_EMISSAO, C5_FECENT, C6_PRODUTO, C6_ENTREG, C6_QTDVEN, B1_GRUPO, B1_DESC, BM_DESC, A1_COD, A1_LOJA, A1_NOME, A1_MUN, A1_EST, C5_NOTA, C5_LIBEROK, C6_OP, C6_PVCOMOP
		A3_COD, CASE WHEN A3_GEREN = '' THEN A3_COD ELSE A3_GEREN END A3_GEREN, A3_NOME, C2_NUM, C2_ITEM, C2_SEQUEN, ZL_DESC, B1_QB, B1_PESO, Z2_BLOQ
		FROM %TABLE:SC5% SC5
		INNER JOIN %TABLE:SC6% SC6 ON (C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.%NOTDEL%)
		INNER JOIN %TABLE:SB1% SB1 ON (B1_FILIAL = %EXP:XFILIAL("SB1")% AND C6_PRODUTO = B1_COD AND SB1.%NOTDEL%)
		INNER JOIN %TABLE:SBM% SBM ON (BM_FILIAL = %EXP:XFILIAL("SBM")% AND B1_GRUPO = BM_GRUPO AND SBM.%NOTDEL%)
		INNER JOIN %TABLE:SA1% SA1 ON (A1_FILIAL = %EXP:XFILIAL("SA1")% AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.%NOTDEL%)
		LEFT JOIN %TABLE:SA3%  SA3 ON (A3_FILIAL = %EXP:XFILIAL("SA3")% AND A3_COD = C5_VEND1 AND SA3.%NOTDEL%)
		LEFT JOIN %TABLE:SC2%  SC2 ON (C2_FILIAL = %EXP:XFILIAL("SC2")% AND C2_PEDIDO = C6_NUM AND C2_ITEMPV = C6_ITEM AND C2_PRODUTO = C6_PRODUTO AND SC2.%NOTDEL%)
		LEFT JOIN %TABLE:SZL%  SZL ON (ZL_FILIAL = %EXP:XFILIAL("SZL")% AND BM_GRUPOFK = ZL_ID AND SZL.%NOTDEL%)
		LEFT JOIN %TABLE:SZ2%  SZ2 ON (Z2_FILIAL = %EXP:XFILIAL("SZ2")% AND Z2_COD = B1_FSARTE AND SZ2.%NOTDEL%)
		WHERE SC5.%NOTDEL% AND C5_FILIAL = %EXP:XFILIAL("SC5")% 
		AND C5_NUM BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
		AND C6_PRODUTO BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
		AND C5_CLIENTE BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
		AND C5_FECENT BETWEEN  %EXP:DTOS(MV_PAR07)% AND %EXP:DTOS(MV_PAR08)% 
		AND C5_EMISSAO BETWEEN %EXP:DTOS(MV_PAR09)% AND %EXP:DTOS(MV_PAR10)%
		AND C6_ENTREG BETWEEN  %EXP:DTOS(MV_PAR11)% AND %EXP:DTOS(MV_PAR12)%
		ORDER BY C5_NUM, C6_ITEM
	EndSql

	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_ValidPerบAutor  ณ                    บ Data ณFEVEREIRO/11 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao resposnvel pela criacao do dicionario de perguntas X1บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    A T U A L I Z A C O E S                            บฑฑ
ฑฑฬออออออออออัออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      |PROGRAMADOR       |ALTERACOES                               บฑฑ
ฑฑบ          |                  |                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_ValidPerg(c_Perg)
	Local a_MV_PAR01 := {}
	Local a_MV_PAR02 := {}
	Local a_MV_PAR03 := {}
	Local a_MV_PAR04 := {}
	Local a_MV_PAR05 := {}
	Local a_MV_PAR06 := {}
	Local a_MV_PAR07 := {}
	Local a_MV_PAR08 := {}
	Local a_MV_PAR09 := {}
	Local a_MV_PAR10 := {}
	Local a_MV_PAR11 := {}
	Local a_MV_PAR12 := {}	
	Local a_MV_PAR13 := {}	

	Aadd(a_MV_PAR01, "Informe o Pedido inicial")
	Aadd(a_MV_PAR02, "Informe o Pedido final")
	Aadd(a_MV_PAR03, "Informe o Produto inicial")
	Aadd(a_MV_PAR04, "Informe o Produto final")
	Aadd(a_MV_PAR05, "Informe o Cliente inicial")
	Aadd(a_MV_PAR06, "Informe o Cliente final")
	Aadd(a_MV_PAR07, "Informe a Data PCP inicial")
	Aadd(a_MV_PAR08, "Informe o Data PCP final")
	Aadd(a_MV_PAR09, "Informe a Data de Emissใo inicial")
	Aadd(a_MV_PAR10, "Informe a Data de Emissใo final")
	Aadd(a_MV_PAR11, "Informe a Data de Entrega inicial")
	Aadd(a_MV_PAR12, "Informe a Data de Entrega final")
	Aadd(a_MV_PAR13, "Informe o Status do Pedido")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Pedido Venda de?      ","","","mv_ch1","C",06,0,0,"G","","SC5","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
	PutSx1(c_Perg,"02","Pedido Venda ate?     ","","","mv_ch2","C",06,0,0,"G","","SC5","","","mv_par02","","","","","","","","","","","","","","","","",a_MV_PAR02)
	PutSx1(c_Perg,"03","Produto de?           ","","","mv_ch3","C",TamSX3("B1_COD")[1],0,0,"G","","SB1","",""   ,"MV_PAR03","","","","","","","","","","","","","","","","",a_MV_PAR03)
	PutSx1(c_Perg,"04","Produto ate?          ","","","mv_ch4","C",TamSX3("B1_COD")[1],0,0,"G","","SB1" ,"","","mv_par04","","","","","","","","","","","","","","","","",a_MV_PAR04)
	PutSx1(c_Perg,"05","Cliente de?           ","","","mv_ch5","C",06,0,0,"G","","SA1" ,"","","mv_par05","","","","","","","","","","","","","","","","",a_MV_PAR05)
	PutSx1(c_Perg,"06","Cliente ate?          ","","","mv_ch6","C",06,0,0,"G","","SA1" ,"","","mv_par06","","","","","","","","","","","","","","","","",a_MV_PAR06)
	PutSx1(c_Perg,"07","Data PCP de?          ","","","mv_ch7","D",08,0,0,"G","","" ,"","","mv_par07","","","","","","","","","","","","","","","","",a_MV_PAR07)
	PutSx1(c_Perg,"08","Data PCP ate?         ","","","mv_ch8","D",08,0,0,"G","","" ,"","","mv_par08","","","","","","","","","","","","","","","","",a_MV_PAR08)
	PutSx1(c_Perg,"09","Data Emissao de?      ","","","mv_ch9","D",08,0,0,"G","","" ,"","","mv_par09","","","","","","","","","","","","","","","","",a_MV_PAR09)
	PutSx1(c_Perg,"10","Data Emissao ate?     ","","","mv_cha","D",08,0,0,"G","","" ,"","","mv_par10","","","","","","","","","","","","","","","","",a_MV_PAR10)
	PutSx1(c_Perg,"11","Data Entrega de?      ","","","mv_chb","D",08,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",a_MV_PAR11)
	PutSx1(c_Perg,"12","Data Entrega ate?     ","","","mv_chc","D",08,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",a_MV_PAR12)
	PutSx1(c_Perg,"13","Pedido?               ","","","mv_chd","N",01,0,0,"C","","","","","mv_par13","Aberto","","","","Liberado","","","Aberto+Liberado","","","Encerrado","","","Todos","","",a_MV_PAR13)
Return