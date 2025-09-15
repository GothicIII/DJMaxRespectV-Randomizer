;DJMax Respect V Randomizer
;Provided to you by GothicIII

#include DJMax_Detection.h
#include lib\dlcupdate.ahk
#include lib\helper.ahk
#include lib\tables.ahk
#include lib\streamdeck.ahk
#include lib\initpng.ahk
try 
	if DirExist("Exclude_Archive")
		Filecopy("DJMaxExcludeCharts.db","Exclude_Archive\DJMaxExcludeCharts_" A_YYYY "_" A_MM "_" A_DD "_" A_Hour "_" A_Min ".db",1)
; Variable initialization
#NoTrayIcon
OnMessage(0x5555,Receive_Connection_Data)
Version:="2.5.250915"
songpacks:=[], subsongpacks:=[], kmode:=[], diffmode:=[], stars:=[], dlcpacks:=[], settings:=[], songsdbmem:=[], globwparam:=""
; Create new settings file if it is missing
try 
	if (Iniread("DJMaxRandomizer.ini","config","version")!=Version)
		throw ValueError()
catch 
{
	MsgBox("Generating new config...","Config file missing!",0x40 " T2")
	try FileDelete("DJMaxRandomizer.ini")
	Iniwrite("min=1`nmax=15`nkmodes=1111`ndifficulty=1111`nwinposx=null`nwinposy=null`nDJMExclude=1`nkeydelay=25`nSorting=1`nsd=0`nprogression=0`nversion=" . Version, "DJMaxRandomizer.ini", "config")
	Iniwrite("packs=1111`nsubpacks=0", "DJMaxRandomizer.ini", "packs_selected")
	Iniwrite("main=0`ncollmus=0`ncollvar=0`nplipak=0", "DJMaxRandomizer.ini", "dlc_owned")
}

