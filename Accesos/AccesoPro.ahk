Start:
;Este script se desarrolló con la finalidad de mantener en correcto funcionamiento el equipo de computo utilizado en Accesos de STATION

execute := 0 ;Contador global

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767) ;Obtenemos el nombre de carpeta de usuario 

upgradeAHK := userProfile . "\Desktop\Upgrade.ahk" ;Ruta de almacenamiento del AHK del Upgrade
upgradeEXE := userProfile . "\Desktop\Upgrade.exe" ;Ruta de almacenamiento del EXE del Upgrade
biometrias := "Cargando templates, aguarde" ;Nombre del Proceso de la carga de biometrias

SSHTATION := userProfile . "\Desktop\SSHTATION.txt" ; Ruta de almacenamiento de SSH_KEY.txt
SSHKey := ""

FileRead, SSHKey, %SSHTATION%
if (ErrorLevel)
{
    MsgBox, No se pudo encontrar las credenciales del servidor.
}

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

Process, Exist, FaceRecogProject.exe ;Revisamos la existencia del proceso del Control de Acccesos
If(ErrorLevel = 0)
{ ;Si el nivel de error es 0
    url = www.google.com
    RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel ;Ping para revisar estado de la red
    if(Errorlevel)
    { ;Si el resultado del Ping no es satisfactorio
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
    { ;Si el resultado del Ping es satisfactorio
        RunWait, "%userProfile%\Desktop\Controle Acesso - EVO.appref-ms" ;Abrimos el Control de Accesos
        Loop
        { ;Loop de Revision de la existencia del proceso de carga de biometrias
            Sleep, 500
            Process, Exist, biometrias
            if(ErrorLevel = 0)
            {
                break ;Si el proceso deja de existir seguimos con el proximo Loop
            }
        }
    }
}

loop
{ ;Loop de Mtto
    SetTimer, RestartComputer, 1000
    RestartComputer:
    currentHour := A_Hour
    currentMin := A_Min
    currentSec := A_Sec
    WinGetTitle, titulo, ahk_exe FaceRecogProject.exe
    WinActivate, %titulo%
	Sleep, 10000
    executed := 0

    Switch (currentHour) ;Comparamos activamente la Hora
    {
        Case 12: 
            if(currentMin = 20) ; Si son las 12:20
            {
                Shutdown, 6 ; Reiniciamos el equipo
            }else{}
        Break

        Case 10:
            if(currentMin = 20) ; Si son las 11:20
            {
                Run, cmd.exe /c ipconfig /flushdns,, hide ; Limpiamos Bus serial y Cache 
		Run, cmd.exe /c ipconfig /allcompartments /all,, hide ; Refrescamos la conexion con internet
            }else{}
        Break

        Case 9:
            if(currentMin = 50) and (executed == 0) ; Si son las 10:50
            { ; Iniciamos el proceso de Actualizacion del Script
                if FileExist("%upgradeEXE%")
                { ;Si el archivo ya existe en el equipo
                    Loop
                    {
                        Process, Exist, Upgrade.exe
                        if(ErrorLevel == 0)
                        { ;Si no se esta ejecutando
                            Run, %upgradeEXE% ;Arrancamos la rutina de Actualizacion
                            Break ;Salimos del Loop
                        }
                        else
                        { ;Si ya se esta ejecutando
                            Process, Close, Upgrade.exe ;Cerramos el proceso 
                        }
                    }
                }
                else
                { ;Si el archivo no existe
                    url := "https://api.github.com/repos/STATION-24/Scripts/contents/Accesos/Upgrade.ahk"

                    ; Realizar solicitud HTTP GET a la API de GitHub con autenticación
                    http.SetRequestHeader("Authorization", "token " . SSHKey)
                    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                    http.Open("GET", url)
                    http.Send()
                    response := http.ResponseText

                    downloadUrl := RegExMatch(response, """download_url"":\s*""([^""]+)""", match)
                    if (downloadUrl) ;Generamos el link de descarga desde la API
                    {
                        urlDownload := match1
                        savePath := upgradeAHK

                        URLDownloadToFile, %urlDownload%, %savePath% ;Descargamos el archivo desde la API de Github
                        if(ErrorLevel != 0)
                        { ;Error de Conexion com server
                            MsgBox, Error de conexión con el servidor.
                        }
                        else
                        { ;Descarga en proceso
                            Process, Exist, Upgrade.exe
                            if(ErrorLevel != 0)
                            { ;Si el proceso existe
                                Process, Close, Upgrade.exe ;Cerramos el proceso
                            }else{}

                            FileMove, %upgradeAHK%, %upgradeAHK%, 1 ;Movemos el archivo o remplazamos por si mismo
                            if(ErrorLevel != 0)
                            { ;Si no se pudo mover
                                MsgBox, Error al reemplazar el archivo existente. ;Error
                            }
                            else
                            { ;Si se realizo el remplazo o movimiento con exito
                                if FileExist("%upgradeEXE%") ;Revisamos la existencia del archivo exe
                                { ;Si el archivo existe
                                    FileDelete, %upgradeEXE% ;Eliminamos el archivo existente
                                }

                                RunWait, Ahk2Exe.exe /in "%userProfile%\Desktop\Upgrade.ahk" /out "%userProfile%\Desktop\Upgrade.exe" ; Compilamos el archivo ahk a exe
                                if(ErrorLevel == 0)
                                { ;Si el archivo se compiló con exito
                                    Run, %upgradeEXE% ;Corremos el ejecutable e inicia actualizacion
                                    Sleep, 60000 ;Esperamos un minuto para dar espera a que Upgrade cierre este script
                                    executed := 1 ;Seteamos la ejecucion como 1 para hacer el break de la condicional
                                }
                                else
                                { ;Si no se pudo compilar correctamente
                                    MsgBox, Error al compilar Upgrade. ;Error
                                }
                            }
                        }
                    }
                    else
                    { ;No se pudo generar el link desde la API
                        MsgBox, Error al obtener la descarga del archivo. ;Error
                    }
                }
            }else{}
        Break

        Default: ;Default, a toda hora no especificada en los case anteriores
            Process, Exist, FaceRecogProject.exe ;Revisamos la existencia del proceso de Control Accesos
            if(ErrorLevel)
            {}
            else if(!executed)
            { ;Si no se esta ejecutando y no se ha ejecutado esta sentencia
                RunWait, "%userProfile%\Desktop\Controle Acesso - EVO.appref-ms" ;Corremos el programa de Control de Accesos
                Loop
                { ; Loop de revision de existencia de la carga de biometrias
                    Sleep, 500
                    Process, Exist, biometrias
                    if(ErrorLevel = 0)
                    {
                        Break ;Break del Loop
                    }
                }
                executed := 1 ;Seteamos la ejecucion como 1 para hacer el break de la condicional
            }
        Break
    }
}

Goto, Start
