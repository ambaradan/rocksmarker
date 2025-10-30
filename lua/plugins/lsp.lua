-- lua/plugins/lsp.lua

-- Create an autocommand group for LSP attachments
vim.api.nvim_create_augroup("LspAttachMarkdown", { clear = true })

-- Set up the autocommand for LspAttach event
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttachMarkdown",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Check if the attached client is Marksman
    if client and client.name == "marksman" then
      local function map(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      -- Key mappings for LSP features
      map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      map("K", vim.lsp.buf.hover, "Hover Documentation")
      map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- Use Telescope for references, implementations, and symbols (if available)
      local telescope_ok, telescope = pcall(require, "telescope.builtin")
      if telescope_ok then
        map("gr", function()
          telescope.lsp_references({ theme = "ivy" })
        end, "[G]oto [R]eferences")
        map("gI", function()
          telescope.lsp_implementations({ theme = "ivy" })
        end, "[G]oto [I]mplementation")
        map("<leader>D", function()
          telescope.lsp_type_definitions({ theme = "dropdown" })
        end, "Type [D]efinition")
        map("<leader>ds", function()
          telescope.lsp_document_symbols({ theme = "dropdown" })
        end, "[D]ocument [S]ymbols")
        map("<leader>ws", function()
          telescope.lsp_dynamic_workspace_symbols({ theme = "dropdown" })
        end, "[W]orkspace [S]ymbols")
      else
        vim.notify("Telescope not installed. Some LSP features will be limited.", vim.log.levels.WARN)
      end

      -- Document highlight (if supported)
      if client.server_capabilities.documentHighlightProvider then
        local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
          callback = function(detach_event)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = detach_event.buf })
          end,
        })
      end

      -- Toggle inlay hints (if supported)
      if client.server_capabilities.inlayHintProvider then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}), { bufnr = bufnr })
        end, "[T]oggle Inlay [H]ints")
      end
    end
  end,
})

--- Get LSP capabilities with support for Markdown and other features.
---@return table The LSP client capabilities.
local function get_lsp_capabilities()
  -- Initialize with default client capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Try to extend capabilities with blink.cmp
  local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
  if blink_cmp_ok then
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
  else
    vim.notify("blink.cmp not found. Using default capabilities.", vim.log.levels.WARN)
  end

  -- Ensure the structure exists
  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.completion = capabilities.textDocument.completion or {}
  capabilities.textDocument.completion.completionItem = capabilities.textDocument.completion.completionItem or {}

  -- Extend completion item capabilities with Markdown support
  capabilities.textDocument.completion.completionItem =
    vim.tbl_deep_extend("force", capabilities.textDocument.completion.completionItem, {
      documentationFormat = { "markdown", "plaintext" }, -- Enable Markdown and plaintext documentation
      snippetSupport = true, -- Enable snippet support
      preselectSupport = true, -- Enable preselect support
      insertReplaceSupport = true, -- Enable insert/replace support
      labelDetailsSupport = true, -- Enable label details support
      deprecatedSupport = true, -- Enable deprecated items support
      commitCharactersSupport = true, -- Enable commit characters support
      tagSupport = { valueSet = { 1 } }, -- Enable tag support
      resolveSupport = {
        properties = {
          "documentation", -- Enable documentation resolution
          "detail", -- Enable detail resolution
          "additionalTextEdits", -- Enable additional text edits
        },
      },
    })

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
setup_lsp_server("marksman", {
  capabilities = get_lsp_capabilities(), -- Use extended capabilities
  filetypes = { "markdown", "md" }, -- Specify filetypes for Marksman
})

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
