#Include "Totvs.ch"

/*/{Protheus.doc} JBFIN050
    Rotina para excluir títulos gerados no contas a pagar
    @type Function
    @version 12.1.33
    @author Jonas Machado
    @since 05/04/2022
/*/
User Function JBFIN050()

    Local a_Vet := {}
    Local a_Tit := "SUP012022"  // Número do Título
    Local a_Prx := "FIN"        // Prefixo
    Local a_Pcl := "001"        // Parcela
    Local a_Tip := "TNP"        // Tipo
    Local a_Nat := "040104"     // Natureza
    Local n_Opc := 5            // Opção

    PRIVATE lMsErroAuto := .F.

    // Se estiver sem ambiente gráfico
    If IsBlind()
        // Abre o ambiente
        RPCSetEnv("01")
    EndIf

    // Busca os títulos
    DbSelectArea("SE2")
    DbSetOrder(1)
    DbSeek(xFilial("SE2")+a_Prx+a_Tit+a_Pcl+a_Tip)

    // Inicia a transação
    Begin Transaction

        // Laço para percorrer todos os registros encontrados
        While (!EOF() .AND. SE2->E2_NUM==a_Tit .AND. SE2->E2_PARCELA == a_Pcl .AND. SE2->E2_NATUREZA=a_Nat)
            // Monta o vetor que será enviado para o execauto
            a_Vet :={;
                    {"E2_PREFIXO" ,a_Prx,Nil},;
                    {"E2_NUM"       ,a_Tit,Nil},;
                    {"E2_PARCELA"   ,a_Pcl,Nil},;
                    {"E2_TIPO"      ,a_Tip,Nil},;
                    {"E2_NATUREZ"   ,a_Nat,Nil};
                    }
                // Executa a rotina automática
                MSExecAuto({|x,y,z| Fina050(x,y,z)},a_Vet,,n_Opc)
            // Salta para o próximo registro
            DbSkip()
        // Finaliza o laço de repetição
        End

        // Se houve erro na execução da rotina automática
        If lMsErroAuto
            // Desfaz a transação
            DisarmTransaction()
            // Mostra o erro na tela, caso esteja em ambiente gráfico
            MostraErro()
        Endif
    // Finaliza a transação
    End Transaction

    // Verifica se está sem ambiente gráfico
    If IsBlink()
        // Fecha o ambiente
        RPCCLEARENV()
    EndIf

Return (Nil)
