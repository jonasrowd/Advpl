#include "protheus.ch"
#include "tbiconn.ch"
#include "totvs.ch"
#include "apwebsrv.ch"

//WSSTRUCT Stru040 //EXEMPLO DE WS COM EXECAUTO Mata240

WSSERVICE JOB_WS_01010101

WSDATA ccod AS string
WSDATA cRet AS string

WSMETHOD cMata240

ENDWSSERVICE


WSMETHOD cMata240 WSRECEIVE ccod WSSEND cRet WSSERVICE JOB_WS_01010101

local aItem := {}
local cDoc := '000000028'
local dDatav:= CTOD("2018/10/02")
local cProd := "P11 "
local nOpc := 3
Local nQtd := 10
local dEmissao := dDataBase

Private lAutoErrNoFile := .T.

private lMsErroAuto := .F.

ConOut(Repl("-",80))
ConOut(PadC("Teste de Movimentacoes Internas",80))
ConOut("Inicio: "+Time())

aadd(aItem,{"D3_FILIAL","01", NIL})
aadd(aItem,{"D3_TM", "502",NIL})
aadd(aItem,{"D3_COD",cProd ,NIL})
aadd(aItem,{"D3_UM","" ,NIL})
aadd(aItem,{"D3_QUANT",nQtd ,NIL})
aadd(aItem,{"D3_LOCAL","01" ,NIL})
aadd(aItem,{"D3_CONTA","002 " ,NIL})
aadd(aItem,{"D3_DOC",cDoc, NIL})
aadd(aItem,{"D3_EMISSAO",dEmissao ,NIL})
aadd(aItem,{"D3_NUMSEQ","000017" ,NIL})
aadd(aItem,{"D3_LOCALIZ","RUA 002 " ,NIL})
aadd(aItem,{"D3_LOTECTL ","1012 " ,NIL})
aadd(aItem,{"D3_DTVALID ",dDatav ,NIL})

MSExecAuto({|x,y| mata240(x,y)},aItem,nOpc)

if lMsErroAuto
aLog := GetAutoGRLog()
::cRet := "erro"
for i := 1 to len(aLog)
::cRet += aLog[i]
next i
else
::cRet := "ok"
endIf
