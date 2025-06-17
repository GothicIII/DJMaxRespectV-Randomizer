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