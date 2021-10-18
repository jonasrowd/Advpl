#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FPCPA001  �Autor  �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa responsavel por importacao de arquivo texto.       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FPCPA001()
	Local c_Texto  := "Esta rotina tem a finalidade de atualizar os dados da tabela SG1 - Estruturas de Produto, a partir do arquivo CSV selecionado  pelo usu�rio."
	Local c_Erro   := "� necess�rio selecionar o arquivo CSV para efetuar essa opera��o."

	Private c_File := Space(500)	//Arquivo

	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 090,230,198,670,SM0->M0_NOME,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 004,025,{|u| if( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)

	oBtn1      := TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos CSV |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 021,180,"&Atualizar",oDlg1,{|| iif(Empty(c_File), ShowHelpDlg("Valida��o de Arquivo",{c_Erro},5,{"Selecione um arquivo CSV v�lido."},5), f_MontaRegua())},037,12,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 038,180,"&Sair",oDlg1,{|| oDlg1:End()},037,12,,,,.T.,,"",,,,.F. )

	oGrp1      := TGroup():New( 018,004,050,176,"Descri��o",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 026,016,{||c_Texto},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,036)
	
	oDlg1:Activate(,,,.T.)
Return()

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � f_MontaRegua �Autor  �                     � Data �		  ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a montagem da r�gua de processamento				  ���
�������������������������������������������������������������������������͹��
*/

Static Function f_MontaRegua()
	Processa({|| f_ImportaDados()}, "Aguarde...", "Atualizando o cadastro de estruturas...",.F.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_ImportaDados�Autor  �                � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao resposnavel pela leitura do arquivo texto e gravacao ���
���          �dos dados                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function f_ImportaDados()
	Private n_Pos    := 1    //Numero da linha do arquivo
	Private n_QtdInc := 0    //Conta quantas linhas foram importadas
	Private n_QtdErr := 0    //Conta quantas linhas n�o foram importadas	
	Private c_Buffer := ""   //Buffer do arquivo
	Private a_Buffer := {}   //Array com o Buffer do arquivo
	Private c_Linha  := ""
	Private c_CodPro := ""
	Private n_QB     := 0
	Private c_CodAux := ""
	Private c_MatPri := ""
	Private n_Quant  := 0 
	Private c_Obs    := ""
	Private	n_Opcao  := 3

	Private l_CriaTb := .F.  //Controla a criacao da tabela temporaria
	Private c_Bord   := ""   //Borda da tabela tempor�ria
	Private a_Bord   := {}   //Array da tabela tempor�ria
	Private a_Campos := {}   //Campos da tabela tempor�ria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM,"Esta rotina ir� atualizar os dados da tabela SG1 - Estruturas de Produto. Deseja realmente continuar?",{"Sim","N�o"},2,"Aten��o") == 1
		IF !l_CriaTb
			Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
			Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1],0})
			Aadd(a_Bord,{"TB_QB"   	  ,"N",TamSX3("B1_QB")[1],TamSX3("B1_QB")[2]})
