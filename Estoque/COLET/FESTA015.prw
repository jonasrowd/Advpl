#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFESTA015  บ Autor ณ AP6 IDE            บ Data ณ  05/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FESTA015


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCores := {}

Private cCadastro := "Inventario"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ณ
//ณ que apareceram disponiveis para o usuario. Segue o padrao:          ณ
//ณ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ณ
//ณ              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ณ
//ณ              . . .                                                  ณ
//ณ              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ณ
//ณ Onde: <DESCRICAO> - Descricao da opcao do menu                      ณ
//ณ       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ณ
//ณ                     duplas e pode ser uma das funcoes pre-definidas ณ
//ณ                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ณ
//ณ                     e AXDELETA) ou a chamada de um EXECBLOCK.       ณ
//ณ                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-ณ
//ณ                     clarar uma variavel chamada CDELFUNC contendo   ณ
//ณ                     uma expressao logica que define se o usuario po-ณ
//ณ                     dera ou nao excluir o registro, por exemplo:    ณ
//ณ                     cDelFunc := 'ExecBlock("TESTE")'  ou            ณ
//ณ                     cDelFunc := ".T."                               ณ
//ณ                     Note que ao se utilizar chamada de EXECBLOCKs,  ณ
//ณ                     as aspas simples devem estar SEMPRE por fora da ณ
//ณ                     sintaxe.                                        ณ
//ณ       <TIPO>      - Identifica o tipo de rotina que sera executada. ณ
//ณ                     Por exemplo, 1 identifica que sera uma rotina deณ
//ณ                     pesquisa, portando alteracoes nao podem ser efe-ณ
//ณ                     tuadas. 3 indica que a rotina e de inclusao, porณ
//ณ                     tanto, a rotina sera chamada continuamente ao   ณ
//ณ                     final do processamento, ate o pressionamento de ณ
//ณ                     <ESC>. Geralmente ao se usar uma chamada de     ณ
//ณ                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ณ
//ณ MBROWSE sera identica a da AXCADASTRO:                              ณ
//ณ                                                                     ณ
//ณ cDelFunc  := ".T."                                                  ณ
//ณ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ณ
//ณ                { "Visualizar"   ,"AxVisual" , 0, 2},;               ณ
//ณ                { "Incluir"      ,"AxInclui" , 0, 3},;               ณ
//ณ                { "Alterar"      ,"AxAltera" , 0, 4},;               ณ
//ณ                { "Excluir"      ,"AxDeleta" , 0, 5} }               ณ
//ณ                                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Automแtico","U_fAuto",0,4} ,;
             {"Excluir","AxDeleta",0,5} ,;
             {"Inventario","U_fInvent",0,6},;
             {"Legenda" ,"U_fLegenda" ,0,7} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private c_Doc    := ""
Private cString  := "SZX"

AADD(aCores,{"ZX_STATUS == 'C'" ,"BR_VERDE" })
AADD(aCores,{"ZX_STATUS == 'I'" ,"BR_VERMELHO" })

dbSelectArea("SZX")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a funcao MBROWSE. Sintaxe:                                  ณ
//ณ                                                                     ณ
//ณ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ณ
//ณ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ณ
//ณ                        exibido. Para seguir o padrao da AXCADASTRO  ณ
//ณ                        use sempre 6,1,22,75 (o que nao impede de    ณ
//ณ                        criar o browse no lugar desejado da tela).   ณ
//ณ                        Obs.: Na versao Windows, o browse sera exibi-ณ
//ณ                        do sempre na janela ativa. Caso nenhuma este-ณ
//ณ                        ja ativa no momento, o browse sera exibido naณ
//ณ                        janela do proprio SIGAADV.                   ณ
//ณ Alias                - Alias do arquivo a ser "Browseado".          ณ
//ณ aCampos              - Array multidimensional com os campos a serem ณ
//ณ                        exibidos no browse. Se nao informado, os cam-ณ
//ณ                        pos serao obtidos do dicionario de dados.    ณ
//ณ                        E util para o uso com arquivos de trabalho.  ณ
//ณ                        Segue o padrao:                              ณ
//ณ                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     . . .                           ณ
//ณ                                     {<CAMPO>,<DESCRICAO>} }         ณ
//ณ                        Como por exemplo:                            ณ
//ณ                        aCampos := { {"TRB_DATA","Data  "},;         ณ
//ณ                                     {"TRB_COD" ,"Codigo"} }         ณ
//ณ cCampo               - Nome de um campo (entre aspas) que sera usadoณ
//ณ                        como "flag". Se o campo estiver vazio, o re- ณ
//ณ                        gistro ficara de uma cor no browse, senao fi-ณ
//ณ                        cara de outra cor.                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return



