-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
-- require("tokyonight").setup();
--
vim.cmd('autocmd BufNewFile,BufRead *.fas setlocal ft=fasm')
vim.cmd('autocmd BufNew,BufRead *.asm set ft=nasm')

