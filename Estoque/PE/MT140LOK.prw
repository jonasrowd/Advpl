#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Ponto de entrada � MT140LOK	 �Autor  � Christian Rocha    � Data � 	  ���
�������������������������������������������������������������������������͹��
���Desc.      � Valida informa��es preenchidas no aCols de cada item do   ���
���           � pr�-documento de entrada.                                 ���
�������������������������������������������������������������������������͹��
���Observa��o � Ponto de entrada desenvolvido para impedir o cadastro de  ���
���           � pr�-nota de entrada sem o lote do fornecedor quando o 	  ���
���           � produto possuir controle de rastreabilidade.              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				ShowHelpDlg(SM0->M0_NOME, {"O campo Lote Fornec. � obrigat�rio quando o produto possui controle de rastreabilidade."},5,;
                                 			  {"Preencha o campo Lote Fornec. deste item."},5)
				l_Ret := .F.
			Endif
		Endif
	Endif
Return l_Ret