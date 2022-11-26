;DJMax Respect V Randomizer
;Provided to you by GothicIII

;Needed to generate song database
;#include DJMax_Detection.h
;Numpad1::GetSongData()

; Variable initialization
#NoTrayIcon
Version:="1.4.221126"
songpacks:=[], kmode:=[], diffmode:=[], stars:=[], dlcpacks:=[], settings:=[], songsdbmem:=[]
try (FileDelete("neworder.txt"))

; Create new settings file if it is missing
try 
	if (Iniread("DJMaxRandomizer.ini","config","version")!=Version)
		throw ValueError()
catch 
{
	MsgBox("Generating new config...")
	try FileDelete("DJMaxRandomizer.ini")
	Iniwrite("min=1`nmax=15`nkmodes=1111`ndifficulty=1111`nwinposx=null`nwinposy=null`nkeydelay=25`nversion=" . Version, "DJMaxRandomizer.ini", "config")
	Iniwrite("packs=1", "DJMaxRandomizer.ini", "packs_selected")
	Iniwrite("main=0`ncoll=0", "DJMaxRandomizer.ini", "dlc_owned")
}

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
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Emotional Sense"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Technika 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp+10", "Technica Tune && Q"))
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
DJMaxGuiSubMenu.Add("Text", "x10 y+20 w450 left","Select the DLCs you have. Settings will be saved.`nThis will regenerate the random table so unowned songs`nwon't be rolled.")
DJMaxGuiSubMenu.Add("Text", "x10 y+20 left","Keydelay in msec:")
delaykeyinput := DJMaxGuiSubMenu.Add("Slider", "x+ Tooltip Range5-100", iniread("DJMaxRandomizer.ini", "config", "keydelay"))
DJMaxGuiSubMenu.Add("Text", "x10 y+20 left","If song selection often stops on the wrong song/difficutly`nset this higher.`nLower values will increase song selection speed`nRecommended: 25 msec")
DJMaxGuiSubMenu.Add("Link", "x10 y+20 left",'Latest version: <a href="https://github.com/GothicIII/DJMaxRespectV-Randomizer/releases">Release page</a>')
DJMaxGuiSubMenu.Add("Text", "y+-10 right x375", "v" . Version).SetFont("s8")

;Main GUI
(DJMaxGui := Gui("","DJMax Respect V Freeplay Randomizer by GothicIII")).OnEvent('Close', SaveAndExit)
DJMaxGui.SetFont("S12")
DJMaxGui.Add("Text", "x1 y10 w100 right","Song-Packs:")
songpacks.push(DJMaxGui.Add("Checkbox", "x+10 w65 section", "RE"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P3"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "TR"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "CL"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "BS"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "V1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V3"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp ", "ES"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "T1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T3"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "TQ"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "CO"))
for each in songpacks
	each.OnEvent('Click', (*)=>Checkfilter())
DJMaxGui.Add("Text", "y+ wp hp", "")
(songpacktoggle := DJMaxGui.Add("Checkbox", "y+ wp Checked", "All")).OnEvent('Click', ToggleAllSongPacks)
DJMaxGui.Add("Button", "y+ hp", "Settings").OnEvent('Click', (*)=>DjMaxGuiSubMenu.Show((DJMaxGui.GetClientPos(&x,&y,&w)) "x" x+w . "y" . y-30 ))
DJMaxGui.Add("Text", "x1 yp+40 w100 right","K-Modes:")
kmode.push(DJMaxGui.Add("Checkbox", "x+10 yp w65", "4k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "5k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "6k"))
kmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "8k"))
DJMaxGui.Add("Text", "x1 yp+40 w100 right","Difficulty:")
diffmode.push(DJMaxGui.Add("Checkbox", "x+10 w65", "NM"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "HD"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "MX"))
diffmode.push(DJMaxGui.Add("Checkbox", "x+ wp", "SC"))
DJMaxGui.Add("Text", "x1 y+20 w100 right","Min:")
(mindiff := DJMaxGui.Add("Slider", "yp x+ w335 Range1-15 ToolTip", 1)).OnEvent('Change', (*)=>UpdateSlider(1))
stars.push(DJMaxGui.Add("Text", "xp+3 y+-4 w22 h30 center","★   "))
while A_Index<15
	stars.push(DJMaxGui.Add("Text", "x+ wp hp center","★   "))
