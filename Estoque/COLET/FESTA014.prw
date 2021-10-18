#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"
#include "Report.ch"
#INCLUDE "APVT100.CH"
#INCLUDE "TOPCONN.CH" 

User Function FESTA014
	Private a_Area     := GetArea()
	Private a_Tela     := VTSave(0, 0, 4, 10)
	Private c_Produto  := Space(TamSX3("B1_COD")[1])
	Private n_PrValid  := 0
	Private l_Rastro   := .F.
	Private c_Local    := "E2"
	Private c_Lote     := Space(TamSX3("D3_LOTECTL")[1] + 1)
	Private d_DtValid  := Ctod("  /  /    ")
	Private c_Endereco := Space(TamSX3("D3_LOCALIZ")[1])
	Private c_Contagem := Space(1)
	Private c_Seq      := "01"
	Private n_Quant    := 0
	Private c_Opcao    := Space(1)
	Private n_Lin      := 0
    Private c_Qry      := ""
	Private	c_User     := Padr(UsrRetName(__CUSERID), TamSX3("ZX_USUARIO")[1])
	Private	c_Hora     := SubStr(Time(), 1, 5)
	Private l_Inclui   := .F.
	Private n_Cont1    := 0
	Private n_Cont2    := 0

	VTClear Screen

	If Select("SZX") == 0
		ChkFile("SZX")
	Endif

	@ n_Lin++, 0 VTSAY "Produto: " VTGET c_Produto Pict "@!" Valid f_VldProd()
    VTRead

	If VtLastKey() == 27
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
	Endif

	@ n_Lin++, 0 VTSAY "Armazem: " VTGET c_Local Pict "@!" Valid f_VldArm()
    VTRead

	If VtLastKey() == 27
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
	Endif

	If l_Rastro	
		@ n_Lin++, 0 VTSAY "Lote: " VTGET c_Lote Pict "@!" Valid f_VldLote()
	    VTRead

		If VtLastKey() == 27
			RestArea(a_Area)
			VTClear Screen			
			VTRestore(0, 0, 4, 10, a_Tela)
			Return .F.
		Endif	
	Endif

	@ n_Lin++, 0 VTSAY "Endereço: " VTGET c_Endereco Pict "@!" Valid f_VldEnd()
    VTRead

	If VtLastKey() == 27
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
	Endif

	@ n_Lin++, 0 VTSAY "Contagem: " VTGET c_Contagem Pict "@R 9" Valid f_VldCont()
    VTRead

	If VtLastKey() == 27
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
	Endif

	@ n_Lin++, 0 VTSAY "Quantidade:"	VTGET n_Quant Pict "@E 99999.99" Valid n_Quant > 0
    VTRead

	If VtLastKey() == 27
		RestArea(a_Area)
		VTClear Screen			
		VTRestore(0, 0, 4, 10, a_Tela)
		Return .F.
	Endif

	@ n_Lin++, 0 VTSAY "Incluir (S/N)? " VTGET c_Opcao Pict "@!" Valid c_Opcao $ "SN"
   	VTRead

	VTClear Screen

    If Upper(c_Opcao) == "S"
		VTMsg("Aguarde...")

		Begin Transaction
			RecLock("SZX", .T.)
			SZX->ZX_FILIAL  := XFILIAL("SZX")
			SZX->ZX_PRODUTO := c_Produto
			SZX->ZX_LOCAL   := c_Local
			SZX->ZX_LOTECTL := c_Lote
			SZX->ZX_DTVALID := d_DtValid
			SZX->ZX_END     := c_Endereco
			SZX->ZX_QUANT   := n_Quant
			SZX->ZX_CONT    := c_Contagem
			SZX->ZX_SEQ     := c_Seq
			SZX->ZX_DATA    := DDATABASE
			SZX->ZX_STATUS  := "C"
			SZX->ZX_HORA    := c_Hora
			SZX->ZX_USUARIO := c_User
			MsUnlock()
		End Transaction

		dbSelectArea("SZX")
		dbSetOrder(1)
		dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco)
		While SZX->(!EoF()) .And. SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL + ZX_END) == xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco
			If (SZX->ZX_HORA == c_Hora) .And. (SZX->ZX_USUARIO == c_User) .And. (SZX->ZX_CONT == c_Contagem) .And. (SZX->ZX_SEQ == c_Seq) .And. (SZX->ZX_DATA == DDATABASE) .And. (SZX->ZX_QUANT == n_Quant)
				l_Inclui := .T.
			Endif

			If SZX->ZX_CONT == "1"
				n_Cont1 += SZX->ZX_QUANT
			ElseIf SZX->ZX_CONT == "2"
				n_Cont2 += SZX->ZX_QUANT
			Endif

			SZX->(dbSkip())
		End

		If l_Inclui
			If (c_Contagem == "1" .Or. c_Contagem == "3") .Or. (c_Contagem == "2" .And. n_Cont1 == n_Cont2)
				VTAlert("Inventário da contagem " + c_Contagem + " foi gravado com sucesso.", "Aviso")
			ElseIf (c_Contagem == "2") .And. (n_Cont1 <> n_Cont2)
				VTAlert("Inventário da contagem " + c_Contagem + " foi gravado com sucesso, porém divergências foram encontradas entre a primeira e a segunda contagem deste item.", "Aviso")
			Endif
		Else
			VTAlert("Ocorreu um erro durante o processo de gravação e o inventário da contagem " + c_Contagem + " não foi incluído.", "Aviso")
		Endif
	Else
		VTAlert("Inventário cancelado pelo usuário.", "Aviso")
    Endif

	RestArea(a_Area)
	VTClear Screen			
	VTRestore(0, 0, 4, 10, a_Tela)
