#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"  
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJOBBX001	       Autor TBA001 -XXX     บ Data ณ  21/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSistema de sigma x progama็ใo (Job)						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSIGAPCP - Scheduler                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function JOBBX001

If Select("SX6") == 0
	Conout("Inicio  : "+Time())
	Conout(OemToAnsi("JOB - Sistema de SIGMA - PROGAMAวรO") )
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SH9"
Else
	MsgBox(OemtoAnsi("JOB - Sistema de SIGMA - PROGAMAวรO") ,OemToAnsi("Aten็ใo"), OemToAnsi("Informa็ใo"))	
EndIf

cAmbiente := GetEnvServer()


Private c_Server   	:= GETMV("MV_RELSERV")	//Servidor smtp
Private c_Account  	:= GETMV("MV_RELACNT")	//Conta de e-mail
Private c_Envia    	:= GETMV("MV_RELFROM") 	//Endereco de e-mail
Private c_Password	:= GETMV("MV_RELAPSW")  //Senha da conta de e-mail

// Valida o horแrio de execu็ใo do schedule
Private lExecuta    := .T. //iif(Left(Time(),5)>="02:30".And.Left(Time(),5)<="03:00",.T.,.F.)
private c_body		:= ""
private l_enviado 	:= .F.
private l_conectou 	:= .F.
private c_destino  	:= ""
private c_erro1		:= ""
private c_erro2		:= ""
private c_data		:= ""
Private cAcao		:= ""
Private lCobrado	:= .F.
Private cIncons 	:= "" 	
Private cTextIncons	:= "" 
Private cObserv 	:= ""
Private aParadasProg    := {}

cQuery  := " "
cQuery  += " SELECT * FROM Sigma_Oficial.dbo.BMX_CS_PROGAMACAO_PARADA_SIGMA  "// WHERE MAQUINA_FK = '350-06' and INTEGRADO_TOTVS = 'N' "
	
If Select("QRY") <> 0
	DBSelectArea("QRY")
	DBCLOSEAREA("QRY")
Endif 

TCQUERY cQuery New Alias "QRY"

dbselectarea("QRY")
QRY->(dbgotop())
while QRY->(!eof())  
    

    DbSelectArea("SH9")                 
	RecLock("SH9",.T.)       
			SH9->H9_FILIAL := xFilial("SH9")
			SH9->H9_RECURSO:= QRY->MAQUINA_FK
			SH9->H9_CCUSTO := QRY->CENTRO_DE_CUSTO_FK
			SH9->H9_MOTIVO := QRY->MOTIVO
			SH9->H9_DTINI  := STOD(QRY->DATA_INICIO) 
			SH9->H9_HRINI  := QRY->HORA_INICIO
			SH9->H9_DTFIM  := STOD(QRY->DATA_TERMINO)
			SH9->H9_HRFIM  := QRY->HORA_TERMINO
			SH9->H9_TIPO   := 'B'
	MsUnlock() 	   
	
    DbSelectArea("Z02")                 
	RecLock("Z02",.T.)       
			Z02->Z02_FILIAL := xFilial("Z02")
			Z02->Z02_CODOS  := QRY->CODIGO_PK
			Z02->Z02_DATA   := DDATABASE
	MsUnlock() 
    
    
	AADD(aParadasProg,{QRY->MAQUINA_FK ,QRY->CENTRO_DE_CUSTO_FK , QRY->SETOR_FK, QRY->CODIGO_PK, QRY->PROGAMACAO_PK ,QRY->DATA_INICIO  ,QRY->HORA_INICIO  ,QRY->DATA_TERMINO  ,QRY->HORA_TERMINO, QRY->MOTIVO})    
    
	QRY->(dbskip())
enddo

DBCLOSEAREA("QRY") 

If len(aParadasProg) > 0
  	CONNECT SMTP SERVER c_Server ACCOUNT c_Account PASSWORD c_Password Result l_Conectou 
  	
  
	if l_conectou
		c_body 	  := f_BODY(aParadasProg)
	 	c_destino := GETMV("BX_EJOBPCP")
	 	
	 	MailAuth(c_Account,c_Password)
	 	
	   	SEND MAIL FROM c_Account TO c_destino BCC "desenvolvimento.ti@bomix.com.br" SUBJECT "ATENวรO - PROGAMAวรO - Paradas de Recurso(s)" BODY c_body RESULT l_enviado
			if !l_enviado
			  	GET MAIL ERROR c_erro1
		  		Memowrite("c:\erro_envio.txt",alltrim(c_erro1))  
		  		alert(c_erro1)
			Else
				If Select("SX6") == 0
					Conout("Inicio  : "+Time())
					Conout(OemToAnsi("E-mail enviado com sucesso-Sistema de SIGMA - PROGAMAวรO") )
				Else
					MsgBox(OemtoAnsi("E-mail enviado com sucesso-Sistema de SIGMA - PROGAMAวรO") ,OemToAnsi("Aten็ใo"), OemToAnsi("Informa็ใo"))	
				EndIf		  		
			endif
		DISCONNECT SMTP SERVER
	else
  		  	GET MAIL ERROR c_erro2
		Memowrite("c:\erro_envio.txt",alltrim(c_erro2))
  	endif
Endif	

//FINALIZA A CONEXAO

If Select("SX6") == 0
	Conout(OemToAnsi("Job Sistema de SIGMA/PARADAS executado!")  )	
	RESET ENVIRONMENT
