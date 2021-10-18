#INCLUDE "MATR300.CH" 
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR300  � Autor �Alexandre Inacio Lemes � Data �21/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao das movimentacoes internas                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR300(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FMATR300()

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
//Else
//	MATR300R3()
//EndIf
                                               
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �21/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao das movimentacoes internas                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local aOrdem   := {STR0004,STR0005,STR0006,STR0007,STR0008,STR0009,STR0010,STR0011} //" Codigo Produto "###" Ordem Producao "###" Classificacao  "###" Tipo Produto   "###" Grupo Produto  "###" Centro Custo   "###" Conta Contabil "###" Nr. Documento  "
Local cTitle   := STR0001 //"Relacao das Movimentacoes Internas"
Local oReport 
Local oSection1
Local oSection2
Local lVersao := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.)) > 11)

#IFDEF TOP
	Local cAliasSD3 := GetNextAlias()
#ELSE
	Local cAliasSD3 := "SD3"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Produto inicial                              �
//� mv_par02     // Produto final                                �
//� mv_par03     // Ordem de producao inicial                    �
//� mv_par04     // Ordem de producao final                      �
//� mv_par05     // classificacao do movimento inicial           �
//� mv_par06     // classificacao do movimento final             �
//� mv_par07     // tipo do produto inicial                      �
//� mv_par08     // tipo do produto final                        �
//� mv_par09     // grupo do produto inicial                     �
//� mv_par10     // grupo do produto final                       �
//� mv_par11     // centro de custo do produto inicial           �
//� mv_par12     // centro de custo do produto final             �
//� mv_par13     // conta contabil do produto inicial            �
//� mv_par14     // conta contabil do produto final              �
//� mv_par15     // moeda selecionada ( 1 a 5 )                  �
//� mv_par16     // Data inicial                                 �
//� mv_par17     // Data final                                   �
//� mv_par18     // 1 - Analitico , 2 - Sintetico                �
//� mv_par19     // De  Local                                    �
//� mv_par20     // Ate Local                                    �
//� mv_par21     // De  Documento                                �
//� mv_par22     // Ate Documento                                �
//� mv_par23     // De  Lote                                     �
//� mv_par24     // Ate Lote                                     �
//� mv_par25     // De  SubLote                                  �
//� mv_par26     // Ate SubLote                                  �
//� mv_par27     // Imprime a Descricao do Armazem               �
//����������������������������������������������������������������
AjustaSX1()
Pergunte("MTR300",.F.)
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
oReport:= TReport():New("MTR300",cTitle,"MTR300", {|oReport| ReportPrint(oReport,aOrdem,cAliasSD3)},STR0002+" "+STR0003) //"Lista  as  movimentacoes  internas  da empresa  ,ou seja ,Requisicoes ,""Devolucoes ,Producoes e Estornos de Producao."
oReport:SetTotalInLine(.F.)
oReport:SetLandscape() 
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
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0051,{"SD3"},aOrdem) // "Produtos"
oSection1:SetTotalInLine(.F.)
oSection1:SetLineStyle()

TRCell():New(oSection1,"D3_COD"    ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_TIPO"   ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D3_GRUPO"  ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"  "        ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:= TRSection():New(oSection1,STR0052,{"SD3"}) //"Itens de Movimenta��o Interna" 
oSection2:SetTotalInLine(.F.)
oSection2:SetHeaderPage()

TRCell():New(oSection2,"D3_LOCAL"  ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
If !lVersao
	TRCell():New(oSection2,"B2_LOCALIZ" ,"SB2"," "+STR0042,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Posicione("SB2",1,xFilial("SB2")+((cAliasSD3)->D3_COD+(cAliasSD3)->D3_LOCAL),"B2_LOCALIZ")})
Else 																										
	TRCell():New(oSection2,"NNR_DESCRI","NNR",STR0042,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Posicione("NNR",1,xFilial("NNR")+((cAliasSD3)->D3_LOCAL),"NNR_DESCRI")})
EndIf
 
TRCell():New(oSection2,"QTDENTRADA","   ",STR0043,PesqPictQt("D3_QUANT",17),TamSX3("D3_QUANT")[1],/*lPixel*/,{|| If((cAliasSD3)->D3_TM <= "500" ,(cAliasSD3)->D3_QUANT, 0 ) })
TRCell():New(oSection2,"QTDSAIDA"  ,"   ",STR0044,PesqPictQt("D3_QUANT",17),TamSX3("D3_QUANT")[1],/*lPixel*/,{|| If((cAliasSD3)->D3_TM > "500",(cAliasSD3)->D3_QUANT, 0 ) })
TRCell():New(oSection2,"CUSTOUNIT" ,"   ",STR0045,PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17),/*Tamanho*/,/*lPixel*/,{|| (cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1)) / If((cAliasSD3)->D3_QUANT == 0,1,(cAliasSD3)->D3_QUANT ) })
TRCell():New(oSection2,"CUSTO"     ,"   ",STR0046,PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17),/*Tamanho*/,/*lPixel*/,{||  If((cAliasSD3)->D3_TM > "500",((cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1)))* -1,(cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1))) })
TRCell():New(oSection2,"D3_TM"     ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_CF"     ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_OP"     ,"SD3",STR0047,"@!",6,/*lPixel*/,{|| SubStr(D3_OP,1,6) }) //"Ordem Producao"
TRCell():New(oSection2,"D3_OP"     ,"SD3",STR0048,"@!",2,/*lPixel*/,{|| SubStr(D3_OP,7,2) })
TRCell():New(oSection2,"D3_OP"     ,"SD3",STR0049,"@!",3,/*lPixel*/,{|| SubStr(D3_OP,9,3) })
TRCell():New(oSection2,"D3_NUMSEQ" ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_CC"     ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_CONTA"  ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_DOC"    ,"SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_EMISSAO","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D3_USUARIO","SD3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �21/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao das movimentacoes internas                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasSD3)

Local oSection1  := oReport:Section(1) 
Local oSection2  := oReport:Section(1):Section(1)  
Local nOrdem     := oReport:Section(1):GetOrder()
Local aFileCtb   := If( CtbInUse() , { "CT1", "CTT" } , { "SI1", "SI3" } )
Local cCposCtb   := If(aFileCtb[1] = "CT1", If( nOrdem ==6 , "CTT->CTT_CUSTO + '-' + CTT->CTT_DESC" + StrZero(mv_par15, 2) , ;
                  "CT1->CT1_DESC" + StrZero(mv_par15, 2)) , If( nOrdem ==6 , "SI3->I3_CUSTO + '-' + SI3->I3_DESC", "SI1->I1_DESC"))
