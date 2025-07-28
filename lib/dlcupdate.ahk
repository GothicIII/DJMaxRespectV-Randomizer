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
		Case "VL3":
			val:=16
		Case "ES":	
			val:=17
		Case "T1":
			val:=18
		Case "T2":
			val:=19
		Case "T3":
			val:=20
		Case "TQ":
			val:=21
		Case "CH":
			val:=22
		Case "CY":
			val:=23
		Case "DE":
			val:=24
		Case "EZ":	
			val:=25
		Case "GC":
			val:=26
		Case "MD":
			val:=27
		Case "GG":
			val:=28
		Case "BA":
			val:=29
		Case "ET":
			val:=30
		Case "FA":
			val:=31
		Case "GF":
			val:=32
		Case "MA":
			val:=33
		Case "NE":
			val:=34				
		Case "TK":
			val:=35	
		Case "PL1":
			val:=36
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
	if substr(last,1,3)="U-N" and Substr(first,1,4)="Unwe"
		Return 1
	
	loop parse first
	{
		
		charf:=ord(A_Loopfield), charl:=ord(substr(last,A_Index,1))   
		if substr(first,1,8)="Misty E'" and substr(last,1,8)="Misty Er" ;  fixing "Misty E[r]'a" against "Misty E[']ra 'MUI'"
			Return 1
		; moves first pos down
		if ((charf!=59 and charl=59)
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
		or (charf=700) and charl!=32 ; fix part 2, yes that's right 
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

RetLongSG(sg)
{
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
		case "P3":
			Return dlcpacks[1].Text
		case "TR":
			Return dlcpacks[2].Text
		case "CL":
			Return dlcpacks[3].Text
		case "BS":
			Return dlcpacks[4].Text
		case "V1":
			Return dlcpacks[5].Text
		case "V2":
			Return dlcpacks[6].Text
		case "V3":
			Return dlcpacks[7].Text
		case "V4":
			Return dlcpacks[8].Text
		case "V5":
			Return dlcpacks[9].Text
		case "VL":
			Return dlcpacks[10].Text
		case "VL2":
			Return dlcpacks[11].Text
		case "VL3":
			Return dlcpacks[12].Text
		case "ES":
			Return dlcpacks[13].Text
		case "T1":
			Return dlcpacks[14].Text
		case "T2":
			Return dlcpacks[15].Text
		case "T3":
			Return dlcpacks[16].Text
		case "TQ":
			Return "Technica Tune & Q"
		case "CH":
			Return dlcpacks[18].Text
		case "CY":
			Return dlcpacks[19].Text
		case "DE":
			Return dlcpacks[20].Text
		case "EZ":
			Return dlcpacks[21].Text
		case "GC":
			Return dlcpacks[22].Text
		case "MD":
			Return dlcpacks[23].Text
		case "GG":
			Return dlcpacks[24].Text
		case "BA":
			Return dlcpacks[25].Text
		case "ET":
			Return dlcpacks[26].Text
		case "FA":
			Return dlcpacks[27].Text
		case "GF":
			Return dlcpacks[28].Text
		case "MA":
			Return dlcpacks[29].Text
		case "NE":
			Return dlcpacks[30].Text
		case "TK":
			Return dlcpacks[31].Text
		case "PL1":
			Return dlcpacks[32].Text
		Default:
			Return sg
	}
}
