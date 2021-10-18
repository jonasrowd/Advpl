#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada para validar os dados da Produção PCP Mod2
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
/*/
User Function MT680VAL
	Local a_Area    := GetArea()
	Local l_Ret     := .T.
	Local n_Op		:= M->H6_OP

	If l_Ret .And. l681
		DbSelectArea("SZ7") //Seleciona a área da tabela customizada que controla as movimentações de estoque para o wms
		DbSetOrder(1)
		DbSeek(FwXFilial("SZ7") + __CUSERID + M->H6_LOCAL)	//Busca a informação do usuário na tabela da rotina customizada
		If !("TOTVSMES" $ M->H6_OBSERVA)
			If !(Z7_TPMOV $ "E|A")	//Se NÃO vier do WebService MES ou o usuário não tenha permissão de entrada no estoque do wms. (E=Entrada, A=Ambos)
				lRet := .F.	//Não permite o apontamento e exibe o Help do bloqueio.
				Help(NIL, NIL, "MOV_ARM", NIL, "O seu usuário não possui permissão para efetuar este tipo de movimentação no armazém " + M->H6_LOCAL + ".",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			ElseIf (M->H6_QTDPERD > 0 .And. lSavePerda == .F. .And. M->H6_PT == "T")
				//Identifica se é apontamento de perda pela quantidade apontada no campo H6_QTDPERD.
				//lSavePerda é variável privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
				//Verifica também que o apontamento de perda não pode ser Total, ou seja, não pode encerrar OP com Perda.
				//Caso não, bloqueia a gravação do apontamento de perda e exibe o Help do bloqueio.
				lRet := .F.
				M->H6_PT := "P"
				Help(NIL, NIL, "ERROR_PERD", NIL, "Apontamento de perda preenchido incorretamente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os dados do apontamento e lembre-se que não pode encerrar a Op com Perda."})
			EndIf
		EndIf

		DBSELECTAREA('SB1')
		DBSETORDER(1)
		DBSEEK(XFILIAL('SB1') + M->H6_PRODUTO)
		If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID)
			nCount := SB1->B1_PRVALID
		EndIf
		
		If Select("SH6TEMP") > 0 //Verifica se o Alias já possui registro
			SH6TEMP->(DbCloseArea()) //Fecha a tabela se já estiver aberta
		EndIf

		//SELECIONA OS REGISTROS DA OP
		BEGINSQL ALIAS "SH6TEMP" 
			COLUMN H6_DTVALID AS DATE

			SELECT
				TOP 1
				H6.H6_DTVALID AS FSDTVLD
			FROM
				%TABLE:SH6% H6
			WHERE
				H6.H6_FILIAL = %XFILIAL:SH6% AND
				H6.H6_OP = %EXP:n_Op% AND
				H6.%NOTDEL%
			ORDER BY H6.H6_DTVALID DESC
		ENDSQL

		If !Empty(SH6TEMP->FSDTVLD) //Se não é o primeiro apontamento
			While SH6TEMP->(!EOF())//Enquanto não for o final do arquivo procura se já tem uma validade preenchida em qualquer item da Op
				M->H6_DTVALID := SH6TEMP->FSDTVLD //Armazena a data de validade da Op
			DbSkip()
			End
		EndIf

		SH6TEMP->(DbCloseArea())

		DBSelectArea('SC2')
		DbSetOrder(1)
		If DbSeek(xFilial("SC2")+ SUBSTR(M->H6_OP,1,6) + SUBSTR(M->H6_OP,7,2) + SUBSTR(M->H6_OP,9,3))
			If (Found())
				If Empty(M->H6_DTVALID)
					M->H6_DTVALID := date() + nCount
				EndIf
				If  Empty(SC2->C2_FSDTVLD)
					RecLock('SC2',.F.)
						SC2->C2_FSDTVLD := M->H6_DTVALID
						If Empty(SC2->C2_FSLOTOP) 
							SC2->C2_FSLOTOP:= M->H6_LOTECTL
						EndIf
					SC2->(MsUnlock())
				Else 
					M->H6_DTVALID := SC2->C2_FSDTVLD
				EndIf
			EndIf
		EndIf
		DbSelectArea("SG2") //Seleciona a área da SG2 para preencher o apontamento com informações da estrutura do produto
		DbSetOrder(3)
		If (DbSeek(FwXFilial("SG2")+ M->H6_PRODUTO + M->H6_OPERAC))
			M->H6_FERRAM  := SG2->G2_FERRAM //Preenche a ferramenta
			M->H6_FSCAVI  := SG2->G2_FSCAVI //Preenche a cavidade
			M->H6_FSSETOR := SG2->G2_DESCRI //Preenche a descrição do setor
			M->H6_CICLOPD := SG2->G2_FSCICLO //Preenche o ciclo padrão
		EndIf
	EndIf

	RestArea(a_Area)

Return l_Ret
