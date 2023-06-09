Start:
execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.exe"

Process, Exist, AccesoPro.exe
if (ErrorLevel == 0) and (!execute) 
{
    Process, Close, AccesoPro.exe

    URLDownloadToFile,%url%,%USERPROFILE%\Desktop\AccesoPro.exe
    if ErrorLevel != 0
    {
        MsgBox, Error de conexion con GitHub.
    }
    Else
    {
        if FileExist(targetFile)
        {
            FileDelete, %targetFile%
        }

        MsgBox, Actualizacion en progreso.

        NewDestination := A_Startup . "\AccesoPro.exe"
        FileMove, %USERPROFILE%\Desktop\AccesoPro.exe, %NewDestination%
        if ErrorLevel != 0
        {
            MsgBox, Error al reemplazar el archivo existente.
        }
        Else
        {
            Run, %targetFile%
            MsgBox, Actualizacion completada de forma exitosa.
        }
        execute := 1
    }
}
Goto, Start
