;DJMax Respect V Randomizer
;Provided to you by GothicIII
;Changelog since last release:
; - Optimized config generation and variable initialization (Running for the 1st time disables all DLC packs properly)

; <DEBUG FUNCTIONS>
;Numpad3::Reload()
; Main header for debug/recording functions
/*



#include DJMax_Detection.h

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

;Generates Songname.db from SongList.
Numpad6::CreateSongNameDbFromSongList()

Numpad7::Msgbox(EvaluateSongGroup("PL1",0))

; Quickly shows songpack bounderies. They are directly taken from SongNames db. Add new cm/cv songpacks in global section of Detection.h!
Numpad9::Song_Order_Numbers_New(1)

try (FileDelete("InternalDB.db"))
*/
try 
	if DirExist("Exclude_Archive")
		Filecopy("DJMaxExcludeCharts.db","Exclude_Archive\DJMaxExcludeCharts_" A_YYYY "_" A_MM "_" A_DD "_" A_Hour "_" A_Min ".db",1)
; Variable initialization
#NoTrayIcon
OnMessage(0x5555,Receive_Connection_Data)
Version:="2.3.250428a"
songpacks:=[], kmode:=[], diffmode:=[], stars:=[], dlcpacks:=[], settings:=[], songsdbmem:=[], globwparam:=""

; Create new settings file if it is missing
try 
	if (Iniread("DJMaxRandomizer.ini","config","version")!=Version)
		throw ValueError()
catch 
{
	MsgBox("Generating new config...")
	try FileDelete("DJMaxRandomizer.ini")
	Iniwrite("min=1`nmax=15`nkmodes=1111`ndifficulty=1111`nwinposx=null`nwinposy=null`nkeydelay=25`nversion=" . Version, "DJMaxRandomizer.ini", "config")
	Iniwrite("packs=1111", "DJMaxRandomizer.ini", "packs_selected")
	Iniwrite("main=0`ncollmus=0`ncollvar=0`nplipak=0", "DJMaxRandomizer.ini", "dlc_owned")
}

; GUI Initializiation
; EDIT menu Gui

(DJMaxGuiSubMenu := Gui("","DLC-Settings")).OnEvent('Close', ModifySettings)
DJMaxGuiSubMenu.SetFont("S12 q5")
DJMaxGuiSubMenu.Add("Text", "x10 y1 w250 left section","Main DLC-Packs").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ x10 w150 section", "Portable 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Trilogy"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Clazziquai"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Black Square"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "V Extension 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 4"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Extension 5"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "V Liberty"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Liberty 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Emotional Sense"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp+10", "Technica Tune && Q"))
maindlccount:=dlcpacks.length
DJMaxGuiSubMenu.Add("Text", "x10 y+40 w250 left","Collaboration").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x10 y+ w150 left section","Music Packs:").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x+ yp left","Variety Packs:").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x+50 yp left","PLI Playlist Packs:").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x10 y+ w150 section", "Chunism"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Cytus"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Deemo"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "EZ2ON"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Groove Coaster"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Muse Dash"))
musicdlccount:=dlcpacks.length
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Guilty Gear"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Blue Archive"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Estimate"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Falcom"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Girls' Frontline"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Maplestory"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Nexon"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Tekken"))
varietydlccount:=dlcpacks.length
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "2025 Vol. 1"))
(dlcpacktoggle := DJMaxGuiSubmenu.Add("Checkbox", "x+ ys wp Checked", "All DLC")).OnEvent('Click', ToggleMainDLCSongPacks)
(collabpacktoggle := DJMaxGuiSubmenu.Add("Checkbox", "y+ wp Checked", "All Coll/PLI")).OnEvent('Click', ToggleCollSongPacks)
DJMaxGuiSubMenu.Add("Text", "x10 y+120 w450 left","Select the DLCs you have. Settings will be saved.`nThis will regenerate the random table so unowned songs`nwon't be rolled.")
DJMaxGuiSubMenu.Add("Text", "x10 y+20 left","Keydelay in msec:")
delaykeyinput := DJMaxGuiSubMenu.Add("Slider", "x+ Tooltip Range5-100", iniread("DJMaxRandomizer.ini", "config", "keydelay"))
DJMaxGuiSubMenu.Add("Text", "x10 y+20 left","If song selection often stops on the wrong song/difficulty`nset this higher.`nLower values will increase song selection speed`nRecommended: 25 msec")
DJMaxGuiSubMenu.Add("Link", "x10 y+20 left",'Latest version: <a href="https://github.com/GothicIII/DJMaxRespectV-Randomizer/releases">Release page</a>')
DJMaxGuiSubMenu.Add("Text", "y+-10 right x375", "v" . Version).SetFont("s8")