User Function fLegenda
	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"    ,"Em Aberto" })
	AADD(aLegenda,{"BR_VERMELHO" ,"Inventariado" })

	BrwLegenda(cCadastro, "", aLegenda)
Return



User Function fInvent(cAlias, nReg, nOpc)
	Local a_Area  	 := GetArea()
	Local n_Cont1 	 := 0
	Local n_Cont2 	 := 0
	Local n_Cont3 	 := 0
	Local l_Cont3 	 := .F.
	Local l_Ok    	 := .T.
	Local c_Filial   := SZX->ZX_FILIAL
	Local c_Produto  := SZX->ZX_PRODUTO
	Local c_Local    := SZX->ZX_LOCAL
	Local c_Lote     := SZX->ZX_LOTECTL
	Local d_DtValid  := SZX->ZX_DTVALID
	Local c_Endereco := SZX->ZX_END
	Local c_Perg     := "FESTA015"
	Local n_Quant    := 0
	Local c_Obs      := ""
	Local a_Endereco := {}

	If SZX->ZX_STATUS == "C"
	    dbSelectArea("SZX")
	    dbSetOrder(1)
	    dbGoTop()
	    dbSeek(c_Filial + c_Produto + c_Local + c_Lote)
		While SZX->(!EoF()) .And. (SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL) == c_Filial + c_Produto + c_Local + c_Lote)
			c_Endereco := SZX->ZX_END
			n_Cont1 := 0
			n_Cont2 := 0
			n_Cont3 := 0
			l_Cont3 := .F.

			While SZX->(!EoF()) .And. SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL + ZX_END) == c_Filial + c_Produto + c_Local + c_Lote + c_Endereco
				If SZX->ZX_CONT == "1"
					n_Cont1 += SZX->ZX_QUANT
				ElseIf SZX->ZX_CONT == "2"
					n_Cont2 += SZX->ZX_QUANT
				ElseIf SZX->ZX_CONT == "3"
					l_Cont3 := .T.
					n_Cont3 += SZX->ZX_QUANT
				Endif
		
				SZX->(dbSkip())
			End

			If n_Cont1 == n_Cont2
				n_Cont3 += n_Cont1
			Else
				If l_Cont3 == .F.
					l_Ok := .F.
					AADD(a_Endereco, c_Endereco)
				Endif
			Endif

			n_Quant += n_Cont3
		End

		If l_Ok
			If f_Mata270(c_Produto, c_Local, c_Lote, d_DtValid, n_Quant, c_Perg)
			    dbSelectArea("SZX")
			    dbSetOrder(1)
			    dbGoTop()
			    dbSeek(c_Filial + c_Produto + c_Local + c_Lote)
				While SZX->(!EoF()) .And. SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL) == c_Filial + c_Produto + c_Local + c_Lote
					RecLock("SZX", .F.)
					SZX->ZX_STATUS := "I"
					MsUnlock()
	
					SZX->(dbSkip())
				End
	
				Aviso(SM0->M0_NOMECOM,"Inventแrio " + AllTrim(c_Doc) + " gerado com sucesso",{"OK"},2,"Aten็ใo")
			Endif
		Else
			c_Obs := "O inventแrio deste item nใo pode ser gerado, pois hแ diverg๊ncias entre a primeira e a segunda contagem " + IIF(Len(a_Endereco) > 1, "nos endere็os ", "no endere็o ")
			For j:=1 To Len(a_Endereco)
				c_Obs += ALLTRIM(a_Endereco[j]) + IIF(j < Len(a_Endereco), ", ", "")
			Next
			c_Obs += " e nใo hแ registro da terceira contagem no sistema"

			ShowHelpDlg(SM0->M0_NOME, {c_Obs}, 5, {"Efetue a terceira contagem deste item antes de prosseguir"},5)
		Endif
	Else
		ShowHelpDlg(SM0->M0_NOME, {"Este registro jแ foi inventariado"}, 5, {"Somente registros em aberto podem ser inventariados"},5)
	Endif

	RestArea(a_Area)
