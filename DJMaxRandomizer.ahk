;DJMax Respect V Randomizer
;Provided to you by GothicIII

;Needed to generate song database
;#include DJMax_Detection.h
;Numpad1::GetSongData()
;Numpad2::Reload



; Variable initialization
#NoTrayIcon
global refresh:=0
Version:="1.0.220609"
songpacks:=[], kmode:=[], diffmode:=[], stars:=[], dlcpacks:=[], settings:=[]

; GUI Initializiation
; EDIT menu Gui

(DJMaxGuiSubMenu := Gui("","DLC-Settings")).OnEvent('Close', ModifySettings)
DJMaxGuiSubMenu.SetFont("S12")
DJMaxGuiSubMenu.Add("Text", "x10 y1 w250 left section","Main DLC-Packs").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ x10 w150 section", "Portable 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Trilogy"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Clazziquai"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Black Square"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "V Extension 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Emotional Sense"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Technika 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 3"))
maindlccount:=dlcpacks.length
DJMaxGuiSubMenu.Add("Text", "x10 y+40 w250 left","Collaboration Packs").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ w150 section", "Guilty Gear"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Chunism"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Cytus"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Deemo"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Estimate"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Groove Coaster"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Girls' Frontline"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Nexon"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Muse Dash"))
;disable Muse dash dlc, since data is not available for me
dlcpacks[dlcpacks.length].Enabled:=0
DJMaxGuiSubMenu.Add("Text", "x10 y+20 w450 left","Select the DLCs you have. Settings will be saved.`nThis will regenerate the random table so not owned songs`nwon't be rolled.")
DJMaxGuiSubMenu.Add("Text", "y+-10 right x370", "v" . Version).SetFont("s8")

