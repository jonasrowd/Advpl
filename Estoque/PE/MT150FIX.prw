#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
���Programa  �MT150FIX  �Autor  �Adriano Alves      � Data �Outubro/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizadao fixar o campo C8_FSNOMEF no     ���
���          �no browser da tela de atualiza cotacao                       ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������͹��
���                     A L T E R A C O E S                               ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

User Function MT150FIX(a_Campos)

Local a_Campos	:= PARAMIXB
Local a_Camp	:= {}

For I:= 1 to Len(a_Campos)	
	aAdd(a_Camp, {a_Campos[I][1],a_Campos[I][2]})
	
	If (Alltrim(a_Campos[I][2]) == "C8_LOJA")
		aAdd(a_Camp, {"N Fantasia","C8_NREDUZ"})
	Endif
Next            

Return(a_Camp)