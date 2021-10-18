#Include 'Totvs.ch'

/*/{Protheus.doc} MT100LOK
	Ponto de entrada desenvolvido para impedir o cadastro de doc. de entrada
	sem o lote do fornecedor quando o produto possuir controle de rastreabilidade.
	Bloqueia gravação de Doc. de Entrada sem CC, caso Rateio seja Não.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 02/08/2021
	@return Logical, Bloqueia a gravação do documento de entrada
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085397
/*/
User Function MT100LOK()
	Local c_Produto := ''        // 
	Local c_LoteFor := ''        // 
	Local c_Rastro  := ''        // 
	Local c_CC      := ''        // 
	Local c_Rateio  := ''        // 
	Local l_Ret     := .T.       // 
	Local c_Conta   := ''        // 
	Local a_Area    := GetArea() // 

	If cTipo == 'N'
		c_CC      := aCols[n][AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_CC'})]
		c_Conta   := aCols[n][AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_CONTA'})]
		c_Rateio  := aCols[n][AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_RATEIO'})]
		c_Produto := aCols[n][AScan(aHeader, {|x| AllTrim(x[2]) == 'D1_COD'})]
		c_Rastro  := Posicione('SB1', 1, FwXFilial('SB1') + c_Produto, 'B1_RASTRO')

		If Empty(c_CC) .And. c_Rateio == '2'
			l_Ret := .F.
			Help(NIL, NIL, 'CC_BLOCKED', NIL, 'O Campo centro de custo é obrigatório.',;
				1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha o campo corretamente.'})
			If c_Rastro == 'L'
				c_LoteFor := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_LOTEFOR'})]

				If Empty(c_LoteFor)
					l_Ret := .F.
					Help(NIL, NIL, 'LOT_BLOCKED', NIL, 'O campo Lote Fornec. é obrigatório quando o produto possui controle de rastreabilidade.',;
						1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha o campo Lote Fornec. deste item.'})
				EndIf
			EndIf

			If Empty(c_Conta) .And. c_Rateio  == '1'
				If !MsgYesNo('O campo conta contábil está em branco.' + Chr(10) +;
				'Deseja proseguir com a conta contábil cadastrada no rateio por centro de custo ?', 'CODIGO_ERRO')
					l_Ret := .F.
				EndIf
			ElseIf Empty(c_Conta) .And. c_Rateio  == '2'
				l_Ret := .F.
				Help(NIL, NIL, 'LOT_BLOCKED', NIL, 'Conta contábil (D1_CONTA) não preenchido.',;
					1, 0, NIL, NIL, NIL, NIL, NIL, {'Favor preencher a conta contábil.'})
			EndIf
		ElseIf c_Rateio == '1'
			l_Ret := .T.
		EndIf
	EndIf

	RestArea(a_Area)
Return l_Ret
