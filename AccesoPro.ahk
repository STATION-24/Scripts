Start:

Process, Exist, FaceRecogProject.exe
If ErrorLevel = 0
{
	url = www.google.com
	RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel
	If Errorlevel
	{
    	Secs := 20
		SetTimer, CountDown, 1000
		MsgBox, 1, CONEXIÓN PERDIDA, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, %Secs%
		SetTimer, CountDown, Off
		CountDown:
		Secs -= 1
		ControlSetText,Static1,REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%,CONEXIÓN PERDIDA ahk_class #32770
		Goto, Start
	}
	Else 	Run, "%A_Desktop%\Controle Acesso - EVO.appref-ms"
		Sleep, 45000
}

loop
{
	SetTimer, RestartComputer, 1000
	RestartComputer:
	currentHour := A_Hour
	currentMin := A_Min
	currentSec := A_Sec
	WinGetTitle, titulo, ahk_exe FaceRecogProject.exe
	WinActivate, %titulo%
	Sleep, 10000 ; Esperar 10 segundos
		
	Switch (currentHour)
	{
		Case 12:
			if (currentMin == 20)
			{
				Shutdown, 6 ; Reiniciar la computadora
			}else{}
		Break

		Case 16:
			Run, cmd.exe /c ipconfig /flushdns,, hide
			Sleep, 5000
		Break

		Default:
			Process, Exist, FaceRecogProject.exe
			if (ErrorLevel)
			{
			}else
			{
				RunWait, "%A_Desktop%\Controle Acesso - EVO.appref-ms"
				Sleep, 20000
			}
		Break
	}
}
Goto,Start
