#INCLUDE "MATR235.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MATR235   � Autor �Felipe Nunes Toledo    � Data � 12/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de Perda.                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������           
*/
User Function FMATR235()
Local   oReport
Private cAliasSBC

//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
oReport:= ReportDef()
oReport:PrintDialog()

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Felipe Nunes Toledo    � Data �12/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR235			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
Local oReport
Local oSection
Local c_Perg := "FMATR235"

CriaPerg(c_Perg)
Pergunte(c_Perg,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("FMATR235",OemToAnsi(STR0001),c_Perg, {|oReport| ReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Emite a relacao das perdas em producao no sistema, de acordo com a ordem selecionada pelo usuario. Relaciona as perdas de Scrap e Refugo que foram classificadas."
If(TamSX3("BC_PRODUTO")[1]<=15,oReport:SetPortrait(),oReport:SetLandscape())  //Define a orientacao de pagina.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  OP								         �
//� mv_par02     // Ate OP									     �
//� mv_par03     // De  Produto                                  �
//� mv_par04     // Ate Produto                                  �
//� mv_par05     // De  Recurso                                  �
//� mv_par06     // Ate Recurso                                  �
//� mv_par07     // De  Motivo                                   �
//� mv_par08     // Ate Motivo                                   �
//� mv_par09     // De  Data                                     �
//� mv_par10     // Ate Data                                     �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oSection)                                          �
//����������������������������������������������������������������
oSection := TRSection():New(oReport,OemToAnsi(STR0001),{"SBC"}) //"Relatorio de Perda"
oSection:SetHeaderPage()
oSection:SetTotalInLine(.F.)

TRCell():New(oSection,'BC_OP'	  	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_LOCORIG' 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_PRODUTO' 	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B1_DESC' 	,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'B1_QB' 		,'SB1',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,'BC_QUANT'  	,'SBC',/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:= TRSection():New(oSection,"Requisi��es da Perda",{"SG1","SB1"},/*aOrdem*/)

oSection1:SetCellBorder("ALL",,,.T.)
oSection1:SetCellBorder("RIGHT")
oSection1:SetCellBorder("LEFT")

TRCell():New(oSection1,"G1_COMP"    ,"SG1","Produto",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSG1)->G1_COMP },,,,,,.F.)
TRCell():New(oSection1,"B1_DESC"    ,"SB1","Descri��o",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| (cAliasSG1)->DESCRI },,,,,,.F.)
TRCell():New(oSection1,"G1_QUANT"	,"SG1","Quantidade Estrutura",X3Picture("G1_QUANT"),16,/*lPixel*/,{|| (cAliasSG1)->G1_QUANT },,,,,,.F.)
TRCell():New(oSection1,"G1_QUANT"	,"SG1","Quantidade por Unidade",X3Picture("G1_QUANT"),16,/*lPixel*/,{|| (cAliasSG1)->G1_QPU },,,,,,.F.)
TRCell():New(oSection1,"QUANT"      ,"SG1","Quantidade Requisitada",X3Picture("G1_QUANT"),16,/*lPixel*/,{|| nQuant },"RIGHT",,"RIGHT")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Felipe Nunes Toledo  � Data �12/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR825			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oSection  := oReport:Section(1)
Local oSection1 := oReport:Section(1):Section(1)
Local oBreak
Local oFunction
Local cOrderBy

//�������������������Ŀ
//�Defininco a Quebra �
//���������������������
oBreak := TRBreak():New(oSection,oSection:Cell("BC_OP"),STR0023+STR0014,.T.) // "Total da OP:"

//����������������������������������������������������������������Ŀ
//�Totalizando as Horas Produtivas / Improdutivas conforme a Quebra�
//������������������������������������������������������������������
oFunction := TRFunction():New(oSection:Cell('BC_QUANT'),NIL,"SUM",oBreak,/*Titulo*/,/*Picture*/,/*uFormula*/,.F.,.F.) // Total

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Query do relatorio da secao 1                                           �
//��������������������������������������������������������������������������
	
oSection:BeginQuery()	
	
cAliasSBC := GetNextAlias()
    
//��������������������������������������������������������������Ŀ
//� Order by de acordo com a ordem selecionada.                  �
//����������������������������������������������������������������
   
cOrderBy := "%"
cOrderBy += " BC_FILIAL, BC_OP "	//"da OP:"
cOrderBy += "%"
	
BeginSql Alias cAliasSBC

	SELECT BC_OP, BC_PRODUTO, BC_LOCORIG, SUM(BC_QUANT) BC_QUANT
	
	FROM %table:SBC% SBC

	WHERE BC_FILIAL = %xFilial:SBC%		 AND 
  		  BC_OP    	  >= %Exp:mv_par01%	 AND 
	 	  BC_OP       <= %Exp:mv_par02%	 AND 
  		  BC_DATA     >= %Exp:Dtos(mv_par03)% AND
	 	  BC_DATA     <= %Exp:Dtos(mv_par04)% AND
  		  BC_LOCORIG  >= %Exp:mv_par05% AND
	 	  BC_LOCORIG  <= %Exp:mv_par06% AND
  		  BC_PRODUTO  >= %Exp:mv_par07% AND
	 	  BC_PRODUTO  <= %Exp:mv_par08% AND
  		  BC_RECURSO  >= %Exp:mv_par09% AND
	 	  BC_RECURSO  <= %Exp:mv_par10% AND
 		  SBC.%NotDel%
    GROUP BY BC_FILIAL, BC_OP, BC_PRODUTO, BC_LOCORIG

	ORDER BY %Exp:cOrderBy%

EndSql 

oSection:EndQuery()
//��������������������������Ŀ
//�Posicionamento das tabelas�
//����������������������������
TRPosition():New(oSection,"SB1",1,{|| xFilial("SB1")+(cAliasSBC)->BC_PRODUTO })

//��������������������������������Ŀ
//�Inicio da impressao do relatorio�
//����������������������������������

oSection:Init()
While (cAliasSBC)->(!EoF()) .AND. !oReport:Cancel()
	If oReport:Cancel()
		Exit
	EndIf

	oSection:PrintLine()
	oReport:IncMeter()

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:Section(1):uParam)
	
	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������
		
	oSection1:BeginQuery()	
		
	cAliasSG1 := GetNextAlias()
	    
	//��������������������������������������������������������������Ŀ
	//� Order by de acordo com a ordem selecionada.                  �
	//����������������������������������������������������������������
	   
	cOrderBy := "%"
	cOrderBy += " G1_COD, G1_COMP "
	cOrderBy += "%"
		
	BeginSql Alias cAliasSG1
	
		SELECT (G1_QUANT/B1.B1_QB) G1_QPU, SB1.B1_DESC DESCRI, SB1.B1_TIPODEC TIPODEC, * FROM %table:SG1% SG1 
		JOIN  %table:SB1% B1 ON B1_FILIAL = %xFilial:SB1% AND B1_COD = G1_COD AND B1.%NotDel%
		JOIN  %table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND SB1.B1_COD = G1_COMP AND SB1.%NotDel%

		WHERE G1_FILIAL = %xFilial:SG1%		 AND 
		 	  G1_COD    = %Exp:oSection:Cell("BC_PRODUTO"):GetText()%	 AND 
	 		  SG1.%NotDel%
	
		ORDER BY %Exp:cOrderBy%
				
	EndSql 

	oSection1:EndQuery()
	
	a_AreaSB1 := SB1->(GetArea())

	nQB := Posicione("SB1", 1, xFilial("SB1") + oSection:Cell("BC_PRODUTO"):GetText(), "B1_QB")

	RestArea(a_AreaSB1)

	oSection1:Init()
	While (cAliasSG1)->(!EoF()) .AND. !oReport:Cancel()
		If oReport:Cancel()
			Exit
		EndIf

		nQuant := NoRound((Val(StrTran(oSection:Cell("BC_QUANT"):GetText(), "."))/nQB) * (cAliasSG1)->G1_QUANT, 5)

		If (cAliasSG1)->TIPODEC == "I"
			If nQuant - Int(nQuant) > 0
				nQuant := Int(nQuant) + 1
			Endif
		Endif

		oSection1:PrintLine()	
		(cAliasSG1)->(dbSkip())
	End
	oSection1:Finish()	
	(cAliasSG1)->(dbCloseArea())

    oReport:SkipLine()
	(cAliasSBC)->(dbSkip())
