orig_file:=Fileopen("rmb_orig.png", "r")
hexfile:=Fileopen("lib\pngiconhex.ahk", "w")
lastrun:=mod(orig_file.length, 32760)
alldata:=orig_file.length
hexfile.Write("pngfile:=[]`r`n")
while (alldata-=32760)>=0
	Splitfile()
Splitfile(lastrun)
orig_file.Close
hexfile.Close

splitfile(lim:=32760)
{
	static counter:=0
	hexfile.Write("pngfile.push(`"")
	loop lim
		hexfile.Write(Format("{:02X}", orig_file.ReadUChar()))
	hexfile.Write("`")`r`n")
	counter++
}