DJMaxGui.Add("Text", "x1 y+ w100 right","Max:")
(maxdiff := DJMaxGui.Add("Slider", "yp x+ w335 Left Range1-15 ToolTip section", 15)).OnEvent('Change', (*)=>UpdateSlider())
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Go!").OnEvent('Click', (*)=>RollSong(songpacks, kmode, diffmode, mindiff, maxdiff))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Save&&Exit").OnEvent('Click', SaveAndExit)
DJMaxGui.Add("Text", "xs+7 ys+50","Song: ")
guisongname	:= DJMaxGui.Add("Text", "x+ ys+52 w270 h30 section"," ")
guisongname.SetFont("S10")
guikmode		:= DJMaxGui.Add("Text", "xp y+ w30"," ")
guidiff 		:= DJMaxGui.Add("Text", "x+ w30"," ")
(excludebox := DJMaxGui.Add("Checkbox", "x+60 left","Exclude Chart? (F4)")).OnEvent('Click', (*)=>ExcludeChart(songnum, kmod, songd))
excludebox.visible := 0, excludebox.Enabled:=0
guistarsy 	:= DJMaxGui.Add("Text", "xs y+ w90 h30"," ")
guistarso	:= DJMaxGui.Add("Text", "x+ yp wp hp"," ")
guistarsr	:= DJMaxGui.Add("Text", "x+ yp w54 hp"," ")
guistarsp	:= DJMaxGui.Add("Text", "x+ yp w34 hp"," ")
statusbar := DJMaxGui.Add("StatusBar",, "")
statusbar.SetText("Welcome! Select your Options and Press 'Go!' or F2 :)")


; Retrieve settings and set them
	settings.push(Iniread("DJMaxRandomizer.ini", "config", "min"))
	settings.push(Iniread("DJMaxRandomizer.ini", "config", "max"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "kmodes"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "difficulty"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "winposx"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "winposy"))
	settings.push(iniread("DJMaxRandomizer.ini", "config", "keydelay"))
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
	loop parse settings[8]
		songpacks[A_Index].value:=A_Loopfield
	loop parse settings[9]
	{
		dlcpacks[A_Index].value:=A_Loopfield
		songpacks[A_Index+3].Enabled:=A_Loopfield
	}
	if settings[10]="000000000"
		songpacks[songpacks.length].enabled:=0
	loop parse settings[10]
		dlcpacks[A_Index+maindlccount].value:=A_Loopfield
	
	if not FileExist("SongList.db")
	{
		MsgBox("You need to generate a SongList.db first! Either use GetSongData() from detection lib or download a premade one!")
		Return
	}

	; prefill with data.
	excludedb := fillarr(1024,0)
	FileOpen("DJMaxExcludeCharts.db", "rw")
	loop parse excludedbstring :=FileRead("DJMaxExcludeCharts.db"), "`n"
		excludedb[A_Index]:=A_Loopfield
		
 ; Draw GUI
	UpdateSlider()
	excludedb.RemoveAt(songsdbmem.length,excludedb.length-songsdbmem.length)
	;DJMaxGui.Opt("+Resize")
	DJMaxGui.Show((winposx="null" ? "" : "x" . winposx . "y" winposy))
	;ToolTip "Multiline`nTooltip", 100, 150
	
	
	F2::RollSong(songpacks, kmode, diffmode, mindiff, maxdiff)
	F4::
	{
	if excludebox.Enabled=1
		ExcludeChart(songnum, kmod, songd)
	}

