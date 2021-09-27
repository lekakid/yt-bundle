@echo off
chcp 65001 > nul

set cookie=YES
set shutdown=NO
set audioonly=NO

:MENU
cls
echo ============ 아카이브 ============
echo.
echo 쿠키정리: %cookie%
echo 종료예약: %shutdown%
echo 오디오만: %audioonly%
echo.
echo ============== MENU ==============
echo.
echo 1. 다운로드 대상 편집
echo 2. 쿠키 정리
echo 3. 시스템 종료 예약
echo 4. 오디오만 추출
echo 9. 다운로드 시작
echo.
echo 0. 돌아가기
echo.
echo ==================================
set /p "sel=> "

cls
if %sel% equ 1 start notepad list.txt
if %sel% equ 2 call :SET_COOKIECLEAR
if %sel% equ 3 call :SET_SHUTDOWN
if %sel% equ 4 call :SET_AUDIOONLY
if %sel% equ 9 call :RUN_YOUTUBE_DL
if %sel% equ 0 call launcher.bat
goto MENU

:SET_COOKIECLEAR
if "%cookie%" == "NO" (
  set cookie=YES
) else (
  set cookie=NO
)
goto :EOF

:SET_SHUTDOWN
if "%shutdown%" == "NO" (
  set shutdown=YES
) else (
  set shutdown=NO
)
goto :EOF

:SET_AUDIOONLY
if "%audioonly%" == "NO" (
  set audioonly=YES
) else (
  set audioonly=NO
)
goto :EOF


:RUN_YOUTUBE_DL
set arg=
if exist cookies.txt set arg=-cookies %cd%\cookies.txt
if "%audioonly%" == "YES" (
  set arg=%arg% --audio-format mp3 -x
)
if "%audioonly%" == "NO" (
  set arg=%arg% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" ^
                --merge-output-format mp4 ^
                --embed-thumbnail
)
set arg=%arg% ^
        -o %outputdir%/%outputname%.%%(ext)s ^
        --add-metadata ^
        -a list.txt
youtube-dl %arg%

if %ERRORLEVEL% gtr 0 (
  pause
  goto :EOF
)
if "%cookie%" == "YES" (
  del cookies.txt
)
if "%shutdown%" == "YES" (
  shutdown -s -t 300
  echo 5분 후에 컴퓨터가 종료됩니다.
  echo 아무 키를 눌러 취소합니다.
  pause > nul
  shutdown -a
)
goto :EOF