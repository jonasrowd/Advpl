#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FPCPM003/FPCPM004   �Autor  � Christian Rocha    �    �    ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para retornar a hora e o turno para o Relat�rio de  ���
���          � Perdas													  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAPCP          										  ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FPCPM003
	Local a_Area  := GetArea()
	Local c_IdEnt := Posicione("SD3",4,XFILIAL("SD3")+(ALIAS())->BC_NUMSEQ,"D3_IDENT")
	Local c_Hora  := ""

	c_Qry := " SELECT * FROM " + RetSqlName("SH6") + " SH6 WHERE H6_IDENT = '" + c_IdEnt + "' AND SH6.D_E_L_E_T_<>'*' AND H6_FILIAL = '" + xFilial("SH6") + "' "

	TCQUERY c_Qry NEW ALIAS QRY

	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!EoF())
		c_Hora := QRY->H6_HORAFIN
	Endif
  	QRY->(dbCloseArea())

	RestArea(a_Area)
Return c_Hora

User Function FPCPM004
	Local a_Area  := GetArea()
	Local c_IdEnt := Posicione("SD3",4,XFILIAL("SD3")+(ALIAS())->BC_NUMSEQ,"D3_IDENT")
	Local c_Turno := ""

	c_Qry := " SELECT * FROM " + RetSqlName("SH6") + " SH6 WHERE H6_IDENT = '" + c_IdEnt + "' AND SH6.D_E_L_E_T_<>'*' AND H6_FILIAL = '" + xFilial("SH6") + "' "

	TCQUERY c_Qry NEW ALIAS QRY

	dbSelectArea("QRY")
	dbGoTop()
	If QRY->(!EoF())
		c_Turno := QRY->H6_FSTURNO
	Endif
  	QRY->(dbCloseArea())

	RestArea(a_Area)
Return c_Turno