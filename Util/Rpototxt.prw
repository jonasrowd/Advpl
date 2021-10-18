#Include 'Totvs.ch'

#Define SLASH IIf(IsSrvUnix(), "/", "\")
#Define CRLF Chr(10) + Chr(13)

/*/{Protheus.doc} Rpototxt
    Função para extrair informações do Rpo e salvar em txt separado por ;
    @type function
    @version 12.1.25
    @author Jonas Machado
    @since 10/09/2021
    @see https://tdn.totvs.com/display/tec/GetFuncArray
/*/
User Function Rpototxt()
    Local oArchive    := NIL      // Arquivo gerado com os fontesw
    Local nX          := 0
    Local cType       := ""
    Local cFile       := ""
    Local cFuncao     := ""
    Local cArch       := ""
    Local cSearch     := "U_MARKBLQ1"  // Neste caso, será exibido todos os fontes de usuário, seja fontes feitas por você ou Totvs.
    Local aFunction   := {}     // Para retornar a origem da função: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
    Local aType       := {}     // Para retornar o nome do arquivo onde foi declarada a função
    Local aFile       := {}     // Para retornar o número da linha no arquivo onde foi declarada a função
    Local aDate       := {}     // Para retornar a data da última modificação do código fonte compilado
    Local aTime       := {}     // Para retornar a hora da última modificação do código fonte compilado
    Local aLine       := {}
    Local aList       := {}
    Local cPath       := SLASH + "DIRDOC" + SLASH

    aFunction := GetFuncArray(cSearch, aType, aFile, aLine, aDate, aTime) //Captura as informações da function

    oArchive := FwFileWriter():New(cPath + "RPO" + "_" + FwTimeStamp() + ".txt", .T.) //Local e nome do arquivo
	oArchive:Create() //Cria o arquivo no local indicado

        For nX := 1 To Len(aFunction) //Percorre o array salvando as informações linha a linha
            cFile   := aFile[nX]
            cType   := Alltrim(aType[nX])
            cFuncao := aFunction[nX]
            aList   := {cFuncao, cFile, aType[nX], Replace(Substr(DtoC(aDate[nX]),6,6)+Substr(DtoC(aDate[nX]),3,4)+Substr(Dtoc(aDate[nX]),1,2),"/",""), aTime[nX]}

            cArch   := FwTimeStamp(2) + "; "
            cArch   += aList[1] + '; '
            cArch   += aList[2] + '; '
            cArch   += aList[3] + '; '
            cArch   += aList[4] + '; '
            cArch   += aList[5]

            oArchive:Write(EncodeUTF8(cArch) + CRLF) //Salva a informação no arquivo
        Next nX

    oArchive:Close()
    FreeObj(oArchive)

Return Nil
