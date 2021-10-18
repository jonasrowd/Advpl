#Include 'Totvs.ch'

/*/{Protheus.doc} MT680VAL
	Ponto de entrada solicitado pelo setor de Pcp com regras para apontamento de produ��o.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 30/07/2021
	@return variant, Logical
/*/
User Function MT680VAL()
	Local a_Area    := GetArea()
	Local l_Ret     := .T.
	Local n_Op		:= M->H6_OP

	If l_Ret .And. l681
		DbSelectArea("SZ7") //Seleciona a �rea da tabela customizada que controla as movimenta��es de estoque para o wms
		DbSetOrder(1)
		DbSeek(FwXFilial("SZ7") + __CUSERID + M->H6_LOCAL)	//Busca a informa��o do usu�rio na tabela da rotina customizada
		If !("TOTVSMES" $ M->H6_OBSERVA)
			If !(Z7_TPMOV $ "E|A")	//Se N�O vier do WebService MES ou o usu�rio n�o tenha permiss�o de entrada no estoque do wms. (E=Entrada, A=Ambos)
				lRet := .F.	//N�o permite o apontamento e exibe o Help do bloqueio.
				Help(NIL, NIL, "MOV_ARM", NIL, "O seu usu�rio n�o possui permiss�o para efetuar este tipo de movimenta��o no armaz�m " + M->H6_LOCAL + ".",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Contacte o administrador do sistema."})
			ElseIf (M->H6_QTDPERD > 0 .And. lSavePerda == .F. .And. M->H6_PT == "T")
				//Identifica se � apontamento de perda pela quantidade apontada no campo H6_QTDPERD.
				//lSavePerda � vari�vel privada da rotina de apontamento de perda que verifica se foi preenchida corretamente.
				//Verifica tamb�m que o apontamento de perda n�o pode ser Total, ou seja, n�o pode encerrar OP com Perda.
				//Caso n�o, bloqueia a grava��o do apontamento de perda e exibe o Help do bloqueio.
				lRet := .F.
				M->H6_PT := "P"
				Help(NIL, NIL, "ERROR_PERD", NIL, "Apontamento de perda preenchido incorretamente.",;
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os dados do apontamento e lembre-se que n�o pode encerrar a Op com Perda."})
			EndIf
		EndIf

		DBSELECTAREA('SB1')
		DBSETORDER(1)
		DBSEEK(XFILIAL('SB1') + M->H6_PRODUTO)
		If SB1->B1_RASTRO == 'L' .AND. !EMPTY(SB1->B1_PRVALID)
			nCount := SB1->B1_PRVALID
		EndIf
		
		If Select("SH6TEMP") > 0 //Verifica se o Alias j� possui registro
			SH6TEMP->(DbCloseArea()) //Fecha a tabela se j� estiver aberta
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

		If !Empty(SH6TEMP->FSDTVLD) //Se n�o � o primeiro apontamento
			While SH6TEMP->(!EOF())//Enquanto n�o for o final do arquivo procura se j� tem uma validade preenchida em qualquer item da Op
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
		DbSelectArea("SG2") //Seleciona a �rea da SG2 para preencher o apontamento com informa��es da estrutura do produto
		DbSetOrder(3)
		If (DbSeek(FwXFilial("SG2")+ M->H6_PRODUTO + M->H6_OPERAC))
			M->H6_FERRAM  := SG2->G2_FERRAM //Preenche a ferramenta
			M->H6_FSCAVI  := SG2->G2_FSCAVI //Preenche a cavidade
			M->H6_FSSETOR := SG2->G2_DESCRI //Preenche a descri��o do setor
			M->H6_CICLOPD := SG2->G2_FSCICLO //Preenche o ciclo padr�o
		EndIf
	EndIf

	RestArea(a_Area)

Return l_Ret
