local M = {}

-- Configuration
M.config = {
	venvs_dir = vim.fn.stdpath("data") .. "/venvs",
	preserved_paths = {
		vim.fn.stdpath("data") .. "/mason/bin",
		"/usr/local/bin",
		"/usr/bin",
		os.getenv("HOME") .. "/.local/bin",
		server_job_id = nil,
	},
}

-- State management
M.state = {
	original_path = vim.env.PATH,
	original_python_path = vim.fn.exepath("python"),
	active = false,
}

return M
