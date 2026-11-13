#let showtitle(title) = {    
    text(size: 18pt, fill: rgb("#008080"), weight: "medium")[#par(text(title,), leading: 0.2em)]  
}

#let showabstract(abstract) = {
  heading(
        outlined: false,
        numbering: none,
        text(
          0.75em,     
          font: "Libertinus Serif",
          fill: rgb("#014D4e"),
          smallcaps[Abstract]
        ),
  )
  par(first-line-indent: 0em)[
    #text( 
      size: 0.95em
    )[#abstract]
  ]
}


#let showauthors(authors, institutions, corresponding_email) = {

for person in authors.keys() [
  #text(size: 1em)[#person#for x in authors.at(person).affiliations {  
  let pos = institutions.keys().position(y => y == x) + 1
    super()[#pos]
    if institutions.keys().at(institutions.keys().position(y => y == x)) != authors.at(person).affiliations.last()  {super()[,]}
  }#if person != authors.keys().last(){","}]
]

v(0.25em)

text(size: 0.85em)[Corresponding Author: #corresponding_email]

v(1em)

for (i,inst) in institutions.keys().enumerate() {
  let pos = institutions.keys().position(y => y == inst) + 1
  text(0.8em, rgb("#222"))[#super()[#text(size: 1.2em, weight: "bold")[#pos ]]#institutions.at(inst)]
    if institutions.keys().last() != inst {text(size: 0.7em, font: "Libertinus Serif")[, ]}
  }
}

#let showbibliography(file) = {
  pagebreak()
  text(size: 0.95em)[
    #bibliography(file, title: "References", style: "springer-basic-author-date")
  ]
}

#let note(author, body, color : orange) = {
  text(color)[(Note from #author: #body)]
}
