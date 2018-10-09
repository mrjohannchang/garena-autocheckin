/*
 * Copyright 2015-2018 Henry Chang
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/*
AutoCheckIn for Garena
----------------------
Developed on: Autohotkey 1.1.14.04
Version     : 1.6
=======================================================================
                      This software is FREEWARE
                      -------------------------
If this software works, it was surely written by Chang Yu-heng (張昱珩)
                   <http://changyuheng.github.io/>
           (If it doesn't, I don't know anything about it.)
=======================================================================
*/

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#SingleInstance force
SetControlDelay, -1
CoordMode, Mouse, Relative

site := "http://changyuheng.github.io/"
Version := "1.6"
WinTitle := "Standby"
Width := "180"
Height := "160"
GuiX := A_ScreenWidth - Width - 50
GarenaAhkClass := "SkinWindow"
GarenaDialogAhkClass := "SkinDialog"
OldGarenaAhkClass := "GG_GUIDE_WIN"
OldGarenaDialogAhkClass := "#32770"

#NoTrayIcon

Gui, -MaximizeBox -MinimizeBox

TextBackgroundWidth := Width
TextBackgroundHeight := Height - 30

Gui, Add, Text, x0 y0 w%Width% h%TextBackgroundHeight% border 0x6
Gui, Font, s14 Bold
Gui, Add, Text, Section x0 y10 w%TextBackgroundWidth% center -Background BackgroundTrans, AutoCheckIn
Gui, Font,
Gui, Font,, Georgia
Gui, Add, Text,  w%Width% center BackgroundTrans, Version %Version%
Gui, Font,
Gui, Font, s9 Bold
Gui, Add, Text, w%Width% center BackgroundTrans, Double-click : Start `n`n F10 : Stop
Gui, Font
Gui, Font, cBlue underline, Georgia
Gui, Add, Text, vURL_Link1 gL_Copyright x0 w%Width% center, © 2010 Chang Yu-heng
    Process, Exist
    pid_this := ErrorLevel
    WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%
    WM_SETCURSOR = 0x20
    OnMessage(WM_SETCURSOR, "HandleMessage")
    WM_MOUSEMOVE = 0x200
    OnMessage(WM_MOUSEMOVE, "HandleMessage")
Gui, Submit
Gui, Show, Hide x%GuiX% y100 w%Width% h%Height%, %WinTitle%
DetectHiddenWindows, on
WinSet, Transparent, 0, %WinTitle%
WinGet, GuiID , ID, %WinTitle%
Gui, Show
DetectHiddenWindows, off

FadeIn(200, WinTitle)

Hotkey, IfWinActive, ahk_class AutoHotkeyGUI
Hotkey, ~F10, L_Stop

Hotkey, IfWinActive, ahk_class %GarenaAhkClass%
Hotkey, ~F10, L_Stop
Hotkey, IfWinActive, ahk_class %GarenaAhkClass%
HotKey, ~LButton, L_LButton

Hotkey, IfWinActive, ahk_class %OldGarenaAhkClass%
Hotkey, ~F10, L_Stop
Hotkey, IfWinActive, ahk_class %OldGarenaAhkClass%
HotKey, ~LButton, L_LButton

Return

GuiClose:
	ExitApp
return

L_LButton:
    MouseGetPos, X, Y, , CtrlNN
    if (A_PriorHotkey = "~LButton" and A_TimeSincePriorHotkey < 500 and PriorX == X and PriorY == Y)
    {
        if (CtrlNN == "GG_LISTVIEW4" or CtrlNN == "GG_LISTVIEW_AREA1")
        {
            MouseGetPos, , , WinUID
            hwnd := ControlFromPoint( X, Y, "ahk_id " WinUID,"", X, Y)
            SetTimer, L_Join
            SetTimer, L_TitleRunning

            Hotkey, IfWinActive, ahk_class %GarenaAhkClass%
            HotKey, ~LButton, L_LButton, off
            Hotkey, IfWinActive, ahk_class %OldGarenaAhkClass%
            HotKey, ~LButton, L_LButton, off
        }
    }
    PriorX := X
    PriorY := Y
return

L_Copyright:
    run, %site%
return

L_GetRoomID:
	MouseGetPos,,,, CtrlNN
	if (CtrlNN == "GG_LISTVIEW4" or CtrlNN == "GG_LISTVIEW_AREA1")
		MouseGetPos, X, Y, WinUID
return

