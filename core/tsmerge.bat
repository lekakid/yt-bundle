:FFMPEG
cls
echo.
set index=0
for %%n in (%outputdir%/*.f140.ts) do (
  setlocal disabledelayedexpansion
  set name=%%n
  setlocal enabledelayedexpansion
  set /a "index+=1"
  set name=!name:.f140.ts=!
  set video[!index!]=!name!
  set num=   !index!
  echo !num:~-2!. !name!
)
setlocal disabledelayedexpansion
if %index% equ 0 echo 저장된 영상 없음
echo.
echo  0. 돌아가기
echo.
set /p "sel=> "

cls
if %sel% equ 0 call launcher.bat
if %sel% geq 1 (
  if %sel% leq %index% (
    call :SUB_MERGE
  )
)
goto FFMPEG

:SUB_MERGE
call set v=%%video[%sel%]%%
set arg=-i "%outputdir%/%v%.f140.ts" -i "%outputdir%/%v%.f299.ts" -c copy "%outputdir%/%v%.mp4"
ffmpeg %arg%
if %ERRORLEVEL% gtr 0 (
  pause
)
else (
  del /s "%outputdir%\%v%.*.ts"
)