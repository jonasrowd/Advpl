#Include "Totvs.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} EMP650
	Altera็ใo do Armaz้m de destino. Este ponto de entrada ้ executado na rotina de inclusใo da OP, antes da apresenta็ใo da tela de empenhos.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/09/2021
/*/
User Function EMP650

	Local i		   := 0
	Local n_RecTot := 0
	Local c_Local  := ''
	Local a_Area   := GetArea()

	c_Qry := " SELECT H1_FSLOCAL FROM " + RetSqlName("SC2") + " SC2 " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SG2") + " SG2 " + chr(13) + chr(10)
	c_Qry += " 		ON  G2_FILIAL = '" + xFilial("SG2") + "' " + chr(13) + chr(10)
	c_Qry += "		AND G2_PRODUTO = C2_PRODUTO " + chr(13) + chr(10)
	c_Qry += "      AND G2_CODIGO = C2_ROTEIRO " + chr(13) + chr(10)
	c_Qry += " 		AND SG2.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SH1") + " SH1 " + chr(13) + chr(10)
	c_Qry += " 		ON  H1_FILIAL = '" + xFilial("SH1") + "' " + chr(13) + chr(10)
	c_Qry += " 		AND H1_CODIGO = G2_RECURSO " + chr(13) + chr(10)
	c_Qry += " 		AND SH1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_NUM = '" + SC2->C2_NUM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_FILIAL = '" + xFilial("SC2") + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_PRODUTO = '" + SC2->C2_PRODUTO + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_ITEM = '" + SC2->C2_ITEM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_SEQUEN = '" + SC2->C2_SEQUEN + "' "

	TCQUERY c_Qry NEW ALIAS "QRY"

	dbSelectArea("QRY")
	Count To n_RecTot
	QRY->(dbGoTop())

	If n_RecTot > 0
		c_Local := QRY->H1_FSLOCAL
	EndIf

	QRY->(dbCloseArea())

	If !Empty(c_Local)
		For i:=1 To Len(aCols)
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2") + aCols[i][1] + c_Local)
				aCols[i][3] := c_Local
			Else
				RecLock("SB2", .T.)
					SB2->B2_FILIAL := XFILIAL("SB2")
					SB2->B2_COD    := aCols[i][1]
					SB2->B2_LOCAL  := c_Local
				MsUnlock()
				aCols[i][3] := c_Local
			EndIf
		Next
	EndIf

	RestArea(a_Area)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA650LEMP     บ Autor ณ AP6 IDE            บ Data ณ  28/09/12บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera็ใo do Armaz้m de Empenho                            บฑฑ
ฑฑบ          ณ O ponto de entrada A650LEMP permite alterar o conte๚do do  บฑฑ
ฑฑบ          ณ armaz้m gravado na linha do aCols do produto que gerarแ 	  บฑฑ
ฑฑบ          ณ empenho/scดs que faz parte da estrutura do produto pai. 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

/*
User Function A650LEMP
	Local a_Empenho := aClone(PARAMIXB)
	Local c_Local   := a_Empenho[3]
	Local n_RecTot  := 0

	c_Qry := " SELECT H1_FSLOCAL FROM " + RetSqlName("SC2") + " SC2 " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SG2") + " SG2 " + chr(13) + chr(10)
	c_Qry += " 		ON  G2_FILIAL = '" + xFilial("SG2") + "' " + chr(13) + chr(10)
	c_Qry += "		AND G2_PRODUTO = C2_PRODUTO " + chr(13) + chr(10)
	c_Qry += "      AND G2_CODIGO = C2_ROTEIRO " + chr(13) + chr(10)
	c_Qry += " 		AND SG2.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " INNER JOIN " + RetSqlName("SH1") + " SH1 " + chr(13) + chr(10)
	c_Qry += " 		ON  H1_FILIAL = '" + xFilial("SH1") + "' " + chr(13) + chr(10)
	c_Qry += " 		AND H1_CODIGO = G2_RECURSO " + chr(13) + chr(10)
	c_Qry += " 		AND SH1.D_E_L_E_T_ <> '*' " + chr(13) + chr(10)
	c_Qry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_NUM = '" + SC2->C2_NUM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_PRODUTO = '" + SC2->C2_PRODUTO + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_ITEM = '" + SC2->C2_ITEM + "' " + chr(13) + chr(10)
	c_Qry += " 		AND C2_SEQUEN = '" + SC2->C2_SEQUEN + "' "

	TCQUERY c_Qry NEW ALIAS "QRY"

	dbSelectArea("QRY")
	Count To n_RecTot
	QRY->(dbGoTop())

	If n_RecTot > 0
		If !Empty(QRY->H1_FSLOCAL)
			c_Local := QRY->H1_FSLOCAL
		EndIf
	EndIf

	QRY->(dbCloseArea())

Return c_Local
*/
