#let style(it) = {
show heading: set text(weight: "medium", fill: rgb("#555555"))
show cite: set text(fill: rgb("#014D4e"))
show link: set text(fill: blue)
show figure.caption: set text(9pt)
show table.cell: set text(size: 1em, font: "Libertinus Serif", weight: "light")
show table.cell.where(x: 0): set text(weight: "medium")
show table.cell.where(y: 0): set text(weight: 500, size: 1em)
show table.cell: it => {
  if it.y == 0 {
    strong(it)
  } 
  else {
    if it.x == 0 {
      it
    }
    else {
      it
    }
  }
}
set text(hyphenate: false, size: 10pt
)
set par(first-line-indent: 1em,
leading: 0.75em,
justify: true) 

set heading(numbering: none, )
show heading: set block(below: 0.75em)

show heading: set text(weight: 600)
show heading: set par(leading: 0.4em)
show heading.where(level: 1): set text(
  size:12pt, 
  fill: rgb("81cdc6").darken(50%)
)
show heading.where(level: 2): set text(
  size:11pt,
  weight: 600,
  fill: rgb("#81cdc6").darken(40%)
)
show heading.where(level: 3): set text(
  size:11pt,
    weight: 200,
  fill: rgb("#81cdc6").darken(20%)
)


it 
}
