Start:
execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

Process, Exist, AccesoPro.exe
if (ErrorLevel == 0) and (!execute)
{
    Process, Close, AccesoPro.exe

    userProfile := ""
    VarSetCapacity(userProfile, 32767)
    DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

    URLDownloadToFile, %url%, %userProfile%\Desktop\AccesoPro.ahk
    if (ErrorLevel != 0)
    {
        MsgBox, Error de conexión con el servidor.
    }
    else
    {
        FileMove, %userProfile%\Desktop\AccesoPro.ahk, %userProfile%\Desktop\AccesoPro.ahk, 1
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
                FileMove, %userProfile%\Desktop\AccesoPro.exe, %A_Startup%\AccesoPro.exe
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