;Main GUI
(DJMaxGui := Gui("","DJMax Respect V Freeplay Randomizer by GothicIII")).OnEvent('Close', SaveAndExit)
DJMaxGui.SetFont("S12")
DJMaxGui.Add("Text", "x1 y10 w100 right","Song-Packs:")
songpacks.push(DJMaxGui.Add("Checkbox", "x+10 w60 section", "RE"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P3"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "TR"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "CL"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "BS"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "V1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp ", "ES"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "T1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T3"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "CO"))
DJMaxGui.Add("Button", "y+ wp hp", "DLC").OnEvent('Click', (*)=>DjMaxGuiSubMenu.Show((DJMaxGui.GetClientPos(&x,&y,&w)) "x" x+w . "y" . y ))
(songpacktoggle := DJMaxGui.Add("Checkbox", "y+ wp Checked", "All")).OnEvent('Click', ToggleAllSongPacks)
DJMaxGui.Add("Text", "x1 yp+80 w100 right","K-Modes:")
kmode.push(DJMaxGui.Add("Checkbox", "x+10 yp w80", "4k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "5k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "6k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "8k"))
DJMaxGui.Add("Text", "x1 yp+40 w100 right","Difficulty:")
diffmode.push(DJMaxGui.Add("Checkbox", "x+10 w80", "NM"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "HD"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "MX"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "SC"))
DJMaxGui.Add("Text", "x1 y+20 w100 right","Min:")
(mindiff := DJMaxGui.Add("Slider", "yp x+ w335 Range1-15 ToolTip", 1)).OnEvent('Change', (*)=>Update(1))
stars.push(DJMaxGui.Add("Text", "xp+3 y+-4 w22 h30 center","★   "))
while A_Index<15
	stars.push(DJMaxGui.Add("Text", "x+ wp hp center","★   "))
DJMaxGui.Add("Text", "x1 y+ w100 right","Max:")
(maxdiff := DJMaxGui.Add("Slider", "yp x+ w335 Left Range1-15 ToolTip section", 15)).OnEvent('Change', (*)=>Update(0))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Go!").OnEvent('Click', (*)=>RollSong(songpacks, kmode, diffmode, mindiff, maxdiff))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Save&&Exit").OnEvent('Click', SaveAndExit)
DJMaxGui.Add("Text", "xs+7 ys+50 w60","Song: ")
guisongname	:= DJMaxGui.Add("Text", "x+ yp+2 w310 h30 section"," ")
guikmode		:= DJMaxGui.Add("Text", "xs y+ w30"," ")
guidiff 		:= DJMaxGui.Add("Text", "x+ w30"," ")
guistarsy 	:= DJMaxGui.Add("Text", "xs y+ w95 h30"," ")
guistarso	:= DJMaxGui.Add("Text", "x+ yp wp hp"," ")
guistarsr	:= DJMaxGui.Add("Text", "x+ yp w57 hp"," ")
guistarsp	:= DJMaxGui.Add("Text", "x+ yp wp hp"," ")
statusbar := DJMaxGui.Add("StatusBar",, "")
statusbar.SetText("Welcome! Select your Options and Press 'Go!' or F2 :)")

; Create new settings file if it is missing
try 
	Iniread("DJMaxRandomizer.ini","config")
catch 
{
	MsgBox("Generating new config...")
	try FileDelete("DJMaxRandomizer.ini")
	Iniwrite("min=1`nmax=15`nkmodes=1111`ndifficulty=1111`nwinposx=null`nwinposy=null;", "DJMaxRandomizer.ini", "config")
	Iniwrite("packs=11111111111111", "DJMaxRandomizer.ini", "packs_selected")
	Iniwrite("main=1111111111`ncoll=111111110", "DJMaxRandomizer.ini", "dlc_owned")
}
; Retrieve settings and set them
	settings.push(Iniread("DJMaxRandomizer.ini", "config", "min"))
	settings.push(Iniread("DJMaxRandomizer.ini", "config", "max"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "kmodes"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "difficulty"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "winposx"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "winposy"))
	settings.push(iniread("DJMaxRandomizer.ini","packs_selected", "packs"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "main"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "coll"))
	mindiff.value:=settings[1]
	maxdiff.value:=settings[2]
	loop parse settings[3]
		kmode[A_Index].value:=A_Loopfield
	loop parse settings[4]
		diffmode[A_Index].value:=A_Loopfield
	winposx:=settings[5]
	winposy:=settings[6]
	loop parse settings[7]
		songpacks[A_Index].value:=A_Loopfield
	loop parse settings[8]
	{
		dlcpacks[A_Index].value:=A_Loopfield
		songpacks[A_Index+3].Enabled:=A_Loopfield
	}
	if settings[9]="000000000"
		songpacks[songpacks.length].enabled:=0
	loop parse settings[9]
		dlcpacks[A_Index+maindlccount].value:=A_Loopfield
 
 ; Draw GUI
	Update(0)
	DJMaxGui.Show((winposx="null" ? "" : "x" . winposx . "y" winposy))
	F2::RollSong(songpacks, kmode, diffmode, mindiff, maxdiff)

; Chart data definition in memory
class Generate_Chart_Data
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
	esg:=EvaluateSongGroup(songgroup)
	this.name 	:= name
	if esg=0 or esg=2
		this.order:=-1
	else 
		if ord(strupper(this.name))-64 < 1 
			this.order:=0
		else
			this.order	:= ++alphaarr[ord(strupper(this.name))-64]
	;debugfunc(name, this.order)
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
	if esg>1
		this.sg := "CO"
	else 
		this.sg := songgroup
	}
} 

;Helper func to convert arr to writeable string
ArrToStr(arr,min:=1,max:=0)
{	
	str:=""
	for ch in arr
	{
		if A_Index<min or A_Index>(max=0 ? arr.length : max)
			continue
		str:=str . ch.value
	}
	return str
}

; Prints order of internal db songs
DebugFunc(name, order)
{
	; set search string
	debugstring:="A"
	If debugstring!="" and substr(strupper(name),1,strlen(debugstring))=debugstring
		{
		try {
		WinActivate("ahk_exe DJMax Respect V.exe")
		Send "{Down}"
		Sleep 25
		}
		MsgBox(name "," order)
		}
}

;Helper function to get value in dlcpack Array from songgroup String
EvaluateSongGroup(sg)
{
	Switch sg
		{
			Case "RE":
				Return 1
			Case "P1":
				Return 1
			Case "P2":
				Return 1
			Case "P3":
				val:=1
			Case "TR":
				val:=2
			Case "CL":
				val:=3
			Case "BS":
				val:=4
			Case "V1":
				val:=5
			Case "V2":
				val:=6
			Case "ES":
				val:=7
			Case "T1":
				val:=8
			Case "T2":
				val:=9
			Case "T3":
				val:=10
			Case "GG":
				val:=11
			Case "CH":
				val:=12
			Case "CY":
				val:=13
			Case "DE":
				val:=14
			Case "ET":
				val:=15
			Case "GC":
				val:=16
			Case "GF":
				val:=17
			Case "NE":
				val:=18
			Case "MD":
				val:=19
			Default:
				MsgBox("Invalid Songgroup! Data corrupted?")
				ExitApp
		}
	Return dlcpacks[val].value + (val>10 ? 2 : 0)
}

; Helper Function to initialize arrays
FillArr(count, data:=1)
{
arr:=[]
while A_index<=count
	arr.push(data)
Return arr
}

; Extends default sorting function since DJMax has a weird song sorting scheme 
FunctionSort(first,last,*)
{
	;chr(32) space, chr(58) :, chr(59) ;, chr(39) ', chr(700) ʼ, chr(126) ~
	first := strupper(first), last:= strupper(last)
	loop parse first
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1))
		if charl=59 or (charf=39 and charl=32) or (charf=45 and charl>82)
			Return 1
		if charf=59 or (charl=39 and charl=32) or (charl=45 and charf<=82)
			Return -1
		if charf!=charl
			Return 0
	}
}

