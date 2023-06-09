Start:
targetFile := A_Startup . "\AccesoPro.exe"
url := "https://drive.google.com/uc?export=download&id=171l-fcQfsCYYCA-JvNJLIq1hgMx17jaU"

Process, Exist, AccesoPro.exe
if ErrorLevel == 0
{
    Process, Close, AccesoPro.exe

    URLDownloadToFile,%url%,%USERPROFILE%\Desktop\AccesoPro 2.0.ahk
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

        NewDestination := A_Startup . "\AccesoPro 2.0.ahk"
        FileMove, %USERPROFILE%\Desktop\AccesoPro 2.0.ahk, %NewDestination%
        if ErrorLevel != 0
        {
            MsgBox, Error al reemplazar el archivo existente.
        }
        Else
        {
            Run, %targetFile%
            MsgBox, Actualizacion completada de forma exitosa.
        }
    }
}
Goto, Start