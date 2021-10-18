/*
�����������������������������������������������������������������������������
���Programa  � FPCPV001   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para validar o tipo de ordem de produ��o selecionada���
���          � na rotina MRP.									 		  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

User Function FPCPV001(n_TipoOP)

If n_TipoOP == 1
	ShowHelpDlg(SM0->M0_NOME,;
				{"Ordens de produ��o firmes est�o bloqueadas nessa rotina."},5,;
				{"Contacte o administrador do sistema."},5)
	MV_PAR10 := 2
	l_Ret    := .F.
Else
	l_Ret := .T.
Endif

Return l_Ret