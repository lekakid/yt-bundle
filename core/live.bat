@echo off
chcp 65001 > nul

set url=NONE
set cookie=YES
set shutdown=NO
set /a maxthread=(%NUMBER_OF_PROCESSORS%-4)/2
if %maxthread% lss 1 (
  set threadcount=1
) else (
  set threadcount=%maxthread%
)

:MENU
cls
echo ============= 라이브 =============
echo.
echo 　　주소: %url%
echo 쿠키정리: %cookie%
echo 종료예약: %shutdown%
echo 스레드수: %threadcount%
echo.
echo ============== MENU ==============
echo.
echo 1. 라이브 주소 입력
echo 2. 쿠키 정리
echo 3. 시스템 종료 예약
echo 9. 다운로드 시작
echo.
echo 0. 돌아가기
echo.
echo ==================================
set /p "sel=> "

cls
if %sel% equ 1 call :INPUT_TARGET
if %sel% equ 2 call :SET_COOKIECLEAR
if %sel% equ 3 call :SET_SHUTDOWN
if %sel% equ 4 call :SET_THREAD
if %sel% equ 9 call :RUN_YTARCHIVE
if %sel% equ 0 call launcher.bat
goto MENU

:INPUT_TARGET
echo.
echo 현재 진행 중인 라이브주소 입력 (q 입력 시 취소)
set /p "input=> "
if "%input%" == "q" goto :EOF
if "%input%" == "Q" goto :EOF
set url=%input%
goto :EOF

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

:SET_THREAD
echo 사용할 스레드 수 입력 (권장값 1~%maxthread% / 현재값 %threadcount%)
set /p "count=> "

if %count% lss 1 goto SET_THREAD
set threadcount=%count%
goto :EOF

:RUN_YTARCHIVE

if "%target%" == "NONE" goto :EOF

set arg=
if exist cookies.txt set arg=-c %cd%\cookies.txt
set arg=%arg% ^
        --threads %threadcount% ^
        --merge ^
        -w ^
        -o %outputdir%/%outputname% ^
        %url% best
ytarchive %arg%

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