#include-once

; # ABOUT THE LIBRARY # =========================================================================================================
; Name .............: _GUIRegisterMsg
; Description ......: The library extends GUIRegisterMsg
;                   : Allows to execute, in the required order, more than one function for known Windows messages
; Current version ..: 1.0.1
; AutoIt Version ...: 3.3.14.5
; Author ...........: Webarion
; Links: ...........: http://webarion.ru, http://f91974ik.bget.ru
; Github: ..........: https://github.com/webarion/_GUIRegisterMsg
; ===============================================================================================================================
; # О БИБЛИОТЕКЕ # ==============================================================================================================
; Название .........: _GUIRegisterMsg
; Описание .........: Библиотека расширяет GUIRegisterMsg
;                   : Даёт возможность выполнить, в необходимом порядке, более одной функции для известных сообщений Windows
; Текущая версия ...: 1.0.1
; AutoIt Версия ....: 3.3.14.5
; Автор ............: Webarion
; Ссылки: ...........: http://webarion.ru, http://f91974ik.bget.ru
; ===============================================================================================================================


; Version history:
;   v1.0.0 - First published version
;   v1.0.1 - Removing unused variables. Correction of comments. Added minified script

; История версий:
;   v1.0.0 - Первая опубликованная версия
;   v1.0.1 - Удаление неиспользуемых переменных. Корректировка комментариев.  Добавлен минимизированный скрипт

; USER FUNCTIONS ==================================================================================================================
;   _GUIRegisterMsg     - Registers functions for known Windows messages. Multiple functions can be registered
;   _GUIUnRegisterMsg   - Releases the function previously associated with the message
;   _Get_GUIRegisterMsg - Use to view the registered functions and the order in which they are performed.
; =================================================================================================================================
; ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ # ======================================================================================================
;   _GUIRegisterMsg     - Регистрирует функцию для известных сообщений Windows. Можно зарегистрировать несколько функций
;   _GUIUnRegisterMsg   - Освобождает ранее связанную с сообщением функцию
;   _Get_GUIRegisterMsg - Используйте для просмотра зарегистрированных функций и порядка их выполнения
; =================================================================================================================================

; _GUIRegisterMsg database, system variable for internal use only
; База данных _GUIRegisterMsg, системная переменная только для внутреннего использования
Global $agDB_GUIRegisterMsg[0][2]


#Region User Functions. Пользовательские функции

; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Регистрация пользовательских функций для известных кодов (ID) сообщений Windows (WM_MSG)
;              : Позволяет выполнить несколько функций для одного сообщения, а также указать порядок выполнения
; Параметры ...: $iMsgID    - Код (ID) сообщения Windows
;                $sFunc     - Имя пользовательской функции, которая вызывается при появлении сообщения
;                $iPriority - Приоритет выполнения указанной функции. Чем меньше это число, тем выше приоритет.
; ===============================================================================================================================
; #USER FUNCTION# ===============================================================================================================
; Description .: Register custom functions for known Windows message IDs (WM_MSG)
;              : Allows you to perform multiple functions for one message, as well as specify the order of execution
; Parameters ..: $iMsgID    - Нет данных (истекло время ожидания отправки данных).
;                $sFunc     - Имя пользовательской функции, которая вызывается при появлении сообщения
;                $iPriority - Приоритет выполнения указанной функции. Чем меньше это число, тем выше приоритет.
; ===============================================================================================================================
Func _GUIRegisterMsg($iMsgID, $sFunc, $iPriority = 0)
	If Not $sFunc Or $sFunc = '__Kernel_Exec_GUIRegisterMsg' Then Return SetError(1, 0, 0)
	Local $aFunc, $iFuncIndex, $iUB, $aTmp[1][2]
	Local $iIndex = __ArrIndCnm_GUIRegisterMsg($agDB_GUIRegisterMsg, $iMsgID)
	$agDB_GUIRegisterMsg[$iIndex][0] = $iMsgID
	$aFunc = $agDB_GUIRegisterMsg[$iIndex][1]
	If Not UBound($aFunc) Then Dim $aFunc[0][2]
	$iFuncIndex = __ArrIndCnm_GUIRegisterMsg($aFunc, $sFunc, 1)
	$aFunc[$iFuncIndex][0] = $iPriority
	$aFunc[$iFuncIndex][1] = $sFunc
	$iUB = UBound($aFunc)
	For $i = 0 To $iUB - 1
		For $j = $i + 1 To $iUB - 1
			If $aFunc[$j][0] < $aFunc[$i][0] Then
				$aTmp[0][0] = $aFunc[$i][0]
				$aTmp[0][1] = $aFunc[$i][1]
				$aFunc[$i][0] = $aFunc[$j][0]
				$aFunc[$i][1] = $aFunc[$j][1]
				$aFunc[$j][0] = $aTmp[0][0]
				$aFunc[$j][1] = $aTmp[0][1]
			EndIf
		Next
	Next
	$agDB_GUIRegisterMsg[$iIndex][1] = $aFunc
	Return GUIRegisterMsg($iMsgID, '__Kernel_Exec_GUIRegisterMsg')
