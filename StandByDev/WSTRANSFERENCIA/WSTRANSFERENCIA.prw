#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://192.168.254.53:5996/WSTRANSFERENCIA.apw?WSDL
Gerado em        10/14/21 16:33:37
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function WSTRANSFERENCIA ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSTRANSFERENCIA
------------------------------------------------------------------------------- */

WSCLIENT WSWSTRANSFERENCIA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD TRANSMOD1

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCEMPRESA                 AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCUSERID                  AS string
	WSDATA   oWSO_TRANSMOD1            AS WSTRANSFERENCIA_OTRANSMOD1
	WSDATA   cTRANSMOD1RESULT          AS string

	// Estruturas mantidas por compatibilidade - N�O USAR
	WSDATA   oWSOTRANSMOD1             AS WSTRANSFERENCIA_OTRANSMOD1

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSTRANSFERENCIA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.191205P-20210522] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSTRANSFERENCIA
	::oWSO_TRANSMOD1     := WSTRANSFERENCIA_OTRANSMOD1():New()

	// Estruturas mantidas por compatibilidade - N�O USAR
	::oWSOTRANSMOD1      := ::oWSO_TRANSMOD1
Return

WSMETHOD RESET WSCLIENT WSWSTRANSFERENCIA
	::cCEMPRESA          := NIL 
	::cCFIL              := NIL 
	::cCUSERID           := NIL 
	::oWSO_TRANSMOD1     := NIL 
	::cTRANSMOD1RESULT   := NIL 

	// Estruturas mantidas por compatibilidade - N�O USAR
	::oWSOTRANSMOD1      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSTRANSFERENCIA
Local oClone := WSWSTRANSFERENCIA():New()
	oClone:_URL          := ::_URL 
	oClone:cCEMPRESA     := ::cCEMPRESA
	oClone:cCFIL         := ::cCFIL
	oClone:cCUSERID      := ::cCUSERID
	oClone:oWSO_TRANSMOD1 :=  IIF(::oWSO_TRANSMOD1 = NIL , NIL ,::oWSO_TRANSMOD1:Clone() )
	oClone:cTRANSMOD1RESULT := ::cTRANSMOD1RESULT

	// Estruturas mantidas por compatibilidade - N�O USAR
	oClone:oWSOTRANSMOD1 := oClone:oWSO_TRANSMOD1
Return oClone

// WSDL Method TRANSMOD1 of Service WSWSTRANSFERENCIA

WSMETHOD TRANSMOD1 WSSEND cCEMPRESA,cCFIL,cCUSERID,oWSO_TRANSMOD1 WSRECEIVE cTRANSMOD1RESULT WSCLIENT WSWSTRANSFERENCIA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TRANSMOD1 xmlns="http://192.168.254.53:5996/">'
cSoap += WSSoapValue("CEMPRESA", ::cCEMPRESA, cCEMPRESA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CFIL", ::cCFIL, cCFIL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CUSERID", ::cCUSERID, cCUSERID , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("O_TRANSMOD1", ::oWSO_TRANSMOD1, oWSO_TRANSMOD1 , "OTRANSMOD1", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</TRANSMOD1>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://192.168.254.53:5996/TRANSMOD1",; 
	"DOCUMENT","http://192.168.254.53:5996/",,"1.031217",; 
	"http://192.168.254.53:5996/WSTRANSFERENCIA.apw")

::Init()
::cTRANSMOD1RESULT   :=  WSAdvValue( oXmlRet,"_TRANSMOD1RESPONSE:_TRANSMOD1RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure OTRANSMOD1

WSSTRUCT WSTRANSFERENCIA_OTRANSMOD1
	WSDATA   cCARMDEST                 AS string
	WSDATA   cCARMORIG                 AS string
	WSDATA   cCDTVALID                 AS string OPTIONAL
	WSDATA   cCLOTECTL                 AS string OPTIONAL
	WSDATA   cCOBSERVA                 AS string OPTIONAL
	WSDATA   cCPRODDEST                AS string
	WSDATA   cCPRODORIG                AS string
	WSDATA   nNQUANT                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSTRANSFERENCIA_OTRANSMOD1
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSTRANSFERENCIA_OTRANSMOD1
Return

WSMETHOD CLONE WSCLIENT WSTRANSFERENCIA_OTRANSMOD1
	Local oClone := WSTRANSFERENCIA_OTRANSMOD1():NEW()
	oClone:cCARMDEST            := ::cCARMDEST
	oClone:cCARMORIG            := ::cCARMORIG
	oClone:cCDTVALID            := ::cCDTVALID
	oClone:cCLOTECTL            := ::cCLOTECTL
	oClone:cCOBSERVA            := ::cCOBSERVA
	oClone:cCPRODDEST           := ::cCPRODDEST
	oClone:cCPRODORIG           := ::cCPRODORIG
	oClone:nNQUANT              := ::nNQUANT
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSTRANSFERENCIA_OTRANSMOD1
	Local cSoap := ""
	cSoap += WSSoapValue("CARMDEST", ::cCARMDEST, ::cCARMDEST , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CARMORIG", ::cCARMORIG, ::cCARMORIG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CDTVALID", ::cCDTVALID, ::cCDTVALID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CLOTECTL", ::cCLOTECTL, ::cCLOTECTL , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("COBSERVA", ::cCOBSERVA, ::cCOBSERVA , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPRODDEST", ::cCPRODDEST, ::cCPRODDEST , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPRODORIG", ::cCPRODORIG, ::cCPRODORIG , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NQUANT", ::nNQUANT, ::nNQUANT , "float", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap


