/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  MT240TOK     º Autor ³ AP6 IDE            º Data ³  28/09/12º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validação de Mov. Internos                                 º±±
±±º          ³ O ponto tem a finalidade de ser utilizado como validação   º±±
±±º          ³ da inclusão do movimento pelo usuário. 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT240TOK()
	Local l_Ret 	:= .T.
	Local c_Local   := M->D3_LOCAL							//Armazem da Movimentação
	Local c_TM		:= M->D3_TM								//Código do Tipo de Movimentação
	Local c_TpMov   := IIF(Val(M->D3_TM) > 500, 'S', 'E')   //Tipo de Movimentação
	Local c_Menu    := Upper(NoAcento(AllTrim(FunDesc())))  //Nome do menu executado

    If INCLUI .And. c_Menu == 'INTERNOS'
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
			If Z7_TPMOV == c_TpMov .Or. Z7_TPMOV == 'A'
				dbSelectArea("SZJ")
				dbSetOrder(1)
				If dbSeek(xFilial("SZJ") + __CUSERID + c_TM)
					l_Ret := .T.
				Else
					l_Ret := .F.
				Endif
			Else
				l_Ret := .F.
			Endif
		Else
			l_Ret := .F.
		Endif
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif
Return l_Ret
