#import "src/lib.typ": *

/// typstfmt::off

#easytable((auto, auto, auto))[
  #cstyle(left, center, right)
  #th[header1   ][header2     ][header3    ]
  #td[align left][align center][align right]
  #td[a         ][b           ][c          ]
]

#easytable((auto, auto, auto))[
  #cstyle(left + bottom, center + bottom, (c) => {
    text(fill: blue, size: 1.5em, align(right + bottom, c))
  })

  #th[header1   ][header2     ][header3     ]
  #td[align left][align center][blue and big]
  #td[a         ][b           ][c           ]

  #cstyle(
    left + bottom,
    (c) => {
      text(fill: blue, size: 1.5em, align(center + bottom, c))
    },
    right + bottom
  )
  #td[align left][align center][blue and big]
  #td[a         ][b           ][c           ]
]

#easytable((auto, auto))[
  #let td = td.with(trans: pad.with(y: 4pt))
  #th[][例]
  #td[Emph][_強調されたテキスト_]
  ---
  #td[Code][`some code`]
  ---
  #td[#align(horizon)[Math]][$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2a) $]
  ---
  #td[#align(horizon)[Inner table]][
    #easytable((auto, auto))[
      #cstyle(left, right)
      #th[header 1][header 2]
      #td[a][b]
    ]
  ]
]

#easytable((auto, auto), {
  let cell_style = (x: none, y: none) => (if calc.even(y) {(fill:luma(90%))} else {(:)})
  let td = td.with(cell_style: cell_style)
  let th = th.with(cell_style: cell_style)
  let tds = [
    #td[foo][bar]
    #td[foo][bar]
  ]

  th[][例]
  td[Emph][_強調されたテキスト_]
  td[Code][`some code`]
  td[#align(horizon)[Math]][$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2a) $]
  td[#align(horizon)[Inner table]][
    #easytable((auto, auto))[
      #cstyle(left, right)
      #th[header 1][header 2]
      #td[a][b]
    ]
  ]
  tds
})
