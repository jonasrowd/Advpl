#include "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

User Function FFATG004(cCampo,cCampo2)

	Local cTexto 	:= Space(10)
	Local cCliente 	:= Space(6)
	Local cLoja  	:= Space(2)
	Local oLegVerde     := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oLegVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
	default cCampo := ''
	private cfil :="      "

	cFil := FWCodFil()
		if cFil = "030101"
			return 'L'
		endif
	If !IsInCallStack("MATA311")

		DbSelectArea("SA1")
		SA1->( DbSetOrder(1) )

		If Upper(FunName())=="MATA410" 	//Pedido de Venda
			If cCampo = SC5->C5_CLIENTE .AND. cCampo2 = SC5->C5_LOJACLI
				cCliente := SC5->C5_CLIENTE
				cLoja 	 := SC5->C5_LOJACLI
			Else
				cCliente := M->C5_CLIENTE
				cLoja 	 := M->C5_LOJACLI
			EndIf
		ElseIf Upper(FunName())== "MATA415" // Orcamento de Venda
			cCliente := M->CJ_CLIENTE
			cLoja 	 := M->CJ_LOJA
		Endif

		If SA1->( DbSeek(xFilial("SA1") + cCliente + cLoja ))

			l_Ret		:=''
			_cCGC   	:= SubStr(SA1->A1_CGC,1,8)
			nLimite 	:= 0
			nVencido 	:= 0
			nVencer  	:= 0
			nAberto  	:= 0
			nSaldo   	:= 0
			cTexto 	 	:= ''

			_aArea  := GetArea()
			DbSelectArea("SA1")
				SA1->( DbSetOrder(3) )
				SA1->( DbSeek(xFilial("SA1")+_cCGC ))
				nLimite 	:= 	SA1->A1_LC
				nVencido 	:= 	retVencido(cCliente,cLoja)
				nVencer  	:= 	retAVencer(cCliente,cLoja)
				nAberto  	:= 	retAberto(cCliente,cLoja)
				nSaldo   	:= 	(SA1->A1_LC - nVencido)
				SA1->(DbSkip())
			RestArea(_aArea)

			oFont1    := TFont():New('Courier new',,-18,.T.)
			oFont1:Bold := .T.
			oFont2    := TFont():New('Courier new',,-12,.T.)
			oFont2:Bold := .T.
			oFont3    := TFont():New('Courier new',,-20,.T.)
			oFont3:Bold := .T.

			oDlg1 := MSDialog():New(180,180,750,950,'Informações do Cliente',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			oSay01:= tSay():New(03,130,{||"Posição do Cliente"},oDlg1,,oFont1,,,,.T.,CLR_BLACK,CLR_WHITE,120,30)

			If nVencido > 0
				oSay02:= tSay():New(25,005,{||"Titulos Vencidos:"},oDlg1,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,070,30)
			Else
				oSay02:= tSay():New(25,005,{||"Titulos Vencidos:"},oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,30)
			Endif
			@ 23, 080 Get nVencido Object oVencido When .F. Size 060,010 Picture  "@E 99,999,999,999.99"

			oSay03:= tSay():New(40,005,{||"Titulos a Vencer: "},oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,30)
			@ 40, 080 Get nVencer Object oVencer When .F. Size 060,010 Picture "@E 99,999,999,999.99"

			oSay04:= tSay():New(55,005,{||"Titulos em Aberto:"},oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,30)
			@ 55, 080 Get nAberto Object oAberto When .F. Size 060,010  Picture "@E 99,999,999,999.99"

			oSay05:= tSay():New(70,005,{||"Limite de Crédito:"},oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,30)
			@ 70, 080 Get nLimite  Object oLimCred When .F. Size 060,010 Picture  "@E 99,999,999,999.99"

			oSay06:= tSay():New(85,005,{||"Saldo Disponível: "},oDlg1,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,070,30)
			@ 85, 080 Get nSaldo Object oSaldo When .F. Size 060,010  Picture "@E 99,999,999,999.99"

			If nSaldo < 0
				oSay07:= tSay():New(40,200,{||"Cliente inadimplente!"},oDlg1,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,100,40)
				l_Ret := 'B'
			Endif

			oBtn  := TBtnBmp2():New( 200, 15, 35, 35, "OK" , "OK" , , ,{|| oDlg1:End()}, oDlg1, , , .T.)
			oBrowse := TWBrowse():New( 120 , 005, 380,140,,{'','Pedido','Titulo','Emissão','Vencimento','Valor','Historico','Saldo'},{20,20,20,20,20},oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
			aBrowse   := getSE1Hist(cCliente,cLoja)
			oBrowse:SetArray(aBrowse)
			oBrowse:bLine := {||{if(aBrowse[oBrowse:nAt,04] < dDataBase, oLegVermelho,oLegVerde),; //Vencimento menor que hoje
									aBrowse[oBrowse:nAt,01],;
									aBrowse[oBrowse:nAt,02],;
									aBrowse[oBrowse:nAt,03],;
									aBrowse[oBrowse:nAt,04],;
									aBrowse[oBrowse:nAt,05],;
									aBrowse[oBrowse:nAt,06],;
									aBrowse[oBrowse:nAt,07] } }
			Activate Dialog oDlg1 Centered
		Endif
	Endif

Return l_Ret

/*/{Protheus.doc} getSE1Hist
	Busca títulos em aberto e vencidos para mostrar no Browse.
	@type function
	@version 12.1.25
	@author jonas.machado
	@since 05/08/2021
	@param cCodCli, character, Código do cliente
	@param cLojaCli, character, Código da loja.
	@return variant, Array
/*/
Static Function getSE1Hist(cCodCli,cLojaCli)

aDadosCli := {}

If Select("E1TEMP") > 0
    E1TEMP->(dbCloseArea())
Endif

BeginSql alias 'E1TEMP'
    column E1_EMISSAO as Date
    column E1_VENCREA  as Date

    SELECT
	E1_PEDIDO,
    E1_NUM,
    E1_EMISSAO,
    E1_VENCREA,
    E1_VALOR,
    E1_HIST,
	E1_SALDO

    FROM %table:SE1% SE1

    WHERE
    E1_SALDO > 0 AND
    E1_CLIENTE = %exp:cCodCli% AND
    E1_LOJA = %exp:cLojaCli% AND
    SE1.%notDel% AND
	E1_TIPO = 'NF' AND
	E1_SALDO <> E1_JUROS AND
	E1_VENCREA >= '20210101'
    ORDER BY E1_VENCREA ASC

EndSql

while E1TEMP->(!EOF())
    aadd(aDadosCli,{ E1TEMP->E1_PEDIDO, E1TEMP->E1_NUM,E1TEMP->E1_EMISSAO,E1TEMP->E1_VENCREA,E1TEMP->E1_VALOR,E1TEMP->E1_HIST,E1_SALDO })
    E1TEMP->(dbSkip())
end

If Len(aDadosCli) = 0
aadd(aDadosCli,{ '','',CtoD("  /  /  "),CtoD("  /  /  "),0,'',0 })

EndIf

Return aDadosCli


Static Function retVencido(cCliente,cLoja)

If Select("E1TEMP") > 0
    E1TEMP->(dbCloseArea())
Endif

BeginSql alias 'E1TEMP'
    SELECT

	SUM(E1_SALDO) VALOR

    FROM %table:SE1% SE1

    WHERE
    E1_SALDO > 0 AND
    E1_CLIENTE = %exp:cCliente% AND
    E1_LOJA = %exp:cLoja% AND
    SE1.%notDel% AND
	E1_TIPO = 'NF' AND
	E1_VENCREA >= '20210101' AND
	E1_VENCREA < %exp:DtoS(dDataBase)% AND
	E1_SALDO <> E1_JUROS
EndSql

If E1TEMP->(!EOF())
	RETURN E1TEMP->VALOR
EndIf

Return 0

Static Function retAVencer(cCliente,cLoja)

If Select("E1TEMP") > 0
    E1TEMP->(dbCloseArea())
Endif

BeginSql alias 'E1TEMP'
    SELECT

	SUM(E1_SALDO) VALOR

    FROM %table:SE1% SE1

    WHERE
    E1_SALDO > 0 AND
    E1_CLIENTE = %exp:cCliente% AND
    E1_LOJA = %exp:cLoja% AND
	E1_TIPO = 'NF' AND
    SE1.%notDel% AND
	E1_VENCREA >= %exp:DtoS(dDataBase)% AND
	E1_SALDO <> E1_JUROS
EndSql

If E1TEMP->(!EOF())
	RETURN E1TEMP->VALOR
EndIf

Return 0

Static Function retAberto(cCliente,cLoja)

If Select("E1TEMP") > 0
    E1TEMP->(dbCloseArea())
Endif

BeginSql alias 'E1TEMP'
    SELECT

	SUM(E1_SALDO) VALOR

    FROM %table:SE1% SE1

    WHERE
    E1_SALDO > 0 AND
    E1_CLIENTE = %exp:cCliente% AND
    E1_LOJA = %exp:cLoja% AND
	E1_TIPO = 'NF' AND
    SE1.%notDel% AND
	E1_SALDO <> E1_JUROS
EndSql

If E1TEMP->(!EOF())
	RETURN E1TEMP->VALOR
EndIf

Return 0
