@echo off

NET SESSION > NUL 2>&1
if not %ERRORLEVEL% == 0 (
	echo 管理者で実行してください。
	exit /B 1
)

rem 現在のカレントを退避
set CURRENT=%CD%

rem このファイルがあるディレクトリに移動する
%~d0
cd %~p0

rem vimrcとgvimrcのシンボリックリンクを%HOME%に作成する
if not exist %USERPROFILE%\_vimrc (
	mklink %USERPROFILE%\_vimrc %CD%\vimrc
)
if not exist %USERPROFILE%\_gvimrc (
	mklink %USERPROFILE%\_gvimrc %CD%\gvimrc
)

rem バックアップディレクトリ等を作成する
if not exist %USERPROFILE%\.vim\.backup (
	mkdir %USERPROFILE%\.vim\.backup
)

rem 最初のカレントに戻る
cd %CURRENT%
