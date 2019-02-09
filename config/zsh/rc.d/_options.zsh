##############################################################################
# ZSH options
#

# Changing Directories {{{

# ディレクトリ名だけでcd
setopt auto_cd

# cdしたらpushd
setopt auto_pushd

# ディレクトリが無ければ先頭に'~'をつけて処理
# setopt cdable_vars

# リンク先を絶対参照して'..'を処理
# setopt chase_dots

# symlinkを追跡してオリジナルにcdする
# setopt chase_links

# よりPOSIX標準に準拠する
setopt posix_cd

# 同じディレクトリは2度pushdしない
setopt pushd_ignore_dups

# pushdの+と-の意味を交換
# setopt pushd_minus

# pushdやpopdで出力を行わない
setopt pushd_silent

# 引数なしのpushdは'pushd $HOME'とする
setopt pushd_to_home

# }}}

# Completion {{{

# 補完の出力を上書きしない
# unsetopt always_last_prompt

# 完全な補完をしたらカーソルを末尾へ移動
setopt always_to_end

# 曖昧な補完で候補をリストアップしない
# unsetopt auto_list

# Tabキーを連打しても選択を移動しない
# unsetopt auto_menu

# 変数がディレクトリの場合に変数名をディレクトリ名として使用
# setopt auto_name_dirs

# 変数名の賢い補完
# unsetopt auto_param_keys

# ディレクトリを補完した場合は最後にスラッシュをつける
# unsetopt auto_param_slash

# ディレクトリの補完で付いたスラッシュを自動的に削除
# unsetopt auto_remove_slash

# Tabを3回押すまでリスト表示しない（ただし menu_complete が優先）
# setopt bash_auto_list

# エイリアスを別のコマンド名として処理する
setopt complete_aliases

# カーソル部分から補完を開始する
# setopt complete_in_word

# 補完のグロブを展開せずに適合ワードをサイクルする
# setopt glob_complete

# 最初のコマンド補完時に path の内容をハッシュしない
# unsetopt hash_list_all

# 補完候補が一意の場合もリスト表示
# unsetopt list_ambiguous

# Tabを押して補完が成功しない時のビープを抑制
unsetopt list_beep

# コンパクトに表示
setopt list_packed

# 選択時に横方向に移動する
setopt list_rows_first

# ファイルの末尾に種別の識別記号をつける
# unsetopt list_types

# リスト表示の時にはじめから1つ挿入する
setopt menu_complete

# 曖昧さが残っていても補完を終了する
# unsetopt rec_exact

# }}}

# Expansion and Globbing {{{

# 不正なパターン時にエラーメッセージを表示しない
# unsetopt bad_pattern

# グロブを適切に処理する
# unsetopt bare_glob_qual

# ブレース展開式がただの文字列の場合に1文字ずつ展開
# setopt brace_ccl

# 大文字小文字を区別しない
# unsetopt case_glob

# 正規表現を使用しない
# unsetopt case_match

# csh形式のグロブを扱う
# setopt csh_null_glob

# =をグロブに使用できなくする
# unsetopt equals

# グロブに追加文字を使用する
# setopt extended_glob

# 数値計算を浮動小数点計算として扱う
# setopt force_float

# グロブを使用しない
# unsetopt glob

# 代入式の右辺で不明確なグロブ展開を使用する deprecated
# setopt glob_assign

# 明確な場合はファイル名先頭のドットを必要としない
# setopt glob_dots

# 変数の内容も展開に使用する
# setopt glob_subst

# sや&の展開修飾マッチングをパターンマッチにする
setopt hist_subst_pattern

# ブレース展開を無効にする
# setopt ignore_braces

# コマンド最初の閉じ大カッコ（｝）が必要なくなる。ただし最後のコマンドに';'がないとエラーになる。
# setopt ignore_close_braces

# ksh形式のグロブを使用する
# setopt ksh_glob

# オプションの=以降の補完を可能にする
setopt magic_equal_subst

# グロブ展開後のディレクトリには末尾に'/'を付加
setopt mark_dirs

# マルチバイト文字を扱わない
# unsetopt multibyte

# ファイル生成パターンのエラーを表示しない
# unsetopt no_match

# エラーの表示の代わりにパターンを除去する
# setopt null_glob

# ファイル名生成を辞書順ではなく数値順にする
# setopt numeric_glob_sort

# 展開に含まれる配列を別々に展開する
# setopt rc_expand_param

# 正規表現マッチング（param =~ regexp）でPCREを使用可能にする
# unsetopt rematch_pcre

# kshやshのグロブを使用する
# setopt sh_glob

# 定義されていない変数を空文字の変数として扱わない（エラーになる）
# unsetopt unset

# 関数内の変数がグローバルとして定義されていたら警告を出す
# setopt warn_create_global

# }}}

# History {{{

# ヒストリファイルをセッションごとに上書きする
# unsetopt append_history

# csh形式のヒストリ拡張を使用しない
# unsetopt bang_hist

# ヒストリにコマンド実行時刻を含める
setopt extended_history

# 書き込みリダイレクトで既存ファイルの上書きを許可する
# setopt hist_allow_clobber

# 存在しないヒストリの場合ビープで通知する
unsetopt hist_beep

# ヒストリが削られる場合、以前入力した同じものを先に削除する
# setopt hist_expire_dups_fist

# 書き込み中のヒストリファイルをロックする際に fcntl を使用する
setopt hist_fcntl_lock

# ヒストリ検索時に以前見たものを2度表示しない
setopt hist_find_no_dups

# 以前と同じコマンドはヒストリに保存しない
setopt hist_ignore_all_dups

