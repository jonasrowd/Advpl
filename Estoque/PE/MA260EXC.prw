/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA260EXC/MA261EXC  � 			            �     �  		  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para excluir o registro da tabela SZW     ���
���          � quando a transfer�ncia associada ao registro � estornada   ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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