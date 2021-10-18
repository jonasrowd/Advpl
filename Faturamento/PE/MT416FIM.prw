// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} MT416FIM
	Ponto de entrada acionado após o termino da efetivação do Orçamento de Venda
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 21/07/2021
	@see https://tdn.totvs.com/display/public/PROT/MT416FIM
/*/
User Function MT416FIM
	Local nX         := 0                                        // 
	Local aArea      := GetArea()                                // Armazena a área atual
	Local nAtrasados := U_FFATVATR(M->C5_CLIENTE, M->C5_LOJACLI) // Retorna o valor de títulos em aberto

	// Processa apenas se não for a filial 030101
	If (FwCodFil() != "030101")

		// Realiza a gravação complementar
		// no cabeçalho do pedido de venda
		DBSelectArea("SC5")
		RecLock("SC5", .F.)
			// Se houver saldo em atraso, bloqueia o pedido
			If (nAtrasados != 0)
				C5_BXSTATU := "B"
				C5_BLQ     := "B"
				C5_LIBEROK := "S"

				// TODO Verificar a chamada deste ponto de entrada e avalidação de apenas uma linha
				For nX := 1 To Len(aCols)
					If (GDFieldGet("C6_FSGEROP", nX) == "1")
						C5_FSSTBI	:= "BLOQUEADO PR" //NÃO PODE BOTAR DATA NO PCP E NÃO GERA OP
						EXIT
					Else
						C5_FSSTBI 	:= "BLOQUEADO LO" //PODE BOTAR DATA NO PCP 
					EndIf
				Next nX

				Help(NIL, NIL, "CLIENTE_ATRASO", NIL, "Existem restrições financeiras para este cliente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Por favor solicitar liberação ao departamento comercial."})
			Else
				C5_BXSTATU := "L"
				C5_BLQ     := " "
				C5_LIBEROK := "L"
				C5_FSSTBI 	:= "LIBERADO"
			EndIf
		MsUnlock()
	EndIf

	// Restaura a área de trabalho anterior
	RestArea(aArea)
Return (NIL)
