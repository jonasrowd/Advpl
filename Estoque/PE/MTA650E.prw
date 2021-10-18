/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA650E   �Autor  � Victor Sousa       � 16/03/2020       ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executadado antes de excluir a ordem de   ���
���          � produ��o.					                              ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
���          � Este ponto de entrada est� sendo utilizado para            ���
���          � remover o campo de OP e Item OP no pedido de Vendas        ���
���          �                                              			  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA650E
	a_Area := GetArea()
	l_Ret  := .T.
	/*
	If !Empty(SC2->C2_PEDIDO)
	a_AreaSC6 := SC6->(GetArea())
	n_Qempn   := 0

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6") + SC2->C2_PEDIDO + SC2->C2_ITEMPV)
	n_Qempn := SC6->C6_QTDVEN - SC6->C6_QTDENT
	Endif

	RestArea(a_AreaSC6)

	a_AreaSB2 := SB2->(GetArea())

	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2") + SC2->C2_PRODUTO + SC2->C2_LOCAL)
	RecLock("SB2", .F.)
	SB2->B2_QEMPN -= n_Qempn
	MsUnlock()
	Endif

	RestArea(a_AreaSB2)
	Endif
	*/


	// ver update para atualizar a tabela SC6 - VICTOR - 24/07/2020
	If !Empty(SC2->C2_PEDIDO)
		a_AreaSC6 := SC6->(GetArea())
		n_Qempn   := 0

		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6") + SC2->C2_PEDIDO + SC2->C2_ITEMPV)
			//	n_Qempn := SC6->C6_QTDVEN - SC6->C6_QTDENT
			//Endif
			RecLock("SC6", .F.)
			SC6->C6_OP:="02"
			SC6->C6_NUMOP:="      "
			SC6->C6_ITEMOP:="  "
			MsUnlock()
		Endif
		RestArea(a_AreaSC6)

	Endif


	/*
	a_AreaSB2 := SB2->(GetArea())

	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2") + SC2->C2_PRODUTO + SC2->C2_LOCAL)
	RecLock("SB2", .F.)
	SB2->B2_QEMPN -= n_Qempn
	MsUnlock()
	Endif

	RestArea(a_AreaSB2)

	Endif
	*/

	RestArea(a_Area)
Return l_Ret