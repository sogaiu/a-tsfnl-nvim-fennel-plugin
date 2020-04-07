# a-tsfnl-nvim-fennel-plugin

A demo of using tree-sitter-fennel to highlight code in neovim (>= 0.5)

## Prerequisites

* fennel
* neovim (>= 0.5)
* tree-sitter-fennel

## Prepare

* Install neovim (>= 0.5) or rather the master branch of neovim as 0.5
  is not released yet (tested with 30a6e374).

* Follow the instructions through "Initial Setup" step of
  [tree-sitter-fennel](https://github.com/sogaiu/tree-sitter-fennel).
  Note, you likely won't need emsdk.

* From the tree-sitter-fennel directory that was cloned, parse
  fennelview.fnl (assuming fennel source lives under ~/src):

  ```
  npx tree-sitter parse ~/src/Fennel/fennelview.fnl
  ```

  This should have prepared a `~/.tree-sitter` directory and copied a
  `fennel.so` (or .dynlib or .dll) file to live under
  `~/.tree-sitter/bin`.

  The vim runtimepath is used to locate the .so|.dynlib|.dll file, so
  to arrange for that to succeed, one could symlink
  `~/.tree-sitter/bin` to a place such as `~/.config/nvim/parser`:

  ```
  cd ~/.config/nvim
  ln -s ~/.tree-sitter/bin parser # assuming nothing named parser exists
  ```

  Here `~/.config/nvim` is assumed to be on the vim runtimepath,
  substitute something else if this particular choice is undesirable.

* Clone this repository somewhere appropriate:

  ```
  git clone https://github.com/sogaiu/a-tsfnl-nvim-fennel-plugin
  ```

* Start neovim with the cloned directory on the vim runtime path:

  ```
  nvim --cmd "set rtp+=./a-tsfnl-nvim-fennel-plugin"
  ```

* Turn off syntax highlighting:

  ```
  :syntax off
  ```

* Open fennelview.fnl:

  ```
  :edit ~/src/Fennel/fennelview.fnl
  ```

  The file should look pretty plain, i.e. no syntax highlighting.

## Demo

* Use tree-sitter-fennel to highlight the buffer by entering `<M-C-H>`
  (see `plugin/a-tsfnl-nvim-fennel-plugin.fnl` if another key sequence
  needs to be used).

  Alternatively, one can:

  ```
  :lua trsifnl:highlight_fennel()<CR>
  ```

  The text `tree-sitter-fennel detected` should appear at the bottom
  of the screen if all went well, and the buffer should now have more
  color in it.

  [screenshot](a-tsfnl-nvim-fennel-plugin.png)

## Hacking

* Tweaking of highlighting can be done by editing the value of
  `default-query` in `fnl/trsifnl/init.fnl`.

*  Be sure to compile to lua after editing:

   ```
   fennel --compile fnl/trsifnl/init.fnl > lua/trsifnl/init.lua
   ```

* Alternatively, directly modify `lua/trsifnl/init.lua` while tweaking
  and port the changes back to `fnl/trsifnl/init.fnl`.

## Thanks

* bakpakin - fennel and fennel.vim
* bfredl - neovim and tree-sitter work
* jacobsimpson - nvim-example-lua-plugin
* morhetz - gruvbox
* Olical - discussion and suggestions
* SevereOverfl0w - tree-sitter and vim info
* technomancy - fennel, fennel-mode, and related articles
