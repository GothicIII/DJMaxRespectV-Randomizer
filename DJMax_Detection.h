;// Library to generate SongList.db
;// Version 1.5.250915
;// Prerequisites
;// 
;// SongNames.db - ';' seperated csv with song names and addon short name
;// e.g. RE for Respect in the order described in class song_order_numbers
;//
;// DJMax is running in borderless window mode at 2560x1440 without AA. Freeplay mode is active on 'Respect' Tab
;// 
;// Usage: Uncomment the #include line and run GetSongData() from DJMaxRandomizer.ahk 
;//	Look into comments for details if detection fails.
;// 
;// Remarks:
;// Sorry, but all pixel positions are hardcoded for 2560x1440. DJMaxRespect V renders most things inside subpixels
;// so it took a lot of time to find 'good' consistent pixels. If somebody knows the native resolution, let me know.
;// This library is not able to fetch data consistently so manual intervention is neccessary to produce all results.
;// Do not forget to disable HDR! Everything above a bitdepth of 8 can't be detected, because there are no win32 functions to achieve this task.
;//
cm_packs:= [ "CH", "CY", "DE", "EZ", "GC", "MD", "AR"]
cv_packs:= [ "GG", "ET", "FA", "GF", "MA", "NE", "TK", "BA" ]
pli_packs:=[ "PL2" ]
refresh:=1 

; <DEBUG FUNCTIONS>
Numpad3::Reload()
; Main header for debug/recording functions
; (ALT)
!Numpad1::GetSongData("all")

; (CTRL) Start detecting song Data from current selected songpack tab (not all songs tab!). Writes to SongList.db.
^Numpad1::GetSongData("pack")

; do it only for current line. Does not add Songname!
Numpad1::GetSongData("only")
;
;Returns all difficulty banner colors and DLC banner color. Useful for new songpacks.
Numpad2::GetSongGroupColor()

; Function to quickly test if all songpacks are properly loaded. 1st column shows if it is on or off
Numpad4::ListSongPacks()

; Function call testing if fetching the songname works. Repeated calls should return the next song from this songpack.
Numpad5::Msgbox(FetchSongName("ES").Get(1))
!Numpad5::Msgbox(FetchSongName("CM").Get(1))
;Numpad5::FetchSongName("ES")

;Generates Songname.db from SongList.db
Numpad6::CreateSongNameDbFromSongList()

Numpad7::Msgbox(EvaluateSongGroup("PL1",0))

Numpad8::Msgbox(PixelGetColor(1008,200))

; Quickly shows songpack bounderies. They are directly taken from SongNames db. Add new cm/cv songpacks in global section of Detection.h!
Numpad9::Song_Order_Numbers_New(1)
try (FileDelete("InternalDB.db"))


;// Chart data definition in memory
;// Don't use the class from the main executable. It breaks when trying to detect Collab songs! 
;// esg reference removed.
;// May have some bugs for very long song names
class Generate_Chart_Data_debug
{
	__New(name, songgroup, fourkdata, fivekdata, sixkdata, eightkdata)
	{
		global refresh, debugstring
		static alphaarr := fillarr(26,0)
		if refresh=1
		{
			alphaarr := fillarr(26,0)
			refresh:=0
		}
		this.name 	:= name
		if ord(strupper(this.name))-64 < 1 
			this.order:=0
		else
			this.order	:= ++alphaarr[ord(strupper(this.name))-64]
	;debugfunc(name, this.order, songgroup)
	this.fourk	:= {}
	this.fivek	:= {}
	this.sixk	:= {}
	this.eightk	:= {}
	
	this.fourk.nm	:= fourkdata[1]
	this.fourk.hd	:= fourkdata[2]
	this.fourk.mx	:= fourkdata[3]
	this.fourk.sc	:= fourkdata[4]
	
	this.fivek.nm	:= fivekdata[1]
	this.fivek.hd	:= fivekdata[2]
	this.fivek.mx	:= fivekdata[3]
	this.fivek.sc	:= fivekdata[4]
	
	this.sixk.nm	:= sixkdata[1]
	this.sixk.hd	:= sixkdata[2]
	this.sixk.mx	:= sixkdata[3]
	this.sixk.sc	:= sixkdata[4]
	
	this.eightk.nm	:= eightkdata[1]
	this.eightk.hd	:= eightkdata[2]
	this.eightk.mx	:= eightkdata[3]
	this.eightk.sc	:= eightkdata[4]
	this.sg := songgroup
	}
} 

