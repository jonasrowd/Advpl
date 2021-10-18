#Include 'Totvs.ch'
#Include 'Parmtype.ch'

/*/{Protheus.doc} MA416COR
	Acrescenta novas cores de legenda.
	@type function
	@version 12.1.25
	@author Rômulo Ferreira
	@since 09/08/2021
	@return Array, Retorna as novas cores de status.
	@see https://tdn.engpro.totvs.com.br/display/public/PROT/MA416COR+-+Alterar+cores+do+browse+do+cadastro
/*/
User Function MA416COR()

	Local aCor := aclone(PARAMIXB)
	
	If (FWCodFil() != '030101') //Se não for filial 03, segue o fonte
		aCor[1]:= {"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU<>'B'" , "ENABLE"    }
		aCor[2]:= {"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU<>'B'" , "DISABLE"   }
		AADD(aCor,{"SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_PINK"   })
		AADD(aCor,{"SCJ->CJ_STATUS=='B' .AND. SCJ->CJ_BXSTATU=='B'" , "BR_AZUL_CLARO"   })
	EndIf

Return aCor
