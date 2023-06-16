Start:

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
upgradeAHK := userProfile . "\Desktop\Upgrade.ahk"
upgradeEXE := userProfile . "\Desktop\Upgrade.exe"
biometrias := "Cargando templates, aguarde"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

if(RegExMatch("HKLM\SOFTWARE\Policies\Microsoft\Windows\System", "EnableSmartScreen") != ""){}
else
{
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

        Case 10:
            if(currentMin = 20)
            {
                Run, cmd.exe /c ipconfig /flushdns,, hide
            }else{}
        Break

        Case 9:
            if(currentMin = 50) and (executed == 0)
            {
                if FileExist("%upgradeEXE%")
                {
                    Process, Exist, Upgrade.exe
                    if(ErrorLevel == 0){}
                    else
                    {
                        Process, Close, Upgrade.exe
                    }
                Run, %upgradeEXE%
                }
                else
                {
                    URL := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/Upgrade.ahk"

                    UrlDownloadToFile, %URL%, %upgradeAHK%
                    if(ErrorLevel != 0)
                    {
                        MsgBox, Error de conexion con Servidor.
                    }
                    else
                    {
                        Process, Exist, Upgrade.exe
                        if(ErrorLevel == 0){}
                        else
                        {
                            Process, Close, Upgrade.exe
                        }

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
                                RunWait, %upgradeEXE%
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
            }else{}
        Break

        Default:
            Process, Exist, FaceRecogProject.exe
            if(ErrorLevel){}
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
