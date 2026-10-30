use v5.24;

# 実行方法:
# find lib/ -type f | xargs perl ./spellcheck.pl | comm -2 - <(cat /usr/share/dict/words)

my %hash;

while (<<>>) {
  my @words = split /[\s#:,=@?!|~^%*\$\&\-\_\<\>\[\]\{\}\(\)\'\"\/\\\.]+/;

  foreach (@words) {
    s/([a-zA-Z])/\L\1/gi;
    $hash{$_} += 1 if /\A[a-zA-Z]{2,}\Z/;
  };
}

# 単語の出現回数をチェックしたい場合
# foreach my $key (sort keys %hash) {
#   print "$key => $hash{$key}\n";
# };

foreach my $key (sort keys %hash) {
  print "$key\n";
};