//			Aadd(a_Bord,{"TB_MP"   	  ,"C",TamSX3("B1_COD")[1],0})
//			Aadd(a_Bord,{"TB_QUANT"   ,"N",TamSX3("G1_QUANT")[1],TamSX3("G1_QUANT")[2]})
			Aadd(a_Bord,{"TB_OBS"     ,"C",150,0})

			c_Bord := CriaTrab(a_Bord,.t.)
			Use &c_Bord Shared Alias TRC New
			Index On TB_POS To &c_Bord

			SET INDEX TO &c_Bord

			l_CriaTb:= .T.	 
		ENDIF	

		IF FT_FUSE(ALLTRIM(c_File)) == -1
	  		ShowHelpDlg("Valida��o de Arquivo",;
	  		{"O arquivo "+ALLTRIM(c_File)+" n�o foi encontrado."},5,;
		  	{"Verifique se o caminho est� correto ou se o arquivo ainda se encontra no local indicado."},5)
			Return()
		Endif
	 
		ProcRegua(FT_FLastRec())

		WHILE !FT_FEOF()
			c_Buffer:= FT_FREADLN()
		  	//���������������������������������������������������������������������������������Ŀ
			//�STRTOKARR:                                                                       �
			//�Funcao utilizada para retornar um array, de acordo com os dados passados como    �
			//�parametro para a funcao. Esta funcao recebe uma string <cValue> e um caracter    �
			//�<cToken> que representa um separador, e para toda ocorrencia deste separador     �
			//�em <cValue> e adicionado um item no array.                                       �
			//�����������������������������������������������������������������������������������  
			a_Buffer:= STRTOKARR(c_Buffer,";")        

			c_CodPro   := PADR(UPPER(a_Buffer[1]), TAMSX3("B1_COD")[1])   					// C�digo do produto
			n_QB       := Val(StrTran(a_Buffer[3], ",", "."))
			a_Materias := {}
			a_Bloqueio := {}
			c_CodAux   := c_CodPro
			l_Erro   := .F.
			
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			MSSEEK(XFILIAL("SB1") + c_CodPro)
			IF FOUND()
				IF SB1->B1_MSBLQL == '1'
					RECLOCK("SB1", .F.)
					SB1->B1_MSBLQL := '2'
					MSUNLOCK()

					AADD(a_Bloqueio, c_CodPro)
				ENDIF
			ELSE
		    	n_QtdErr++
//				c_MatPri := PADR(UPPER(a_Buffer[6]), TAMSX3("B1_COD")[1])
//				n_Quant  := Val(StrTran(a_Buffer[8], ",", "."))
				c_Obs    := "Estrutura do Produto " + AllTrim(c_CodPro) + " n�o foi atualizada pela rotina, porque n�o est� cadastrado no sistema."
				l_Erro   := .T.

				RECLOCK("TRC",.T.)
				TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
				TRC->TB_PRODUTO := c_CodPro
				TRC->TB_QB      := n_QB
//				TRC->TB_MP      := c_MatPri
//				TRC->TB_QUANT   := n_Quant
				TRC->TB_OBS     := c_Obs
				MSUNLOCK()

				WHILE !FT_FEOF() .AND. c_CodAux == c_CodPro
					FT_FSKIP()
					n_Pos++
					IncProc()

					IF !FT_FEOF()
						c_Buffer := FT_FREADLN()
						a_Buffer := STRTOKARR(c_Buffer,";")        

						c_CodAux := PADR(UPPER(a_Buffer[1]), TAMSX3("B1_COD")[1])
					ELSE
						c_CodAux := Space(TAMSX3("B1_COD")[1])
					ENDIF
				END

				LOOP
			ENDIF

			WHILE !FT_FEOF() .AND. c_CodAux == c_CodPro
				c_MatPri := PADR(UPPER(a_Buffer[6]), TAMSX3("B1_COD")[1])
				n_Quant  := Val(StrTran(a_Buffer[8], ",", "."))

				DBSELECTAREA("SB1")
				DBSETORDER(1)
				MSSEEK(XFILIAL("SB1") + c_MatPri)
				IF FOUND()
					IF SB1->B1_MSBLQL == '1'
						RECLOCK("SB1", .F.)
						SB1->B1_MSBLQL := '2'
						MSUNLOCK()

						AADD(a_Bloqueio, c_MatPri)
					ENDIF

					AADD(a_Materias, {c_MatPri, n_Quant})
				ELSE
			    	n_QtdErr++			
					c_Obs  := "Estrutura do Produto " + AllTrim(c_CodPro) + " n�o foi atualizada pela rotina, porque o Produto " + AllTrim(c_MatPri) + " n�o est� cadastrado no sistema."
					l_Erro := .T.

					RECLOCK("TRC",.T.)
					TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
					TRC->TB_PRODUTO := c_CodPro
					TRC->TB_QB      := n_QB
