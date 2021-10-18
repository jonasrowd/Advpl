//Bibliotecas
#Include 'Totvs.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} FFINR005
	Gera relatório de fluxo de caixa em excel para o financeiro Bomix
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 16/08/2021
/*/
User Function FFINR005()

	Local cCabec1        := ""
	Local aOrd 			 := {}
	Local nLin           := 80
	Local cDesc1         := "Este programa tem como objetivo exportar o relatório de FLUXO DE CAIXA"
	Local cDesc2         := "para o EXCEL de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "SERA GRAVADO NA PASTA c:\bomix\"
	Local cTitulo        := "Fluxo de Caixa - EXCEL
	Local cCabec2        := "Cliente/Fornecedor   Nat/CC                 Emissão   Num.        Pc       Venc Real  Vencimento        Receber          Pagar          Saldo      Usuario"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private cTxt         := ""
	Private cString   	 := ""
	Private cTamanho     := "M"
	Private nLastKey     := 0
	Private nCont        := 00
	Private nTipo        := 18
	Private nContfl      := 01
	Private nNpag        := 01
	Private nLimite      := 240
	Private nMpcc		 := 0.00
	Private cWnrel       := "FFINR005" // Nome do arquivo gerado pelo programa
	Private cPerg        := "FFINR005" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cNomeProg    := "FFINR005" // Coloque aqui o nome do programa para impressao no cabecalho
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}

	// Cria instância do objeto
	oSX1 := CreateSX1():New("FFINR005")
	// Adiciona novos itens da SX1
	oSX1:NewItem({01, "Cliente de?"		,	"MV_CH1", "C", 06, 00, "G", "SA1"})
	oSX1:NewItem({02, "Cliente até?"	,	"MV_CH2", "C", 06, 00, "G", "SA1"})
	oSX1:NewItem({03, "Fornecedor de?"	,	"MV_CH3", "C", 06, 00, "G", "SA2"})
	oSX1:NewItem({04, "Fornecedor até?"	,	"MV_CH4", "C", 06, 00, "G", "SA2"})
	oSX1:NewItem({05, "Emissão de?"		,	"MV_CH5", "D", 08, 00, "G", NIL})
	oSX1:NewItem({06, "Emissão até?"	,	"MV_CH6", "D", 08, 00, "G", NIL})
	oSX1:NewItem({07, "Vencimento de?"	,	"MV_CH7", "D", 08, 00, "G", NIL})
	oSX1:NewItem({08, "Vencimento até?"	,	"MV_CH8", "D", 08, 00, "G", NIL})
	oSX1:NewItem({09, "Saldo Inicial?"	,	"MV_CH9", "N", TamSX3("E1_VALOR")[1],TamSX3("E1_VALOR")[2], "G", Nil})

	oSX1:Commit()

	Pergunte(cPerg,.F.) //Mostra a janela de parâmetros

	cWnrel := SetPrint(cString,cNomeProg,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,cTamanho,,.T.)

	If nLastKey == 27
		Return
	EndIf

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	EndIf

	nTipo := If(aReturn[4]==1,15,18)
	cCabec1 := "Saldo inicial: " + Transform(MV_PAR09, "@E 999,999,999.99")

	RptStatus({|| RunReport(cCabec1,cCabec2,cTitulo,nLin) },cTitulo) //Monta janela com a regua de processamento.

Return Nil

/*/{Protheus.doc} RunReport
	Função auxiliar para ser utilizada pela RptStatus
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 15/09/2021
/*/
Static Function RunReport(cCabec1,cCabec2,cTitulo,nLin)

	Private cQry := f_Qry()

	TcQuery cQry New Alias QRY
	DbSelectArea("QRY")
	DbGoTop()
	If QRY->(EOF())
		Help(NIL, NIL, "NO_REGISTER", NIL, "Nenhum registro encontrado.",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os parâmetros informados."})
	EndIf
	QRY->(DbCloseArea())

Return Nil

/*/{Protheus.doc} f_Qry
	Gera a query utilizada no relatório
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 07/10/2021
	@return character, cQry
