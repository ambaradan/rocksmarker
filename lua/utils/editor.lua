local M = {}

--- Function to set key mappings with options {{{
--- @param mode string The mode for the mapping (e.g., 'n', 'i', 'v').
--- @param lhs string The left-hand side of the mapping.
--- @param rhs string The right-hand side of the mapping.
--- @param desc string Optional description for the mapping.
function M.set_key_mapping(mode, lhs, rhs, desc)
	local opts = M.make_opt(desc)
	M.remap(mode, lhs, rhs, opts)
end

--- Local function to remap keybinding.
M.remap = function(mode, lhs, rhs, opts)
	pcall(vim.keymap.del, mode, lhs)
	return vim.keymap.set(mode, lhs, rhs, opts)
end

--- Function to create default options for key mappings.
--- @param desc string Description for the mapping.
function M.make_opt(desc)
	return {
		silent = true,
		noremap = true,
		desc = desc,
	}
end
-- }}}

--- Buffer modification control function {{{
--- @param bufnr number|nil The buffer number to check for modifications.
--- If not provided, defaults to the current buffer.
--- @return boolean True if the buffer is modified, false otherwise.
function M.is_buffer_modified(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	-- Check if buffer is valid
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	-- Try multiple methods to check modification status
	local modified = false
	-- Method 1: vim_bo
	pcall(function()
		modified = vim.bo[bufnr].modified
	end)
	-- Method 2: Direct API call with fallback
	if not modified then
		pcall(function()
			-- Method to get modified status
			modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
		end)
	end
	return modified or false
end
-- }}}

--- Saves all modified buffers in the current session {{{
--- @return nil
function M.save_all_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if M.is_buffer_modified(bufnr) then
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd("w!")
			end)
		end
	end
end
-- }}}

--- Saves the current buffer in the Neovim session {{{
--- If the buffer has unsaved changes, saves it and notifies the user.
--- Otherwise, notifies the user that there are no changes to save.
--- @return nil
function M.save_current_buffer()
	--- Get the name of the current buffer
	local buffer_name = vim.fn.bufname()

	--- Check if buffer_name is nil or empty
	if not buffer_name or buffer_name == "" then
		vim.notify("No valid buffer name found", vim.log.levels.ERROR, {
			timeout = 250,
		})
		return
	end

	--- Check if the current buffer has unsaved changes
	if M.is_buffer_modified() then
		--- Save the current buffer
		vim.cmd("write")
		--- Notify the user that the buffer was saved
		vim.notify("Buffer '" .. vim.fn.fnamemodify(buffer_name, ":t") .. "' saved", vim.log.levels.INFO, {
			timeout = 250,
		})
	else
		--- Notify the user that there are no changes to save
		vim.notify("No changes to " .. vim.fn.fnamemodify(buffer_name, ":t"), vim.log.levels.WARN, {
			timeout = 250,
		})
	end
end
-- }}}

--- Creates a new buffer in the current session {{{
--- If the current buffer has unsaved changes, prompts the user
--- to choose between saving and creating, creating without saving, or cancelling.
--- @return nil
function M.create_new_buffer()
	--- Get the current buffer number
	local current_buf = vim.api.nvim_get_current_buf()

	--- Check if the current buffer has unsaved changes
	if M.is_buffer_modified(current_buf) then
		--- Prompt the user to choose an action
		vim.ui.select({ "Save and Create", "Create Without Saving", "Cancel" }, {
			--- Display a prompt indicating that the current buffer has unsaved changes
			prompt = "Current buffer has unsaved changes:",
		}, function(choice)
			--- Handle the user's choice
			if choice == "Save and Create" then
				--- Save the current buffer
				vim.cmd("write")
				--- Create a new buffer
				vim.cmd("enew")
				--- Notify the user that the current buffer was saved and a new buffer was created
				vim.notify("Saved and created new buffer", vim.log.levels.INFO, {
					timeout = 1500,
				})
			elseif choice == "Create Without Saving" then
				--- Create a new buffer without saving the current buffer
				vim.cmd("enew!")
				--- Notify the user that a new buffer was created without saving the current buffer
				vim.notify("New buffer created without saving", vim.log.levels.WARN, {
					timeout = 1500,
				})
			else
				--- Notify the user that the new buffer creation was cancelled
				vim.notify("New buffer creation cancelled", vim.log.levels.INFO, {
					timeout = 1000,
				})
			end
		end)
	else
		--- Create a new buffer if the current buffer does not have unsaved changes
		vim.cmd("enew")
		--- Notify the user that a new buffer was created
		vim.notify("New buffer created", vim.log.levels.INFO, {
			timeout = 1000,
		})
	end
end
--- }}}

