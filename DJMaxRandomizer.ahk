;DJMax Respect V Randomizer
;Provided to you by GothicIII

;Needed to generate song database
;#include DJMax_Detection.h
;Numpad1::GetSongData()

; Variable initialization
;#NoTrayIcon
Version:="1.3.220729"
songpacks:=[], kmode:=[], diffmode:=[], stars:=[], dlcpacks:=[], settings:=[], songsdbmem:=[]

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
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technica Tune & Q"))
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
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "TQ"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "CO"))
for each in songpacks
	each.OnEvent('Click', (*)=>Checkfilter())
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
(mindiff := DJMaxGui.Add("Slider", "yp x+ w335 Range1-15 ToolTip", 1)).OnEvent('Change', (*)=>UpdateSlider(1))
stars.push(DJMaxGui.Add("Text", "xp+3 y+-4 w22 h30 center","★   "))
while A_Index<15
	stars.push(DJMaxGui.Add("Text", "x+ wp hp center","★   "))
DJMaxGui.Add("Text", "x1 y+ w100 right","Max:")
(maxdiff := DJMaxGui.Add("Slider", "yp x+ w335 Left Range1-15 ToolTip section", 15)).OnEvent('Change', (*)=>UpdateSlider())
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Go!").OnEvent('Click', (*)=>RollSong(songpacks, kmode, diffmode, mindiff, maxdiff))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Save&&Exit").OnEvent('Click', SaveAndExit)
DJMaxGui.Add("Text", "xs+7 ys+50 w60","Song: ")
(excludebox := DJMaxGui.Add("Checkbox", "xs+7 ys+80 left","Exclude?`n(F4)")).OnEvent('Click', (*)=>ExcludeChart(songnum, kmod, songd))
excludebox.visible := 0, excludebox.Enabled:=0
guisongname	:= DJMaxGui.Add("Text", "x+ yp-28 w310 h30 section"," ")
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
	Iniwrite("main=1111111111`ncoll=111111111", "DJMaxRandomizer.ini", "dlc_owned")
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
	
	if not FileExist("SongList.db")
	{
		MsgBox("You need to generate a SongList.db first! Either use GetSongData() from detection lib or download a premade one!")
		Return
	}
	
	
	; prefill with data.
	excludedb := fillarr(1024,0)
	if FileExist("DJMaxExcludeCharts.db")
		loop parse excludedbstring :=FileRead("DJMaxExcludeCharts.db"), "`n"
			excludedb[A_Index]:=A_Loopfield
	else
		global excludedbstring:=""
 ; Draw GUI
	UpdateSlider()
	excludedb.RemoveAt(songsdbmem.length,excludedb.length-songsdbmem.length)
	DJMaxGui.Show((winposx="null" ? "" : "x" . winposx . "y" winposy))
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
		static alphaarr := fillarr(26,0)
		if newdb=1 
		{
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
				this.order:=0
			else
				this.order	:= ++alphaarr[ord(strupper(this.name))-64]
		;debugfunc(name, this.order, songgroup)
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
		Msgbox("Error in retrieving Excluded chart database entries!`nMost likely SongList.db changed due to added songs.`nIn that case please delete DJMaxExcludeCharts.db and try again!")
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
			Case "ES":
				val:=10
			Case "T1":
				val:=11
			Case "T2":
				val:=12
			Case "T3":
				val:=13
			Case "TQ":
				val:=14	
			Case "GG":
				val:=15
			Case "CH":
				val:=16
			Case "CY":
				val:=17
			Case "DE":
				val:=18
			Case "ET":
				val:=19
			Case "GC":
				val:=20
			Case "GF":
				val:=21
			Case "NE":
				val:=22
			Case "MD":
				val:=23
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
		static oldorder:=0
		if oldorder>order
		{
			if substr(strupper(name),1,1)="M"
			MsgBox(orderstr)
			orderstr:=""
		}
		oldorder:=order
		orderstr := orderstr . name . "," . order . "," . songpack . "`n"
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
	;first := strupper(first), last:= strupper(last)

	
	loop parse first
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1)) 
		if (charl=59 and charf!=59) or (charf=45 and charl<=78) or (charf=39 and charl=32) or (charf=39 and charl=76) or (charf=39 and charl=68) or (charf=50 and charl=126) or (charl=80 and charf=108)
			Return 1
		if (charf=59 and charl!=59) or (charl=45 and charf<=78) or (charl=39 and charf=32) or (charl=39 and charf=76) or (charl=39 and charf=68) or (charf=126 and charl=50) or (charl=108 and charf=80)
			Return -1
		if charf!=charl or (charf=59 and charl=59)
			Return 0
	}
}