; Options GUI Initializiation	
(DJMaxGuiSubMenu := Gui("","Options")).OnEvent('Close', (*)=>ToggleGui("Options"))
DJMaxGuiSubMenu.BackColor:=0xF0F0F0
DJMaxGuiSubMenu.SetFont("S12 q5")
tabu:=DJMaxGuiSubMenu.Add("Tab3","+Background 0x100",["DLC","General"])
DJMaxGuiSubMenu.Add("Text", "x20 y45 left","Select the DLCs you bought.`nThis will generate the song table so unplayable songs won't be rolled.")
DJMaxGuiSubMenu.Add("Text", "x20 y+10 w250 left section","Main DLC-Packs").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ x20 w150 section", "Portable 3"))
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
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "V Liberty 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Emotional Sense"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 2"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Technika 3"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp+10", "Technica Tune && Q"))
maindlccount:=dlcpacks.length
DJMaxGuiSubMenu.Add("Text", "x20 y+10 w250 left","Collaboration").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x20 y+ w150 left section","Music Packs:").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x+ yp left","Variety Packs:").SetFont("Underline")
DJMaxGuiSubMenu.Add("Text", "x+50 yp left","PLI Playlist Packs:").SetFont("Underline")
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x20 y+ w150 section", "Chunism"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Cytus"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Deemo"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "EZ2ON"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Groove Coaster"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Muse Dash"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "Arcaea"))
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
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "x+ ys wp", "Tribute #1"))
dlcpacks.push(DJMaxGuiSubMenu.Add("Checkbox", "y+ wp", "65414 Part.1"))
(dlcpacktoggle := DJMaxGuiSubmenu.Add("Checkbox", "x+ ys wp Checked", "All DLC")).OnEvent('Click', ToggleMainDLCSongPacks)
(collabpacktoggle := DJMaxGuiSubmenu.Add("Checkbox", "y+ wp Checked", "All Coll/PLI")).OnEvent('Click', ToggleCollSongPacks)
tabu.UseTab(2) 
DJMaxGuiSubMenu.Add("Text", "x20 y45 left","Randomizer").SetFont("Underline")
(djmaxexcludedben := DJMaxGuiSubMenu.Add("Checkbox", "xp y+ left checked", "Enable usage of DJMaxExcludeCharts.db.")).Value:=iniread("DJMaxRandomizer.ini", "config", "DJMExclude")
djmaxexcludedben.OnEvent('Click', PrepareDJMaxExclude)
(progressioncb:=DJMaxGuiSubMenu.Add("Checkbox", "xp y+ left", "Only allow next difficulty tier to be rolled if previous difficulties are excluded.")).Value:=iniread("DJMaxRandomizer.ini", "config", "progression")
DJMaxGuiSubMenu.Add("Checkbox", "xp y+ left disabled", "Use alternative randomness logic to roll songs")
DJMaxGuiSubMenu.Add("Text", "xp y+10 left","Song selection").SetFont("Underline")
delaykeyinput := DJMaxGuiSubMenu.Add("Slider", "xp y+10 w150 Tooltip Range5-50", iniread("DJMaxRandomizer.ini", "config", "keydelay"))
DJMaxGuiSubMenu.Add("Text", "x+ left","Keydelay in msec. If song selection often stops on the`nwrong song/difficulty set this higher. Lower values will`nincrease song selection speed. Don't deceed 15 msec!")
(sortorder:=DJMaxGuiSubMenu.Add("DropDownList", "x20 y+20 w139 left Disabled",["Title A-Z","Update Newest","Update Oldest"])).Value:=iniread("DJMaxRandomizer.ini", "config", "Sorting")
DJMaxGuiSubMenu.Add("Text", "x+10 left","Select the sorting type. Please match ingame settings.`nEditable at freeplay on the top middle screen.`nDefault: Title A-Z")
DJMaxGuiSubMenu.Add("Text", "x20 y+10 left","Streamdeck").SetFont("Underline")
(sdsupport:=DJMaxGuiSubMenu.Add("Checkbox", "xp y+ left", "Toggle StreamDeck support. Please consult the readme from the github page!")).Value:=iniread("DJMaxRandomizer.ini", "config", "sd")
tabu.UseTab()
DJMaxGuiSubMenu.Add("Link", "x15 y+ left",'Latest version: <a href="https://github.com/GothicIII/DJMaxRespectV-Randomizer/releases">Release page on github</a>').SetFont("s8")
DJMaxGuiSubMenu.Add("Text", "x+260 right", "v" Version).SetFont("s8")
;Main + Context GUI
(DJMaxGui := Gui("","DJMax Respect V Freeplay Randomizer by GothicIII")).OnEvent('Close', SaveAndExit)
DJMaxGui.SetFont("s12 q5")
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
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "VL3"))
songpacks.push(DJMaxGui.Add("Checkbox", "x+ ys wp", "ES"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T1"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T2"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "T3"))
songpacks.push(DJMaxGui.Add("Checkbox", "y+ wp", "TQ"))

;Init CM/DV/PLI-filter-menu
(cmobj:=DJMaxGui.Add("Checkbox", "vSubA x+ ys w50 check3", "CM")).OnEvent('ContextMenu', ToggleGui)
(cvobj:=DJMaxGui.Add("Checkbox", "vSubB y+ wp check3", "CV")).OnEvent('ContextMenu', ToggleGui)
(pliobj:=DJMaxGui.Add("Checkbox", "vSubC y+ wp check3", "PLI")).OnEvent('ContextMenu', ToggleGui)
cmobj.OnEvent('Click', (*)=>ChangeComboBox(2))
cvobj.OnEvent('Click', (*)=>ChangeComboBox(1))
pliobj.OnEvent('Click', (*)=>ChangeComboBox(0))
songpacks.push(cmobj)
songpacks.push(cvobj)
songpacks.push(pliobj)

(DJMaxGuiColl := Gui("","Collaboration Songs")).OnEvent('Close', (*)=>ToggleGui("SubA"))
DJMaxGuiColl.SetFont("s12 q5")
DJMaxGuiColl.Add("Text","left section","Collab.`nMusic").SetFont("Underline")
CreateCheckboxSubSP(musicdlccount-maindlccount, maindlccount)
collabmusic:=subsongpacks.length
DJMaxGuiColl.Add("Text","left ys section","Collab.`nVariation").SetFont("Underline")
CreateCheckboxSubSP(varietydlccount-musicdlccount, musicdlccount)
collabvar:=subsongpacks.length
DJMaxGuiColl.Add("Text","left ys section","Playlist`nPacks").SetFont("Underline")
CreateCheckboxSubSP(dlcpacks.length-varietydlccount, dlcpacks.length-1)
collabpli:=subsongpacks.length
; End FilterMenu
for each in songpacks
		each.OnEvent('Click', (*)=>Checkfilter())
