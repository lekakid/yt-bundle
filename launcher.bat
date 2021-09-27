@echo off
chcp 65001 > nul

set core=core
set lib=lib
set yt=%lib%\ytarchive.exe
set ytdl=%lib%\youtube-dl.exe
set ffmpeg=%lib%\ffmpeg.exe
set path=%path%;%cd%\%lib%

set outputdir=videos
set outputname=%%(title)s-%%(id)s

set sel=0
:MENU
echo ============== MENU ==============
echo.
echo 1. 라이브 다운로드
echo 2. 아카이브 다운로드
echo 3. 아카이브 클립 다운로드
echo 4. ts 파일 병합
echo 9. 출력 폴더 열기
echo.
echo 0. 종료
echo.
echo ==================================
set /p "sel=> "
cls

if %sel% == 1 call %core%/live.bat
if %sel% == 2 call %core%/archive.bat
if %sel% == 3 call %core%/clip.bat
if %sel% == 4 call %core%/tsmerge.bat
if %sel% == 9 start explorer %outputdir%
if %sel% == 0 exit
goto MENU