EndFunc   ;==>_GUIRegisterMsg


; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Освобождает ранее связанную с сообщением функцию
; Параметры ...: $iMsgID    - Код (ID) сообщения Windows
;                $sFunc     - Имя пользовательской функции, которую нужно освободить
; Возвращает ..: 1 - если сообщение успешно освобождено от функции
;              : 0 - если сообщение, либо функция ранее не были зарегистрированы, устанавливает @error
;              : @error = 1 - Нет ни одного зарегистрированного сообщения
;              : @error = 2 - Сообщение $iMsgID не было ранее зарегистрировано
;              : @error = 3 - Для сообщения $iMsgID не была ранее зарегистрирована функция $sFunc
; Примечание ..: Данный метод работает только с сообщениями, зарегистрированными через _GUIRegisterMsg
; ===============================================================================================================================
; #USER FUNCTION# ===============================================================================================================
; Description .: Releases the function previously associated with the message
; Parameters ..: $iMsgID    - Windows message ID
;                $sFunc     - The name of the custom function to be released
; Returns .....: 1 - If the message is successfully freed from the function
;              : 0 - If the message or function has not been previously registered, sets @error
;              : @error = 1 - There are no registered posts
;              : @error = 2 - The $ iMsgID message was not previously registered
;              : @error = 3 - $ SFunc has not been previously registered for message $ iMsgID
; Remarks .....: This method only works with messages registered via _GUIRegisterMsg
; ===============================================================================================================================
Func _GUIUnRegisterMsg($iMsgID, $sFunc)
	If Not UBound($agDB_GUIRegisterMsg) Then Return SetError(1, 0, 0)
	Local $iIndex = __ArrIndCnm_GUIRegisterMsg($agDB_GUIRegisterMsg, $iMsgID, 0, False)
	If @error Then Return SetError(2, 0, 0)
	Local $aFunc = $agDB_GUIRegisterMsg[$iIndex][1]
	Local $iFuncIndex = __ArrIndCnm_GUIRegisterMsg($aFunc, $sFunc, 1, False)
	If @error Then Return SetError(3, 0, 0)
	__DelArrInd_GUIRegisterMsg($aFunc, $iFuncIndex)
	If UBound($aFunc) Then
		$agDB_GUIRegisterMsg[$iIndex][1] = $aFunc
	Else
		__DelArrInd_GUIRegisterMsg($agDB_GUIRegisterMsg, $iIndex)
	EndIf
	Return 1
EndFunc   ;==>_GUIUnRegisterMsg


; #ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ# ====================================================================================================
; Описание ....: Возвращает массив сообщений, функций и порядок их вызова, которые зарегистрированы с помощью _GUIRegisterMsg
;              : Используйте для просмотра зарегистрированных функций и порядка их выполнения
; ===============================================================================================================================
; #USER FUNCTION# ===============================================================================================================
; Description .: Returns an array of messages, functions and the order of their invocation, which are registered with _GUIRegisterMsg
;              : Use to view the registered functions and the order in which they are performed
; ===============================================================================================================================
Func _Get_GUIRegisterMsg()
	Local $aRet[0][3], $iUBR = 0
	Local $iUB = UBound($agDB_GUIRegisterMsg), $aFunc
	If Not $iUB Then Return SetError(1, 0, 0)
	For $i = 0 To $iUB - 1
		$aFunc = $agDB_GUIRegisterMsg[$i][1]
		If UBound($aFunc) Then
			For $j = 0 To UBound($aFunc) - 1
				ReDim $aRet[$iUBR + 1][3]
				$aRet[$iUBR][0] = '0x' & Hex($agDB_GUIRegisterMsg[$i][0])
				$aRet[$iUBR][1] = $aFunc[$j][1]
				$aRet[$iUBR][2] = $aFunc[$j][0]
				$iUBR += 1
			Next
		EndIf
	Next
	Return $aRet
