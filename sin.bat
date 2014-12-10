::============================================================
:: Script:		  SINstaller
:: Purpose:       Silent INstaller for common applications
:: Version:       3.1.1
::============================================================
SETLOCAL
:::::::::::::::===============================================
:: CONFIGURE 
::
::
::Variables
::
set SCRIPT_VERSION=3.1.1
set scriptdate=12/10/2014
set LOGPATH=%SystemDrive%\SIN_Logs
set LOGFILE=SIN.log
:: App versions
set libver=4.3.4
set ffver=34.0.5
set flashver=16.0.0.235
set readerver=11.0.10
set airver=15.0.0.356
set notepadver=6.6.9
set chromever=39.0.2171.0m
set silverver=5.1.30514.0
set vlcver=2.1.5
set zipver=9.35
set javaver=8u25
:: App setup files
set librebin=libreoffice.msi
set ffbin=firefox34.0.5.exe
set flashffbin=flash15ffch.msi
set flashiebin=flash15ie.msi
set readerbin=AdbeRdr11010.exe
set airbin=AdobeAIRInstaller.exe
set notepadbin=notepadplusplus.exe
:: x86 setup files
set chrome86bin=chromex86.msi
set silver86bin=silverlightx86.exe
set vlc86bin=vlcx86.exe
set zip86bin=7zipx86.msi
set java86bin=jre-8u25-x86.msi
:: x64 setup files
set chrome64bin=chromex64.msi
set silver64bin=silverlightx64.exe
set vlc64bin=vlcx64.exe
set zip64bin=7zipx64.msi
set java64bin=jre-8u25-x64.msi
:: Flags
set libreflag=/passive /norestart
set ffflag=-ms
set flashflag=ALLUSERS=1 /q /norestart
set readerflag=/sAll /rs /msi /qb- /norestart EULA_ACCEPT=YES
set airflag=-silent -eulaAccepted
set notepadflag=/S
set chromeflag=/q /I
set silverflag=/q
set vlcflag=/L=1033 /S
set zipflag=/q /norestart
set javaflag=ALLUSERS=1 /qn /norestart /l JU=0 JAVAUPDATE=0 AUTOUPDATECHECK=0 RebootYesNo=No WEB_JAVA_SECURITY_LEVEL=M
::
::=========================================================================================
::                             Don't edit below this line!
::=========================================================================================
::
::
:: Misc - credit to /u/vocatus
::
:: Get in the correct drive (~d0). This is sometimes needed when running from a thumb drive
%~d0 2>NUL
:: Get in the correct path (~dp0). This is useful if we start from a network share. This converts CWD to a drive letter
pushd %~dp0 2>NUL
:: Force WMIC location in case the system PATH is messed up
set WMIC=%WINDIR%\system32\wbem\wmic.exe
:: Detect the version of Windows we're on.
set WIN_VER=undetected
for /f "tokens=3*" %%i IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| Find "ProductName"') DO set WIN_VER=%%i %%j
:: Get the date into ISO 8601 standard date format (yyyy-mm-dd) so we can use it 
FOR /f %%a in ('WMIC OS GET LocalDateTime ^| find "."') DO set DTS=%%a
set CUR_DATE=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%
if not exist %LOGPATH% mkdir %LOGPATH%
if not exist %LOGPATH%\%LOGFILE% echo. > %LOGPATH%\%LOGFILE%
::
:: END CONFIGURE 
:::::::::::::::::::============================================
::
:::::::::::::::::::============================================
:: SCRIPT START 
::
:no
@echo off && cls && echo. && echo  Loading...
color 1f
title SINstaller v%SCRIPT_VERSION% [main]
cls
echo  ********************  SINstaller v%SCRIPT_VERSION%  ********************
echo  *                                                           *
echo  * Script to slient-install the following:  7zip, Adobe Air, *
echo  * Adobe Reader, Adobe Flash, Google Chrome, Firefox,        *
echo  * LibreOffice, NotePadPlusPlus, Microsoft Silverlight,      *
echo  * Java, and VLC Media Player.                               *
echo  *                                                           *
echo  *===========================================================*
echo  *                                                           *
echo  * USAGE: y to run script.  v to see version list.           *
echo  *                                                           *
echo  * Logfile will be saved to: %SystemDrive%\SIN_Logs                     *
echo  *                                                           *
echo  *************************************************************
echo.
echo   MACHINE INFO:                                             				  
echo   ---Windows Version:       %WIN_VER%
echo   ---Architecture:          %PROCESSOR_ARCHITECTURE%
echo   ---CPU ID:                %PROCESSOR_IDENTIFIER%
echo.
set /p answer=Continue [y/n/v]?
if /i {%answer%}=={y} (goto :yes)
if /i {%answer%}=={n} (goto :no)
if /i (%answer%}=={v} (goto :verlist)
:verlist
color 1f
title SINstaller v%SCRIPT_VERSION% [version list]
cls
echo  ***  SINstaller - Version List  ***
echo.
echo        LibreOffice:   %libver%
echo            Firefox:   %ffver%
echo        Adobe Flash:   %flashver%
echo       Adobe Reader:   %readerver%
echo          Adobe Air:   %airver%
echo          NotePad++:   %notepadver%
echo      Google Chrome:   %chromever%
echo     MS Silverlight:   %silverver%
echo   VLC Media Player:   %vlcver%
echo              7-zip:   %zipver%
echo               Java:   %javaver%
echo.
echo         SIN Script:   %SCRIPT_VERSION%
echo       Last updated:   %scriptdate%
echo.
echo  *=================================*
echo  * Press any key to return to main *
echo  *=================================*
echo.
pause
goto no
:yes
:::::::::::::::::::============================================
:: LOG HEADER
::
cls
color 1f
title SINstaller v%SCRIPT_VERSION% [app installation]
echo ------------------------------------------------------------------------------->> %LOGPATH%\%LOGFILE%
echo -------------------------------------------------------------------------------
echo  %CUR_DATE% %TIME%  SINstaller v%SCRIPT_VERSION%, %PROCESSOR_ARCHITECTURE% architecture detected>> %LOGPATH%\%LOGFILE%
echo  %CUR_DATE% %TIME%  SINstaller v%SCRIPT_VERSION%, %PROCESSOR_ARCHITECTURE% architecture detected
echo                          Executing as %USERDOMAIN%\%USERNAME% on %COMPUTERNAME%>> %LOGPATH%\%LOGFILE%
echo                          Executing as %USERDOMAIN%\%USERNAME% on %COMPUTERNAME%
echo ------------------------------------------------------------------------------->> %LOGPATH%\%LOGFILE%
echo -------------------------------------------------------------------------------
echo                          %PROCESSOR_ARCHITECTURE% detected, using appropriate setup files!>> %LOGPATH%\%LOGFILE%
echo                          %PROCESSOR_ARCHITECTURE% detected, using appropriate setup files!
echo ------------------------------------------------------------------------------->> %LOGPATH%\%LOGFILE%
echo -------------------------------------------------------------------------------
:::::::::::::::::::============================================
:: INSTALLER
::		first we will install apps that aren't architecture-dependant
::
title SIN v%SCRIPT_VERSION% [app installation]
echo %CUR_DATE% %TIME%   Beginning silent installation...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%   Beginning silent installation...
::
:: LibreOffice
::
echo %CUR_DATE% %TIME%    Installing LibreOffice v%libver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing LibreOffice v%libver%...
	"%librebin%" %libreflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Firefox
