Start:

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
accesoProAHK := userProfile . "\Desktop\AccesoPro.ahk"
accesoProEXE := userProfile . "\Desktop\AccesoPro.exe"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

Process, Exist, AccesoPro.exe
if (ErrorLevel == 0) and (!execute)
{
    Process, Close, AccesoPro.exe

    if FileExist("%accesoProAHK%")
    {
        FileDelete, %accesoProAHK%
    }

    URLDownloadToFile, %url%, %accesoProAHK%
    if (ErrorLevel != 0)
    {
        MsgBox, Error de conexión con el servidor.
    }
    else
    {
        FileMove, %accesoProAHK%, %accesoProAHK%, 1
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

            RunWait, Ahk2Exe.exe /in "%userProfile%\Desktop\AccesoPro.ahk" /out "%userProfile%\Desktop\AccesoPro.exe"
            if (ErrorLevel == 0)
            {
                FileMove, %userProfile%\Desktop\AccesoPro.exe, %targetFile%
                if (ErrorLevel != 0)
                {
                    MsgBox, El archivo no se pudo cargar a Inicio.
                }
                else
                {
                    Run, %targetFile%
                    Sleep, 60000
                }
            }
            else
            {
                MsgBox, Error al compilar AccesoPro.
            }
        }
        execute := 1
    }
}

Goto, Start
