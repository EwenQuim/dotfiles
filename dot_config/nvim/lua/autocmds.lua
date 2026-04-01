require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- gI → go to implementation
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)

    -- Ctrl+click: go to definition, fallback to implementation if no results
    local function smart_goto()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
      local params = vim.lsp.util.make_position_params(0, encoding)
      vim.lsp.buf_request(bufnr, 'textDocument/definition', params, function(err, result, ctx)
        if err or not result or (type(result) == 'table' and vim.tbl_isempty(result)) then
          vim.lsp.buf.implementation()
          return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local encoding = client and client.offset_encoding or 'utf-16'
        local locations = vim.islist(result) and result or { result }
        if #locations == 1 then
          vim.lsp.util.show_document(locations[1], encoding, { focus = true })
        else
          vim.fn.setqflist({}, ' ', {
            title = 'Definitions',
            items = vim.lsp.util.locations_to_items(locations, encoding),
          })
          vim.cmd 'copen'
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
