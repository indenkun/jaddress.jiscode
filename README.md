
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jaddress.jiscode

<!-- badges: start -->
<!-- badges: end -->

`{jaddress.jiscode}`はRで漢字の都道府県名と市区町村名を含む住所を入力すると総務省の割り当てた全国地方公共団体コード（市区町村コード、JISコード）（以下団体コード）を出力ための`jaddress_jiscode()`関数を含むパッケージです。

## Installation

Githubからインストールできます。

``` r
install.packages("remotes")
remotes::install_github("indenkun/jaddress.jiscode")
```

## Example

このパッケージは都道府県と市町村名を含む住所から団体コードを出力するため`address.jiscode()`の単一の関数からなります。

``` r
library(jaddress.jiscode)
```

都道府県名（漢字）と市町村名（漢字）を含む住所を入力すると団体コード（文字列）を出力します。

``` r
jaddress_jiscode("東京都新宿区西新宿２丁目８−１")
#> [1] "131041"
```

デフォルトでは市区町村までのコードを出力しますが、引数を指定すると都道府県コードまでの出力に変更することもできます。

``` r
jaddress_jiscode("東京都新宿区西新宿２丁目８−１", jis = "pref")
#> [1] "13"
```

総務省の都道府県コード及び市区町村コードの形式ではない市区町村名でも可能な限り検索するように努めています。

``` r
# 北海道の月形町役場の住所は北海道樺戸郡月形町となっている。
# 総務省の市区町村コード表では月形町のみになっている。
# この場合、北海道樺戸郡月形町と入力されると北海道月形町の市区町村コードを出力するようにしている。
jaddress_jiscode("北海道樺戸郡月形町1219番地")
#> [1] "014303"
```

住所の入力は都道府県と市区町村名が漢字で含まれていれば出力可能です。

``` r
jaddress_jiscode("秋田県秋田市")
#> [1] "052019"
```

ただし、ちゃんと市や県などをつけていない場合や都道府県名や市区町村名が漢字ではない場合は処理できません。
また総務省の団体コード表上実在しない住所は処理できません。処理できない住所が入力され場合はWarrning
messageとともに`NA`を返すようにしています。

``` r
jaddress_jiscode("東京新宿")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): The address is not in a searchable form
#> for jis codes.
#> [1] NA
jaddress_jiscode("とうきょうとしんじゅくく")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): The address is not in a searchable form
#> for jis codes.
#> [1] NA
jaddress_jiscode("沖縄県呉市")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): It seems that the address was not
#> narrowed down to a single jis code or was not in a searchable format.
#> [1] NA
```

複数の住所をベクトルで入力するとベクトルで団体コードを返します。

``` r
jaddress_jiscode(c("青森県青森市長島一丁目1-1", "鳥取県鳥取市東町1丁目220"))
#> [1] "022012" "312011"
```

## Notice

市区町村名だけで団体コードを返すことについては、共通する市区町村名を有する複数の都道府県があるため一意に団体コードを求めるためには都道府県情報が必須となっています。

パッケージでは内部に総務省のホームページに掲載されているデータを含んでいます（出典：総務省ホームページ、全国地方公共団体コード<https://www.soumu.go.jp/denshijiti/code.html>（令和元年5月1日更新））。

総務省はホームページ上で公開している情報については出典の明記等の条件を満たすなどの条件で複製、公衆送信、翻訳・変形等の翻案等、自由に利用できるとしています。詳細は総務省のホームページを御覧ください。

DESCRIPTIONに記載しているメールアドレスはダミーです。なにかあればISSUEに記載してください。

## Imports

-   `{stringr}`
-   `{purrr}`
-   `{zipangu}`

## License.

MIT.