Local cPicD3Cust := PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
Local cChave	 := ""
Local cCodPro	 := ""
Local cKeyForTot := ""
Local cSubTotal  := ""
Local cTotaliza  := ""
Local cSubCtb    := ""
Local nProdSegEnt:= 0
Local nProdSegSai:= 0
Local nGSegEnt	 := 0
Local nGSegSai   := 0
Local nTotSegEnt := 0
Local nTotSegSai := 0
Local cWhereD3   := '%%'        
Local lVersao    := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.)) > 11)
Local lPlanilha  := oReport:nDevice == 4 // planilha
Local oSection3
	
#IFDEF TOP
	Local cOrder    := ""
#ELSE
	Local cCondicao := ""
	Local cIndexKey := ""
#ENDIF

If lPlanilha
	oSection3  := oReport:Section(2)

	oSection3:= TRSection():New(oReport,"",{"SD3"}) //"Itens de Movimenta��o Interna" 
	oSection3:SetTotalInLine(.F.)
	oSection3:lPrintHeader := .F.
	oSection3:lHeaderVisible := .F.
	
	TRCell():New(oSection3,"D3_LOCAL"  ,"SD3",/*Titulo*/,/*Picture*/									 , /*Tamanho*/		   ,/*lPixel*/ ,/*{|| code-block de impressao }*/)
	TRCell():New(oSection3,"QTDENTRADA","   ",""		 ,PesqPictQt("D3_QUANT",17)						 ,TamSX3("D3_QUANT")[1],/*lPixel*/,{|| If((cAliasSD3)->D3_TM <= "500" ,(cAliasSD3)->D3_QUANT, 0) })
	TRCell():New(oSection3,"QTDSAIDA"  ,"   ",""		 ,PesqPictQt("D3_QUANT",17)						 ,TamSX3("D3_QUANT")[1],/*lPixel*/,{|| If((cAliasSD3)->D3_TM > "500",(cAliasSD3)->D3_QUANT, 0 ) })
	TRCell():New(oSection3,"CUSTOUNIT" ,"   ",""		 ,PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17),TamSX3("D3_QUANT")[1],/*lPixel*/,{|| (cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1)) / If((cAliasSD3)->D3_QUANT == 0,1,(cAliasSD3)->D3_QUANT ) })
	TRCell():New(oSection3,"CUSTO"     ,"   ",""		 ,PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17),TamSX3("D3_QUANT")[1],/*lPixel*/,{||  If((cAliasSD3)->D3_TM > "500",((cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1)))* -1,(cAliasSD3)->&("D3_CUSTO"+Str(mv_par15,1))) })
Else
	oSection2:SetTotalText("Total Produto") //"Total Produto"  
	TRFunction():New(oSection2:Cell("QTDENTRADA"),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1)
	TRFunction():New(oSection2:Cell("QTDSAIDA"  ),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
	TRFunction():New(oSection2:Cell("CUSTO"     ),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection1) 
EndIf	

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
oReport:SetTitle(oReport:Title() + STR0040+AllTrim(aOrdem[nOrdem])+STR0041+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par15))))+")" )//" (Por "###" ,em " 

dbSelectArea("SD3")
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	
 	MakeSqlExpr(oReport:uParam)
    
 	oReport:Section(1):BeginQuery()	
 	
	If ! __lPyme 
		cWhereD3 := "%" 
		cWhereD3 += "D3_LOTECTL >= '"+mv_par23+"' AND "
		cWhereD3 += "D3_LOTECTL <= '"+mv_par24+"' AND "     
		cWhereD3 += "D3_NUMLOTE >= '"+mv_par25+"' AND "
		cWhereD3 += "D3_NUMLOTE <= '"+mv_par26+"' AND "     
		cWhereD3 += "%" 
	Endif 	
 
	Do Case
		Case nOrdem == 1
			cOrder := "% D3_FILIAL,D3_COD,D3_LOCAL,D3_NUMSEQ %"
		Case nOrdem == 2
			cOrder := "% D3_FILIAL,D3_OP,D3_COD,D3_LOCAL %"
		Case nOrdem == 3
			cOrder := "% D3_FILIAL,D3_CF,D3_COD,D3_LOCAL %"
		Case nOrdem == 4
			cOrder := "% D3_FILIAL,D3_TIPO,D3_COD,D3_LOCAL %"
		Case nOrdem == 5
			cOrder := "% D3_FILIAL,D3_GRUPO,D3_COD,D3_LOCAL %"
		Case nOrdem == 6
			cOrder := "% D3_FILIAL,D3_CC,D3_COD,D3_LOCAL %"
		Case nOrdem == 7
			cOrder := "% D3_FILIAL,D3_CONTA,D3_COD,D3_LOCAL %"
		Case nOrdem == 8
			cOrder := "% D3_FILIAL,D3_DOC,D3_COD %"
	EndCase
				

	BeginSql Alias cAliasSD3
	 
	SELECT SD3.*
	FROM %table:SD3% SD3
	 
	WHERE SD3.D3_FILIAL  = %xFilial:SD3% AND 
		SD3.D3_COD      >= %Exp:mv_par01% AND 
	    SD3.D3_COD      <= %Exp:mv_par02% AND      
	    SD3.D3_OP       >= %Exp:mv_par03% AND 
	    SD3.D3_OP       <= %Exp:mv_par04% AND          
	    SD3.D3_CF       >= %Exp:mv_par05% AND 
	    SD3.D3_CF       <= %Exp:mv_par06% AND      
	    SD3.D3_TIPO     >= %Exp:mv_par07% AND 
	    SD3.D3_TIPO     <= %Exp:mv_par08% AND      
	    SD3.D3_GRUPO    >= %Exp:mv_par09% AND 
	    SD3.D3_GRUPO    <= %Exp:mv_par10% AND          
	    SD3.D3_CC       >= %Exp:mv_par11% AND 
	    SD3.D3_CC       <= %Exp:mv_par12% AND          
	    SD3.D3_CONTA    >= %Exp:mv_par13% AND 
	    SD3.D3_CONTA    <= %Exp:mv_par14% AND      
	    SD3.D3_EMISSAO  >= %Exp:Dtos(mv_par16)% AND 
	    SD3.D3_EMISSAO  <= %Exp:Dtos(mv_par17)% AND 
	    SD3.D3_LOCAL    >= %Exp:mv_par19% AND 
	    SD3.D3_LOCAL    <= %Exp:mv_par20% AND          
	    %Exp:cWhereD3%
	    SD3.%NotDel% 
	    
	ORDER BY %Exp:cOrder%
	   
	EndSql
	
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	If lPlanilha
		oSection3:SetParentQuery()
	EndIf	
	oSection2:SetParentQuery()

