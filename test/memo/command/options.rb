# ありうる引数のパターンを作成して、それぞれについてテストを作成する
# 引数よりコマンドのごとに考えたほうが良さそう
#
# 全体
# 三つ以上の引数がある場合はその時点でエラーを出す
# 引数が0 -> memo help
# 引数が1 -> 引数によって各コマンドへ分岐し、<word>ならmemo read、それ以外の文字列ならエラー
# 引数が2 -> 最初の引数で各コマンドへ分岐し、登録されていない文字列ならそこでエラーを出す
#            二番目の引数は、各コマンドごとの指定に従う
# <word> -> 先頭と最後はa-zA-Z、文中はそれにハイフンを追加した文字列のみ受け付ける。32文字以上はエラーにする。
# <dirs> -> word と同じ条件にしたい。memo直下にmemoがあると面倒なので、それ以外のものはetcとかmiscに入れよう
#
# memo help
# 正常系
# memo
# memo -h
# memo help
# memo --help
#
# 異常系
# memo -h <args>
# memo help <args>
# memo --help <args>
# -> 余分な引数がついているというエラーを出す
#
# memo version
# 正常系
# memo -v
# memo -V
# memo --version
# memo version
# 
# 異常系
# memo -v <args>
# memo -V <args>
# memo --version <args>
# memo version <args>
# -> memo versionと同じにする
#
# memo dirs
# 正常系
# memo dirs
# 異常系
# memo dirs <args>
#
# memo list
# 正常系
# memo list
# memo list <dir>
# dir によって正常か異常かが変化する
# 異常系
# memo list <arg2>
# arg2は二つ以上の引数の場合
#
# memo read
# 正常系
# memo <word>
# memo read <word>
# word によって正常か異常かが変化する
# 異常系
# memo <arg2>
# memo read <arg2>
# -> memo <arg2>ほ判定が厄介そう