;// Writes Songlist.db
AppendSongData(songobject, filename:="SongList_New.db"){
	try 
	{
		FileAppend
	(
	songobject.Name ";"
	songobject.sg ";"
	songobject.fourk.nm ";"
	songobject.fourk.hd ";"
	songobject.fourk.mx ";"
	songobject.fourk.sc ";"
	songobject.fivek.nm ";"
	songobject.fivek.hd ";"
	songobject.fivek.mx ";"
	songobject.fivek.sc ";"
	songobject.sixk.nm ";"
	songobject.sixk.hd ";"
	songobject.sixk.mx ";"
	songobject.sixk.sc ";"
	songobject.eightk.nm ";"
	songobject.eightk.hd ";"
	songobject.eightk.mx ";"
	songobject.eightk.sc "`n" 
	), filename, "UTF-8"
	}
	catch
		AppendSongData(songobject)
}

;// creates a difficulty array and detects how many difficulty charts exist for that song.
CreateDiffArray(buttoncolor, altcolr)
{
	buttoncolorTtwo:=["0xFFBA00", "0xFD6306", "0xFF00D8", "0xFF0042"]
	buttoncolorpli:=["0xE2D5B6", "0xE0D4BA", "0xE2D5B6", "0xE0D4BA"]
	xbuttondiffpos:=[133,293,453,613]
	y:=667
	diff_arr:=[]
	for curdiff in xbuttondiffpos
	{
		WinActivate("ahk_exe DJMax Respect V.exe")
		if altcolr=1
			buttoncolor:=buttoncolorttwo[A_Index]
		if altcolr=2
			buttoncolor:=buttoncolorpli[A_Index]
		if buttoncolor=PixelGetColor(curdiff,y)
		{
			diff_arr.push(GetSongDiff())
			WinActivate("ahk_exe DJMax Respect V.exe")
			Send "{Right Down}"
			Sleep 25
			Send "{Right Up}"
			Sleep 100
			continue
		}
		else
		{
			;// Skips data, so be careful!
			while (curdiff=133 and PixelGetColor(133,667)!="0x132A1B")
				if Msgbox("NM not found! Try again?`nCancel will skip the chart!`n`nNeed: " buttoncolor "`nFound: " PixelGetColor(133,667),"Error",0x5)!="Retry"
					break
			diff_arr.push(0)
		}
	}
	Return diff_arr
}

;// Generates songpack bounderies by parsing songname db. 
;// Bounderies for CM/CV are taken from global cm/cv_packs[].
Class Song_Order_Numbers_New
{
	__New(dbg:=0)
	{
		SongNamesDb := FileRead("DJMaxSongNames.db","UTF-8")
		global cm_packs, cv_packs, pli_packs
		gp_last:="RE"
		gp_cnt:=0
		loop parse SongNamesDb, "`n"
		{
			if A_Loopfield=""
				continue
			gp_cur := StrSplit(A_Loopfield,";",,2).Get(2)
			for cm in cm_packs
				if cm = gp_cur
					gp_cur:="CM"
			for cv in cv_packs
				if cv = gp_cur
					gp_cur:="CV"
			for pli in pli_packs
				if pli = gp_cur
					gp_cur:="PLI"
			if gp_last!=gp_cur
			{	
				this.%gp_last%:= [ 1, A_Index-gp_cnt, gp_cnt ]
				gp_cnt:=0
				gp_last:=gp_cur
			}
			gp_cnt++
		}
		if dbg=1
		{
			dbgstr:=""
			for sg in this.OwnProps()
				for idx in this.%sg%	
					if A_index>1 and A_index<3
						dbgstr .= idx . ", "
					else if A_Index>1
					{
						dbgstr .= idx . " : " . sg . "`n"
					}
		Msgbox("idx, cnt, pack`n" . sort(dbgstr,"N"))
		}	
	}
}

;// Returns songname from SongNames.db by interpreting songgroup and song_order_numbers.
;// e.g. FetchSongname("RE") returns the first songname found in songnames.db
;// consecutive calls will return the 2nd, 3rd... songnames of that songname group
FetchSongname(SongGroup)
{
	static SongNamesDb := FileRead("DJMaxSongNames.db","UTF-8")
	static songorder:=Song_Order_Numbers_New()
	loop parse SongNamesDb, "`n"
		if A_Index=songorder.%SongGroup%[2]+songorder.%SongGroup%[1]-1
		{
			if songorder.%SongGroup%[3]<songorder.%SongGroup%[1]
				Return ["STOP", "NOW"]
			songorder.%SongGroup%[1]++
			Return StrSplit(A_Loopfield,";",,2)
		}
}

