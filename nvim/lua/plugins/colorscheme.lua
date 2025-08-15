return{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
--    vim.cmd[[colorscheme tokyonight-night]]
    require('tokyonight').setup({
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
      }
    })
    vim.cmd[[colorscheme tokyonight-night]]
  end
}

