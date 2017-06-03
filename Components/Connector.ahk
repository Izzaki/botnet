class Connector
{
	static zombie ; Zombie dependency
	static config ; Config dependency
	static parser ; Parser dependency
	
	static HTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	
	prepareNotationLink(notation){
		return this.config.links.notation . "&notation=" . notation
	}
	
	receiveCommands(){
		this.HTTP.Open("GET", this.config.links.receive . this.zombie.getName(), false)
		this.HTTP.SetRequestHeader("X-Requested-With", "XMLHttpRequest")
		this.HTTP.SetRequestHeader("Content-Type", "text/html;charset=UTF-8")
		this.HTTP.Send()
		return this.HTTP.ResponseText
	}
	
	startListen(){
		loop{
			try{
				response := this.receiveCommands()
				; Zombie.notation("test")
				; break
				
				this.parser.parseResponse(response)
			}
			catch{
				; this try/catch block prevents errors displaying
			}
			sleep (this.config.receiveDelaySeconds * 1000)
		}
	}
	
	toFile(response){
		if(fileExist("response.html"))
			fileDelete, response.html
		fileAppend, % response, response.html
	}
	
	
	
	; building
	setZombie(zombie){
		this.zombie := zombie
		return this
	}
	setConfig(config){
		this.config := config
		return this
	}
	
	setParser(parser){
		this.parser := parser
		return this
	}
	
	init(){
		return this
	}
}