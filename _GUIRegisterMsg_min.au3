#include-once
Global $agDB_GUIRegisterMsg[0][2]
Func _GUIRegisterMsg($3,$5,$2=0)
If Not $5 Or $5='__3_GUIRegisterMsg' Then Return SetError(1,0,0)
Local $6,$1,$8,$7[1][2]
Local $4=__1_GUIRegisterMsg($agDB_GUIRegisterMsg,$3)
$agDB_GUIRegisterMsg[$4][0]=$3
$6=$agDB_GUIRegisterMsg[$4][1]
If Not UBound($6)Then Dim $6[0][2]
$1=__1_GUIRegisterMsg($6,$5,1)
$6[$1][0]=$2
$6[$1][1]=$5
$8=UBound($6)
For $0A=0 To $8-1
For $9=$0A+1 To $8-1
If $6[$9][0]<$6[$0A][0]Then
$7[0][0]=$6[$0A][0]
$7[0][1]=$6[$0A][1]
$6[$0A][0]=$6[$9][0]
$6[$0A][1]=$6[$9][1]
$6[$9][0]=$7[0][0]
$6[$9][1]=$7[0][1]
EndIf
Next
Next
$agDB_GUIRegisterMsg[$4][1]=$6
Return GUIRegisterMsg($3,'__3_GUIRegisterMsg')
EndFunc
Func _GUIUnRegisterMsg($3,$4)
If Not UBound($agDB_GUIRegisterMsg)Then Return SetError(1,0,0)
Local $2=__1_GUIRegisterMsg($agDB_GUIRegisterMsg,$3,0,False)
If @error Then Return SetError(2,0,0)
Local $5=$agDB_GUIRegisterMsg[$2][1]
Local $1=__1_GUIRegisterMsg($5,$4,1,False)
If @error Then Return SetError(3,0,0)
__2_GUIRegisterMsg($5,$1)
If UBound($5)Then
$agDB_GUIRegisterMsg[$2][1]=$5
Else
__2_GUIRegisterMsg($agDB_GUIRegisterMsg,$2)
EndIf
Return 1
EndFunc
Func _Get_GUIRegisterMsg()
Local $2[0][3],$3=0
Local $4=UBound($agDB_GUIRegisterMsg),$1
If Not $4 Then Return SetError(1,0,0)
For $6=0 To $4-1
$1=$agDB_GUIRegisterMsg[$6][1]
If UBound($1)Then
For $5=0 To UBound($1)-1
ReDim $2[$3+1][3]
$2[$3][0]='0x'&Hex($agDB_GUIRegisterMsg[$6][0])
$2[$3][1]=$1[$5][1]
$2[$3][2]=$1[$5][0]
$3+=1
Next
EndIf
Next
Return $2
EndFunc
Func __1_GUIRegisterMsg(ByRef $3,$2,$0=0,$1=True)
Local $4=UBound($3)
For $5=0 To $4-1
If $3[$5][$0]=$2 Then ExitLoop
Next
If $5>=$4 Then
If $1 Then
ReDim $3[$5+1][2]
Return $5
Else
Return SetError(1,0,-1)
EndIf
EndIf
Return $5
EndFunc
Func __2_GUIRegisterMsg(ByRef $1,$0)
Local $2=UBound($1)
If $2 Then
For $3=$0 To $2-2
$1[$3][0]=$1[$3+1][0]
$1[$3][1]=$1[$3+1][1]
Next
ReDim $1[$2-1][2]
EndIf
Return $1
EndFunc
Func __3_GUIRegisterMsg($5,$6,$3,$2)
Local $7=UBound($agDB_GUIRegisterMsg),$4
If $7 Then
For $9=0 To $7-1
If $agDB_GUIRegisterMsg[$9][0]<>$6 Then ContinueLoop
$4=$agDB_GUIRegisterMsg[$9][1]
If UBound($4)Then
For $8=0 To UBound($4)-1
Call($4[$8][1],$5,$6,$3,$2)
If @error=0xDEAD And @extended=0xBEEF Then Call($4[$8][1],$5,$6,$3)
If @error=0xDEAD And @extended=0xBEEF Then Call($4[$8][1],$5,$6)
If @error=0xDEAD And @extended=0xBEEF Then Call($4[$8][1],$5)
If @error=0xDEAD And @extended=0xBEEF Then Call($4[$8][1])
If @error=0xDEAD And @extended=0xBEEF Then ConsoleWrite('_GUIRegisterMsg('&@ScriptLineNumber&'):==>Failed to execute function: '&$4[$8][1]&@CRLF)
Next
EndIf
Next
EndIf
Return $GUI_RUNDEFMSG
EndFunc