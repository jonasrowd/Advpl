/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT381VLD     � Autor � AP6 IDE            � Data �  28/09/12���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o de Ajuste de Empenho Modelo 2                    ���
���          � Ponto de Entrada, localizado na valida��o de Ajuste Empenho���
���          � Mod. 2, utilizado para confirmar ou n�o a grava��o.        ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT381VLD()
	Local c_Local := ''
	Local l_Inc   := PARAMIXB[1]
	Local l_Alt   := PARAMIXB[2]
	Local l_Ret   := .T.
	Local c_Menu  := Upper(NoAcento(AllTrim(FunDesc())))  //Nome do menu executado

	If (l_Inc .Or. l_Alt) .And. c_Menu == 'AJUSTE EMP (MOD.2)'
		For i:=1 To Len(aCols)
		   	If aCols[i][Len( aHeader )+1] == .F.
				c_Local := aCols[i][AScan(aHeader,{ |x| Alltrim(x[2]) == 'D4_LOCAL'})]
	
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + __CUSERID + c_Local)
					If Z7_TPMOV == 'S' .Or. Z7_TPMOV == 'A'
						l_Ret := .T.
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
		{"O seu usu�rio n�o possui permiss�o para efetuar sa�das no armaz�m " + c_Local + "."},5,;
		{"Contacte o administrador do sistema."},5)
	Endif
Return l_Ret