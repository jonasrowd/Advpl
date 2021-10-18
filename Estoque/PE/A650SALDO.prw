#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A650SALDO  �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para manipular o saldo dispon�vel do 	  ���
���          � produto antes de efetuar a gera��o da ordem de produ��o do ���
���          � pedido de venda selecionado.                               ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
���          � Este ponto de entrada est� sendo utilizado para evitar que ���
���          � as ordens de produ��o sejam geradas com quantidades acima  ���
���          � do que do pedido de venda.		 						  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������       

*/

User Function A650SALDO
	n_Saldo   := PARAMIXB

	/*
	�����������������������������������������������������������������������
	�����������������������������������������������������������������������
	��� � Sintaxe � ExpN1 := SaldoSB2(ExpL1,ExpL2,ExpD1,ExpL3,ExpN1) 	���
	��� � Parametros� ExpN1 = Saldo devolvido pela funcao 				���
	��� � ExpL1 = Flag que indica se chamada da funcao � utilizada p/	���
	��� � calculo de necessidade. Caso .T. deve considerar quantidade	���
	��� � a distribuir, pois a mesma apenas nao pode ser utilizada, 	���
	��� � porem ja esta em estoque. 									���
	��� � ExpL2 = Flag que indica se deve substrair o empenho do 		���
	��� � saldo a ser retornado. 										���
	��� � ExpD1 = Data final para filtragem de empenhos. Empenhos ate	���
	��� � esta data serao considerados no caso de leitura do SD4. 		���
	��� � ExpL3 = Flag que indica se deve considerar o saldo de terc 	���
	��� � eiros em nosso poder ou nao (B2_QTNP). 						���
	��� � ExpL4 = Flag que indica se deve considerar nosso saldo em 	���
	��� � poder de terceiros ou nao (B2_QNPT). 							���
	��� � ExpN1 = Qtd empenhada para esse movimento que nao deve ser 	���
	��� � subtraida 													���
	��� � ExpN2 = Qtd empenhada do Projeto para esse movimento que 		���
	��� � nao deve ser subtraida 										���
	��� � ExpL5 = Subtrai a Reserva do Saldo a ser Retornado? 			���
	��� � ExpD2 = Data limite para composicao do saldo MV_TPSALDO="C"	���
	�����������������������������������������������������������������������
	�����������������������������������������������������������������������
	*/       
	

	n_Saldo := SaldoSB2(.T., , ,.F.,.F.)

	If n_Saldo > 0
		n_SalPedi := 0
		n_QEmpN   := 0

		c_Qry := " SELECT SUM(C2_QUANT-C2_QUJE) SALPEDI FROM " + RetSqlName("SC2") + " WHERE C2_PRODUTO='" + SB2->B2_COD + "' AND D_E_L_E_T_='' "
		c_Qry += " AND C2_DATRF='' AND C2_STATUS<>'U' AND C2_FILIAL='" + xFilial("SC2") + "' AND C2_LOCAL='" + SB2->B2_LOCAL + "' "
		c_Qry += " AND C2_PEDIDO+C2_ITEMPV NOT IN (SELECT C6_NUM+C6_ITEM FROM " + RetSqlName("SC6") + " WHERE C6_PRODUTO='" + SB2->B2_COD + "' AND D_E_L_E_T_='' AND C6_PVCOMOP='S' "
		c_Qry += " AND C6_FILIAL='" + xFilial("SC6") + "' AND (C6_BLQ='R' OR C6_QTDENT=C6_QTDVEN)) "

		TCQUERY c_Qry NEW ALIAS QRY
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!EoF())
			n_SalPedi := QRY->SALPEDI
		Endif
	  	QRY->(dbCloseArea())

		c_Qry := " SELECT SUM(C6_QTDVEN-C6_QTDENT) QEMPN FROM " + RetSqlName("SC6") + " WHERE C6_PRODUTO='" + SB2->B2_COD + "' AND D_E_L_E_T_='' AND C6_PVCOMOP='S' AND C6_OP IN ('01','05') 
		c_Qry += " AND C6_FILIAL='" + xFilial("SC6") + "' AND C6_LOCAL='" + SB2->B2_LOCAL + "' AND C6_BLQ<>'R' AND C6_QTDENT<>C6_QTDVEN "
		c_Qry += " AND C6_NUMOP IN (SELECT C2_NUM FROM " + RetSqlName("SC2") + " WHERE C2_PRODUTO='" + SB2->B2_COD + "' AND D_E_L_E_T_='' "
		c_Qry += " AND C2_DATRF='' AND C2_STATUS<>'U' AND C2_FILIAL='" + xFilial("SC2") + "' AND C2_LOCAL='" + SB2->B2_LOCAL + "') "

		TCQUERY c_Qry NEW ALIAS QRY
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!EoF())
			n_QEmpN := QRY->QEMPN
		Endif
	  	QRY->(dbCloseArea())

		n_Saldo += n_SalPedi - n_QEmpN
	Endif

	If n_Saldo < 0
		n_Saldo := 0
	Endif
Return n_Saldo