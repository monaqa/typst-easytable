#import "@preview/tablex:0.0.8": cellx, gridx, hlinex, vlinex

#let _easytable_processor(n_columns, columns, operations, tablex_extra_args: (:)) = {
  let data = ()
  let row_idx = 0
  let layout_func = ((c) => c,) * n_columns

  for op in operations {
    if op._kind == "easytable.push_row" {
      // validation
      if op.data.len() != n_columns {
        panic(
          "# of columns does not match. expected " + str(n_columns) + ", got " + str(op.data.len()),
        )
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
      if op.layout.len() != n_columns {
        panic(
          "# of columns does not match. expected " + str(n_columns) + ", got " + str(op.layout.len()),
        )
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

  gridx(columns: columns, ..tablex_extra_args, ..data)
}

#let hline_tb(operations, stroke: 0.8pt) = {
  (
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    ..operations,
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
  )
}

#let rectbox(operations, stroke: 1.0pt) = {
  (
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    (_kind: "easytable.push_vline", args: (stroke: stroke)),
    ..operations,
    (_kind: "easytable.push_hline", args: (stroke: stroke)),
    (_kind: "easytable.push_vline", args: (stroke: stroke)),
  )
}

/// テーブルを作成する。
///
/// - tablex_extra_args (dict, (:)): tablex 生成時に `tablex` にわたすキーワード引数。
/// - body (array, (:)): テーブルのデータやレイアウト設定など。
#let easytable(decoration: hline_tb, tablex_extra_args: (:), body) = {
  let n_column_detector = body.find(
    (c)=> ("easytable.set_layout", "easytable.push_row", "easytable.set_column").contains(c._kind),
  )

  if n_column_detector == none {
    panic("empty table, # of n_column_detector cannot be determined.")
  }

  let n_columns = n_column_detector.length
  let columns = {
    let op_set_column = body.find(c => c._kind == "easytable.set_column")
    if op_set_column == none {
      n_columns
    } else {
      op_set_column.value
    }
  }

  body = decoration(body)
  _easytable_processor(n_columns, columns, body, tablex_extra_args: tablex_extra_args)
}

/// Sets column width.
///
/// - ..columns (length or auto): column の長さ
#let cwidth(..columns) = {
  ((
    _kind: "easytable.set_column",
    length: columns.pos().len(),
    value: columns.pos(),
  ),)
}

/// Sets column style.
///
/// - ..columns (function or alignment): column のレイアウトを決める関数または alignment
#let cstyle(..columns) = {
  let layout_func = columns.pos().map((e) => {
    if type(e) == "alignment" {
      return _content => align(e, _content)
    } else {
      return e
    }
  })
  ((
    _kind: "easytable.set_layout",
    length: layout_func.len(),
    layout: layout_func,
  ),)
}

/// Add table row data.
///
/// - trans (function, none): 与えられた関数に従ってセル要素を変換する。関数には変換前のコンテンツが引数として渡される。
/// - trans_by_idx (function, none): 与えられた関数に従ってセル要素を変換する。関数にはセルの番地と変換前のコンテンツが引数として渡される。
/// - cell_style (function, none): 与えられた関数に従ってセルのスタイルを変換する。関数にはセルの番地が引数として渡される。
#let td(trans: none, trans_by_idx: none, cell_style: none, ..columns) = {
  let cell_trans = if trans != none {
    (x: none, y: none, c) => trans(c)
  } else if trans_by_idx != none {
    trans_by_idx
  } else {
    none
  }
  ((
    _kind: "easytable.push_row",
    length: columns.pos().len(),
    data: columns.pos(),
    cell_style: cell_style,
    cell_trans: cell_trans,
  ),)
}

/// Add table row data.
///
/// - ..args (dict, (:)): `tablex` の hlinex に渡す引数。
#let hline(..args) = ((_kind: "easytable.push_hline", args: args),)

/// Add table header.
///
/// 基本的には td と同じだが、 hline が末尾に追加される。
#let th(
  trans: text.with(weight: 700),
  trans_by_idx: none,
  cell_style: none,
  ..columns,
) = (..td(
  trans: trans,
  trans_by_idx: trans_by_idx,
  cell_style: cell_style,
  ..columns,
), ..hline(stroke: 0.5pt, expand: -2pt),)