Return



User Function fAuto
	Local a_Area := GetArea()
	Local c_Perg := "FESTA0151"

	CriaPerg(c_Perg)

	If Pergunte(c_Perg, .T.) == .T.
    	Processa({|| fGeraSB7()}, "Aguarde...", "Gerando os registros do inventแrio...",.F.)
	Else
		Aviso(SM0->M0_NOMECOM,"Inventแrio automแtico cancelado pelo usuแrio",{"OK"},2,"Aten็ใo")
	Endif

	RestArea(a_Area)
Return



Static Function fGeraSB7
	Local c_Perg 	 := "FESTA0151"
	Local c_Produto  := ""
    Local c_Desc     := ""
	Local c_Local    := ""
	Local c_Lote     := ""
	Local c_DtValid  := ""
	Local n_Quant    := 0
	Local n_Cont0    := -1
	Local n_Cont1    := 0
	Local n_Cont2    := 0
	Local n_Cont3    := 0
	Local l_Cont3    := .F.
	Local l_Ok       := .F.
	Local a_Bord     := {}
	Local c_Obs      := ""
	Local n_Pos      := 1
	Local n_QtdInc   := 0
	Local n_QtdErr   := 0
	Local a_Recno    := {}

	Private a_Bord   := {}   //Array da tabela temporแria
	Private a_Campos := {}   //Campos da tabela temporแria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	c_Doc := MV_PAR01

	Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
	Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1],0})
	Aadd(a_Bord,{"TB_DESC"    ,"C",TamSX3("B1_DESC")[1],0})
	Aadd(a_Bord,{"TB_LOCAL"   ,"C",TamSX3("B2_LOCAL")[1],0})
	Aadd(a_Bord,{"TB_LOTECTL" ,"C",TamSX3("B8_LOTECTL")[1],0})
	Aadd(a_Bord,{"TB_DTVALID" ,"D",TamSX3("B8_DTVALID")[1],0})
	Aadd(a_Bord,{"TB_QUANT1"  ,"N",12,2})
	Aadd(a_Bord,{"TB_QUANT2"  ,"N",12,2})
	Aadd(a_Bord,{"TB_QUANT3"  ,"N",12,2})
	Aadd(a_Bord,{"TB_QUANT"   ,"N",12,2})
	Aadd(a_Bord,{"TB_OBS"     ,"C",200,0})

	c_Bord := CriaTrab(a_Bord,.t.)
	Use &c_Bord Shared Alias TRC New
	Index On TB_POS To &c_Bord

	SET INDEX TO &c_Bord

	c_Qry := " SELECT ZX_PRODUTO PRODUTO, B1_DESC DESCRI, ZX_LOCAL ARM, ZX_LOTECTL LOTE, ZX_DTVALID DTVALID, ZX_END ENDERECO, ZX_CONT CONT, ZX_SEQ SEQ, ZX_QUANT QUANT, SZX.R_E_C_N_O_ RECNO FROM " + RetSqlName("SZX") + " SZX "
	c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD=ZX_PRODUTO "		
	c_Qry += " WHERE SZX.D_E_L_E_T_<>'*' AND ZX_STATUS = 'C' AND ZX_FILIAL = '" + XFILIAL("SZX") + "' AND "
	c_Qry += " ZX_PRODUTO BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' AND "
	c_Qry += " ZX_LOCAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND "
	c_Qry += " ZX_LOTECTL BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' AND "
	c_Qry += " ZX_END BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' AND "
	c_Qry += " ZX_DATA BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' "
	IF MV_PAR12 == 1
		c_Qry += " UNION "
		c_Qry += " SELECT B8_PRODUTO PRODUTO, B1_DESC DESCRI, B8_LOCAL ARM, B8_LOTECTL LOTE, B8_DTVALID DTVALID, '' ENDERECO, '0' CONT, '01' SEQ, 0 QUANT, 0 RECNO FROM " + RetSqlName("SB8") + " SB8 "
		c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD=B8_PRODUTO AND B1_RASTRO='L' AND B1_MSBLQL<>'1' "
		c_Qry += " WHERE SB8.D_E_L_E_T_<>'*' AND B8_FILIAL = '" + XFILIAL("SB8") + "' AND "
		c_Qry += " B8_SALDO > 0 AND B8_PRODUTO BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' AND "
		c_Qry += " B8_LOCAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND "
		c_Qry += " B8_DTVALID > '" + DTOS(DDATABASE) + "' AND "
		c_Qry += " B8_PRODUTO+B8_LOCAL+B8_LOTECTL NOT IN (SELECT ZX_PRODUTO+ZX_LOCAL+ZX_LOTECTL FROM " + RetSqlName("SZX") + " WHERE D_E_L_E_T_<>'*' AND ZX_STATUS = 'C' AND ZX_FILIAL = '" + XFILIAL("SZX") + "' AND "
		c_Qry += " ZX_DATA BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "') "
		c_Qry += " UNION "
		c_Qry += " SELECT B2_COD PRODUTO, B1_DESC DESCRI, B2_LOCAL ARM, '' LOTE, '' DTVALID, '' ENDERECO, '0' CONT, '01' SEQ, 0 QUANT, 0 RECNO FROM " + RetSqlName("SB2") + " SB2 "
		c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD=B2_COD AND B1_RASTRO<>'L' AND B1_MSBLQL<>'1' "
		c_Qry += " WHERE SB2.D_E_L_E_T_<>'*' AND B2_FILIAL = '" + XFILIAL("SB2") + "' AND "
		c_Qry += " B2_QATU > 0 AND B2_COD BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' AND "
		c_Qry += " B2_LOCAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND "
		c_Qry += " B2_COD+B2_LOCAL NOT IN (SELECT ZX_PRODUTO+ZX_LOCAL FROM " + RetSqlName("SZX") + " WHERE D_E_L_E_T_<>'*' AND ZX_STATUS = 'C' AND ZX_FILIAL = '" + XFILIAL("SZX") + "' AND "
		c_Qry += " ZX_DATA BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "') "
	ENDIF
	c_Qry += " ORDER BY 1, 2, 3, 4, 6 "
		
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()
	If EoF()
		Aviso(SM0->M0_NOMECOM,"Nenhum registro encontrado",{"OK"},2,"Aten็ใo")
	Else
		Count To n_Reg
		ProcRegua(n_Reg)		

		dbGoTop()
		While QRY->(!EoF())
			c_Produto  := QRY->PRODUTO
			c_Desc     := QRY->DESCRI
			c_Local    := QRY->ARM
			c_Lote     := QRY->LOTE
			c_DtValid  := QRY->DTVALID
			n_Cont0    := -1
			n_Cont1    := 0
			n_Cont2    := 0
			n_Cont3    := 0
			n_Quant    := 0
			a_Recno    := {}
			a_Endereco := {}
			l_Ok       := .T.

			While QRY->(!EoF()) .AND. (QRY->(PRODUTO + ARM + LOTE) == c_Produto + c_Local + c_Lote)
				c_Endereco := QRY->ENDERECO
				l_Cont3    := .F.
				n_Cont1End := 0
				n_Cont2End := 0
				n_Cont3End := 0

				While QRY->(!EoF()) .AND. QRY->(PRODUTO + ARM + LOTE + ENDERECO) == c_Produto + c_Local + c_Lote + c_Endereco
					If QRY->CONT == "0"
						n_Cont0 := QRY->QUANT
					ElseIf QRY->CONT == "1"
						n_Cont1End += QRY->QUANT
					ElseIf QRY->CONT == "2"
						n_Cont2End += QRY->QUANT
					ElseIf QRY->CONT == "3"
						l_Cont3 := .T.
						n_Cont3End += QRY->QUANT
					Endif

					If QRY->CONT <> "0"
						AADD(a_Recno, QRY->RECNO)
					Endif

					QRY->(dbSkip())
					IncProc()
				End

				If n_Cont1End == n_Cont2End
					If n_Cont0 <> -1
						n_Cont3End += n_Cont0
					Else
						n_Cont3End += n_Cont1End
					Endif
				Else
					If l_Cont3 == .F.
						l_Ok := .F.
						AADD(a_Endereco, c_Endereco)
					Endif
				Endif

				n_Cont1 += n_Cont1End
				n_Cont2 += n_Cont2End
				n_Cont3 += n_Cont3End
			End

			If l_Ok
				n_Quant := n_Cont3

				If f_Mata270(c_Produto, c_Local, c_Lote, Stod(c_DtValid), n_Quant, c_Perg)
					For j:=1 To Len(a_Recno)
					    dbSelectArea("SZX")
					    dbGoTo(a_Recno[j])
						RecLock("SZX", .F.)
						SZX->ZX_STATUS := "I"
						MsUnlock()
					Next

					c_Obs := "O inventแrio deste item foi gerado com sucesso"
					n_QtdInc++
				Else
					c_Obs := "Erro durante a gera็ใo d inventแrio deste item"
					n_QtdErr++
				Endif
			Else
				n_Quant := 0

				c_Obs := "O inventแrio deste item nใo pode ser gerado, pois hแ diverg๊ncias entre a primeira e a segunda contagem " + IIF(Len(a_Endereco) > 1, "nos endere็os ", "no endere็o ")
				For j:=1 To Len(a_Endereco)
					c_Obs += ALLTRIM(a_Endereco[j]) + IIF(j < Len(a_Endereco), ", ", "")
				Next
				c_Obs += " e nใo hแ registro da terceira contagem no sistema"
				n_QtdErr++
			Endif

			RECLOCK("TRC",.T.)
			TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
			TRC->TB_PRODUTO	:= c_Produto
			TRC->TB_DESC    := c_Desc
			TRC->TB_LOCAL   := c_Local
			TRC->TB_LOTECTL := c_Lote
			TRC->TB_DTVALID := Stod(c_DtValid)
			TRC->TB_QUANT1  := n_Cont1
			TRC->TB_QUANT2  := n_Cont2
			TRC->TB_QUANT3  := n_Cont3
			TRC->TB_QUANT   := n_Quant
			TRC->TB_OBS     := c_Obs
			MSUNLOCK()			

			n_Pos++
		End

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'      	,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  	,'@!'})
		Aadd(a_Campos,{"TB_DESC"    ,,'Descri็ใo'  	,'@!'})
		Aadd(a_Campos,{"TB_LOCAL"   ,,'Armazem'  	,'@!'})
		Aadd(a_Campos,{"TB_LOTECTL" ,,'Lote'   		,'@!'})
		Aadd(a_Campos,{"TB_DTVALID" ,,'Data de Validade'	,'@!'})
		Aadd(a_Campos,{"TB_QUANT1"  ,,'Primeira Contagem' 	,'@E 999,999,999.99'})
		Aadd(a_Campos,{"TB_QUANT2"  ,,'Segunda Contagem' 	,'@E 999,999,999.99'})
		Aadd(a_Campos,{"TB_QUANT3"  ,,'Terceira Contagem' 	,'@E 999,999,999.99'})
		Aadd(a_Campos,{"TB_QUANT"   ,,'Quantidade Final' 	,'@E 999,999,999.99'})
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa็ใo' 	,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Inventแrio Automแtico",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdErr)) + "		Total de Inventariados: "+ ALLTRIM(STR(n_QtdInc)) + "		Total de Erros: "+ ALLTRIM(STR(n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,580,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Salvar" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
		o_Btn:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

		o_Dlg:Activate(,,,.T.)
	
		DBSELECTAREA("TRC")
		TRC->(DBCLOSEAREA())
	End If

	QRY->(dbCloseArea())
