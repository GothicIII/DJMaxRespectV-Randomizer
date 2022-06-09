;// Library to generate SongList.db
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
;// so it took a lot of time to find 'good' consistant pixels. If somebody knows the native resolution, 
;// This library is not able to fetch data consistantly so manual intervention is neccessary to produce all results. 
;//

Class song_order_numbers
{
	__New()
	{
	;//[currentline (always 1, but if detection fails, you can start from a later song by providing the songcount), beginning line in namesdb of that songpack, number of songs]
	this.re 	:= [1,1,80]
	this.pone 	:= [1,81,56]
	this.ptwo	:= [1,137,53]
	this.pthree	:= [1,190,22]
	this.tr		:= [1,212,20]
	this.cl		:= [1,232,24]
	this.bs		:= [1,256,21]
	this.vone	:= [1,277,20]
	this.vtwo	:= [1,297,21]
	this.es		:= [1,318,8]
	this.tone	:= [1,326,21]
	this.ttwo	:= [1,347,23]
	this.tthree	:= [1,370,29]
	this.co		:= [1,399,70]
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
	), "SongList2.db"
	}
	catch
		AppendSongData(songobject)
Return
}

;// creates a difficulty array and detects how many difficulty charts exist for that song.
CreateDiffArray(buttoncolor, TTwo)
{
	buttoncolorTtwo:=["0xFFBA00",	"0xFD6306", "0xFE00D8", "0xFF0042"]
	xbuttondiffpos:=[133,293,452,613]
	y:=667
	diff_arr:=[]
	for curdiff in xbuttondiffpos
	{
		WinActivate("ahk_exe DJMax Respect V.exe")
		if TTwo=1
		{
			buttoncolor:=buttoncolorTtwo[A_Index]
		}
		if buttoncolor=PixelGetColor(curdiff,y)
		{
			diff_arr.push(GetSongDiff())
			WinActivate("ahk_exe DJMax Respect V.exe")
			Send "{Right}"
			Sleep 100
			continue
		}
		else
		{
			if curdiff=133
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
		Case "ES":
			suffix:="es"
		Case "T1":
			suffix:="tone"
		Case "T2":
			suffix:="ttwo"
		Case "T3":
			suffix:="tthree"
		Case "CO":
			suffix:="co"
	}
	if songorder.%suffix%[3]=songorder.%suffix%[1]
		{
		WinActivate("ahk_exe DJMax Respect V.exe")
		Send "{RShift down}" 
		Sleep 50
		Send "{RShift up}" 
		}
		else
			Send "{Down}"
		Sleep 300
	loop parse SongNamesDb, "`n"
		if A_Index=songorder.%suffix%[2]+songorder.%suffix%[1]-1
		{
			songorder.%suffix%[1]++
			Return substr(A_Loopfield,1,StrLen(A_Loopfield)-4)
		}
}

;// Main function. Collects all data and sends it for writing into songlist.db
GetSongData(){
	WinActivate("ahk_exe DJMax Respect V.exe")
	lastsonggroup:=songgroup:=""
	while songgroup!="CO" or A_Index<=85 ;Number of collaboration songs
	{
		; This block is only useful to skip Muse Dash DLC since I do not own it.
		if songgroup="CO" and A_Index>=50 and A_Index<=64 
		{
			Send "{Down}"
			Sleep 100
			continue
		}
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
			Case "ES":
				buttoncolor := "0x1AD10B"
			Case "T1":
				buttoncolor := "0xF21CC7"
			Case "T2":
				buttoncolor := "0"
				Ttwo:=1
			Case "T3":
				buttoncolor := "0x1257EE"
			Case "CO":
				buttoncolor := "0xFFFFFF"
		}
		fourkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "5"
		sleep 50
		fivekdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "6"
		sleep 50
		sixkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "8"
		sleep 50
		eightkdata:=CreateDiffArray(buttoncolor, Ttwo)
		Send "4"
		sleep 50
		AppendSongData(Generate_Chart_Data(FetchSongname(songgroup), songgroup, fourkdata, fivekdata, sixkdata, eightkdata))
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
	Case "0x00B4D4":
		Return "P1"	
	Case "0xFF1C76":
		Return "P2"	
	Case "0xFBBB01":
		Return "P3"	
	Case "0x7E97FF":
		Return "TR"
	Case "0xFFFFFF":
		Return "CL"
	Case "0xEC0042":
		Return "BS"
	Case "0xFD731D":
		Return "V1"
	Case "0xBA3955":
		Return "V2"
	Case "0x34DF26":
		Return "ES"
	Case "0xF31CC7":
		Return "T1"
	Case "0x11DAD8":
		Return "T2"
	Case "0x514CF7":
		Return "T3"
	Case "0x4C4C4C":
		Return "CO"
	}
	Default:
		MsgBox("Wrong color detected. Maybe try again? " pxcolor)
		Return GetSongGroup()	
}