-- lua/plugins/markdown.lua

-- mkdocs-material settings
local mkdocs_ok, mkdocs_material = pcall(require, "mkdocs_material")
if mkdocs_ok then
  mkdocs_material.setup({})
end
-- }}}

-- render-markdown.nvim settings {{{
local render_ok, render_markdown = pcall(require, "render-markdown")
if not render_ok then
  return
end

render_markdown.setup({
  heading = {
    sign = false,
    icons = { "⌂ ", "¶ ", "§ ", "❡ ", "⁋ ", "※ " },
    width = "block",
    border = true,
    border_virtual = true,
    left_pad = 2,
    right_pad = 4,
  },
  code = { sign = false, width = "block", left_pad = 2, right_pad = 4, min_width = 45 },
  pipe_table = { style = "normal" },
  latex = { enabled = false },
})

-- markdown-plus.nvim settings
local markdown_plus_ok, markdown_plus = pcall(require, "markdown-plus")
if markdown_plus_ok then
  markdown_plus.setup({})
end

-- markdown-table-mode.nvim settings
local table_mode_ok, table_mode = pcall(require, "markdown-table-mode")
if not table_mode_ok then
  return
end

table_mode.setup({
  filetype = {
    "*.md",
  },
  options = {
    insert = true, -- when typing "|"
    insert_leave = true, -- when leaving insert mode
  },
})
