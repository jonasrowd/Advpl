#Include 'Totvs.ch'
#Include 'Ap5mail.ch'

/*/{Protheus.doc} FMATA650
	Ponto de entrada desenvolvido para preencher campos personalizados na SD4
	e excluir as Op's e Empenhos que não querem que gere.
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 05/10/2021
/*/
User Function FMATA650()

    Local nOpc 			:= 5 //3 - Inclusao, 4 - Alteracao, 5 - Exclusao
    Local cOp			:= ""
	Local aMATA650		:= {} //-Array com os campos
    Local DDATABASE		:= DATE()
	Private l_Email		:= .T.
    Private lMsErroAuto := .F.
	Private c_Email		:= 'ti@bomix.com.br'
	Private c_Titulo	:= "OP: " + SD4->D4_OP + " Notificação de erro na exclusão automática do MATA650."
	Private c_Corpo		:= c_Titulo + CRLF + "Acionamento Key User para verificar com o usuário " + UsrRetName(__CUSERID) +" o ocorrido."

	// Gera um novo alias para a tabela temporária
	c_AliasAux := GetNextAlias()

	// Pesquisa pelos produtos que não devem
	// gerar Ordem de Produção
	BEGINSQL ALIAS c_AliasAux
		SELECT
			C2.C2_FILIAL  CFILAUX,
			C2.C2_NUM     CNUMAUX,
			C2.C2_ITEM    CITEMAUX,
			C2.C2_SEQUEN  CSEQAUX,
			C2.C2_PRODUTO CPRODAUX,
			C2.C2_LOCAL	  CLOCALAUX,
			C2.C2_QUANT	  CQUANTAUX
		FROM
			%TABLE:SC2% C2
			INNER JOIN
				%TABLE:SB1% B1
				ON B1.B1_FILIAL = %XFILIAL:SB1%
				AND B1.B1_COD   = C2.C2_PRODUTO
				AND B1.%NOTDEL%
			INNER JOIN
				%TABLE:Z05% Z05
				ON Z05.Z05_FILIAL = %XFILIAL:Z05%
				AND Z05.Z05_NOME  = B1.B1_BRTPPR
				AND Z05.%NOTDEL%
		WHERE
			C2.C2_NUM + C2.C2_ITEM + C2.C2_SEQUEN = %EXP:AllTrim(cOp)%
			AND Z05.Z05_GERAOP = 'N'
			AND C2.%NOTDEL%
	ENDSQL

	//Execauto para excluir as op's e empenhos 
	While (!EOF())
			aMATA650 := {;
                {'C2_FILIAL'    , CFILAUX   ,NIL},;
                {'C2_NUM'       , CNUMAUX   ,NIL},; 
                {'C2_ITEM'      , CITEMAUX  ,NIL},; 
                {'C2_SEQUEN'    , CSEQAUX   ,NIL},;
                {'C2_PRODUTO'   , CPRODAUX  ,NIL},;
                {'C2_LOCAL'     , CLOCALAUX ,NIL},;
                {'C2_QUANT'     , CQUANTAUX ,NIL},;
                {'C2_DATPRI'    , DDATABASE ,NIL},;
                {'C2_DATPRF'    , DDATABASE ,NIL},;
                {'AUTEXPLODE'   , "S"       ,NIL};
                }

    // Se alteracao ou exclusao, deve-se posicionar no registro da SC2 antes de executar a rotina automática
    If nOpc == 4 .Or. nOpc == 5
        SC2->(DbSetOrder(1))//FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
        SC2->(DbSeek(xFilial("SC2")+aMATA650[2][2]+aMATA650[3][2]+aMATA650[4][2]))
    EndIf

    msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)

	//Se Erro, apresenta mensagem para que o usuário possa nos informar
    If lMsErroAuto
		jEnvMail()
		Help(NIL, NIL, 'ERR_OP', NIL, 'Erro no ajuste de Empenho e Op.',;
			1, 0, NIL, NIL, NIL, NIL, NIL, {'Encaminhe esta Op ao time de TI para acompanhar o processo.'})
        MostraErro()
    EndIf

	DBSkip()
	End

Return (Nil)

/*/{Protheus.doc} jEnvMail
	Envia email se erro
	@type function
	@version 12.1.25
	@author Jonas Machado
	@since 08/10/2021
	@return logical, .T.
/*/
Static Function jEnvMail()
	Local _cServer   	:= Alltrim(GETMV("MV_RELSERV"))	//Servidor smtp
	Local _cAccount  	:= Alltrim(GETMV("BM_BOLMAIL"))	//Conta de e-mail
	Local _cPassword	:= Alltrim(GETMV("BM_BOLSNH"))	//Senha da conta de e-mail
	Local _cEnvia    	:= Alltrim(GETMV("BM_BOLMAIL"))	//Endereco de e-mail
	Local _cTo			:= "jonas.machado@bomix.com.br"// _Par1+";"+ALLTRIM(UsrRetMail(__cUserID))			//Destinatario
	Local _cMsg			:= "Erro na geração das op x pedidos de venda."			//Corpo da Mensagem
	Local _cSubj		:= OemToAnsi('BOMIX - Geração de Op ') //Assunto

	//Conecta ao servidor de SMTP
	CONNECT SMTP SERVER _cServer ACCOUNT _cAccount PASSWORD _cPassword Result lConectou
	//Caso o servidor SMTP do cliente necessite de autenticacao
	//sera necessario habilitar o parametro MV_RELAUTH.
	If GETMV("MV_RELAUTH")
		If !MailAuth( _cAccount, _cPassword )
			DISCONNECT SMTP SERVER RESULT lDisConectou
			Return (.F.)
		EndIf
	EndIf
	//Verifica se houve conexao com o servidor SMTP
	If !lConectou
		Return (.F.)
	EndIf
	//Envia o e-mail
	SEND MAIL FROM _cEnvia TO Alltrim(_cTo) SUBJECT _cSubj BODY _cMsg RESULT lEnviado
	//Verifica possiveis erros durante o envio do e-mail
	If lEnviado
		Return (.T.)
	Else
		_cMsg := ""
		GET MAIL ERROR _cMsg
		Return (.F.)
	EndIf
	//Desconecta o servidor de SMTP
	DISCONNECT SMTP SERVER Result lDisConectou
Return (.T.)
