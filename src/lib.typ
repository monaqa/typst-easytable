#import "@preview/tablex:0.0.8": cellx, gridx, hlinex, vlinex

#let _easytable_processor(columns, operations) = {
  let data = ()
  let row_idx = 0
  let layout_func = ((c) => c,) * columns.len()

  for op in operations {
    if op._kind == "easytable.push_data" {
      // validation
      if op.data.len() != columns.len() {
        panic("# of columns does not match.")
      }

      for (col_idx, z) in op.data.zip(layout_func).enumerate() {
        let _trans = op.at("cell_trans", default: none)
        let _style = op.at("cell_style", default: none)
        let (c, layout_f) = z
        c = layout_f(c)
        if _trans != none {
          c = _trans(x: col_idx, y: row_idx, c)
        }

        let cell_args = if _style == none { () } else {
          _style(x: col_idx, y: row_idx)
        }
        data.push(cellx(c, ..cell_args))
      }
      row_idx += 1
    }

    if op._kind == "easytable.set_layout" {
      if op.layout.len() != columns.len() {
        panic("# of layouts does not match.")
      }
      layout_func = op.layout
    }

    if op._kind == "easytable.push_hline" {
      data.push(hlinex(..op.at("args", default: ())))
    }

    if op._kind == "easytable.push_vline" {
      data.push(vlinex(..op.at("args", default: ())))
    }
  }

  gridx(columns: columns, ..data)
}

#let hline_tb(operations, stroke: 0.8pt) = {
  (
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    ..operations,
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
  )
}

#let rectbox(operations, stroke: 0.8pt) = {
  (
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    (_kind: "easytable.push_vline", args: (stroke: stroke)),
    ..operations,
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    (_kind: "easytable.push_vline", args: (stroke: stroke)),
  )
}

#let easytable(decoration: hline_tb, em_dash: auto, columns, body) = {
  let operations = decoration(body)
  _easytable_processor(columns, operations)
}

#let cstyle(..columns) = {
  let layout_func = columns.pos().map((e) => {
    if type(e) == "alignment" {
      return _content => align(e, _content)
    } else {
      return e
    }
  })
  ((_kind: "easytable.set_layout", layout: layout_func),)
}

#let td(
  trans: none,
  trans_by_idx: none,
  header: false,
  cell_style: none,
  ..columns,
) = {
  let cell_trans = if trans != none {
    (x: none, y: none, c) => trans(c)
  } else if trans_by_idx != none {
    trans_by_idx
  } else {
    none
  }
  let data = (
    _kind: "easytable.push_data",
    data: columns.pos(),
    cell_style: cell_style,
    cell_trans: cell_trans,
  )

  if header {
    (
      data,
      (_kind: "easytable.push_hline", args: (stroke: 0.5pt, expand: -2pt)),
    )
  } else {
    (data,)
  }
}

#let th = td.with(header: true, trans: (c) => align(center, text(weight: 700, c)))