; If Songtable is empty it will generate it
GenerateSongTable(songsdbmem)
{
	static SongsDB := sort(sort(FileRead("SongList.db")),,functionsort) 
	global refresh
	if %songsdbmem%.length=0 or refresh=1
	{
		if %songsdbmem%.length>0
			%songsdbmem% := []
		loop parse SongsDB, "`n"
		{
		song_data := strsplit(A_Loopfield, ";")
		if song_data.length=0
			break
		%songsdbmem%.push(Generate_Chart_Data(song_data[1], song_data[2], [song_data[3],song_data[4],song_data[5],song_data[6]], [song_data[7],song_data[8],song_data[9],song_data[10]], [song_data[11],song_data[12],song_data[13],song_data[14]], [song_data[15],song_data[16],song_data[17],song_data[18]]))
		}
	}
	Return
}


;Called when Edit menu is closed. Enables/Disables checkboxes
ModifySettings(*)
{
	for dlc in dlcpacks
		if A_Index<=maindlccount
		{
			if dlc.value=0
			{
				songpacks[A_Index+3].value:=0
				songpacks[A_Index+3].enabled:=0
			}
			else
			{
				songpacks[A_Index+3].value:=1
				songpacks[A_Index+3].enabled:=1
			}
		}
		else
		{   
			;Check if all 
			if dlc.value=0 or A_Index=dlcpacks.length
			{
			songpacks[songpacks.length].value:=0
			songpacks[songpacks.length].enabled:=0
			}
			else 
			{
				songpacks[songpacks.length].value:=1
				songpacks[songpacks.length].enabled:=1
				break
			}
		}
	global refresh:=1
}

