#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA651FIL   �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada respons�vel por filtrar a tabela de Ordens���
���          � de Produ��o, antes da execu��o do Browse.				  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
���          � Este ponto de entrada est� sendo utilizado para filtrar as ���
���          � Ordens de Produ��o que n�o s�o de arte.					  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA651FIL()
	Local c_Filtro := PARAMIXB[1]   //Filtro Padr�o

	c_Filtro += " .And. (C2_FSARTE = '2' .Or. C2_FSARTE = ' ')"   //Filtra apenas as OPs Previstas que n�o s�o de arte
Return( c_Filtro )