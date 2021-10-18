/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบPrograma  ณ A710PAR    บAutor  ณ Christian Rocha    บ      ณ           บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ O ponto de entrada A710PAR permite alterar a parametriza็ใoบฑฑ
ฑฑบ          ณ inicial do MRP.									 		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Estoque/Custos, SIGAPCP - Planej. Contr. Prod.   บฑฑ
ฑฑฬ          ณ Este ponto de entrada estแ sendo utilizado para impedir a  นฑฑ
ฑฑบ          ณ utiliza็ใo de OPs Firmes na rotina MRP.                    บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑบ          บ                  บ                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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