DJMaxGui.Add("Text", "y+ wp hp", "")
(songpacktoggle := DJMaxGui.Add("Checkbox", "y+ wp Checked", "All")).OnEvent('Click', ToggleAllSongPacks)
DJMaxGui.Add("Button", "vOptions section y+ hp", "Options").OnEvent('Click', ToggleGui)
DJMaxGui.Add("Button", "vStats y+ wp hp", "Stats").OnEvent('Click', ToggleGui)
DJMaxGui.Add("Picture", "vSubD y20 xp+32 w52 h39 BackgroundTrans", ".\png\rmb.png").OnEvent('ContextMenu',ToggleGui)
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
(mindiff := DJMaxGui.Add("Slider", "yp x+ w378 Range1-15 ToolTip", 1)).OnEvent('Change', (*)=>UpdateSlider(1,1))
stars.push(DJMaxGui.Add("Text", "xp+1 y+-4 w25 h30 center","★   "))
while A_Index<15
	stars.push(DJMaxGui.Add("Text", "x+ wp hp center","★   "))
DJMaxGui.Add("Text", "x1 y+ w100 right","Max:")
(maxdiff := DJMaxGui.Add("Slider", "yp x+ w378 Left Range1-15 ToolTip section", 15)).OnEvent('Change', (*)=>UpdateSlider(1))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Go!").OnEvent('Click', (*)=>RollSong(songpacks, kmode, diffmode, mindiff, maxdiff))
DJMaxGui.Add("Button", "x20 y+ Default w80 h50", "Save&&Exit").OnEvent('Click', SaveAndExit)
DJMaxGui.Add("Text", "xs+7 ys+50","Song: ")
guisongname	:= DJMaxGui.Add("Text", "x+ ys+52 w378 h30 section"," ")
guisongname.SetFont("S10")
guikmode		:= DJMaxGui.Add("Text", "xp y+ w30"," ")
guidiff 		:= DJMaxGui.Add("Text", "x+ w30"," ")
(excludebox := DJMaxGui.Add("Checkbox", "x+120 left","Exclude Chart? (F4)")).OnEvent('Click', (*)=>ExcludeChart(songid, kmod, songd))
excludebox.Visible:=0, excludebox.Enabled:=0
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
settings.push(iniread("DJMaxRandomizer.ini", "config", "DJMExclude"))
settings.push(iniread("DJMaxRandomizer.ini", "config", "keydelay"))
settings.push(iniread("DJMaxRandomizer.ini", "config", "progression"))
settings.push(iniread("DJMaxRandomizer.ini", "config", "Sorting"))
settings.push(iniread("DJMaxRandomizer.ini", "config", "sd"))
settings.push(iniread("DJMaxRandomizer.ini","packs_selected", "packs"))
settings.push(iniread("DJMaxRandomizer.ini","packs_selected", "subpacks"))
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

progression:=settings[9]
; fix if no songpacks are enabled
if settings[12]=0
	settings[12]:=1
loop parse settings[12]
	songpacks[A_Index].value:=(A_Loopfield=2?-1:A_Loopfield)
; main dlcpacks
if settings[14]="0"
	loop maindlccount-1
		settings[14]:=settings[14] . "0"
loop parse settings[14]
{
	dlcpacks[A_Index].value:=A_Loopfield
	songpacks[A_Index+4].Enabled:=A_Loopfield
}
; dlcmus
if settings[15]=0
	songpacks[songpacks.length-2].enabled:=0
loop parse settings[15]
	dlcpacks[A_Index+maindlccount].value:=A_Loopfield
; dlcvar
if settings[16]=0
	songpacks[songpacks.length-1].enabled:=0
loop parse settings[16]
	dlcpacks[A_Index+musicdlccount].value:=A_Loopfield
