## memo CLIに関するワンライナー集
###  タグ名のTypoを検出する機能[OK]
- Settingとsetting, settingsなどの表記ゆれを簡易的に検出する
```bash
memo tags -n | tr "[A-Z]" "[a-z]" | sort | uniq -c
```

### タグの出現頻度が１程度のものを抽出する場合
```bash
memo tags -c | awk -v FS="\t" '$1 == 1 { print $2 }'

# ソートして見やすくする
memo tags -c | awk -v FS="\t" '$1 == 1 { print $2 }' | sort
```