;Main GUI
(DJMaxGui := Gui("","DJMax Respect V Freeplay Randomizer by GothicIII")).OnEvent('Close', SaveAndExit)
DJMaxGui.SetFont("S12")
DJMaxGui.Add("Text", "x1 y10 w100 right","Song-Packs:")
songpacks.push(DJMaxGui.Add("Checkbox", "x+10 w65 section", "RE"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "RV"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "P3"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "TR"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "CL"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "BS"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "V1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V3"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V4"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "V5"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "VL"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "VL2"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "ES"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T3"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "TQ"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "CM"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "CV"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "PLI"))
for each in songpacks
	each.OnEvent('Click', (*)=>Checkfilter())
DJMaxGui.Add("Text", "y+ wp hp", "")
(songpacktoggle := DJMaxGui.Add("Checkbox", "y+ wp Checked", "All")).OnEvent('Click', ToggleAllSongPacks)
DJMaxGui.Add("Button", "section y+ hp", "Options").OnEvent('Click', (*)=>DjMaxGuiSubMenu.Show((DJMaxGui.GetClientPos(&x,&y,&w)) "x" x+w . "y" . y-30 ))
DJMaxGui.Add("Button", "y+ wp hp", "Stats").OnEvent('Click', (*)=>DJMaxGuiStat.Show((DJMaxGui.GetClientPos(&x,&y,&w)) "x" x+w . "y" . y-30 ))
DJMaxGui.Add("Text", "x1 ys+20 w100 right","K-Modes:")
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
(excludebox := DJMaxGui.Add("Checkbox", "x+60 left","Exclude Chart? (F4)")).OnEvent('Click', (*)=>ExcludeChart(songid, kmod, songd))
excludebox.visible := 0, excludebox.Enabled:=0
guistarsy 	:= DJMaxGui.Add("Text", "xs y+ w90 h30"," ")
guistarso	:= DJMaxGui.Add("Text", "x+ yp wp hp"," ")
guistarsr	:= DJMaxGui.Add("Text", "x+ yp wp hp"," ")
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
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "collmus"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "collvar"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "plipak"))
	mindiff.value:=settings[1]
	maxdiff.value:=settings[2]
	loop parse settings[3]
		kmode[A_Index].value:=A_Loopfield
	loop parse settings[4]
		diffmode[A_Index].value:=A_Loopfield
	winposx:=settings[5]
	winposy:=settings[6]
	if settings[8]=0
		settings[8]:=1
	loop parse settings[8]
		songpacks[A_Index].value:=A_Loopfield
	; main dlcpacks
	if settings[9]="0"
		loop maindlccount-1
			settings[9]:=settings[9] . "0"
	loop parse settings[9]
	{
		dlcpacks[A_Index].value:=A_Loopfield
		songpacks[A_Index+4].Enabled:=A_Loopfield
	}
	; dlcmus
	if settings[10]=0
		songpacks[songpacks.length-2].enabled:=0
	loop parse settings[10]
		dlcpacks[A_Index+maindlccount].value:=A_Loopfield
	; dlcvar
	if settings[11]=0
		songpacks[songpacks.length-1].enabled:=0
	loop parse settings[11]
		dlcpacks[A_Index+musicdlccount].value:=A_Loopfield
	; dlcpli	
	if settings[12]=0
		songpacks[songpacks.length].enabled:=0
	loop parse settings[12]
		dlcpacks[A_Index+varietydlccount].value:=A_Loopfield
	if not FileExist("SongList.db")
	{
		if (MsgBox("You need to generate a SongList.db first! Either use GetSongData() from detection lib or download a premade one!","SongList.db missing!",5)= "Retry")
			Reload
		else 
			ExitApp
	}
	
	; prefill with data.
	excludedb := Map()
	try loop read, "DJMaxExcludeCharts.db", "`n"	
	{
		exclude_data := strsplit(A_LoopReadLine,";")
		if exclude_data.Has(2)
			if not (exclude_data[2]<=0xFFFF)
				throw Error()
		excludedb.Set(exclude_data[1], exclude_data[2])
	}
	catch 
	{
		Msgbox("DJMaxExcludeCharts.db has errors/does not exist!`nA new file will be created.",,"T2")
		try FileMove("DJMaxExcludeCharts.db", "DJMaxExcludeCharts_" . version . "_bak.db", 1) 
	}
	; Draw GUI
	UpdateSlider()
	DJMaxGui.Show((winposx="null" ? "" : "x" . winposx . "y" winposy))
	
	; New buttons 'Stats' will open following subgui 
	DJMaxGuiStat := Gui("","Chart-Statistic")
	DJMaxGuiStat.SetFont("q5 s11","Consolas")
	(filter4k := DJMaxGuiStat.Add("Button", "section x+ y+ w50","4K")).OnEvent('Click', (*)=>SetFilter("4k"))
	(filter5k := DJMaxGuiStat.Add("Button", "section x+ yp wp","5K")).OnEvent('Click', (*)=>SetFilter("5k"))
	(filter6k := DJMaxGuiStat.Add("Button", "section x+ yp wp","6K")).OnEvent('Click', (*)=>SetFilter("6k"))
	(filter8k := DJMaxGuiStat.Add("Button", "section x+ yp wp","8K")).OnEvent('Click', (*)=>SetFilter("8k"))
	(filterak := DJMaxGuiStat.Add("Button", "section x+ yp wp","ALLK")).OnEvent('Click', (*)=>SetFilter("ak"))
	filterak.Opt("+Default")
	SetFilter("ak",0)
	if A_Args.length>0
		Receive_Connection_Data(A_Args[1])
	NumpadAdd::{
		Try WinMinimize("ahk_exe DJMax Respect V.exe")
		WinGetPos(&x, &y,,,"DJMax Respect V Freeplay")
		CoordMode "Mouse","Screen"
		MouseMove(x+100,y+150)
		WinActivate("DJMax Respect V Freeplay")
	}
	^F2::CacheSongSelection()
	F2::try RollSong(songpacks, kmode, diffmode, mindiff, maxdiff)
	F4::
	{
		if excludebox.Enabled=1
			ExcludeChart(songid, kmod, songd)
	}

