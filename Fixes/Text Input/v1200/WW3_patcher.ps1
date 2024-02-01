<# PeekMessageA function wrapper for WW3.exe
The altered function discards passed wMsgFilterMin and wMsgFilterMax parameters and replaces them with WM_KEYFIRST(0x100) and WM_KEYLAST(0x109) respectively

0:  55                      push   ebp
1:  89 e5                   mov    ebp,esp
3:  57                      push   edi
4:  8b 45 18                mov    eax,DWORD PTR [ebp+0x18]
7:  50                      push   eax
8:  68 09 01 00 00          push   0x109
d:  68 00 01 00 00          push   0x100
12: 6a 00                   push   0x0
14: 8b 45 08                mov    eax,DWORD PTR [ebp+0x8]
17: 50                      push   eax
18: 8b 3d 38 73 81 00       mov    edi,DWORD PTR ds:0x817338
1e: ff d7                   call   edi
20: 5f                      pop    edi
21: 5d                      pop    ebp
22: c2 14 00                ret    0x14
#>
function ApplyTextInputFixes([Parameter(Mandatory = $true)] [byte[]]$bytes)
{
	"Injecting PeekMessageA function wrapper..."
	$offset = 0x00416b30
	$bytes[$offset++] = 0x55
	$bytes[$offset++] = 0x89
	$bytes[$offset++] = 0xe5
	$bytes[$offset++] = 0x57
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x18
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x09
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x6a
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x08
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x3d
	$bytes[$offset++] = 0x38
	$bytes[$offset++] = 0x73
	$bytes[$offset++] = 0x81
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0xff
	$bytes[$offset++] = 0xd7
	$bytes[$offset++] = 0x5f
	$bytes[$offset++] = 0x5d
	$bytes[$offset++] = 0xc2
	$bytes[$offset++] = 0x14
	$bytes[$offset] = 0x00
	
	"Injecting PeekMessageA function wrapper pointer..."
	$offset = 0x00416b28
	$bytes[$offset++] = 0x30
	$bytes[$offset++] = 0x6b
	$bytes[$offset++] = 0x81
	$bytes[$offset] = 0x00
	

	"Replacing PeekMessageA function addresses..."
	$offset = 0x003bbcd2
	$bytes[$offset++] = 0x28
	$bytes[$offset++] = 0x6b
	$bytes[$offset++] = 0x81
	$bytes[$offset] = 0x00
}

"============================================"
"Patching WW3.exe"
"============================================"
$hash = Get-FileHash WW3.exe -Algorithm MD5
if ($hash.Hash -ne '317B26703ED1D4BCED937F2CAED6C06C')
{
	'Invalid exe version'
	Read-Host -Prompt "Press ENTER to exit"
	throw 'Invalid exe version'
}
[byte[]]$bytes = Get-Content WW3.exe -Encoding Byte -Raw
ApplyTextInputFixes  -bytes $bytes
,$bytes |Set-Content WW3.exe -Encoding Byte
"All patched!"
Read-Host -Prompt "Press ENTER to exit"
