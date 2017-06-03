#include Components/Connector.ahk
#include Components/Parser.ahk
#include Components/Decoder.ahk
#include Components/Zombie.ahk
#include Components/Commands.ahk
#include Components/Translator.ahk
#include Components/Config.ahk

;#NoTrayIcon

Connector
	.setZombie(Zombie)
	.setConfig(Config)
	.setParser(Parser)
	.init()
	
Zombie
	.setConnector(Connector)
	.setCommands(Commands)
	.init()

Parser
	.setDecoder(Decoder)
	.setZombie(Zombie)
	.setCommands(Commands)
	.init()
	
Commands
	.setConfig(Config)
	.setZombie(Zombie)
	.setTranslator(Translator)
	.setConnector(Connector)
	.init()

Zombie.startListen()
	
$^r::
	if(Config.debug){
		reload
	}
return