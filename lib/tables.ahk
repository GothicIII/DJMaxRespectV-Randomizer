; Draws and fills the statistics table
Create_Table(chartobj, chartobjo)
{
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
			(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.NM.sum fillhole(strlen(chartobj.NM.sum)-1))).Redraw()
			(DJMaxGuiStat.Add("Text", "x+ yp C00CC00", (chartobj.NM.sum-chartobjo.NM.sum>0?"(+" chartobj.NM.sum-chartobjo.NM.sum ") ":"     "))).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.HD.sum fillhole(strlen(chartobj.HD.sum)-1))).Redraw()
			(DJMaxGuiStat.Add("Text", "x+ yp C00CCCC", (chartobj.HD.sum-chartobjo.HD.sum>0?"(+" chartobj.HD.sum-chartobjo.HD.sum ") ":"     "))).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.MX.sum fillhole(strlen(chartobj.MX.sum)-1))).Redraw()
			(DJMaxGuiStat.Add("Text", "x+ yp CCC8E55", (chartobj.MX.sum-chartobjo.MX.sum>0?"(+" chartobj.MX.sum-chartobjo.MX.sum ") ":"     "))).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20", " | " chartobj.SC.sum fillhole(strlen(chartobj.SC.sum)-1))).Redraw()
			(DJMaxGuiStat.Add("Text", "x+ yp CCC00CC", (chartobj.SC.sum-chartobjo.SC.sum>0?"(+" chartobj.SC.sum-chartobjo.SC.sum ") ":"     "))).Redraw()
		}		
		else
		{
			(DJMaxGuiStat.Add("Text", "xs y+20 C" ChangeColor(chartobj.NM.lv%A_Index-1%, chartobjo.NM.lv%A_Index-1%,"NM"), fillhole(strlen(chartobj.NM.lv%A_Index-1%)) . chartobj.NM.lv%A_Index-1%)).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20 C" ChangeColor(chartobj.HD.lv%A_Index-1%, chartobjo.HD.lv%A_Index-1%,"HD"), fillhole(strlen(chartobj.HD.lv%A_Index-1%)) . chartobj.HD.lv%A_Index-1%)).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20 C" ChangeColor(chartobj.MX.lv%A_Index-1%, chartobjo.MX.lv%A_Index-1%,"MX"), fillhole(strlen(chartobj.MX.lv%A_Index-1%)) . chartobj.MX.lv%A_Index-1%)).Redraw()
			(DJMaxGuiStat.Add("Text", "xs y+20 C" ChangeColor(chartobj.SC.lv%A_Index-1%, chartobjo.SC.lv%A_Index-1%,"SC"), fillhole(strlen(chartobj.SC.lv%A_Index-1%)) . chartobj.SC.lv%A_Index-1%)).Redraw()
		}
	}
}

ChangeColor(vala,valb,ch)
{
	if vala="-"
		vala:=0
	if valb="-"
		valb:=0
	if vala>valb
		Switch(ch)
		{
			Case "NM":
				Return "00CC00"
			Case "HD":
				Return "00CCCC"
			Case "MX":
				Return "CC8E55"
			Case "SC":
				Return "CC00CC"
		}
	if vala<valb
		Return "CC0000"
}

; Determines which table is shown in the statistics subgui
SetFilter(checkbox)
{
	static alreadyrun:=0, lastbox:=checkbox
	CheckFilter(0)
	if checkbox=0
		checkbox:=lastbox
	if ++alreadyrun=1
	{
		for k in ["4k","5k","6k","8k","ak"]
			if checkbox=k
			{
				filter%k%.SetFont("underline")
				DJMaxGuiStat.Add("Text", "section x10 y42 left","Excluded charts").SetFont("underline")
				Create_Table(chartsmiss.%k%, chartsmiss_old.%k%)
				DJMaxGuiStat.Add("Text", "section x10 y+20 left", "Available charts").SetFont("underline")
				Create_Table(charts.%k%, charts_old.%k%)
				lastbox:=checkbox
				continue
			}
			else
				filter%k%.SetFont("")
		alreadyrun:=0
	}
}