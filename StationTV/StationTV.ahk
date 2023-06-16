Start:

executed := 0
url := "https://raw.githubusercontent.com/STATION-24/Scripts/main/Accesos/AccesoPro.ahk"

userProfile := ""
VarSetCapacity(userProfile, 32767)
DllCall("kernel32\ExpandEnvironmentStrings", "str", "%USERPROFILE%", "str", userProfile, "uint", 32767)

MediaFind := userProfile . "\Desktop\MediaFind.exe"
MediaPath := userProfile . "\Desktop\StationTV\"
Player := "C:\Program Files\VideoLAN\VLC\vlc.exe"
PlaylistFile := MediaPath . "playlist.xspf"

Loop
{
    Process, Exist, vlc.exe
    If(ErrorLevel = 0)
    {
        url = www.google.com
        RunWait, ping.exe %url% -n 1,, Hide UseErrorlevel
        if(Errorlevel)
        {
            Secs := 20
            SetTimer, CountDown, 1000
            MsgBox, 1, CONEXIÓN PERDIDA, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, %Secs%
            SetTimer, CountDown, Off
            CountDown:
            Secs -= 1
            ControlSetText, Static1, REVISA TU CONEXIÓN A INTERNET `nAbriendo control de acceso en` %Secs%, CONEXIÓN PERDIDA ahk_class #32770
            Continue
        }
    
        if (FileExist(PlaylistFile))
        {
            FileDelete, %PlaylistFile%
        }

        FileAppend, <?xml version="1.0" encoding="UTF-8" standalone="no"?>`n<playlist xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/" version="1">`n<trackList>`n, %PlaylistFile%
    
        Loop, Files, %MediaPath%\*.mp4
        {
            archivo := A_LoopFileFullPath
            FileAppend, <track><location>%archivo%</location></track>`n, %PlaylistFile%
        }
        
        FileAppend, </trackList>`n</playlist>, %PlaylistFile%
        
        Run, %Player% "%PlaylistFile%" --fullscreen
        Break
    }
}

Loop
{
    Switch (A_Hour)
    {
        Case 23:
            if (A_Min > 0) and (!executed)
            {
                if FileExist(MediaFind)
                {
                    RunWait, MediaFind
                    executed := 1
                }
            }
        Break

        Default:
            Process, Exist, vlc.exe
            if (ErrorLevel)
            {}
            else if (!executed)
            {
                if (FileExist(PlaylistFile))
                {    
                    FileDelete, %PlaylistFile%
                }
    
                FileAppend, <?xml version="1.0" encoding="UTF-8" standalone="no"?>`n<playlist xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/" version="1">`n<trackList>`n, %PlaylistFile%
                
                Loop, Files, %MediaPath%\*.mp4
                {
                    archivo := A_LoopFileFullPath
                    FileAppend, <track><location>%archivo%</location></track>`n, %PlaylistFile%
                }
                
                FileAppend, </trackList>`n</playlist>, %PlaylistFile%
                
                Run, %Player% "%PlaylistFile%" --fullscreen
                executed := 1
            }
        Break
    }
}
Goto, Start
