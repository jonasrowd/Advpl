#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} FESTR005
RELATำRIO DE ORDEM DE PRODUวรO II ALTERADO A PARTIR DO FESTR002 PARA UTILIZAวรO NA SOPRO.
COMENTมRIO NO LOCAL DE ALTERAวรO.
@type function
@version  12.1.25
@author Jonas Machado
@since 01/07/2021
/*/
User Function FESTR005

Private c_Titulo := "ORDEM DE PRODUวรO"
Private c_Data   := dtoc(DDATABASE)
Private c_Hora   := Time()
Private c_Qry    := ''

CriaPerg("FESTR002")

If !(Pergunte("FESTR002",.T.))
	Return
EndIf

RptStatus({|| ImpRel()},c_titulo)

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPREL    บAutor  ณCHRISTIAN ROCHA     บ Data ณ   DEZ/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que imprime o relatorio                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function ImpRel()     
	//TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
	Private oFont01n	:= TFont():New( "Arial",,18,,.T.,,,,,.F.,.F.) 
	Private oFont02		:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.F.) 
	Private oFont02i	:= TFont():New( "Arial",,12,,.F.,,,,,.F.,.T.)
	Private oFont03		:= TFont():New( "Arial",,14,,.F.,,,,,.F.,.F.)
	Private oFont03n	:= TFont():New( "Arial",,14,,.T.,,,,,.F.,.F.)
	Private oFont04		:= TFont():New( "Arial",,08,,.F.,,,,,.F.,.F.) 
	Private oFont04n	:= TFont():New( "Arial",,08,,.T.,,,,,.F.,.F.)
	Private oFont05		:= TFont():New( "Arial",,10,,.F.,,,,,.F.,.F.) 

	Private c_BitMap 	:= "\system\lgrl01.bmp"
	Private n_Lin
	Private n_QuantP	:= 0
	Private n_Pag		:= 1
	Private L			:= 1
	Private n_TotPag	:= 1 //Total de Paginas
	Private l_Rodape    := .F.

	f_Qry()    //Chama a fun็ใo para gerar a query
		
	TCQUERY c_Qry NEW ALIAS QRY
	dbSelectArea("QRY")
	dbGoTop()

	If Eof()
		Alert("Nenhum registro encontrado.")
		QRY->(dbCloseArea())
		Return
	End If

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPara contar a quantidade de paginas, tive que imprimir os dados no relatorio, excluir o objetoณ
	//ณoPrn, recriแ-lo e imprimir tudo novamente.                                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For L := 1 TO 2
		oPrn := TMSPrinter():New("ORDEM DE PRODUวรO")
		oPrn:SetPortrait()  

	 	If L == 2
			oPrn:Setup()
	 	EndIf
	
		oPrn:StartPage()
		dbGoTop()

		While !Eof()
			c_NumOp := QRY->(C2_NUM + C2_ITEM + C2_SEQUEN)
			c_Desc  := QRY->B1_DESC
			
			ImpCabec() //Imprime o cabecalho	

			If L == 2
				oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
			EndIf

			QRY->(dbSkip())
			
			If !Eof() .And. QRY->(C2_NUM + C2_ITEM + C2_SEQUEN) <> c_NumOp
				oPrn:EndPage()
				n_Pag++
			Endif
		End

		If L == 2
			oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)
		EndIf
		
		oPrn:EndPage()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAqui eu reincio as variaveis e guardo a quantidade de paginas.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If L == 1                                                              
			n_TotPag	:= n_Pag
			n_Pag		:= 1
			oPrn:ResetPrinter()  //Exclui o objeto e reinicia suas propriedades.
			oPrn:End()
		Else
			oPrn:Preview()
		EndIf
	Next
	
	QRY->(dbCloseArea())
	
Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณIMPCABEC  บAutor  ณ CHRISTIAN ROCHA    บ Data   ณ DEZ/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabecalho da Ordem de Produ็ใo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function ImpCabec()     

oPrn:SayBitmap( 100,100,c_BitMap,540,150)
oPrn:Say(100,1000, "DATA DE CONTROLE:" ,oFont02,100)
oPrn:Say(200,800, "ORDEM DE PRODUวรO Nบ " + c_NumOp	,oFont01n,100)
oPrn:Say(100,1830, "Pแgina",oFont02,100)
oPrn:Say(150,1830, "Data:   " + c_Data + "   " + c_Hora,oFont02,100) 

oPrn:Line( 275,100,275,2350 )

oPrn:Say(300, 100, "Produto: " ,oFont02i,100)  
oPrn:Say(300, 280, AllTrim(QRY->C2_PRODUTO) + " - "	+ MemoLine(c_Desc,50,1),oFont02,100)  
oPrn:Say(350, 280, MemoLine(c_Desc,50,2),oFont02,100)  

oPrn:Say(300, 1770,"Quantidade: "	,oFont02i,100)  
oPrn:Say(300, 2010,AllTrim(Transform(QRY->C2_QUANT, "@E 999,999,999"))	,oFont02,100)  

oPrn:Say(400, 100, "Recurso: "	,oFont02i,100)
oPrn:Say(400, 280, IIF(Empty(QRY->C2_RECURSO), AllTrim(QRY->G2_RECURSO), AllTrim(QRY->C2_RECURSO)) + " - "	+ AllTrim(QRY->H1_DESCRI),oFont02,100)
oPrn:Say(350, 1770, "Saldo เ Produzir:",oFont02i,100)
oPrn:Say(350, 2100, AllTrim(Transform(QRY->C2_QUANT - QRY->C2_QUJE, "@E 999,999,999")),oFont02,100)
oPrn:Say(400 ,1770,"Qtd por Embalagem: "		,oFont02i,100)
oPrn:Say(400 ,2170,AllTrim(Transform(QRY->C2_FSQTDPE, "@E 999,999,999"))	,oFont02,100)

oPrn:Say(450, 100, "Ferramenta: "	,oFont02i,100)
oPrn:Say(450, 340, AllTrim(QRY->G2_FERRAM) + " - "	+ QRY->H4_DESCRI,oFont02,100)
oPrn:Say(450, 1300, "Opera็ใo: ",oFont02i,100)
oPrn:Say(450, 1510, AllTrim(QRY->G2_OPERAC) + " - " + QRY->G2_DESCRI,oFont02,100)

oPrn:Line( 500,100,500,2350 )

oPrn:Say(510 ,100 , "PRODUวรO:"				,oFont03n,100)
oPrn:Say(510 ,410 , "TURNO: _____"	,oFont05,100)
oPrn:Say(510 ,730 , "DATA: ___/ ___/ _____ "	,oFont05,100)
oPrn:Say(510 ,1720, "DOSAGENS MASTER:  _____"	,oFont05,100)

oPrn:Say(560 ,100, "INอCIO: ___/ ___/ _____   ___:___"							,oFont05,100)
oPrn:Say(610 ,100, "CONTADOR INอCIO: __________"							,oFont05,100)
oPrn:Say(560 ,1720, "TEMPO DE CICLO:   _____"	,oFont05,100)

oPrn:Say(560 ,730, "FINAL : ___/ ___/ _____   ___:___"							,oFont05,100)
oPrn:Say(610 ,730, "CONTADOR FINAL : __________=__________"							,oFont05,100)
oPrn:Say(610 ,1720, "TOTAL BORRA (Kg): _____"	,oFont05,100)

oPrn:Line( 675,100,675,1100 )	//Linha horizontal 1
oPrn:Line( 750,100,750,1100 )   //Linha horizontal 2
oPrn:Line( 825,100,825,1100 )	//Linha horizontal 3

oPrn:Line( 675,100,825,100 )	//Linha vertical 1
oPrn:Line( 675,200,825,200 )   	//Linha vertical 2
oPrn:Line( 675,500,825,500 )	//Linha vertical 3
oPrn:Line( 675,800,825,800 )	//Linha vertical 4
oPrn:Line( 675,1100,825,1100 )	//Linha vertical 5

oPrn:Say(675 ,300, "A"							,oFont02,100)
oPrn:Say(675 ,600, "C"							,oFont02,100)
oPrn:Say(675 ,900, "D"	,oFont02,100)

oPrn:Say(750 ,100, " Qtd."	,oFont02,100)

oPrn:Line( 675,1450,675,1650 )	//Linha horizontal 1
oPrn:Line( 750,1450,750,1650 )  //Linha horizontal 2
oPrn:Line( 825,1450,825,1650 )	//Linha horizontal 3

oPrn:Line( 675,1450,825,1450 )	//Linha vertical 1
oPrn:Line( 675,1650,825,1650 )  //Linha vertical 2

oPrn:Say(675 ,1450, "  TOTAL"							,oFont02,100)

oPrn:Line( 675,1720,675,1970 )	//Linha horizontal 1
oPrn:Line( 750,1720,750,1970 )  //Linha horizontal 2
oPrn:Line( 825,1720,825,1970 )	//Linha horizontal 3

oPrn:Line( 675,1720,825,1720 )	//Linha vertical 1
oPrn:Line( 675,1970,825,1970 ) 	//Linha vertical 2

oPrn:Say(675 ,1720, "  PESO (D)"							,oFont02,100)

oPrn:Line( 850,100,850,2350 )

oPrn:Say(875,100, "VERIFICAวีES"	,oFont03n,100)				//VERIFICAวีES

oPrn:Say(925,100, "Nํvel do Lubrificante: ( )Alto   ( )Normal   ( )Baixo                  Mแquina: ( )Limpa   ( )Suja                  Mat้ria Prima: ( )OK",oFont02,100)

oPrn:Line( 1025,100,1025,2350 )

oPrn:Say(1025 ,100, "MมQUINA PARADA"	,oFont03n,100)
oPrn:Say(1075 ,100, " Hora Parada"		,oFont04,100)
oPrn:Say(1075 ,340, " Hora Retorno"	,oFont04,100)
oPrn:Say(1075 ,590, " Motivo"		,oFont04,100)

For i:=1125 To 1275 Step 50
	oPrn:Line(i,100,i,2350 )
	oPrn:Say(i ,600, "( )Manuten็ใo     ( )Troca Molde     ( )Desligada     ( )Outros (Descrever em Observa็ใo)"		,oFont04,100)
Next i

oPrn:Line(1075,100,1075,2350 )		//Linha horizontal 1
oPrn:Line(1325,100,1325,2350 )		//Linha horizontal 2
oPrn:Line(1075,100,1325,100 )		//Linha vertical 1
oPrn:Line(1075,340,1325,340 )		//Linha vertical 2
oPrn:Line(1075,590,1325,590 )		//Linha vertical 3
oPrn:Line(1075,2350,1325,2350 )		//Linha vertical 4

oPrn:Say(1350 ,100, "MATษRIA PRIMA"	,oFont03n,100)
oPrn:Say(1400 ,100, "   Descri็ใo"		,oFont02,100)
oPrn:Say(1400 ,1200, "Lote 01"		,oFont02,100)
oPrn:Say(1400 ,1500, "Lote 02"		,oFont02,100)
oPrn:Say(1400 ,1800, "Lote 03"		,oFont02,100)
oPrn:Say(1400 ,2100, "Lote 04"		,oFont02,100)

oPrn:Line(1400,100,1775,100 )		//Linha vertical 1
oPrn:Line(1400,1190,1775,1190 )		//Linha vertical 2
oPrn:Line(1400,1490,1775,1490 )		//Linha vertical 3
oPrn:Line(1400,1790,1775,1790 )		//Linha vertical 4
oPrn:Line(1400,2090,1775,2090 )		//Linha vertical 5
oPrn:Line(1400,2350,1775,2350 )		//Linha vertical 6

oPrn:Line(1400,100,1400,2350 )		//Linha horizontal 1

For i:=1400 To 1775 Step 75
	oPrn:Line(i,100,i,2350 )
Next i

oPrn:Say(1800 ,100, "OBSERVAวรO:"	,oFont03n,100)

oPrn:Line(2050,100,2050,2350 )

oPrn:Say(2100 ,300 , "_____________________"						,oFont02,100)
oPrn:Say(2100 ,1000 , "_____________________"						,oFont02,100)
oPrn:Say(2100 ,1700, "_____________________"						,oFont02,100)
oPrn:Say(2150 ,300 , "Auxiliar de Produ็ใo"	,oFont02,100)
oPrn:Say(2150 ,1000 , "Encarregado Produ็ใo"	,oFont02,100)
oPrn:Say(2150 ,1700, "Responsแvel Produ็ใo"	,oFont02,100)

oPrn:Line(2225,100,2225,2350 )


//ALTERAวรO SOLICITADA POR E-MAIL DO SR. LUIS 01/07/2021

oPrn:Say(2280,500, " LIMPEZA NอVEL 1"	,oFont04n,100)
oPrn:Say(2335,100, " MมQUINA"			,oFont04,100)
oPrn:Say(2395,100, " TURNO"				,oFont04,100)
oPrn:Say(2395,300, " DATA"				,oFont04,100)
oPrn:Say(2395,500, " HORA"				,oFont04,100)
oPrn:Say(2395,700, " RESPONSมVEL"		,oFont04,100)
oPrn:Say(2395,900, " VERIFICAวรO"		,oFont04,100)

oPrn:Line( 2275,100,2275,1100 )		//Linha horizontal 1
oPrn:Line( 2335,100,2335,1100 ) 	//Linha horizontal 2
oPrn:Line( 2395,100,2395,1100 )		//Linha horizontal 3
oPrn:Line( 2455,100,2455,1100 )		//Linha horizontal 4
oPrn:Line( 2515,100,2515,1100 )		//Linha horizontal 5
oPrn:Line( 2575,100,2575,1100 )		//Linha horizontal 6
oPrn:Line( 2635,100,2635,1100 )		//Linha horizontal 7
oPrn:Line( 2695,100,2695,1100 )		//Linha horizontal 8
oPrn:Line( 2755,100,2755,1100 )		//Linha horizontal 9
oPrn:Line( 2815,100,2815,1100 )		//Linha horizontal 10

oPrn:Line( 2275, 100, 2815,  100 )		//Linha vertical 1
oPrn:Line( 2395, 300, 2815,  300 )		//Linha vertical 2
oPrn:Line( 2395, 500, 2815,  500 )		//Linha vertical 3
oPrn:Line( 2395, 700, 2815,  700 )		//Linha vertical 4
oPrn:Line( 2395, 900, 2815,  900 )		//Linha vertical 5
oPrn:Line( 2275, 1100, 2815,  1100 )	//Linha vertical 5


oPrn:Say(3250,800 , "_____________________",oFont02,100)
oPrn:Say(3300,800 , "Conferido/Encarregado",oFont02,100)

oPrn:Say(2275,1180 , " HORA"		,oFont04,100)
oPrn:Say(2275,1320 , " PESO I"				,oFont04,100)
oPrn:Say(2275,1460 , " PESO II"			,oFont04,100)
oPrn:Say(2275,1600 , " CICLO"	,oFont04,100)

oPrn:Say(2275,1790 , " HORA"		,oFont04,100)
oPrn:Say(2275,1930 , " PESO I"				,oFont04,100)
oPrn:Say(2275,2070 , " PESO II"			,oFont04,100)
oPrn:Say(2275,2210 , " CICLO"	,oFont04,100)

For i:= 2275 To 2815 Step 60
	oPrn:Line(i,1180,i,1740 )
	oPrn:Line(i,1790,i,2350 )
Next i

oPrn:Line(2275,1180,2815,1180 ) //Linha Vertical 1
oPrn:Line(2275,1320,2815,1320 ) //Linha Vertical 2
oPrn:Line(2275,1460,2815,1460 ) //Linha Vertical 3
oPrn:Line(2275,1600,2815,1600 ) //Linha Vertical 4
oPrn:Line(2275,1740,2815,1740 ) //Linha Vertical 5

oPrn:Line(2275,1790,2815,1790 ) //Linha Vertical 6
oPrn:Line(2275,1930,2815,1930 ) //Linha Vertical 7
oPrn:Line(2275,2070,2815,2070 ) //Linha Vertical 8
oPrn:Line(2275,2210,2815,2210 ) //Linha Vertical 9
oPrn:Line(2275,2350,2815,2350 ) //Linha Vertical 10

oPrn:Say(2865,1230 , "Inje็ใo/Sopro:"		,oFont04,100)
oPrn:Say(2865,1460 , "CLASSE A = Produtos Conforme Amostra"		,oFont04,100)
oPrn:Say(2915,1460 , "CLASSE C = Produtos Nใo Conforme"				,oFont04,100)
oPrn:Say(2965,1460 , "CLASSE D = Falha Inje็ใo, Amassados ou Furados"			,oFont04,100)

Return


/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณPULAPAG   บAutor  ณCHRISTIAN ROCHA     บ Data ณ Abril/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel por gerar nova pagina e imprimir as      บฑฑ
ฑฑบ          ณinformacoes restantes.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function PulaPag

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSo deve imprimir o total de paginas quando for a 2 vezณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If L == 2
		oPrn:Say(100,2100, Str(n_Pag,3)+" de "+Str(n_TotPag,3),oFont02,100)  
	EndIf

	oPrn:EndPage()
	n_Pag++

	oPrn:StartPage()

Return

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณCriaPerg  บAutor  ณCHRISTIAN ROCHA     บ Data ณ Abril/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao responsavel imprimir a observacao do orcamento conforบฑฑ
ฑฑบ          ณme a largura da pagina.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST/SIGAPCP                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function CriaPerg(c_Perg)

//PutSx1(cGrupo,cOrdem,c_Pergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c_Perg,"01","Ord. Produ็ใo de ?"   ,"","","mv_ch1","C",11,0,0,"G","","SC2","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"02","Ord. Produ็ใo at้ ?"  ,"","","mv_ch2","C",11,0,0,"G","","SC2","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(c_Perg,"03","Recurso ?"   	  ,"","","mv_ch3","C",06,0,0,"G","","SH4","","","mv_par03","","","","","","","","","","","","","","","","")

Return()

Static Function f_Qry()

c_Qry := " SELECT * FROM " + RetSqlName("SC2") + " SC2 " + chr(13)
c_Qry += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " JOIN " + RetSqlName("SBM") + " SBM ON BM_GRUPO = B1_GRUPO AND BM_FILIAL = '" + XFILIAL("SBM") + "' AND SBM.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " LEFT JOIN " + RetSqlName("SG2") + " SG2 ON (G2_CODIGO = C2_ROTEIRO OR G2_RECURSO = C2_RECURSO) AND G2_FILIAL = '" + XFILIAL("SG2") + "' AND G2_PRODUTO = B1_COD AND SG2.D_E_L_E_T_<>'*' " + chr(13)
If Empty(MV_PAR03)
	c_Qry += " LEFT JOIN " + RetSqlName("SH1") + " SH1 ON (H1_CODIGO = C2_RECURSO OR H1_CODIGO = G2_RECURSO) AND H1_FILIAL = '" + XFILIAL("SH1") + "' AND SH1.D_E_L_E_T_<>'*' " + chr(13)
Else
	c_Qry += " JOIN " + RetSqlName("SH1") + " SH1 ON (H1_CODIGO = C2_RECURSO OR H1_CODIGO = G2_RECURSO) AND H1_FILIAL = '" + XFILIAL("SH1") + "' AND SH1.D_E_L_E_T_<>'*' " + chr(13)
	c_Qry += " AND H1_CODIGO = '" + MV_PAR03 + "' " + chr(13)
Endif
c_Qry += " LEFT JOIN " + RetSqlName("SH4") + " SH4 ON H4_CODIGO = G2_FERRAM AND H4_FILIAL = '" + XFILIAL("SH4") + "' AND SH4.D_E_L_E_T_<>'*' " + chr(13)
c_Qry += " WHERE (C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "') AND (SC2.D_E_L_E_T_<>'*') " + chr(13)
c_Qry += " AND (C2_STATUS <> 'U') AND (C2_QUJE < C2_QUANT) AND (C2_TPOP = 'F') AND (C2_DATRF = '') AND C2_FILIAL = '" + XFILIAL("SC2") + "' " + chr(13)
c_Qry += " ORDER BY C2_NUM "

MemoWrit("C:\TEMP\FESTR005.SQL",c_Qry)

Return c_Qry