Return



Static Function f_Mata270(c_Produto, c_Local, c_Lote, d_DtValid, n_Quant, c_Perg)
	Local aVetor        := {}
	Local lRet          := .F.
	Local l_SB7         := .F.
	Private lMsErroAuto := .F.
	
	If c_Perg == "FESTA015"
		CriaPerg(c_Perg)
		
		If Pergunte(c_Perg, .T.) == .T.
			c_Doc  := MV_PAR01
			l_SB7  := .T.
		Endif
	Else
		l_SB7  := .T.
	Endif
	
	If l_SB7
		aVetor :=   {;
		            {"B7_FILIAL", 	xFilial("SB7"),	Nil},;
		            {"B7_COD",		c_Produto,		Nil},;
		            {"B7_DOC",		c_Doc,			Nil},;
		            {"B7_LOTECTL",	c_Lote,			Nil},;            
		            {"B7_DTVALID",	d_DtValid,		Nil},;
		            {"B7_QUANT",	n_Quant,		Nil},;
		            {"B7_LOCAL",	c_Local,		Nil},;
		            {"B7_DATA",		DDATABASE,		Nil} }
		
		MSExecAuto({|x,y,z| mata270(x,y,z)}, aVetor, .T., 3)
	
		If lMsErroAuto
		    MostraErro()
		Else
		    lRet := .T.
		EndIf
	Else
		Aviso(SM0->M0_NOMECOM,"Inventแrio cancelado pelo usuแrio",{"OK"},2,"Aten็ใo")
	Endif