SaveAndExit(*)
{
	if settings[1]!=mindiff.value
		iniwrite(mindiff.value,"DJMaxRandomizer.ini", "config", "min")
	if settings[2]!=mindiff.value
		iniwrite(maxdiff.value,"DJMaxRandomizer.ini", "config", "max")
	if settings[3]!=ArrToStr(kmode)	
		iniwrite(ArrToStr(kmode), "DJMaxRandomizer.ini", "config", "kmodes")
	if settings[4]!=ArrToStr(diffmode)	
		iniwrite(ArrToStr(diffmode),"DJMaxRandomizer.ini", "config", "difficulty")
	DJMaxGui.GetClientPos(&x,&y)
	if settings[5]!=x
		iniwrite(x,"DJMaxRandomizer.ini", "config", "winposx")
	if settings[6]!=y
		iniwrite(y,"DJMaxRandomizer.ini", "config", "winposy")
	if settings[7]!=ArrToStr(songpacks)
		iniwrite(ArrToStr(songpacks),"DJMaxRandomizer.ini", "packs_selected", "packs")
	if settings[8]!=ArrToStr(dlcpacks,1,maindlccount)
		iniwrite(ArrToStr(dlcpacks,1,maindlccount),"DJMaxRandomizer.ini", "dlc_owned", "main")
	if settings[9]!=ArrToStr(dlcpacks,maindlccount+1)
		iniwrite(ArrToStr(dlcpacks,maindlccount+1),"DJMaxRandomizer.ini", "dlc_owned", "coll")
	ExitApp
}

ToggleAllSongPacks(*)
{
	for packs in songpacks
		if packs.enabled=1
			if songpacktoggle.value=1 
				packs.value:=1
			else 
				packs.value:=0
}


Update(slider)
{
	if mindiff.value>maxdiff.value and slider=1
		mindiff.value:=maxdiff.value
	else if maxdiff.value<mindiff.value and slider=0
		maxdiff.value:=mindiff.value
	while A_Index<=15
	{
		if A_Index<=5 and mindiff.value<=A_Index and maxdiff.value>=A_Index
			stars[A_Index].SetFont("s20 CFFFD55 W700")
		else if A_Index>5 and A_Index<=10 and mindiff.value<=A_Index and maxdiff.value>=A_Index
			stars[A_Index].SetFont("s20 CFF8E55 W700")
		else if A_Index>10 and A_Index<=13 and mindiff.value<=A_Index and maxdiff.value>=A_Index
			stars[A_Index].SetFont("s20 CFF0000 W700")
		else if A_Index>13 and A_Index<=15 and mindiff.value<=A_Index and maxdiff.value>=A_Index
			stars[A_Index].SetFont("s20 CFF00FF W700")
		else 
			stars[A_Index].SetFont("s20 CFFFFFF W700")
	}
}