; Chart data definition in memory
class Generate_Chart_Data
{
	__New(name, songgroup, fourkdata, fivekdata, sixkdata, eightkdata, newdb:=0)
	{
		global minarray, maxarray
		static alphaarr := fillarr(26,0), numeric:=0
		if newdb=1 
		{
			numeric:=0
			alphaarr := fillarr(26,0)
			minarray:=fillarr(16,0)
			maxarray:=fillarr(16,16)
		}
		esg:=EvaluateSongGroup(songgroup)
		this.name 	:= name
		;MsgBox(esg "`n" name)
		if esg=0 or esg=2
			this.order:=-1
		else 
			if ord(strupper(this.name))-64 < 1 
				this.order:=++numeric
			else
				this.order	:= ++alphaarr[ord(strupper(this.name))-64]
		;debugfunc(this.name, this.order, songgroup)
		this.fourk	:= {}
		this.fivek	:= {}
		this.sixk	:= {}
		this.eightk	:= {}
		
		for f in ["nm","hd","mx","sc"]
		{
			this.fourk.%f% := fourkdata[A_Index]
			this.fivek.%f% := fivekdata[A_Index]
			this.sixk.%f% := sixkdata[A_Index]
			this.eightk.%f% := eightkdata[A_Index]
		}
		if esg>1
			this.sg := "CO"
		else 
			this.sg := songgroup
		while A_Index<=4 and this.order>-1 and EvaluateSongGroup(songgroup,0)
		{
			if fourkdata[A_Index] > minarray[4 * A_Index - 3]
				minarray[4*A_Index-3] := fourkdata[A_Index]
			if fivekdata[A_Index] > minarray[4 * A_Index - 2]
				minarray[4*A_Index-2] := fivekdata[A_Index]
			if sixkdata[A_Index] > minarray[4 * A_Index - 1]
				minarray[4*A_Index-1] := sixkdata[A_Index]
			if eightkdata[A_Index] > minarray[4 * A_Index]
				minarray[4*A_Index] := eightkdata[A_Index]
			
			if fourkdata[A_Index] < maxarray[4 * A_Index - 3] and fourkdata[A_Index]>0
				maxarray[4*A_Index-3] := fourkdata[A_Index]
			if fivekdata[A_Index] < maxarray[4 * A_Index - 2] and fivekdata[A_Index]>0
				maxarray[4*A_Index-2] := fivekdata[A_Index]
			if sixkdata[A_Index] < maxarray[4 * A_Index - 1] and sixkdata[A_Index]>0
				maxarray[4*A_Index-1] := sixkdata[A_Index]
			if eightkdata[A_Index] < maxarray[4 * A_Index] and eightkdata[A_Index]>0
				maxarray[4*A_Index] := eightkdata[A_Index]
		}
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

;Safetycheck for Filter settings (kmode, diffmode)
;Updates db in memory if different filtersettings are found.
CheckFilter()
{
	global songpacks
	static enabledsongpacks:=0
	statusbar.SetText("")
	if enabledsongpacks!=ArrToStr(songpacks) or excludebox.value=1
	{	
		enabledsongpacks:=ArrToStr(songpacks)
		GenerateSongTable()
	}
	SetMinMaxBoundaries()
	checkk:=0, checkd:=0
	while A_Index<=4
	{
	if kmode[A_Index].Value=0 or kmode[A_Index].Enabled=0
		checkk++
	if diffmode[A_Index].Value=0 or diffmode[A_Index].Enabled=0
		checkd++
	}
	if checkk=4 or checkd=4
	{
		while A_Index<=4
		{
			kmode[A_Index].Enabled:=1
			diffmode[A_Index].Enabled:=1
		}
		statusbar.SetText("Please adjust your settings. That combination leads nowhere @_@")	
		Return 1
	}
}

ExcludeChart(songnum, kmod, songd)
{
	global excludedb
	kshift:=((kmod-4)*4<12 ? (kmod-4)*4 : 12)
	Switch songd
	{
		Case "NM":
			dshift:=0
		Case "HD":
			dshift:=1
		Case "MX":
			dshift:=2
		Case "SC":
			dshift:=3
	}
	excludedb[songnum]+=(0x1<<dshift) << kshift
	excludebox.value := 1
	excludebox.enabled := 0
}

RetrieveChartFromExludeDb(songnum, kmod, songd)
{
	global excludedb
	kshift:=((kmod-4)*4<12 ? (kmod-4)*4 : 12)
	Switch songd
	{
		Case "NM":
			dshift:=0
		Case "HD":
			dshift:=1
		Case "MX":
			dshift:=2
		Case "SC":
			dshift:=3
	}
	try 
		Return !((excludedb[songnum]>>kshift & 0xF)>>dshift & 0x1)
	catch
	{
			FileMove("DJMaxExcludeCharts.db", "DJMaxExcludeCharts_before_" . version . ".db", 1) 
			Msgbox("Error in retrieving Excluded chart database entries!`nMost likely SongList.db changed due to added songs.`nA backup of DJMaxExcludeCharts.db has been made and a new one was created!")
			Reload
	}
	
}

;Helper function to get value in dlcpack/songpack Array from songgroup String
EvaluateSongGroup(sg, dlc:=1)
{
	Switch sg
		{
			Case "RE":
				val:=1
			Case "P1":
				val:=2
			Case "P2":
				val:=3
			Case "P3":
				val:=4
			Case "TR":
				val:=5
			Case "CL":
				val:=6
			Case "BS":
				val:=7
			Case "V1":
				val:=8
			Case "V2":
				val:=9
			Case "V3":
				val:=10
			Case "ES":
				val:=11
			Case "T1":
				val:=12
			Case "T2":
				val:=13
			Case "T3":
				val:=14
			Case "TQ":
				val:=15	
			Case "GG":
				val:=16
			Case "CH":
				val:=17
			Case "CY":
				val:=18
			Case "DE":
				val:=19
			Case "ET":
				val:=20
			Case "GC":
				val:=21
			Case "GF":
				val:=22
			Case "NE":
				val:=23
			Case "MD":
				val:=24
			Default:
				MsgBox("Invalid Songgroup! Data corrupted?")
				ExitApp
		}
	if dlc=1 and val>3
		Return dlcpacks[val-3].value + (val>14 ? 2 : 0)
	if dlc=1
		Return 1
	else 
		Return songpacks[(val>14 ? 15 : val)].value
}

; Helper Function to initialize arrays
FillArr(count, data:=1)
{
arr:=[]
while A_index<=count
	arr.push(data)
Return arr
}

; Prints order of internal db songs
DebugFunc(name, order, songpack)
{
		static orderstr:=""
		if order=1 and orderstr!=""
		{
			;FileAppend(orderstr, "NewOrder.txt")
			MsgBox(orderstr)
			orderstr:=""	
		}
		orderstr := orderstr . name . "," . order . "," . songpack . "`n"
		if order=4 and substr(name,1,1)="Z"
		{
			;FileAppend(orderstr, "NewOrder.txt")
			MsgBox(orderstr)
			ExitApp(0)
		}
		
}

; Extends default sorting function since DJMax has a weird song sorting scheme 
	; Problematic songs:
	; Urban Night 2x
	; A lie <-> A lie ~deep inside mix~
	; I've got a feeling <-> I want you or IF
	; We're gonna die <-> welcome to the space
	; U-nivius
FunctionSort(first,last,*)
{
	;chr(32) space, chr(45) -, chr(58) :, chr(59) ;, chr(39) ', chr(700) ʼ, chr(126) ~
	;Upper first 4 letters since LovePanic comes before Lovely Hands.
	;Eexceptions for LovePanic/Lovely hands
	;Else alone breaks Supersonic and NB Ranger songs
	if (substr(first,1,4)="Love" and substr(last,1,4)="Love")
	{
		first := strupper(substr(first,1,4)) . substr(first,5,strlen(first)-4)
		last:= strupper(substr(last,1,4)) . substr(last,5,strlen(last)-4)
	}
	else
		first := strupper(first), last:=strupper(last)
	
	loop parse first
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1))  
		;if substr(first,1,3)="NB " or substr(last,1,3)="NB "
		;	Msgbox(first ":`n" charf " : " chr(charf) "`n" last "`n" charl " : " chr(charl))
		;Msgbox(ord("-"))
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1)) 
		if ((charf!=59 and charl=59)
		or (charf=45 and charl<=78))
		;or (charf=39 and charl=32)
		;or (charf=39 and charl=76)
		;or (charf=39 and charl=68)
		;or (charf=50 and charl=126)
		;or (charf=108 and charl=80))
			Return 1
		if ((charl!=59 and charf=59)
		or (charl=45 and charf<=78)
		or (charl=39 and charf=76)
		or (charl=39 and charf=68)
		or (charl=50 and charf=126)
		or (charl=108 and charf=80))
		;or (charl=39 and charf=32)
			Return -1
		if charf!=charl
			Return 0
	}
}

