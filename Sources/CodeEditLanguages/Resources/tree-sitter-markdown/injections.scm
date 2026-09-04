(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content (#set! injection.language "html"))

(document . (section . (thematic_break) (_) @injection.content (thematic_break)) (#set! injection.language "yaml"))

([(minus_metadata) (plus_metadata)] @injection.content (#set! injection.language "yml"))

;; Skipper patch: paragraphs only, NOT every (inline) node.
;;
;; The editor gives an injected layer EXCLUSIVE ownership of its range — the
;; parent layer is not even queried there. A heading's text is an (inline) node,
;; so injecting into every (inline) handed headings to the inline grammar, which
;; has no rule for them, and `(atx_heading (inline) @text.title)` above never got
;; a chance to run: every heading in every .md file rendered as plain body text.
;; Paragraphs carry the emphasis, links and code spans the inline grammar exists
;; for, and list items and block quotes contain paragraphs, so they keep it too.
((paragraph (inline) @injection.content) (#set! injection.language "markdown_inline"))