; If Songtable is empty it will generate it
GenerateSongTable()
{
	global songsdbmem := []
	static SongsDB := sort(sort(FileRead("SongList.db")),,functionsort)
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
	if settings[7]!=ArrToStr(songpacks)
		iniwrite(ArrToStr(songpacks),"DJMaxRandomizer.ini", "packs_selected", "packs")
	if settings[8]!=ArrToStr(dlcpacks,1,maindlccount)
		iniwrite(ArrToStr(dlcpacks,1,maindlccount),"DJMaxRandomizer.ini", "dlc_owned", "main")
	if settings[9]!=ArrToStr(dlcpacks,maindlccount+1)
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
	} until songsdbmem[songnumber:=Random(1,songsdbmem.length)].%kmode%.%songdif%!=0 and songsdbmem[songnumber].%kmode%.%songdif%<=maximum and songsdbmem[songnumber].%kmode%.%songdif%>=minimum and CheckSongPack(songsdbmem[songnumber].sg) and songsdbmem[songnumber].order>-1 and RetrieveChartFromExludeDb(songnumber, kmodnum, songdif)
	guisongname.SetFont("s10")
	guisongname.Text:=songsdbmem[songnumber].Name
	guikmode.Text:=kmodnum . "K"
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
		statusbar.SetText("DJMaxV window not found! Can't send you straight to the song :(")	
		Return
	}
	Send "{PgUp down}"
	Sleep 25
	Send "{PgUp up}"
	Sleep 25
	if song.order=0
	{
		send "a"
		Sleep 25
		send "{Up down}"
		Sleep 25
		Send "{Up up}"
		Sleep 25
	}
	statusbar.SetText("Sending Input..." song.order "x " substr(song.name,1,1))	
	while A_Index<=song.order
	{
		Send "{" . strlower(substr(song.name,1,1)) . " down}"
		Sleep 10
		Send "{" . strlower(substr(song.name,1,1)) . " up}"
		Sleep 25
		if A_Index=1
			Sleep 300
	}
	oldletter:=strlower(substr(song.name,1,1))
	;dMsgBox("Sent Input:" song.order "x " substr(song.name,1,1))
	switch kmode
	{
		case "fourk":
			Send "{4 down}"
			Sleep 25
			Send "{4 up}"
		case "fivek":
			Send "{5 down}"
			Sleep 25
			Send "{5 up}"
		case "sixk":
			Send "{6 down}"
			Sleep 25
			Send "{6 up}"
		case "eightk":
			Send "{8 down}"
			Sleep 25
			Send "{8 up}"
	}
	Sleep 25
	if (songdif="HD" or songdif="MX" or songdif="SC") and (song.%kmode%.hd>0 or song.%kmode%.hd=-1)
	{
			Send "{right down}"
			Sleep 25
			Send "{right up}"
			Sleep 25
	}
	if (songdif="MX" or songdif="SC") and (song.%kmode%.mx>0 or song.%kmode%.mx=-1)
	{
			Send "{right down}"
			Sleep 25
			Send "{right up}"
			Sleep 25
	}
	if songdif="SC" and (song.%kmode%.sc>0 or song.%kmode%.sc=-1)
	{
			Send "{right down}"
			Sleep 25
			Send "{right up}"
			Sleep 25
	}
	statusbar.SetText("Are you Ready? Never give up!")	
}