End

oSection:Finish()
(cAliasSBC)->(dbCloseArea())

Return NIL



Static Function CriaPerg(c_Perg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
 	PutSx1(c_Perg,"01","OP de?"  	 ,"","","mv_ch1","C",13,0,0,"G","","SC2","","","mv_par01","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"02","OP at�?" 	 ,"","","mv_ch2","C",13,0,0,"G","","SC2","","","mv_par02","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"03","Data de?"    ,"","","mv_ch3","D",08,0,0,"G","",""   ,"","","mv_par03","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"04","Data at�?"   ,"","","mv_ch4","D",08,0,0,"G","",""   ,"","","mv_par04","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"05","Local de?" 	 ,"","","mv_ch5","C",02,0,0,"G","","NNR","","","mv_par05","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"06","Local at�?"	 ,"","","mv_ch6","C",02,0,0,"G","","NNR","","","mv_par06","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"07","Produto de?" ,"","","mv_ch7","C",TamSX3("B1_COD")[1],0,0,"G","","SB1","","","mv_par07","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"08","Produto at�?","","","mv_ch8","C",TamSX3("B1_COD")[1],0,0,"G","","SB1","","","mv_par08","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"09","Recurso de?" ,"","","mv_ch9","C",TamSX3("BC_RECURSO")[1],0,0,"G","","SH1","","","mv_par09","","","","","","","","","","","","","","","","")
 	PutSx1(c_Perg,"10","Recurso at�?","","","mv_cha","C",TamSX3("BC_RECURSO")[1],0,0,"G","","SH1","","","mv_par10","","","","","","","","","","","","","","","","")
Return Nil