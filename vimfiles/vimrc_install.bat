@echo off

NET SESSION > NUL 2>&1
if not %ERRORLEVEL% == 0 (
	echo �Ǘ��҂Ŏ��s���Ă��������B
	exit /B 1
)

rem ���݂̃J�����g��ޔ�
set CURRENT=%CD%

rem ���̃t�@�C��������f�B���N�g���Ɉړ�����
%~d0
cd %~p0

rem vimrc��gvimrc�̃V���{���b�N�����N��%HOME%�ɍ쐬����
if not exist %USERPROFILE%\_vimrc (
	mklink %USERPROFILE%\_vimrc %CD%\vimrc
)
if not exist %USERPROFILE%\_gvimrc (
	mklink %USERPROFILE%\_gvimrc %CD%\gvimrc
)

rem �o�b�N�A�b�v�f�B���N�g�������쐬����
if not exist %USERPROFILE%\.vim\.backup (
	mkdir %USERPROFILE%\.vim\.backup
)

rem �ŏ��̃J�����g�ɖ߂�
cd %CURRENT%
