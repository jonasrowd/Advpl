/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT241TOK     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o de Mov. Internos Mod 2                           ���
���          � O ponto tem a finalidade de ser utilizado como valida��o   ���
���          � da inclus�o do movimento pelo usu�rio. 					  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT241TOK()
	Local l_Ret := .T.
	Local c_Local   := ''									//Armazem da Movimenta��o
	Local c_TpMov   := IIF(Val(cTM) > 500, 'S', 'E')   		//Tipo de Movimenta��o
	Local c_Menu    := Upper(NoAcento(AllTrim(FunDesc())))  //Nome do menu executado

    If INCLUI .And. c_Menu == 'INTERNOS (MOD.2)'
		For i:=1 To Len(aCols)
		   	If aCols[i][Len( aHeader )+1] == .F.
				c_Local := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D3_LOCAL'})]
	
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
					If Z7_TPMOV == c_TpMov .Or. Z7_TPMOV == 'A'
						dbSelectArea("SZJ")
						dbSetOrder(1)
						If dbSeek(xFilial("SZJ") + __CUSERID + cTM)
							l_Ret := .T.
						Else
							l_Ret := .F.
							Exit
						Endif
					Else
						l_Ret := .F.
						Exit
					Endif
				Else
					l_Ret := .F.
					Exit
				Endif
			Endif
		Next
	Endif

	If !l_Ret
		ShowHelpDlg(SM0->M0_NOME,;
		{"O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif
Return l_Ret