;// Main function. Collects all data and sends it for writing into songlist.db
GetSongData(mode:="all",songgroup:=GetSongGroup())
{
	global globpause
	lastsonggroup:=songgroup, filename:=""
	while songgroup!="FIN"
	{
		WinActivate("ahk_exe DJMax Respect V.exe")
		if lastsonggroup!=songgroup
		{
			A_Index:=1
			lastsonggroup:=songgroup
		}
		altcolr:=0
		if ((snsg:=FetchSongname(songgroup)).Get(1)="STOP" and snsg[2]="NOW") or pixelgetcolor(133,667)="0x13291B"
		{
			if mode="pack" or mode="only"
			{
				songgroup:="FIN"
				continue
			}
			if Msgbox("Last song reached! Continueing in about 5 seconds...","Information","0x4 T5")="No"
				break
			WinActivate("ahk_exe DJMax Respect V.exe")
			Send "{RShift down}" 
			Sleep 50
			Send "{RShift up}" 
			Sleep 500
			songgroup:=GetSongGroup()
			snsg:=FetchSongname(songgroup)
		}	
		Switch songgroup
		{
			Case "RE","RV":
				buttoncolor := "0xF0B405"
			Case "P1":	
				buttoncolor := "0x00B4D4"
			Case "P2":
				buttoncolor := "0xFF1E1E"
			Case "P3":
				buttoncolor := "0xFCAC00"
			Case "TR":
				buttoncolor := "0x7289FF"
			Case "BS":
				buttoncolor := "0xEC0043"
			Case "V1":
				buttoncolor := "0xFF7E31"
			Case "V2":
				buttoncolor := "0xCB3F5D"
			Case "V3":
				buttoncolor := "0x691AC4"
			Case "V4":
				buttoncolor := "0xBD000F"
			Case "V5":
				buttoncolor := "0xFFA90F"
			Case "VL":
				buttoncolor := "0xFFF650"
			Case "VL2":
				buttoncolor := "0x99FF33"
			Case "VL3":
				buttoncolor := "0xF26E7B"
			Case "ES":
				buttoncolor := "0x1AD10B"
			Case "T1":
				buttoncolor := "0xF21CC7"
			Case "T2":
				buttoncolor := "0"
				altcolr:=1
			Case "T3":
				buttoncolor := "0x1257EE"
			Case "TQ":
				buttoncolor := "0x999999"
			Case "CL","CM","CV":
				buttoncolor := "0xFFFFFF"
			Case "PLI":
				buttoncolor := "0"
				altcolr:=2
			default:
				Msgbox("Error: Button Color NM:" . PixelGetColor(133,667))
		}
		fourkdata:=CreateDiffArray(buttoncolor, altcolr)
		Send "{5 down}"
		Sleep 25
		Send "{5 up}"
		fivekdata:=CreateDiffArray(buttoncolor, altcolr)
		Send "{6 down}"
		Sleep 25
		Send "{6 up}"
		sixkdata:=CreateDiffArray(buttoncolor, altcolr)
		Send "{8 down}"
		Sleep 25
		Send "{8 up}"
		eightkdata:=CreateDiffArray(buttoncolor, altcolr)
		Send "{4 down}"
		Sleep 25
		Send "{4 up}"
		WinActivate("ahk_exe DJMax Respect V.exe")
		Send "{Down Down}"
		Sleep 25
		Send "{Down Up}"
		Sleep 300
		if mode="only"
		{
			snsg:=["Placeholder", songgroup]
			filename:="SongList_Line.db"
			songgroup:="FIN"
		}
		AppendSongData(Generate_Chart_Data_debug(snsg[1], snsg[2], fourkdata, fivekdata, sixkdata, eightkdata), filename)

	}
	Msgbox("Job finished!",,"T5")
}

;//Detects how many * the songchart has. It is written recursivly to extremely improve correct detection rate.
GetSongDiff(safetyresult:=0)
{
	WinActivate("ahk_exe DJMax Respect V.exe")
	x:=609
	maxdiff:=15
	while PixelGetColor(x,722)="0x000000"
	{
		if Mod(maxdiff,2)
			x-=33
		else 
			x-=32
		maxdiff--
	}
	if safetyresult!=maxdiff
	{	
		sleep 200
		Return GetSongDiff(maxdiff)
	}
	Return maxdiff
}

