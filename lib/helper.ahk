;Helper func to convert arr to writeable string
; - added negative number detection since each char is read in.
;	Have to do it here since skipping the loop parse of the ini-string will change
;	A_Index which is needed to determine the correct array in songpacks[]
 	
ArrToStr(arr,min:=1,max:=0)
{	
	str:=""
	for ch in arr
	{
		if A_Index<min or A_Index>(max=0 ? arr.length : max)
			continue
		if ch.value="-1"
		{
			str .= 2
			continue
		}
		str .= ch.value
	}
	return str
}

; Prints order of internal db songs. Useful to debug sorting function
; Please make sure that all available songpacks are selected!
DebugFunc(cnt, name, order, songpack)
{
	static orderstr:="", debugcnt:=1
	if debugcnt=cnt
	{
		;Msgbox(this.name "," this.order "," songgroup)
		if orderstr!="" and order=1
		{
			FileAppend(orderstr, "InternalDB.db","UTF-8")
			;MsgBox(orderstr)
			orderstr:=""
		}	
		;Makes harder to compare versions:
		;orderstr := orderstr . name . "," . order . "," . songpack . "`n"
		orderstr .= name "," songpack "`n"
		debugcnt++
	}

	if debugcnt>2 and cnt=1
	{
		FileAppend(orderstr, "InternalDB.db","UTF-8")
		;MsgBox(orderstr)
		debugcnt:=0
	}
}

; Helper Function to initialize arrays
FillArr(count, data:=1)
{
	arr:=[]
	while A_index<=count
		arr.push(data)
	Return arr
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
