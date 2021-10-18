/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �A260GRV      � Autor � AP6 IDE            � Data �  28/09/12  ���
���������������������������������������������������������������������������͹��
���Descricao � Valida��o da Transfer�ncia	                                ���
���          � Apos confirmada a transferencia, antes de atualizar qualquer ���
���          � qualquer arquivo.Pode ser utilizado para validar o movimento ���
���          � ou atualizar o valor de alguma das variaveis disponiveis no  ���
���          � momento.  													���
���������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                      ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function A260GRV

Local l_Ret  := .T.
Local c_Orig := ""			//Armazem de Origem
Local c_Dest := ""			//Armazem de Destino
Local c_Menu := ""     	    //Nome do menu executado
Local a_Area := GetArea()

If Upper(Funname()) <> "DLGV001" // inserido valida��o porque esse ponto de entrada gerava erro no coletor
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
						{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Dest + "."},5,;
						{"Contacte o administrador do sistema."},5)
						l_Ret := .F.
					Endif
				Else
					ShowHelpDlg(SM0->M0_NOME,;
					{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Dest + "."},5,;
					{"Contacte o administrador do sistema."},5)
					l_Ret := .F.
				Endif
			Else
				ShowHelpDlg(SM0->M0_NOME,;
				{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
				{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Else
			ShowHelpDlg(SM0->M0_NOME,;
			{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Orig + "."},5,;
			{"Contacte o administrador do sistema."},5)
			l_Ret := .F.
		Endif

		If l_Ret
			If (c_GrupoOri <> c_GrupoDes) .And. (c_ProdDest <> c_Classe_D) .And. (SubStr(c_GrupoOri, 1, 1) $ "BT")
				ShowHelpDlg(SM0->M0_NOME,;
					{"N�o � permitido realizar transfer�ncias entre produtos de grupos diferentes."},5,;
					{"Contacte o administrador do sistema."},5)
				l_Ret := .F.
			Endif
		Endif

		If l_Ret
			If DEMIS260 <> DDATABASE
				ShowHelpDlg(SM0->M0_NOME,;
					{"Data de Emiss�o inv�lida."},5,;
					{"Preencha a Data de Emiss�o com a data atual do sistema."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
Endif

RestArea(a_Area)
Return l_Ret