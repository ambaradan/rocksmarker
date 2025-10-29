-- This script configures the Language Server Protocol (LSP) settings for Neovim.

-- nvim-lspconfig settings - LSP capabilities {{{{
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAttachMap", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Lsp: " .. desc })
    end
    -- Key mappings for LSP features
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("gr", [[<cmd>Telescope lsp_references theme=ivy<cr>]], "Goto References")
    map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
    map("<leader>ds", "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>", "Document Symbols")
    map("<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>", "Workspace Symbols")

    -- Document highlight support
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
-- }}}

-- LSP capabilities configuration {{{{
local capabilities_ok, capabilities = pcall(require, "blink.cmp")
if not capabilities_ok then
  return
end
capabilities = capabilities.get_lsp_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
-- }}}

-- Setup language servers {{{{
-- Lua language server
local lua_ls_ok, lua_ls = pcall(require, "lspconfig")
if not lua_ls_ok then
  return
end

lua_ls.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      completion = {
        callSnippet = "Replace",
        displayContext = 5,
      },
      diagnostics = {
        globals = { "vim", "describe", "it", "before_each", "after_each" },
        disable = { "lowercase-global", "undefined-field" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        ignoreDir = { ".git", "node_modules" },
        maxPreload = 2000,
        preloadFileSize = 500,
      },
      format = {
        enable = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Enable",
        await = true,
        paramName = "All",
        paramType = true,
        semicolon = "SameLine",
        setType = true,
      },
    },
  },
})

-- Harper language server for grammar and style checking
lua_ls.harper_ls.setup({
  settings = {
    linters = {
      SpellCheck = true,
      SpelledNumbers = false,
      AnA = true,
      SentenceCapitalization = true,
      UnclosedQuotes = true,
      WrongQuotes = false,
      LongSentences = true,
      RepeatedWords = true,
      Spaces = true,
      Matcher = true,
      CorrectNumberSuffix = true,
    },
    codeActions = {
      ForceStable = false,
    },
    markdown = {
      IgnoreLinkTitle = false,
      IgnoreCodeBlocks = true,
      IgnoreInlineCode = true,
      CheckLists = true,
      CheckHeadings = true,
    },
    diagnosticSeverity = "hint",
    isolateEnglish = true,
  },
})

-- Taplo LSP configuration for TOML files
lua_ls.taplo.setup({
  settings = {
    format = {
      enable = true,
    },
    completion = {
      enable = true,
      triggerCharacters = { ".", '"', "'" },
    },
    diagnostics = {
      enable = true,
      severity = "Error",
    },
    schema = {
      enable = false,
    },
  },
  filetypes = { "toml" },
})

-- Marksman LSP for Markdown
lua_ls.marksman.setup({})
-- }}}

-- Mason LSP-related {{{{
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  return
end
mason.setup({})

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  return
end
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "html",
    "cssls",
    "marksman",
    "harper_ls",
    "yamlls",
    "bashls",
    "taplo",
    "jsonls",
    "vimls",
  },
  handlers = {
    function(server_name)
      lua_ls[server_name].setup({
        capabilities = capabilities,
      })
    end,
  },
})

-- Mason tool installer for additional tools
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
  return
end
mason_tool_installer.setup({
  ensure_installed = {
    "markdownlint",
    "vale",
    "stylua",
    "shfmt",
    "yamlfmt",
    "shellcheck",
    "prettier",
    "yamllint",
    "jsonlint",
    "vint",
  },
})
-- }}}

-- Autocompletion features - blink.cmp {{{{
local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
if not blink_cmp_ok then
  return
end
blink_cmp.setup({
  keymap = {
    preset = "super-tab",
    ["<ESC>"] = { "cancel", "fallback" },
  },
  cmdline = {
    keymap = { preset = "default" },
  },
  fuzzy = { implementation = "lua" },
})
-- }}}

-- Function and command for Harper LSP
pcall(require, "utils.lsp_toggle")
