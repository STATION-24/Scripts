Start: 
ruta:= "C:\Users\station\Desktop\Controle Acesso - EVO.appref-ms"
Process, Exist, FaceRecogProject.exe
If ErrorLevel = 0
{
	url=www.google.com
	RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel
	If Errorlevel
	{
    		Secs := 20
		SetTimer, CountDown, 1000
		MsgBox, 1, CONEXIÓN PERDIDA, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, %Secs%
		SetTimer, CountDown, Off
		CountDown:
		Secs -= 1
		ControlSetText,Static1,REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%?,CONEXIÓN PERDIDA ahk_class #32770
		Goto, Start
	}
	Else 	RunWait, %ruta%
		sleep, 45000
		SetTitleMatchMode, 2
		WinActivate, ahk_exe FaceRecogProject.exe
		Sleep, 1000
		WinWaitActive, ahk_exe FaceRecogProject.exe
}
SetTimer, RestartComputer, 1000
RestartComputer:
currentHour := A_Hour
currentMin := A_Min
currentSec := A_Sec

if (currentHour = 12) and (currentMin = 14) and (currentSec = 0) {
    Shutdown, 6 ; Reiniciar la computadora
}
if (currentHour = 5) and (currentMin = 30) and (currentSec = 0) {
    Shutdown, 6 ; Reiniciar la computadora
}
if (currentHour = 5) and (currentMin = 50) and (currentSec = 0) {
   	SetTitleMatchMode, 2
	WinActivate, ahk_exe FaceRecogProject.exe
	Sleep, 1000
	WinWaitActive, ahk_exe FaceRecogProject.exe
	Goto, Start
}
if (currentHour = 12) and (currentMin = 20) and (currentSec = 0) {
   	SetTitleMatchMode, 2
	WinActivate, ahk_exe FaceRecogProject.exe
	Sleep, 1000
	WinWaitActive, ahk_exe FaceRecogProject.exe
	Goto, Start
}
if (currentHour = 16) and (currentMin = 0) and (currentSec = 0) {
	Run, cmd.exe /c ipconfig /flushdns,, hide
	Sleep, 5000
	SetTitleMatchMode, 2
	WinActivate, ahk_exe FaceRecogProject.exe
	Sleep, 1000
	WinWaitActive, ahk_exe FaceRecogProject.exe
	Goto, Start
}
Goto, Start
