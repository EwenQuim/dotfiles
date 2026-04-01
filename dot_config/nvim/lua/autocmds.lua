require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- gI → go to implementation (mirrors how NvChad maps gd → buf.definition)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)

    -- Ctrl+click: go to definition, fallback to implementation if no results
    vim.keymap.set('n', '<C-LeftMouse>', function()
      local pos = vim.fn.getmousepos()
      vim.api.nvim_set_current_win(pos.winid)
      vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })

      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
      local params = vim.lsp.util.make_position_params(0, encoding)

      vim.lsp.buf_request_all(bufnr, 'textDocument/definition', params, function(results)
        local locations = {}
        local enc = encoding
        for client_id, res in pairs(results) do
          if not res.err and res.result then
            local client = vim.lsp.get_client_by_id(client_id)
            enc = client and client.offset_encoding or enc
            local locs = vim.islist(res.result) and res.result or { res.result }
            if not vim.tbl_isempty(locs) then
              vim.list_extend(locations, locs)
            end
          end
        end
        if vim.tbl_isempty(locations) then
          vim.lsp.buf.implementation()
          return
        end
        if #locations == 1 then
          vim.lsp.util.show_document(locations[1], enc, { focus = true })
        else
          vim.fn.setqflist({}, ' ', {
            title = 'Definitions',
            items = vim.lsp.util.locations_to_items(locations, enc),
          })
          vim.cmd 'copen'
        end
      end)
    end, opts)
  end,
})