--- Closes the current buffer in the Neovim session {{{
--- If the buffer has unsaved changes, prompts the user to save before closing.
--- Otherwise, closes the buffer immediately.
--- @return nil
function M.close_current_buffer()
	--- Get the name of the current buffer
	local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(), ":t")

	--- Check if the current buffer has unsaved changes
	if M.is_buffer_modified() then
		--- Options for the user to select from
		local options = { "Save and close", "Close without saving", "Cancel" }

		--- Prompt the user to decide
		vim.ui.select(options, {
			prompt = "Buffer '" .. buffer_name .. "' has unsaved changes. Choose an option:",
			format_item = function(item)
				return item
			end,
		}, function(choice)
			if choice == "Save and close" then
				--- Save the current buffer
				M.save_current_buffer()

				--- Notify that the buffer has been closed
				vim.notify("Buffer '" .. buffer_name .. "' closed", vim.log.levels.INFO, {
					timeout = 250,
				})

				--- Close the buffer
				vim.cmd("bdelete")
			elseif choice == "Close without saving" then
				--- User chose not to save changes
				vim.notify("Buffer '" .. buffer_name .. "' closed without saving.", vim.log.levels.INFO, {
					timeout = 250,
				})
				--- Close the buffer
				vim.cmd("bdelete!")
			elseif choice == "Cancel" then
				--- User canceled the action
				vim.notify("Action canceled. Buffer '" .. buffer_name .. "' remains open.", vim.log.levels.INFO, {
					timeout = 250,
				})
				--- No action taken, buffer remains open
			end
		end)
	else
		--- If no unsaved changes, just close the buffer
		vim.cmd("bdelete")
		--- Notify that the buffer has been closed
		vim.notify("Buffer '" .. buffer_name .. "' closed", vim.log.levels.INFO, {
			timeout = 250,
		})
	end
end
--- }}}

--- Closes all buffers in the current Neovim session {{{
--- Prompts the user to choose between saving all, discarding changes,
--- or cancelling if any buffers have unsaved modifications.
--- @return nil
function M.close_all_buffers()
	--- Table to store buffer numbers with unsaved changes
	local modified_bufs = {}

	--- Iterate over all existing buffers
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		--- Check if the current buffer is modified
		if M.is_buffer_modified(bufnr) then
			--- Add the buffer number to the table if it has unsaved changes
			table.insert(modified_bufs, bufnr)
		end
	end

	--- Check if there are any buffers with unsaved changes
	if #modified_bufs > 0 then
		--- Prompt the user to choose an action
		vim.ui.select({ "Yes (Save all)", "Yes (Discard changes)", "Cancel" }, {
			--- Display a prompt indicating the number of buffers with unsaved changes
			prompt = string.format("%d buffer(s) have unsaved changes. Close all?", #modified_bufs),
		}, function(choice)
			--- Handle the user's choice
			if choice == "Yes (Save all)" then
				--- Save all modified buffers
				M.save_all_buffers()
				--- Close all buffers
				vim.cmd("%bdelete!")
				--- Notify the user that all buffers were closed with changes saved
				vim.notify(
					string.format("Closed %d buffers with saving changes", #modified_bufs),
					vim.log.levels.INFO,
					{
						timeout = 2000,
					}
				)
			elseif choice == "Yes (Discard changes)" then
				--- Close all buffers without saving changes
				vim.cmd("%bdelete!")
				--- Notify the user that all buffers were closed forcefully
				vim.notify(string.format("Closed %d buffers forcefully", #modified_bufs), vim.log.levels.WARN, {
					timeout = 2000,
				})
			else
				--- Notify the user that the close all buffers action was cancelled
				vim.notify("Close all buffers cancelled", vim.log.levels.INFO, {
					timeout = 1000,
				})
			end
		end)
	else
		--- Close all buffers if there are no unsaved changes
		vim.cmd("%bdelete")
		--- Notify the user that all buffers were closed
		vim.notify("All buffers closed", vim.log.levels.INFO, {
			timeout = 1000,
		})
	end
end
--- }}}

--- Diagnostic Toggle {{{

--- @desc Toggles diagnostic virtual text on or off.
--- @params None
function M.toggle_diagnostic_virtual_text()
	--- Get the current diagnostic configuration.
	local current_config = vim.diagnostic.config() or { virtual_text = false }
	--- Toggle the virtual text state.
	local new_virtual_text = not current_config.virtual_text
	--- Update the diagnostic configuration with the new virtual text state.
	vim.diagnostic.config({ virtual_text = new_virtual_text })
	--- Notify the user about the new state of diagnostic virtual text.
	vim.notify("Diagnostic virtual text: " .. (new_virtual_text and "ON" or "OFF"))
end

--- @desc Creates a user command to toggle diagnostics.
--- @params None
--- @usage Call the `:ToggleDiagnostics` command in Neovim to toggle diagnostic virtual text.
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
	M.toggle_diagnostic_virtual_text()
end, {})

--- }}}

-- - Persisted - Get session file name and session name {{{

function M.get_session_names()
	local session_file_name = vim.fn.fnamemodify(vim.g.persisted_loaded_session, ":t")
	local clean_session_name = session_file_name:match(".*%%(.*)") or session_file_name

	return session_file_name, clean_session_name
end

-- }}}

return M