#ELSE

	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'D3_FILIAL=="' + xFilial()+ '".And.'
	cCondicao += 'D3_COD>="'    + mv_par01 + '".And.D3_COD<="'    + mv_par02 + '".And.'
	cCondicao += 'D3_LOCAL>="'  + mv_par19 + '".And.D3_LOCAL<="'  + mv_par20 + '".And.'
	cCondicao += 'D3_OP>="'     + mv_par03 + '".And.D3_OP<="'     + mv_par04 + '".And.'
	cCondicao += 'D3_CF>="'     + mv_par05 + '".And.D3_CF<="'     + mv_par06 + '".And.'
	cCondicao += 'D3_TIPO>="'   + mv_par07 + '".And.D3_TIPO<="'   + mv_par08 + '".And.'
	If ! __lPyme 
		cCondicao += 'D3_LOTECTL>="'+ mv_par23 + '".And.D3_LOTECTL<="'+ mv_par24 + '".And.'
		cCondicao += 'D3_NUMLOTE>="'+ mv_par25 + '".And.D3_NUMLOTE<="'+ mv_par26 + '".And.'
	Endif	
	cCondicao += 'D3_GRUPO>="'  + mv_par09 + '".And.D3_GRUPO<="'  + mv_par10 + '".And.'
	cCondicao += 'D3_CC>="'     + mv_par11 + '".And.D3_CC<="'     + mv_par12 + '".And.'
	cCondicao += 'D3_CONTA>="'  + mv_par13 + '".And.D3_CONTA<="'  + mv_par14 + '".And.'
	cCondicao += 'DTOS(D3_EMISSAO)>="'+DTOS(mv_par16)+'".And.DTOS(D3_EMISSAO)<="'+DTOS(mv_par17)+'"'

	dbSelectArea("SD3")
	Do Case
		Case nOrdem == 1
			SD3->(dbSetOrder(3))
			cIndexKey := IndexKey()
		Case nOrdem == 2
			SD3->(dbSetOrder(1))
			cIndexKey := IndexKey()
		Case nOrdem == 3
			cIndexKey := "D3_FILIAL+D3_CF+D3_COD+D3_LOCAL"
		Case nOrdem == 4
			cIndexKey := "D3_FILIAL+D3_TIPO+D3_COD+D3_LOCAL"
		Case nOrdem == 5
			cIndexKey := "D3_FILIAL+D3_GRUPO+D3_COD+D3_LOCAL"
		Case nOrdem == 6
			cIndexKey := "D3_FILIAL+D3_CC+D3_COD+D3_LOCAL"
		Case nOrdem == 7
			cIndexKey := "D3_FILIAL+D3_CONTA+D3_COD+D3_LOCAL"
		Case nOrdem == 8
			SD3->(dbSetOrder(2))
			cIndexKey := IndexKey()
	EndCase
			
	oReport:Section(1):SetFilter(cCondicao,cIndexKey)

#ENDIF		
	
If lPlanilha
	oSection3:Cell("QTDENTRADA"):Hide()
	oSection3:Cell("QTDSAIDA"):Hide()
	oSection3:Cell("CUSTO"):Hide()                                 
	oSection3:Cell("CUSTOUNIT"):Hide()
	oSection3:Cell("D3_LOCAL"):Hide()
EndIf

If mv_par18 == 2
	oSection2:Hide()
EndIf

If mv_par27 == 2
	 If lVersao
	 	oSection2:Cell("NNR_DESCRI"):Disable()
	 Else
	 	oSection2:Cell("B2_LOCALIZ"):Disable()
	 EndIf
EndIf

Do Case
	Case nOrdem == 1
		cKeyForTot := "D3_COD"
		cSubTotal  := STR0017 //"......... Total do Produto "
	Case nOrdem == 2
		cKeyForTot := "D3_OP"
		cSubTotal  := STR0018 //"......... Total da Ordem de Producao "
	Case nOrdem == 3
		cKeyForTot := "D3_CF"
		cSubTotal  := STR0020 //"......... Total da Classificacao "
	Case nOrdem == 4
		cKeyForTot := "D3_TIPO"
		cSubTotal  := STR0021 //"......... Total do Tipo "
	Case nOrdem == 5
		cKeyForTot := "D3_GRUPO"
		cSubTotal  := STR0022 //"......... Total do Grupo "
	Case nOrdem == 6
		cKeyForTot := "D3_CC"
		cSubTotal  := STR0023 //"......... Total do Centro de Custo"
	Case nOrdem == 7
		cKeyForTot := "D3_CONTA"
		cSubTotal  := STR0024 //"......... Total da Conta"
	Case nOrdem == 8
		cKeyForTot := "D3_DOC"
		cSubTotal  := STR0025 //"......... Total do Documento "
EndCase

If lPlanilha
	oSection3:SetTotalText("Total Produto") //"Total Produto"  
	TRFunction():New(oSection3:Cell("QTDENTRADA"),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection2)
	TRFunction():New(oSection3:Cell("QTDSAIDA"  ),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection2) 
	TRFunction():New(oSection3:Cell("CUSTO"     ),NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.T.,,oSection2) 
EndIf

TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSD3)->D3_COD })
TRPosition():New(oSection1,"SB2",1,{|| xFilial("SB2") + (cAliasSD3)->D3_COD + (cAliasSD3)->D3_LOCAL })

oReport:SetPageFooter(3, {|| f_Footer(oReport, oSection2)}, .F.)

oReport:SetMeter(SD3->(LastRec()))
dbSelectArea(cAliasSD3)