customsort(strf, strl, *)
{
	;Msgbox(ord(","))
	strf := strupper(substr(strf,1,4)) . substr(strf,5,strlen(strf)-4)
	strl:= strupper(substr(strl,1,4)) . substr(strl,5,strlen(strl)-4)
	;Msgbox(strf "`n" strl)
	loop parse strf
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(strl,A_Index,1))
		if charf=39
			charf+=128
		if charl=39
			charl+=128
		if charf=59
			charf-=128
		if charl=59
			charl-=128	
		
		if charf<charl
			Return -1
		if charf>charl
			Return 1
	}
	Return 0
}

; If Songtable is empty it will generate it
GenerateSongTable()
{
	global songsdbmem := []
	static SongsDB := sort(sort(FileRead("SongList.db")),,functionsort)
	;static SongsDB := sort(FileRead("SongList.db"),,functionsort)
	loop parse SongsDB, "`n"
	{
		song_data := strsplit(A_Loopfield, ";")
		if song_data.length=0
			break
		sd_index:=3
		lp_index:=A_Index
		for k in [4,5,6,8]
		{
			for d in ["NM","HD","MX","SC"]
			{
			if !RetrieveChartFromExludeDb(lp_index,k,d)
				song_data[sd_index]:=-1
			sd_index++
			}
		}
		songsdbmem.push(Generate_Chart_Data(song_data[1],song_data[2], [song_data[3],song_data[4],song_data[5],song_data[6]], [song_data[7],song_data[8],song_data[9],song_data[10]], [song_data[11],song_data[12],song_data[13],song_data[14]], [song_data[15],song_data[16],song_data[17],song_data[18]], A_Index))
;		if A_Index = 432
;			MsgBox(song_data[1] " " song_data[15] "," song_data[16] "," song_data[17] "," song_data[18])
	}
}

