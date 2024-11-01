;// Library to generate SongList.db
;// Version 1.1.241101
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
;// so it took a lot of time to find 'good' consistant pixels. If somebody knows the native resolution,let me know.
;// This library is not able to fetch data consistantly so manual intervention is neccessary to produce all results.
;// Do not forget to disable HDR! Everything above a bitdepth of 8 can't be detected, because there are no win32 functions to achieve this task.
;//

refresh:=1 



; Chart data definition in memory
; Don't use the class from the main executable. It breaks when trying to detect Collab songs! 
; May have some bugs for very long song names
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
	;esg:=EvaluateSongGroup(songgroup)
	this.name 	:= name
	;if esg=0 or esg=2
	;	this.order:=-1
	;else 
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
	;esg=1 ? this.sg := "CM"
	;esg=2 ? this.sg := "CV"
	;if esg>1
	;	this.sg := "CO"
	;else 
		this.sg := songgroup
	}
} 
;// This static object needs to be regenerated everytime a song gets added. Use song-order-numbers.ps1 
;// to generate those numbers from songnames.db. ToDo: Generate dynamically.
Class song_order_numbers
{
	__New()
	{
	;//[currentline (always 1, but if detection fails, you can start from a later song by providing the songcount), beginning line in namesdb of that songpack, number of songs]
this.re := [1,1,45]
this.rv := [1,46,38]
this.pone := [1,84,56]
this.ptwo := [1,140,53]
this.pthree := [1,193,24]
this.tr := [1,217,21]
this.cl := [1,238,25]
this.bs := [1,263,22]
this.vone := [1,285,20]
this.vtwo := [1,305,21]
this.vthree := [1,326,20]
this.vfour := [1,346,21]
this.vfive := [1,367,20]
this.vlib := [1,387,20]
this.es := [1,407,8]
this.tone := [1,415,22]
this.ttwo := [1,437,24]
this.tthree := [1,461,30]
this.tq := [1,491,20]
this.cm := [1,511,71]
this.cv := [1,582,69]
	}
}

;//Writes Songlist.db
AppendSongData(songobject){
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
	), "SongList_New.db"
	}
	catch
		AppendSongData(songobject)
Return
}

;// creates a difficulty array and detects how many difficulty charts exist for that song.
CreateDiffArray(buttoncolor, TTwo)
{
	buttoncolorTtwo:=["0xFFBA00", "0xFD6306", "0xFE00D8", "0xFF0042"]
	xbuttondiffpos:=[133,293,453,613]
	y:=667
	diff_arr:=[]
	
	
	for curdiff in xbuttondiffpos
	{
		WinActivate("ahk_exe DJMax Respect V.exe")
		;Msgbox(PixelGetColor(curdiff,y))
		if TTwo=1
		{
			buttoncolor:=buttoncolorTtwo[A_Index]
		}
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
			;/ Testing!!!!
			if curdiff=133 and PixelGetColor(133,667)!="0x13291B" 
				Msgbox("NM not found! Try again?`nNeed: " buttoncolor "`nFound: " PixelGetColor(133,667))
			diff_arr.push(0)
		}
	}
	Return diff_arr
}

;// Returns songname from SongNames.db by interpreting songgroup and song_order_numbers.
;// e.g. FetchSongname("RE") returns the first songname found in songnames.db
;// consecutive calls will return the 2nd, 3rd... songnames of that songname group
FetchSongname(SongGroup)
{
	static SongNamesDb := FileRead("DJMax_SongNames.db")
	static songorder:=song_order_numbers()
	Switch SongGroup
	{
		Case "RE":
			suffix:="re"
		Case "RV":
			suffix:="rv"
		Case "P1":	
			suffix:="pone"
		Case "P2":
			suffix:="ptwo"
		Case "P3":
			suffix:="pthree"
		Case "TR":
			suffix:="tr"
		Case "CL":
			suffix:="cl"
		Case "BS":
			suffix:="bs"
		Case "V1":
			suffix:="vone"
		Case "V2":
			suffix:="vtwo"
		Case "V3":
			suffix:="vthree"
		Case "V4":
			suffix:="vfour"
		Case "V5":
			suffix:="vfive"
		Case "VL":
			suffix:="vlib"	
		Case "ES":
			suffix:="es"
		Case "T1":
			suffix:="tone"
		Case "T2":
			suffix:="ttwo"
		Case "T3":
			suffix:="tthree"
		Case "TQ":
			suffix:="tq"
		Case "CM":
			suffix:="cm"
		Case "CV":
			suffix:="cv"
	}
	
	;//deprecated
	;if songorder.%suffix%[3]=songorder.%suffix%[1]
	;	{
	;	WinActivate("ahk_exe DJMax Respect V.exe")
	;	Send "{RShift down}" 
	;	Sleep 50
	;	Send "{RShift up}" 
	;	}
	;	else
	;	{
	;		Send "{Down Down}"
	;		Sleep 25
	;		Send "{Down Up}"
	;	}
	;	
		Send "{Down Down}"
		Sleep 25
		Send "{Down Up}"
		Sleep 300
		if pixelgetcolor(133,667)="0x13291B"	
		{
			Msgbox("Random reached! Changing section...","Information","T2")
			Send "{RShift down}" 
			Sleep 50
			Send "{RShift up}" 
			Sleep 500
		}
		loop parse SongNamesDb, "`n"
		if A_Index=songorder.%suffix%[2]+songorder.%suffix%[1]-1
		{
			songorder.%suffix%[1]++
			Return [ substr(A_Loopfield,1,StrLen(A_Loopfield)-4), substr(A_Loopfield,-3,2) ]
		}
}

