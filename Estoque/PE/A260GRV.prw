/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออออปฑฑ
ฑฑบPrograma  ณA260GRV      บ Autor ณ AP6 IDE            บ Data ณ  28/09/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo da Transfer๊ncia	                                บฑฑ
ฑฑบ          ณ Apos confirmada a transferencia, antes de atualizar qualquer บฑฑ
ฑฑบ          ณ qualquer arquivo.Pode ser utilizado para validar o movimento บฑฑ
ฑฑบ          ณ ou atualizar o valor de alguma das variaveis disponiveis no  บฑฑ
ฑฑบ          ณ momento.  													บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function A260GRV

Local l_Ret  := .T.
Local c_Orig := ""			//Armazem de Origem
Local c_Dest := ""			//Armazem de Destino
Local c_Menu := ""     	    //Nome do menu executado
Local a_Area := GetArea()

If Upper(Funname()) <> "DLGV001" // inserido valida็ใo porque esse ponto de entrada gerava erro no coletor
	c_Orig   := cLocOrig								//Armazem de Origem
	c_Dest   := cLocDest  							//Armazem de Destino
	c_Menu   := Upper(NoAcento(AllTrim(FunDesc())))   //Nome do menu executado

	c_ProdOrig := cCodOrig
	c_GrupoOri := Posicione("SB1", 1, xFilial("SB1") + c_ProdOrig, "B1_GRUPO")
	c_Classe_D := SB1->B1_FSPRODD

	c_ProdDest := cCodDest
	c_GrupoDes := Posicione("SB1", 1, xFilial("SB1") + c_ProdDest, "B1_GRUPO")

	If INCLUI .And. (c_Menu == 'TRANSFERENCIA' .Or. c_Menu == 'TRANSFERENCIAS')
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + c_Orig)
			If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Dest)
					If Z7_TPMOV == 'E' .Or. Z7_TPMOV == 'A'
						l_Ret := .T.
					Else
						ShowHelpDlg(SM0->M0_NOME,;
						{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Dest + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Dest + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
				Endif
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Orig + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usuแrio nใo possui permissใo para efetuar este tipo de movimenta็ใo no armaz้m " + c_Orig + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif

		If l_Ret
			If (c_GrupoOri <> c_GrupoDes) .And. (c_ProdDest <> c_Classe_D) .And. (SubStr(c_GrupoOri, 1, 1) $ "BT")
				ShowHelpDlg(SM0->M0_NOME,;
					{"Nใo ้ permitido realizar transfer๊ncias entre produtos de grupos diferentes."},5,;
					{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Endif

		If l_Ret
			If DEMIS260 <> DDATABASE
				ShowHelpDlg(SM0->M0_NOME,;
					{"Data de Emissใo invแlida."},5,;
					{"Preencha a Data de Emissใo com a data atual do sistema."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
Endif

RestArea(a_Area)
Return l_Ret