L_Join:
	IfWinExist, ahk_class %GarenaDialogAhkClass%
	{
		WinGetText, text, ahk_class %GarenaDialogAhkClass%
		IfInstring ,text, 抱歉，您只能每五秒鐘嘗試進入頻道一次!
			ControlClick, Button1, ahk_class %GarenaDialogAhkClass%,, Left
		else IfInstring, text, 抱歉, 這個頻道已滿, 您可以購買黃金會員, 讓您隨意擠進滿房!
			ControlClick, Button1, ahk_class %GarenaDialogAhkClass%,, Left
		else IfInstring, text, Sorry, you can only try to join a room every 5 seconds!
			ControlClick, Button1, ahk_class %GarenaDialogAhkClass%,, Left
		else IfInstring, text, Sorry, this room is full.
			ControlClick, Button1, ahk_class %GarenaDialogAhkClass%,, Left
        else IfInstring, text, 您仍在房間裡, 要離開房間嗎?
        {
            GoSub, L_Standby
        }
        else IfInstring, text, You are still in room, leave room now?
        {
			GoSub, L_Standby
        }
	}
    else IfWinExist, ahk_class %OldGarenaDialogAhkClass%
    {
		WinGetText, text, ahk_class %OldGarenaDialogAhkClass%
		IfInstring , text, 馬上開始遊戲！！！
			ControlClick, Button1, ahk_class %OldGarenaDialogAhkClass%,, Left
		else IfInstring , text, 抱歉，您只能每五秒鐘嘗試進入頻道一次!
			ControlClick, Button1, ahk_class %OldGarenaDialogAhkClass%,, Left
		else IfInstring , text, 購買黃金會員
			ControlClick, Button2, ahk_class %OldGarenaDialogAhkClass%,, Left
		else IfInstring, text, 您仍在房間裡, 要離開房間嗎?
        {
            GoSub, L_Standby
        }
    }
	else
	{
		PostMessage, 0x203, wParam, (x & 0xFFFF) | ((y & 0xFFFF)<<16),, ahk_id %hwnd%

		wParam &= ~0x1


		PostMessage, 0x202, wParam, (x & 0xFFFF) | ((y & 0xFFFF)<<16),, ahk_id %hwnd%


		WinGetText, text, ahk_class %GarenaAhkClass%
		IfInstring ,text, 歡迎來到
        {
            GoSub, L_Standby
        }
        WinGetText, text, ahk_class %OldGarenaAhkClass%
		IfInstring ,text, 歡迎來到
        {
            GoSub, L_Standby
            GoSub, L_Standby
        }
	}
return

L_Standby:
    Reload
return

L_Stop:
	GoSub, L_Standby
return

L_TitleRunning:
    if (WinTitle == "Standby" or WinTitle == "")
    {
        WinTitle := "C"
    }
    else if (WinTitle == "C")
    {
        WinTitle := "Ch"
    }
    else if (WinTitle == "Ch")
    {
        WinTitle := "Che"
    }
    else if (WinTitle == "Che")
    {
        WinTitle := "Chec"
    }
    else if (WinTitle == "Chec")
    {
        WinTitle := "Check"
    }
    else if (WinTitle == "Check")
    {
        WinTitle := "Checki"
    }
    else if (WinTitle == "Checki")
    {
        WinTitle := "Checkin"
    }
    else if (WinTitle == "Checkin")
    {
        WinTitle := "Checking"
    }
    else if (WinTitle == "Checking")
    {
        WinTitle := "Checking "
    }
    else if (WinTitle == "Checking ")
    {
        WinTitle := "Checking i"
    }
    else if (WinTitle == "Checking i")
    {
        WinTitle := "Checking in"
    }
    else if (WinTitle == "Checking in")
    {
        WinTitle := "Checking in "
    }
    else if (WinTitle == "Checking in ")
    {
        WinTitle := "Checking in ."
    }
    else if (WinTitle == "Checking in .")
    {
        WinTitle := "Checking in .."
    }
    else if (WinTitle == "Checking in ..")
    {
        WinTitle := "Checking in ..."
    }
    else if (WinTitle == "Checking in ...")
    {
        WinTitle := "Checking in ...."
    }
    else if (WinTitle == "Checking in ....")
    {
        WinTitle := "Checking in ....."
    }
    else if (WinTitle == "Checking in .....")
    {
        WinTitle := "Checking in ......"
    }
    else if (WinTitle == "Checking in ......")
    {
        WinTitle := ""
    }
    WinSetTitle, ahk_id %GuiID%, , %WinTitle%