::
echo %CUR_DATE% %TIME%    Installing Mozilla Firefox v%ffver% ...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Mozilla Firefox v%ffver%...
	"%ffbin%" %ffflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Adobe Flash - Chrome & Firefox
::
echo %CUR_DATE% %TIME%    Installing Adobe Flash for Chrome and Firefox v%flashver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Adobe Flash for Chrome and Firefox v%flashver%...
	"%flashffbin%" %flashflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Adobe Flash - IE
::
echo %CUR_DATE% %TIME%    Installing Flash for Internet Explorer v%flashver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Flash for Internet Explorer v%flashver%...
	"%flashiebin%" %flashflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Adobe Reader
::
echo %CUR_DATE% %TIME%    Installing Adobe Reader v%readerver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Adobe Reader v%readerver%...
	"%readerbin%" %readerflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Adobe Air
::
echo %CUR_DATE% %TIME%    Installing Adobe AIR v%airver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Adobe AIR v%airver%...
	"%airbin%" %airflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Notepad++
::
echo %CUR_DATE% %TIME%    Installing Notepad++ v%notepadver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Notepad++ v%notepadver%...
	"%notepadbin%" %notepadflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Now we will install apps that have x64 and x86 versions
::
if '%PROCESSOR_ARCHITECTURE%'=='x86' (
	goto x86
		) else (
	goto x64
	)
:x86
::
:: Chrome
::
echo %CUR_DATE% %TIME%    Installing Google Chrome v%chromever%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Google Chrome v%chromever%...
	Msiexec %chromeflag% "%chrome86bin%"
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Silverlight
::
echo %CUR_DATE% %TIME%    Installing Microsoft Silverlight v%silverver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Microsoft Silverlight v%silverver%...
	"%silver86bin%" %silverflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: VLC Media Player
