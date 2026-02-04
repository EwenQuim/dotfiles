require "nvchad.options"

local o = vim.o

o.relativenumber = true     -- Relative line numbers (easier motions like 5j)
o.scrolloff = 8             -- Keep 8 lines visible above/below cursor
o.ignorecase = true         -- Case insensitive search...
o.smartcase = true          -- ...unless uppercase used
o.clipboard = "unnamedplus" -- System clipboard
o.undofile = true           -- Persistent undo
o.cursorline = true         -- Highlight current line
