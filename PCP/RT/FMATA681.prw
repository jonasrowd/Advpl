#Include 'FIVEWIN.CH'

User Function FMATA681
	Local cQuery := ""
	Local aVetor := {}

	Private lMsHelpAuto := .F.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .F.	// Determina se houve alguma inconsistencia na execucao da rotina

	cQuery := " SELECT * FROM " + RetSqlName("SH6") + " WHERE D_E_L_E_T_ = '' AND H6_DATAINI BETWEEN '20150330' AND '20150418' AND H6_FILIAL = '" + xFilial("SH6") + "' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EST",.T.,.T.)
	
	dbSelectArea("EST")
	While EST->(!EoF())
		aVetor := { {"H6_FILIAL",			EST->H6_FILIAL,		Nil},;
					{"H6_OP",				EST->H6_OP,			Nil},;
					{"H6_PRODUTO", 			EST->H6_PRODUTO,	Nil},;
					{"H6_OPERAC",			EST->H6_OPERAC,		Nil},;
					{"H6_SEQ",				EST->H6_SEQ,		Nil},;
					{"H6_DATAINI",			Stod(EST->H6_DATAINI),	Nil},;
					{"H6_HORAINI",			EST->H6_HORAINI,	Nil},;
					{"H6_DATAFIN",			Stod(EST->H6_DATAFIN),	Nil},;
					{"H6_HORAFIN",			EST->H6_HORAFIN,	Nil},;
					{"INDEX",				1 ,NIL}} 			// PASSAR O INDICE UTILIZADO PARA ESTORNO

		Begin Transaction
			MSExecAuto({|x,Z| MATA681(x,Z)},aVetor,5)

			If lMsErroAuto
				Mostraerro()
			Endif
		End Transaction


		EST->(dbSkip())
	End

	EST->(dbCloseArea())
Return