::
echo %CUR_DATE% %TIME%    Installing VLC Media Player v%vlcver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing VLC Media Player v%vlcver%...
	"%vlc86bin%" %vlcflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: 7-Zip
::
echo %CUR_DATE% %TIME%    Installing 7zip v%zipver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing 7zip v%zipver%...
	"%zip86bin%" %zipflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Java
::
echo %CUR_DATE% %TIME%    Installing Java v%javaver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Java v%javaver%...
	"%java86bin%" %javaflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
goto remjava
:x64
::
:: Chrome
::
echo %CUR_DATE% %TIME%    Installing Google Chrome v%chromever%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Google Chrome v%chromever%...
	Msiexec %chromeflag% "%chrome64bin%"
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Silverlight
::
echo %CUR_DATE% %TIME%    Installing Microsoft Silverlight v%silverver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Microsoft Silverlight v%silverver%...
	"%silver64bin%" %silverflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: VLC Media Player
::
echo %CUR_DATE% %TIME%    Installing VLC Media Player v%vlcver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing VLC Media Player v%vlcver%...
		"%vlc64bin%" %vlcflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: 7-Zip
::
echo %CUR_DATE% %TIME%    Installing 7zip v%zipver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing 7zip v%zipver%...
	"%zip64bin%" %zipflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Java
::
echo %CUR_DATE% %TIME%    Installing Java v%javaver%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Installing Java v%javaver%...
	"%java64bin%" %javaflag%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
goto remjava
:remjava
::
:: Java - Remove old version - credit to /u/vocatus
::
echo %CUR_DATE% %TIME%    Checking and removing outdated JRE installations...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Checking and removing outdated JRE installations...
:: JRE 7
echo %CUR_DATE% %TIME%    JRE 7...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    JRE 7...
%WMIC% product where "IdentifyingNumber like '{26A24AE4-039D-4CA4-87B4-2F8__170__FF}'" call uninstall /nointeractive >> "%LOGPATH%\%LOGFILE%"
:: JRE 6
echo %CUR_DATE% %TIME%    JRE 6...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    JRE 6...
:: 1st line is for updates 23-xx, after 64-bit runtimes were introduced.
:: 2nd line is for updates 1-22, before Oracle released 64-bit JRE 6 runtimes
%WMIC% product where "IdentifyingNumber like '{26A24AE4-039D-4CA4-87B4-2F8__160__FF}'" call uninstall /nointeractive>> "%LOGPATH%\%LOGFILE%"
%WMIC% product where "IdentifyingNumber like '{3248F0A8-6813-11D6-A77B-00B0D0160__0}'" call uninstall /nointeractive>> "%LOGPATH%\%LOGFILE%"
:: JRE 5
echo %CUR_DATE% %TIME%    JRE 5...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    JRE 5...
%WMIC% product where "IdentifyingNumber like '{3248F0A8-6813-11D6-A77B-00B0D0150__0}'" call uninstall /nointeractive>> "%LOGPATH%\%LOGFILE%"
:: JRE 4
echo %CUR_DATE% %TIME%    JRE 4...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    JRE 4...
%WMIC% product where "IdentifyingNumber like '{7148F0A8-6813-11D6-A77B-00B0D0142__0}'" call uninstall /nointeractive>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: END INSTALLER
:::::::::::::::::::============================================
echo %CUR_DATE% %TIME%   Finishing up...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%   Finishing up...
:: Copy Java log to log folder
echo %CUR_DATE% %TIME%   Copying Java log to %LOGPATH%...>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%   Copying Java log to %LOGPATH%...
xcopy JU=0 %LOGPATH%
echo %CUR_DATE% %TIME%    Done.>> "%LOGPATH%\%LOGFILE%"
echo %CUR_DATE% %TIME%    Done.
::
:: Log footer
::
echo ------------------------------------------------------------------------------->> %LOGPATH%\%LOGFILE%
echo -------------------------------------------------------------------------------
echo  %CUR_DATE% %TIME%  SINstaller v%SCRIPT_VERSION% complete>> %LOGPATH%\%LOGFILE%
echo  %CUR_DATE% %TIME%  SINstaller v%SCRIPT_VERSION% complete
echo                          Executed as %USERDOMAIN%\%USERNAME% on %COMPUTERNAME%>> %LOGPATH%\%LOGFILE%
echo                          Executed as %USERDOMAIN%\%USERNAME% on %COMPUTERNAME%
echo                          Logfile: %LOGPATH%\%LOGFILE%>> %LOGPATH%\%LOGFILE%
echo                          Logfile: %LOGPATH%\%LOGFILE%
echo ------------------------------------------------------------------------------->> %LOGPATH%\%LOGFILE%
echo -------------------------------------------------------------------------------
pause
