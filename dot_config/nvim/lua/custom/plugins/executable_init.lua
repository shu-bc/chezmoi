local plugins = {
-- ["goolord/alpha-nvim"] = { disable = false },

	-- Override plugin definition options
	["neovim/nvim-lspconfig"] = {
	config = function()
		require "plugins.configs.lspconfig"
		require "custom.plugins.lspconfig"
	end,
	},

	["jose-elias-alvarez/null-ls.nvim"] = {
	after = "nvim-lspconfig",
	config = function()
		require "custom.plugins.null-ls"
	end,
	},

	["folke/trouble.nvim"] = {
	requires = "nvim-tree/nvim-web-devicons",
	config = function()
		require "custom.plugins.trouble"
	end,
	},

	["gpanders/editorconfig.nvim"] = {},

	["tpope/vim-surround"] = {},

  ["tpope/vim-fugitive"] = {},
}

require('custom.plugins.gotest')

return plugins
