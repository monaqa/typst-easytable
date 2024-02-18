#import "@preview/tidy:0.2.0"
#import "src/lib.typ": *

#set text(font: "Noto Serif CJK JP")
#show heading: set text(font: "Noto Sans CJK JP")

#show heading: set pad(bottom: 2em)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 2em, [Typst-Easytable Package])

  version: 0.1.0

  #datetime.today().display()
]

#outline(title: "目次", indent: 1em, depth: 3)

= 概要

`typst-easytable` は Typst で簡単に表を記述するためのパッケージです。

== `typst-easytable` の目指すもの

- 簡潔で視認性の高いマークアップ
- ある程度の汎用性

== `typst-easytable` の目指さないもの

- ほとんどの用途で必要のない表機能の提供

= 使い方

```typst
#import "@preview/easytable:0.1.0": *
```

== 最も単純な表

シンプルに記述できます。

```typst
#easytable({
  td[How      ][I      ][want      ]
  td[a        ][drink, ][alcoholic ]
  td[of       ][course,][after     ]
  td[the      ][heavy  ][lectures  ]
  td[involving][quantum][mechanics.]
})
```

#easytable({
  td[How ][I ][want ]
  td[a ][drink, ][alcoholic]
  td[of ][course,][after ]
  td[the ][heavy ][lectures ]
  td[involving][quantum][mechanics.]
})

`td` はデータを表す関数です。ヘッダを追加するには `th` 関数を用いて以下のようにします。

```typst
#easytable({
  th[Header 1 ][Header 2][Header 3  ]
  td[How      ][I       ][want      ]
  td[a        ][drink,  ][alcoholic ]
  td[of       ][course, ][after     ]
  td[the      ][heavy   ][lectures  ]
  td[involving][quantum ][mechanics.]
})
```

#easytable({
  th[Header 1 ][Header 2][Header 3 ]
  td[How ][I ][want ]
  td[a ][drink, ][alcoholic ]
  td[of ][course, ][after ]
  td[the ][heavy ][lectures ]
  td[involving][quantum ][mechanics.]
})

4つ以上の列を追加することも簡単ですが...気をつけてください。
1箇所でも列の数に矛盾があるとエラーになります。
逆に言えば、セル1つずれてレイアウトが崩れていることに気づかない、という心配はありません。

列ごとに中央揃え、左揃え、右揃えを変えるには以下のようにします。

```typst
#easytable({
  cstyle(left, center, right)
  th[Header 1 ][Header 2][Header 3  ]
  td[How      ][I       ][want      ]
  td[a        ][drink,  ][alcoholic ]
  td[of       ][course, ][after     ]
  td[the      ][heavy   ][lectures  ]
  td[involving][quantum ][mechanics.]
})
```

#easytable({
  cstyle(left, center, right)
  th[Header 1 ][Header 2][Header 3 ]
  td[How ][I ][want ]
  td[a ][drink, ][alcoholic ]
  td[of ][course, ][after ]
  td[the ][heavy ][lectures ]
  td[involving][quantum ][mechanics.]
})

列ごとに長さを変えたければ？以下のようにします。

```typst
#easytable({
  cwidth(100pt, 1fr, 20%)
  th[Header 1 ][Header 2][Header 3  ]
  td[How      ][I       ][want      ]
  td[a        ][drink,  ][alcoholic ]
  td[of       ][course, ][after     ]
  td[the      ][heavy   ][lectures  ]
  td[involving][quantum ][mechanics.]
})
```

#easytable({
  cwidth(100pt, 1fr, 20%)
  th[Header 1 ][Header 2][Header 3 ]
  td[How ][I ][want ]
  td[a ][drink, ][alcoholic ]
  td[of ][course, ][after ]
  td[the ][heavy ][lectures ]
  td[involving][quantum ][mechanics.]
})

組み合わせて使うことも当然可能です。

```typst
#easytable({
  cwidth(100pt, 1fr, 20%)
  cstyle(left, center, right)
  th[Header 1 ][Header 2][Header 3  ]
  td[How      ][I       ][want      ]
  td[a        ][drink,  ][alcoholic ]
  td[of       ][course, ][after     ]
  td[the      ][heavy   ][lectures  ]
  td[involving][quantum ][mechanics.]
})
```

#easytable({
  cwidth(100pt, 1fr, 20%)
  cstyle(left, center, right)
  th[Header 1 ][Header 2][Header 3 ]
  td[How ][I ][want ]
  td[a ][drink, ][alcoholic ]
  td[of ][course, ][after ]
  td[the ][heavy ][lectures ]
  td[involving][quantum ][mechanics.]
})

今まではマークアップ上の見やすさのためカッコの位置を揃えていました。
が、本来その必要はありません。
そして、複数行に渡る長い content を記述することもできます。その場合も、表は問題なく組まれます。

```typst
#easytable({
  cwidth(auto, 50%)
  cstyle(right, left)
  th[用語][長い説明]
  td[LaTeX][素晴らしい組版システムです。学習難度は高いかもしれません。]
  td([Typst], [
    素晴らしい組版システム！具体的には以下のような利点があります。

    - インストールがとても簡単
    - 書きやすい

    皆さんも是非使ってみましょう。
  ])
})
```

#easytable({
  cwidth(auto, 50%)
  cstyle(right, left)
  th[用語][長い説明]
  td[LaTeX][素晴らしい組版システムです。学習難度は高いかもしれません。]
  td([Typst], [
    素晴らしい組版システム！具体的には以下のような利点があります。

    - インストールがとても簡単
    - 書きやすい

    皆さんも是非使ってみましょう。
  ])
})

= カスタマイズ

最初に述べておきますが、easytable はシンプルな表を楽に書くためのパッケージです。
複雑なレイアウトを要求する表にはあまり適していない場合があります。
とはいえ、最低限のカスタマイズはできます。

== background color をセルごとに変える

== 特定の列のレイアウトを変える

== 特定の行のレイアウトを変える

== 特定のセルのレイアウトを変える

直接変えたほうが早いでしょう。

== tablex にわたす引数を変える

内部で tablex を使っており、自由に引数を渡すことができます。

/// typstfmt::off


// #easytable({
//   cwidth(auto, auto, 1fr)
//   cstyle(left + bottom, center + bottom, (c) => {
//     text(fill: blue, size: 1.5em, align(right + bottom, c))
//   })
//
//   th[header1   ][header2     ][header3     ]
//   td[align left][align center][blue and big]
//   td[a         ][b           ][c           ]
//
//   cstyle(
//     left + bottom,
//     (c) => {
//       text(fill: blue, size: 1.5em, align(center + bottom, c))
//     },
//     right + bottom
//   )
//
//   td[align left][align center][blue and big]
//   td[a         ][b           ][c           ]
// })
//
// #easytable({
//   let td = td.with(trans: pad.with(y: 4pt))
//   cwidth(40%, 40%)
//   th[][例]
//   td[Emph][_強調されたテキスト_]
//   td[Code][`some code`]
//   td[#align(horizon)[Math]][$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2a) $]
//   td[#align(horizon)[Inner table]][
//     #easytable({
//       cstyle(left, right)
//       th[header 1][header 2]
//       td[a][b]
//   })
//   ]
// })
//
// #easytable({
//   th[][例]
//   td[Emph][_強調されたテキスト_]
// })

= API Reference

#let docs = tidy.parse-module(read("src/lib.typ"))
#tidy.show-module(docs)
