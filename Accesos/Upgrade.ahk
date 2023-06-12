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
        MsgBox, Error de conexion con Servidor.
    }
    Else
    {
        if FileExist(targetFile)
        {
            FileDelete, %targetFile%
        }

        NewDestination := A_Startup . "\AccesoPro.exe"
        FileMove, %USERPROFILE%\Desktop\AccesoPro.exe, %NewDestination%
        if ErrorLevel != 0
        {
            MsgBox, Error al reemplazar el archivo existente.
        }
        Else
        {
            Run, %targetFile%
        }
        execute := 1
    }
}
Goto, Start
