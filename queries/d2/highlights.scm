; D2 語法高亮規則
; 基於 ravsii/tree-sitter-d2 的節點結構

; 註解
(comment) @comment

; 節點識別符
(identifier) @variable

; 連線符號
(arrow) @operator
"->" @operator
"--" @operator
"<->" @operator

; 屬性鍵值
(attribute
  key: (identifier) @property)

; 字串
(string) @string

; 數字
(number) @number

; 關鍵字
"style" @keyword
"shape" @keyword
"label" @keyword

; 特殊值
"true" @boolean
"false" @boolean
"null" @constant.builtin