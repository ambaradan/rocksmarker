-- lua/utils/persisted.lua

local M = {}

--- Get session file name and session name
--- @return string, string The session file name and cleaned session name
function M.get_session_names()
	local session_file_name = vim.fn.fnamemodify(vim.g.persisted_loaded_session, ":t")
	local clean_session_name = session_file_name:match(".*%%(.*)") or session_file_name

	return session_file_name, clean_session_name
end

return M
