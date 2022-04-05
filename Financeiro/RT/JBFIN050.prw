#Include "Totvs.ch"

/*/{Protheus.doc} JBFIN050
    Rotina para excluir t�tulos gerados no contas a pagar
    @type Function
    @version 12.1.33
    @author Jonas Machado
    @since 05/04/2022
/*/
User Function JBFIN050()

    Local a_Vet := {}
    Local a_Tit := "SUP012022"  // N�mero do T�tulo
    Local a_Prx := "FIN"        // Prefixo
    Local a_Pcl := "001"        // Parcela
    Local a_Tip := "TNP"        // Tipo
    Local a_Nat := "040104"     // Natureza
    Local n_Opc := 5            // Op��o

    PRIVATE lMsErroAuto := .F.

    // Se estiver sem ambiente gr�fico
    If IsBlind()
        // Abre o ambiente
        RPCSetEnv("01")
    EndIf

    // Busca os t�tulos
    DbSelectArea("SE2")
    DbSetOrder(1)
    DbSeek(xFilial("SE2")+a_Prx+a_Tit+a_Pcl+a_Tip)

    // Inicia a transa��o
    Begin Transaction

        // La�o para percorrer todos os registros encontrados
        While (!EOF() .AND. SE2->E2_NUM==a_Tit .AND. SE2->E2_PARCELA == a_Pcl .AND. SE2->E2_NATUREZA=a_Nat)
            // Monta o vetor que ser� enviado para o execauto
            a_Vet :={;
                    {"E2_PREFIXO" ,a_Prx,Nil},;
                    {"E2_NUM"       ,a_Tit,Nil},;
                    {"E2_PARCELA"   ,a_Pcl,Nil},;
                    {"E2_TIPO"      ,a_Tip,Nil},;
                    {"E2_NATUREZ"   ,a_Nat,Nil};
                    }
                // Executa a rotina autom�tica
                MSExecAuto({|x,y,z| Fina050(x,y,z)},a_Vet,,n_Opc)
            // Salta para o pr�ximo registro
            DbSkip()
        // Finaliza o la�o de repeti��o
        End

        // Se houve erro na execu��o da rotina autom�tica
        If lMsErroAuto
            // Desfaz a transa��o
            DisarmTransaction()
            // Mostra o erro na tela, caso esteja em ambiente gr�fico
            MostraErro()
        Endif
    // Finaliza a transa��o
    End Transaction

    // Verifica se est� sem ambiente gr�fico
    If IsBlink()
        // Fecha o ambiente
        RPCCLEARENV()
    EndIf

Return (Nil)
