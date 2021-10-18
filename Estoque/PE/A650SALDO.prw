#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A650SALDO  ºAutor  ³ Christian Rocha    º      ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para manipular o saldo disponível do 	  º±±
±±º          ³ produto antes de efetuar a geração da ordem de produção do º±±
±±º          ³ pedido de venda selecionado.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   º±±
±±Ì          ³ Este ponto de entrada está sendo utilizado para evitar que ¹±±
±±º          ³ as ordens de produção sejam geradas com quantidades acima  º±±
±±º          ³ do que do pedido de venda.		 						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß       

*/

User Function A650SALDO
	n_Saldo   := PARAMIXB

	/*
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±³ ³ Sintaxe ³ ExpN1 := SaldoSB2(ExpL1,ExpL2,ExpD1,ExpL3,ExpN1) 	³±±
	±±³ ³ Parametros³ ExpN1 = Saldo devolvido pela funcao 				³±±
	±±³ ³ ExpL1 = Flag que indica se chamada da funcao ‚ utilizada p/	³±±
	±±³ ³ calculo de necessidade. Caso .T. deve considerar quantidade	³±±
	±±³ ³ a distribuir, pois a mesma apenas nao pode ser utilizada, 	³±±
	±±³ ³ porem ja esta em estoque. 									³±±
	±±³ ³ ExpL2 = Flag que indica se deve substrair o empenho do 		³±±
	±±³ ³ saldo a ser retornado. 										³±±
	±±³ ³ ExpD1 = Data final para filtragem de empenhos. Empenhos ate	³±±
	±±³ ³ esta data serao considerados no caso de leitura do SD4. 		³±±
	±±³ ³ ExpL3 = Flag que indica se deve considerar o saldo de terc 	³±±
	±±³ ³ eiros em nosso poder ou nao (B2_QTNP). 						³±±
	±±³ ³ ExpL4 = Flag que indica se deve considerar nosso saldo em 	³±±
	±±³ ³ poder de terceiros ou nao (B2_QNPT). 							³±±
	±±³ ³ ExpN1 = Qtd empenhada para esse movimento que nao deve ser 	³±±
	±±³ ³ subtraida 													³±±
	±±³ ³ ExpN2 = Qtd empenhada do Projeto para esse movimento que 		³±±
	±±³ ³ nao deve ser subtraida 										³±±
	±±³ ³ ExpL5 = Subtrai a Reserva do Saldo a ser Retornado? 			³±±
	±±³ ³ ExpD2 = Data limite para composicao do saldo MV_TPSALDO="C"	³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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