; Determines the song to play and updates the GUI when found
RollSong(songpacks, kmodes, songdiff, mindiff, maxdiff)
{
	static songsdbmem:=[]
	GenerateSongTable(&songsdbmem)
	loop
	{
		;Select Random SongPack
		songpack:=""
		while songpack=""
			if songpacks[randomnum := Random(1,14)].value=1
				songpack:=songpacks[randomnum].Text

		;Select Random k-Mode
		kmode:=""
		while kmode=""
		{
			randomnum := Random(1,4)
			if kmodes[randomnum].value=1
				Switch randomnum
				{
					Case 1:
						kmode:="fourk"
						kmodenice:="4K"
					Case 2:
						kmode:="fivek"
						kmodenice:="5K"
					Case 3:
						kmode:="sixk"
						kmodenice:="6K"
					Case 4:
						kmode:="eightk"
						kmodenice:="8K"
				}	
		}
		
		;Select Random Difficulty.
		songdif:=""
		while songdif=""
		{
			maximum:=maxdiff.value
			minimum:=mindiff.value
			randomnum := Random(1,4)
			if songdiff[randomnum].value=1
				Switch randomnum
				{
					Case 1:
						songdif:="NM"
						color:="00FF00"
						Switch kmodenice
						{
							Case "4K":
								if minimum>9
									minimum:=9
							Case "5K":
								if minimum>9
									minimum:=9
							Case "6K":
								if minimum>11
									minimum:=11
							Case "8K":
								if minimum>12
									minimum:=12
						}
					Case 2:
						songdif:="HD"
						color:="00FFFF"
						Switch kmodenice
						{
							Case "4K":
								if minimum>12
									minimum:=12
								if maximum<4
									maximum:=4
							Case "5K":
								if minimum>13
									minimum:=13
								if maximum<4
									maximum:=4
							Case "6K":
								if minimum>14
									minimum:=14
								if maximum<4
									maximum:=4
							Case "8K":
								if minimum>14
									minimum:=14
								if maximum<3
									maximum:=3
						}
					Case 3:
						songdif:="MX"
						color:="FF8E55"
						Switch kmodenice
						{
							Case "4K":
								if maximum<6
									maximum:=6
							Case "5K":
								if maximum<7
									maximum:=7
							Case "6K":
								if maximum<7
									maximum:=7
							Case "8K":
								if maximum<7
									maximum:=7
						}
					Case 4:
						songdif:="SC"
						color:="FF00FF"
						Switch kmodenice
						{
							Case "4K":
								if maximum<10
									maximum:=10
							Case "5K":
								if maximum<10
									maximum:=10
							Case "6K":
								if maximum<12
									maximum:=12
							Case "8K":
								if maximum<10
									maximum:=10
						}
				}
		}
	} until songsdbmem[songnumber:=Random(1,songsdbmem.length)].%kmode%.%songdif%!=0 and songsdbmem[songnumber].%kmode%.%songdif%<=maximum and songsdbmem[songnumber].%kmode%.%songdif%>=minimum and songsdbmem[songnumber].sg=songpack and songsdbmem[songnumber].order>-1
	guisongname.SetFont("s10")
	guisongname.Text:=songsdbmem[songnumber].Name
	guikmode.Text:=kmodenice
	guidiff.SetFont("W700 C" . color)
	guidiff.Text:=songdif
	guistarsy.SetFont("s20 CFFFD55 W700")
	guistarsy.Text:=""
	guistarso.SetFont("s20 CFF8E55 W700")
	guistarso.Text:=""
	guistarsr.SetFont("s20 CFF0000 W700")
	guistarsr.Text:=""
	guistarsp.SetFont("s20 CFF00FF W700")
	guistarsp.Text:=""
	while A_Index<=Songsdbmem[songnumber].%kmode%.%songdif%
	{
		if A_Index<=5
			guistarsy.Text:=guistarsy.Text . "★"
		else if A_Index>5 and A_Index<=10
			guistarso.Text:=guistarso.Text . "★"
		else if A_Index>10 and A_Index<=13
			guistarsr.Text:=guistarsr.Text . "★"
		else 
			guistarsp.Text:=guistarsp.Text . "★"
	}
SelectSong(Songsdbmem[songnumber], kmode, songdif)
}

; Sends Input to game
SelectSong(song, kmode, songdif)
{
	try WinActivate("ahk_exe DJMax Respect V.exe")
	catch
	{
		statusbar.SetText("DJMaxV window not found! Can't send you straight to the song :(")	
		Return
	}
	;while PixelGetColor(921,175)!="0xFFFFFF"
	;	{
	;	Send "{RShift Down}"
	;	Sleep 50
	;	Send "{RShift Up}"
	;	Sleep 500
	;	}
	Send "{PgUp}"
	sleep 25
	if song.order=0
	{
		send "a"
		sleep 25
		send "{Up}"
		Sleep 25
	}
	statusbar.SetText("Sending Input..." song.order "x " substr(song.name,1,1))	
	while A_Index<=song.order
	{
		Send strlower(substr(song.name,1,1))
		sleep 25
	}
	switch kmode
	{
		case "fourk":
			Send "4"
			sleep 25
		case "fivek":
			Send "5"
			sleep 25
		case "sixk":
			Send "6"
			sleep 25
		case "eightk":
			Send "8"
			sleep 25
	}
	if (songdif="HD" or songdif="MX" or songdif="SC") and song.%kmode%.hd>0
	{
			Send "{Right}"
			sleep 25
	}
	if (songdif="MX" or songdif="SC") and song.%kmode%.mx>0
	{
			Send "{Right}"
			sleep 25
	}
	if songdif="SC" and song.%kmode%.sc>0
	{
			Send "{Right}"
			sleep 25
	}
	statusbar.SetText("Are you Ready? Never give up!")	
}
