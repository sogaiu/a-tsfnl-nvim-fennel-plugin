(local default-query
       (.. "(comment) @Comment\n"
           "(boolean) @Boolean\n"
           "(keyword) @Keyword\n"
           "(nil) @Constant\n"
           "(number) @Number\n"
           "(string) @String\n"
           "\n"
           "((list\n"
           "   (symbol) @Conditional)\n"
           "     (match? @Conditional \"^(and|if|match|not|or|when)$\"))\n"
           "\n"
           "((list\n"
           "   (symbol) @Define)\n"
           " (match? @Define \"^(λ|fn|global|hashfn|include|lambda|let|local|macro|macros|partial|require|require-macros|var)$\"))\n"
           "\n"
           "((list\n"
           "   (symbol) @Function)\n"
           " (match? @Function \"^(_G|_VERSION|assert|collectgarbage|dofile|error|getmetatable|ipairs|load|loadfile|next|pairs|pcall|print|rawequal|rawget|rawlen|rawset|require|select|setmetatable|tonumber|tostring|type|xpcall|coroutine|coroutine.create|coroutine.isyieldable|coroutine.resume|coroutine.running|coroutine.status|coroutine.wrap|coroutine.yield|debug|debug.debug|debug.gethook|debug.getinfo|debug.getlocal|debug.getmetatable|debug.getregistry|debug.getupvalue|debug.getuservalue|debug.sethook|debug.setlocal|debug.setmetatable|debug.setupvalue|debug.setuservalue|debug.traceback|debug.upvalueid|debug.upvaluejoin|io|io.close|io.flush|io.input|io.lines|io.open|io.output|io.popen|io.read|io.stderr|io.stdin|io.stdout|io.tmpfile|io.type|io.write|math|math.abs|math.acos|math.asin|math.atan|math.ceil|math.cos|math.deg|math.exp|math.floor|math.fmod|math.huge|math.log|math.max|math.maxinteger|math.min|math.mininteger|math.modf|math.pi|math.rad|math.random|math.randomseed|math.sin|math.sqrt|math.tan|math.tointeger|math.type|math.ult|os|os.clock|os.date|os.difftime|os.execute|os.exit|os.getenv|os.remove|os.rename|os.setlocale|os.time|os.tmpname|package|package.config|package.cpath|package.loaded|package.loadlib|package.path|package.preload|package.searchers|package.searchpath|string|string.byte|string.char|string.dump|string.find|string.format|string.gmatch|string.gsub|string.len|string.lower|string.match|string.pack|string.packsize|string.rep|string.reverse|string.sub|string.unpack|string.upper|table|table.concat|table.insert|table.move|table.pack|table.remove|table.sort|table.unpack|utf8|utf8.char|utf8.charpattern|utf8.codepoint|utf8.codes|utf8.len|utf8.offset)$\"))\n"
           "\n"
           "((list\n"
           "   (symbol) @Label)\n"
           " (match? @Label \"^(comment|doc|eval-compiler|length|lua|not=|quote|set|set-forcibly!|tset|values)$\"))\n"
           "\n"
           "((list\n"
           "   (symbol) @PreProc)\n"
           " (match? @PreProc \"^(#|\\%|\\*|\\+|-|-\\>|-\\>\\>|-\\?\\>|-\\?\\>\\>|\\.|\\.\\.|/|//|:|\\<|\\<\\=|\\=|\\>|\\>\\=|\\~\\=|^)$\"))\n"
           "\n"
           "((list\n"
           "   (symbol) @Repeat)\n"
           " (match? @Repeat \"^(do|doto|each|for|while)$\"))\n"
           "\n"
           "((syntax_quote_form\n"
           "   \"`\" @SpecialChar))\n"
           "\n"
           "((unquote_form\n"
           "   \",\" @SpecialChar))\n"))

(fn has-parser [lang]
  (let [path_pat (.. "parser/" lang ".*")
        check (< 0 (length (vim.api.nvim_get_runtime_file path_pat false)))]
    (if check
        (print (.. "tree-sitter-" lang " detected"))
        (print (.. "tree-sitter-" lang " NOT detected")))
  check))

(fn init-parser [self lang]
  (tset self "lang" lang)
  (tset self "parser" nil)
  (when (has-parser lang)
    ;; XXX: should there be platform detection (dll, dynlib, so)?
    (let [path-pat (.. "parser/" lang ".*")
          lang-path (. (vim.api.nvim_get_runtime_file path-pat false) 1)]
      ;; XXX: how to check for failure?
      (vim.treesitter.require_language lang lang-path)
      (tset self "parser" (vim.treesitter.get_parser 0 lang))))
  (when (not self.parser)
    (print "failed to initialize parser"))
  self.parser)

(fn highlight-fennel [self query bufnr]
  (when (not self.parser)
    (tset self "parser" (init-parser self "fennel")))
  (if (not self.parser)
      (do
        (print "failed to initialize parser")
        nil)
      (if (~= self.lang "fennel")
          (do
            (print "parser was not initialized for fennel")
            nil)
          (let [bufnr (or bufnr 0)
                query (or query default-query)]
            (if (not self.highlighter)
                (tset self "highlighter"
                      (vim.treesitter.TSHighlighter.new query bufnr "fennel"))
                (self.highlighter.set_query self query))
            self.highlighter))))

{"has_parser" has-parser
 "init_parser" init-parser
 "highlight_fennel" highlight-fennel}