/*/
Static Function f_Qry()

	Local oFWMsExcel
	Local oExcel
	Local i			 := 0
	Local aArea      := GetArea()
	Local cArquivo   := "c:\bomix\"

	cQry := " SELECT * FROM " + CRLF
	cQry += " (SELECT SC7.C7_DESCRI, A2_NOME FORNECE, C7_CC AS NATUREZA, CTT_DESC01 AS ED_DESCRIC, C7_OBS OBS, '' NOTA, C7_NUM PEDIDO, C7_DESCRI AS DESC_PEDIDO,C7_FSDTPRE EMISSAO, '' VENC, " + CRLF
	cQry += " SUM(CASE WHEN C7_QUJE > 0 AND C7_QUJE < C7_QUANT AND C7_VALIPI > 0 THEN ((C7_QUANT-C7_QUJE)*(C7_PRECO))+((C7_QUANT-C7_QUJE) * C7_IPI/100) " + CRLF
	cQry += " WHEN C7_QUJE > 0 AND C7_QUJE < C7_QUANT AND C7_VALIPI = 0 THEN ((C7_QUANT-C7_QUJE)*(C7_PRECO)) ELSE (C7_TOTAL)+(C7_VALIPI) END) AS VALOR, C7_COND CONDICAO, 'Previstos' TIPO " + CRLF
	cQry += " FROM " + RetSqlName("SC7") + " SC7 (NOLOCK)" + CRLF
	cQry += " JOIN " + RetSqlName("SA2") + " SA2  (NOLOCK) ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND (A2_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') "
	cQry += " AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + xFilial("SA2") + "'" + CRLF
	cQry += " LEFT JOIN "+RetSqlName("CTT") +" CTT (NOLOCK) ON " + CRLF
	cQry += " C7_CC=CTT.CTT_CUSTO AND CTT.D_E_L_E_T_<>'*' AND CTT.CTT_FILIAL= '" + xFilial("CTT") + "'" + CRLF
	cQry += " WHERE C7_QUJE < C7_QUANT AND SC7.C7_RESIDUO <> 'S' AND (C7_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') AND SC7.D_E_L_E_T_<>'*' " + CRLF
	cQry += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + CRLF
	cQry += " GROUP BY C7_NUM, A2_NOME, C7_OBS, C7_FSDTPRE, C7_COND,  C7_CC, CTT_DESC01, SC7.C7_DESCRI, C7_QUJE, C7_QUANT " + CRLF

	cQry += " UNION ALL " + CRLF

	cQry += " SELECT '' AS C7_DESCRI,CASE WHEN E2_ORIGEM='MATA460' THEN A1_NOME ELSE A2_NOME END, E2_NATUREZ AS NATUREZA, SED.ED_DESCRIC, E2_HIST OBS, E2_NUM NOTA, '' PEDIDO, '' AS DESC_PEDIDO,
	cQry += " E2_EMISSAO EMISSAO, E2_VENCREA VENC, E2_SALDO VALOR, '', 'Pagar' TIPO " + CRLF
	cQry += " FROM " + RetSqlName("SE2") + " SE2 (NOLOCK) " + CRLF
	cQry += " LEFT JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK) ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL = '" + xFilial("SA2") + "'" + CRLF
	cQry += " LEFT JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_COD = E2_FORNECE AND A1_LOJA = E2_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + xFilial("SA1") + "'" + CRLF
	cQry += " INNER JOIN "+ RetSqlName("SED")+ " SED (NOLOCK) ON " + CRLF
	cQry += " SED.ED_CODIGO=SE2.E2_NATUREZ AND SED.D_E_L_E_T_ <>'*' AND SED.ED_FILIAL='" + xFilial("SED") + "'" + CRLF
	cQry += " WHERE E2_TIPO <> 'PA' AND E2_SALDO <> 0 AND SE2.D_E_L_E_T_<>'*' " + CRLF
	cQry += " AND E2_FILIAL = '" + xFilial("SE2") + "' " + CRLF
	cQry += " AND (E2_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "') " + CRLF
	cQry += " AND (E2_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + CRLF
	cQry += " AND (E2_VENCREA BETWEEN '" + Dtos(MV_PAR07) + "' AND '" + Dtos(MV_PAR08) + "') " + CRLF

	cQry += " UNION ALL " + CRLF

	cQry += " SELECT '' AS C7_DESCRI,A1_NOME, E1_NATUREZ AS NATUREZA, SED.ED_DESCRIC, E1_HIST OBS, E1_NUM NOTA, '' PEDIDO, '' AS DESC_PEDIDO, E1_EMISSAO EMISSAO, E1_VENCREA VENC, E1_SALDO VALOR, '',
	cQry += " 'Receber' TIPO " + CRLF
	cQry += " FROM " + RetSqlName("SE1") + " SE1 (NOLOCK) " + CRLF
	cQry += " JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_<>'*' AND A1_FILIAL = '" + xFilial("SA1") + "'" + CRLF
	cQry += " INNER JOIN "+ RetSqlName("SED") +" SED (NOLOCK) ON SED.ED_CODIGO=SE1.E1_NATUREZ AND SED.D_E_L_E_T_ <>'*' AND SED.ED_FILIAL = '" +xFilial("SED") + "'" + CRLF
	cQry += " WHERE E1_SALDO <> 0 AND SE1.D_E_L_E_T_<>'*' " + CRLF
	cQry += " AND E1_FILIAL = '" + xFilial("SE1") + "' " + CRLF
	cQry += " AND (E1_CLIENTE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') " + CRLF
	cQry += " AND (E1_EMISSAO BETWEEN '" + Dtos(MV_PAR05) + "' AND '" + Dtos(MV_PAR06) + "') " + CRLF
	cQry += " AND (E1_VENCREA BETWEEN '" + Dtos(DaySub(MV_PAR07, 1)) + "' AND '" + Dtos(MV_PAR08) + "')) TAB " + CRLF
	cQry += " ORDER BY EMISSAO"

	TcQuery cQry New Alias "QRYPRO"

	oFWMsExcel := FWMSExcel():New() //Criando o objeto que irá armazenar o conteúdo do Excel

	//Fluxo de Caixa
	oFWMsExcel:AddworkSheet("FLUXO")
	//Criando a Tabela
	oFWMsExcel:AddTable("FLUXO","FLUXO")
	oFWMsExcel:AddColumn("FLUXO","FLUXO","CLIENTE/FORNECEDOR",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","NATUREZA/CC",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","DESCRICAO",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","OBS",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","EMISSAO",1,4,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","NOTA",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","PEDIDO",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","DESCRICAO_PEDIDO",1,1,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","VENC REAL",1,4,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","VENC",1,4,.F.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","RECEBER",3,3,.T.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","PAGAR",3,3,.T.)
	oFWMsExcel:AddColumn("FLUXO","FLUXO","PREVISTOS",3,3,.T.)

	//Criando as Linhas... Enquanto não for fim da query
	oFWMsExcel:AddRow("FLUXO","FLUXO",{"S A L D O  I N I C I A L ","","","",STOD(QRYPRO->EMISSAO),"","","","",STOD(QRYPRO->VENC),mv_par09,0,0})

	While !QRYPRO->(EOF())
		oFWMsExcel:AddRow("FLUXO","FLUXO",{QRYPRO->FORNECE,;
			AllTrim(QRYPRO->NATUREZA),;
			AllTrim(QRYPRO->ED_DESCRIC),;
			AllTrim(QRYPRO->OBS),;
			STOD(QRYPRO->EMISSAO),;
			(QRYPRO->NOTA),;
			(QRYPRO->PEDIDO),;
			"",;
			IIF(AllTrim(QRYPRO->VENC)<>'',IIF(AllTrim(QRYPRO->TIPO) = "Receber",;
			(DataValida(DaySum(Stod(QRYPRO->VENC), 1), .T.)),;
			(DataValida(Stod(QRYPRO->VENC), .T.))),''),;
			STOD(QRYPRO->VENC),;
			IIF(AllTrim(QRYPRO->TIPO) = "Receber",(QRYPRO->VALOR),0),;
			IIF(AllTrim(QRYPRO->TIPO) = "Pagar",(QRYPRO->VALOR),0),;
			IIF(AllTrim(QRYPRO->TIPO) = "Previstos",(QRYPRO->VALOR),0)})
		QRYPRO->(DbSkip())
	End

	DbSelectArea("QRYPRO")
	DbGoTop()
	While !QRYPRO->(EOF())
		a_Parcelas2 := Condicao(QRYPRO->VALOR, QRYPRO->CONDICAO, 0, Stod(QRYPRO->EMISSAO))
		For i:=1 To Len(a_Parcelas)
			If (a_Parcelas2[i][1] >= MV_PAR07) .And. (a_Parcelas2[i][1] <= MV_PAR08)
				oFWMsExcel:AddRow("FLUXO","FLUXO",{QRYPRO->FORNECE,;
					AllTrim(QRYPRO->NATUREZA),;
					AllTrim(QRYPRO->ED_DESCRIC),;
					AllTrim((QRYPRO->OBS)),;
					STOD(QRYPRO->EMISSAO),;
					(QRYPRO->NOTA),;
					(QRYPRO->PEDIDO),;
					(QRYPRO->C7_DESCRI),;
					Stod(Dtos(DataValida(a_Parcelas2[i][1],.T.))),;
					Stod(Dtos(a_Parcelas2[i][1])),;
					0,;
					a_Parcelas2[i][2],;
					0})
			EndIf
		Next

		QRYPRO->(DbSkip())
	End

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo+cWnrel+".xml")
	oExcel := MsExcel():New()             			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo+cWnrel+".xml")	//Abre uma planilha
	oExcel:SetVisible(.T.)							//Visualiza a planilha
	oExcel:Destroy()								//Encerra o processo do gerenciador de tarefas

	QRYPRO->(DbCloseArea())
	RestArea(aArea)

Return cQry
