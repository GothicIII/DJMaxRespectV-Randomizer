Close_Connection(wParam, msg:=1)
{
	try Send_WM_Copydata(";;;;;Destroy", wParam)
	if msg
		statusbar.SetText("Connection to StreamDeck closed!")
	else
		statusbar.SetText("Connection to StreamDeck rejected!")
}

Receive_Connection_Data(wParam,*)
{
	if !sdsupport.value
	{
		Close_Connection(wParam,0)
		Return
	}
	statusbar.SetText("Connection to StreamDeck established!")
	if globwparam and globwparam!=wParam
	{
		Close_Connection(globwparam)
		statusbar.SetText("Connection to StreamDeck reestablished!")
	}
	global globwparam:=wParam
}

Send_WM_Copydata(str, phwnd)
{  
	static tried:=0
    SizeInBytes := (StrLen(str)+1)*2
	CopyDataStruct := Buffer(3*A_PtrSize)
	NumPut( "Ptr", SizeInBytes, "Ptr", StrPtr(str), CopyDataStruct, A_PtrSize)
	try
		SendMessage(0x004a,0, CopyDataStruct,, "ahk_id" phwnd)
	catch
	{
		if !A_IsAdmin and tried=0
		{
			Msgbox("Sorry, we need admin rights to connect to StreamDeck AHK API.`nRestarting now.")
			if A_IsCompiled
				Run ('*RunAs "' A_ScriptDir . "\DJMaxRandomizer.exe" '"' " /restart " phwnd)
			else
				Run ('*RunAs "' A_ScriptDir . "\..\..\AutoHotkey64.exe" '"' " /restart DJMaxRandomizer.ahk " phwnd)
		}
		global globwparam:=""
		tried:=1
	}
}