; Determines which table is shown in the statistics subgui
SetFilter(checkbox, update:=1)
{
	static alreadyrun:=0
	global DJMaxGuiStat
	if ++alreadyrun=1
	{
		for k in ["4k","5k","6k","8k","ak"]
			if checkbox=k
			{
				DJMaxGuiStat.Add("Text", "section x10 y42 left","Available charts").SetFont("underline")
				Create_Table(charts.%k%, 32)
				DJMaxGuiStat.Add("Text", "section x10 y+20 left", "Excluded charts").SetFont("underline")
				Create_Table(chartsmiss.%k%, 230)
				filter%k%.SetFont("underline")
				if update=1
					DJMaxGuiStat.Show("AutoSize")
				continue
			}
			else
				filter%k%.SetFont("")
		alreadyrun:=0
	}
}

; Draws and fills the statistics table
Create_Table(chartobj, pix)
{
	; Yeah, need this to update chart data
	GenerateSongTable()
	charbuf:=[]
	Loop 17
	{
		If A_Index=1
		{
			DJMaxGuiStat.Add("Text", "section xs y+20 left", "LV:")
			DJMaxGuiStat.Add("Text", "xp y+20 left c00FF00 BackgroundSilver", "NM:").SetFont("bold")
			DJMaxGuiStat.Add("Text", "xp y+20 left c00FFFF BackgroundSilver", "HD:").SetFont("bold")
			DJMaxGuiStat.Add("Text", "xp y+20 left cFF8E55 BackgroundSilver", "MX:").SetFont("bold")
			DJMaxGuiStat.Add("Text", "xp y+20 left cFF00FF BackgroundSilver", "SC:").SetFont("bold")
			continue
		}
		If A_Index-1<6
			DJMaxGuiStat.Add("Text", "x+10 section ys cFFFD55", "  ★")
		else if A_Index-1<11
			DJMaxGuiStat.Add("Text", "x+10 section ys cFF8E55", "  ★")
		else if A_Index-1<16
			DJMaxGuiStat.Add("Text", "x+10 section ys cFF0000", "  ★")
		else
			DJMaxGuiStat.Add("Text", "x+10 section ys", " | ∑   ")
		if A_Index-1=16
		{
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.NM.sum "  "))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.HD.sum "  "))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.MX.sum "  "))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.SC.sum "  "))
		}		
		else
		{
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", fillhole(strlen(chartobj.NM.lv%A_Index-1%)) . chartobj.NM.lv%A_Index-1%))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", fillhole(strlen(chartobj.HD.lv%A_Index-1%)) . chartobj.HD.lv%A_Index-1%))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", fillhole(strlen(chartobj.MX.lv%A_Index-1%)) . chartobj.MX.lv%A_Index-1%))
			charbuf.push(DJMaxGuiStat.Add("Text", "xs y+20", fillhole(strlen(chartobj.SC.lv%A_Index-1%)) . chartobj.SC.lv%A_Index-1%))
		}
	}
	; very important! Redraws all elements.
	for i in charbuf
		i.redraw()
}

; Used by Create_Table() - filling up small values with spaces
fillhole(len)
{
	If len=3
		Return " "
	else if len=2
		Return "  "
	else 
		Return "   "
}

