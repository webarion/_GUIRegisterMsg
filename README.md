# _GUIRegisterMsg

Note: English translation by Google Translate

## ABOUT THE LIBRARY ##
- **Description:** The library extends GUIRegisterMsg. Allows to execute, in the required order, more than one function for known Windows messages
- **Current version:** 1.0.1
- **AutoIt Version:** 3.3.14.5
- **Author:** Webarion
- **Links:** [Site](http://webarion.ru "Site"), [Mirror](http://f91974ik.bget.ru "Mirror")

### Version history: ###
- v1.0.0 - First published version
- v1.0.1 - Removing unused variables. Correcting comments

### User methods ###
- `_GUIRegisterMsg` - Registers a function for Windows known messages. Multiple functions can be registered
- `_GUIUnRegisterMsg` - Releases the previously associated function from the message
- `_Get_GUIRegisterMsg` - Use to view registered messages, functions and the order of their execution
----------

## О БИБЛИОТЕКЕ ##
 - **Описание:** Библиотека расширяет GUIRegisterMsg. Даёт возможность выполнить, в необходимом порядке, более одной функции для известных сообщений Windows
 - **Текущая версия:** 1.0.1
 - **AutoIt Версия:** 3.3.14.5
 - **Автор:** Webarion
 - **Ссылки:** [Основной сайт](http://webarion.ru "Основной сайт"), [Зеркало](http://f91974ik.bget.ru "Зеркало")
 
### История версий: ###
- v1.0.0 - Первая опубликованная версия
- v1.0.1 - Удаление неиспользуемых переменных. Корректировка комментариев

### Пользовательские методы ###
- `_GUIRegisterMsg` - Регистрирует функцию для известных сообщений Windows. Можно зарегистрировать несколько функций
- `_GUIUnRegisterMsg` - Освобождает ранее связанную функцию от сообщения
- `_Get_GUIRegisterMsg` - Используйте для просмотра зарегистрированных сообщений, функций и порядка их выполнения

### Example. Пример ###

```AutoIt
#include <Array.au3>
#include '_GUIRegisterMsg.au3'

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region GUI
$hForm = GUICreate("_GuiRegisteMsg", 243, 155, -1, -1)
$iMenu = GUICtrlCreateMenu(_Tr('Open this menu', 'Откройте это меню'))
$iMenuItem = GUICtrlCreateMenuItem(_Tr('Menu item', 'Пункт меню'), $iMenu)
$iButton1 = GUICtrlCreateButton(_Tr('Viewing registered functions', 'Просмотр зарегистрированных функций'), 8, 8, 227, 25)
$iButton2 = GUICtrlCreateButton(_Tr('Change the order of execution of functions', 'Изменить порядок выполнения функций'), 8, 39, 227, 25)
$iButton3 = GUICtrlCreateButton(_Tr('Release _Example1', 'Освободить _Example1'), 8, 72, 139, 25)
$iButton4 = GUICtrlCreateButton(_Tr('Release _Example2', 'Освободить _Example2'), 8, 100, 139, 25)
$iButton5 = GUICtrlCreateButton(_Tr('Reset', 'Сброс'), 176, 100, 59, 25)
GUISetState(@SW_SHOW)
#EndRegion GUI

; Registering functions for the $ WM_INITMENUPOPUP message. Регистрация функций для сообщения $WM_INITMENUPOPUP
_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example1', 1)
_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example2', 2)
_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example3', 3)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $iButton1
			_DemoList() ; Show a list of registered functions. Показываем список зарегистрированных функций
		Case $iButton2
			; We set for the message $ WM_INITMENUPOPUP, the order of execution of the function _Example1 after all others
			; Устанавливаем для сообщения $WM_INITMENUPOPUP, порядок выполнения функции _Example1 после всех других
			_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example1', 10)
			_DemoList()
		Case $iButton3
			; Freeing the _Example1 function from the $ WM_INITMENUPOPUP message. Освобождаем функцию _Example1 от сообщения $WM_INITMENUPOPUP
			_GUIUnRegisterMsg($WM_INITMENUPOPUP, '_Example1')
			_DemoList()
		Case $iButton4
			; Freeing the _Example2 function from the $ WM_INITMENUPOPUP message. Освобождаем функцию _Example2 от сообщения $WM_INITMENUPOPUP
			_GUIUnRegisterMsg($WM_INITMENUPOPUP, '_Example2')
			_DemoList()
		Case $iButton5
			; Restoring the registration example to default values. Восстанавливаем пример регистрации, до значений по умолчанию
			_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example1', 1)
			_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example2', 2)
			_GUIRegisterMsg($WM_INITMENUPOPUP, '_Example3', 3)
			_DemoList()
	EndSwitch
	Sleep(10)
WEnd

; To perform functions, open the form menu. Для выполнения функций, откройте меню формы
Func _Example1($hWnd, $Msg, $wParam, $lParam)
	_ExampleMsgBox(1)
EndFunc   ;==>_Example1

Func _Example2($hWnd, $Msg)
	_ExampleMsgBox(2)
EndFunc   ;==>_Example2

Func _Example3()
	_ExampleMsgBox(3)
EndFunc   ;==>_Example3

Func _ExampleMsgBox($i)
	MsgBox(0, '', _Tr('Executed function _Example' & $i & ' for message $ WM_INITMENUPOPUP', 'Выполнена функция _Example' & $i & ' для сообщения $WM_INITMENUPOPUP'))
EndFunc   ;==>_ExampleMsgBox

Func _DemoList()
	_ArrayDisplay( _Get_GUIRegisterMsg(), _Tr('List of registered functions', 'Список зарегистрированных функции'), '', 0, Default, _Tr('Message', 'Сообщение') & '|' & _Tr('Function name', 'Название функции') & '|' & _Tr('Execution order', 'Порядок выполнения'))
EndFunc   ;==>_DemoList

Func _Tr($sEn, $sRu)
	Return Number(@OSLang) = 419 ? $sRu : $sEn
EndFunc   ;==>_Tr
```
