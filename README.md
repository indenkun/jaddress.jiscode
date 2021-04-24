
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jaddress.jiscode

<!-- badges: start -->
<!-- badges: end -->

`{jaddress.jiscode}`は住所と総務省の割り当てた全国地方公共団体コード（市区町村コード、JISコード）（以下団体コード）の相互変換をサポートするパッケージです。

## Installation

Githubからインストールできます。

``` r
install.packages("remotes")
remotes::install_github("indenkun/jaddress.jiscode")
```

## Example

``` r
library(jaddress.jiscode)
```

### `jaddress_jiscode()`

`address_jiscode()`は都道府県と市町村名を含む住所から団体コードを出力するための関数です。

都道府県名（漢字）と市町村名（漢字）を含む住所を入力すると団体コード（文字列）を出力します。

``` r
jaddress_jiscode("東京都新宿区西新宿２丁目８−１")
#> [1] "13104"
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
#> [1] "01430"
```

住所の入力は都道府県と市区町村名が漢字で含まれていれば出力可能です。

``` r
jaddress_jiscode("秋田県秋田市")
#> [1] "05201"
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
#> [1] "02201" "31201"
```

全国に一箇所しか無い市区町村の場合は団体コードを出力できますが全国に2箇所以上ある市区町村名の場合はNAを返します。

``` r
jaddress_jiscode("鳥取市")
#> [1] "31201"
# 美里町は秋田県と島根県と宮崎県にある。
jaddress_jiscode("美里町")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): It seems that the address was not
#> narrowed down to a single jis code or was not in a searchable format.
#> [1] NA
```

都道府県名のみを入力すると、都道府県コード2桁と000の5桁のコードを返します。都道府県名のみを入力して2桁の都道府県コードのみを出力したい場合は、`jis = "pref"`
としてください。

``` r
jaddress_jiscode("埼玉県")
#> [1] "11000"
jaddress_jiscode("埼玉県", jis = "pref")
#> [1] "11"
```

引数で`check.digit = TRUE`とすると、チェックディジットも表示されます。

``` r
jaddress_jiscode("沖縄県那覇市", check.digit = TRUE)
#> [1] "472018"
```

### `jiscode_jaddres()`

`jiscode_jaddres()`は団体コードを入力することで当該都道府県市区町村名を出力する関数です。

``` r
jiscode_jaddress("39201")
#> [1] "高知県高知市"
```

団体コードは半角数字２桁（都道府県コードのみ）、５桁（市区町村コード）、６桁（チェックディジットを含む）のみを受け付けます。それ以外は受け付けません。

``` r
jiscode_jaddress("1")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): Please enter the JIS code as a 2-digit,
#> 5-digit, or 6-digit value.
#> [1] NA
jiscode_jaddress("０１")
#> Warning in .f(.x[[1L]], .y[[1L]], ...): JIS codes are only accepted if they
#> consist of only half-width numbers.
#> [1] NA
```

団体コードが全角のデータをたまに見かけますが、本関数ではサポートしていないので事前に`{stringi}`の`stri_trans_general()`などを使って、半角のデータに変換してください。

``` r
# 全角数字で構成されたデータを半角数字に変換して都道府県市区町村名を求める例
example.data <- c("１３１１６", "０４２１３")
require(stringi)
#> Loading required package: stringi
example.data <- stri_trans_general(example.data, "Fullwidth-Halfwidth")
jiscode_jaddress(example.data)
#> [1] "東京都豊島区" "宮城県栗原市"
```

デフォルトでは都道府県+市区町村名となっていますが、`jis = "city"`とすると市区町村名のみ、`jis = "pref"`とすると都道府県名のみを出力するようにできます。

``` r
jiscode_jaddress("20413")
#> [1] "長野県天龍村"
jiscode_jaddress("20413", jis = "city")
#> [1] "天龍村"
jiscode_jaddress("20413", jis = "pref")
#> [1] "長野県"
```

## Notice

`jaddres_jiscode()`は全国に同じ市区町村名を有する複数の都道府県があるため正しく一意に団体コードを求めるためには都道府県情報が必須となっています。
ただし、全国に一箇所しか無い市区町村名も多いので、そういった市町村名が入力されたときには一意に団体コードを求められるのでその結果を出力しています。

市区町村よりも細かい区分の住所は一切参照していないので、都道府県+市区町村名が正しければ団体コードを出力します。そのため入力された住所が実際に存在するかどうかは判定していません。

パッケージでは内部に総務省のホームページに掲載されているデータを含んでいます（出典：総務省ホームページ、全国地方公共団体コード<https://www.soumu.go.jp/denshijiti/code.html>（令和元年5月1日更新））。

総務省はホームページ上で公開している情報については出典の明記等の条件を満たすことで複製、公衆送信、翻訳・変形等の翻案等、自由に利用できるとしています。詳細は総務省のホームページを御覧ください。

DESCRIPTIONに記載しているメールアドレスはダミーです。なにかあればISSUEに記載してください。

## Imports

-   `{stringr}`
-   `{purrr}`
-   `{zipangu}`

## License.

MIT.
