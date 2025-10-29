-- spec/rocksmarker/editor_spec.lua

local helper = require("spec.helper")
local editor = require("utils.editor")

describe("utils.editor", function()
  before_each(function()
    vim.cmd("enew | file TestBuffer") -- Create a new buffer with a name
  end)

  after_each(function()
    helper.teardown()
  end)

  describe("is_buffer_modified", function()
    it("should return false for an unmodified buffer", function()
      assert.is_false(editor.is_buffer_modified())
    end)

    it("should return true for a modified buffer", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test line" })
      assert.is_true(editor.is_buffer_modified())
    end)
  end)

  describe("save_current_buffer", function()
    it("should notify when there are no changes to save", function()
      local original_notify = vim.notify
      local notify_called = false
      local notify_message = ""
      local notify_level = nil

      vim.notify = function(msg, level, opts)
        notify_called = true
        notify_message = msg
        notify_level = level
      end

      editor.save_current_buffer()

      vim.notify = original_notify

      assert.is_true(notify_called, "vim.notify was not called")
      assert(
        notify_message:lower():find("no changes to") ~= nil,
        string.format("Expected message to contain 'no changes to', got '%s'", notify_message:lower())
      )
      assert.equals(vim.log.levels.WARN, notify_level)
    end)

    it("should save and notify when buffer is modified", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test line" })

      local original_notify = vim.notify
      local notify_called = false
      local notify_message = ""
      local notify_level = nil

      vim.notify = function(msg, level, opts)
        notify_called = true
        notify_message = msg
        notify_level = level
      end

      editor.save_current_buffer()

      vim.notify = original_notify

      assert.is_true(notify_called, "vim.notify was not called")
      assert(
        notify_message:lower():find("saved") ~= nil,
        string.format("Expected message to contain 'saved', got '%s'", notify_message:lower())
      )
      assert.equals(vim.log.levels.INFO, notify_level)
    end)

    it("should save and notify when buffer is modified", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test line" })

      -- Save the original vim.notify function
      local original_notify = vim.notify
      -- Variables to record calls to vim.notify
      local notify_called = false
      local notify_message = ""
      local notify_level = nil

      -- Replace vim.notify with a custom function
      vim.notify = function(msg, level, opts)
        notify_called = true
        notify_message = msg
        notify_level = level
      end

      -- Execute the function to test
      editor.save_current_buffer()

      -- Restore the original vim.notify function
      vim.notify = original_notify

      -- Verify that vim.notify was called with the expected parameters
      assert.is_true(notify_called, "vim.notify was not called")
      assert(
        notify_message:lower():find("buffer 'testbuffer' saved") ~= nil,
        string.format("Expected message to contain 'buffer 'testbuffer' saved', got '%s'", notify_message:lower())
      )
      assert.equals(vim.log.levels.INFO, notify_level)
    end)
  end)

  describe("create_new_buffer", function()
    it("should create a new buffer if current buffer is not modified", function()
      local buf_count_before = #vim.api.nvim_list_bufs()
      -- Mock vim.ui.select to automatically choose "Create Without Saving" if prompted
      local original_ui_select = vim.ui.select
      vim.ui.select = function(items, opts, on_choice)
        on_choice("Create Without Saving")
      end

      editor.create_new_buffer()

      -- Restore the original vim.ui.select function
      vim.ui.select = original_ui_select

      local buf_count_after = #vim.api.nvim_list_bufs()
      assert.equals(buf_count_before + 1, buf_count_after)
    end)

    it("should prompt to save or discard changes if current buffer is modified", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test line" })

      -- Save the original vim.ui.select function
      local original_ui_select = vim.ui.select
      -- Variable to record calls to vim.ui.select
      local ui_select_called = false

      -- Replace vim.ui.select with a custom function
      vim.ui.select = function(items, opts, on_choice)
        ui_select_called = true
        on_choice("Cancel")
      end

      -- Execute the function to test
      editor.create_new_buffer()

      -- Restore the original vim.ui.select function
      vim.ui.select = original_ui_select

      -- Verify that vim.ui.select was called
      assert.is_true(ui_select_called, "vim.ui.select was not called")
    end)
  end)

  describe("close_current_buffer", function()
    it("should close the buffer if it is not modified", function()
      local closed = false

      -- Override vim.cmd to capture bdelete command
      local original_cmd = vim.cmd
      vim.cmd = function(command)
        if command == "bdelete" then
          closed = true
        end
        original_cmd(command)
      end

      editor.close_current_buffer()

      vim.cmd = original_cmd

      assert.is_true(closed, "Buffer was not closed")
    end)

    it("should prompt to save or discard changes if buffer is modified", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "test line" })

      local original_ui_select = vim.ui.select
      local ui_select_called = false

      vim.ui.select = function(items, opts, on_choice)
        ui_select_called = true
        on_choice("Cancel")
      end

      editor.close_current_buffer()

      vim.ui.select = original_ui_select

      assert.is_true(ui_select_called, "vim.ui.select was not called")
    end)
  end)

  describe("toggle_diagnostic_virtual_text", function()
    it("should toggle diagnostic virtual text", function()
      local initial_config = vim.diagnostic.config()
      local initial_virtual_text = initial_config.virtual_text
      editor.toggle_diagnostic_virtual_text()
      local new_config = vim.diagnostic.config()
      assert.not_equal(initial_virtual_text, new_config.virtual_text)
    end)
  end)

  describe("set_key_mapping", function()
    it("should set a key mapping with the correct options", function()
      -- Set the key mapping
      editor.set_key_mapping("n", "<leader>t", "<cmd>echo 'test'<cr>", "Test mapping")

      -- Get the key mappings for normal mode
      local keymap = vim.api.nvim_get_keymap("n")
      local found = false

      -- Search for the mapping
      for _, map in ipairs(keymap) do
        if map.lhs == " t" then -- Note the space before 't' because leader is set to space
          found = true
          assert.are.same(map.desc, "Test mapping")
          assert.is_truthy(map.noremap) -- Use is_truthy to handle both boolean and number 1
          assert.is_truthy(map.silent) -- Use is_truthy to handle both boolean and number 1
          break
        end
      end

      assert.is_true(found, "Key mapping was not found")
    end)
  end)
end)
