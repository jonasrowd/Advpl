#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  JOBBX002  บAutor  ณ                    บ Data ณ			  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma responsavel por importacao de dados do SIGMA       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAPCP                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JOBBX002()

Local c_Texto  := "Esta rotina tem a finalidade de importar dados do SIGMA para o Apontamento de Horas Improdutivas do PROTHEUS"

SetPrvt("oDlg1","oSay1","oBtn1","oBtn2","oGrp1")


If Select("SX6") == 0
	Conout("Inicio  : "+Time())
	Conout(OemToAnsi("JOB - Sistema de SIGMA - IMPORTAวรO") )
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SH6"
	cAmbiente := GetEnvServer()
	f_JobImporta()
Else

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	oDlg1      := MSDialog():New( 090,230,180,670,SM0->M0_NOMECOM,,,.F.,,,,,,.T.,,,.T. )

	oBtn1      := TButton():New( 004,180,"&Importar",oDlg1,{|| f_MontaRegua()},037,12,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 021,180,"&Sair",oDlg1,{|| oDlg1:End()},037,12,,,,.T.,,"",,,,.F. )

	oGrp1      := TGroup():New( 004,004,040,176,"Descri็ใo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 014,016,{||c_Texto},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,036)

	oDlg1:Activate(,,,.T.)
EndIf


//FINALIZA A CONEXAO

If Select("SX6") == 0
	Conout(OemToAnsi("Job Sistema de SIGMA/IMPORTAวรO executado!")  )	
	RESET ENVIRONMENT
Endif	
	
Return()

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ f_MontaRegua บAutor  ณ                     บ Data ณ		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a montagem da r้gua de processamento				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
*/

Static Function f_MontaRegua()

If Select("SX6") == 0
	f_JobImporta()
Else
	Processa({|| f_Importa()}, "Aguarde...", "Importando os dados do SIGMA...",.F.)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_Importa     บAutor  ณ                บ Data ณ Julho/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao resposnavel pela leitura do arquivo texto e gravacao บฑฑ
ฑฑบ          ณdos dados                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_Importa()
	Local a_Vetor       := {}
	Local c_Alias       := GetNextAlias()
	Local c_Query       := ""

	Private lMsErroAuto := .F.
	Private n_Pos       := 1     //Numero da linha do arquivo
	Private n_QtdInc    := 0    	//Conta quantas linhas foram importadas
	Private n_QtdErr    := 0    	//Conta quantas linhas nใo foram importadas	
	Private c_Obs       := ""

	Private c_Bord   := ""   //Borda da tabela temporแria
	Private a_Bord   := {}   //Array da tabela temporแria
	Private a_Campos := {}   //Campos da tabela temporแria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM, "Esta rotina tem a finalidade de importar dados do SIGMA para o Apontamento de Horas Improdutivas do PROTHEUS. Deseja realmente continuar?",{"Sim","Nใo"},2,"Aten็ใo") == 1
		Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
		Aadd(a_Bord,{"TB_TURNO"   ,"C",TamSX3("H6_FSTURNO")[1],0})
		Aadd(a_Bord,{"TB_RECURSO" ,"C",TamSX3("H6_RECURSO")[1],0})
		Aadd(a_Bord,{"TB_DATAINI" ,"D",TamSX3("H6_DATAINI")[1],0})
		Aadd(a_Bord,{"TB_DATAFIN" ,"D",TamSX3("H6_DATAFIN")[1],0})
		Aadd(a_Bord,{"TB_HORAINI" ,"C",TamSX3("H6_HORAINI")[1],0})
		Aadd(a_Bord,{"TB_HORAFIN" ,"C",TamSX3("H6_HORAFIN")[1],0})
		Aadd(a_Bord,{"TB_MOTIVO"  ,"C",TamSX3("H6_MOTIVO")[1],0})
		Aadd(a_Bord,{"TB_OPERADO" ,"C",TamSX3("H6_OPERADO")[1],0})
		Aadd(a_Bord,{"TB_DETALHE" ,"C",50,0})
		Aadd(a_Bord,{"TB_OBS"     ,"C",250,0})

		c_Bord := CriaTrab(a_Bord,.t.)
		Use &c_Bord Shared Alias TRC New
		Index On TB_POS To &c_Bord

		SET INDEX TO &c_Bord

		BeginSql Alias c_Alias
			SELECT * FROM Sigma_Monitor.dbo.INTEGRA_PROTHEUS WHERE (STATUS_INTEGRA <> 'S' OR STATUS_INTEGRA IS NULL )
		EndSql

		dbSelectArea(c_Alias)
		dbGoTop()
		If (c_Alias)->(EoF())
			AVISO(SM0->M0_NOMECOM,"Nenhum registro foi encontrado para ser importado pela rotina.",{"OK"},2,"Aviso")
		Else
			ProcRegua((c_Alias)->(RecCount()))
			dbGoTop()
			While (c_Alias)->(!EoF())
				Begin Transaction
					IF ((c_Alias)->DATA_INI == (c_Alias)->DATA_FIM) .AND. ((c_Alias)->HORA_INI == (c_Alias)->HORA_FIM)
						n_QtdErr++
						c_Obs := "REGISTRO INVมLIDO PARA IMPORTAวรO, POIS ESTม COM DATA INICIAL IGUAL A DATA FINAL E HORA INICIAL IGUAL A HORA FINAL"
					ELSE
						a_Vetor := {{"H6_RECURSO", PADR((c_Alias)->OBJ_CODIGO, TamSX3("H6_RECURSO")[1]), NIL},;
								   {"H6_FILIAL", XFILIAL("SH6"), NIL},;
								   {"H6_FSTURNO", PADR((c_Alias)->TURNO, TAMSX3("H6_FSTURNO")[1]), NIL},;
								   {"H6_DETALHE", (c_Alias)->DETALHES, NIL},;
								   {"H6_MOTIVO",  PADR((c_Alias)->MOT_CODIGO, TAMSX3("H6_FSTURNO")[1]), NIL},;
								   {"H6_DTAPONT", dDataBase, NIL},;
								   {"H6_DATAINI", STOD((c_Alias)->DATA_INI), NIL},;
								   {"H6_DATAFIN", STOD((c_Alias)->DATA_FIM), NIL},;
								   {"H6_HORAINI", (c_Alias)->HORA_INI, NIL},;
								   {"H6_OPERADO", UPPER((c_Alias)->USUARIO), NIL},;
								   {"H6_HORAFIN", (c_Alias)->HORA_FIM, NIL}}

						MSExecAuto({|x,y| Mata682(x,y)}, a_Vetor, 3)
	
						If lMsErroAuto
							n_QtdErr++
							MostraErro()
							c_Obs := "ERRO NA IMPORTAวรO DO REGISTRO"
						Else
							c_Query := " UPDATE Sigma_Monitor.dbo.INTEGRA_PROTHEUS SET STATUS_INTEGRA = 'S' WHERE CODIGO = " + cValToChar((c_Alias)->CODIGO)
				
							While TcSqlExec(c_Query) < 0
								TcSqlExec(c_Query)
							End
							
							n_QtdInc++
							c_Obs := "REGISTRO IMPORTADO COM SUCESSO"
						Endif
					ENDIF


				End Transaction
				
				RECLOCK("TRC",.T.)
				TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
				TRC->TB_TURNO   := (c_Alias)->TURNO
				TRC->TB_RECURSO := (c_Alias)->OBJ_CODIGO
				TRC->TB_DATAINI := STOD((c_Alias)->DATA_INI)
				TRC->TB_HORAINI := (c_Alias)->HORA_INI
				TRC->TB_DATAFIN := STOD((c_Alias)->DATA_FIM)
				TRC->TB_HORAFIN := (c_Alias)->HORA_FIM
				TRC->TB_MOTIVO  := (c_Alias)->MOT_CODIGO
				TRC->TB_OPERADO := UPPER((c_Alias)->USUARIO)
				TRC->TB_DETALHE := (c_Alias)->DETALHES
				TRC->TB_OBS     := UPPER(c_Obs)
				MSUNLOCK()

				n_Pos++
				IncProc()
				(c_Alias)->(dbSkip())
			End
			
			AVISO(SM0->M0_NOMECOM,"O programa processou " + ALLTRIM(STR(n_QtdInc+n_QtdErr)) + " registros. Foram efetuadas " + ALLTRIM(STR(n_QtdInc)) + " importa็๕es e " + ALLTRIM(STR(n_QtdErr)) + " importa็๕es nใo foram realizadas.",{"OK"},2,"Aviso")

			//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
			
			DBSELECTAREA("TRC")
			TRC->(DBGOTOP())

		 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'      	,'@!'})
			Aadd(a_Campos,{"TB_TURNO"   ,,'Turno'     	,'@!'})
			Aadd(a_Campos,{"TB_RECURSO" ,,'Recurso'		,'@!'})
			Aadd(a_Campos,{"TB_DATAINI" ,,'Data Inicial','@D'})
			Aadd(a_Campos,{"TB_HORAINI" ,,'Hora Inicial','@!'})
			Aadd(a_Campos,{"TB_DATAFIN" ,,'Data Final' 	,'@D'})
			Aadd(a_Campos,{"TB_HORAFIN" ,,'Hora Final' 	,'@!'})
			Aadd(a_Campos,{"TB_MOTIVO"  ,,'Motivo'	 	,'@!'})
			Aadd(a_Campos,{"TB_OPERADO" ,,'Operador' 	,'@!'})		
			Aadd(a_Campos,{"TB_DETALHE" ,,'Detalhamento','@!'})				
			Aadd(a_Campos,{"TB_OBS"     ,,'Observa็ใo' 	,'@!'})

			o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Importa็๕es",,,.F.,,,,,,.T.,,,.T. )
			o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
			o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
			o_Btn:= TButton():New( 253,10,"Salvar" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
			o_Btn:= TButton():New( 253,60,"Sair"   ,o_Dlg,{|| o_Dlg:End() },041,012,,,,.T.,,"",,,,.F. )

			o_Dlg:Activate(,,,.T.) 
			
		
			

			DBSELECTAREA("TRC")
			TRC->(DBCLOSEAREA())
		Endif

		(c_Alias)->(dbCloseArea())
	ENDIF
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณd   บAutor  ณ  TB001        บ Data ณ Julho/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao resposnavel pela leitura do arquivo texto e gravacao บฑฑ
ฑฑบ          ณdos dados                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_JobImporta()
	Local a_Vetor       := {}
	Local c_Alias       := GetNextAlias()
	Local c_Query       := ""

	Private lMsErroAuto := .F.
	Private n_Pos       := 1     //Numero da linha do arquivo
	Private n_QtdInc    := 0    	//Conta quantas linhas foram importadas
	Private n_QtdErr    := 0    	//Conta quantas linhas nใo foram importadas	
	Private c_Obs       := ""

	Private c_Bord   := ""   //Borda da tabela temporแria
	Private a_Bord   := {}   //Array da tabela temporแria
	Private a_Campos := {}   //Campos da tabela temporแria

	Conout(OemToAnsi("Executando - JOB - Sistema de SIGMA - IMPORTAวรO"))

		Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
		Aadd(a_Bord,{"TB_TURNO"   ,"C",TamSX3("H6_FSTURNO")[1],0})
		Aadd(a_Bord,{"TB_RECURSO" ,"C",TamSX3("H6_RECURSO")[1],0})
		Aadd(a_Bord,{"TB_DATAINI" ,"D",TamSX3("H6_DATAINI")[1],0})
		Aadd(a_Bord,{"TB_DATAFIN" ,"D",TamSX3("H6_DATAFIN")[1],0})
		Aadd(a_Bord,{"TB_HORAINI" ,"C",TamSX3("H6_HORAINI")[1],0})
		Aadd(a_Bord,{"TB_HORAFIN" ,"C",TamSX3("H6_HORAFIN")[1],0})
		Aadd(a_Bord,{"TB_MOTIVO"  ,"C",TamSX3("H6_MOTIVO")[1],0})
		Aadd(a_Bord,{"TB_OPERADO" ,"C",TamSX3("H6_OPERADO")[1],0})
		Aadd(a_Bord,{"TB_DETALHE" ,"C",50,0})
		Aadd(a_Bord,{"TB_OBS"     ,"C",250,0})

		c_Bord := CriaTrab(a_Bord,.t.)
		Use &c_Bord Shared Alias TRC New
		Index On TB_POS To &c_Bord

		SET INDEX TO &c_Bord

		BeginSql Alias c_Alias
			SELECT * FROM Sigma_Monitor.dbo.INTEGRA_PROTHEUS WHERE (STATUS_INTEGRA <> 'S' OR STATUS_INTEGRA IS NULL )
		EndSql

		dbSelectArea(c_Alias)
		dbGoTop()
		If (c_Alias)->(EoF())
			Conout("Nenhum registro foi encontrado para ser importado pela rotina.")
		Else
			ProcRegua((c_Alias)->(RecCount()))
			dbGoTop()
			While (c_Alias)->(!EoF())
				Begin Transaction
					IF ((c_Alias)->DATA_INI == (c_Alias)->DATA_FIM) .AND. ((c_Alias)->HORA_INI == (c_Alias)->HORA_FIM)
						n_QtdErr++
						c_Obs := "REGISTRO INVมLIDO PARA IMPORTAวรO, POIS ESTม COM DATA INICIAL IGUAL A DATA FINAL E HORA INICIAL IGUAL A HORA FINAL"
					ELSE
						a_Vetor := {{"H6_RECURSO", PADR((c_Alias)->OBJ_CODIGO, TamSX3("H6_RECURSO")[1]), NIL},;
								   {"H6_FILIAL", XFILIAL("SH6"), NIL},;
								   {"H6_FSTURNO", PADR((c_Alias)->TURNO, TAMSX3("H6_FSTURNO")[1]), NIL},;
								   {"H6_DETALHE", (c_Alias)->DETALHES, NIL},;
								   {"H6_MOTIVO",  PADR((c_Alias)->MOT_CODIGO, TAMSX3("H6_FSTURNO")[1]), NIL},;
								   {"H6_DTAPONT", dDataBase, NIL},;
								   {"H6_DATAINI", STOD((c_Alias)->DATA_INI), NIL},;
								   {"H6_DATAFIN", STOD((c_Alias)->DATA_FIM), NIL},;
								   {"H6_HORAINI", (c_Alias)->HORA_INI, NIL},;
								   {"H6_OPERADO", UPPER((c_Alias)->USUARIO), NIL},;
								   {"H6_HORAFIN", (c_Alias)->HORA_FIM, NIL}}

						MSExecAuto({|x,y| Mata682(x,y)}, a_Vetor, 3)
	
						If lMsErroAuto
							n_QtdErr++
							MostraErro()
							c_Obs := "ERRO NA IMPORTAวรO DO REGISTRO"
						Else
							c_Query := " UPDATE Sigma_Monitor.dbo.INTEGRA_PROTHEUS SET STATUS_INTEGRA = 'S' WHERE CODIGO = " + cValToChar((c_Alias)->CODIGO)
				
							While TcSqlExec(c_Query) < 0
								TcSqlExec(c_Query)
							End
							
							n_QtdInc++
							c_Obs := "REGISTRO IMPORTADO COM SUCESSO"
						Endif
					ENDIF


				End Transaction
				
				RECLOCK("TRC",.T.)
					TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
					TRC->TB_TURNO   := (c_Alias)->TURNO
					TRC->TB_RECURSO := (c_Alias)->OBJ_CODIGO
					TRC->TB_DATAINI := STOD((c_Alias)->DATA_INI)
					TRC->TB_HORAINI := (c_Alias)->HORA_INI
					TRC->TB_DATAFIN := STOD((c_Alias)->DATA_FIM)
					TRC->TB_HORAFIN := (c_Alias)->HORA_FIM
					TRC->TB_MOTIVO  := (c_Alias)->MOT_CODIGO
					TRC->TB_OPERADO := UPPER((c_Alias)->USUARIO)
					TRC->TB_DETALHE := (c_Alias)->DETALHES
					TRC->TB_OBS     := UPPER(c_Obs)
				MSUNLOCK()

				n_Pos++
				IncProc()
				(c_Alias)->(dbSkip())
			End
			
			Conout("O programa processou " +;
			ALLTRIM(STR(n_QtdInc+n_QtdErr)) +;
			" registros. Foram efetuadas " +;
			ALLTRIM(STR(n_QtdInc)) + ;
			" importa็๕es e " +;
			ALLTRIM(STR(n_QtdErr)) +;
			" importa็๕es nใo foram realizadas."+c_Obs)

		   	f_ExpLog()
		Endif

		(c_Alias)->(dbCloseArea())
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ f_ExpLog บ Autor ณ                  บ Data ณ    Julho/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta o log de importa็ใo para um arquivo texto          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑศออออออออออสออออออออออออออออออสอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function f_ExpLog()
	Local c_Dir     := ""
	Local c_File    := "LOG_INTEGRACAO_SIGMA_PROTHEUS_" + DTOS(DDATABASE) + "_" + SUBSTR(STRTRAN(TIME(),":"),1,6) + ".CSV"
	Local c_Linha   := "" 
	
	
	If Select("SX6") == 0
		c_Dir := "C:\bomix\"
	Else		
        c_Dir := cGetFile( '*.*' , '', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY, GETF_LOCALHARD, GETF_NETWORKDRIVE), .F., .T. )
	EndIf

	If !Empty(c_Dir)
		c_Destino := FCREATE(c_Dir + c_File)

		// TESTA A CRIAวรO DO ARQUIVO DE DESTINO
		IF c_Destino == -1
		
			If Select("SX6") == 0
				Conout('Erro ao criar arquivo destino. Erro: '+str(ferror(),4))
			Else
				MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
			EndIf
		 	RETURN
		ENDIF
	
		c_Linha:= "REGISTRO;TURNO;RECURSO;DATA INICIAL;HORA INICIAL;DATA FINAL;HORA FINAL;MOTIVO;OPERADOR;DETALHAMENTO;OBSERVAวรO" + CHR(13)+CHR(10)
	
		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF
	
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())
		
		Count To n_Reg
		ProcRegua(n_Reg)
	
		TRC->(DBGOTOP())
		WHILE !(TRC->(EOF()))
			c_Linha:= STRZERO(TRC->TB_POS,6)+";"+TRC->TB_TURNO+";"+TRC->TB_RECURSO+";"+DTOC(TRC->TB_DATAINI)+";"+TRC->TB_HORAINI+";"+DTOC(TRC->TB_DATAFIN)+";"+TRC->TB_HORAFIN+";"+TRC->TB_MOTIVO+";"+TRC->TB_OPERADO+";"+TRC->TB_DETALHE+";"+TRC->TB_OBS + CHR(13)+CHR(10)

			IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			
				If Select("SX6") == 0
					Conout("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?")
					FCLOSE(c_Destino)
					DBSELECTAREA("TRC")
					DBGOTOP()
					Return
				Else
					IF !MSGALERT("Ocorreu um erro na grava็ใo do arquivo destino. Continuar?","Aten็ใo")
						FCLOSE(c_Destino)
						DBSELECTAREA("TRC")
						DBGOTOP()
						Return
					ENDIF
				Endif
		 	ENDIF
		 	
		 	IncProc()
		 	TRC->(DBSKIP())
		ENDDO 
	
		If Select("SX6") == 0
			Conout("Arquivo exportado para " + c_Dir + c_File)
		Else
			AVISO(SM0->M0_NOMECOM,"Arquivo exportado para " + c_Dir + c_File,{"Ok"},2,"Aten็ใo")
		EndIf
		
		FCLOSE(c_Destino)
		DBSELECTAREA("TRC")
		DBGOTOP()
	Endif
Return
