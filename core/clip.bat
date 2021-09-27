set type=live
set url=NONE
set shutdown=NO
set start=0:00:00
set end=0:00:00

:MENU
cls
echo ============= STATUS =============
echo.
echo 　　주소: %url%
echo 시작시간: %start%
echo 종료시간: %end%
echo.
echo ============== MENU ==============
echo.
echo 1. 주소 및 시간 입력
echo 9. 다운로드 시작
echo.
echo 0. 돌아가기
echo.
echo ==================================
set /p "sel=> "

cls
if %sel% equ 1 call :INPUT_URL
if %sel% equ 9 call :RUN_YOUTUBE_DL
if %sel% equ 0 call launcher.bat
goto MENU

:INPUT_URL
echo.
echo 클립을 딸 아카이브의 주소 입력 (q 입력 시 취소)
set /p "input=> "
if "%input%" == "q" goto :EOF
if "%input%" == "Q" goto :EOF
cls
goto INPUT_STARTTIME

:INPUT_STARTTIME
echo.
echo 시작 시간 입력 (형식 0:00:00 / q 입력 시 취소)
set /p "input2=> "
if "%input2%" == "q" goto :EOF
if "%input2%" == "Q" goto :EOF
cls
goto INPUT_ENDTIME

:INPUT_ENDTIME
echo.
echo 종료 시간 입력 (형식 0:00:00 / q 입력 시 취소)
set /p "input3=> "
if "%input3%" == "q" goto :EOF
if "%input3%" == "Q" goto :EOF
cls
goto INPUT_CONFIRM

:INPUT_CONFIRM
set url=%input%
set start=%input2%
set end=%input3%
goto :EOF

:RUN_YOUTUBE_DL
if "%url%" == "NONE" goto :EOF
set arg=--external-downloader ffmpeg ^
        --external-downloader-args "-ss %start% -to %end%" ^
        -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" ^
        --merge-output-format mp4 ^
        -o %outputdir%/%outputname% ^
        %url%
youtube-dl %arg%

if %ERRORLEVEL% gtr 0 (
  pause
)
goto :EOF