;// Main function. Collects all data and sends it for writing into songlist.db
GetSongData(){
	WinActivate("ahk_exe DJMax Respect V.exe")
	lastsonggroup:=songgroup:=""
	while songgroup!="CM" or A_Index<=85 ;Number of collaboration songs
	{
		songgroup:=GetSongGroup()
		if lastsonggroup!=songgroup
		{
			A_Index:=1
			lastsonggroup:=songgroup
		}
		Ttwo:=0
		Switch songgroup
		{
			Case "RE":
				buttoncolor := "0xF0B405"
			Case "RV":
				buttoncolor := "0xF0B405"
			Case "P1":	
				buttoncolor := "0x00B4D4"
			Case "P2":
				buttoncolor := "0xFF1E1E"
			Case "P3":
				buttoncolor := "0xFCAC00"
			Case "TR":
				buttoncolor := "0x7289FF"
			Case "CL":
				buttoncolor := "0xFFFFFF"
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
			Case "ES":
				buttoncolor := "0x1AD10B"
			Case "T1":
				buttoncolor := "0xF21CC7"
			Case "T2":
				buttoncolor := "0"
				Ttwo:=1
			Case "T3":
				buttoncolor := "0x1257EE"
			Case "TQ":
				buttoncolor := "0x999999"
			Case "CM":
				buttoncolor := "0xFFFFFF"
			Case "CV":
				buttoncolor := "0xFFFFFF"
			default:
				Msgbox("Error: Button Color NM:" . PixelGetColor(133,667))
		}
		fourkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "{5 down}"
		Sleep 25
		Send "{5 up}"
		fivekdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "{6 down}"
		Sleep 25
		Send "{6 up}"
		sixkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "{8 down}"
		Sleep 25
		Send "{8 up}"
		eightkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "{4 down}"
		Sleep 25
		Send "{4 up}"
		snsg:=FetchSongname(songgroup)
		AppendSongData(Generate_Chart_Data_debug(snsg[1], snsg[2], fourkdata, fivekdata, sixkdata, eightkdata))
	}
}

;//Detects how many * the songchart has. It is written recursivly to extremely improve correct detection rate.
GetSongDiff(safetyresult:=0){
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
GetSongGroup(){
;First pixel of DLC banner
WinActivate("ahk_exe DJMax Respect V.exe")
	Switch pxcolor:=PixelGetColor(110,292)
	{
	Case "0xEFB506":
		Return "RE"
	Case "0xFFAE00":
		Return "RV"
	Case "0x00B3D5":
		Return "P1"	
	Case "0xFF1D77":
		Return "P2"	
	Case "0xFABC00":
		Return "P3"	
	Case "0x7F97FE":
		Return "TR"
	Case "0xFFFFFF":
		Return "CL"
	Case "0xEC0043":
		Return "BS"
	Case "0xFB721F":
		Return "V1"
	Case "0xBA3955":
		Return "V2"
	Case "0x691AC4":
		Return "V3"
	Case "0xBE000E":
		Return "V4"
	Case "0xFFA509":
		Return "V5"		
	Case "0x49F8FC":
		Return "VL"		
	Case "0x34DF26":
		Return "ES"
	Case "0xF11CC7":
		Return "T1"
	Case "0x11D9D2":
		Return "T2"
	Case "0x514DF5":
		Return "T3"
	Case "0xBBBBBB":
		Return "TQ"	
	Case "0x4C4C4C":
		if PixelGetColor(1008,200)="0xBABABA"
			Return "CM"
		else 
			Return "CV"
	}
		Return GetSongGroup()	
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
}