return

FadeIn(SemiTransparent, WinTitle)
{
   N := 0
   Loop, 20
   {
      N += SemiTransparent//20
      WinSet, Transparent, %N%, %WinTitle%
      Sleep, 10
   }
}

ControlFromPoint(X, Y, WinTitle="", WinText="", ByRef cX="", ByRef cY="", ExcludeTitle="", ExcludeText="")
{
    static EnumChildFindPointProc=0
    if !EnumChildFindPointProc
        EnumChildFindPointProc := RegisterCallback("EnumChildFindPoint","Fast")

    if !(target_window := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText))
        return false

    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect","uint",target_window,"uint",&rect)
    VarSetCapacity(pah, 36, 0)
    NumPut(X + NumGet(rect,0,"int"), pah,0,"int")
    NumPut(Y + NumGet(rect,4,"int"), pah,4,"int")
    DllCall("EnumChildWindows","uint",target_window,"uint",EnumChildFindPointProc,"uint",&pah)
    control_window := NumGet(pah,24) ? NumGet(pah,24) : target_window
    DllCall("ScreenToClient","uint",control_window,"uint",&pah)
    cX:=NumGet(pah,0,"int"), cY:=NumGet(pah,4,"int")
    return control_window
}

EnumChildFindPoint(aWnd, lParam)
{
    if !DllCall("IsWindowVisible","uint",aWnd)
        return true
    VarSetCapacity(rect, 16)
    if !DllCall("GetWindowRect","uint",aWnd,"uint",&rect)
        return true
    pt_x:=NumGet(lParam+0,0,"int"), pt_y:=NumGet(lParam+0,4,"int")
    rect_left:=NumGet(rect,0,"int"), rect_right:=NumGet(rect,8,"int")
    rect_top:=NumGet(rect,4,"int"), rect_bottom:=NumGet(rect,12,"int")
    if (pt_x >= rect_left && pt_x <= rect_right && pt_y >= rect_top && pt_y <= rect_bottom)
    {
        center_x := rect_left + (rect_right - rect_left) / 2
        center_y := rect_top + (rect_bottom - rect_top) / 2
        distance := Sqrt((pt_x-center_x)**2 + (pt_y-center_y)**2)
        update_it := !NumGet(lParam+24)
        if (!update_it)
        {
            rect_found_left:=NumGet(lParam+8,0,"int"), rect_found_right:=NumGet(lParam+8,8,"int")
            rect_found_top:=NumGet(lParam+8,4,"int"), rect_found_bottom:=NumGet(lParam+8,12,"int")
            if (rect_left >= rect_found_left && rect_right <= rect_found_right
                && rect_top >= rect_found_top && rect_bottom <= rect_found_bottom)
                update_it := true
            else if (distance < NumGet(lParam+28,0,"double")
                && (rect_found_left < rect_left || rect_found_right > rect_right
                 || rect_found_top < rect_top || rect_found_bottom > rect_bottom))
                 update_it := true
        }
        if (update_it)
        {
            NumPut(aWnd, lParam+24)
            DllCall("RtlMoveMemory","uint",lParam+8,"uint",&rect,"uint",16)
            NumPut(distance, lParam+28, 0, "double")
        }
    }
    return true
}

HandleMessage(p_w, p_l, p_m, p_hw)
  {
    global   WM_SETCURSOR, WM_MOUSEMOVE,
    static   URL_hover, h_cursor_hand, h_old_cursor, CtrlIsURL, LastCtrl

    If (p_m = WM_SETCURSOR)
      {
        If URL_hover
          Return, true
      }
    Else If (p_m = WM_MOUSEMOVE)
      {

        StringLeft, CtrlIsURL, A_GuiControl, 3
        If (CtrlIsURL = "URL")
          {
            If URL_hover=
              {
                Gui, Font, norm
                GuiControl, Font, %A_GuiControl%
                LastCtrl = %A_GuiControl%

                h_cursor_hand := DllCall("LoadCursor", "uint", 0, "uint", 32649)

                URL_hover := true
              }
              h_old_cursor := DllCall("SetCursor", "uint", h_cursor_hand)
          }

        Else
          {
            If URL_hover
              {
                Gui, Font, cBlue underline
                GuiControl, Font, %LastCtrl%

                DllCall("SetCursor", "uint", h_old_cursor)

                URL_hover=
              }
          }
      }
}
