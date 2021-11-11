#Include "Totvs.ch"

/*/{Protheus.doc} MTDGPERD
	Ponto de entrada para preencher campos da Classificação da Perda na Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 10/11/2021
/*/
User Function MTDGPERD()

	Local a_Area    := FwGetArea() //
	Local c_Prod    := PARAMIXB[1] //
	Local c_OP      := PARAMIXB[2] //
	Local n_Qtd     := PARAMIXB[3] //
	Local cRet 		:= ""
	Local xLinha 	:= 10
	Local n_Size    := 0           //
	Local cMensagem	:= ""
	// Local n_Count := 0
	Local oSayTela
	Local oBtnCancel
	Local oBtnMater
	Local oBtnBorra
	Public oDlg

	If cFilAnt == '010101' 
        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(FwXFilial("SB1")+c_Prod)
        If Found()
            n_Peso := SB1->B1_PESO
            n_Size := Len(aCols)
            If Len(aCols) > 0
                n_QtdSegUm := n_Qtd * n_Peso
                GDFieldPut('BC_QUANT'  , n_Qtd, n_Size)
                GDFieldPut("BC_QTDDEST", n_Qtd, n_Size)
                GDFieldPut('BC_PRODUTO', c_Prod, n_Size)
                GDFieldPut("BC_DTVALID", dDatabase, n_Size)
                GDFieldPut("BC_QTSEGUM", n_QtdSegUm, n_Size)
                GDFieldPut("BC_QTDDES2", n_QtdSegUm, n_Size)
                GDFieldPut("BC_LOTECTL", M->H6_LOTECTL, n_Size)
                GDFieldPut("BC_CODDEST", SB1->B1_FSPRODC, n_Size)
                GDFieldPut("BC_PRDEST" , POSICIONE("SB1", 1, XFILIAL("SB1") + SB1->B1_FSPRODC, "B1_DESC"), n_Size)
            EndIf
        EndIf
	ElseIf cFilAnt == '020101'

        cMensagem := "O Apontamento de perda será para Borra ou Material Reprovado?"
        DEFINE MSDIALOG oDlg TITLE OemToAnsi("Atenção!") FROM 000,000 TO 180,650 PIXEL
        oSayTela	:= TSay():New(10,10,{||AllTrim(cMensagem)},oDlg,,,,,,.T.,,,100,400,,,,,,)
        oBtnBorra	:= TButton():New(060,070+xLinha,"Apontar Borra"			, oDlg,{||cRet := "Borra",oDlg:End()},50,20,,,,.T.,,"",,,,.F.) //P
        oBtnMater	:= TButton():New(060,130+xLinha,"Apontar Mat. Reprovado", oDlg,{||cRet := "Material",oDlg:End()},80,20,,,,.T.,,"",,,,.F.) //L
        oBtnCancel	:= TButton():New(060,250+xLinha,"Voltar"                , oDlg,{||oDlg:End()},50,20,,,,.T.,,"",,,,.F.)
        ACTIVATE MSDIALOG oDlg CENTERED

        // Carrega as informações de perda da MASTER
        fMasRes(c_OP)

        // Carrega as informações de perda da resina
        fSerCor(MASTER->ResinaSerie, MASTER->MasterCor)

        n_Size := Len(aCols)

		If cRet == "Borra"
            GDFieldPut("BC_QUANT"  , n_Qtd, n_Size)
            GDFieldPut("BC_QTSEGUM", n_Qtd, n_Size)
            GDFieldPut("BC_QTDDEST", n_Qtd, n_Size)
            GDFieldPut("BC_QTDDES2", n_Qtd, n_Size)
            GDFieldPut("BC_PRODUTO", c_Prod, n_Size)
            GDFieldPut("BC_DTVALID", dDatabase, n_Size)
            GDFieldPut("BC_LOTECTL", M->H6_LOTECTL, n_Size)
            GDFieldPut("BC_CODDEST", ESPEC->B1_FSPRODC, n_Size)
            GDFieldPut("BC_PRDEST" , POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_FSPRODC, "B1_DESC"), n_Size)
            GDFieldPut("BC_LOCAL"  , POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_FSPRODC, "B1_LOCPAD"), n_Size)
		ElseIf cRet == "Material"
            n_Qtd       := n_Qtd * (MASTER->Peso)
            n_Size      := Len(aCols)
            n_QtdSegUm  := n_Qtd * (MASTER->Peso)
            GDFieldPut("BC_QUANT"  , n_Qtd           , n_Size)
            GDFieldPut("BC_QTDDEST", n_Qtd           , n_Size)
            GDFieldPut("BC_PRODUTO", c_Prod          , n_Size)
            GDFieldPut("BC_DTVALID", dDatabase       , n_Size)
            GDFieldPut("BC_QTDDES2", n_QtdSegUm      , n_Size)
            GDFieldPut("BC_QTSEGUM", n_QtdSegUm      , n_Size)
            GDFieldPut("BC_LOTECTL", M->H6_LOTECTL   , n_Size)
            GDFieldPut("BC_CODDEST", ESPEC->B1_COD   , n_Size)
            GDFieldPut("BC_LOCAL"  , ESPEC->B1_LOCPAD, n_Size)
            GDFieldPut("BC_PRDEST" , POSICIONE("SB1", 1, XFILIAL("SB1")+ESPEC->B1_COD, "B1_DESC"), n_Size)
		EndIf

        // Fecha o alias do produto moido
        If (Select("ESPEC") > 0)
        DBSelectArea("ESPEC")
        DBCloseArea()
        EndIf

        // Fecha o alias da MASTER
        If (Select("MASTER") > 0)
            DBSelectArea("MASTER")
            DBCloseArea()
        EndIf
	EndIf

	// Restaura a área de trabalho anterior
	FwRestArea(a_Area)
