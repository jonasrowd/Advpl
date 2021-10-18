#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
���Programa  �MTA130C8  �Autor  �Welington Junior   � Data �Outubro/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizado para preencher o nome fantasia do���
���          �do fornecedor na SC8 - Campo customizado C8_NREDUZ          ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

User Function MTA130C8()

Local cFantasia
Local a_Area := GetArea()

DbSelectArea("SA2")
DbSetOrder(1)
If DbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA)
	cFantasia := SA2->A2_NREDUZ
	
	DbSelectArea("SC8")
	RecLock("SC8",.F.)
		SC8->C8_NREDUZ := cFantasia
	MsUnLock()
Endif

RestArea(a_Area)

Return Nil