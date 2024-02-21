# Typst Easytable Package

A Typst library for writing simple tables.

## Usage

**WARNING: This library is not in `preview` namespace.**

```typst
#import "@preview/easytable:0.1.0": easytable, elem
```

## Manual

See [manual](./manual.pdf).

## Examples

### A Simple Table

```typst
#easytable({
  import elem: *
  th[Header 1 ][Header 2][Header 3  ]
  td[How      ][I       ][want      ]
  td[a        ][drink,  ][alcoholic ]
  td[of       ][course, ][after     ]
  td[the      ][heavy   ][lectures  ]
  td[involving][quantum ][mechanics.]
})
```

### Setting Column Alignment and Width

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

### Customizing Styles

```typst
#easytable({
  let td = td.with(trans: pad.with(x: 3pt))

  th[Header 1][Header 2][Header 3]
  td[How][I][want]
  td[a][drink,][alcoholic]
  td[of][course,][after]
  td[the][heavy][lectures]
  td[involving][quantum][mechanics.]
})
```

```typst
#easytable({
  let th = th.with(trans: emph)
  let td = td.with(
    cell_style: (x: none, y: none)
      => (fill: if calc.even(y) {
        luma(95%)
      } else {
        none
      })
  )

  th[Header 1][Header 2][Header 3]
  td[How][I][want]
  td[a][drink,][alcoholic]
  td[of][course,][after]
  td[the][heavy][lectures]
  td[involving][quantum][mechanics.]
})
```
