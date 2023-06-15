Start:

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

accesoProAHK := userProfile . "\Desktop\AccesoPro.ahk"
accesoProEXE = userProfile . "\Desktop\AccesoPro.exe"

Process, Exist, AccesoPro.exe
if (ErrorLevel == 0) and (!execute)
{
    Process, Close, AccesoPro.exe

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

            RunWait, Ahk2Exe.exe /in "%accesoProAHK%" /out "%accesoProEXE%"
            if (ErrorLevel == 0)
            {
                FileMove, %accesoProEXE%, %targetFile%
                if (ErrorLevel != 0)
                {
                    MsgBox, No se movió a Inicio.
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
