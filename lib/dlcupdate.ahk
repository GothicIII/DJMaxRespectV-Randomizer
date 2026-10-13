sp:=Map(), spacks:=[
"RE","RV","P1","P2",
"P3","TR","CL","BS","V1","V2","V3","V4","V5","VL","VL2","VL3","VL4","VL5","ES","T1","T2","T3","TQ",
"AR","CH","CY","DE","EZ","GC","MD","ON",
"GG","BA","DF","ET","FA","GF","MA","NE","TK",
"PL1","PL2","PL3","PL4"]
for pack in spacks
	sp.Set(pack,A_Index)

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
	if !sp.Has(sg)
	{
		MsgBox("Invalid Songgroup! Data corrupted? sg: " . sg)
		ExitApp
	}
	val:=sp.Get(sg)
	if dlc=1
	{
		;// RE,RV,P1,P2
		if sp.Get(sg)<=4
			Return 1
		Return dlcpacks[val-4].value + (val>varietydlccount+4?6:(val>musicdlccount+4?4:(val>maindlccount+4?2:0)))
	}
	else 
		Return songpacks[(val>varietydlccount+4?songpacks.length:(val>musicdlccount+4?songpacks.length-1:(val>maindlccount+4?songpacks.length-2:val)))].value
}

; Extends default sorting function since DJMax has a weird song sorting scheme 
FunctionSort(first,last,*)
{
	offset:=0, nodefault:=0
	first:=strupper(first), last:=strupper(last)
	
	;Exceptions
	if substr(first,1,8)="MISTY ER" and substr(last,1,8)="MISTY E'"
		Return [ 32, 32, 99, 1 ]
	
	loop parse first
	{
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index-offset,1))
		
		; skips "'" and "-" when comparing
		if (charf=39 and charl!=39) or (charf=45 and charl!=45)
		{
			offset++
			continue
		}
		if (charl=39 and charf!=39) or (charf!=45 and charl=45)
		{
			offset--
			charl:=charl:=ord(substr(last,A_Index-offset,1))
		}
		
		; Handles ";", "ʼ" and "~"
		if charf=59 or (charf=700 and charl!=32) or (charf=126 and charl=50)
			Return [ charf, charl, offset, -1 ]
		if charl=59 or (charf!=32 and charl=700) or (charf=50 and charl=126)
			Return [ charf, charl, offset, 1 ]	

		;Overwrites chars "Ö" and "☆" for comparison
		if charf=214
			charf:=79, nodefault:=1
		if charl=214
			charl:=79, nodefault:=1
		if charf=9734
			charf:=46, nodefault:=1
		if charl=9734
			charl:=46, nodefault:=1
		if charf!=charl
		{
			if !offset and !nodefault
				Return [ charf, charl, offset, 0 ]
			else
				Return [ charf, charl, offset, (charf-charl<0?-1:1) ]
		}
	}
}

Callback(first, last, *)
{
	ret := FunctionSort(first,last)
	;if (substr(first,1,4)="ALO" and substr(last,1,4)="ALO") and !A_IsCompiled
	;	Msgbox(ret[1] "[" chr(ret[1]) "]:" ret[2] "[" chr(ret[2]) "]`n" (ret[4]?ret[4]=1?"↓":"↑":"") first (ret[4]?ret[4]=1?"↓":"↑":"") "`n" last "`nBack:" ret[3] "`nReturn: " (ret[4]?ret[4]:"default"))
	Return ret[4]
}

; Extends default sorting function since DJMax has a weird song sorting scheme 
/*FunctionSortOld(first,last,*)
{
	; All song conditions SHOULD be here twice. Once for charf and for charl.
	;chr(32) space, chr(45) -, chr(46) ., chr(58) :, chr(59) ;, chr(39) ', chr(700) ʼ, chr(126) ~, chr(214) Ö
	first := strupper(first), last:=strupper(last)
	
	; Needed for Misty E'ra vs O'men
	;firstsp:=StrSplit(first,";",,3)
	;lastsp:=StrSplit(last,";",,3)
	; This lines where inside parse loop
	;if substr(first,1,8)="Misty E'" and substr(last,1,8)="Misty Er" ;  fixing "Misty E[r]'a" against "Misty E[']ra 'MUI'"
	;	Return 1

	;fixing songs with the same name
	if (substr(first,1,5)="ALONE" and substr(last,1,5)="ALONE")
		or (substr(first,1,4)="STOP" and substr(last,1,4)="STOP")
		or (substr(first,1,4)="BURN" and substr(last,1,4)="BURN")
		or (substr(first,1,7)="RIGHT B" and substr(last,1,7)="RIGHT B")
		Return -1
		
	if (substr(first,1,8)="SHOWDOWN" and substr(last,1,8)="SHOWDOWN")
		Return 1
		
	loop parse first
	{
		
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1))
		
		; Test here make later debug var and msgbox in return statements
		;if (substr(first,1,3)="U-N" or substr(last,1,3)="U-N") and charl!=charf
		;		Msgbox(A_Index ":" charf ":" charl "`n" first "`n" last "`n" (charf>charl?"Down":"Up"))
					
		; moves first pos down
		if ((charf!=59 and charl=59)
		or (charl=214 and charf=79 and ord(substr(first,A_Index+1,1))>=83 and ord(substr(first,A_Index+3,1))<=68)
		;or (charf=50 and charl=126) 	; Fix for SuperSonic [~] Mr against SuperSonic [2]011
		or (charf=39 and charl!=39 and ord(substr(first,A_Index+1,1))>charl) ; Trying to ignore ' char and instead compare next char
		or (charf!=32 and charl=700) 	;fix I've got a feeling
		or ((charf=76 or charf=82) and charl=9734)) ; fixes Love☆Panic
			Return 1

		;moves first position up
		if ((charf=59 and charl!=59)
		or (charl=79 and charf=214)
		or (charl=45 and charf=78 and substr(first,1,3)="UND") ; UNDO:U-nivus
		or (charl=50 and charf=126) ; Fix for SuperSonic [~] Mr against SuperSonic [2]011
		or (charl=39 and charf!=39 and (ord(substr(last,A_Index+1,1))>charf and charf!=79))		; Trying to ignore ' char and instead compare next char, exception O for Hell'o	
		or (charf=700) and charl!=32	;I've got a feeling
		or (charf=9734) and (charl=76 or charl=82)) ; fixes Love☆Panic
			Return -1
		
		; Fixes most "-" by comparing next char, above fix is neccessary because iterations of parse don't have the logic to know that "-" was skipped
		if charf=45
			if ord(substr(first,A_Index+1,1))<charl
				Return -1
			else
				Return 1
		if charl=45
			if ord(substr(last,A_Index+1,1))>charf
				Return -1
			else
				Return 1
		; Default sort
		if charf!=charl
			Return 0
	}
}
*/

RetLongSG(sg)
{
	if !sp.Has(sg)
	{
		MsgBox("Invalid Songgroup! sg: " . sg)
		ExitApp
	}
	switch sg
	{
		case "RE":
			Return "Respect"
		case "RV":
			Return "Respect V"
		case "P1":
			Return "Portable 1"
		case "P2":
			Return "Portable 2"
		case "TQ":
			Return "Technica Tune & Q"
		case "DF":
			Return "Dungeon & Fighter"
		Default:
			Return dlcpacks[sp.Get(sg)-4].Text
	}
}