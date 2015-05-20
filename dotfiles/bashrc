# ~/にscalaディレクトリとplayディレクトリへのシンボリックリンクを作成すること
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ll='ls -l'
alias gg='git grep --no-index -I --line-number'

# ヒストリ
export HISTCONTROL=ignoreboth # 重複は無視し、かつスペースで始まるコマンドも無視する
export HISTIGNORE="history*:cd*:ls*:ll*:groot" # よく使うコマンドは記録しない
export HISTSIZE=10000 # ヒストリの履歴を増やす
# 複数端末でヒストリを共有する
function share_history {
history -a # .bash_historyに前回コマンドを1行追記
history -c # 端末ローカルの履歴を一旦消去
history -r # .bash_historyから履歴を読み込み直す
}
shopt -u histappend # .bash_history追記モードは不要なのでOFFに
PROMPT_COMMAND="share_history" # share_historyをプロンプトごとに自動実行

# git settings
if [ -e ~/.git-prompt.sh ]; then
	source ~/.git-prompt.sh
fi
source ~/.git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

function groot {
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		cd `git rev-parse --show-toplevel`
	fi
}

# tmux
if [ -z "$TMUX" -a -z "$STY" ]; then
	if type tmuxx >/dev/null 2>&1; then
		tmuxx
	elif type tmux >/dev/null 2>&1; then
		if tmux has-session && tmux list-sessions | egrep -q '.*]$'; then
			# デタッチ済みセッションが存在する
			tmux attach && echo "tmux attached session"
		else
			tmux new-session && echo "tmux created new session"
		fi
	elif type screen >/dev/null 2>&1; then
		screen -rx || screen -D -RR
	fi
fi