Return



Static Function f_VldProd
	Local l_Ret := .F.

	If Empty(c_Produto)
		VTAlert("Produto inválido.", "Aviso")
	Else
	   	dbSelectArea("SB1")
	   	dbSetOrder(1)
	   	If dbSeek(xFilial("SB1") + c_Produto)
	   		If SB1->B1_MSBLQL <> "1"
				n_PrValid := SB1->B1_PRVALID
			   	l_Rastro  := IIF(SB1->B1_RASTRO == "L", .T., .F.)
			   	l_Ret     := .T.
			 Else
				VTAlert("Registro bloqueado para uso.", "Aviso")
			 Endif
		Else
			VTAlert("Produto " + AllTrim(c_Produto) + " não foi encontrado no Cadastro de Produtos. Por favor verifique se o código do produto foi digitado corretamente.", "Aviso")
		Endif
	Endif
Return l_Ret



Static Function f_VldArm
	Local l_Ret := .F.

	If Empty(c_Local)
		VTAlert("Armazém inválido.", "Aviso")
	Else
		dbSelectArea("NNR")
		dbSetOrder(1)
		If dbSeek(xFilial("NNR") + c_Local)
			l_Ret := .T.
		Else
			VTAlert("Armazém " + AllTrim(c_Local) + " não foi encontrado no Cadastro de Armazéns. Por favor verifique se o código do armazém foi digitado corretamente.", "Aviso")
		Endif
	Endif
Return l_Ret

Static Function f_VldLote
	Local l_Ret := .F.

	If Empty(c_Lote)
		VTAlert("Lote inválido para produto com controle de rastreabilidade.", "Aviso")
	Else
	    c_Lote := Padr(c_Lote, TamSX3("D3_LOTECTL")[1])
	
		c_Qry := " SELECT B8_LOTECTL, B8_DTVALID FROM " + RetSqlName("SB8") + " SB8 " + chr(13)
	  	c_Qry += " WHERE B8_FILIAL='" + XFILIAL("SB8") + "' AND B8_LOCAL = '" + c_Local + "' AND B8_PRODUTO = '" + c_Produto + "' AND B8_LOTECTL = '" + c_Lote + "' AND SB8.D_E_L_E_T_<>'*' " + chr(13)
	
		TCQUERY c_Qry NEW ALIAS QRY
	
		dbSelectArea("QRY")
		dbGoTop()
		If QRY->(!EoF())
		   	d_DtValid := Stod(QRY->B8_DTVALID)
			l_Ret     := .T.
		Else
			If VTYesNo("Lote " + AllTrim(c_Lote) + " não foi encontrado. Deseja confirmar a utilização deste lote?", "Atenção")
			   	d_DtValid := DaySum(DDATABASE, IIF(n_PrValid > 0, n_PrValid, 365))
				l_Ret := .T.
			Endif
		End

		QRY->(dbCloseArea())
	Endif