Return (NIL)

/*/{Protheus.doc} fMasRes
	Monta tabela temporária que traz o material reprovado (MASTER e RESINA)
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 10/11/2021
	@param c_OP, Character, Número da OP
/*/
Static Function fMasRes(c_OP)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Fecha o alias se ele já estiver em uso
	If (Select("MASTER") > 0)
		DBSelectArea("MASTER")
		DBCloseArea()
	EndIf

	// Realiza a consulta SQL
	BEGINSQL ALIAS "MASTER"

		SELECT 
			Top 1 
			C2_NUM + C2_ITEM + C2_SEQUEN as OP, 
			C2_PRODUTO as ProdutoOP, 
			ProdutoOP.B1_PESO as Peso, 
			ProdutoOP.B1_LOCPAD as Armazem, 
			D4.D4_COD as Resina_ID, 
			B1.B1_DESC as Resina, 
			B1.B1_SERIE as ResinaSerie,
			D4_MASTER.D4_COD as Master_ID, 
			D4_MASTER.D4_FSDSC as Master, 
			ISNULL(B1_MASTER.B1_SERIE,'NATURAL') as MasterCor
		FROM
			%TABLE:SC2% C2 (NOLOCK)
			INNER JOIN
			%TABLE:SB1% ProdutoOP (NOLOCK)
			ON ProdutoOP.B1_FILIAL = %XFILIAL:SB1%
			AND ProdutoOP.%NOTDEL%
			AND ProdutoOP.B1_COD = C2.C2_PRODUTO
			INNER JOIN
			%TABLE:SD4% D4 (NOLOCK)
			ON D4.D4_FILIAL = %XFILIAL:SD4%
			AND D4.%NOTDEL%
			AND D4.D4_OP = %EXP:AllTrim(c_OP)%
			AND D4.D4_FSTP = "RESINA"
			INNER JOIN
			%TABLE:SB1% B1 (NOLOCK)
			ON B1.B1_FILIAL = %XFILIAL:SB1%
			AND B1.%NOTDEL%
			AND B1.B1_COD = D4.D4_COD
			LEFT JOIN
			%TABLE:SD4% D4_MASTER (NOLOCK)
			ON D4_MASTER.D4_FILIAL = %XFILIAL:SD4%
			AND D4_MASTER.%NOTDEL%
			AND D4_MASTER.D4_OP = %EXP:AllTrim(c_OP)%
			AND D4_MASTER.D4_FSTP = "MASTER"
			LEFT JOIN
			%TABLE:SB1% B1_MASTER (NOLOCK)
			ON B1_MASTER.B1_FILIAL = %XFILIAL:SB1%
			AND B1_MASTER.%NOTDEL%
			AND B1_MASTER.B1_COD = D4_MASTER.D4_COD
		WHERE
			C2_FILIAL = %XFILIAL:SC2% AND
			C2.%NOTDEL% AND
			C2_NUM + C2_ITEM + C2_SEQUEN = %EXP:AllTrim(c_OP)%
	ENDSQL

	// Restaura a área anterior
	FwRestArea(aArea)
Return (NIL)

/*/{Protheus.doc} fSerCor
	Monta tabela temporária que traz o material moído da perda
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 10/11/2021
	@param c_Serie, Character, Série da resina
	@param c_Cor, Character, Cor da MASTER
/*/

Static Function fSerCor(c_Serie, c_Cor)
	Local aArea := FwGetArea() // Armazena a área corrente

	// Prepara os valores para inserção na query
	//c_Serie := "%'%" + AllTrim(c_Serie) + "%'%"
	//c_Cor   := "%'%" + AllTrim(c_Cor) + "%'%"

	// Fecha o alias se ele já estiver em uso
	If (Select("ESPEC") > 0)
		DBSelectArea("ESPEC")
		DBCloseArea()
	EndIf

	// Realiza a consulta SQL
	BEGINSQL ALIAS "ESPEC"
		SELECT
			B1_COD,
			B1_DESC,
			B1_SERIE,
			B1_MSBLQL,
			B1_COD,
			B1_FSPRODC,
			B1_LOCPAD
		FROM
			%TABLE:SB1%
		WHERE
			B1_MSBLQL <> '1'
			AND B1_SERIE	= %EXP:AllTrim(c_Serie)%
			AND B1_BRTPPR	= 'MATERIAL REPROVADO'
			AND B1_BRCORG	= %EXP:AllTrim(c_Cor)%
			AND B1_FILIAL	= %XFILIAL:SB1%
	ENDSQL

	// Restaura a área anterior
	FwRestArea(aArea)
Return (NIL)
