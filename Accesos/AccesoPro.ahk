Start:
;Este script se desarrolló con la finalidad de mantener en correcto funcionamiento el equipo de computo utilizado en Accesos de STATION

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767) ;Obtenemos el nombre de carpeta de usuario 


execute := 0 ;Contador global
upgradeAHK := userProfile . "\Desktop\Upgrade.ahk" ;Ruta de almacenamiento del AHK del Upgrade
upgradeEXE := userProfile . "\Desktop\Upgrade.exe" ;Ruta de almacenamiento del EXE del Upgrade
biometrias := "Cargando templates, aguarde" ;Nombre del Proceso de la carga de biometrias

if (RegExMatch("HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU", "NoAutoUpdate") != "")
{}
else
{ ;Desactivamos las actualizaciones automaticas del Sistema Operativo 
    RunWait, reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f 
}

if(RegExMatch("HKLM\SOFTWARE\Policies\Microsoft\Windows\System", "EnableSmartScreen") != "")
{}
else
{ ;Desactivamos la proteccion con SmartScreen
    Run, reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_SZ /d "0" /f,, hide
}

Process, Exist, FaceRecogProject.exe
If(ErrorLevel = 0)
{
    url = www.google.com
    RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel
    if(Errorlevel)
    {
        Secs := 20
        SetTimer, CountDown, 1000
        MsgBox, 1, CONEXIÓN PERDIDA, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, %Secs%
        SetTimer, CountDown, Off
        CountDown:
        Secs -= 1
        ControlSetText, Static1, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, CONEXIÓN PERDIDA ahk_class #32770
        Goto, Start
    }
    else
    {
        RunWait, "%userProfile%\Desktop\Controle Acesso - EVO.appref-ms"
        Loop
        {
            Sleep, 500
            Process, Exist, biometrias
            if(ErrorLevel = 0)
            {
                break
            }
        }
    }
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
	Sleep, 10000
    executed := 0

    Switch (currentHour)
    {
        Case 12:
            if(currentMin = 20)
            {
                Shutdown, 6
            }else{}
        Break

        Case 11:
            if(currentMin = 20)
            {
                Run, cmd.exe /c ipconfig /flushdns,, hide
            }else{}
        Break

        Case 10:
            if(currentMin = 50) and (executed == 0)
            {
                if FileExist("%upgradeEXE%")
                {
                    Loop
                    {
                        Process, Exist, Upgrade.exe
                        if(ErrorLevel == 0)
                        {
                            Run, %upgradeEXE%
                            Break
                        }
                        else
                        {
                            Process, Close, Upgrade.exe
                        }
                    }
                }
                else
                {
                    url := "https://api.github.com/repos/STATION-24/Scripts/contents/Accesos/Upgrade.ahk"

                    ; Realizar solicitud HTTP GET a la API de GitHub
                    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                    http.Open("GET", url)
                    http.Send()
                    response := http.ResponseText

                    downloadUrl := RegExMatch(response, """download_url"":\s*""([^""]+)""", match)
                    if (downloadUrl)
                    {
                        urlDownload := match1
                        savePath := upgradeAHK
                        URLDownloadToFile, %urlDownload%, %savePath%
                        if(ErrorLevel != 0)
                        {
                            MsgBox, Error de conexion con Servidor.
                        }
                        else
                        {
                            Process, Exist, Upgrade.exe
                            if(ErrorLevel != 0)
                            {
                                Process, Close, Upgrade.exe
                            }else{}

                            FileMove, %upgradeAHK%, %upgradeAHK%, 1
                            if(ErrorLevel != 0)
                            {
                                MsgBox, Error al reemplazar el archivo existente.
                            }
                            else
                            {
                                if FileExist("%upgradeEXE%")
                                {
                                    FileDelete, %upgradeEXE%
                                }

                                RunWait, Ahk2Exe.exe /in "%userProfile%\Desktop\Upgrade.ahk" /out "%userProfile%\Desktop\Upgrade.exe"
                                if(ErrorLevel == 0)
                                {
                                    Run, %upgradeEXE%
                                    Sleep, 60000
                                    executed := 1
                                }
                                else
                                {
                                    MsgBox, Error al compilar Upgrade
                                }
                            }
                        }
                    }
                    else
                    {
                        MsgBox, Error al obtener la descarga del archivo.
                    }
                }
            }else{}
        Break

        Default:
            Process, Exist, FaceRecogProject.exe
            if(ErrorLevel)
            {}
            else if(!executed)
            {
                RunWait, "%userProfile%\Desktop\Controle Acesso - EVO.appref-ms"
                Loop
                {
                    Sleep, 500
                    Process, Exist, biometrias
                    if(ErrorLevel = 0)
                    {
                        Break
                    }
                }
                executed := 1
            }
        Break
    }
}

Goto, Start
