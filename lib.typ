/// 版面基本设置
#let set_style(
  title_chs,
  author_chs,
  abstract_chs,
  keyword_chs,
  title_eng,
  author_eng,
  abstract_eng,
  keyword_eng,
  doc,
  bibpath,
) = {
  import "@preview/pointless-size:0.1.0": zh
  import "@preview/cuti:0.2.1": show-cn-fakebold
  import "@preview/i-figured:0.2.4"
  import "@preview/modern-nju-thesis:0.3.4": bilingual-bibliography

  show math.equation: i-figured.show-equation
  show figure: i-figured.show-figure
  show: show-cn-fakebold

  // 确定整体页面格式
  set page(
    width: 22cm,
    height: 29.7cm,
    // 页眉
    header: {
      set text(size: zh(-5))
      context {
        if calc.even(counter(page).get().first()) {    
          counter(page).display("1")
          h(1fr)
          title_chs
          h(1fr)
        } else {
          h(1fr)
          title_chs
          h(1fr)
          counter(page).display("1")
        }
      }
      line(length: 100%, stroke: (thickness: 0.5pt))
    },
    // 奇偶页不同
    margin: (inside: 4.17cm, outside: 3.17cm, y: 2.54cm),
    number-align: center,
  )
  set text(size: zh(5), font: ("Times New Roman", "Simsun"), lang: "zh")

  // 解决缩进问题，同时解决行尾间距
  set par(first-line-indent: 2em,spacing: 0.65em)
  let fake-par = {
    v(-1em)
    par("")
  }
  show math.equation.where(block: true): it=>it+fake-par // 公式后缩进
  show enum.item: it=>it+fakepar
  show list.item: it=>it+fakepar // 列表后缩进

  // 图片的标题格式
  show figure.where(
    kind: image
  ): it => {
    set text(font: ("Times New Roman", "STKaiti"), size: zh(-5))
    it
  } 

  // 表格的标题格式
  show figure.where(
    kind: table
  ): it => {
    set figure.caption(position: top)
    set text(font: ("Times New Roman", "SimHei"), weight: "bold")
    it
  } 

  // Figure 上面空出一个空格
  show figure: it => {
    pad(top: 0.5em, bottom: 0.5em)[
      #it
    ]
    fake-par // 关键的换行
  }

  // 标题的字体格式
  set heading(numbering: "1.1.1")
  show heading.where(level: 1): it => {
    set text(font: ("Times New Roman", "SimHei"), size: zh(4))
    pad(top: 0.5em, bottom: 0.5em, [
      #strong(it)
    ])
    fake-par // 关键的换行
  } 
  show heading.where(level: 2): it => {
    set text(font: ("Times New Roman", "SimHei"), size: zh(5))
    pad( [
      #strong(it)
    ])
    fake-par // 关键的换行
  }

  // 表格内字体设置
  show table.cell: it => {
    set text(font: ("Times New Roman", "Simsun"), size: zh(-5), weight: "regular")
    it
  }

  // 默认图像宽度
  set image(width: 60%)

  // 标题格式
  let title(title_str) = {
    linebreak()
    align(center, text(size: zh(-2), font: ("Times New Roman", "SimHei"))[
      #strong(title_str)
    ])
    linebreak()
  } 

  /// 作者信息，格式为一个(name,insitute)的数组
  let author(info, isEng:false) = {
    set align(center)
    let index = 1
    set text(
      size: zh(4),
      font: ("Times New Roman", "Fangsong"),
      style: if isEng { "italic" } else { "normal" },
    )
    for name in info {
      name.name
      super[#index]
      if name != info.last() {
        if isEng { ", " } else { "，" }
      }
      index += 1
    }

    linebreak()
    set text(size: zh(-5), font: ("Times New Roman", "STKaiti"))
    index = 1
    if isEng { "(" } else { "（" }
    for value in info {
      str(index)
      ". "
      value.insitute
      if isEng { ";" } else { "；" }
      if value != info.last() {
        linebreak()
      }
      index += 1
    }
    if isEng { ")" } else { "）" }
    linebreak()
  }

  // 摘要格式
  let abstract(leading, string) = {
    set text(size: zh(-5))
    pad(left: 2em, right: 2em, {
      text(font: ("Times New Roman", "SimHei"))[*#leading*]
      text(font: ("Times New Roman", "STKaiti"))[#string]
    })
  }

  
  title(title_chs)
  author(author_chs)
  abstract("摘要：", abstract_chs)
  abstract("关键词：", keyword_chs)
  title(title_eng)
  author(author_eng, isEng: true)
  abstract("Abstract: ", abstract_eng)
  abstract("Keywords: ", keyword_eng)
  linebreak()
  
  doc

  bilingual-bibliography(
    bibliography: bibpath
  )
}


