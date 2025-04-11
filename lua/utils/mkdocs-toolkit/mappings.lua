-- File: mappings.lua
-- Description: File with Neovim commands and key mappings

local mkdocs = require("utils.mkdocs-toolkit.main")
local venv = require("utils.mkdocs-toolkit.utils")

vim.api.nvim_create_user_command("MkdocsRockyDocsSetup", mkdocs.rockydocs, {})
vim.api.nvim_create_user_command("MkdocsMaterialSetup", mkdocs.material, {})
vim.api.nvim_create_user_command("MkdocsStandardSetup", mkdocs.new_project, {})
vim.api.nvim_create_user_command("MkdocsServe", mkdocs.serve, {})
vim.api.nvim_create_user_command("MkdocsStop", mkdocs.stop_serve, {})
vim.api.nvim_create_user_command("MkdocsBuild", mkdocs.build, {})
vim.api.nvim_create_user_command("MkdocsStatus", mkdocs.mkdocs_status, {})

vim.api.nvim_create_user_command("PyVenvCreate", venv.create, {})
vim.api.nvim_create_user_command("PyVenvActivate", venv.activate, {})
vim.api.nvim_create_user_command("PyVenvDeactivate", venv.deactivate, {})
vim.api.nvim_create_user_command("PyVenvStatus", function()
	vim.notify(venv.status(), vim.log.levels.INFO)
end, {})
vim.api.nvim_create_user_command("PyVenvList", venv.list, {})
vim.api.nvim_create_user_command("PyVenvRemove", venv.remove, {})