;//detects songgroup by determining the pixelcolor of the songgroup banner
GetSongGroup(rec:=1)
{
	;// First pixel of DLC banner
	WinActivate("ahk_exe DJMax Respect V.exe")
	Switch pxcolor:=PixelGetColor(110,292)
	{
		Case "0xEFB506":
			Return "RE"
		Case "0xFFAD00", "0xFFAE00":
			Return "RV"
		Case "0x00B4D4":
			Return "P1"	
		Case "0xFF1D77":
			Return "P2"	
		Case "0xFBBD00", "0xFABC00":
			Return "P3"	
		Case "0x7F97FF", "0x7F97FE":
			Return "TR"
		Case "0xFFFFFF":
			Return "CL"
		Case "0xEC0043", "0xEC0042":
			Return "BS"
		Case "0xFB721E":
			Return "V1"
		Case "0xBA3955":
			Return "V2"
		Case "0x691AC4", "0x681AC4":
			Return "V3"
		Case "0xBF000E", "0xBE000E":
			Return "V4"
		Case "0xFFA80C", "0xFFA509":
			Return "V5"		
		Case "0x48F7F8", "0x48F8FA":
			Return "VL"		
		Case "0x99FF33":
			Return "VL2"
		Case "0xF26E7B","0xF26E7A":
			Return "VL3"
		Case "0x34DF26":
			Return "ES"
		Case "0xF21CC7":
			Return "T1"
		Case "0x10D9D6","0x10D8D1":
			Return "T2"
		Case "0x514DF5":
			Return "T3"
		Case "0xBBBBBB":
			Return "TQ"	
		Case "0xA8A8A8":
			if PixelGetColor(1008,200)="0xFFFFFF"
				Return "CM"
			else 
				Return "CV"
		Case "0x212121":
			Return "PLI"
	}
	if rec<10
		Return GetSongGroup(++rec)
	else
	{
		Msgbox("No known Songgroup detected! Color: " pxcolor)
		Reload
	}
}

;// currently not in use. Attempt to replace default sort function
;// Problems: Even after getting around the non-ascii-conform table, the songs need always somekind of exception. e.g. U-NIVUS or We're gonna die
;// Thats why legacy code will be used, because it is easier to implement changes on a per-song-basis.
customsort(strf, strl, *)
{
	strf := substr(strf,1,strlen(strf)-4)
	strl:= substr(strl,1,strlen(strl)-4)
	loop parse strf
	{
		;chr(32) space, chr(45) -, chr(58) :, chr(59) ;, chr(39) ', chr(700) ʼ, chr(126) ~
		charf:=ord(A_Loopfield), charl:=ord(substr(strl,A_Index,1))
		;if strlen(strl)=A_Index
		;	Return 1
		;if charf=39
		;	charf+=128
		if charf=58
			charf+=38
		else if charf=59
			charf-=128
		else if charf>=97 and charf<123
			charf-=32
		else if charf=45
			charf:=64		
		else if charf=126
			charf:=42
		
		if charl=58
			charl+=38	
		else if charl=59
			charl-=128	
		else if charl>=97 and charl<123
			charl-=32
		else if charl=45
			charl:=64
		else if charl=126
			charl:=42
		
		if charf<charl
			Return -1
		if charf>charl
			Return 1
	}
	Return 0
}

CreateSongNameDbFromSongList()
{
	try FileMove("DJMaxSongNames.db", "DJMaxSongNames_" . version . "_bak.db", 1) 
	count:=0
	songlist := FileOpen("SongList.db", "r")
	songnames:= FileOpen("DJMaxSongNames.db", "w")

	while (!songlist.AtEOF)
	{
		str_arr := StrSplit(songlist.ReadLine(),";")
		if str_arr.length>1
			songnames.WriteLine(str_arr[1] ";" str_arr[2])
			;songnames.WriteLine(CreateID(A_Loopreadline) ";" str_arr[1] ";" str_arr[2])
		count++
	}
	songnames.WriteLine("This line is needed by Song_Order_Numbers_New class!;ZZ")
	songlist.close()
	songnames.close()
	Msgbox("File generation complete!`n Wrote " count+1 " lines")
}

ListSongPacks()
{
	dbgname:=""
	for names in songpacks
		dbgname.= names.text ":" names.value ":" A_Index "/" songpacks.length . "`n"
	Msgbox(dbgname)
}

GetSongGroupColor(){
	WinActivate("ahk_exe DJMax Respect V.exe")
	MsgBox("DLC Color:" . PixelGetColor(110,292)
		. "`nDLC Great Banner Color:" . PixelGetColor(1008,200)
		. "`nButton Color NM:" . PixelGetColor(133,667)
		. "`nButton Color HD:" . PixelGetColor(293,667)
		. "`nButton Color MX:" . PixelGetColor(453,667)
		. "`nButton Color SC:" . PixelGetColor(613,667)
		)
	;Msgbox(GetSongGroup())
}

;// It does not work for real CRC32
;// but the broken code should suffice for the purpose. 
;// => Nope Having many hash collisions
CreateIdOld(str)
{
	str_hex := ""
	loop parse str
		str_hex .= Format("{1:x}", ord(A_Loopfield)>255?255:ord(A_Loopfield))
	x := str_hex . 12345678
	;Msgbox(x)
	R := 0xFFFFFFFF
		loop parse x
		{
			y := "0x" . A_Loopfield
			Loop 4
			{
				R := (R << 1) ^ ((y << (A_Index+28)) & 0x10000000)
				If R > 0xFFFFFFFF
					R := R ^ 0x104C11DB7
			}
		}
	Return Format("{:08x}",R)
}