While !oReport:Cancel() .And. !(cAliasSD3)->(Eof())

	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf
	
	If UPPER((cAliasSD3)->D3_DOC) < UPPER(mv_par21) .Or. UPPER((cAliasSD3)->D3_DOC) > UPPER(mv_par22)
		(cAliasSD3)->(dbSkip())
		Loop
	EndIf
	If !D3Valido(cAliasSD3)
		(cAliasSD3)->(dbSkip())
		Loop
	EndIf  
	
 	oSection1:Init()
 	oSection1:PrintLine()		

	nProdSegEnt := 0
	nProdSegSai := 0
	
	cChave := (cAliasSD3)->&(cKeyForTot) 
	cCodPro:= (cAliasSD3)->D3_COD
	
	If lPlanilha
		oSection3:Init(.F.)
	EndIf
	
 	oSection2:Init()
	While !oReport:Cancel() .And. !(cAliasSD3)->(Eof()) .And. cChave == (cAliasSD3)->&(cKeyForTot) .And. cCodPro == (cAliasSD3)->D3_COD

		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf
		
		If UPPER((cAliasSD3)->D3_DOC) < UPPER(mv_par21) .Or. UPPER((cAliasSD3)->D3_DOC) > UPPER(mv_par22)
			(cAliasSD3)->(dbSkip())
			Loop
		EndIf		
	
		If !D3Valido(cAliasSD3)
			(cAliasSD3)->(dbSkip())
			Loop
		EndIf
	
  		cTotaliza := (cAliasSD3)->&(cKeyForTot)
		
		If lPlanilha
			oSection3:PrintLine()
		EndIf
			  		          
   		oSection2:PrintLine()

		
		If (cAliasSD3)->D3_TM <= "500"
			nProdSegEnt += If(SB1->B1_CONV>0,ConvUm((cAliasSD3)->D3_COD,(cAliasSD3)->D3_QUANT,0,2),(cAliasSD3)->D3_QTSEGUM )
        Else
			nProdSegSai += If(SB1->B1_CONV>0,ConvUm((cAliasSD3)->D3_COD,(cAliasSD3)->D3_QUANT,0,2),(cAliasSD3)->D3_QTSEGUM )	
        EndIf
        
		cSubCtb := ""
		If nOrdem == 6 .Or. nOrdem == 7
			If nOrdem == 6 .And. (aFileCtb[2])->(dbSeek(xFilial(aFileCtb[2])+(cAliasSD3)->D3_CC,   .F.)) .Or. ;
			   nOrdem == 7 .And. (aFileCtb[1])->(dbSeek(xFilial(aFileCtb[1])+(cAliasSD3)->D3_CONTA,.F.))
			   cSubCtb := &(cCposCtb)
			ElseIf !Empty((cAliasSD3)->D3_CC) .Or. !Empty((cAliasSD3)->D3_CONTA)
			   cSubCtb := STR0037 // ' ** CC nao cadastrado ** '
			EndIf
		EndIf

		dbSelectArea(cAliasSD3)
		dbSkip()
			
	EndDo

	oReport:PrintText(STR0033+SB1->B1_SEGUM+ STR0034+TransForm(nProdSegEnt,cPicD3Cust)+"   "+;
	STR0035+TransForm(nProdSegSai,cPicD3Cust),,oSection1:Cell("B1_UM"):ColPos()) //"Quantidade na Seg. UM ("###"): Entrada -> "
	

	oSection1:Finish()
	nGSegEnt += nProdSegEnt 
	nGSegSai += nProdSegSai
	nTotSegEnt += nProdSegEnt 
	nTotSegSai += nProdSegSai

	If cTotaliza <> (cAliasSD3)->&(cKeyForTot) .Or. (cAliasSD3)->(Eof())

		oSection2 :SetTotalText( cSubTotal + cTotaliza + cSubCtb ) //" Subtotal das Ordens do Relatorio

		If (cAliasSD3)->(Eof())
			If nOrdem ==1
				nProdSegEnt:=nGSegEnt
				nProdSegSai:=nGSegSai
			Else
				nTotSegEnt:=nGSegEnt
				nTotSegSai:=nGSegSai
			EndIf
		EndIf
		
		If lPlanilha
			oSection3:Finish()
		EndIf
			
  		oSection2:Finish()
		If (cAliasSD3)->(Eof())
			oReport:PrintText(PadR(STR0055,Len(STR0033)+2+TamSx3('B1_SEGUM')[1])+Substr(STR0034,3)+TransForm(nGSegEnt,cPicD3Cust)+"   "+;
			STR0035+TransForm(nGSegSai,cPicD3Cust),oReport:Row()+2,oSection1:Cell("B1_UM"):ColPos())

		ElseIf nOrdem <> 1 .And. cTotaliza <> (cAliasSD3)->&(cKeyForTot)
			oReport:PrintText(Left(STR0033,Len(STR0033)-2)+Space(2+TamSx3('B1_SEGUM')[1])+"  "+Substr(STR0034,3)+TransForm(nTotSegEnt,cPicD3Cust)+"   "+;
			STR0035+TransForm(nTotSegSai,cPicD3Cust),,oSection1:Cell("B1_UM"):ColPos())
			nTotSegEnt:=0
			nTotSegSai:=0
		EndIf

  	EndIf
	
EndDo

Return Nil 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR300R3� Autor � Eveli Morasco         � Data � 02/03/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao das movimentacoes internas                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo Pim.�06/02/98�12531A�Ajuste do total geral na 2a UM.           ���
���Eduardo     �09/06/98�XXXXXX�Ajuste da variavel cmens linha 429        ���
���Rodrigo     �23/06/98�XXXXXX�Acerto no tamanho do documento para 12    ���
���            �        �      �posicoes                                  ���
���FernandoJoly�16/09/98�17338A�Ajuste da variavel cmens - a descri��o do ���
���            �        �      �CC devera corresponder ao CC correto.     ���
���FernandoJoly�10/11/98�XXXXXX�Ajuste para o Ano 2000.                   ���
���CesarValadao�19/03/99�20515A�Corre��o de totaliza��o por Centro Custo  ���
���CesarValadao�30/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���CesarValadao�29/04/99�21555A�Manutencao Lay-Out P Imprimir Cpos Maiores���
���CesarValadao�14/07/99�22097A�Acerto no Cabecalho, Custos e Totais.     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR300R3
//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local padrao de todos os relatorios           �
//����������������������������������������������������������������
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Relacao das Movimentacoes Internas"
LOCAL cDesc1   := STR0002	//"Lista  as  movimentacoes  internas  da empresa  ,ou seja ,Requisicoes ,"
LOCAL cDesc2   := STR0003	//"Devolucoes ,Producoes e Estornos de Producao."
LOCAL cDesc3   := ""
LOCAL cString  := "SD3"
LOCAL nTipo    := 0
LOCAL aOrd     := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010),OemToAnsi(STR0011)}			//" Codigo Produto "###" Ordem Producao "###" Classificacao  "###" Tipo Produto   "###" Grupo Produto  "###" Centro Custo   "###" Conta Contabil "###" Nr. Documento  "
LOCAL wnrel := "MATR300"

