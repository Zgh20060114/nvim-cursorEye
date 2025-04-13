return {
  "nvim-lua/plenary.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ns_id = vim.api.nvim_create_namespace("cursor_eye")
    local marks = {}

    local function clear_mark(bufnr)
      if marks[bufnr] then
        pcall(vim.api.nvim_buf_del_extmark, bufnr, ns_id, marks[bufnr])
        marks[bufnr] = nil
      end
    end

    local function update_cursor_eye()
      local bufnr = vim.api.nvim_get_current_buf()
      
      --清除当前缓冲区的旧mark
      clear_mark(bufnr)
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
      -- 创建新的mark
      marks[bufnr] = vim.api.nvim_buf_set_extmark(bufnr, ns_id, cursor_line, 0, {
        sign_text = "👀",
        sign_hl_group = "CursorEye",
        priority = 1000,
      })
    end
    vim.api.nvim_set_hl(0, "CursorEye", { fg = "#61AFEF" })
    local group = vim.api.nvim_create_augroup("CursorEye", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      callback = update_cursor_eye,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload" }, {
      group = group,
      callback = function(ev)
        clear_mark(ev.buf)
      end,
    })
  end,
} 
