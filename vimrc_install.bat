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

rem skk辞書のインストール
if not exist %USERPROFILE%\.skk (
	mkdir %USERPROFILE%\.skk
)
if not exist %USERPROFILE%\.skk\SKK-JISYO.L (
	mklink %USERPROFILE%\.skk\SKK-JISYO.L %CD%\skk\SKK-JISYO.L
)

rem NeoBundleをインストール
if not exists %USERPROFILE%\.vim\bundle (
	git > NUL 2>&1
	if not %ERRORLEVEL% == 0 (
		mkdir %USERPROFILE%\.vim\bundle
		git clone "https://github.com/Shougo/neobundle.vim" "%USERPROFILE%\.vim\bundle\neobundle.vim"
	) else (
		echo gitコマンドが存在しませんのでNeoBundleをインストールできませんでした
	)
)

rem 最初のカレントに戻る
cd %CURRENT%
