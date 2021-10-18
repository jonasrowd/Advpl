/*
�����������������������������������������������������������������������������
���Programa  � A710PAR    �Autor  � Christian Rocha    �      �           ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada A710PAR permite alterar a parametriza��o���
���          � inicial do MRP.									 		  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   ���
���          � Este ponto de entrada est� sendo utilizado para impedir a  ���
���          � utiliza��o de OPs Firmes na rotina MRP.                    ���
�������������������������������������������������������������������������͹��
���Data      �Programador       �Alteracoes                               ���
���          �                  �                                         ���
�����������������������������������������������������������������������������
*/

User Function A710PAR()

Local _nTipPer  := Paramixb[1]
Local _nQuantPer:= Paramixb[2]
Local _a711Tipo := Paramixb[3]
Local _a711Grupo:= Paramixb[4]
Local _lPedido  := Paramixb[5]
Local aRet      := {}

aadd(aRet,{_nTipPer ,_nQuantPer,_a711Tipo,_a711Grupo,_lPedido})

DbSelectArea("SX1")
DbGoTop()
DbSeek("MTA712    ")
While !Eof() .And. X1_GRUPO == "MTA712    "
	If X1_ORDEM == "10"
		RecLock("SX1", .F.)
	 		X1_VALID  := "EXECBLOCK(U_FPCPV001(MV_PAR10))"
	 		X1_PRESEL := 2
		MsUnLock()
		Exit
	Endif
	
	DbSkip()
Enddo

Return aRet