Else 
	MsgBox(OemtoAnsi("Job Sistema de SIGMA/PARADAS executado!") ,OemToAnsi("Aten็ใo"), OemToAnsi("Informa็ใo"))
Endif


Return            
/*
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Montagem do corpo do e-mail 										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
Static Function f_BODY(aParadasProg)

Local  cBody:= ""


cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cBody += '<html xmlns="http://www.w3.org/1999/xhtml"> '
cBody += '<head>'
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '
cBody += '<title>Documento sem tรญtulo</title> '
cBody += '<style type="text/css">'
cBody += '.header {'
cBody += '	font-size: 15px;'
cBody += '	text-align: center;'
cBody += '	font-weight: bold;'
cBody += '	background-color:#CBF2FE;'
cBody += '}'
cBody += '.header2 {'
cBody += '	font-size: 13px;'
cBody += '	text-align: center;'
cBody += '	font-weight: bold;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '.itens_texto {'
cBody += '	font-size: 12px;'
cBody += '	text-align: center;'
cBody += '}'
cBody += '.itens_numero {'
cBody += '	font-size: 12px;'
cBody += '	text-align: right;'
cBody += '}' 
cBody += '.itens_texto2 {'
cBody += '	font-size: 12px;'
cBody += '	text-align: center;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '.itens_numero2 {'
cBody += '	font-size: 12px;'
cBody += '	text-align: right;'
cBody += '	background-color:#E8FAFF;'
cBody += '}'
cBody += '</style>'
cBody += '</head>'
cBody += ''
cBody += '<body>'
cBody += '<table cellspacing="0" cellpadding="0" id="table44" style="width: 720px" class="style3">'
cBody += '	<tr>'
cBody += '		<td valign="top" class="style1">'
cBody += ' <table>	'
cBody += ' <tr> '
cBody += ' <td> '
cBody += ' <p class="MsoNormal" align="center" style="margin-bottom:0cm;margin-bottom:.0001pt;text-align:center;line-height:normal"><b><i> '
cBody += ' <span style="font-size:22.0pt;font-family:&quot;Arial&quot;,&quot;sans-serif&quot;">			 '
cBody += ' <div align="center"><img src="http://www.bomix.com.br/site/hp/img/logobx.jpg" width="200" height="51"/>  '
cBody += ' <span style="text-align: left"> '
cBody += ' </span> '
cBody += ' </div>  '
cBody += ' </span>  '
cBody += ' </i></b>  '
cBody += ' <span style="font-family:&quot;Arial&quot;,&quot;sans-serif&quot;"><br />		    '
cBody += ' </p>		 '
cBody += ' </td>	  '
cBody += ' </tr>	 '
cBody += ' </table> '  
cBody += '		</td>' 
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table style="width: 720px; font-weight: bold;" cellpadding="5" class="style9" cellspacing="0">'
cBody += '	<tr>'
cBody += '		<td class="rat">INFORMAวีES DAS PARADAS PROGAMADAS</td>
cBody += '		'
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table cellspacing="0" id="table45" style="width: 720px; height: 30px;" class="style3" cellpadding="0">'
cBody += '	<tr>'
cBody += '		<td class="aviso">ATENวรO: POR FAVOR, NรO RESPONDA ESTE E-MAIL. <br />'
cBody += '		Este e-mail foi enviado por uma caixa postal automแtica. <br />		'
cBody += '		D๚vidas e comentแrios, favor entrar em contato com a TI<br />
cBody += '		analista.sistemas@bomix.com.br.</td>'
cBody += '	</tr>'
cBody += '</table>'
cBody += '<br>'
cBody += '<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000">'
cBody += '  <tr>'
cBody += '    <td colspan="3"  class="header">Infor. dos Recursos</td>
cBody += '    '
cBody += '    <td colspan="7" class="header"> Dados da Ordem de Sevi็o</td>
cBody += '    '
cBody += '  </tr>'
cBody += '  <tr>'
cBody += '    <td class="header2">Recurso</td>
cBody += '    '
cBody += '    <td class="header2">Centro de Custo</td>
cBody += '    '
cBody += '    <td class="header2">Setor</td>
cBody += '    '
cBody += '    <td class="header2">O.S.</td>
cBody += '    '
cBody += '    <td class="header2">Programa็ใo</td>
cBody += '    '
cBody += '    <td class="header2">Data de Inicํo</td>
cBody += '    '
cBody += '    <td class="header2">Hora de Inicํo</td>
cBody += '    '
cBody += '    <td class="header2">Data Termino</td>
cBody += '    '
cBody += '    <td class="header2">Hora Termino</td>
cBody += '    '
cBody += '    <td class="header2">Motivo</td>
cBody += '    '
cBody += '  </tr>'

For i:=1 to len(aParadasProg)   

	If MOD(i,2) == 1 
		cCssTexto :="itens_texto"
	Else
		cCssTexto :="itens_texto2"
	Endif

	cBody += '	  <tr>'
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][1]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][2]+'</td> '
   	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][3]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][4]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+strzero(aParadasProg[i][5],5)+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+dtoc(stod(aParadasProg[i][6]))+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][7]+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+dtoc(stod(aParadasProg[i][8]))+'</td> '
	cBody += '	    <td class="'+cCssTexto+'">'+aParadasProg[i][9]+'</td> '   
	cBody += '  	<td class="'+cCssTexto+'">'+aParadasProg[i][10]+'</td> '
	cBody += '	</tr>
next    

cBody += '</table> ' 
cBody += '</html>  '
cBody += '</body>  '


Return   cBody     