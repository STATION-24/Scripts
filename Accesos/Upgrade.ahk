Start:
;Script de Acrualizacion de script de Accesos

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767) ;Obtenemos el nombre de carpeta de usuario 

execute := 0 ;Obtenemos el nombre de carpeta de usuario 
targetFile := A_Startup . "\AccesoPro.exe" ;Ruta de destino del EXE de Accesos
accesoProAHK := userProfile . "\Desktop\AccesoPro.ahk" ;Ruta de almacenamiento del AHK de Accesos
accesoProEXE := userProfile . "\Desktop\AccesoPro.exe" ;Ruta de almacenamiento del EXE de Accesos

url := "https://api.github.com/repos/STATION-24/Scripts/contents/Accesos/AccesoPro.ahk" ;Link a API Git Repo

Process, Exist, AccesoPro.exe ;Revision de existencia del proceso del script de Accesos
if (ErrorLevel == 0) and (!execute)
{ ;Sí el Script esta en ejecucion
    Process, Close, AccesoPro.exe ;Cerramos el Script 

    if FileExist("%accesoProAHK%") ;Revisamos la existenccia del archivo del script de Accesos
    { ;Si el archivo existe
        FileDelete, %accesoProAHK% ;Eliminamos el archivo
    }

    ; Realizar solicitud HTTP GET a la API de GitHub
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url)
    http.Send()
    response := http.ResponseText

    downloadUrl := RegExMatch(response, """download_url"":\s*""([^""]+)""", match)
    if (downloadUrl) ;Generamos el link de descarga desde la API
    {
        urlDownload := match1
        
        URLDownloadToFile, %urlDownload%, %accesoProAHK% ;Descargamos el archivo desde la API de Github
        if (ErrorLevel != 0)
        { ;Error de Conexion con server
            MsgBox, Error de conexión con el servidor.
        }
        else
        { ;Descarga en proceso
            FileMove, %accesoProAHK%, %accesoProAHK%, 1 ;Movemos/Remplazamos el archivo descargado por el destino
            if (ErrorLevel != 0)
            { ;Si no se pudo mover
                MsgBox, Error al reemplazar el archivo existente. ;Error
            }
            else
            { ;Si la descarga se realizo con exito
                if FileExist(targetFile) ;Si existe el archivo EXE de destino
                {
                    FileDelete, %targetFile% ;Borramos el archivo
                }
        
                RunWait, Ahk2Exe.exe /in "%userProfile%\Desktop\AccesoPro.ahk" /out "%targetFile%" ;Compilamos el archivo AHK en EXE
                if (ErrorLevel == 0)
                { ;Si el archivo se compiló con exito
                    Run, %targetFile% ;Ejecutamos el nuevo Script
                    Sleep, 60000 
                    execute := 1  
                }
                else
                { ;Si no se compila exitosamente
                    MsgBox, Error al compilar AccesoPro. ;Error
                }
            }
        }
    }
    else
    { ;Si no se pudo generar link de descarga 
        MsgBox, Error al obtener la URL de descarga del archivo. ;Error
    }
}
Goto, Start