; Chart data definition in memory
class Generate_Chart_Data
{
	__New(name, songgroup, fourkdata, fivekdata, sixkdata, eightkdata, songid, newdb:=0)
	{
		global minarray, maxarray
		static alphaarr := fillarr(26,0), numeric:=0
		if newdb=1 
		{
			numeric:=0
			alphaarr:=fillarr(26,0)
			minarray:=fillarr(16,0)
			maxarray:=fillarr(16,16)
		}
		esg:=EvaluateSongGroup(songgroup)
		this.name 	:= name
		this.realsg := songgroup
		this.id		:= songid
						;if this.name="#mine (feat. Riho Iwamoto)"
					;Msgbox(this.name "`n" ord(strupper(this.name))-64 "`n" (ord(strupper(this.name))-64<1?"Yes":"No") "`n" MOd(esg,2)=0?"UhOh":"Puh")

		;if esg=0 or esg=2 or esg=4 or esg=6

		if Mod(esg,2)=0
			this.order:=-1
		else 
			if ord(strupper(this.name))-64 < 1 
				this.order:=++numeric
			else
				this.order	:= ++alphaarr[ord(strupper(this.name))-64]
				;	Msgbox("O:" strupper(this.name))	
		; Further unlock conditions for very specific songs
		if (this.name="Airwave ~Extended Mix~" and EvaluateSongGroup("CL",0)=0 and EvaluateSongGroup("T1",0)=0)
			or (this.name="Diomedes ~Extended Mix~" and EvaluateSongGroup("VL2",0)=0)
			or (this.name="Flowering ~Original Ver.~" and EvaluateSongGroup("V1",0)=0)
			or (this.name="Here in the Moment ~Extended Mix~" and EvaluateSongGroup("BS",0)=0 and EvaluateSongGroup("T1",0)=0)
			or (this.name="Karma ~Original Ver.~" and EvaluateSongGroup("V3",0)=0)
			or (this.name="SON OF SUN ~Extended Mix~" and EvaluateSongGroup("CL",0)=0 and EvaluateSongGroup("BS",0)=0)
				this.order:=-1
		;debugfunc(this.name, this.order, songgroup)
		this.fourk	:= {}
		this.fivek	:= {}
		this.sixk	:= {}
		this.eightk:= {}
		for f in ["nm","hd","mx","sc"]
		{
			this.fourk.%f% := fourkdata[A_Index]
			this.fivek.%f% := fivekdata[A_Index]
			this.sixk.%f% := sixkdata[A_Index]
			this.eightk.%f% := eightkdata[A_Index]
		}
		this.sg := songgroup
		;Msgbox(this.name " " esg ":" esg>>1)
		if esg>>1=3
			this.sg := "PLI"
		if esg>>1=2
			this.sg := "CV"
		if esg>>1=1		
			this.sg := "CM"
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

;creates object for statistics. Inside are ★/pattern difficulties and a sum for each.
class chartsstat
{
	__New()
	{
		this.4k	:= {}
		this.5k	:= {}
		this.6k	:= {}
		this.8k	:= {}
		this.ak:= {}
		
		for md in [4,5,6,8,"a"]
			for df in ["NM", "HD", "MX", "SC"]
			{
				this.%md%k.%df% := {}
				this.%md%k.%df%.sum := 0
				loop 15
					this.%md%k.%df%.lv%A_Index% := "-"
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

ExcludeChart(songid, kmod, songd)
{
	excludebox.value := 1
	pressedagain:=0
	loop 3
	{
		if KeyWait("F4", "D T1")
		{
			pressedagain++
			sleep 500
		}
		Send_WM_Copydata(";;" . kmod . "k;;;" . 3-A_Index, globwparam)
		if pressedagain>1 or excludebox.value=0
		{
			Send_WM_Copydata(";;" . kmod . "k;;;✗", globwparam)
			excludebox.value := 0
			Return
		}
	}
	kshift:=((kmod-0x4)*0x4<0xC ? (kmod-0x4)*0x4 : 0xC)
	Switch songd
	{
		Case "NM":
			dshift:=0x0
		Case "HD":
			dshift:=0x1
		Case "MX":
			dshift:=0x2
		Case "SC":
			dshift:=0x3
	}
	excludedb.Set(songid, (excludedb.Has(songid)?excludedb.Get(songid):0x0) + ((0x1<<dshift) << kshift))
	excludebox.enabled := 0
	if globwparam
		Send_WM_Copydata(";;;;;✓", globwparam)
}
 
RetrieveChartFromExcludeDb(songid, kmod, songd)
{
	global excludedb
	kshift:=((kmod-0x4)*0x4<0xC ? (kmod-0x4)*0x4 : 0xC)
	Switch songd
	{
		Case "NM":
			dshift:=0x0
		Case "HD":
			dshift:=0x1
		Case "MX":
			dshift:=0x2
		Case "SC":
			dshift:=0x3
	}
	Return !(((excludedb.Has(songid)?excludedb.Get(songid):0x0)>>kshift & 0xF)>>dshift & 0x1)
}

;Helper function to get value in dlcpack/songpack Array from songgroup String
;DLC=0 means it only returns if the given songpack is enabled/disabled
;DLC=1 means it returns if the given songpack is enabled/disabled and if it is maindlc/cm/cv
;Return 1 reserved for basic packs (always enabled)
;Return 0/1 Main DLC packs (off/on)
;Return 2/3 Collab Music packs (off/on)
;Return 4/5 Collab Variety packs (off/on)
;Return 6/7 PLI - Playlist packs (off/on)
EvaluateSongGroup(sg, dlc:=1)
{
	Switch sg
	{
		Case "RE":
			val:=1
		Case "RV":
			val:=2
		Case "P1":
			val:=3
		Case "P2":
			val:=4
		Case "P3":
			val:=5
		Case "TR":
			val:=6
		Case "CL":
			val:=7
		Case "BS":
			val:=8
		Case "V1":
			val:=9
		Case "V2":
			val:=10
		Case "V3":
			val:=11
		Case "V4":
			val:=12
		Case "V5":
			val:=13
		Case "VL":
			val:=14
		Case "VL2":
			val:=15
		Case "ES":	
			val:=16
		Case "T1":
			val:=17
		Case "T2":
			val:=18
		Case "T3":
			val:=19
		Case "TQ":
			val:=20
		Case "CH":
			val:=21
		Case "CY":
			val:=22
		Case "DE":
			val:=23
		Case "EZ":	
			val:=24
		Case "GC":
			val:=25
		Case "MD":
			val:=26
		Case "GG":
			val:=27
		Case "BA":
			val:=28
		Case "ET":
			val:=29
		Case "FA":
			val:=30
		Case "GF":
			val:=31
		Case "MA":
			val:=32
		Case "NE":
			val:=33				
		Case "TK":
			val:=34	
		Case "PL1":
			val:=35
		Default:
			MsgBox("Invalid Songgroup! Data corrupted? sg: " . sg)
			ExitApp
	}
	if dlc=1
	{
		;// RE,RV,P1,P2
		if val<=4
			Return 1
		Return dlcpacks[val-4].value + (val>varietydlccount+4?6:(val>musicdlccount+4?4:(val>maindlccount+4?2:0)))
	}
	else 
		Return songpacks[(val>varietydlccount+4?songpacks.length:(val>musicdlccount+4?songpacks.length-1:(val>maindlccount+4?songpacks.length-2:val)))].value
}

; Helper Function to initialize arrays
FillArr(count, data:=1)
{
	arr:=[]
	while A_index<=count
		arr.push(data)
	Return arr
}

; Prints order of internal db songs. Useful to debug sorting function
DebugFunc(name, order, songpack)
{
	static orderstr:=""
	if orderstr!="" and order=1
	{
		FileAppend(orderstr, "InternalDB.db","UTF-8")
		;MsgBox(orderstr " : " order " : " name)
		orderstr:=""	
	}
	;Makes harder to compare versions:
	;orderstr := orderstr . name . "," . order . "," . songpack . "`n"
	orderstr := orderstr . name "," songpack "`n"
	; order here is max number of Z songs
	if order=5 and substr(name,1,1)="Z"
	{
		FileAppend(orderstr, "InternalDB.db","UTF-8")
		;MsgBox(orderstr)
		ExitApp(0)
	}		
}

; Extends default sorting function since DJMax has a weird song sorting scheme 
	; Problematic songs:
	; Urban Night 2x
	; A lie <-> A lie ~deep inside mix~
	; I've got a feeling has now 1370 Unicode
	; We're gonna die <-> welcome to the space
	; U-nivus
FunctionSort(first,last,*)
{
	; All song conditions must be here twice. Once for charf and for charl.
	;panic:=strsplit(first,";")
	;if substr(first,1,4)="Love" and substr(panic[1],-5)="Panic"
	;	Msgbox(first "`n" strlen(panic[1]) "`n" ord(substr(panic[1],5,1)))
	;dbg:=0
	;chr(32) space, chr(45) -, chr(58) :, chr(59) ;, chr(39) ', chr(700) ʼ, chr(126) ~
	first := strupper(first), last:=strupper(last)
	
	; Needed for Misty E'ra vs O'men
	firstsp:=StrSplit(first,";",,3)
	lastsp:=StrSplit(last,";",,3)

; ULTRA FAIL	
	;fixing Alone against Alone
	if (substr(first,1,5)="ALONE" and substr(last,1,5)="ALONE")
		or (substr(first,1,8)="SHOWDOWN" and substr(last,1,8)="SHOWDOWN")
		Return -1

			

	loop parse first
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1))  
		if substr(last,1,8)="Misty E'" and charf<=82 and charl=39   ;  fixing "Misty E[r]'a" against "Misty E[']ra 'MUI'"
			Return -1
	
		; moves first pos down
		if ((charf!=59 and charl=59)
		;or (charf=32 and charl=700)
		or (charf=45 and charl=68)	; Fixes Para[d]ise against Para[-]Q
		or (charf=45 and charl=46) ; Partial U-Nivus fix
		or (charf=50 and charl=126) 	; Fix for SuperSonic [~] Mr against SuperSonic [2]011
		or (charf=39 and charl!=39 and ord(substr(first,A_Index+1,1))>charl) ; Trying to ignore ' char and instead compare next char
		or (charf!=32 and charl=700) ;fix I've got a feeling
		or ((charf=76 or charf=82) and charl=9734)) ; fixes Love☆Panic
		{
			;if substr(first,1,18)="IʼVE GOT A FEELING" or substr(last,1,18)="IʼVE GOT A FEELING"
			;	Msgbox(charf ":" charl "`n" first "`n" last "`n" 1)
			Return 1
		}

		;moves first position up
		if ((charf=59 and charl!=59)
		or (charl=45 and ord(substr(last,A_Index+1,1))>=charf) ; Fix for U-nivus
		or (charl=50 and charf=126) ; Fix for SuperSonic [~] Mr against SuperSonic [2]011
		or (charl=39 and charf!=39 and (ord(substr(last,A_Index+1,1))>charf and charf!=79))		; Trying to ignore ' char and instead compare next char, exception O for Hell'o	
		or (charf=700) ; fix part 2, yes that's right 
		or (charf=9734) and (charl=76 or charl=82)) ; fixes Love☆Panic
		{
			;if substr(first,1,18)="IʼVE GOT A FEELING" or substr(last,1,18)="IʼVE GOT A FEELING"
			;	Msgbox(charf ":" charl "`n" first "`n" last "`n" "-1")
			Return -1
		}
			
		; Default sort
		if charf!=charl
		{
			;if (substr(first,1,18)="IʼVE GOT A FEELING" or substr(last,1,18)="IʼVE GOT A FEELING") and charf=charl
			;	Msgbox(charf ":" charl "`n" first "`n" last "`n" 0)
			Return 0
		}
		;{
		;	if substr(first,1,5)="Hell'" or substr(last,1,5)="Hell'"
		;		Msgbox(first "`n" last "`nUp. because " charf ":" charl " or " ord(substr(first,A_Index+1,1)) ":" ord(substr(last,A_Index+1,1)) )
		;	Return -1
		;}	
	}
}

; If Songtable is empty it will generate it
GenerateSongTable()
{
	global songsdbmem:=[], charts := chartsstat(), chartsmiss := chartsstat()
	static SongsDB := sort(sort(FileRead("SongList.db","UTF-8")),,FunctionSort)
	;static SongsDB := sort(FileRead("SongList.db","UTF-8"))
	static firstrun:=1
	loop parse SongsDB, "`n"
	{
		if firstrun
			songid := CreateID(A_Loopfield,1)
		else 
			songid := CreateID(A_Loopfield)
		;if firstrun
		;	FileAppend(songid . ";" . A_Loopfield . "`n","SongIds.db")
		song_data := strsplit(A_Loopfield, ";")
		if song_data.length=0
			break
		sd_index:=3
		for k in [4,5,6,8]
			for d in ["NM","HD","MX","SC"]
			{
				if !RetrieveChartFromExcludeDb(songid,k,d)
				{
					if song_data[sd_index]>0
					{
						if chartsmiss.%k%k.%d%.lv%song_data[sd_index]%="-"
							chartsmiss.%k%k.%d%.lv%song_data[sd_index]%:=0
						chartsmiss.%k%k.%d%.lv%song_data[sd_index]%++
						chartsmiss.%k%k.%d%.sum++
						if chartsmiss.ak.%d%.lv%song_data[sd_index]%="-"
							chartsmiss.ak.%d%.lv%song_data[sd_index]%:=0
						chartsmiss.ak.%d%.lv%song_data[sd_index]%++
						chartsmiss.ak.%d%.sum++
					}
					song_data[sd_index]:=-1
				}
				else
					if song_data[sd_index]>0
					{
						if charts.%k%k.%d%.lv%song_data[sd_index]%="-"
							charts.%k%k.%d%.lv%song_data[sd_index]%:=0
						charts.%k%k.%d%.lv%song_data[sd_index]%++
						charts.%k%k.%d%.sum++
						if charts.ak.%d%.lv%song_data[sd_index]%="-"
							charts.ak.%d%.lv%song_data[sd_index]%:=0
						charts.ak.%d%.lv%song_data[sd_index]%++
						charts.ak.%d%.sum++
					}
				sd_index++
			}
		
		songsdbmem.push(Generate_Chart_Data(song_data[1],song_data[2], [song_data[3],song_data[4],song_data[5],song_data[6]], [song_data[7],song_data[8],song_data[9],song_data[10]], [song_data[11],song_data[12],song_data[13],song_data[14]], [song_data[15],song_data[16],song_data[17],song_data[18]], songid, A_Index))
	}
	firstrun:=0
}

;Called when Edit menu is closed. Enables/Disables checkboxes
ModifySettings(*)
{
	skip:=0
	;dlc is the value of the checkbox in submenu
	for dlc in dlcpacks
	{
		;checks for maindlc, cm and cv. If more songpacks get added, the checkbox is not properly grayed out. Fix it here!
		;currently there are 6 songpacks for cm, so A_Index<=maindlccount+6 is the check for it
		element := (A_Index<=maindlccount ? A_Index+4 : (A_Index<=musicdlccount ? songpacks.length-2: (A_Index<=varietydlccount ? songpacks.length-1:songpacks.length)))
		;
		
		if skip=1 and element<=musicdlccount
			continue
		;if dlc.value=1
		;	Msgbox(dlc.value "," dlc.text "," element )
		;
		if dlc.value=0
		{
			songpacks[element].value:=0
			songpacks[element].enabled:=0
		}
		else
		{
		;Msgbox("Else: " element "," songpacks.length ", sp_old" songpacks[element].value)
			songpacks[element].value:=1
			songpacks[element].enabled:=1
			;fix for PLI
			if element=songpacks.length
				break
			;fix for CV
			if element=songpacks.length-1 and element<=varietydlccount
			{
				skip:=1 
				continue
			}
			;fix for CM
			if element=songpacks.length-2 and element<=musicdlccount
			{
				skip:=1 
				continue
			}
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
	if settings[10]!=ArrToStr(dlcpacks,maindlccount+1,musicdlccount)
		iniwrite(ArrToStr(dlcpacks,maindlccount+1,musicdlccount),"DJMaxRandomizer.ini", "dlc_owned", "collmus")
	if settings[11]!=ArrToStr(dlcpacks,musicdlccount+1,varietydlccount)
		iniwrite(ArrToStr(dlcpacks,musicdlccount+1,varietydlccount),"DJMaxRandomizer.ini", "dlc_owned", "collvar")
	if settings[12]!=ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length)
		iniwrite(ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length),"DJMaxRandomizer.ini", "dlc_owned", "plipak")
	filedb:=fileopen("DJMaxExcludeCharts.db","w")
	global excludedb, songsdbmem
	validid:=Map()
	;Sorry for beeing shit. This is temporary until I have a better solution.
	for song in songsdbmem
		validid.Set(song.id,1)
	skip:=0
	for id, data in excludedb
	{	
		if validid.Has(id)
		{
			filedb.pos:=16*(A_Index-1-skip)
			filedb.write(id . ";" . Format("0x{:04x}", data) . "`n")
		}
		else
			skip++
	}
	filedb.close()
	if globwparam
		Close_Connection(globwparam)
	ExitApp
}

;Sets difficulty boundaries and disables checkboxes according to slider value
;Min/MaxArray are dynamically adjusted values for min/max difficulty on each mode depending on selected song pack: 
SetMinMaxBoundaries()
{	
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

ToggleMainDLCSongPacks(*)
{
	;Msgbox(songpacktoggle.value)
	;Msgbox(dlcpacks.length)
	for packs in dlcpacks
	{
		;Msgbox(packs.value "," maindlccount)
		if packs.enabled=1
		{ 
			if A_index>maindlccount
				break
			if dlcpacktoggle.value=1
				packs.value:=1
			else
				packs.value:=0
		}
	}
	Checkfilter()
}

ToggleCollSongPacks(*)
{
	for packs in dlcpacks
	{
		if A_Index<=maindlccount
			continue
		
		if packs.enabled=1
			if collabpacktoggle.value=1
				packs.value:=1
			else
				packs.value:=0
	}
	Checkfilter()
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
		;Safety if all fails
		if A_Index>9999999
		{
			statusbar.SetText("We are out of charts! Would you please widen up your settings?:)")
			Return
		}
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
	} until songsdbmem[songnumber:=Random(1,songsdbmem.length)].%kmode%.%songdif%>0 and songsdbmem[songnumber].%kmode%.%songdif%<=maximum and songsdbmem[songnumber].%kmode%.%songdif%>=minimum and CheckSongPack(songsdbmem[songnumber].sg) and songsdbmem[songnumber].order>-1 and RetrieveChartFromExcludeDb(songsdbmem[songnumber].id, kmodnum, songdif)
	guisongname.Text:=songsdbmem[songnumber].Name
	guikmode.Text:=kmodnum . "K"
	guidiff.SetFont("W700 C" . color)
	guidiff.Text:=songdif
	if songdif="SC"
		starcolors:=["DF0074", "C604E3", "3C65FF"]
	else
		starcolors:=["FFFD55", "FF8E55", "FF0000"]
	guistarsy.SetFont("s19 W700 C" . starcolors[1])
	guistarsy.Text:=""
	guistarso.SetFont("s19 W700 C" . starcolors[2])
	guistarso.Text:=""
	guistarsr.SetFont("s19 W700 C" . starcolors[3])
	guistarsr.Text:=""
	while A_Index<=Songsdbmem[songnumber].%kmode%.%songdif%
	{
		if A_Index<=5
			guistarsy.Text:=guistarsy.Text . "★"
		else if A_Index>5 and A_Index<=10
			guistarso.Text:=guistarso.Text . "★"
		else 
			guistarsr.Text:=guistarsr.Text . "★"
	}
	global kmod:=kmodnum, songd:=songdif, songid:=songsdbmem[songnumber].id
	excludebox.enabled := 1
	excludebox.value:= 0
	excludebox.visible := 1
	if globwparam
		try Send_WM_Copydata(Songsdbmem[songnumber].Realsg ";" Songsdbmem[songnumber].Name ";" kmode ";" Songsdbmem[songnumber].%kmode%.%songdif% ";" songdif, globwparam)
	SelectSong(Songsdbmem[songnumber], kmode, songdif)
	CacheSongSelection(Songsdbmem[songnumber], kmode, songdif, 0)
}

CacheSongSelection(song:=0, kmode:=0, songdif:=0, run:=1)
{
	static sg, km, sd
	if song and kmode and songdif
		sg:=song, km:=kmode, sd:=songdif
	if run and sg and km and sd
		SelectSong(sg, km, sd)
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
		SendFunc("z")
		SendFunc("PgDn")
		SendFunc("down", song.order-1)
	}
	else
		SendFunc(strlower(substr(song.name,1,1)), song.order)
	oldletter:=strlower(substr(song.name,1,1))
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

;Returns hash and checks for collision
;mode: 0 - no collision check
CreateID(str, mode:=0)
{
	static collisiontest:=Map()
	crc_hash := Format("{:x}", DllCall("ntdll\RtlComputeCrc32", "UInt",0, "Str", str, "Int", strlen(str), "UInt"))
	if collisiontest.Has(crc_hash) and mode=1
	{
		Msgbox("Collision found!`n" str  "`n" Format("{:08x}", "0x" . crc_hash) "`n`n" collisiontest.Get(crc_hash))
		ExitApp
	}
	collisiontest.Set(crc_hash, str)
	;Msgbox(Format("{:08x}", "0x" . crc_hash) "`n" str)
	Return Format("{:08x}", "0x" . crc_hash)
}

SendFunc(key, repeat:=1){
	while (repeat-->0)
	{
		; Test for better diff accuracy
		If key="right"
			Sleep 2*delaykeyinput.value
		Send "{" . key . " down}"
		Sleep delaykeyinput.value
		Send "{" . key . " up}"
		Sleep delaykeyinput.value
	}
}

Send_WM_Copydata(str, phwnd)
{  
    SizeInBytes := (StrLen(str)+1)*2
	CopyDataStruct := Buffer(3*A_PtrSize)
	NumPut( "Ptr", SizeInBytes, "Ptr", StrPtr(str), CopyDataStruct, A_PtrSize)
	try
		SendMessage(0x004a,0, CopyDataStruct,, "ahk_id" phwnd)
	catch
	{
		if !A_IsAdmin
		{
			Msgbox("Sorry, we need admin rights to connect to StreamDeck AHK API.`nRestarting now.")
			if A_IsCompiled
				Run ('*RunAs "' A_ScriptDir . "\DJMaxRandomizer.exe" '"' " /restart " phwnd)
			else
				Run ('*RunAs "' A_ScriptDir . "\AutoHotkey64.exe" '"' " /restart DJMaxRandomizer.ahk " phwnd)
		}
		global globwparam:=""
	}
}

Receive_Connection_Data(wParam,*)
{
	statusbar.SetText("Connection to StreamDeck established!")
	if globwparam and globwparam!=wParam
	{
		Close_Connection(globwparam)
		statusbar.SetText("Connection to StreamDeck reestablished!")
	}
	global globwparam:=wParam
}

Close_Connection(wParam)
{
	try Send_WM_Copydata(";;;;;Destroy", wParam)
	statusbar.SetText("Connection to StreamDeck closed!")
}