//��������������������������������������������������������������Ŀ
//� Variaveis privadas ,padrao de todos os relatorios            �
//����������������������������������������������������������������
PRIVATE aReturn := {OemToAnsi(STR0012), 1,OemToAnsi(STR0013), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "MTR300"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Produto inicial                              �
//� mv_par02     // Produto final                                �
//� mv_par03     // Ordem de producao inicial                    �
//� mv_par04     // Ordem de producao final                      �
//� mv_par05     // classificacao do movimento inicial           �
//� mv_par06     // classificacao do movimento final             �
//� mv_par07     // tipo do produto inicial                      �
//� mv_par08     // tipo do produto final                        �
//� mv_par09     // grupo do produto inicial                     �
//� mv_par10     // grupo do produto final                       �
//� mv_par11     // centro de custo do produto inicial           �
//� mv_par12     // centro de custo do produto final             �
//� mv_par13     // conta contabil do produto inicial            �
//� mv_par14     // conta contabil do produto final              �
//� mv_par15     // moeda selecionada ( 1 a 5 )                  �
//� mv_par16     // Data inicial                                 �
//� mv_par17     // Data final                                   �
//� mv_par18     // 1 - Analitico , 2 - Sintetico                �
//� mv_par19     // De  Local                                    �
//� mv_par20     // Ate Local                                    �
//� mv_par21     // De  Documento                                �
//� mv_par22     // Ate Documento                                �
//� mv_par23     // De  Lote                                     �
//� mv_par24     // Ate Lote                                     �
//� mv_par25     // De  SubLote                                  �
//� mv_par26     // Ate SubLote                                  �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C300Imp(aOrd,@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C300IMP  � Autor � Rodrigo de A. Sartorio� Data � 12.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR300                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C300Imp(aOrd,lEnd,WnRel,cString,tamanho,titulo)

//��������������������������������������������������������������Ŀ
//� Variaveis locais especificas deste relatorio                 �
//����������������������������������������������������������������
LOCAL cRodaTxt 	:= STR0014		//"MOVIMENTO(S)"
LOCAL nCntImpr 	:= 0
LOCAL nProdEnt,nProdSai,nProdVal,nQuebraEnt,nQuebraSai,nQuebraVal,nGeralEnt,nGeralSai,nGeralVal,nQSegEnt,nQSegSai,nGSegEnt,nGSegSai
LOCAL cCampoCus  ,lPassou1  ,nCntProd   ,cCompCampo ,lImprime  ,cCodAnt
LOCAL nCusto ,nCM, cDet := ''
LOCAL nIndex ,cSeek  
Local aEntCt    := If(CtbInUse(), { "CT1", "CTT" }, { "SI1", "SI3" })
Local cEntCpo 	:= If(aEntCt[1] = "CT1", If(aReturn[8]==6,;
					"CTT->CTT_CUSTO + '-' + CTT->CTT_DESC" + StrZero(mv_par15, 2),;
					"CT1->CT1_DESC" + StrZero(mv_par15, 2)),;
					If(aReturn[8]==6,;
					"SI3->I3_CUSTO + '-' + SI3->I3_DESC", "SI1->I1_DESC"))
Local lDescArm  := .F. 
Local nTamDoc   := TamSX3("D3_DOC")[1]
Local lVersao   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.)) > 11)
Local cLocaliz  := "" 

//��������������������������������������������������������������Ŀ
//� Variaveis privadas especificas deste relatorio               �
//����������������������������������������������������������������
PRIVATE cCondicao ,cCondSec ,cNomArq ,lContinua

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li := 80 ,m_pag := 1

//��������������������������������������������������������������Ŀ
//� Verifica se deve comprimir ou nao                            �
//����������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
If Type("NewHead")#"U"
	NewHead += STR0040+AllTrim(aOrd[aReturn[8]])+STR0041+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par15))))+")" //" (Por "###" ,em "
Else
	Titulo  += STR0040+AllTrim(aOrd[aReturn[8]])+STR0041+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par15))))+")" //" (Por "###" ,em "
EndIf

//��������������������������������������������������������������Ŀ
//� Monta o cabecalho do relatorio                               �
//����������������������������������������������������������������
//"ALMOXARIFADO                    QUANTIDADE                            CUSTO                 CUSTO    TIPO DE     TIPO    ORDEM DE IT SEQ    CENTRO              CONTA           DOCUMENTO       EMISSAO      NOME DO"
//"                      ENTRADA                   SAIDA              UNITARIO                 TOTAL    MOVIMENTO   RE/DE   PRODUCAO           CUSTO              CONTABIL                                      USUARIO"
// XX            99,999,999,999.99       99,999,999,999.99         99,999,999,999.99     99,999,999,999.99       123        123     123456   12 123    123456789    123456789012345   123456        12/12/12    XXXXXXXXXXXXXXX
// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
If nTamDoc > 13 
	Cabec1 := STR0015+If(mv_par18==1, STR0053, "")
	Cabec2 := STR0016+If(mv_par18==1, STR0054, "")
Else
	Cabec1 := STR0015+If(mv_par18==1, STR0038, "")
	Cabec2 := STR0016+If(mv_par18==1, STR0039, "")
Endif

dbSelectArea("SD3")

cFiltro := "D3_FILIAL=='"+xFilial()+"'.And."
cFiltro += "D3_COD>='"+mv_par01+"'.And.D3_COD<='"+mv_par02+"'.And."
cFiltro += "D3_LOCAL>='"+mv_par19+"'.And.D3_LOCAL<='"+mv_par20+"'.And."
cFiltro += "D3_OP>='"+mv_par03+"'.And.D3_OP<='"+mv_par04+"'.And."
cFiltro += "D3_CF>='"+ mv_par05+"'.And.D3_CF<='"+mv_par06+"'.And."
If ! __lPyme 
	cFiltro += "D3_LOTECTL>='"+mv_par23+"'.And. D3_LOTECTL<='"+mv_par24+"'.And."
	cFiltro += "D3_NUMLOTE>='"+mv_par25+"'.And. D3_NUMLOTE<='"+mv_par26+"'.And."