;Called when Edit menu is closed. Enables/Disables checkboxes
ModifySettings(*)
{
	for dlc in dlcpacks
	{
		element := (A_Index<=maindlccount ? A_Index+3 : songpacks.length)
		if dlc.value=0
		{
			songpacks[element].value:=0
			songpacks[element].enabled:=0
		}
		else
		{
			songpacks[element].value:=1
			songpacks[element].enabled:=1
			if element=songpacks.length
				break
		}
	}
	Checkfilter()
}

SaveAndExit(*)
{
	if settings[1]!=mindiff.value
		iniwrite(mindiff.value,"DJMaxRandomizer.ini", "config", "min")
	if settings[2]!=maxdiff.value
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
	if settings[7]!=delaykeyinput.value
		iniwrite(delaykeyinput.value, "DJMaxRandomizer.ini", "config", "keydelay")
	if settings[8]!=ArrToStr(songpacks)
		iniwrite(ArrToStr(songpacks),"DJMaxRandomizer.ini", "packs_selected", "packs")
	if settings[9]!=ArrToStr(dlcpacks,1,maindlccount)
		iniwrite(ArrToStr(dlcpacks,1,maindlccount),"DJMaxRandomizer.ini", "dlc_owned", "main")
	if settings[10]!=ArrToStr(dlcpacks,maindlccount+1)
		iniwrite(ArrToStr(dlcpacks,maindlccount+1),"DJMaxRandomizer.ini", "dlc_owned", "coll")
	filedb:=fileopen("DJMaxExcludeCharts.db","w")
	global excludedbstring:=strsplit(excludedbstring)
	for chartdata in excludedb
	{
		chartdata := Format("0x{:04x}", chartdata)
			if A_Index>excludedbstring.length or chartdata != excludedbstring[A_Index]
			{
				filedb.pos:=7*(A_Index-1)
				filedb.write(chartdata . "`n")
			}
	}
	filedb.close()
	ExitApp
}

;Sets difficulty boundaries and disables checkboxes according to slider value
;Min/MaxArray are fixed values for min/max difficulty on each mode: 
;e.g. 9 is the highest minimum '*'-count for 4k&5k NM
;e.g. 7 is the lowest maximum '*'-count for 5k&6k&7k MX
;New: Min/MaxArrays are dynamically adjusted depending on selected SongPacks.
SetMinMaxBoundaries()
{	
	;static minarray := [[9,9,11,12],[13,13,14,14],[15,15,15,15],[15,15,15,15]]
	;static maxarray := [[1,1,1,1],[3,4,4,3],[6,7,7,7],[10,10,12,10]]
	global minarray,maxarray
	indexkdisable:=fillarr(4,0)
	safetykmode:=4
	for indexd in diffmode
	{
		B_Index:=A_Index-1
		indexddisable:=0
			for indexk in kmode
			{
				if indexk.value=1 and (mindiff.value>minarray[4 * B_Index + A_Index] or maxdiff.value<maxarray[4 * B_Index + A_Index])
				{
					indexkdisable[A_Index]++
					indexddisable++
				}
				else
				{
					if indexd.value=0
						indexkdisable[A_Index]++
					if indexk.value=0
						indexddisable++
				}
			}
		if indexddisable=4
			indexd.enabled:=0
		else
			indexd.enabled:=1
	}
	while A_Index<=kmode.length
		if indexkdisable[A_Index]=4
			kmode[A_Index].enabled:=0
		else
			kmode[A_Index].enabled:=1
}

ToggleAllSongPacks(*)
{
	for packs in songpacks
		if packs.enabled=1
			if songpacktoggle.value=1 
				packs.value:=1
			else 
				packs.value:=0
	Checkfilter()
}

UpdateSlider(slider:=0)
{
	statusbar.SetText("")	
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
	CheckFilter()
}


