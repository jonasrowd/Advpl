//Bibliotecas necessárias
#Include "TOTVS.CH"

/*/{Protheus.doc} jbimportsg1
	Função responsável pela manipulação da estrutura de produtos.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 20/10/2021
	@exemple 
	• ESTRUTURA DO CSV PARA EXPORTACAO
	B1_COD;;B1_QB;;;G1_COMP;;G1_QUANT

	• CAMPOS DO ARRAY PREENCHIDOS NA ROTINA
	aFeed[1];;aFeed[3];;;aFeed[6];;aFeed[8]
	
	•LINHAS DE EXEMPLO
	PRD000001;;960;;;PRDFIL001;;2
	PRD000001;;960;;;PRDFIL002;;1,18944
	PRD000001;;960;;;PRDFIL003;;168,73056
	PRD000001;;960;;;PRDFIL004;;48
	PRD000001;;960;;;PRDFIL005;;2
	PRD000002;;960;;;PRDFIL006;;2
	PRD000002;;960;;;PRDFIL007;;3,3984
	PRD000002;;960;;;PRDFIL003;;166,5216
	PRD000002;;960;;;PRDFIL004;;48
	PRD000002;;960;;;PRDFIL005;;2
	PRD000003;;960;;;PRDFIL001;;2
	PRD000003;;960;;;PRDFIL008;;0,8496
	PRD000003;;960;;;PRDFIL003;;169,0704
	PRD000003;;960;;;PRDFIL004;;48
	PRD000003;;960;;;PRDFIL005;;2
	PRD000004;;960;;;PRDFIL006;;2
	PRD000004;;960;;;PRDFIL002;;1,18944
	PRD000004;;960;;;PRDFIL003;;168,73056
	PRD000004;;960;;;PRDFIL004;;48
	PRD000004;;960;;;PRDFIL005;;2
/*/
User Function jbimportsg1()
	Local c_Texto  := "Esta rotina tem a finalidade de atualizar os dados da tabela SG1 - Estrutura de Produtos, a partir do arquivo CSV selecionado  pelo usuário."
	Local c_Erro   := "É necessário selecionar o arquivo CSV para efetuar essa operação."
	Private c_File := Space(500)	//Arquivo

	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	//Definicao do Dialog e todos os seus componentes.
	oDlg1:= TDialog():New(90,230,198,670,'Importa Estrutura de Produtos',,,,,,,,,.T.)
	oSay1:= TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1:= TGet():New( 004,025,{|u| If( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)
	oBtn1:= TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos CSV |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
	oBtn2:= TButton():New( 021,180,"&Atualizar",oDlg1,{|| iIf(Empty(c_File), Help(NIL, NIL, "Validação de Arquivo.", NIL, c_Erro,1, 0,NIL, NIL, NIL, NIL, NIL, {"Selecione um arquivo CSV válido."}), jbbuilder())},037,12,,,,.T.,,"",,,,.F. )
	oBtn3:= TButton():New( 038,180,"&Sair",oDlg1,{|| oDlg1:End()},037,12,,,,.T.,,"",,,,.F. )
	oGrp1:= TGroup():New( 018,004,050,176,"Descrição",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2:= TSay():New( 026,016,{||c_Texto},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,036)
	oDlg1:Activate(,,,.T.)

Return Nil

/*/{Protheus.doc} jbbuilder
	Efetua a montagem da régua de processamento
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 20/10/2021
/*/
Static Function jbbuilder()

	Processa({|| jbimportdata()}, "Aguarde...", "Atualizando o cadastro de estruturas...",.F.)

Return Nil

/*/{Protheus.doc} jbimportdata
	Função responsável pela importação dos dados do arquivo texto.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 20/10/2021
/*/
Static Function jbimportdata()
	//Local j		   := 0
	Local oJbTemp	   := Nil
	Private nQtdLin    := 0     //Contagem de linhas importadas
	Private nLinErr    := 0     //Contagem de linhas não importadas
	Private nQtdBase   := 0     //Quantidade Base do Produto
	Private nQtde  	   := 0     //Quantidade Produto Filho
	Private nPosicion  := 1     //Posição no arquivo
	Private	nOption    := 3     //3 - Inclusão, 4 - Alteração, 5 - Exclusão, 7 - Substituição
	Private cFeed 	   := ""    //Alimentação do arquivo
	Private cLine  	   := ""    //Linha do Log
	Private cCodePrd   := ""    //Produto Pai
	Private cCodeAux   := ""    //Código Auxiliar
	Private cSonPrd    := ""    //Produto Filho
	Private cObs       := ""    //Observação
	Private cTab   	   := ""    //Borda da tabela temporária
	Private aFeed 	   := {}    //Array com o Feed do arquivo
	Private aTab   	   := {}    //Array da tabela temporária
	Private aFields    := {}    //Campos da tabela temporária
	Private aBlock	   := {}    //Array caso queira alterar itens bloqueados também
	Private lTable	   := .T.   //Controla a criação da tabela temporária
	Private oFont	   := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	If AVISO(SM0->M0_NOMECOM,"Esta rotina irá atualizar os dados da tabela SG1 - Estruturas dos Produtos. Deseja realmente continuar?",{"Sim","Não"},2,"Atenção") == 1
		If lTable
			Aadd(aTab,{"TB_POS"    , "N", 6				       , 0					  })
			Aadd(aTab,{"TB_PRODUTO", "C", TamSX3("B1_COD")[1]  , 0					  })
			Aadd(aTab,{"TB_QB"     , "N", TamSX3("B1_QB")[1]   , TamSX3("B1_QB")[2]	  })
			Aadd(aTab,{"TB_MP"     , "C", TamSX3("B1_COD")[1]  , 0					  })
			Aadd(aTab,{"TB_QUANT"  , "N", TamSX3("G1_QUANT")[1], TamSX3("G1_QUANT")[2]})
			Aadd(aTab,{"TB_OBS"    , "C", 150				   , 0					  })

			oJbTemp := FWTemporaryTable():New("TTB", aTab)
			oJbTemp:Create()
			cTab := oJbTemp:GetRealName()
		EndIf

		If FT_FUSE(ALLTRIM(c_File)) == -1
			Help(NIL, NIL, "Validação de Arquivo.", NIL, "O arquivo "+ALLTRIM(c_File)+" não foi encontrado.",1, 0,;
				NIL, NIL, NIL, NIL, NIL, {"VerIfique se o caminho está correto ou se o arquivo ainda se encontra no local indicado."})
			Return Nil
		EndIf

		ProcRegua(FT_FLastRec())

		While !FT_FEOF()
			cFeed	    := FT_FREADLN()
			aFeed	    := STRTOKARR2(cFeed,";",.T.)
			cCodePrd	:= PADR(UPPER(aFeed[1]), TAMSX3("B1_COD")[1])   					// Código do produto
			nQtdBase	:= Val(StrTran(aFeed[3], ",", "."))
			a_Materias	:= {}
			aBlock      := {}
			cCodeAux	:= cCodePrd
			l_Erro		:= .F.

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1") + cCodePrd)
			If Found()
				// If SB1->B1_MSBLQL == '1'
				// 	RecLock("SB1", .F.)
				// 		SB1->B1_MSBLQL := '2'
				// 	MsUnlock()
				// 	Aadd(aBlock, cCodePrd)
				// EndIf
			Else
				nLinErr++
				cSonPrd := PADR(UPPER(aFeed[6]), TAMSX3("B1_COD")[1])
				nQtde  := Val(StrTran(aFeed[8], ",", "."))
				cObs    := "Estrutura do Produto " + AllTrim(cCodePrd) + " não foi atualizada pela rotina, porque não está cadastrado no sistema."
				l_Erro   := .T.

				Reclock("TTB",.T.)
					TTB->TB_POS     := nPosicion //LINHA DO ARQUIVO
					TTB->TB_PRODUTO := cCodePrd
					TTB->TB_QB      := nQtdBase
					TTB->TB_MP      := cSonPrd
					TTB->TB_QUANT   := nQtde
					TTB->TB_OBS     := cObs
				MsUnlock()

				While (!FT_FEOF() .And. cCodeAux == cCodePrd)
					FT_FSKIP()
					nPosicion++
					IncProc()

					If !FT_FEOF()
						cFeed := FT_FREADLN()
						aFeed := STRTOKARR2(cFeed,";",.T.)
						cCodeAux := PADR(UPPER(aFeed[1]), TAMSX3("B1_COD")[1])
					Else
						cCodeAux := Space(TAMSX3("B1_COD")[1])
					EndIf
				End

				Loop
			EndIf

			While (!FT_FEOF() .And. cCodeAux == cCodePrd)
				cSonPrd := PADR(UPPER(aFeed[6]), TAMSX3("B1_COD")[1])
				nQtde  := Val(StrTran(aFeed[8], ",", "."))

				DbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1") + cSonPrd)
				If Found()
					// If SB1->B1_MSBLQL == '1'
					// 	Reclock("SB1", .F.)
					// 	SB1->B1_MSBLQL := '2'
					// 	MsUnlock()

					// 	Aadd(aBlock, cSonPrd)
					// EndIf

					Aadd(a_Materias, {cSonPrd, nQtde})
				Else
					nLinErr++
					cObs  := "Estrutura do Produto " + AllTrim(cCodePrd) + " não foi atualizada pela rotina, porque o Produto " + AllTrim(cSonPrd) + " não está cadastrado no sistema."
					l_Erro := .T.
					Reclock("TTB",.T.)
						TTB->TB_POS     := nPosicion //LINHA DO ARQUIVO
						TTB->TB_PRODUTO := cCodePrd
						TTB->TB_QB      := nQtdBase
						TTB->TB_MP      := cSonPrd
						TTB->TB_QUANT   := nQtde
						TTB->TB_OBS     := cObs
					MsUnlock()
				EndIf

				FT_FSKIP()
				nPosicion++
				IncProc()

				If !FT_FEOF()
					cFeed := FT_FREADLN()
					aFeed := STRTOKARR2(cFeed,";",.T.)
					cCodeAux := PADR(UPPER(aFeed[1]), TAMSX3("B1_COD")[1])
				Else
					cCodeAux := Space(TAMSX3("B1_COD")[1])
				EndIf
			End

			If l_Erro == .F.
				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1") + cCodePrd)
					If jbdelmt200()
						If jbmt200()
							cObs := "Estrutura do Produto " + Alltrim(cCodePrd) + " foi atualizada pela rotina."
							nQtdLin++
						Else
							cObs := "Erro na inclusão da Estrutura do Produto " + Alltrim(cCodePrd) + "."
							nLinErr++
						EndIf
					Else
						l_Erro := .T.
						cObs := "Erro na alteração da Estrutura do Produto " + Alltrim(cCodePrd) + "."
						nLinErr++
					EndIf
				Else
					If jbmt200()
						cObs := "Estrutura do Produto " + Alltrim(cCodePrd) + " foi atualizada pela rotina."
						nQtdLin++
					Else
						cObs := "Erro na inclusão da Estrutura do Produto " + Alltrim(cCodePrd) + "."
						nLinErr++
					EndIf
				EndIf

				// For j := 1 To Len(aBlock)
				// 	DbSelectArea("SB1")
				// 	DbSetOrder(1)
				// 	DbSeek(xFilial("SB1") + aBlock[j])
				// 	If Found()
				// 		Reclock("SB1", .F.)
				// 			SB1->B1_MSBLQL := '1'
				// 		MsUnlock()
				// 	EndIf
				// Next

				Reclock("TTB",.T.)
					TTB->TB_POS     := nPosicion-1 //LINHA DO ARQUIVO
					TTB->TB_PRODUTO := cCodePrd
					TTB->TB_QB      := nQtdBase
					TTB->TB_MP      := cSonPrd
					TTB->TB_QUANT   := nQtde
					TTB->TB_OBS     := cObs
				MsUnlock()
			EndIf
		End

		FT_FUSE()

		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(nQtdLin+nLinErr)) ;
			+ " registros. Foram atualizados " + ALLTRIM(STR(nQtdLin)) + " registros e " + ALLTRIM(STR(nLinErr)) ;
			+ " registros não foram atualizados para a Filial " + AllTrim(cFilAnt) + " - " + AllTrim(SM0->M0_FILIAL) + ".",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DbSelectArea("TTB")

		TTB->(DbGoTop())

		Aadd(aFields,{"TB_POS"     ,,'Linha'    ,'@!'})
		Aadd(aFields,{"TB_PRODUTO" ,,'Produto'  ,'@!'})
		Aadd(aFields,{"TB_QB"   	,,'Qtde Base'  ,X3Picture("B1_QB")})
		Aadd(aFields,{"TB_MP"   	,,'Matéria Prima'  ,'@!'})
		Aadd(aFields,{"TB_QUANT"   ,,'Quantidade'  ,X3Picture("G1_QUANT")})
		Aadd(aFields,{"TB_OBS"     ,,'Observação' ,'@!'})

		o_Dlg	:= MSDialog():New( 091,232,637,1240,"Log de atualização do Cadastro de Estruturas",,,.F.,,,,,,.T.,,,.T. )
		o_Say	:= TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(nQtdLin+nLinErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw	:= MsSelect():New( "TTB","","",aFields,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn	:= TButton():New( 253,10,"Salvar" ,o_Dlg,{|| Processa( {|| jbExpotLog()} ) },041,012,,,,.T.,,"",,,,.F. )
		o_Btn	:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

		o_Dlg:Activate(,,,.T.)

		//Após fazer o uso da tabela, as boas práticas pedem que a mesma seja fechada
		//O método Delete efetuar a exclusão da tabela e também fecha a workarea da mesma
		DbSelectArea("TTB")
		TTB->(DbCloseArea())
		oJbTemp:Delete()
	EndIf

Return Nil

/*/{Protheus.doc} jbExpotLog
	Exporta o log de importação para um arquivo texto
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 20/10/2021
/*/
Static Function jbExpotLog()
	Local c_LogFile := "C:\TEMP\LOG_ESTRUTURAS_" + Dtos(DDATABASE) + "_" + Subs(Time(), 1, 2) + Subs(Time(), 4, 2) + Subs(Time(), 7, 2) + ".TXT"
	Local c_Destino := FCREATE(c_LogFile)
	Local cLine := ""

	// TESTA A CRIAÇÃO DO ARQUIVO DE DESTINO
	If c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
		Return Nil
	EndIf

	DbSelectArea("TTB")
	TTB->(DbGoTop())

	Count To n_Reg
	ProcRegua(n_Reg)

	TTB->(DbGoTop())
	While !(TTB->(EOF()))
		// cLine:= STRZERO(TTB->TB_POS,6)+";"+TTB->TB_PRODUTO+";"+TRANSFORM(TTB->TB_QB, X3Picture("B1_QB"))+";"+TTB->TB_MP+";"+TRANSFORM(TTB->TB_QUANT, X3Picture("G1_QUANT"))+";"+TTB->TB_OBS + CRLF
		cLine:= STRZERO(TTB->TB_POS,6)+";"+TTB->TB_PRODUTO+";"+TRANSFORM(TTB->TB_QB, X3Picture("B1_QB"))+";"+TTB->TB_OBS + CRLF

		If FWRITE(c_Destino,cLine,LEN(cLine)) != LEN(cLine)
			If !MSGALERT("Ocorreu um erro na gravação do arquivo de log. Continuar?","Atenção")
				FCLOSE(c_Destino)
				DbSelectArea("TTB")
				DbGoTop()
				Return Nil
			EndIf
		EndIf

		IncProc()

		TTB->(DBSKIP())
	End

	AVISO(SM0->M0_NOMECOM,"Log gerado para o arquivo " + Lower(c_LogFile), {"Ok"}, 2, "Atenção")
	FCLOSE(c_Destino)
	DbSelectArea("TTB")
	DbGoTop()

Return Nil

/*/{Protheus.doc} jbmt200
	Executa a rotina automática de inclusão/alteração de estrutura.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 20/10/2021
/*/
Static Function jbmt200()
	Local i 		  := 0
	Local PARAMIXB1   := {}
	Local PARAMIXB2   := {}
	Local aGets       := {}
	Local PARAMIXB3   := nOption
	Local c_Revisao   := Space(3)
	Private lMsErroAuto	      := .F.

	/*
	PARAMIXB1   Vetor   	Array contEndo cabeçalho da Estrutura de Produtos      X
	PARAMIXB2   Vetor   	Array contEndo os itens que a estrutura possui.        X
	PARAMIXB3   Numérico    Opção desejada: 3-Inclusão; 4-Alteração ; 5-Exclusão
	*/

	PARAMIXB1 := {{"G1_COD", cCodePrd, NIL},;
		{"G1_QUANT", nQtdBase, NIL},;	// Quantidade base será de 1 Kg	para evitar grAndes distorções nos valores
	{"G1_TRT", c_Revisao, NIL},;
		{"NIVALT", "S", NIL}} 	// A variável NIVALT é utilizada pra recalcular ou não a estrutura

	// a_Materias[i][1]   	// Código do produto matéria prima
	// a_Materias[i][2]		// Quantidade utilizada da matéria prima

	For i:=1 To Len(a_Materias)
		aGets := {}
		Aadd(aGets,{"G1_COD", cCodePrd, NIL})
		Aadd(aGets,{"G1_COMP", a_Materias[i][1], NIL})
		Aadd(aGets,{"G1_TRT", c_Revisao, NIL})
		Aadd(aGets,{"G1_QUANT", a_Materias[i][2], NIL})
		Aadd(aGets,{"G1_PERDA", 0, NIL})
		Aadd(aGets,{"G1_INI", DDATABASE, NIL})
		Aadd(aGets,{"G1_FIM", Stod("20501231"),NIL})
		Aadd(PARAMIXB2,aGets)
	Next

	Begin Transaction
		MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Return .F.
		Else
			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1") + cCodePrd)
				l_Ret := .T.
			Else
				l_Ret := .F.
			EndIf
		EndIf
	End Transaction
Return l_Ret

/*/{Protheus.doc} jbdelmt200
	ExecAuto para deletar a estrutura do produto antes de incluir a nova.
	@type Function
	@version 12.1.25
	@author Jonas
	@since 20/10/2021
/*/
Static Function jbdelmt200()
	Local PARAMIXB1		:= {}
	Local l_Ret			:= .F.
	Private INCLUI		:= .F.
	Private lMsErroAuto	:= .F.

	PARAMIXB1 :=   {{"G1_COD", cCodePrd , NIL},;
		{"NIVALT", "S"		, NIL}}

	Begin Transaction
		MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Return l_Ret
		Else
			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1") + cCodePrd)
				l_Ret := .F.
			Else
				l_Ret := .T.
			EndIf
		EndIf
	End Transaction

Return l_Ret
