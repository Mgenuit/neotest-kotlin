-- Add current directory to 'runtimepath' to be able to use 'lua' files
vim.cmd([[let &rtp.=','.getcwd()]])

-- When running headless only (i.e. via Makefile command)
if #vim.api.nvim_list_uis() == 0 then
	-- Add dependenices to rtp (installed via the Makefile 'deps' command)
	local neotest_path = vim.fn.getcwd() .. "/deps/neotest"
	local plenary_path = vim.fn.getcwd() .. "/deps/plenary"
	local treesitter_path = vim.fn.getcwd() .. "/deps/nvim-treesitter"
	local mini_path = vim.fn.getcwd() .. "/deps/mini.doc.nvim"

	vim.cmd("set rtp+=" .. neotest_path)
	vim.cmd("set rtp+=" .. plenary_path)
	vim.cmd("set rtp+=" .. treesitter_path)
	vim.cmd("set rtp+=" .. mini_path)

	-- Source the plugin dependency files
	vim.cmd("runtime plugin/nvim-treesitter.lua")
	vim.cmd("runtime plugin/plenary.vim")
	vim.cmd("runtime lua/mini/doc.lua")

	-- Setup test plugin dependencies
	require("nvim-treesitter.configs").setup({
		ensure_installed = "kotlin",
		sync_install = true,
		highlight = {
			enable = false,
		},
	})
end