CheckSongPack(sg)
{
	for pack in songpacks
		if sg=pack.text and pack.value=1
			Return 1
	Return 0
}

; Determines the song to play and updates the GUI when found
RollSong(songpacks, kmodes, songdiff, mindiff, maxdiff)
{
	if CheckFilter()
		Return
	loop
	{
		;Select Random k-Mode
		kmode:=""
		while kmode=""
		{
			randomnum := Random(1,4)
			if kmodes[randomnum].value=1 and kmodes[randomnum].enabled=1
				Switch randomnum
				{
					Case 1:
						kmode:="fourk"
						kmodnum:=4
					Case 2:
						kmode:="fivek"
						kmodnum:=5
					Case 3:
						kmode:="sixk"
						kmodnum:=6
					Case 4:
						kmode:="eightk"
						kmodnum:=8
				}	
		}
		
		;Select Random Difficulty.
		songdif:=""
		while songdif=""
		{
			maximum:=maxdiff.value
			minimum:=mindiff.value
			randomnum := Random(1,4)
			if songdiff[randomnum].value=1 and songdiff[randomnum].enabled=1
				Switch randomnum
				{
					Case 1:
						songdif:="NM"
						color:="00FF00"

					Case 2:
						songdif:="HD"
						color:="00FFFF"
					Case 3:
						songdif:="MX"
						color:="FF8E55"
					Case 4:
						songdif:="SC"
						color:="FF00FF"
				}
		}
	} until songsdbmem[songnumber:=Random(1,songsdbmem.length)].%kmode%.%songdif%!=0 and songsdbmem[songnumber].%kmode%.%songdif%<=maximum and songsdbmem[songnumber].%kmode%.%songdif%>=minimum and CheckSongPack(songsdbmem[songnumber].sg) and songsdbmem[songnumber].order>-1 and RetrieveChartFromExludeDb(songnumber, kmodnum, songdif) ;and songnumber>0 and songnumber<3
	guisongname.Text:=songsdbmem[songnumber].Name
	guikmode.Text:=kmodnum . "K"
	guidiff.SetFont("W700 C" . color)
	guidiff.Text:=songdif
	guistarsy.SetFont("s19 CFFFD55 W700")
	guistarsy.Text:=""
	guistarso.SetFont("s19 CFF8E55 W700")
	guistarso.Text:=""
	guistarsr.SetFont("s19 CFF0000 W700")
	guistarsr.Text:=""
	guistarsp.SetFont("s19 CFF00FF W700")
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
global songnum:=songnumber, kmod:=kmodnum, songd:=songdif
excludebox.enabled := 1
excludebox.value:= 0
excludebox.visible := 1
SelectSong(Songsdbmem[songnumber], kmode, songdif)
}

; Sends Input to game
SelectSong(song, kmode, songdif)
{
	try WinActivate("ahk_exe DJMax Respect V.exe")
	catch
	{
		statusbar.SetText("Game window not found! Can't send you straight to the song :(")	
		Return
	}
	SendFunc("PgUp")
	statusbar.SetText("Sending Input..." song.order "x " substr(song.name,1,1))	
	;In future need to implement song.order for # and !@#-Groups
	if ord(strupper(song.name))-64 < 1 
	{
		SendFunc("a")
		SendFunc("PgUp")
		if song.order=1
			SendFunc("PgUp")
	}
	else
		SendFunc(strlower(substr(song.name,1,1)), song.order)
	oldletter:=strlower(substr(song.name,1,1))
	;dMsgBox("Sent Input:" song.order "x " substr(song.name,1,1))
	switch kmode
	{
		case "fourk":
			SendFunc("4")
		case "fivek":
			SendFunc("5")
		case "sixk":
			SendFunc("6")
		case "eightk":
			SendFunc("8")
	}
	if (songdif="HD" or songdif="MX" or songdif="SC") and (song.%kmode%.hd>0 or song.%kmode%.hd=-1)
		SendFunc("right")
	if (songdif="MX" or songdif="SC") and (song.%kmode%.mx>0 or song.%kmode%.mx=-1)
		SendFunc("right")
	if songdif="SC" and (song.%kmode%.sc>0 or song.%kmode%.sc=-1)
		SendFunc("right")
	statusbar.SetText("Are you Ready? Never give up!")	
}

SendFunc(key, repeat:=1){
	;global delaykeyinput
	while (repeat-->0)
	{
		Send "{" . key . " down}"
		Sleep delaykeyinput.value
		Send "{" . key . " up}"
		Sleep delaykeyinput.value
	}
}