EndFunc   ;==>_Get_GUIRegisterMsg

#EndRegion User Functions. Пользовательские функции


#Region Internal Functions. Системные функции

; #СИСТЕМНАЯ ФУНКЦИЯ# ===========================================================================================================
; Описание ....: Возвращает индекс искомого значения в двумерном массиве
;              : если соответствие не найдено, расширяет массив для новой записи и возвращает индекс новой ячейки
; ===============================================================================================================================
; #INTERNAL FUNCTION# ===========================================================================================================
; Description .: Returns the index of the desired value in a two-dimensional array
;              : if no match is found, expands the array for a new record and returns the index of the new cell
; ===============================================================================================================================
Func __ArrIndCnm_GUIRegisterMsg(ByRef $aArray, $sSearch, $iIndex2D = 0, $bExpand = True)
	Local $iUB = UBound($aArray)
	For $i = 0 To $iUB - 1
		If $aArray[$i][$iIndex2D] = $sSearch Then ExitLoop
	Next
	If $i >= $iUB Then
		If $bExpand Then
			ReDim $aArray[$i + 1][2]
			Return $i
		Else
			Return SetError(1, 0, -1)
		EndIf
	EndIf
	Return $i
EndFunc   ;==>__ArrIndCnm_GUIRegisterMsg


; #СИСТЕМНАЯ ФУНКЦИЯ# ===========================================================================================================
; Описание ....: По индексу, удаляет ячейки из двумерного массива
; ===============================================================================================================================
; #INTERNAL FUNCTION# ===========================================================================================================
; Description .: By index, removes cells from a two-dimensional array
; ===============================================================================================================================
Func __DelArrInd_GUIRegisterMsg(ByRef $aArray, $iIndex)
	Local $iUB = UBound($aArray)
	If $iUB Then
		For $i = $iIndex To $iUB - 2
			$aArray[$i][0] = $aArray[$i + 1][0]
			$aArray[$i][1] = $aArray[$i + 1][1]
		Next
		ReDim $aArray[$iUB - 1][2]
	EndIf
	Return $aArray
EndFunc   ;==>__DelArrInd_GUIRegisterMsg


; #СИСТЕМНАЯ ФУНКЦИЯ# ===========================================================================================================
; Описание ....: Ядро выполнения зарегистрированных функций
; ===============================================================================================================================
; #INTERNAL FUNCTION# ===========================================================================================================
; Description .: Kernel for executing registered functions
; ===============================================================================================================================
Func __Kernel_Exec_GUIRegisterMsg($hWnd, $Msg, $wParam, $lParam)
	Local $iUB = UBound($agDB_GUIRegisterMsg), $aFunc
	If $iUB Then
		For $i = 0 To $iUB - 1
			If $agDB_GUIRegisterMsg[$i][0] <> $Msg Then ContinueLoop
			$aFunc = $agDB_GUIRegisterMsg[$i][1]
			If UBound($aFunc) Then
				For $j = 0 To UBound($aFunc) - 1
					Call($aFunc[$j][1], $hWnd, $Msg, $wParam, $lParam)
					If @error = 0xDEAD And @extended = 0xBEEF Then Call($aFunc[$j][1], $hWnd, $Msg, $wParam)
					If @error = 0xDEAD And @extended = 0xBEEF Then Call($aFunc[$j][1], $hWnd, $Msg)
					If @error = 0xDEAD And @extended = 0xBEEF Then Call($aFunc[$j][1], $hWnd)
					If @error = 0xDEAD And @extended = 0xBEEF Then Call($aFunc[$j][1])
					If @error = 0xDEAD And @extended = 0xBEEF Then ConsoleWrite('_GUIRegisterMsg (' & @ScriptLineNumber & ') : ==> Failed to execute function: ' & $aFunc[$j][1] & @CRLF)
				Next
			EndIf
		Next
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>__Kernel_Exec_GUIRegisterMsg

#EndRegion Internal Functions. Системные функции
