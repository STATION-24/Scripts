Start:

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
accesoProAHK := userProfile . "\Desktop\AccesoPro.ahk"
accesoProEXE := userProfile . "\Desktop\AccesoPro.exe"

url := "https://api.github.com/repos/STATION-24/Scripts/contents/Accesos/AccesoPro.ahk"

Process, Exist, AccesoPro.exe
if (ErrorLevel == 0) and (!execute)
{
    Process, Close, AccesoPro.exe

    if FileExist("%accesoProAHK%")
    {
        FileDelete, %accesoProAHK%
    }

    ; Realizar solicitud HTTP GET a la API de GitHub
    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("GET", url)
    http.Send()
    response := http.ResponseText

    downloadUrl := RegExMatch(response, """download_url"":\s*""([^""]+)""", match)
    if (downloadUrl)
    {
        urlDownload := match1
        URLDownloadToFile, %urlDownload%, %accesoProAHK%
        if (ErrorLevel != 0)
        {
            MsgBox, Error de conexión con el servidor.
        }
        else
        {
            FileMove, %accesoProAHK%, %accesoProAHK%, 1x
            if (ErrorLevel != 0)
            {
                MsgBox, Error al reemplazar el archivo existente.
            }
            else
            {
                if FileExist(targetFile)
                {
                    FileDelete, %targetFile%
                }
        
                RunWait, Ahk2Exe.exe /in "%userProfile%\Desktop\AccesoPro.ahk" /out "%targetFile%"
                if (ErrorLevel == 0)
                {
                    Run, %targetFile%
                    Sleep, 60000
                    execute := 1  
                }
                else
                {
                    MsgBox, Error al compilar AccesoPro.
                }
            }
        }
    }
    else
    {
        MsgBox, Error al obtener la URL de descarga del archivo.
    }
}
Goto, Start