Return l_Ret



Static Function f_VldEnd
	Local l_Ret := .F.

    c_Endereco := Padr(c_Endereco, TamSX3("ZX_END")[1])

	dbSelectArea("SZY")
	dbSetOrder(1)
	If dbSeek(xFilial("SZY") + c_Endereco)
		l_Ret := .T.
	Else
		If Empty(c_Endereco)
			VTAlert("Endereço inválido.", "Aviso")
		Else
			VTAlert("Endereço " + AllTrim(c_Endereco) + " não foi encontrado no Cadastro de Endereços do Armazém E2. Por favor verifique se o código do endereço foi digitado corretamente.", "Aviso")
		Endif
	Endif
Return l_Ret
	

	
Static Function f_VldCont
	Local l_Ret      := .F.
	Local l_Continua := .F.
	Local n_Conta1   := 0
	Local n_Conta2   := 0
	Local l_Conta1   := .F.
	Local l_Conta2   := .F.

	If c_Contagem $ "123"
		dbSelectArea("SZX")
		dbSetOrder(1)
		If dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + c_Contagem)
			If c_Contagem == "1"
				dbSelectArea("SZX")
				dbSetOrder(1)
				If dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + "2")
					VTAlert("A contagem 2 deste item neste endereço já foi iniciada, portanto não é possível utilizar a contagem 1 para este item.", "Aviso")
				Else
					l_Continua := .T.
				Endif
			ElseIf c_Contagem == "2"
				dbSelectArea("SZX")
				dbSetOrder(1)
				If dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + "3")
					VTAlert("A contagem 3 deste item neste endereço já foi iniciada, portanto não é possível utilizar a contagem 2 para este item.", "Aviso")
				Else
					l_Continua := .T.
				Endif
			Endif
            
			If l_Continua
				If VTYesNo("Este registro já foi cadastrado para esta contagem. Deseja confirmar a utilização desta contagem para incluir mais itens?", "Atenção")
					dbSelectArea("SZX")
					dbSetOrder(1)
					dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + c_Contagem)
					While SZX->(!EoF()) .And. SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL + ZX_END + ZX_CONT) == xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + c_Contagem
						c_Seq := Soma1(SZX->ZX_SEQ)

						SZX->(dbSkip())
					End

					l_Ret := .T.
				Endif
			Endif
		Else
			If c_Contagem == "1"
				l_Ret := .T.
			ElseIf c_Contagem == "2"
				dbSelectArea("SZX")
				dbSetOrder(1)
				If dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco + "1")
					l_Ret := .T.
				Else
					VTAlert("Não é possível iniciar a contagem 2 antes de iniciar a contagem 1.", "Aviso")
				Endif
			Else
				dbSelectArea("SZX")
				dbGoTop()
				dbSetOrder(1)
				dbSeek(xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco)
				While SZX->(!EoF()) .And. SZX->(ZX_FILIAL + ZX_PRODUTO + ZX_LOCAL + ZX_LOTECTL + ZX_END) == xFilial("SZX") + c_Produto + c_Local + c_Lote + c_Endereco
					If SZX->ZX_CONT == "1"
						l_Conta1 := .T.
						n_Conta1 += SZX->ZX_QUANT
					Elseif SZX->ZX_CONT == "2"
						l_Conta2 := .T.
						n_Conta2 += SZX->ZX_QUANT
					Endif

					SZX->(dbSkip())
				End

				If l_Conta1 .And. l_Conta2 .And. n_Conta1 <> n_Conta2
					l_Ret := .T.
				Elseif l_Conta1 .And. l_Conta2 .And. n_Conta1 == n_Conta2
					VTAlert("Não é possível efetuar a contagem 3 deste item, pois não houve divergências entre a primeira e a segunda contagem.", "Aviso")
				Elseif (l_Conta1 == .F.) .Or. (l_Conta2 == .F.)
					VTAlert("Não é possível iniciar a contagem 3 antes de iniciar as contagens 1 e 2.", "Aviso")
				Endif
			Endif
		Endif
	Else
		VTAlert("Contagem inválida. Apenas contagens de 1 até 3 são permitidas.", "Aviso")
	Endif
Return l_Ret