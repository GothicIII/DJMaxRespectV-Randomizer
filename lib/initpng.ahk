if !Direxist("png")
	DirCreate("png")
if !FileExist("png\rmb.png") or FileGetSize("png\rmb.png")=0
{
	#include pngiconhex.ahk
	writefile:=FileOpen("png\rmb.png","w")
	for pngpart in pngfile
		loop strlen(pngpart)
			if (Mod(A_Index,2))
				writefile.WriteUChar(Format("{:i}", "0x" . SubStr(pngpart, A_Index, 2)))
	writefile.close
	pngfile:=""
}