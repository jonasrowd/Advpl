
#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA410COR
	Ponto de entrada para inserir novas cores ao menu de vendas.
	@type Function
	@version 12.1.25
	@author Jonas Machado
	@since 09/08/2021
	@return Array, aCor, Contém as cores e regras selecionadas.
/*/
User function MA410COR ()
		
	Local aCor := aclone(PARAMIXB)

	If FWCodFil() != '030101'
		aCor[1][1] := "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU<>'B'" 
		aCor[3][1] := "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. SC5->C5_BXSTATU $ ('L|A')" 
		AADD(aCor,{"(!Empty(C5_LIBEROK) .AND. SC5->C5_BXSTATU=='E') .Or. (SC5->C5_BXSTATU=='E')" , "BR_MARROM"	})
		AADD(aCor,{"(!Empty(C5_LIBEROK) .AND. SC5->C5_BXSTATU=='B') .Or. (SC5->C5_BXSTATU=='B')" , "BR_PINK"		})
		AADD(aCor,{"(!Empty(C5_LIBEROK) .AND. SC5->C5_BXSTATU=='P') .Or. (SC5->C5_BXSTATU=='P')" , "BR_PRETO"		})						
	EndIf
		
Return aCor


/*
Local aCores 	:=	{	{ "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"	,	'ENABLE'		,	STR0264	},;		//Pedido em Aberto
						{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .jonAnd. Empty(C5_BLQ)"		,	'DISABLE'		,	STR0265	},;		//Pedido Encerrado
						{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)"	,	'BR_AMARELO'	,	STR0266	},;		//Pedido Liberado
						{ "C5_BLQ == '1'"												,	'BR_AZUL'		,	STR0267	},;		//Pedido Bloquedo por regra
						{ "C5_BLQ == '2'"												,	'BR_LARANJA'	,	STR0268	}}		//Pedido Bloquedo por verba
*/
