// Bibliotecas Necessárias
#Include 'Totvs.ch'

/*/{Protheus.doc} CNNINS
	Rotina para inserir usuário e permitir controle total em um contrato do módulo Gestão de Contratos
	@type Function
	@version 12.1.33
	@author Jonas Machado
	@since 08/04/2022
/*/
User Function CNNINS()

	Local c_UsrCod := SuperGetMV("PR_USRGPTI",.F.,"001070") // Parâmetro para que possa utilizar a rotina
	Local c_GrpCod := SPACE(TamSX3("CNN_GRPCOD")[1]) // Não utilizamos grupo de usuários
	Local c_TraCod := "001" // Permissão de controle total
	Local c_Pergs  := "GPTPAR" // Nome da pergunta a ser inserida ou alterada no dicionário
	Local a_Area   := GetArea() // Salva a Área
	Local oSX1	   := Nil          //Objeto para instanciar a classe de criar perguntas na Sx1

	// Cria instância da classe
    oSX1 := CreateSX1():New(c_Pergs)
    // Adiciona novos itens na SX1
    oSX1:NewItem({01, "Contrato?",  "MV_CH2", "C", TamSX3("CN9_NUMERO")[1], 00, "G", "CN9"})
    oSX1:NewItem({02, "Usuário?",   "MV_CH1", "C", 06, 00, "G", "USR"})
	// Insere ou atualiza os dados da pergunta
    oSX1:Commit()

	// Validação para executar a permissão
    If (Pergunte(c_Pergs, .T.) .AND. RetCodUsr() $ c_UsrCod)
		// Verifica se não existe o registro
		DbSelectArea("CNN")
		DbSetOrder(1)
		If !(DbSeek(FwXFilial("CNN") + MV_PAR01 + MV_PAR02) .AND. EMPTY(MV_PAR01) .AND. EMPTY(MV_PAR02))
			RecLock("CNN", .T.)
				CNN_FILIAL := FwXFilial()
				CNN_CONTRA := MV_PAR01
				CNN_USRCOD := MV_PAR02
				CNN_GRPCOD := c_GrpCod
				CNN_TRACOD := c_TraCod
			MsUnlock()

			MsgInfo("Usuário inserido com sucesso.", "CNN Table")
		Else
			// Se já existir o registro, exibe alerta.
			MsgAlert("Usuário já cadastrado para este contrato,", "CNN Table")
		EndIf
	EndIf

	// Restaura a área anterior
	RestArea(a_Area)

Return (Nil)