Endif	
cFiltro += "D3_TIPO>='"+mv_par07+"'.And. D3_TIPO<='"+mv_par08+"'"
#IFDEF TOP
	cFiltro += ".And.D3_GRUPO>='"+mv_par09+"'.And.D3_GRUPO<='"+mv_par10+"'.And."
	cFiltro += "D3_CC>='"+mv_par11+"'.And.D3_CC<='"+mv_par12+"'.And."
	cFiltro += "D3_CONTA>='"+mv_par13+"'.And.D3_CONTA<='"+mv_par14+"'.And."
	cFiltro += "DTOS(D3_EMISSAO)>='"+DTOS(mv_par16)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(mv_par17)+"'"
#ENDIF	

Do Case
	Case aReturn[8] == 1
		cNomArq := CriaTrab("",.F.)
		Set Order To 3
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019) 		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par01
		cCondicao  := "lContinua .And. !EOF() .And. D3_COD <= mv_par02"
		cCondSec   := "D3_COD == cVar"
		cCompCampo := "D3_COD"
		cMens      := STR0017 //"......... Total do Produto "
	Case aReturn[8] == 2
		cNomArq := CriaTrab("",.F.)
		Set Order To 1
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019) 		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par03
		cCondicao  := "lContinua .And. !EOF() .And. D3_OP <= mv_par04"
		cCondSec   := "D3_OP == cVar"
		cCompCampo := "D3_OP"
		cMens      := STR0018 //"......... Total da Ordem de Producao "
	Case aReturn[8] == 3
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CF+D3_COD+D3_LOCAL",,cFiltro,STR0019)			//"Selecionando Registros..."
		cSeek :=cFilial+mv_par05
		cCondicao  := "lContinua .And. !EOF() .And. D3_CF <= mv_par06"
		cCondSec   := "D3_CF == cVar"
		cCompCampo := "D3_CF"
		cMens      := STR0020 //"......... Total da Classificacao "
	Case aReturn[8] == 4
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_TIPO+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek := cFilial+mv_par07
		cCondicao  := "lContinua .And. !EOF() .And. D3_TIPO <= mv_par08"
		cCondSec   := "D3_TIPO == cVar"
		cCompCampo := "D3_TIPO"
		cMens      := STR0021 //"......... Total do Tipo "
	Case aReturn[8] == 5
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_GRUPO+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek := cFilial+mv_par09
		cCondicao  := "lContinua .And. !EOF() .And. D3_GRUPO <= mv_par10"
		cCondSec   := "D3_GRUPO == cVar"
		cCompCampo := "D3_GRUPO"
		cMens      := STR0022 //"......... Total do Grupo "
	Case aReturn[8] == 6
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CC+D3_COD+D3_LOCAL",,cFiltro,STR0019)			//"Selecionando Registros..."
		cSeek :=cFilial+mv_par11
		cCondicao  := "lContinua .And. !EOF() .And. D3_CC <= mv_par12"
		cCondSec   := "D3_CC == cVar"
		cCompCampo := "D3_CC"
		cMens      := STR0023 //"......... Total do Centro de Custo"
	Case aReturn[8] == 7
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CONTA+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par13
		cCondicao  := "lContinua .And. !EOF() .And. D3_CONTA <= mv_par14"
		cCondSec   := "D3_CONTA == cVar"
		cCompCampo := "D3_CONTA"
		cMens      := STR0024 //"......... Total da Conta"
	Case aReturn[8] == 8
		Set Order To 2
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek :=cFilial
		cCondicao  := "lContinua .And. !EOF() "
		cCondSec   := "D3_DOC == cVar"
		cCompCampo := "D3_DOC"
		cMens      := STR0025 //"......... Total do Documento "
EndCase

