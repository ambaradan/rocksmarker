-- lua/plugins/markdown.lua

-- mkdocs-material settings
local mkdocs_ok, mkdocs_material = pcall(require, "mkdocs_material")
if mkdocs_ok then
  ---@diagnostic disable-next-line: need-check-nil
  mkdocs_material.setup({})
end

-- render-markdown.nvim settings
local render_ok, render_markdown = pcall(require, "render-markdown")
if not render_ok then
  return
end

---@diagnostic disable-next-line: need-check-nil
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
  ---@diagnostic disable-next-line: need-check-nil
  markdown_plus.setup({})
end
