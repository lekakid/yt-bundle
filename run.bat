@echo off
chcp 65001

set output=videos
set outputname=%%(title)s-%%(id)s

set url=NONE
set cookie=YES
set shutdown=NO
set /a maxthread=(%NUMBER_OF_PROCESSORS%-4)/2
if %maxthread% lss 1 (
  set threadcount=1
) else (
  set threadcount=%maxthread%
)

:DOWNLOAD_OPTION
cls
echo ============= STATUS =============
echo.
echo 　　주소: %url%
echo 쿠키정리: %cookie%
echo 종료예약: %shutdown%
echo 스레드수: %threadcount%
echo.
echo ============== MENU ==============
echo.
echo 1. 라이브 주소 입력
echo 2. 다운로드 후 쿠키 정리
echo 3. 시스템 종료 예약
echo 4. 스레드 설정
echo 5. ts 파일 결합
echo.
echo 0. 다운로드 시작
echo.
echo ==================================
set /p sel=선택 : 

cls
if %sel% equ 1 goto INPUT_URL
if %sel% equ 2 goto SET_COOKIECLEAR
if %sel% equ 3 goto SET_SHUTDOWN
if %sel% equ 4 goto SET_THREAD
if %sel% equ 5 goto FFMPEG
if %sel% equ 0 goto RUN_YTARCHIVE
goto DOWNLOAD_OPTION

:INPUT_URL
set /p url=다운로드 받을 주소 입력 : 
goto DOWNLOAD_OPTION

:SET_COOKIECLEAR
if "%cookie%" == "NO" (
  set cookie=YES
) else (
  set cookie=NO
)
goto DOWNLOAD_OPTION

:SET_SHUTDOWN
if "%shutdown%" == "NO" (
  set shutdown=YES
) else (
  set shutdown=NO
)
goto DOWNLOAD_OPTION

:SET_THREAD
set /p count=사용할 스레드 수 입력 (권장값 1~%maxthread% / 현재값 %threadcount%): 

if %count% lss 1 goto SET_THREAD
set threadcount=%count%
goto DOWNLOAD_OPTION

:FFMPEG
cls
echo.
set index=0
for %%n in (%output%/*.f140.ts) do (
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
set /p sel= 선택 : 

cls
if %sel% equ 0 goto DOWNLOAD_OPTION
if %sel% geq 1 (
  if %sel% leq %index% (
    goto SUB_MERGE
  )
)
goto FFMPEG

:SUB_MERGE
call set v=%%video[%sel%]%%
set arg=-i "%output%/%v%.f140.ts" -i "%output%/%v%.f299.ts" -c copy "%output%/%v%.mp4"
ffmpeg %arg%
if %ERRORLEVEL% gtr 0 (
  pause
)
else (
  del /s "%output%\%v%.*.ts"
)
goto FFMPEG

:RUN_YTARCHIVE

if "%url%" == "NONE" goto DOWNLOAD_OPTION

set arg=--threads %threadcount% --merge -w -o %output%/%outputname%
if exist cookies.txt set arg=%arg% -c cookies.txt
set arg=%arg% %url% best
ytarchive.exe %arg%

if %ERRORLEVEL% gtr 0 (
  pause
  goto DOWNLOAD_OPTION
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
goto DOWNLOAD_OPTION
