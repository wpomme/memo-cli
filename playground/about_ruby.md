## About Ruby: Rubyの動作について気になったことを調べた結果

### モジュールやクラスのことを調べてみる
```irb
## モジュール
## モジュールはインスタンスを生成できないことに注意！
## Module#instance_methodsで、そのモジュールのインスタンスメソッドを調べられる
Memo::MemoFileUtility.instance_methods

## モジュールからミックスインされているメソッドを探して使用する方法
## 経緯: モジュールから直接メソッドを取り出すのが面倒だった
## やり方:
## 継承されているオブジェクトobjについて、存在すれば見つかる
obj.methods.find{|m| m == :method_I_want_to_use }
=> :method_I_want_to_use

## これで使いたいメソッドが使える
repo.method_I_want_to_use
```

