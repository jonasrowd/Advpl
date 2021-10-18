/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA260EXC/MA261EXC  º 			            º     ³  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para excluir o registro da tabela SZW     º±±
±±º          ³ quando a transferência associada ao registro é estornada   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MA260EXC
	Local a_Area := GetArea()

	dbSelectArea("SZW")
	dbSetOrder(4)
	dbSeek(xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ)
	While SZW->(!EoF()) .AND. SZW->(ZW_FILIAL + ZW_DOC + ZW_NUMSEQ) == xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ
		RecLock("SZW", .F.)
		dbDelete()
		MsUnlock()

		SZW->(dbSkip())
	End

	RestArea(a_Area)
Return Nil



User Function MA261EXC
	Local a_Area := GetArea()

	dbSelectArea("SZW")
	dbSetOrder(4)
	dbSeek(xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ)
	While SZW->(!EoF()) .AND. SZW->(ZW_FILIAL + ZW_DOC + ZW_NUMSEQ) == xFilial("SZW") + SD3->D3_DOC + SD3->D3_NUMSEQ
		RecLock("SZW", .F.)
		dbDelete()
		MsUnlock()

		SZW->(dbSkip())
	End

	RestArea(a_Area)
Return Nil