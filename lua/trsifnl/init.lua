local default_query = ("(comment) @Comment\n" .. "(boolean) @Boolean\n" .. "(keyword) @Keyword\n" .. "(nil) @Constant\n" .. "(number) @Number\n" .. "(string) @String\n" .. "\n" .. "((list\n" .. "   (symbol) @Conditional)\n" .. "     (match? @Conditional \"^(and|if|match|not|or|when)$\"))\n" .. "\n" .. "((list\n" .. "   (symbol) @Define)\n" .. " (match? @Define \"^(\206\187|fn|global|hashfn|include|lambda|let|local|macro|macros|partial|require|require-macros|var)$\"))\n" .. "\n" .. "((list\n" .. "   (symbol) @Function)\n" .. " (match? @Function \"^(_G|_VERSION|assert|collectgarbage|dofile|error|getmetatable|ipairs|load|loadfile|next|pairs|pcall|print|rawequal|rawget|rawlen|rawset|require|select|setmetatable|tonumber|tostring|type|xpcall|coroutine|coroutine.create|coroutine.isyieldable|coroutine.resume|coroutine.running|coroutine.status|coroutine.wrap|coroutine.yield|debug|debug.debug|debug.gethook|debug.getinfo|debug.getlocal|debug.getmetatable|debug.getregistry|debug.getupvalue|debug.getuservalue|debug.sethook|debug.setlocal|debug.setmetatable|debug.setupvalue|debug.setuservalue|debug.traceback|debug.upvalueid|debug.upvaluejoin|io|io.close|io.flush|io.input|io.lines|io.open|io.output|io.popen|io.read|io.stderr|io.stdin|io.stdout|io.tmpfile|io.type|io.write|math|math.abs|math.acos|math.asin|math.atan|math.ceil|math.cos|math.deg|math.exp|math.floor|math.fmod|math.huge|math.log|math.max|math.maxinteger|math.min|math.mininteger|math.modf|math.pi|math.rad|math.random|math.randomseed|math.sin|math.sqrt|math.tan|math.tointeger|math.type|math.ult|os|os.clock|os.date|os.difftime|os.execute|os.exit|os.getenv|os.remove|os.rename|os.setlocale|os.time|os.tmpname|package|package.config|package.cpath|package.loaded|package.loadlib|package.path|package.preload|package.searchers|package.searchpath|string|string.byte|string.char|string.dump|string.find|string.format|string.gmatch|string.gsub|string.len|string.lower|string.match|string.pack|string.packsize|string.rep|string.reverse|string.sub|string.unpack|string.upper|table|table.concat|table.insert|table.move|table.pack|table.remove|table.sort|table.unpack|utf8|utf8.char|utf8.charpattern|utf8.codepoint|utf8.codes|utf8.len|utf8.offset)$\"))\n" .. "\n" .. "((list\n" .. "   (symbol) @Label)\n" .. " (match? @Label \"^(comment|doc|eval-compiler|length|lua|not=|quote|set|set-forcibly!|tset|values)$\"))\n" .. "\n" .. "((list\n" .. "   (symbol) @PreProc)\n" .. " (match? @PreProc \"^(#|\\%|\\*|\\+|-|-\\>|-\\>\\>|-\\?\\>|-\\?\\>\\>|\\.|\\.\\.|/|//|:|\\<|\\<\\=|\\=|\\>|\\>\\=|\\~\\=|^)$\"))\n" .. "\n" .. "((list\n" .. "   (symbol) @Repeat)\n" .. " (match? @Repeat \"^(do|doto|each|for|while)$\"))\n" .. "\n" .. "((syntax_quote_form\n" .. "   \"`\" @SpecialChar))\n" .. "\n" .. "((unquote_form\n" .. "   \",\" @SpecialChar))\n")
local function has_parser(lang)
  local path_pat = ("parser/" .. lang .. ".*")
  local check = (0 < #vim.api.nvim_get_runtime_file(path_pat, false))
  if check then
    print(("tree-sitter-" .. lang .. " detected"))
  else
    print(("tree-sitter-" .. lang .. " NOT detected"))
  end
  return check
end
local function init_parser(self, lang)
  self["lang"] = lang
  self["parser"] = nil
  if has_parser(lang) then
    local path_pat = ("parser/" .. lang .. ".*")
    local lang_path = vim.api.nvim_get_runtime_file(path_pat, false)[1]
    vim.treesitter.require_language(lang, lang_path)
    self["parser"] = vim.treesitter.get_parser(0, lang)
  end
  if not self.parser then
    print("failed to initialize parser")
  end
  return self.parser
end
local function highlight_fennel(self, query, bufnr)
  if not self.parser then
    self["parser"] = init_parser(self, "fennel")
  end
  if not self.parser then
    print("failed to initialize parser")
    return nil
  else
    if (self.lang ~= "fennel") then
      print("parser was not initialized for fennel")
      return nil
    else
      local bufnr0 = (bufnr or 0)
      local query0 = (query or default_query)
      if not self.highlighter then
        self["highlighter"] = vim.treesitter.TSHighlighter.new(query0, bufnr0, "fennel")
      else
        self.highlighter.set_query(self, query0)
      end
      return self.highlighter
    end
  end
end
return {has_parser = has_parser, highlight_fennel = highlight_fennel, init_parser = init_parser}
