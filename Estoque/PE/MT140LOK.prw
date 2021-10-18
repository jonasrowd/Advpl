#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPonto de entrada ³ MT140LOK	 ºAutor  ³ Christian Rocha    º Data ³ 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Valida informações preenchidas no aCols de cada item do   º±±
±±º           ³ pré-documento de entrada.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservação ³ Ponto de entrada desenvolvido para impedir o cadastro de  º±±
±±º           ³ pré-nota de entrada sem o lote do fornecedor quando o 	  º±±
±±º           ³ produto possuir controle de rastreabilidade.              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT140LOK
	Local c_Produto := ''
	Local c_LoteFor := ''
	Local c_Rastro  := ''
	Local l_Ret     := .T.

   	If aCols[n][Len( aHeader )+1] == .F.
		c_Produto := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_COD'})]
		c_Rastro  := Posicione("SB1", 1, xFilial("SB1")+c_Produto, "B1_RASTRO")

		If c_Rastro == 'L'
			c_LoteFor := aCols[n][AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_LOTEFOR'})]

			If Empty(c_LoteFor)
				ShowHelpDlg(SM0->M0_NOME, {"O campo Lote Fornec. é obrigatório quando o produto possui controle de rastreabilidade."},5,;
                                 			  {"Preencha o campo Lote Fornec. deste item."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
Return l_Ret