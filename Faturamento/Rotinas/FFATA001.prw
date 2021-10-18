// Bibliotecas necessárias
#Include "TOTVS.ch"

// Barra de separação de diretórios
#Define SLASH IIf(IsSrvUnix(), "/", "\")

/*
	FUNÇÕES ÚTEIS
	• Alias(): Retorna a tabela posicionada
	• Found(): Verifica se o último DBSeek() encontrou algo
*/

/*/{Protheus.doc} FFATA001
	Job para avaliação de todos os pedido de venda em aberto
	afim de bloquear ou desbloquear o status do pedido com
	base nos títulos em aberto do cliente.
	@type Function
	@author Jonas Machado
	@since 31/08/2021
	@version 12.1.25
/*/
User Function FFATA001()
	Local cText     := ""  // Auxiliar da montagem da linha do log
	Local cPath     := ""  // Caminho de gravação do arquivo de logs
	Local oFile     := NIL // Arquivo de logs do job
	Local lAtualiza := .T. // Controle de atualização do pedido

	// Efetua a abertura do ambiente apenas a empresa BOMIX
	RPCSetEnv("01", "010101")

	If (cValToChar(DOW(DATE())) $ ('2|3|4|5|6'))
		cPath := SLASH + "DIRDOC" + SLASH
		oFile := FwFileWriter():New(cPath + cFilAnt + "_" + FwTimeStamp() + ".txt", .T.)
		oFile:Create()

		// Fecha a tabela de pedidos em aberto caso o alias esteja em uso
		If (Select("C5TEMP") > 0)
			DBSelectArea("C5TEMP")
			DBCloseArea()
		EndIf

		// Trás os pedidos que estão em aberto
		BEGINSQL ALIAS "C5TEMP"
			SELECT
				C5_FILIAL FILIAL,
				C5_NUM NUM
			FROM
				SC5010 C5
				INNER JOIN
					SC6010 C6
					ON C5_FILIAL       = C6_FILIAL
					AND C5_NUM         = C6_NUM
					AND C6.D_E_L_E_T_ <> '*'
			WHERE
				C5.D_E_L_E_T_  <> '*'
				AND C6_QTDENT   = '0'
				AND C5_NOTA     = ''
				AND C6_NOTA     = ''
				AND C6_NUMORC  <> ''
                AND C5_TIPO     = 'N'
				AND C5_LIBEROK <> 'E'
				AND C6_BLQ     <> 'R'
                AND C5_FILIAL   = '010101'
                AND C6_FILIAL   = '010101'
		ENDSQL

		// Percorre os pedidos em aberto
		While (!EOF())
            //Redefine o parâmetro de atualização
            lAtualiza := .T.
			// Posiciona o pedido na tabela padrão
			DBSelectArea("SC5")
			DBSetOrder(1)
			DBSeek(C5TEMP->FILIAL + C5TEMP->NUM)

			// Fecha a tabela de débitos do cliente caso o alias esteja em uso
			If (Select("E1TEMP") > 0)
				DBSelectArea("E1TEMP")
				DBCloseArea()
			EndIf

			// Calcula os débitos do cliente contido no pedido
			BEGINSQL ALIAS "E1TEMP"
				SELECT
					SUM(E1_SALDO) Saldo
				FROM
					%TABLE:SE1% SE1
				WHERE
					SE1.E1_SALDO > 0
					AND SE1.E1_CLIENTE  = %EXP:SC5->C5_CLIENTE%
					AND SE1.E1_LOJA     = %EXP:SC5->C5_LOJACLI%
					AND SE1.E1_TIPO     = 'NF'
					AND SE1.E1_VENCREA >= '20200101'
					AND SE1.E1_VENCREA  < %EXP:DToS(dDataBase)%
					AND SE1.E1_SALDO   <> SE1.E1_JUROS
					AND SE1.E1_FILIAL   = '010101'
					AND SE1.%NOTDEL%
			ENDSQL

			// Posiciona na tabela de liberação de pedidos
			DBSelectArea("Z07")
			DBSetOrder(1)
			DBSeek(SC5->C5_FILIAL + SC5->C5_NUM)
			// Atualiza o pedido conforme liberação manual
			If (Found())
				// Percorre os vários registros da tabela de logs de libereação manual
				// procurando por aquele que tenha as informações "VENDA" ou "EXPED"
				While (!EOF() .And. Z07_PEDIDO == SC5->C5_NUM)
					If ("Venda" $ Z07_JUSTIF .Or. "Exped" $ Z07_JUSTIF)
						lAtualiza := .F.
					EndIf

					// Salta para o próximo registro da tabela de liberação manual
					DBSkip()
				EndDo
			EndIf

			// Altera (bloqueia/desbloqueia) o pedido caso ele não tenha
			// sido liberado manualmente na Z07
			If (lAtualiza)
				// Atualiza a SC5
				SC5->(RecLock("SC5", .F.))
					// Posiciona no itens do pedido com base no cabeçalho
					DBSelectArea("SC6")
					DBSetOrder(1)
					DBSeek(SC5->C5_FILIAL + SC5->C5_NUM )

					// Percorre os itens (SC6) com base no pedido (SC5) que não tenham sido faturados
					While (!EOF() .And. C6_NUM == SC5->C5_NUM .And. Empty(C6_NOTA))
						// Bloqueia o cliente caso tenha saldo em aberto (inadimplente)
						If (E1TEMP->(Saldo) > 0)
							// Monta a mensagem que será escrita na linha do log antes do reclock
							cText := "[" + FwTimeStamp(2)       + "]"
                            cText += "[" + "CLIENTE: "          + AllTrim(SC5->C5_CLIENT )   + "]"
                            cText += "[" + "PEDIDO: "           + AllTrim(SC5->C5_NUM    )   + "]"
							cText += "[" + "C5_BXSTATU ANTES: " + AllTrim(SC5->C5_BXSTATU)   + "]"
							cText += "[" + "C5_FSSTBI ANTES: "  + AllTrim(SC5->C5_FSSTBI )   + "]"
							cText += "[" + "C5_BLQ ANTES: "     + AllTrim(SC5->C5_BLQ    )   + "]"
							cText += "[" + "C5_LIBEROK ANTES: " + AllTrim(SC5->C5_LIBEROK)   + "]"
                            cText += "[" + "C6_FSGEROP: "       + AllTrim(C6_FSGEROP     )   + "]"
                            cText += "[" + "C6_NUMOP: "         + AllTrim(C6_NUMOP       )   + "]"
							// Campos padrões para bloqueio
							SC5->C5_BXSTATU := "B"
							SC5->C5_BLQ     := "B"
							SC5->C5_LIBEROK := "S"
							// Verifica se o item já tem ordem de produção criada e se deve gerar OP
							If (C6_FSGEROP == "1" .And. Empty(C6_NUMOP))
								SC5->C5_FSSTBI := "BLOQUEADO PR"
                                // Monta a mensagem que será escrita na linha do log depois do reclock
                                cText += "[" + "C5_BXSTATU DEPOIS: " + AllTrim(SC5->C5_BXSTATU)   + "]"
                                cText += "[" + "C5_FSSTBI DEPOIS: "  + AllTrim(SC5->C5_FSSTBI )   + "]"
                                cText += "[" + "C5_BLQ DEPOIS: "     + AllTrim(SC5->C5_BLQ    )   + "]"
                                cText += "[" + "C5_LIBEROK DEPOIS: " + AllTrim(SC5->C5_LIBEROK)   + "]"
                                // Grava log no arquivo
                                oFile:Write(EncodeUTF8(cText + Chr(10) + (Chr(13))))
								EXIT
							Else
								SC5->C5_FSSTBI := "BLOQUEADO LO"
                                // Monta a mensagem que será escrita na linha do log depois do reclock
                                cText += "[" + "C5_BXSTATU DEPOIS: " + AllTrim(SC5->C5_BXSTATU)   + "]"
                                cText += "[" + "C5_FSSTBI DEPOIS: "  + AllTrim(SC5->C5_FSSTBI )   + "]"
                                cText += "[" + "C5_BLQ DEPOIS: "     + AllTrim(SC5->C5_BLQ    )   + "]"
                                cText += "[" + "C5_LIBEROK DEPOIS: " + AllTrim(SC5->C5_LIBEROK)   + "]"
                                // Grava log no arquivo
                                oFile:Write(EncodeUTF8(cText + Chr(10) + (Chr(13))))
							EndIf
						Else
							// Monta a mensagem que será escrita na linha do log antes do reclock
							cText := "[" + FwTimeStamp(2)       + "]"
                            cText += "[" + "CLIENTE: "          + AllTrim(SC5->C5_CLIENT )   + "]"
                            cText += "[" + "PEDIDO: "           + AllTrim(SC5->C5_NUM    )   + "]"
							cText += "[" + "C5_BXSTATU ANTES: " + AllTrim(SC5->C5_BXSTATU)   + "]"
							cText += "[" + "C5_FSSTBI ANTES: "  + AllTrim(SC5->C5_FSSTBI )   + "]"
							cText += "[" + "C5_BLQ ANTES: "     + AllTrim(SC5->C5_BLQ    )   + "]"
							cText += "[" + "C5_LIBEROK ANTES: " + AllTrim(SC5->C5_LIBEROK)   + "]"
							// Libera o pedido se o cliente não tiver valor negativo
							SC5->C5_BXSTATU := "L"
							SC5->C5_LIBEROK := "L"
							SC5->C5_BLQ     := ""
							SC5->C5_FSSTBI 	:= "LIBERADO"
                            // Monta a mensagem que será escrita na linha do log depois do reclock
                            cText += "[" + "C5_BXSTATU DEPOIS: " + AllTrim(SC5->C5_BXSTATU)   + "]"
                            cText += "[" + "C5_FSSTBI DEPOIS: "  + AllTrim(SC5->C5_FSSTBI )   + "]"
                            cText += "[" + "C5_BLQ DEPOIS: "     + AllTrim(SC5->C5_BLQ    )   + "]"
                            cText += "[" + "C5_LIBEROK DEPOIS: " + AllTrim(SC5->C5_LIBEROK)   + "]"
						    // Grava log no arquivo
                            oFile:Write(EncodeUTF8(cText + Chr(10) + (Chr(13))))
							EXIT
						EndIf

						// Salta para o próximo item do pedido (SC6)
						DBSkip()
					End
				SC5->(MsUnlock())
			EndIf

			// Retorna o ponteiro para a tabela de pedidos em aberto
			DBSelectArea("C5TEMP")
			DBSkip()
		End
	EndIf

	// Fecha o arquivo após o uso
	oFile:Close()
	oFile := NIL
	FreeObj(oFile)

	cText     := ""  // Auxiliar da montagem da linha do log
	oFile := FwFileWriter():New(cPath + cFilAnt + "_ENCERRADOS_" + FwTimeStamp() + ".txt", .T.)
	oFile:Create()

	// Fecha a tabela de pedidos em aberto caso o alias esteja em uso
	If (Select("MIAUMIAU") > 0)
		DBSelectArea("MIAUMIAU")
		DBCloseArea()
	EndIf

	//VERIFICA OS PEDIDOS QUE NÃO FECHARAM CORRETAMENTE BOMIX
	BEGINSQL ALIAS "MIAUMIAU"
		SELECT 
			C5_NUM AS NUME
		FROM 
			SC5010 
		WHERE 
			C5_NUM IN (
			SELECT DISTINCT C6_NUM FROM SC6010 WHERE (C6_BLQ='R' OR C6_QTDENT=C6_QTDVEN) AND C6_FILIAL='010101' AND D_E_L_E_T_='' AND C6_NUMORC<>'')
			AND C5_FILIAL='010101' 
			AND D_E_L_E_T_='' 
			AND C5_NOTA<>'' 
			AND C5_EMISSAO>'20200101' 
			AND C5_FSSTBI<>'ENCERRADO' 
			AND C5_TIPO='N'
	ENDSQL

	While !EOF()
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(FwXFilial("SC5") + MIAUMIAU->NUME)
		If (Found())
			SC5->(RecLock("SC5",.F.))
				C5_FSSTBI ='ENCERRADO' 
				C5_LIBEROK='E' 
				C5_BXSTATU=''
				cText := "[" + FwTimeStamp(2)       + "]"
				cText += "[" + "PEDIDO: "          + AllTrim(MIAUMIAU->NUME)   + "]"
				// Grava log no arquivo
				oFile:Write(EncodeUTF8(cText + Chr(10) + (Chr(13))))
			SC5->(MsUnlock())
		EndIf
		SC5->(DbCloseArea())
		DbSelectArea("MIAUMIAU")
		DbSkip()
	End

	MIAUMIAU->(DbCloseArea())

	oFile:Close()
	oFile := NIL
	FreeObj(oFile)

	RPCClearEnv() // Encerra as variáveis do ambiente
Return (NIL)

