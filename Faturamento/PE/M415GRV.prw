//Bibliotecas necess�rias
#Include 'Totvs.ch'

/*/{Protheus.doc} M415GRV
	Avalia qual status deve gravar na inclus�o, altera��o ou exclus�o do or�amento.
	@type function
	@version 12.1.25
	@author R�mulo Ferreira
	@since 04/08/2021
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784161
/*/
User Function M415GRV

	Local nAtrasados := u_FFATVATR(SCJ->CJ_CLIENTE, SCJ->CJ_LOJA)

	If FWCodFil() != '030101'
		RecLock('SCJ',.F.)
			If PARAMIXB[1] == 1 .Or. PARAMIXB[1] == 2
				If nAtrasados != 0
					SCJ->CJ_BXSTATU := 'B'
				Else
					SCJ->CJ_BXSTATU := 'L'
				EndIf
			ElseIf PARAMIXB[1] == 3
				SCJ->CJ_BXSTATU := ''
			EndIF
		SCJ->(MsUnlock())
		If SCJ->CJ_BXSTATU = 'B'
			Help(NIL, NIL, "CLI_BLOCKED", NIL, "Cliente com restri��es financeiras.",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicitar a libera��o do setor comercial."})
		EndIf
	EndIf
Return
