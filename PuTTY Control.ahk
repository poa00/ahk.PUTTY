Header =
(
; PuTTY control center, one-click access to all PuTTYable servers for the XXX Service Admin group. New version anonymized for public distribution.
; Written by: Daniel Whalen
; Contact information: i3eaker@yahoo.com
; Created on - 06/10/2014
; Last edit - 08/10/2015
)



; Set the window title match mode to pick out of the middle if needed
SetTitleMatchMode 2

; Check to see if PuTTY control should be shut down for replacement/maintenance, very useful if it is being run from a centrally located shared drive by multiple users.
SetTimer, Timeout, 300000

; Get the local path for the user
EnvGet, LocalPath, USERPROFILE

; Set the local path for PuTTY, by default this is set to: %LocalPath%\Documents\PuTTY\
LocalPath = %LocalPath%\Documents\PuTTY\

; Set the local path for the rsa key, by default this is stored in: %LocalPath%\Documents\PuTTY\Keys\rsa.PPK
RSAPath = %LocalPath%Keys\rsa.PPK

; Set the server path for PuTTY, by default this is set to: \\SERVER_SHARE\DIRECTORY\PuTTY\
ServerPath = \\SERVER_SHARE\DIRECTORY\PuTTY\

; Set if this script reads from the server path (for group distribution) or local path (for single user or testing), this will not effect the location checked for the rsa key.
; Un-comment for server path
;Path = %ServerPath%
; Un-comment for local path
Path = %LocalPath%

; Other stuff that needs to be set
#InstallKeybdHook
#SingleInstance force

; Launch the PuTTY Hotkeys script so the users can't screw things up, without this script separated from the main PuTTY Control application, any time somebody launched one of the servers that requires specialized keystrokes and then closed PuTTY Control they would lose access to those key substitutions.
Run, %Path%PuTTY_Hotkeys.exe



; Begin body of script



; GUI creation, populated based on the list of servers in the file: PuTTYcontrol
Gui, Margin, 0, 2
Gui, Font, s10, Arial
X = 0
Y = 0
Count = 1
Loop, read, %Path%PuTTYcontrol
{
    LineNumber = %A_Index%
    Loop, parse, A_LoopReadLine, `,
    {
        IfEqual, A_Index, 1
        {
            ButtonName = %A_LoopField%
        }
        IfEqual, A_Index, 2
        {
            IfEqual, A_LoopField, Text
            {
                Gui, Font, s10 bold, Arial
                Gui, Add, Text, w110 h20 x%X% y%Y% center, %ButtonName%
                Count := Count +1
                Y := Y +20
                GoSub CheckCount
            }
            IfNotEqual, A_LoopField, Text
            {
                Gui, Font, s10 norm, Arial
                ServerName = %A_LoopField%
                Gui, Add, Button, gButton w110 h20 x%X% y%Y%, %ButtonName%
                Count := Count +1
                Y := Y +20
                GoSub CheckCount
            }
        }
    }
}
Gui, Show, x780 y80, PuTTY Control
return

; The button (every button performs this same function), checks against the PuTTYcontrol file and uses the name of the button to launch the appropriate action for that server.
Button:
GuiControlGet, ButtonName, FocusV
Loop, read, %Path%PuTTYcontrol
{
    LineNumber = %A_Index%
    Loop, parse, A_LoopReadLine, `,
    {
        IfEqual, A_Index, 1
        {
            ButtonCheck = %A_LoopField%
        }
        IfEqual, A_Index, 2
        {
            IfEqual, ButtonCheck, %ButtonName%
            {
                Server = %A_LoopField%
            }
        }
        IfEqual, A_Index, 3
        {
            IfEqual, ButtonCheck, %ButtonName%
            {
                IfEqual, A_LoopField, SSH
                {
                    Password = SSH
                }
                IfEqual, A_LoopField, SSH3
                {
                    Password = SSH3
                }
                IfEqual, A_LoopField, SSH_GROUP_ID
                {
                    Password = SSH_GROUP_ID
                }
                IfEqual, A_LoopField, Password
                {
                    Password = Password
                }
            }
        }
    }
}
Gosub PUTTYlaunchSSH
return

; Launch a PuTTY instance using SSH/Telnet based on the specific server
PUTTYlaunchSSH:
{
; Run using the key stored in the standard location
    IfEqual, Password, SSH
    {
; Get the username from global variables, make it lowercase for those who type their windows logins with caps lock...
        EnvGet, User, USERNAME
        StringLower, User, User
        Run, %Path%putty.exe -ssh -i %RSAPath% -l %User% %Server%, UseErrorLevel
        if ErrorLevel = ERROR
            MsgBox Could not launch the specified server.
        Return
    }

; Run using the key stored in the standard location AND the user's non-local ID
    IfEqual, Password, SSH3
    {
; Get the username from global variables, make it lowercase for those who type their Windows logins with caps lock...
        EnvGet, User, USERNAME
        StringLower, User, User
; Compare to the IDMap file to get the user's non-standard ID
        FileRead, IDMap, %Path%IDMap
        Var8 := InStr(IDMap, User)
        Var8 := Var8 +7
        StringMid, User, IDMap, %Var8%, 3
        Run, %Path%putty.exe -ssh -i %RSAPath% -l %User% %Server%, UseErrorLevel
        if ErrorLevel = ERROR
            MsgBox Could not launch the specified server.
        Return
    }

; Run using the key stored in the standard location AND the default IDs of a given server (one ID assigned for several members of a group)
    IfEqual, Password, SSH_GROUP_ID
    {
; Get the username based on the server being accessed (XXX for most, YYY for one outlier)
        IfEqual, Server, XXX.XXX.XX.YY
            User = YYY
        IfNotEqual, Server, XXX.XXX.XX.YY
            User = XXX
        Run, %Path%putty.exe -ssh -i %RSAPath% -l %User% %Server%, UseErrorLevel
        if ErrorLevel = ERROR
            MsgBox Could not launch the specified server.
        Return
    }

; Run without populating anything (for telnet servers with odd formatted IDs)
    IfEqual, Password, Password
    {
        Run, %Path%putty.exe -telnet %Server%, UseErrorLevel
        if ErrorLevel = ERROR
            MsgBox Could not launch the specified server.
        Return
    }
}

; This makes sure the UI rolls over after 29 "rows" of servers, so as to not create a UI that scrolls wildly off the screen vertically
CheckCount:
{
    If Count = 29
    {
        X := X +112
        Y = 0
        Count = 1
    }
    Return
}

; Timeout checker
Timeout:
{
    FileRead, TimeoutCheck, %ServerPath%TimeoutCheck
    Needle = Close Putty?- YES
    Check := InStr(TimeoutCheck, Needle)
    If Check > 0
        ExitApp
    If Check = 0
        SetTimer, Timeout, 300000
    Return
}

; Exit the script if the GUI is closed
GuiClose:
ExitApp
