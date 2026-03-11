; Highlight call-site keyword argument names: myfunc(key=...)
(keyword_argument
  name: (identifier) @parameter.call)

; Re-enable highlighting inside f-string interpolations.
; Use higher priority to override the @none reset in the base query.
(interpolation
  (expression) @string.special
  (#set! "priority" 120))

(format_expression
  (expression) @string.special
  (#set! "priority" 120))
