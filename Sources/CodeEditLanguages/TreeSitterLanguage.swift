//
//  TreeSitterLanguage.swift
//  CodeEditTextView/CodeLanguage
//
//  Created by Lukas Pistrol on 25.05.22.
//

import Foundation

/// A collection of languages that are supported by `tree-sitter`
public enum TreeSitterLanguage: String, CaseIterable {
    case agda
    case bash
    case c
    case cpp
    case cSharp
    case css
    case dart
    case dockerfile
    case elixir
    case go
    case goMod
    case haskell
    case html
    case java
    case javascript
    case jsdoc
    case json
    case jsx
    case julia
    case kotlin
    case lua
    case markdown
    case markdownInline
    case objc
    case ocaml
    case ocamlInterface
    case perl
    case php
    case python
    case regex
    case ruby
    case rust
    case scala
    case sql
    case swift
    case toml
    case tsx
    case typescript
    case verilog
    case yaml
    case zig
    case plainText
}

// MARK: - Naming a language the way a query does (Skipper patch)

public extension TreeSitterLanguage {
    /// Resolves the language name written INSIDE a tree-sitter query — an
    /// `injections.scm` directive, or the info string of a fenced code block.
    ///
    /// `init(rawValue:)` is the wrong door for that name and silently answered
    /// `nil`. Queries spell languages the way tree-sitter repositories do —
    /// snake_case — while this enum spells them the way Swift does, camelCase,
    /// so `markdown_inline` never matched `markdownInline`. The whole of
    /// markdown's inline layer (every bold, italic, link and inline code span
    /// in every .md file) was dropped on that mismatch, and dropping an
    /// injection is not an error: the text is simply left unhighlighted. Same
    /// mismatch, same silence, for `c_sharp` and `go_mod`.
    ///
    /// The info string of a fenced block is written by a HUMAN, so it also
    /// arrives as ```js, ```sh, ```c++ — spellings no enum case will ever
    /// carry. Both problems are one question ("what did this text mean") and
    /// get one answer here.
    init?(injectionName: String) {
        let normalized = Self.normalize(injectionName)
        guard !normalized.isEmpty else { return nil }
        if let alias = Self.aliases[normalized] {
            self = alias
            return
        }
        guard let match = Self.allCases.first(where: { Self.normalize($0.rawValue) == normalized })
        else { return nil }
        self = match
    }

    /// Case and separators carry no meaning in either spelling, so both sides
    /// are reduced to letters and digits before they are compared.
    private static func normalize(_ name: String) -> String {
        name.lowercased().filter { $0.isLetter || $0.isNumber }
    }

    /// Spellings that are not the enum's name with different punctuation, and
    /// so cannot be derived — only listed. Keys are already normalized.
    private static let aliases: [String: TreeSitterLanguage] = [
        "yml": .yaml,
        "sh": .bash, "shell": .bash, "zsh": .bash, "bashrc": .bash,
        "js": .javascript, "jsx": .javascript, "mjs": .javascript, "cjs": .javascript,
        "ts": .typescript,
        "py": .python, "python3": .python,
        "rb": .ruby,
        "rs": .rust,
        "golang": .go,
        "cc": .cpp, "cxx": .cpp, "cplusplus": .cpp,
        "cs": .cSharp,
        "objectivec": .objc, "objectivecpp": .objc,
        "kt": .kotlin, "kts": .kotlin,
        "md": .markdown, "markdowninline": .markdownInline,
        "dockerfile": .dockerfile,
        "text": .plainText, "plaintext": .plainText, "txt": .plainText
    ]
}
