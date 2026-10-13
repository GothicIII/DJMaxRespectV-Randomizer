; Read settings from ini 
GetSettings()
{
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
	settings.push(iniread("DJMaxRandomizer.ini", "keys", "roll"))
	settings.push(iniread("DJMaxRandomizer.ini", "keys", "reroll"))
	settings.push(iniread("DJMaxRandomizer.ini", "keys", "toggle"))
	settings.push(iniread("DJMaxRandomizer.ini", "keys", "exclude"))
	settings.push(iniread("DJMaxRandomizer.ini", "keys", "passthrough"))
	settings.push(iniread("DJMaxRandomizer.ini","packs_selected", "packs"))
	settings.push(iniread("DJMaxRandomizer.ini","packs_selected", "subpacks"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "main"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "collmus"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "collvar"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "plipak"))
	settings.push(iniread("DJMaxRandomizer.ini", "dlc_owned", "special"))
	mindiff.value:=settings[1]
	maxdiff.value:=settings[2]
	loop parse settings[3]
		kmode[A_Index].value:=A_Loopfield
	loop parse settings[4]
		diffmode[A_Index].value:=A_Loopfield
	global winposx:=settings[5], winposy:=settings[6]
	; fix if no songpacks are enabled
	if settings[17]=0
		settings[17]:=1
	loop parse settings[17]
		songpacks[A_Index].value:=(A_Loopfield=2?-1:A_Loopfield)
	; main dlcpacks
	if settings[19]="0"
		loop maindlccount-1
			settings[19]:=settings[19] . "0"
	loop parse settings[19]
	{
		dlcpacks[A_Index].value:=A_Loopfield
		songpacks[A_Index+4].Enabled:=A_Loopfield
	}
	; dlcmus
	if settings[20]=0
		songpacks[songpacks.length-2].enabled:=0
	loop parse settings[20]
		dlcpacks[A_Index+maindlccount].value:=A_Loopfield
	; dlcvar
	if settings[21]=0
		songpacks[songpacks.length-1].enabled:=0
	loop parse settings[21]
		dlcpacks[A_Index+musicdlccount].value:=A_Loopfield
	; dlcpli	
	if settings[22]=0
		songpacks[songpacks.length].enabled:=0
	loop parse settings[22]
		dlcpacks[A_Index+varietydlccount].value:=A_Loopfield
	; subsongpacks
	loop parse settings[18]
	{
		subsongpacks[A_Index].value:=A_Loopfield
		if !dlcpacks[maindlccount+A_Index].value
			subsongpacks[A_Index].Enabled:=0
	}
	;Special case
	special[6].Value:=settings[23]
}

; Write settings to ini and close StreamDeck connection
SaveAndExit(*)
{
	cnt:=1
	if settings[cnt++]!=mindiff.value
		iniwrite(mindiff.value,"DJMaxRandomizer.ini", "config", "min")
	if settings[cnt++]!=maxdiff.value
		iniwrite(maxdiff.value,"DJMaxRandomizer.ini", "config", "max")
	if settings[cnt++]!=ArrToStr(kmode)	
		iniwrite(ArrToStr(kmode), "DJMaxRandomizer.ini", "config", "kmodes")
	if settings[cnt++]!=ArrToStr(diffmode)	
		iniwrite(ArrToStr(diffmode),"DJMaxRandomizer.ini", "config", "difficulty")
	DJMaxGui.GetClientPos(&x,&y)
	if settings[cnt++]!=x
		iniwrite(x,"DJMaxRandomizer.ini", "config", "winposx")
	if settings[cnt++]!=y
		iniwrite(y,"DJMaxRandomizer.ini", "config", "winposy")
	if settings[cnt++]!=djmaxexcludedben.value	
		iniwrite(djmaxexcludedben.value,"DJMaxRandomizer.ini", "config", "DJMExclude")
	if settings[cnt++]!=delaykeyinput.value
		iniwrite(delaykeyinput.value, "DJMaxRandomizer.ini", "config", "keydelay")
	if settings[cnt++]!=progressioncb.value
		iniwrite(progressioncb.value, "DJMaxRandomizer.ini", "config", "progression")
	if settings[cnt++]!=sortorder.value
		iniwrite(sortorder.value, "DJMaxRandomizer.ini", "config", "Sorting")
	if settings[cnt++]!=sdsupport.value
		iniwrite(sdsupport.value, "DJMaxRandomizer.ini", "config", "sd")	
	if settings[cnt++]!=keyrollmod.Value*100+keyroll.Value
		iniwrite(keyrollmod.Value*100+keyroll.Value, "DJMaxRandomizer.ini", "keys", "roll")	
	if settings[cnt++]!=keyrollmod.Value*100+keyroll.Value
		iniwrite(keyrerollmod.Value*100+keyreroll.Value, "DJMaxRandomizer.ini", "keys", "reroll")		
	if settings[cnt++]!=keytglmod.Value*100+keytgl.Value
		iniwrite(keytglmod.Value*100+keytgl.Value, "DJMaxRandomizer.ini", "keys", "toggle")		
	if settings[cnt++]!=keyexcludemod.Value*100+keyexclude.Value
		iniwrite(keyexcludemod.Value*100+keyexclude.Value, "DJMaxRandomizer.ini", "keys", "exclude")		
	if settings[cnt++]!=passthrough.Value
		iniwrite(passthrough.Value, "DJMaxRandomizer.ini", "keys", "passthrough")			
	if settings[cnt++]!=ArrToStr(songpacks)
		iniwrite(ArrToStr(songpacks),"DJMaxRandomizer.ini", "packs_selected", "packs")
	if settings[cnt++]!=ArrToStr(subsongpacks)
		iniwrite(ArrToStr(subsongpacks),"DJMaxRandomizer.ini", "packs_selected", "subpacks")
	if settings[cnt++]!=ArrToStr(dlcpacks,1,maindlccount)
		iniwrite(ArrToStr(dlcpacks,1,maindlccount),"DJMaxRandomizer.ini", "dlc_owned", "main")
	if settings[cnt++]!=ArrToStr(dlcpacks,maindlccount+1,musicdlccount)
		iniwrite(ArrToStr(dlcpacks,maindlccount+1,musicdlccount),"DJMaxRandomizer.ini", "dlc_owned", "collmus")
	if settings[cnt++]!=ArrToStr(dlcpacks,musicdlccount+1,varietydlccount)
		iniwrite(ArrToStr(dlcpacks,musicdlccount+1,varietydlccount),"DJMaxRandomizer.ini", "dlc_owned", "collvar")
	if settings[cnt++]!=ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length)
		iniwrite(ArrToStr(dlcpacks,varietydlccount+1,dlcpacks.length),"DJMaxRandomizer.ini", "dlc_owned", "plipak")
	if settings[cnt++]!=Special[6].Value
		iniwrite(Special[6].Value,"DJMaxRandomizer.ini", "dlc_owned", "special")
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
			if validid.Has(id)
			{
				filedb.pos:=16*(A_Index-1-skip)
				filedb.write(id . ";" . Format("0x{:04x}", data) . "`n")
			}
			else
				skip++
		filedb.close()
	}
	if globwparam
		Close_Connection(globwparam)
	ExitApp
}

; Settings has to be updated for one position only else multiple changes will be ignored. 
UpdateSettings(position,curset)
{
	loop parse curset
	{
		if position=A_Index
			newsettings .= !A_Loopfield
		else
			newsettings .= A_Loopfield
	}
	;Return newsettings
	;Msgbox(curset "`n" newsettings)
	return newsettings
}