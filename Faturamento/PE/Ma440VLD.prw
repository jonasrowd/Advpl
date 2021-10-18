#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} Ma440VLD
	Valida se o cliente está devendo e se não foi liberado anteriormente.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Logical, Se verdadeiro, deixa prosseguir, senão, apresenta o Help.
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784532
/*/
User Function Ma440VLD()
	Local lLiber		:= .T.
    Local aArea		:= GetArea()
	Local cMarca 	:= PARAMIXB[1] //Marca utilizada

	If (FWCodFil() != '030101') .AND. cValToChar(DOW(DATE())) $ ('23456') //Se não for a filial 03 e for dia da semana.

		//Verifica se o alias está aberto e o fecha caso esteja
		If Select("QRYSC9") > 0 
			DbSelectArea("QRYSC9")
			QRYSC9->(DbCloseArea())
		EndIf
		
		//Seleciona os pedidos de venda com a Marca do ParamIxb[1]
		BEGINSQL ALIAS "QRYSC9"

			SELECT DISTINCT
				C9_PEDIDO AS PEDIDO,
				C9_CLIENTE AS CLIENTE,
				C9_LOJA AS LOJA
			FROM
				%TABLE:SC9%
			WHERE
				C9_OK = %EXP:cMarca% AND
				%NOTDEL% AND
				C9_FILIAL = %XFILIAL:SC9%
		ENDSQL

		If lLiber
			While QRYSC9->(!EOF())
				//Verifica títulos em aberto ou se ouve liberação manual do pedido
				nAtrasados := u_FFATVATR(QRYSC9->CLIENTE, QRYSC9->LOJA)
				If nAtrasados > 0 
					//Se há títulos em atraso verifica a liberação.
					If !estaLib(QRYSC9->PEDIDO)
						//Caso retorne .T. exibe mensagem com o número do pedido bloqueado e não permite o faturamento.
						lLiber := .F.
						Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "O Pedido: "+ QRYSC9->PEDIDO+" possui restrições financeiras no total de R$ " ;
							+AllTrim(Transform(nAtrasados,"@e 9,999,999,999,999.99"))+".",1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite a liberação ao departamento comercial."})
					EndIf
				EndIf
				QRYSC9->(DbSkip())
			End
		EndIf
	EndIf

	RestArea(aArea)
Return lLiber

/*/{Protheus.doc} estaLib
	Verifica se o pedido já foi liberado anteriormente.
	@type Function
	@version 12.1.25
	@author Sandro Santos
	@since 04/08/2021
	@param _cPed, variant, Número do pedido capturado pelo ponto de entrada
	@return Logical, lOK, Controle de liberação
/*/
Static Function estaLib(_cPed)
	
	Local lOK	  := .F.
	Default _cPed := ''

	DBSelectArea("SC5")
	DBSetOrder(1)
	DBSeek(FwXFilial("SC5") + _cPed)

	DbSelectArea('Z07')
	DbSetOrder(1)
	If DBSeek(FWXFILIAL('Z07') + _cPed)
		While Z07->(!Eof()) .And. _cPed == Z07->Z07_PEDIDO
			If 'Venda' $ Z07->Z07_JUSTIF .OR. 'Exped' $ Z07->Z07_JUSTIF
				lOK := .T.
			EndIf
			Z07->(dbSkip())
		End
	ElseIf SC5->C5_BXSTATU $ 'L|A|E'
		lOK := .T.
	Else
		lOK := .F.
	EndIf

Return (lOK)
