Header =
(
; Hotkeys for the PuTTY control center, hidden so users can't screw it up
; Written by: Daniel Whalen
; Contact information: i3eaker@yahoo.com
; Created on - 02/22/2015
; Last edit - 08/09/2015
)



; Set the window title match mode to pick out of the middle if needed
SetTitleMatchMode 2

; Check to see if PuTTY Hotkeys should be shut down for replacement/maintenance
SetTimer, Timeout, 300000

; Set the server path for PuTTY, by default this is set to: \\SERVER_SHARE\DIRECTORY\PuTTY\
ServerPath = \\SERVER_SHARE\DIRECTORY\PuTTY\

; Other stuff that needs to be set
#InstallKeybdHook
#NoTrayIcon
#SingleInstance force



; Begin body of script
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



; Hotkeys below this point!!!
; Hotkeys below this point!!!
; Hotkeys below this point!!!

; Send ctrl+v for APPLICATION0 windows
#IfWinActive, SERVER0
NumpadEnter::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {Ctrl Down}
        Send, v
        Send, {Ctrl Up}
    }
    Return

; Send F-keys for APPLICATION1 windows
#IfWinActive, SERVER1
F1::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 1
    }
    Return
#IfWinActive, SERVER1
F2::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 2
    }
    Return
#IfWinActive, SERVER1
F3::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 3
    }
    Return
#IfWinActive, SERVER1
F4::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 4
    }
    Return
#IfWinActive, SERVER1
F5::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 5
    }
    Return
#IfWinActive, SERVER1
F6::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 6
    }
    Return
#IfWinActive, SERVER1
F7::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 7
    }
    Return
#IfWinActive, SERVER1
F8::
    IfWinActive, .domain.company.com - PuTTY
    {
        Send, {F1}
        Sleep 10
        Send, 8
    }
    Return
; Send F-keys for APPLICATION2 windows

#IfWinActive, SERVER2
F5::
    IfWinActive, .domain.server.com - PuTTY
    {
        Send, {Numpad4}
    }
    Return
#IfWinActive, SERVER2
F6::
    IfWinActive, .domain.server.com - PuTTY
    {
        Send, {Numpad5}
    }
    Return
#IfWinActive, SERVER2
F7::
    IfWinActive, .domain.server.com - PuTTY
    {
        Send, {Numpad6}
    }
    Return
#IfWinActive, SERVER2
F8::
    IfWinActive, .domain.server.com - PuTTY
    {
        Send, {Numpad7}
    }
    Return
