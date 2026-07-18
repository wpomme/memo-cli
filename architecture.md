## Memoの内部構造
- Repository <-> ViewModel <-> Presenter <-> Commandの流れにした
Memo::Repository -> 元データ
Memo::ViewModel -> ユーザー向けのデータ加工。色付けなど。また、RepositoryをPrivateにできるかも。
Memo::Presenter -> データの表示とユーザーメッセージ
Memo::Command -> CLI
