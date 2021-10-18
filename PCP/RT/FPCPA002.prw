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
���Programa  �FPCPA002  �Autor  �                    � Data �             ���
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

User Function FPCPA002()
	Local c_Texto  := "Esta rotina tem a finalidade de atualizar o Pos.IPI/NCM da tabela SB1 - Cadastro de Produtos, a partir do arquivo CSV selecionado  pelo usu�rio."
	Local c_Erro   := "� necess�rio selecionar o arquivo CSV para efetuar essa opera��o."

	Private c_File  := Space(500)	//Arquivo

	SetPrvt("oDlg1","oSay1","oSay2","oGet1","oBtn1","oBtn2","oBtn3","oGrp1")

	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 090,230,198,670,SM0->M0_NOME,,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 006,004,{||"Arquivo:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 004,025,{|u| if( Pcount( )>0, c_File := u, u := c_File) },oDlg1,151,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)

	oBtn1      := TButton():New( 004,180,"&Procurar...",oDlg1,{||c_File:=cGetFile( 'Arquivos CSV |*.csv|' , '', 1, '', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE),.T., .T. ) },037,12,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 021,180,"&Importar",oDlg1,{|| iif(Empty(c_File), ShowHelpDlg("Valida��o de Arquivo",{c_Erro},5,{"Selecione um arquivo CSV v�lido."},5), f_MontaRegua())},037,12,,,,.T.,,"",,,,.F. )
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
	Processa({|| f_ImportaDados()}, "Aguarde...", "Importando os dados do arquivo...",.F.)
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
	Private c_Filial := ""
	Private c_CodPro := ""
    Private c_Desc   := ""
	Private c_NcmAnt := ""
	Private c_Ncm    := ""
	Private c_Obs    := ""

	Private l_CriaTb := .F.  //Controla a criacao da tabela temporaria
	Private c_Bord   := ""   //Borda da tabela tempor�ria
	Private a_Bord   := {}   //Array da tabela tempor�ria
	Private a_Campos := {}   //Campos da tabela tempor�ria
	Private oFont    := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	IF AVISO(SM0->M0_NOMECOM,"Esta rotina ir� atualizar o Pos.IPI/NCM da tabela SB1 - Cadastro de Produtos. Deseja realmente continuar?",{"Sim","N�o"},2,"Aten��o") == 1
		IF !l_CriaTb
			Aadd(a_Bord,{"TB_POS"  	  ,"N",6,0})
			Aadd(a_Bord,{"TB_FILIAL"  ,"C",TamSX3("B1_FILIAL")[1],0})
			Aadd(a_Bord,{"TB_PRODUTO" ,"C",TamSX3("B1_COD")[1],0})
			Aadd(a_Bord,{"TB_DESC"    ,"C",TamSX3("B1_DESC")[1],0})
			Aadd(a_Bord,{"TB_NCMANT"  ,"C",TamSX3("B1_POSIPI")[1],0})
			Aadd(a_Bord,{"TB_NCM"     ,"C",TamSX3("B1_POSIPI")[1],0})
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
			c_Buffer := FT_FREADLN()
			c_Buffer := StrTran(c_Buffer, ";;", "; ;")
		  	//���������������������������������������������������������������������������������Ŀ
			//�STRTOKARR:                                                                       �
			//�Funcao utilizada para retornar um array, de acordo com os dados passados como    �
			//�parametro para a funcao. Esta funcao recebe uma string <cValue> e um caracter    �
			//�<cToken> que representa um separador, e para toda ocorrencia deste separador     �
			//�em <cValue> e adicionado um item no array.                                       �
			//�����������������������������������������������������������������������������������  
			a_Buffer:= STRTOKARR(c_Buffer,";")        

			c_Filial := PADR(UPPER(AllTrim(a_Buffer[1])), TAMSX3("B1_FILIAL")[1])  		// Filial do produto
			c_CodPro := PADR(UPPER(AllTrim(a_Buffer[2])), TAMSX3("B1_COD")[1])  		// C�digo do produto
			c_NcmAnt := ""												   				// Pos.IPI/NCM do produto
			c_Ncm    := PADR(UPPER(AllTrim(a_Buffer[5])), TAMSX3("B1_POSIPI")[1])		// Novo Pos.IPI/NCM do produto
			c_Obs    := ""

			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(c_Filial + c_CodPro)
			IF FOUND()
				c_NcmAnt := SB1->B1_POSIPI
				c_Desc   := SB1->B1_DESC
		    	n_QtdInc++

				If Upper(AllTrim(c_Ncm)) == "BLOQUEAR"
					RECLOCK("SB1", .F.)
					SB1->B1_MSBLQL := '1'
					MSUNLOCK()

					c_Obs  := "Produto " + AllTrim(c_CodPro) + " foi bloqueado pela rotina, porque o Pos.IPI/NCM cadastrado � inv�lido."
				Else
					RECLOCK("SB1", .F.)
					SB1->B1_POSIPI := c_Ncm
					MSUNLOCK()

					c_Obs  := "Pos.IPI/NCM do Produto " + AllTrim(c_CodPro) + " foi atualizado pela rotina."
				Endif
			ELSE
		    	n_QtdErr++
				c_Obs  := "Pos.IPI/NCM do Produto " + AllTrim(c_CodPro) + " n�o foi atualizado pela rotina, porque o Produto " + AllTrim(c_CodPro) + " n�o est� cadastrado no sistema."
			ENDIF

			RECLOCK("TRC",.T.)
			TRC->TB_POS     := n_Pos //LINHA DO ARQUIVO
			TRC->TB_FILIAL  := c_Filial
			TRC->TB_PRODUTO := c_CodPro
			TRC->TB_DESC    := c_Desc
			TRC->TB_NCMANT  := c_NcmAnt
			TRC->TB_NCM     := IIF(Upper(AllTrim(c_Ncm)) == "BLOQUEAR", c_NcmAnt, c_Ncm)
			TRC->TB_OBS     := c_Obs
			MSUNLOCK()

			FT_FSKIP()
			n_Pos++
			IncProc()
		END

		FT_FUSE()
		AVISO(SM0->M0_NOME,"O programa processou todo o arquivo com " + ALLTRIM(STR(n_QtdInc+n_QtdErr)) + " registros. Foram atualizados " + ALLTRIM(STR(n_QtdInc)) + " registros e " + ALLTRIM(STR(n_QtdErr)) + " registros n�o foram atualizados pela rotina.",{"OK"},2,"Aviso")

		//SE HOUVE PRODUTOS ATUALIZADOS, MOSTRA NA TELA.
		DBSELECTAREA("TRC")
		TRC->(DBGOTOP())

	 	Aadd(a_Campos,{"TB_POS"     ,,'Linha'    ,'@!'})
		Aadd(a_Campos,{"TB_FILIAL"  ,,'Filial'   ,'@!'})
		Aadd(a_Campos,{"TB_PRODUTO" ,,'Produto'  ,'@!'})
		Aadd(a_Campos,{"TB_DESC"    ,,'Descri��o'  ,'@!'})
		Aadd(a_Campos,{"TB_NCMANT"  ,,'Pos.IPI/NCM Anterior'  ,X3Picture("B1_POSIPI")})
		Aadd(a_Campos,{"TB_NCM"   	,,'Pos.IPI/NCM'  ,X3Picture("B1_POSIPI")})
		Aadd(a_Campos,{"TB_OBS"     ,,'Observa��o' ,'@!'})

		o_Dlg:= MSDialog():New( 091,232,637,1240,"Log de Atualiza��o de Pos.IPI/NCM da tabela SB1 - Cadastro de Produtos",,,.F.,,,,,,.T.,,,.T. )
		o_Say := TSay():New( 004,004,{||"Total de Registros: "+ ALLTRIM(STR(n_QtdInc+n_QtdErr))},o_Dlg,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,008)
		o_Brw:= MsSelect():New( "TRC","","",a_Campos,.F.,"",{015,000,240,507},,, o_Dlg )
		o_Btn:= TButton():New( 253,10,"Log p/ Texto" ,o_Dlg,{|| Processa( {|| f_ExpLog()} ) },041,012,,,,.T.,,"",,,,.F. )
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
	Local c_Destino := FCREATE("C:\TEMP\LOG_ATUALIZACAO_POSIPI_NCM.TXT")
	Local c_Linha := ""

	// TESTA A CRIA��O DO ARQUIVO DE DESTINO
	IF c_Destino == -1
		MsgStop('Erro ao criar arquivo destino. Erro: '+str(ferror(),4),'Erro')
	 	RETURN
	ENDIF

	c_Linha:= "LINHA ;   FILIAL;   "+Padr("PRODUTO", TamSX3('B1_COD')[1])+";   "+Padr("DESCRICAO", TamSX3('B1_COD')[1])+";   "+Padr("NCMANT", TamSX3('B1_COD')[1])+";   "+Padr("NCM", TamSX3('B1_COD')[1])+";   "+Padr("OBSERVACAO", TamSX3('B1_COD')[1]) + CHR(13)+CHR(10)

	IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
		IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
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
		c_Linha:= STRZERO(TRC->TB_POS,6)+";   "+TRC->TB_FILIAL+";   "+TRC->TB_PRODUTO+";   "+TRC->TB_DESC+";   "+TRC->TB_NCMANT+";   "+TRC->TB_NCM+";   "+TRC->TB_OBS + CHR(13)+CHR(10)

		IF FWRITE(c_Destino,c_Linha,LEN(c_Linha)) != LEN(c_Linha)
			IF !MSGALERT("Ocorreu um erro na grava��o do arquivo destino. Continuar?","Aten��o")
				FCLOSE(c_Destino)
				DBSELECTAREA("TRC")
				DBGOTOP()
	   	   		Return
			ENDIF
	 	ENDIF
	 	
	 	IncProc()
	 	TRC->(DBSKIP())
	ENDDO 

	AVISO(SM0->M0_NOMECOM,"Log exportado para o arquivo C:\TEMP\LOG_ATUALIZACAO_POSIPI_NCM.TXT",{"Ok"},2,"Aten��o")
	FCLOSE(c_Destino)
	DBSELECTAREA("TRC")
	DBGOTOP()
Return