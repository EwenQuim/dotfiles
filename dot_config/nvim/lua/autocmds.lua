require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- gI → go to implementation
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)

    -- Ctrl+click: go to definition, fallback to implementation if no results
    local function smart_goto()
      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(bufnr, 'textDocument/definition', params, function(err, result, ctx, config)
        if err or not result or (type(result) == 'table' and vim.tbl_isempty(result)) then
          vim.lsp.buf.implementation()
        else
          vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
        end
      end)
    end

    vim.keymap.set('n', '<C-LeftMouse>', function()
      local pos = vim.fn.getmousepos()
      vim.api.nvim_set_current_win(pos.winid)
      vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })
      smart_goto()
    end, opts)
  end,
})