nIndex := RetIndex("SD3")
#IFNDEF TOP
	dbSetIndex(cNomArq+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
SetRegua(RecCount())		// Total de Elementos da regua

//��������������������������������������������������������������������������Ŀ
//� Define o campo a ser impresso no valor de acordo com a moeda selecionada �
//����������������������������������������������������������������������������
cCampoCus := "SD3->D3_CUSTO"+Str(mv_par15,1)

Store 0 To nGeralEnt,nGeralSai,nGeralVal,nGSegEnt,nGSegSai
lContinua := .T.
dbSeek(cSeek,.T.)
While &(cCondicao) .and. cFilial == D3_FILIAL
	
	cVar := &(cCompCampo)
	
	Store 0 To nQuebraEnt,nQuebraSai,nQuebraVal,nQSegEnt,nQSegSai
	lPassou1 := .F.
	
	If UPPER(D3_DOC) < UPPER(mv_par21) .Or. UPPER(D3_DOC) > UPPER(mv_par22)
		dbSkip()
		Loop
	EndIf
	While &cCondicao .And. &cCondSec .and. cFilial == D3_FILIAL
		
		cCodAnt := D3_COD
		Store 0 To nProdEnt,nProdSai,nProdVal,nProdSegEnt,nProdSegSai
		nCntProd := 0
		lImprime := .T.
		While &(cCondicao) .And. &(cCondSec) .And. D3_COD == cCodAnt .and. cFilial == D3_FILIAL
			
			If lEnd
				@ PROW()+1,001 PSay STR0026		//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
			
			IncRegua()
			
			#IFNDEF TOP
				If D3_GRUPO < mv_par09 .Or. D3_GRUPO > mv_par10
					dbSkip()
					Loop
				EndIf
				
				If D3_CC < mv_par11 .Or. D3_CC > mv_par12
					dbSkip()
					Loop
				EndIf
				
				If D3_CONTA < mv_par13 .Or. D3_CONTA > mv_par14
					dbSkip()
					Loop
				EndIF
				
				If D3_EMISSAO < mv_par16 .Or. D3_EMISSAO > mv_par17
					dbSkip()
					Loop
				EndIf
			#ENDIF	

			If UPPER(D3_DOC) < UPPER(mv_par21) .Or. UPPER(D3_DOC) > UPPER(mv_par22)
				dbSkip()
				Loop
			EndIf

			If !D3Valido()
				dbSkip()
				Loop
			EndIf
			
			If !Empty(aReturn[7]) .And. ! &(aReturn[7])
				dbSkip()
				Loop
			Endif

			If li > 58
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				lImprime := .T.
			EndIf
			
			If lImprime
				dbSelectArea("SB1")
				dbSeek(cFilial+SD3->D3_COD)
				If mv_par27 == 1
					If !lVersao
						lDescArm := SB2->(MsSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL)) .And. !Empty(SB2->B2_LOCALIZ)
						cLocaliz := SB2->B2_LOCALIZ
					Else
						lDescArm := NNR->(MsSeek(xFilial("NNR")+SD3->D3_LOCAL)) .And. !Empty(NNR->NNR_DESCRI)
						cLocaliz := NNR->NNR_DESCRI						
					EndIf
				EndIf
				@ li,000 PSay STR0027+B1_COD+STR0028+SubStr(B1_DESC,1,30)+STR0029+B1_TIPO+STR0030+SD3->D3_GRUPO+STR0031+B1_UM+' '+IIF(lDescArm,STR0042+SD3->D3_LOCAL+" - "+cLocaliz,"")	//"Codigo : "###"   Descricao : "###"   Tipo : "###"   Grupo : "###"   UM : "##"   Armazem : "###############"
				IF mv_par18 == 1
					li += 2
				Endif
				dbSelectArea("SD3")
				lImprime := .F.
			EndIf
			
			//�������������������������������������������������������Ŀ
			//� Adiciona 1 ao contador de registros impressos         �
			//���������������������������������������������������������
			nCntImpr++
			nCusto := &(cCampoCus)
			nCM    := nCusto / Iif(D3_QUANT == 0,1,D3_QUANT)
			IF mv_par18 == 1
				@ Li,000 PSay D3_LOCAL
				If D3_TM <= "500"
					@ Li,013 PSay D3_QUANT Picture PesqPictQt("D3_QUANT",17)
				Else
					@ Li,037 PSay D3_QUANT Picture PesqPictQt("D3_QUANT",17)
				EndIf
				@ Li,053 PSay nCm			Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				@ Li,075 PSay nCusto		Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				@ Li,099 - If(nTamdoc > 13,  5, 0) PSay D3_TM 
				@ Li,109 - If(nTamdoc > 13,  7, 0) PSay D3_CF 
				@ Li,116 - If(nTamdoc > 13, 10, 0) PSay SubStr(D3_OP,1,6)  Picture "@!"
				@ Li,125 - If(nTamdoc > 13, 10, 0) PSay SubStr(D3_OP,7,2)  Picture "@!"
				@ Li,128 - If(nTamdoc > 13, 10, 0) PSay SubStr(D3_OP,9,3)  Picture "@!"
				@ Li,135 - If(nTamdoc > 13, 10, 0) PSay D3_NUMSEQ
				@ Li,142 - If(nTamdoc > 13, 10, 0) PSay D3_CC
				@ Li,163 - If(nTamdoc > 13, 10, 0) PSay D3_CONTA
				@ Li,184 - If(nTamdoc > 13, 10, 0) PSay D3_DOC
				@ Li,194 - If(nTamdoc > 13,  2, 0) PSay D3_EMISSAO
				@ Li,205 - If(nTamdoc > 13,  2, 0) PSay D3_USUARIO
				Li++
			Endif
			lPassou1 := .T.
			
			If D3_TM <= "500"
				nProdEnt  += D3_QUANT
				nProdVal  += nCusto
			Else
				nProdSai  += D3_QUANT
				nProdVal  -= nCusto
			EndIf
			nCntProd++
			dbSkip()
		EndDo
		
		If aReturn[8] != 1
			IF nCntProd > 1 .or. (mv_par18 == 2 .and. nCntProd > 0)
				Li++
				@ Li,013 PSay nProdEnt Picture PesqPictQt("D3_QUANT",17)
				@ Li,037 PSay nProdSai Picture PesqPictQt("D3_QUANT",17)
				@ Li,075 PSay nProdVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				If mv_par18 == 1
					@ Li,100 PSay STR0032 	//"TOT"
				Endif
				@ Li,120 PSay STR0033+SB1->B1_SEGUM+STR0034		//"Quantidade na Seg. UM ("###"): Entrada -> "
				nProdSegEnt :=ConvUm(SB1->B1_COD,nProdEnt,0,2)
				@ Li,159 PSay nProdSegEnt Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				@ Li,180 PSay STR0035	//"Saida -> "
				nProdSegSai :=ConvUm(SB1->B1_COD,nProdSai,0,2)
				@ Li,189 PSay nProdSegSai Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				Li++
				IF mv_par18 == 1
					@ Li,000 PSay __PrtThinLine()
					Li++
				Endif
			Endif
		ElseIf nCntProd == 1 .And. aReturn[8] != 1 .and. mv_par18 == 1
			@ Li,000 PSay __PrtThinLine()
			Li++
		EndIf
		
		nQuebraEnt += nProdEnt
		nQuebraSai += nProdSai
		nQuebraVal += nProdVal
		nQSegEnt   += nProdSegEnt
		nQSegSai   += nProdSegSai
		
	EndDo
	
	If lPassou1
		If aReturn[8] == 1
			Li++
			@ Li,013 PSay nQuebraEnt Picture PesqPictQt("D3_QUANT",17)
			@ Li,037 PSay nQuebraSai Picture PesqPictQt("D3_QUANT",17)
			@ Li,075 PSay nQuebraVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
			@ Li,100 PSay  STR0032		//"TOT"
			@ Li,120 PSay STR0033+SB1->B1_SEGUM+STR0034		//"Quantidade na Seg. UM ("###"): Entrada -> "
			nQSegEnt := ConvUm(SB1->B1_COD,nQuebraEnt,0,2)
			@ Li,159 PSay nQSegEnt	Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
			@ Li,180 PSay STR0035	//"Saida -> "
			nQSegSai := ConvUm(SB1->B1_COD,nQuebraSai,0,2)
			@ Li,189 PSay nQSegSai	Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
			Li++
			@ Li,000 PSay __PrtThinLine()
			Li++
		Else
			@ Li,013 PSay nQuebraEnt Picture PesqPictQt("D3_QUANT",17)
			@ Li,037 PSay nQuebraSai Picture PesqPictQt("D3_QUANT",17)
			@ Li,075 PSay nQuebraVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
			
			cDet := ''
			If aReturn[8] == 6 .Or. aReturn[8] == 7
				If aReturn[8]==6 .And. (aEntCt[2])->(dbSeek(xFilial(aEntCt[2])+cVar,.F.)) .Or. ;
					aReturn[8]==7 .And. (aEntCt[1])->(dbSeek(xFilial(aEntCt[1])+cVar,.F.))
					cDet := &(cEntCpo)
				ElseIf !Empty(cVar)
					cDet := STR0037 // ' ** CC nao cadastrado ** '
				EndIf
			EndIf
			
			@ Li,099 PSay cMens + cDet
			Li++
			
			@ Li,000 PSay __PrtThinLine()
			Li += 2
			
			dbSelectArea("SD3")
		EndIf
	EndIf
	
	nGeralEnt += nQuebraEnt
	nGeralSai += nQuebraSai
	nGeralVal += nQuebraVal
	nGSegEnt  += nQSegEnt
	nGSegSai  += nQSegSai
	
