#Include "Totvs.ch"

/*/{Protheus.doc} MT681AIN
	Ponto de entrada desenvolvido para alterar os empenhos da ordem de produção em caso de produção a maior ou produção com perda durante o processo.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/09/2021
/*/
User Function MT681AIN
	Local a_Area := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
		If SH6->H6_QTGANHO > 0
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB
			Begin Transaction
				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
				While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
					a_Vetor := {}
					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
					If Found()
						c_Produto := SD4->D4_COD
						c_Local   := SD4->D4_LOCAL
						c_Op      := SD4->D4_OP
						d_Data    := SD4->D4_DATA
						n_QtdOri  := SD4->D4_QTDEORI + (SG1->G1_QUANT * n_Perc)
						n_Quant   := SD4->D4_QUANT + (SG1->G1_QUANT * n_Perc)
						c_Trt     := SD4->D4_TRT
						a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
									{"D4_LOCAL"   ,c_Local          ,Nil},;
									{"D4_OP"      ,c_Op  			,Nil},;
									{"D4_DATA"    ,d_Data	        ,Nil},;
									{"D4_QTDEORI" ,n_QtdOri         ,Nil},;
									{"D4_QUANT"   ,n_Quant          ,Nil},;
									{"D4_TRT"     ,c_Trt            ,Nil}}
						f_Mata380(a_Vetor)
					Endif
					SG1->(dbSkip())
				End
			End Transaction
		Endif
	Endif

	RestArea(a_Area)
Return Nil

/*/{Protheus.doc} MT680GREST
	Descrição: É executado após o estorno do movimento da produção, e permite executar qualquer ação definida pelo operador.
	Obs: Para a compilação do PE é necessário que o nome do fisico do aquivo fonte não seja o mesmo nome que MT680GREST.
	Observação: Ponto de entrada desenvolvido para alterar os empenhos da ordem de produção em caso de estorno de produção a maior
	ou com perda durante o processo.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/09/2021
/*/
User Function MT680GREST
	Local a_Area  := GetArea()

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + SH6->H6_OP)
		If SH6->H6_QTGANHO > 0
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + SC2->C2_PRODUTO))
			n_Perc := SH6->H6_QTGANHO/SB1->B1_QB
			Begin Transaction
				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbSeek(xFilial("SG1") + SC2->C2_PRODUTO))
				While SG1->(!EoF()) .And. SG1->G1_COD == SC2->C2_PRODUTO
					a_Vetor := {}
					dbSelectArea("SD4")
					SD4->(dbSetOrder(2))
					SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP + SG1->G1_COMP))
					If Found()
						c_Produto := SD4->D4_COD
						c_Local   := SD4->D4_LOCAL
						c_Op      := SD4->D4_OP
						d_Data    := SD4->D4_DATA
						n_QtdOri  := SD4->D4_QTDEORI - (SG1->G1_QUANT * n_Perc)
						n_Quant   := SD4->D4_QUANT - (SG1->G1_QUANT * n_Perc)
						c_Trt     := SD4->D4_TRT

						a_Vetor:={  {"D4_COD"     ,c_Produto		,Nil},; //COM O TAMANHO EXATO DO CAMPO
									{"D4_LOCAL"   ,c_Local          ,Nil},;
									{"D4_OP"      ,c_Op  			,Nil},;
									{"D4_QUANT"   ,n_Quant          ,Nil},;
									{"D4_QTDEORI" ,n_QtdOri         ,Nil}}
						f_Mata380(a_Vetor)
					Endif
					SG1->(dbSkip())
				End
			End Transaction
		Endif
	Endif

	DbSelectArea("SC2")
	DbSetOrder(1)
	If DbSeek(FwXFilial("SC2") + SubStr(M->H6_OP,1,6) + SubStr(M->H6_OP,7,2) + SubStr(M->H6_OP,9,3))
		RecLock("SC2", .F.)
			If SC2->C2_FSSALDO == 0
				SC2->C2_FSSALDO := SH6->H6_QTDPROD
			ElseIf (SC2->C2_FSSALDO > 0 .And. SC2->C2_FSSALDO + SH6->H6_QTDPROD < SC2->C2_QUANT)
				SC2->C2_FSSALDO := SC2->C2_FSSALDO + SH6->H6_QTDPROD
			ElseIf SC2->C2_FSSALDO + SH6->H6_QTDPROD >= SC2->C2_QUANT
				SC2->C2_FSLOTOP := ""
				SC2->C2_FSDTVLD := SToD("")
				SC2->C2_FSSALDO := SC2->C2_QUANT
			EndIf
		MsUnlock()
	EndIf

	RestArea(a_Area)
Return Nil

/*/{Protheus.doc} f_Mata380
	ExecAuto para ajuste de empenhos
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/09/2021
	@param aVetor, array, Array com os dados a serem alterados no empenho
/*/
Static Function f_Mata380(aVetor)
	Local aEmpen := {}
	Local nOpc   := 4 //Alteração

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen)
	If lMsErroAuto
		MostraErro()
	EndIf
Return Nil
