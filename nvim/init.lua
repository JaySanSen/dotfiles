-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- will show line number
vim.opt.number = true

-- will make the numbers relative for easier navigation
vim.opt.relativenumber = true

-- Set Tab to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Enable auto indenting and set it to spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 2


-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- will use the system clipboard. it is being scheduled because it can increase startup time
vim.schedule(function()
  vim.o.clipboard = 'unnamed,unnamedplus'
end)

-- will highlight the line the cursor is currently one
vim.opt.cursorline = true

--will enable mouse
vim.opt.mouse = 'a'

-- highlight text when copying
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when copying text',
  group = vim.api.nvim_create_augroup('highlight-yanked-text', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.opt.scrolloff = 8

vim.opt.guicursor = {
	"n-v-c:block", -- Normal, visual, command-line: block cursor
	"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
	"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
	"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
--	"a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
--	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
}
