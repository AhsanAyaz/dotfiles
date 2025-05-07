vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

local function tmux_command(cmd)
  -- Use system() for potentially better handling than :!
  -- The ' & disown' part tries to run it in the background without nvim waiting
  -- Adjust if it causes issues, sometimes just system() is enough.
  vim.fn.system('tmux ' .. cmd .. ' & disown')
end

-- Keybinding for vertical split (right)
vim.keymap.set('n', '<leader>%', function()
  tmux_command('split-window -h')
end, { desc = '[T]mux [V]ertical Split' })

-- Keybinding for horizontal split (below)
vim.keymap.set('n', '<leader>"', function()
  tmux_command('split-window -v')
end, { desc = '[T]mux Horizontal [S]plit' })

vim.wo.number = true