//					TRC->TB_MP      := c_MatPri
//					TRC->TB_QUANT   := n_Quant
					TRC->TB_OBS     := c_Obs
					MSUNLOCK()
				ENDIF

				FT_FSKIP()
				n_Pos++
				IncProc()

				IF !FT_FEOF()
					c_Buffer := FT_FREADLN()
					a_Buffer := STRTOKARR(c_Buffer,";")        

					c_CodAux := PADR(UPPER(a_Buffer[1]), TAMSX3("B1_COD")[1])
				ELSE
					c_CodAux := Space(TAMSX3("B1_COD")[1])
				ENDIF
			END

			If l_Erro == .F.
				dbSelectArea("SG1")
				dbSetOrder(1)
				If msSeek(xFilial("SG1") + c_CodPro)
					If f_DelEstr()
					    If f_Mata200()
							c_Obs := "Estrutura do Produto " + Alltrim(c_CodPro) + " foi atualizada pela rotina."
					    	n_QtdInc++
						Else
							c_Obs := "Erro na inclus�o da Estrutura do Produto " + Alltrim(c_CodPro) + "."
					    	n_QtdErr++
						Endif
					Else
						l_Erro := .T.
						c_Obs := "Erro na altera��o da Estrutura do Produto " + Alltrim(c_CodPro) + "."
				    	n_QtdErr++
					Endif
				Else
				    If f_Mata200()
						c_Obs := "Estrutura do Produto " + Alltrim(c_CodPro) + " foi atualizada pela rotina."
				    	n_QtdInc++
					Else
						c_Obs := "Erro na inclus�o da Estrutura do Produto " + Alltrim(c_CodPro) + "."
				    	n_QtdErr++
					Endif
				Endif

				For j:=1 To Len(a_Bloqueio)
					DBSELECTAREA("SB1")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SB1") + a_Bloqueio[j])
					IF FOUND()
						RECLOCK("SB1", .F.)
						SB1->B1_MSBLQL := '1'
						MSUNLOCK()
					ENDIF
				Next

				RECLOCK("TRC",.T.)
				TRC->TB_POS     := n_Pos-1 //LINHA DO ARQUIVO
				TRC->TB_PRODUTO := c_CodPro
				TRC->TB_QB      := n_QB
//				TRC->TB_MP      := c_MatPri
//				TRC->TB_QUANT   := n_Quant
				TRC->TB_OBS     := c_Obs
				MSUNLOCK()			
			Endif
		END

		FT_FUSE()
		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(n_QtdInc+n_QtdErr)) + " registros. Foram atualizados " + ALLTRIM(STR(n_QtdInc)) + " registros e " + ALLTRIM(STR(n_QtdErr)) + " registros n�o foram atualizados para a Filial " + AllTrim(cFilAnt) + " - " + AllTrim(SM0->M0_FILIAL) + ".",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'    ,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  ,'@!'})
		Aadd(a_Campos,{"TB_QB"   	,,'Quantidade Base'  ,X3Picture("B1_QB")})
//		Aadd(a_Campos,{"TB_MP"   	,,'Mat�ria Prima'  ,'@!'})
//		Aadd(a_Campos,{"TB_QUANT"   ,,'Quantidade'  ,X3Picture("G1_QUANT")})
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa��o' ,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de atualiza��o do Cadastro de Estruturas",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Salvar" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
		o_Btn:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

		o_Dlg:Activate(,,,.T.)

		DBSELECTAREA("TRC")
		TRC->(DBCLOSEAREA())
	ENDIF
Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � f_ExpLog � Autor �                  � Data �    Julho/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Exporta o log de importa��o para um arquivo texto          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_ExpLog()
	Local c_LogFile := "C:\TEMP\LOG_ESTRUTURAS_" + Dtos(DDATABASE) + "_" + Subs(Time(), 1, 2) + Subs(Time(), 4, 2) + Subs(Time(), 7, 2) + ".TXT"
	Local c_Destino := FCREATE(c_LogFile)
	Local c_Linha := ""

	// TESTA A CRIA��O DO ARQUIVO DE DESTINO
	IF c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
	 	RETURN
	ENDIF

	DBSELECTAREA("TRC")
	TRC->(DBGOTOP())
	
	Count To n_Reg
	ProcRegua(n_Reg)

	TRC->(DBGOTOP())
	WHILE !(TRC->(EOF()))
