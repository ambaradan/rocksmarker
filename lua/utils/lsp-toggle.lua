local M = {}

-- Function to check if an LSP client is active
local function is_lsp_active(client_name)
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.name == client_name then
			return true
		end
	end
	return false
end

-- Function to enable `harper_ls`
function M.enable_harper_ls()
	if not is_lsp_active("harper_ls") then
		vim.cmd("LspStart harper_ls")
		vim.notify("harper_ls enabled", vim.log.levels.INFO)
	else
		vim.notify("harper_ls is already active", vim.log.levels.WARN)
	end
end

-- Function to disable `harper_ls`
function M.disable_harper_ls()
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.name == "harper_ls" then
			vim.lsp.stop_client(client.id, true)
			vim.notify("harper_ls disabled", vim.log.levels.INFO)
			return
		end
	end
	vim.notify("harper_ls is not active", vim.log.levels.WARN)
end

-- Function to toggle (enable/disable) `harper_ls`
function M.toggle_harper_ls()
	if is_lsp_active("harper_ls") then
		M.disable_harper_ls()
	else
		M.enable_harper_ls()
	end
end

return M
