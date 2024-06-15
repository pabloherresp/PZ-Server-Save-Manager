@echo OFF
SETLOCAL enabledelayedexpansion enableextensions

title Project Zomboid Server Save Handler

REM USER SETUP
REM Name of the server (You can check the .ini inside file in order to know this value. For example, if the file is called "servertest.ini", you should write servertest without quotes here)
set server_name=
REM Location of Zomboid folder. Default location found inside user folder, NOT in Steam folder. Without quotes. %USERPROFILE% is the user folder.
set def_zomboid_loc=%USERPROFILE%\Zomboid
REM Location of zips folder. Default folder is Downloads. Without quotes. %USERPROFILE% is the user folder.
set def_zip_loc=%USERPROFILE%\Downloads
REM URL to open with share link. WITH quotes.
set url=

REM Decide if previous files are saved to Zomboid/backups before extracting a .zip and overwriting previous files. (1 = true. 0 = false.)
set backup_option=1


:start
echo ...................................................................................
echo : Little program to save and load a server from a zip for Project Zomboid hosting :
echo ...................................................................................
echo.
echo You can check the github page to get more information: https://github.com/pabloherresp/PZ-Server-Save-Manager (CTRL + Click to open)

if NOT defined server_name (goto :noname)


:options
echo.
echo  - OPTIONS -
echo . . 1 to SAVE a new zip file
echo . . 2 to LOAD from a existing zip file
echo . . 3 to OPEN zip file folder
echo . . 4 to FIX missing map files for a server
if %url% NEQ "" (echo . . 5 to OPEN url link)
echo . . 0 to CLOSE the program
set /p "id=Choose/Type an option: "

if %id%==1 (
	goto :save
) else (
    if %id%==2 (
		goto :load
    ) else (
        if %id%==3 (
			explorer %def_zip_loc%
			goto :options
		) else (
			if %id%==4 (
				goto :fix_map
			) else (
				if %id%==5 (
					if %url% NEQ null (
						explorer %url%
					) else (echo ERROR: No URL has been defined.)
					goto :options
				) else (
					if %id%==0 (
						goto :end
					) else (
						echo Value %id% is not allowed.
						goto :options
					)
				)
			)
		)
	)
)


:save
echo Creating zip file.
cd "%def_zomboid_loc%"
Call :get_date_time

REM Using of tar command to compress needed files
tar -cf "%def_zip_loc%/!date_time!_PZ_server_%server_name%.zip" db/"%server_name%.db"
tar -uf "%def_zip_loc%/!date_time!_PZ_server_%server_name%.zip" Saves/Multiplayer/"%server_name%" Saves/Multiplayer/"%server_name%_player"
tar -uf "%def_zip_loc%/!date_time!_PZ_server_%server_name%.zip" Server/"%server_name%.ini" Server/"%server_name%_SandboxVars.lua" Server/"%server_name%_spawnregions.lua" 

echo !date_time!_PZ_server_!server_name!.zip has been created at %def_zip_loc% folder
goto :options


:load
set choice[0]=0
set /A count=1

REM Listing zips block
echo Choose the zip file you want to extract.
cd %def_zip_loc%
for %%x in ("*_PZ_server_%server_name%.zip") do (
	echo    !count! - %%x
	set choice[!count!]=%%x
	set /A count=count+1
)
set /p "n=Choose one: "

REM Backup block
if %backup_option%==1 (
	cd %def_zomboid_loc%
	Call :get_date_time
	MKDIR "backups\!date_time!_backup"
	Xcopy db\%server_name%.db backups\!date_time!_backup\db /E /H /C /I /Q
	Xcopy Server\%server_name%* backups\!date_time!_backup\Server /E /H /C /I /Q
	Xcopy Saves\Multiplayer\%server_name% backups\!date_time!_backup\Saves\Multiplayer\%server_name% /E /H /C /I /Q
	Xcopy Saves\Multiplayer\%server_name%_player backups\!date_time!_backup\Saves\Multiplayer\%server_name%_player /E /H /C /I /Q
)
echo Extracting zip file !choice[%n%]!
tar -xf "%def_zip_loc%\!choice[%n%]!"  -C %def_zomboid_loc%

goto :options


:fix_map
echo.
echo You should read properly the FIX MISSING MAP FILES FOR A SERVER section in the github page before using this option.
:fix_choices
echo First, choose the folder whose maps you want to play with.
set choice[0]=0
set /A count=1
cd %def_zomboid_loc%\Saves\Multiplayer\

echo    ID  DATE        TIME                    NAME
for /F "tokens=*" %%x in ('dir /ad ^| find "_player"') do (
	echo    !count! - %%x
	set aux=%%x
	set choice[!count!]=!aux:~36!
	set /A count=count+1
)

set /p "n1=Choose one: "

set /A count=%count%-1
echo Now, choose the target folder whose maps will be overwritten.
for /L %%x in (1,1,!count!) do (
	if %%x NEQ !n1! (
		echo    %%x - !choice[%%x]!
	)
)
set /p "n2=Choose one: "
if %n1%==%n2% (
	echo Both choices are the same. Choose again.
	goto :fix_choices
)
Call :get_date_time
ren !choice[%n2%]!\map_visited.bin map_visited_backup_!date_time!.bin
ren !choice[%n2%]!\map_symbols.bin map_symbols_backup_!date_time!.bin
Xcopy !choice[%n1%]!\map_visited.bin !choice[%n2%]! /E /H /C /I /Q /Y
Xcopy !choice[%n1%]!\map_symbols.bin !choice[%n2%]!  /E /H /C /I /Q /Y

goto :options


:noname
echo.
echo Error: You haven't setup this file before running it.
echo . You need to edit this file with notepad and change the "server_name" variable in the first lines of code.
echo . The needed name for the variable can be found as a .ini file in the default Zomboid location.
set /p "f=. Do you wish to open this folder? (Y for yes, any other input will close the program): "
if %f%==Y (	explorer %def_zomboid_loc%\Server )
if %f%==y ( explorer !def_zomboid_loc!\Server )
goto :end


:end
echo.
echo Closing program.
pause


:get_date_time
REM Function: Name date/time handling against day and minute under 10 behaviour
set now=%date%_%time%
if %now:~0,2% LSS 10 ( set date_time=%now:~6,4%_%now:~3,2%_0%now:~1,1%) else ( set date_time=%now:~6,4%_%now:~3,2%_%now:~0,2%)
if %now:~11,2% LSS 10 ( set date_time=%date_time%__0%now:~12,1%_%now:~14,2%_%now:~17,2%) else ( set date_time=%date_time%__%now:~11,2%_%now:~14,2%_%now:~17,2%)
EXIT /B 0