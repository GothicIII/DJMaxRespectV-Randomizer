EnDisHk(pass,md,k,fn,state)
{
	;Msgbox(inputlst[k])
	if md>1 and k>1
		Hotkey (pass?"~":"") modinputlst[md] " & " inputlst[k], fn, state
	if md=1 and k>1
		Hotkey (pass?"~":"") inputlst[k], fn, state
	else if md>1 and k=1 
		Hotkey (pass?"~":"") modinputlst[md], fn, state
}

; Hotkey functions
FnKeyA(*)
{
	RollSong(songpacks, kmode, diffmode, mindiff, maxdiff)
}

FnKeyB(*)
{
	CacheSongSelection()
}

FnKeyC(*)
{
	try if WinGetProcessName("A")="DJMax Respect V.exe"
	{
		WinMinimize("ahk_exe DJMax Respect V.exe")
		WinGetPos(&x, &y,,,"DJMax Respect V Freeplay")
		CoordMode "Mouse","Screen"
		MouseMove(x+100,y+150)
		WinActivate("DJMax Respect V Freeplay")
	}
	else
		WinMaximize("ahk_exe DJMax Respect V.exe")
}

FnKeyD(key:="")
{
	if !IsSet(songid)
		Return
	if excludebox.Enabled and djmaxexcludedben.Value and !ExcludeChart(songid, kmod, songd, key)
		Statusbar.SetText("Current chart is now excluded and forever gone! :L")
}

; Initially set hotkeys
InitHotKeys(reset:=0,*)
{
	; set the real combo here
	static hk:=[iniread("DJMaxRandomizer.ini", "keys", "roll"),iniread("DJMaxRandomizer.ini", "keys", "reroll"),iniread("DJMaxRandomizer.ini", "keys", "toggle"),iniread("DJMaxRandomizer.ini", "keys", "exclude")]
	if reset=1
		hk:=[104,404,194,106]
	fn:=[FnKeyA,FnKeyB,FnKeyC,FnKeyD]
	for e in hk
		SetHk(e, fn[A_Index], 1)
}

; Main function to create Hotkeys from .ini / Options
; Does dup checks
SetHk(key,fn,mode:=0)
{
	static hkhistory:=[101,102,103,104,0], lst:=["keyroll","keyreroll","keytgl","keyexclude"]	
	lnum:=Ord(SubStr(fn.name,6,1))-64
	if mode=1
	{
		hkhistory[lnum]:=key
		md:=key//100, k:=Mod(key,100)
		hkhistory[hkhistory.length]:=passthrough.Value
	}
	else
	{
		if key>=100
		{
			md:=key//100
			k:=Mod(hkhistory[lnum],100)
		}
		else if key
		{
			md:=hkhistory[lnum]//100
			k:=Mod(key,100)
		}

	}
	; Checking key validity and if a duplicate is found, set it back to what it was (hkhistory)
	for l in lst
	{
		if lnum=A_Index
			continue
		if %l "mod"%.Value*100 + %l%.Value=md*100+k
		{
			Msgbox("Duplicate key-binding found!.`nPlease recheck keys and make sure each key bind is unique!`nOld key-bindings remain active.","Critical error! Keybindings invalid!",0x30)		
			if key>=100
				%lst[lnum] "Mod"%.Value:=hkhistory[lnum]//100
			else
				%lst[lnum]%.Value:=Mod(hkhistory[lnum],100)
			Return
		}
	}
	;Disable old hotkey
	md_old:=hkhistory[lnum]//100
	k_old:=Mod(hkhistory[lnum],100)
	EnDisHk(hkhistory[hkhistory.length],md_old,k_old,fn,"Off")
	;Enable new Hotkey
	%lst[lnum] "mod"%.Value:=md
	%lst[lnum]%.Value:=k
	EnDisHk(passthrough.Value,md,k,fn,"On")
	hkhistory[lnum]:=md*100+k
	hkhistory[hkhistory.length]:=passthrough.Value
}