# 直前のコマンドと同じコマンドはヒストリに保存しない
setopt hist_ignore_dups

# 行頭がスペースのコマンドはヒストリに保存しない
setopt hist_ignore_space

# ヒストリファイルの形式を変更する
# setopt hist_lex_words

# ヒストリから関数定義を除去する
setopt hist_no_functions

# ヒストリコマンドをヒストリから取り除く
setopt hist_no_store

# ヒストリ保存時に余分な空白を除去する
setopt hist_reduce_blanks

# ヒストリを一旦コピーファイルに保存しない
# unsetopt hist_save_by_copy

# ヒストリファイルに書き出すときに以前のコマンドと同じものを除去する
setopt hist_save_no_dups

# ヒストリコマンドを直接実行しない
# setopt hist_verify

# ヒストリをヒストリファイルに即座に書き込む
setopt inc_append_history

# ヒストリ書き込み時間をヒストリファイルに追加する
# setopt inc_append_history_time

# ヒストリの読み出しと書き込みを同時に行う
setopt share_history

# }}}

# Initializations {{{

# すべての変数を自動的にexportする
# setopt all_export

# エクスポートフラグ(-x)をもつ変数が自動的にグローバル(-g)にならない
# unsetopt global_export

# 起動時に /etc/zshenv を除く /etc 以下の設定ファイル群を読み込まない
# unsetopt global_rcs

# 起動時に /etc/zshenv を除く全ての設定ファイルを読み込まない
# unsetopt rcs

# }}}

# Input/Output {{{

# エイリアスを拡張しない
# unsetopt aliases

# リダイレクトによる入出力制御
# unsetopt clobber

# スペルミスの修正をする
setopt correct

# コマンド行の全ての引数に対してスペルミスの修正を行う
# setopt correct_all

# スペルミスの修正時にDvorak配列として修正する
# setopt dvorak

# フロー制御(Ctrl+S,Ctrl+Q)を無効化する
unsetopt flow_control

# EOFを読み込んでも終了しない
# setopt ignore_eof

# 対話的シェルでも#以降をコメントとみなす
setopt interactive_comments

# コマンドの場所をその場所の最初の実行時にハッシュしない
# unsetopt hash_cmds

# コマンドのハッシュ時にそれを含むディレクトリをハッシュしない
# unsetopt hash_dirs

# 実行権限が付与されているコマンド以外はハッシュしない
# setopt hash_executables_only

# メールファイルにアクセスがあると警告を出す
setopt mail_warning

# コマンド名に/が含まれていてもそれを含めたパスの検索を行う
setopt path_dirs

# 効果不明
# setopt path_script

# マルチバイト文字を処理する
# setopt print_eight_bit

# 終了コード($?)を表示する
# setopt print_exit_value

# シングルクォート内のシングルクォートを許可する
# setopt rc_quotes

# 'rm *'の実行時に警告を表示しない
# setopt rm_star_silent

# 'rm *'の実行前に10秒間の猶予を与える
# setopt rm_star_wait

# 省略形式のループ(forなど)を許可しない
# unsetopt short_loops

# バッククォートの数が合わない場合に最後のバッククォートを無視する
# setopt sun_keyboard_hack

# }}}

# Job Control {{{

# disownコマンドでジョブテーブルから除去したjobに自動的にCONTシグナルを送信する
setopt auto_continue

# サスペンドしたjobをそのコマンド名で再開する
setopt auto_resume

# バックグラウンドのjobの優先度を下げない
if __is_wsl; then
  unsetopt bg_nice
fi

# バックグラウンドjobがある際にzshを終了しても何も警告しない
# unsetopt check_jobs

# 実行中のjobがある場合にzshを終了するとそのjobにHUPシグナルを送信しない（道連れにする）
# unsetopt hup

# jobsで表示されるjobリストを冗長にする
# setopt long_list_jobs

# jobコントロールを許可する（インタラクティブシェルではデフォルト）
# setopt monitor

# バックグラウンドjobが終了しても即座に通知しない
# unsetopt notify

# POSIX標準に準拠したjobコントロールを使用する
# setopt posix_jobs

# }}}

# Prompting {{{

# プロンプトで!を特殊文字として扱わない
# unsetopt prompt_bang

# プロンプトで改行コードの無い行を出力しない
# unsetopt prompt_cr

# prompt_crで出力されなかった行を反転文字で通知
# unsetopt prompt_sp

# プロンプトで%を特殊文字として扱わない
# unsetopt prompt_percent

# プロンプトで拡張変数などを利用する
setopt prompt_subst

# コマンド実行時に右プロンプトの表示を削除する
setopt transient_rprompt

# }}}

# Scripts and Functions {{{
# 互換性を考えるとこの種類のオプションを変更するのは好ましくないので省略
# }}}

# Shell Emulation {{{
# 互換性を考えるとこの種類のオプションを変更するのは好ましくないので省略
# }}}

# Shell State {{{
# 互換性を考えるとこの種類のオプションを変更するのは好ましくないので省略
# }}}

# Zsh Line Editor (ZLE) {{{

# ZLEのエラー時にビープで通知しない
unsetopt beep

# 通常では使用されない特殊記号を正しく表示する
# setopt combining_chars

# Emacsのキーバインディングを使用する
setopt emacs

# ZLEをOverstrikeモードで起動
# setopt overstrike

# シングルラインエディットにする
# setopt single_line_zle

# Viのキーバインディングを使用する
# setopt vi

# ZLEを使用する（インタラクティブシェルではデフォルト）
setopt zle

# }}}