Return lRet



Static Function CriaPerg(c_Perg)
	a_MV_PAR01 := {}
	
	Aadd(a_MV_PAR01, "Informe o n๚mero do documento")
	Aadd(a_MV_PAR01, "que serแ criado.")

	//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c_Perg,"01","Documento ?"   	,"","","mv_ch1","C",09,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",a_MV_PAR01)
	
	If c_Perg == "FESTA0151"
		a_MV_PAR02 := {}
		a_MV_PAR03 := {}
		a_MV_PAR04 := {}	
		a_MV_PAR05 := {}                    
		a_MV_PAR06 := {}
		a_MV_PAR07 := {}
		a_MV_PAR08 := {}
		a_MV_PAR09 := {}
		a_MV_PAR10 := {}
		a_MV_PAR11 := {}
		a_MV_PAR12 := {}

		Aadd(a_MV_PAR02, "Informe o produto inicial")
		Aadd(a_MV_PAR03, "Informe o produto final")
		Aadd(a_MV_PAR04, "Informe o armaz้m inicial")
		Aadd(a_MV_PAR05, "Informe o armaz้m final")
		Aadd(a_MV_PAR06, "Informe o lote inicial")
		Aadd(a_MV_PAR07, "Informe o lote final")
		Aadd(a_MV_PAR08, "Informe o endere็o inicial")
		Aadd(a_MV_PAR09, "Informe o endere็o final")
		Aadd(a_MV_PAR10, "Informe a data inicial do inventario")
		Aadd(a_MV_PAR11, "Informe a data final do inventario")
		Aadd(a_MV_PAR12, "Informe se os saldos dos produtos")
		Aadd(a_MV_PAR12, "que nใo foram inventariados serใo")
		Aadd(a_MV_PAR12, "zerados no sistema")

		PutSx1(c_Perg,"02","Produto de ?"  	,"","","mv_ch2","C",TamSX3("B1_COD")[1],0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",a_MV_PAR02)
		PutSx1(c_Perg,"03","Produto ate ?" 	,"","","mv_ch3","C",TamSX3("B1_COD")[1],0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",a_MV_PAR03)
		PutSx1(c_Perg,"04","Local de ?"   	,"","","mv_ch4","C",TamSX3("B1_LOCPAD")[1],0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",a_MV_PAR04)
		PutSx1(c_Perg,"05","Local ate ?"   	,"","","mv_ch5","C",TamSX3("B1_LOCPAD")[1],0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",a_MV_PAR05)
		PutSx1(c_Perg,"06","Lote de ?"   	,"","","mv_ch6","C",TamSX3("D3_LOTECTL")[1],0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",a_MV_PAR06)
		PutSx1(c_Perg,"07","Lote ate ?"   	,"","","mv_ch7","C",TamSX3("D3_LOTECTL")[1],0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",a_MV_PAR07)
		PutSx1(c_Perg,"08","Endereco de ?"  ,"","","mv_ch8","C",TamSX3("ZX_END")[1],0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",a_MV_PAR08)
		PutSx1(c_Perg,"09","Endereco ate ?" ,"","","mv_ch9","C",TamSX3("ZX_END")[1],0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",a_MV_PAR09)
		PutSx1(c_Perg,"10","Data de ?"  	,"","","mv_cha","D",8,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",a_MV_PAR10)
		PutSx1(c_Perg,"11","Data ate ?" 	,"","","mv_chb","D",8,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",a_MV_PAR11)
		PutSx1(c_Perg,"12","Zerar Saldos ?" ,"","","mv_chc","N",01,0,0,"C","","","","","mv_par12","Sim","","","","Nใo","","","","","","","","","","","",a_MV_PAR12)
	Endif
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ f_ExpLog บ Autor ณ                  บ Data ณ    Julho/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta o log de importa็ใo para um arquivo texto          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACOM                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_ExpLog()
	Local c_Dir     := cGetFile( '*.*' , '', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY, GETF_LOCALHARD, GETF_NETWORKDRIVE), .F., .T. )
	Local c_Linha   := ""

	If !Empty(c_Dir)
		c_Destino := FCREATE(c_Dir + "LOG_INVENTARIO_" + AllTrim(c_Doc) + ".CSV")	
	
		// TESTA A CRIAวรO DO ARQUIVO DE DESTINO
		IF c_Destino == -1
			MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
		 	RETURN
		ENDIF
	
		c_Linha:= "REGISTRO;PRODUTO;DESCRIวรO;LOCAL;LOTE;DATA DE VALIDADE;PRIMEIRA CONTAGEM;SEGUNDA CONTAGEM;TERCEIRA CONTAGEM;QUANTIDADE FINAL;OBSERVAวรO" + CHR(13)+CHR(10)
	
		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF
	
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())
		
		Count To n_Reg
		ProcRegua(n_Reg)
	
		TRC->(DBGOTOP())
		WHILE !(TRC->(EOF()))
			c_Linha:= STRZERO(TRC->TB_POS,6)+";"+TRC->TB_PRODUTO+";"+TRC->TB_DESC+";"+TRC->TB_LOCAL+";"+TRC->TB_LOTECTL+";"+Dtoc(TRC->TB_DTVALID)+";"+Transform(TRC->TB_QUANT1, "@E 999,999,999.99")+";"+Transform(TRC->TB_QUANT2, "@E 999,999,999.99")+";"+Transform(TRC->TB_QUANT3, "@E 999,999,999.99")+";"+Transform(TRC->TB_QUANT, "@E 999,999.99")+";"+TRC->TB_OBS + CHR(13)+CHR(10)
	
			IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
				IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
					FCLOSE(c_Destino)
					DBSELECTAREA("TRC")
					DBGOTOP()
		   	   		Return
				ENDIF
		 	ENDIF
		 	
		 	IncProc()
		 	TRC->(DBSKIP())
		ENDDO 
	
		AVISO(SM0->M0_NOMECOM,"Arquivo exportado para " + c_Dir + "LOG_INVENTARIO_" + AllTrim(c_Doc) + ".CSV",{"Ok"},2,"Aten็ใo")
		FCLOSE(c_Destino)
		DBSELECTAREA("TRC")
		DBGOTOP()
	Endif
Return