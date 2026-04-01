require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    local function lsp_request(method, title, fallback)
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
      local params = vim.lsp.util.make_position_params(0, encoding)
      vim.lsp.buf_request(bufnr, method, params, function(err, result, ctx)
        if err or not result or (type(result) == 'table' and vim.tbl_isempty(result)) then
          if fallback then
            fallback()
          else
            vim.notify('No locations found', vim.log.levels.INFO)
          end
          return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local enc = client and client.offset_encoding or 'utf-16'
        local locations = vim.islist(result) and result or { result }
        if #locations == 1 then
          vim.lsp.util.show_document(locations[1], enc, { focus = true })
        else
          vim.fn.setqflist({}, ' ', {
            title = title,
            items = vim.lsp.util.locations_to_items(locations, enc),
          })
          vim.cmd 'copen'
        end
      end)
    end

    -- gI → go to implementation
    vim.keymap.set('n', 'gI', function()
      lsp_request('textDocument/implementation', 'Implementations')
    end, opts)

    -- Ctrl+click: go to definition, fallback to implementation if no results
    vim.keymap.set('n', '<C-LeftMouse>', function()
      local pos = vim.fn.getmousepos()
      vim.api.nvim_set_current_win(pos.winid)
      vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })
      lsp_request('textDocument/definition', 'Definitions', function()
        lsp_request('textDocument/implementation', 'Implementations')
      end)
    end, opts)
  end,
})
