class Translator{
	static voice

	TTS(oVoice, command, param1="", param2="") {
		
		static CommandList := "ToggleSpeak,Speak,SpeakWait,Pause,Stop,SetRate,SetVolume,SetPitch,SetVoice,GetVoices,GetStatus,GetCount,SpeakToFile"
		if command not in %CommandList%
		{
			MsgBox, 16, TTS() error, "%command%" is not valid command.
			return
		}
		if command = ToggleSpeak	; speak or stop speaking
		{
			Status := oVoice.Status.RunningState
			if Status = 1	; finished
			oVoice.Speak(param1,0x1)	; speak asynchronously
			Else if Status = 0	; paused
			{
				oVoice.Resume
				oVoice.Speak("",0x1|0x2)	; stop
				oVoice.Speak(param1,0x1)	; speak asynchronously
			}
			Else if Status = 2	; reading
			oVoice.Speak("",0x1|0x2)	; stop
		}
		Else if command = Speak		; speak asynchronously
		{
			Status := oVoice.Status.RunningState
			if Status = 0	; paused
			oVoice.Resume
			oVoice.Speak("",0x1|0x2)	; stop
			oVoice.Speak(param1,0x1)	; speak asynchronously
		}
		Else if command = SpeakWait		; speak synchronously
		{
			Status := oVoice.Status.RunningState
			if Status = 0	; paused
			oVoice.Resume
			oVoice.Speak("",0x1|0x2)	; stop
			oVoice.Speak(param1,0x0)	; speak synchronously
		}
		Else if command = Pause	; Pause toggle
		{
			Status := oVoice.Status.RunningState
			if Status = 0	; paused
			oVoice.Resume
			else if Status = 2	; reading
			oVoice.Pause
		}
		Else if command = Stop
		{
			Status := oVoice.Status.RunningState
			if Status = 0	; paused
			oVoice.Resume
			oVoice.Speak("",0x1|0x2)	; stop
		}
		Else if command = SetRate
			oVoice.Rate := param1		; rate (reading speed): param1 from -10 to 10. 0 is default.
		Else if command = SetVolume
			oVoice.Volume := param1		; volume (reading loudness): param1 from 0 to 100. 100 is default
		Else if command = SetPitch				; http://msdn.microsoft.com/en-us/library/ms717077(v=vs.85).aspx
			oVoice.Speak("<pitch absmiddle = '" param1 "'/>",0x20)	; pitch : param1 from -10 to 10. 0 is default.
		Else if command = SetVoice
		{
			Loop, % oVoice.GetVoices.Count
			{
				Name := oVoice.GetVoices.Item(A_Index-1).GetAttribute("Name")	; 0 based
				If (Name = param1)
				{
					DoesVoiceExist := 1
					break
				}
			}
			if !DoesVoiceExist
			{
				;MsgBox,64,, Voice "%param1%" does not exist.
				return
			}
			While !(oVoice.Status.RunningState = 1)
				Sleep, 20
			oVoice.Voice := oVoice.GetVoices("Name=" param1).Item(0) ; set voice to param1
		}
		Else if command = GetVoices
		{
			param1 := (param1 == "") ? "`n" : param1		; param1 as delimiter
			Loop, % oVoice.GetVoices.Count
			{
				Name := oVoice.GetVoices.Item(A_Index-1).GetAttribute("Name")	; 0 based
				VoiceList .= Name param1
			}
			Return RTrim(VoiceList,param1)
		}
		Else if command = GetStatus
		{
			Status := oVoice.Status.RunningState
			if Status = 0 ; paused
			Return "paused"
			Else if Status = 1 ; finished
			Return "finished"
			Else if Status = 2 ; reading
			Return "reading"
		}
		Else if command = GetCount
			return oVoice.GetVoices.Count
		Else if command = SpeakToFile	; param1 = TextToSpeak,    param2 = OutputFilePath
		{
			oldAOS := oVoice.AudioOutputStream
			oldAAOFCONS := oVoice.AllowAudioOutputFormatChangesOnNextSet
			oVoice.AllowAudioOutputFormatChangesOnNextSet := 1	
			
			SpStream := ComObjCreate("SAPI.SpFileStream")
			FileDelete, % param2	; OutputFilePath
			SpStream.Open(param2, 3)
			oVoice.AudioOutputStream := SpStream
			this.TTS(oVoice, "SpeakWait", param1)
			SpStream.Close()
			oVoice.AudioOutputStream := oldAOS
			oVoice.AllowAudioOutputFormatChangesOnNextSet := oldAAOFCONS
		}
	}

	TTS_CreateVoice(VoiceName="", VoiceRate="", VoiceVolume="", VoicePitch="") {		; by Learning one. For AHK_L.
		oVoice := ComObjCreate("SAPI.SpVoice")
		if !(VoiceName = "")
			this.TTS(oVoice, "SetVoice", VoiceName)
		if VoiceRate between -10 and 10
			oVoice.Rate := VoiceRate		; rate (reading speed): from -10 to 10. 0 is default.
		if VoiceVolume between 0 and 100
			oVoice.Volume := VoiceVolume	; volume (reading loudness): from 0 to 100. 100 is default
		if VoicePitch between -10 and 10
			this.TTS(oVoice, "SetPitch", VoicePitch)	; pitch: from -10 to 10. 0 is default.
		return oVoice
	}
	
	getVoiceInstance(){
		if(!this.voice)
			this.voice := this.TTS_CreateVoice("IVONA 2 Jacek")
			
		return this.voice
	}
	
	speak(sentence){
		voice := this.getVoiceInstance()
			
		;this.translator.TTS(voice,"SetPitch", 500)	; maximum pitch
		this.TTS(voice, "SpeakWait", sentence)
	}

	getVoices(){
		voices := ComObjCreate("SAPI.SpVoice")
		return this.TTS(voices, "GetVoices")
	}
}