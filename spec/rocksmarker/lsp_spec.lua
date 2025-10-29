-- spec/lsp_spec.lua
local helpers = require("plenary.busted")

describe("LSP setup", function()
  -- Store original functions to restore them later
  local original_pcall = pcall
  local original_require = require
  local original_nvim_create_autocmd = vim.api.nvim_create_autocmd
  local original_nvim_create_augroup = vim.api.nvim_create_augroup
  local original_keymap_set = vim.keymap.set
  local original_lsp_get_client_by_id = vim.lsp.get_client_by_id

  before_each(function()
    -- Clear the test environment
    helpers.clear()
    -- Reset require to avoid caching issues
    package.loaded["plenary.busted"] = nil
    package.loaded["luassert"] = nil
  end)

  after_each(function()
    -- Restore original functions
    pcall = original_pcall
    require = original_require
    vim.api.nvim_create_autocmd = original_nvim_create_autocmd
    vim.api.nvim_create_augroup = original_nvim_create_augroup
    vim.keymap.set = original_keymap_set
    vim.lsp.get_client_by_id = original_lsp_get_client_by_id
  end)

  -- Set the path to the LSP configuration file
  local lsp_script_path = vim.fn.getcwd() .. "/lua/plugins/lsp.lua"

  describe("LSP attach event", function()
    it("should set up key mappings and document highlight", function()
      -- Mock `vim.api.nvim_create_augroup`
      vim.api.nvim_create_augroup = function(name, opts)
        assert(name == "LspAttachMap", "Expected augroup name 'LspAttachMap'")
        assert(opts.clear == true, "Expected opts.clear to be true")
        return 1
      end

      -- Mock `vim.api.nvim_create_autocmd` to track calls
      local autocmd_calls = {}
      vim.api.nvim_create_autocmd = function(event, opts)
        table.insert(autocmd_calls, { event = event, opts = opts })
      end

      -- Mock `vim.keymap.set` to track calls
      local keymap_calls = {}
      vim.keymap.set = function(mode, keys, func, opts)
        table.insert(keymap_calls, { mode = mode, keys = keys, func = func, opts = opts })
      end

      -- Mock `vim.lsp.get_client_by_id`
      vim.lsp.get_client_by_id = function(client_id)
        return {
          server_capabilities = {
            documentHighlightProvider = true,
          },
        }
      end

      -- Mock `vim.lsp.buf` functions
      vim.lsp.buf = {
        definition = function() end,
        hover = function() end,
        signature_help = function() end,
        rename = function() end,
        code_action = function() end,
        declaration = function() end,
        document_highlight = function() end,
        clear_references = function() end,
      }

      -- Mock `telescope.builtin`
      _G.require = function(mod)
        if mod == "telescope.builtin" then
          return {
            lsp_references = function() end,
            lsp_implementations = function() end,
            lsp_type_definitions = function() end,
            lsp_document_symbols = function() end,
            lsp_dynamic_workspace_symbols = function() end,
          }
        end
        return original_require(mod)
      end

      -- Check if the file exists
      local f = io.open(lsp_script_path, "r")
      assert(f ~= nil, "File not found: " .. lsp_script_path)
      if f then
        f:close()
      end

      -- Load the LSP setup script
      dofile(lsp_script_path)

      -- Verify autocmd for LspAttach was created
      local lsp_attach_call = autocmd_calls[1]
      assert(lsp_attach_call.event == "LspAttach", "Expected LspAttach event")
      assert(type(lsp_attach_call.opts.callback) == "function", "Expected callback function")

      -- Simulate LspAttach event
      local event = { buf = 1, data = { client_id = 1 } }
      lsp_attach_call.opts.callback(event)

      -- Verify keymaps were set
      assert(#keymap_calls > 0, "Expected keymaps to be set")
      for _, call in ipairs(keymap_calls) do
        assert(call.mode == "n", "Expected mode to be 'n'")
        assert(type(call.keys) == "string", "Expected keys to be a string")
        assert(type(call.opts) == "table", "Expected opts to be a table")
        assert(call.opts.buffer == event.buf, "Expected buffer to match event.buf")
        assert(string.match(call.opts.desc, "^Lsp: ") ~= nil, "Expected desc to start with 'Lsp: '")
      end

      -- Verify document highlight autocmds were created
      assert(#autocmd_calls >= 3, "Expected at least 3 autocmd calls") -- LspAttach + CursorHold + CursorMoved
    end)
  end)

  describe("LSP capabilities setup", function()
    it("should configure LSP capabilities", function()
      -- Mock `require` to simulate blink.cmp
      require = function(mod)
        if mod == "blink.cmp" then
          return {
            get_lsp_capabilities = function()
              return {
                textDocument = {
                  completion = {
                    completionItem = {},
                  },
                },
              }
            end,
          }
        end
        return original_require(mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        return original_pcall(func)
      end

      -- Load the LSP setup script
      dofile(lsp_script_path)
    end)
  end)

  describe("LSP server setup", function()
    it("should set up Lua language server", function()
      -- Mock `require` to simulate lspconfig
      local lspconfig_calls = {}
      require = function(mod)
        if mod == "lspconfig" then
          return setmetatable({}, {
            __index = function(_, server_name)
              return {
                setup = function(config)
                  table.insert(lspconfig_calls, { server_name = server_name, config = config })
                end,
              }
            end,
          })
        end
        return original_require(mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        return original_pcall(func)
      end

      -- Load the LSP setup script
      dofile(lsp_script_path)

      -- Verify servers were set up
      assert(#lspconfig_calls > 0, "Expected at least one server to be set up")
      for _, call in ipairs(lspconfig_calls) do
        assert(type(call.config.capabilities) == "table", "Expected capabilities to be a table")
      end
    end)
  end)

  describe("Mason setup", function()
    it("should set up Mason and Mason LSP config", function()
      -- Mock `require` to simulate mason and mason-lspconfig
      local mason_calls = {}
      require = function(mod)
        if mod == "mason" then
          return {
            setup = function(config)
              table.insert(mason_calls, { mod = mod, config = config })
            end,
          }
        elseif mod == "mason-lspconfig" then
          return {
            setup = function(config)
              table.insert(mason_calls, { mod = mod, config = config })
            end,
          }
        elseif mod == "mason-tool-installer" then
          return {
            setup = function(config)
              table.insert(mason_calls, { mod = mod, config = config })
            end,
          }
        end
        return original_require(mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        return original_pcall(func)
      end

      -- Load the LSP setup script
      dofile(lsp_script_path)

      -- Verify Mason setups were called
      assert(#mason_calls > 0, "Expected Mason setups to be called")
    end)
  end)

  describe("blink.cmp setup", function()
    it("should set up blink.cmp", function()
      -- Mock `require` to simulate blink.cmp
      local blink_cmp_calls = {}
      require = function(mod)
        if mod == "blink.cmp" then
          return {
            setup = function(config)
              table.insert(blink_cmp_calls, config)
            end,
            get_lsp_capabilities = function()
              return {
                textDocument = {
                  completion = {
                    completionItem = {},
                  },
                },
              }
            end,
          }
        end
        return original_require(mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        return original_pcall(func)
      end

      -- Load the LSP setup script
      dofile(lsp_script_path)

      -- Verify blink.cmp was set up
      assert(#blink_cmp_calls > 0, "Expected blink.cmp to be set up")
      assert(type(blink_cmp_calls[1].keymap) == "table", "Expected keymap to be a table")
      assert(type(blink_cmp_calls[1].cmdline) == "table", "Expected cmdline to be a table")
      assert(type(blink_cmp_calls[1].fuzzy) == "table", "Expected fuzzy to be a table")
    end)
  end)
end)
