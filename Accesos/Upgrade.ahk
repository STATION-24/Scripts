Start:
execute := 0
targetFile := A_Startup . "\AccesoPro.exe"
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

Process, Exist, AccesoPro.exe
if(ErrorLevel == 0) and (!execute)
{
    Process, Close, AccesoPro.exe

    URLDownloadToFile,%url%,%USERPROFILE%\Desktop\AccesoPro.ahk
    if(ErrorLevel != 0)
    {
        MsgBox, Error de conexion con Servidor.
    }
    else
    {
        FileMove, %USERPROFILE%\Desktop\AccesoPro.ahk,  %USERPROFILE%\Desktop\AccesoPro.ahk, 1
        if(ErrorLevel != 0)
        {
            MsgBox, Error al reemplazar el archivo existente.
        }
        else
        {
            if FileExist(targetFile)
            {
                FileDelete, %targetFile%
            } 

			RunWait, Ahk2Exe.exe /in %USERPROFILE%"\Desktop\AccesoPro.ahk" /out %USERPROFILE%"\Desktop\AccesoPro.exe"
			if(ErrorLevel == 0)
			{
                FileMove, %USERPROFILE%\Desktop\AccesoPro.exe, %A_Startup%\AccesoPro.exe
                if(ErrorLevel != 0)
                {
                    MsgBox, No se movio a Inicio
                }
                else
                {
                    Run, %targetFile%
                    Sleep, 60000
                }
			}
			else
			{
				MsgBox, Error al compilar AccesoPro
			}
        }
        execute := 1
    }
}
Goto,Start