; dlcpli	
if settings[17]=0
	songpacks[songpacks.length].enabled:=0
loop parse settings[17]
	dlcpacks[A_Index+varietydlccount].value:=A_Loopfield
; subsongpacks
loop parse settings[13]
{
	subsongpacks[A_Index].value:=A_Loopfield
	if !dlcpacks[maindlccount+A_Index].value
		subsongpacks[A_Index].Enabled:=0
}
if not FileExist("SongList.db")
{
	if (MsgBox("SongList.db not found!`nVisit the github page to download the current one (OK).`nAlternatively you could generate a SongList.db using GetSongData() from DJMaxDetection.h!","Critical error! SongList.db missing!",0x31)="OK")
		run("https://github.com/GothicIII/DJMaxRespectV-Randomizer/blob/main/SongList.db")
	ExitApp
}

; prefill with data.
PrepareDJMaxExclude()

; Draw GUI
UpdateSlider(0)
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

~NumpadAdd::
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
^F2::CacheSongSelection()
F2::try RollSong(songpacks, kmode, diffmode, mindiff, maxdiff)
F4::
{
	if excludebox.Enabled and djmaxexcludedben.Value
	{
		if !ExcludeChart(songid, kmod, songd)
			Statusbar.SetText("Current chart is now excluded and forever gone! :L")
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

; Chart data definition in memory
class Generate_Chart_Data
{
	__New(name, songgroup, fourkdata, fivekdata, sixkdata, eightkdata, songid, newdb:=0)
	{
		global minarray, maxarray
		static alphaarr := fillarr(26,0), numeric:=0, debugcnt:=1
		if newdb=1 
		{
			numeric:=0
			alphaarr:=fillarr(26,0)
			minarray:=fillarr(16,0)
			maxarray:=fillarr(16,16)
		}
		esg:=EvaluateSongGroup(songgroup)
		this.name 	:= name
		this.realsg := RetLongSG(songgroup)
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
		;debugfunc(A_Index, this.name, this.order, songgroup)
		this.4k	:= {}
		this.5k	:= {}
		this.6k	:= {}
		this.8k:= {}
		for d in ["nm","hd","mx","sc"]
		{
			this.4k.%d% := fourkdata[A_Index]
			this.5k.%d% := fivekdata[A_Index]
			this.6k.%d% := sixkdata[A_Index]
			this.8k.%d% := eightkdata[A_Index]
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

CacheSongSelection(song:="", kmode:="", songdif:="", run:=1)
{
	static sg:="", km:="", sd:=""
	if song and kmode and songdif
		sg:=song, km:=kmode, sd:=songdif
	if !sg
		Return
	if globwparam
		try Send_WM_Copydata(sg.Name ";" sg.Realsg ";" km ";" sg.%km%.%sd% ";" sd, globwparam)
	if run
		SelectSong(sg, km, sd)
}

ChangeComboBox(boxno,*)
{
	switch boxno
	{
		case 2:
			cur := lim := collabmusic
		case 1:
			cur := collabvar-collabmusic
			lim := collabvar
		case 0:
			cur := collabpli-collabvar
			lim := collabpli
	}
	if songpacks[songpacks.length-boxno].value<=0
		songpacks[songpacks.length-boxno].value:=0
	else
		songpacks[songpacks.length-boxno].value:=1
	for pack in subsongpacks
	{
		if A_Index<=(lim-cur)
			continue
		if dlcpacks[maindlccount+A_Index].value
			pack.value:=songpacks[songpacks.length-boxno].value
		if A_Index=lim
			break
	}
}

;Safetycheck for Filter settings (kmode, diffmode)
;Updates db in memory if different filtersettings are found.
CheckFilter(update:=1)
{
	global songpacks
	static enabledsongpacks:=0, enabledsubsongpacks:=0
	if update=1
		Statusbar.SetText("")
	if enabledsongpacks!=ArrToStr(songpacks) or enabledsubsongpacks!=ArrToStr(subsongpacks) or excludebox.Value
	{	
		enabledsongpacks:=ArrToStr(songpacks)
		enabledsubsongpacks:=ArrToStr(subsongpacks)
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

; CM/CV/PLI changes checkbox status
CheckboxEnDis(*)
{
	boxcheck:=0, boxenabled:=0
	for pack in subsongpacks
	{
		if pack.value
			boxcheck++
		if pack.Enabled
			boxenabled++
		switch A_Index
		{
			case collabmusic:
				offset := 2
			case collabvar:
				offset := 1
			case collabpli:
				offset := 0
		}
		if (A_Index=collabmusic) or (A_Index=collabvar) or (A_Index=collabpli)
		{	
			curpack:=songpacks.length-offset
			if boxcheck=boxenabled and boxcheck>0
				songpacks[curpack].value:=1
			else if boxcheck=0
				songpacks[curpack].value:=0
			else
				songpacks[curpack].value:=-1
			boxcheck:=0, boxenabled:=0
		}
		else
			continue
	}
	Checkfilter()
}

CheckSongPack(sg, rsg)
{	
	if sg="CM" or sg="CV" or sg="PLI"
	{
		for pack in subsongpacks
			if rsg=pack.text and pack.value=1
				Return 1
		Return 0
	}
	for pack in songpacks
		if sg=pack.text and (pack.value=1 or pack.value=-1)
			Return 1
	Return 0
}

CMVPLIPacksCall(dlccount)
{
	static calls:=dlccount
	calls++
	Return dlcpacks[calls].Text
}

CreateCheckboxSubSP(dlccount, dlcb)
{
	while (dlccount-A_Index)>=0
	{
		subsongpacks.push(curbox:=DJMaxGuiColl.Add("Checkbox", "y+", CMVPLIPacksCall(dlcb)))
		curbox.OnEvent('Click', CheckboxEnDis)
	}
}

;Returns hash and checks for collision
;mode: 0 - no collision check
CreateID(str, mode:=0)
{
	static collisiontest:=Map()
	crc_hash := Format("{:x}", DllCall("ntdll\RtlComputeCrc32", "UInt",0, "Str", str, "Int", strlen(str), "UInt"))
	if collisiontest.Has(crc_hash) and mode=1
	{
		Msgbox("Collision found!`n" str  "`n" Format("{:08x}", "0x" . crc_hash) "`n`n" collisiontest.Get(crc_hash) "`n`nProgram will now exit...","Hash collision detected!", 0x30)
		ExitApp
	}
	collisiontest.Set(crc_hash, str)
	;Msgbox(Format("{:08x}", "0x" . crc_hash) "`n" str)
	Return Format("{:08x}", "0x" . crc_hash)
}

ExcludeChart(songid, kmod, songd)
{
	if !djmaxexcludedben.value
		Return 1
	excludebox.Value := 1
	pressedagain:=0
	loop 3
	{
		if KeyWait("F4", "D T1")
		{
			pressedagain++
			sleep 500
		}
		if globwparam
			Send_WM_Copydata(";;" . kmod . "k;;;" . 3-A_Index, globwparam)
		if pressedagain>1 or !excludebox.Value
		{
			if globwparam
				Send_WM_Copydata(";;" . kmod . "k;;;✗", globwparam)
			excludebox.Value := 0
			Return 1
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
	excludebox.Enabled := 0
	if globwparam
		Send_WM_Copydata(";;;;;✓", globwparam)
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
;dlc.value - if DLC is owned or not (submenu)
;songpacks - every dlc including the first 4 base DLC
;element - songpack categories:
;		<=maindlccount - all main DLC, each has its own checkbox so this value is variable
;		<=musicdlccount - will be fixed songpacks.length-2 for CM
;		<=varietydlccount - will be fixed songpacks.length-1 for CV
;		else songpacks.length - for PLI
;CM/CV/PLI each is combined into one checkbox. So the element for them is fixed.
ModifySettings(*)
{
	boxcheck:=0
	for dlc in dlcpacks
	{
		;checks for maindlc, cm and cv. Songpacks checkboxes not properly grayed out? Fix it here!
		element := (A_Index<=maindlccount ? A_Index+4 : (A_Index<=musicdlccount ? songpacks.length-2: (A_Index<=varietydlccount ? songpacks.length-1:songpacks.length)))
		
		If A_Index<=maindlccount
		{
			songpacks[A_Index+4].value:=dlc.value
			songpacks[A_Index+4].Enabled:=dlc.value
		}
		else
		{
			subsongpacks[A_Index-maindlccount].value:=dlc.value
			subsongpacks[A_Index-maindlccount].Enabled:=dlc.value
			boxcheck+=dlc.value
			
			if (A_Index=musicdlccount) or (A_Index=varietydlccount) or (A_Index=dlcpacks.length)
			{
				if boxcheck=0
				{
					songpacks[element].value:=0
					songpacks[element].Enabled:=0
				}
				else
				{
					songpacks[element].value:=1
					songpacks[element].Enabled:=1
					boxcheck:=0
				}
			}
		}
	}
	Checkfilter()
}

PrepareDJMaxExclude(*)
{
	global excludedb := Map()
	if djmaxexcludedben.value
	{
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
			Msgbox("DJMaxExcludeCharts.db has errors or does not exist!`nA new file will be created.","Errors with DJMaxExcludeCharts.db",0x40 " T2")
			try FileMove("DJMaxExcludeCharts.db", "DJMaxExcludeCharts_" . version . "_bak.db", 1) 
		}
	}
	excludebox.Enabled:=djmaxexcludedben.value
	progressioncb.Enabled:=djmaxexcludedben.value
	GenerateSongTable()
}

RetrieveChartFromExcludeDb(songid, kmod, songd, songn:=0)
{
	global excludedb, songsdbmem
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
	if progressioncb.value and progressioncb.Enabled and songn>0
	{
		for d in ["NM","HD","MX","SC"]
		{
			if d=songd
				break
			if songsdbmem[songn].%kmod%k.%d%=0
				continue
			if !(((excludedb.Has(songid)?excludedb.Get(songid):0x0)>>kshift & 0xF)>>(A_Index-1) & 0x1)
				Return 0
		}
	}
	Return !(((excludedb.Has(songid)?excludedb.Get(songid):0x0)>>kshift & 0xF)>>dshift & 0x1)	
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
	if settings[7]!=djmaxexcludedben.value	
		iniwrite(djmaxexcludedben.value,"DJMaxRandomizer.ini", "config", "DJMExclude")
	if settings[8]!=delaykeyinput.value
		iniwrite(delaykeyinput.value, "DJMaxRandomizer.ini", "config", "keydelay")
	if settings[9]!=progressioncb.value
		iniwrite(progressioncb.value, "DJMaxRandomizer.ini", "config", "progression")
	if settings[10]!=sortorder.value
		iniwrite(sortorder.value, "DJMaxRandomizer.ini", "config", "Sorting")
	if settings[11]!=sdsupport.value
		iniwrite(sdsupport.value, "DJMaxRandomizer.ini", "config", "sd")	
	if settings[12]!=ArrToStr(songpacks)
		iniwrite(ArrToStr(songpacks),"DJMaxRandomizer.ini", "packs_selected", "packs")
	if settings[13]!=ArrToStr(subsongpacks)
		iniwrite(ArrToStr(subsongpacks),"DJMaxRandomizer.ini", "packs_selected", "subpacks")
	if settings[14]!=ArrToStr(dlcpacks,1,maindlccount)
		iniwrite(ArrToStr(dlcpacks,1,maindlccount),"DJMaxRandomizer.ini", "dlc_owned", "main")
	if settings[15]!=ArrToStr(dlcpacks,maindlccount+1,musicdlccount)
		iniwrite(ArrToStr(dlcpacks,maindlccount+1,musicdlccount),"DJMaxRandomizer.ini", "dlc_owned", "collmus")
	if settings[16]!=ArrToStr(dlcpacks,musicdlccount+1,varietydlccount)
		iniwrite(ArrToStr(dlcpacks,musicdlccount+1,varietydlccount),"DJMaxRandomizer.ini", "dlc_owned", "collvar")
	if settings[17]!=ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length)
		iniwrite(ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length),"DJMaxRandomizer.ini", "dlc_owned", "plipak")
	if djmaxexcludedben.Value
	{	
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
	}
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

ToggleAllSongPacks(*)
{
	for packs in songpacks
		if packs.enabled=1
			if songpacktoggle.value=1 
				packs.value:=1
			else 
				packs.value:=0
	ChangeComboBox(2)
	ChangeComboBox(1)
	ChangeComboBox(0)
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

ToggleGui(guiel:="",*)
{
	static shown:=[0,0,0]
	if type(guiel)="Gui.Checkbox" or type(guiel)="Gui.Pic" or type(guiel)="Gui.Button"
		str:=guiel.Name
	else
		str:=guiel
	switch str
	{
		Case "Options":
			el:=1
			guimenu:=DjMaxGuiSubMenu
			command:="ModifySettings"

		Case "Stats":
			el:=2
			guimenu:=DJMaxGuiStat
			command:=""			
		Case "SubA","SubB","SubC","SubD":
			el:=3
			guimenu:=DJMaxGuiColl
			command:=""
		Default:
			Msgbox("Menu: " str " does not exist!","Warning!",0x40)
			Return	
	}
	if shown[el]
	{
		guimenu.Hide
		if command
			%command%()
	}
	else
		guimenu.Show(DJMaxGui.GetClientPos(&x,&y,&w) "x" x+w "y" y-30 )
	shown[el]?shown[el]:=0:shown[el]:=1
}

ToggleMainDLCSongPacks(*)
{
	for packs in dlcpacks
		if packs.enabled=1
		{ 
			if A_index>maindlccount
				break
			if dlcpacktoggle.value=1
				packs.value:=1
			else
				packs.value:=0
		}
	Checkfilter()
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
						kmode:="4k"
					Case 2:
						kmode:="5k"
					Case 3:
						kmode:="6k"
					Case 4:
						kmode:="8k"
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
	} until songsdbmem[songnumber:=Random(1,songsdbmem.length)].%kmode%.%songdif%>0 
		and songsdbmem[songnumber].%kmode%.%songdif%<=maximum
		and songsdbmem[songnumber].%kmode%.%songdif%>=minimum
		and CheckSongPack(songsdbmem[songnumber].sg, songsdbmem[songnumber].realsg)
		and songsdbmem[songnumber].order>-1
		and RetrieveChartFromExcludeDb(songsdbmem[songnumber].id, RTrim(kmode,"k"), songdif, songnumber)
	guisongname.Text:=songsdbmem[songnumber].Name
	guikmode.Text:=StrUpper(kmode)
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
	global kmod:=RTrim(kmode,"k"), songd:=songdif, songid:=songsdbmem[songnumber].id
	if djmaxexcludedben.value
		excludebox.Enabled := 1
	excludebox.Value:= 0
	excludebox.Visible := 1
	SelectSong(Songsdbmem[songnumber], kmode, songdif)
	CacheSongSelection(Songsdbmem[songnumber], kmode, songdif, 0)
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
	SendFunc(RTrim(kmode,"k"))
	;switch kmode
	;{
	;	case "4k":
	;		SendFunc("4")
	;	case "5k":
	;		SendFunc("5")
	;	case "6k":
	;		SendFunc("6")
	;	case "8k":
	;		SendFunc("8")
	;}
	if (songdif="HD" or songdif="MX" or songdif="SC") and (song.%kmode%.hd>0 or song.%kmode%.hd=-1)
		SendFunc("right")
	if (songdif="MX" or songdif="SC") and (song.%kmode%.mx>0 or song.%kmode%.mx=-1)
		SendFunc("right")
	if songdif="SC" and (song.%kmode%.sc>0 or song.%kmode%.sc=-1)
		SendFunc("right")
	statusbar.SetText("Are you Ready? Never give up!")	
}

SendFunc(key, repeat:=1)
{
	while (repeat-->0)
	{
		If key="right"
			Sleep 2*delaykeyinput.value
		Send "{" . key . " down}"
		Sleep delaykeyinput.value
		Send "{" . key . " up}"
		Sleep delaykeyinput.value
	}
}

UpdateSlider(update:=1,slider:=0)
{
	if update
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
	CheckFilter(0)
}