//		c_Linha:= STRZERO(TRC->TB_POS,6)+";"+TRC->TB_PRODUTO+";"+TRANSFORM(TRC->TB_QB, X3Picture("B1_QB"))+";"+TRC->TB_MP+";"+TRANSFORM(TRC->TB_QUANT, X3Picture("G1_QUANT"))+";"+TRC->TB_OBS + CHR(13)+CHR(10)
		c_Linha:= STRZERO(TRC->TB_POS,6)+";"+TRC->TB_PRODUTO+";"+TRANSFORM(TRC->TB_QB, X3Picture("B1_QB"))+";"+TRC->TB_OBS + CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo de log. Continuar?","Aten��o")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF

	 	IncProc()
	 	TRC->(DBSKIP())
	ENDDO 

	AVISO(SM0->M0_NOMECOM,"Log gerado para o arquivo " + Lower(c_LogFile), {"Ok"}, 2, "Aten��o")
	FCLOSE(c_Destino)
	DBSELECTAREA("TRC")
	DBGOTOP()
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � f_Mata220 � Autor �                 � Data �    Julho/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Executa a rotina autom�tica de saldo inicial MATA220       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function f_Mata200
	Local PARAMIXB1   := {}
	Local PARAMIXB2   := {}
	Local PARAMIXB3   := n_Opcao
	Local c_Revisao   := Space(3)
	Local aGets       := {}

    lMsErroAuto	      := .F.

	/*
	PARAMIXB1   Vetor   	Array contendo cabe�alho da Estrutura de Produtos      X     
	PARAMIXB2   Vetor   	Array contendo os itens que a estrutura possui.        X     
	PARAMIXB3   Num�rico    Op��o desejada: 3-Inclus�o; 4-Altera��o ; 5-Exclus�o 
	*/

	PARAMIXB1 := {{"G1_COD", c_CodPro, NIL},;		
				  {"G1_QUANT", n_QB, NIL},;	// Quantidade base ser� de 1 Kg	para evitar grandes distor��es nos valores
				  {"G1_TRT", c_Revisao, NIL},;
				  {"NIVALT", "S", NIL}} 	// A vari�vel NIVALT � utilizada pra recalcular ou n�o a estrutura	

		// a_Materias[i][1]   	// C�digo do produto mat�ria prima
		// a_Materias[i][2]		// Quantidade utilizada da mat�ria prima

	For i:=1 To Len(a_Materias)
		aGets := {}	
		aadd(aGets,{"G1_COD", c_CodPro, NIL})	
		aadd(aGets,{"G1_COMP", a_Materias[i][1], NIL})	
		aadd(aGets,{"G1_TRT", c_Revisao, NIL})	
		aadd(aGets,{"G1_QUANT", a_Materias[i][2], NIL})	
		aadd(aGets,{"G1_PERDA", 0, NIL})	
		aadd(aGets,{"G1_INI", DDATABASE, NIL})	
		aadd(aGets,{"G1_FIM", Stod("20301231"),NIL})	

		aadd(PARAMIXB2,aGets)
	Next

	Begin Transaction
		MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)

		If lMsErroAuto	
			MostraErro()
			DisarmTransaction()
			Return .F.
		Else
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1") + c_CodPro)
				l_Ret := .T.
			Else
				l_Ret := .F.
			Endif
		Endif
	End Transaction
Return l_Ret


Static Function f_DelEstr
	Local PARAMIXB1   := {}
	Local l_Ret       := .F.

    lMsErroAuto	      := .F.

	PARAMIXB1 := {{"G1_COD", c_CodPro, NIL},;
	 	          {"NIVALT", "S", NIL}}

	Begin Transaction
		MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,NIL,5)

		If lMsErroAuto	
			MostraErro()
			DisarmTransaction()
			Return .F.
		Else
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1") + c_CodPro)
				l_Ret := .F.
			Else
				l_Ret := .T.
			Endif
		Endif
    End Transaction
Return l_Ret
