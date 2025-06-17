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
	if substr(name,1,1)="Z"
		ExitApp
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