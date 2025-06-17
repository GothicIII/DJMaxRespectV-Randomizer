@echo off
del InternalDB.db
start "" "%~dp0\..\..\AutoHotkey64.exe" "%~dp0\create.ahk"
exit