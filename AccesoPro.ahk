Start:

i:= 0
j:= 0

Process, Exist, FaceRecogProject.exe
If ErrorLevel = 0
{
	url=www.google.com
	RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel
	If Errorlevel
	{
    		Secs := 20
		SetTimer, CountDown, 1000
		MsgBox, 1, CONEXIÓN PERDIDA, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%?, %Secs%
		SetTimer, CountDown, Off

		CountDown:
		Secs -= 1
		ControlSetText,Static1,REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%?,CONEXIÓN PERDIDA ahk_class #32770
		Goto, Start
	}
	Else 	RunWait, C:\Users\JorgeGR\Desktop\Controle Acesso - EVO.appref-ms
		sleep, 30000

}
if (A_Hour = 17) and (A_Min = 24) and (A_Sec = 000) and (j<=i)
{
      	j:=i
	Run, cmd.exe
      	WinWaitActive, ahk_exe cmd.exe
      	Send, wsreset.exe{Enter}
      	WinClose, ahk_exe cmd.exe
	i:= i+1
	Goto, Start
}

Goto, Start
