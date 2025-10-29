-- lua/plugins/lsp.lua

-- LspAttach autocommand for key mappings and document highlights
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup(LspAttachMap, { clear = true }),
  callback = function(event)
    -- Helper function to set keymaps for LSP features
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Key mappings for LSP features
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")

    -- Use pcall to safely require Telescope
    local telescope_ok, telescope = pcall(require, "telescope.builtin")
    if telescope_ok then
      map("gr", string.format("<cmd>Telescope lsp_references theme=%s<cr>", "ivy"), "Goto References")
      map("gI", telescope.lsp_implementations, "Goto Implementation")
      map("<leader>D", telescope.lsp_type_definitions, "Type Definition")
    else
      vim.notify("Telescope not installed. Some LSP features will be limited.", vim.log.levels.WARN)
    end

    map("<leader>ds", string.format("<cmd>Telescope lsp_document_symbols theme=dropdown<cr>"), "Document Symbols")
    map(
      "<leader>ws",
      string.format("<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>"),
      "Workspace Symbols"
    )

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

-- LSP capabilities configuration
local function get_lsp_capabilities()
  local capabilities_ok, capabilities = pcall(require, "blink.cmp")
  if not capabilities_ok then
    vim.notify("blink.cmp not found. Using default capabilities.", vim.log.levels.WARN)
    return vim.lsp.protocol.make_client_capabilities()
  end
  capabilities = capabilities.get_lsp_capabilities()

  -- Extend capabilities with additional features
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
  return capabilities
end

-- Setup language servers
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  vim.notify("lspconfig not installed.", vim.log.levels.ERROR)
  return
end

-- Helper function to setup LSP servers with error handling
local function setup_lsp_server(server_name, config)
  if not lspconfig[server_name] then
    vim.notify("LSP server not found: " .. server_name, vim.log.levels.WARN)
    return
  end
  lspconfig[server_name].setup(vim.tbl_deep_extend("force", { capabilities = get_lsp_capabilities() }, config or {}))
end

-- Lua language server
setup_lsp_server("lua_ls", {
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
      format = { enable = false },
      telemetry = { enable = false },
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
setup_lsp_server("harper_ls", {
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
    codeActions = { ForceStable = false },
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
setup_lsp_server("taplo", {
  settings = {
    format = { enable = true },
    completion = {
      enable = true,
      triggerCharacters = { ".", '"', "'" },
    },
    diagnostics = { enable = true, severity = "Error" },
    schema = { enable = false },
  },
  filetypes = { "toml" },
})

-- Marksman LSP for Markdown
setup_lsp_server("marksman", {})

-- Mason LSP-related setup
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  vim.notify("mason.nvim not installed.", vim.log.levels.ERROR)
  return
end
mason.setup({})

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  vim.notify("mason-lspconfig not installed.", vim.log.levels.ERROR)
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
      setup_lsp_server(server_name, {})
    end,
  },
})

-- Mason tool installer for additional tools
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
  vim.notify("mason-tool-installer not installed.", vim.log.levels.ERROR)
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

-- Autocompletion features - blink.cmp
local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
if not blink_cmp_ok then
  vim.notify("blink.cmp not installed.", vim.log.levels.ERROR)
  return
end

blink_cmp.setup({
  keymap = {
    preset = "super-tab",
    ["<ESC>"] = { "cancel", "fallback" },
  },
  cmdline = { keymap = { preset = "default" } },
  fuzzy = { implementation = "lua" },
})

-- Function and command for Harper LSP
local success, _ = pcall(require, "utils.lsp_toggle")
if not success then
  vim.notify("Failed to load utils.lsp_toggle", vim.log.levels.WARN)
end