EndDo

If nCntImpr > 0
  	If li > 58
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ Li,013 PSay nGeralEnt Picture PesqPictQt("D3_QUANT",17)
	@ Li,037 PSay nGeralSai Picture PesqPictQt("D3_QUANT",17)
	@ Li,075 PSay nGeralVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
	@ Li,099 PSay STR0036		//"<- TOTAL GERAL ->"
	@ Li,159 PSay nGSegEnt Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
	@ Li,189 PSay nGSegSai Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)	
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve as ordens originais do arquivo                       �
//����������������������������������������������������������������
RetIndex("SD3")
dbClearFilter()
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Apaga indice de trabalho                                     �
//����������������������������������������������������������������
Ferase(cNomArq+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Marcos V. Ferreira    � Data �30.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()
Local aArea := GetArea()
Local aHelpPor :={} 
Local aHelpEng :={} 
Local aHelpSpa :={} 
Local nTamSX1  :=Len(SX1->X1_GRUPO)
     
//Correcao de Ortografia do MV_PAR18
If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"18"))
	RecLock("SX1",.F.)
	Replace SX1->X1_DEF01   With "Analitico"
	Replace SX1->X1_DEFSPA2 With "Analitico"
    Replace SX1->X1_DEF02   With "Sintetico"
    Replace SX1->X1_DEFSPA2 With "Sintetico"
	MsUnLock()
EndIf

PutSx1('MTR300','23','De Lote                      ?','�De Lote                     ?','From Lot                     ?', ;  
'mv_chn','C',10,0,0,'G','','','','N','mv_par23','','','','','','','','','','','','','','','','', ;                                     
{'Lote Inicial a ser considerado na filtr ','agem da impressao do relatorio.         '}, ;                        
{'                                        ','                                        '}, ;                        
{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

PutSx1('MTR300','24','Ate Lote                     ?','�A Lote                      ?','To Lot                       ?', ;  
'mv_cho','C',10,0,0,'G','','','','N','mv_par24','','','','ZZZZZZZZZZ','','','','','','','','','','','','', ;                                     
{'Lote Final a ser considerado na filtrage','m da impressao do relatorio.            '}, ;                        
{'                                        ','                                        '}, ;                        
{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

PutSx1('MTR300','25','De Sub-Lote                  ?','�De Sub-Lote                 ?','From Sub-Lot                 ?', ;  
'mv_chp','C',6,0,0,'G','','','','N','mv_par25','','','','','','','','','','','','','','','','', ;                                     
{'Sub-Lote Inicial a ser considerado na fi','ltragem da impressao do relatorio.      '}, ;                        
{'                                        ','                                        '}, ;                        
{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

PutSx1('MTR300','26','Ate Sub-Lote                 ?','�A Sub-Lote                  ?','To Sub-Lot                   ?', ;  
'mv_chq','C',6,0,0,'G','','','','N','mv_par26','','','','ZZZZZZ','','','','','','','','','','','','', ;                                     
{'Sub-Lote Final a ser considerado na filt','ragem da impressao do relatorio.        '}, ;                        
{'                                        ','                                        '}, ;                        
{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

/*-----------------------MV_PAR27--------------------------*/
Aadd( aHelpPor, "Imprime descricao do Armazem. Sim ou Nao" )

Aadd( aHelpEng, "Print warehouse description. Yes or No  " )

Aadd( aHelpSpa, "Imprime descripcion del almacen. Si o No" ) 

PutSx1( "MTR300","27","Imprime descricao do Armazem ?","Imprime descripc. del almacen?","Print warehouse description ?","mv_chr",;
"N",1,0,2,"C","","","","","mv_par27","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

If __lPyme 
	//Retirada as perguntas de 23 a 26 referente a rastreabilidade para a pyme
	If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"23"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PYME With "N"
		MsUnLock()
	EndIf
	If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"24"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PYME With "N"
		MsUnLock()
	EndIf
	If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"25"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PYME With "N"
		MsUnLock()
	EndIf
	If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"26"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PYME With "N"
		MsUnLock()
	EndIf		
Endif

If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"21")) .And. SX1->X1_TAMANHO <> TamSX3('D1_DOC')[1]
	RecLock("SX1",.F.)
	Replace SX1->X1_TAMANHO With TamSX3('D1_DOC')[1]
	MsUnLock()
EndIf

If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"22")) .And. SX1->X1_TAMANHO <> TamSX3('D1_DOC')[1]
	RecLock("SX1",.F.)
	Replace SX1->X1_TAMANHO With TamSX3('D1_DOC')[1]
	MsUnLock()
EndIf

If SX1->(DbSeek (PADR("MTR300",nTamSX1)+"16"))
	RecLock("SX1",.F.)
	Replace SX1->X1_PERSPA With "�De Fecha ?"
	MsUnLock()
EndIf

RestArea(aArea)
Return

Static Function f_Footer(oReport, oSection2)
	n_Linha := oReport:Row()

	oReport:PrintText("______________________", n_Linha, oSection2:Cell("D3_LOCAL"):ColPos())
	oReport:PrintText("______________________", n_Linha, oSection2:Cell("D3_OP"):ColPos())
	oReport:PrintText("______________________", n_Linha, oSection2:Cell("D3_USUARIO"):ColPos())

	oReport:IncRow()
	n_Linha := oReport:Row()

	oReport:PrintText("     Conferente", n_Linha,oSection2:Cell("D3_LOCAL"):ColPos())
	oReport:PrintText("     Matr�cula", n_Linha,oSection2:Cell("D3_OP"):ColPos())
	oReport:PrintText("     Data/Hora", n_Linha,oSection2:Cell("D3_USUARIO"):ColPos())
Return