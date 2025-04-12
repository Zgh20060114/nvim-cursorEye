return {
  "nvim-lua/plenary.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ns_id = vim.api.nvim_create_namespace("cursor_eye")
    local current_mark = nil

    local function update_cursor_eye()
      if current_mark then
        vim.api.nvim_buf_del_extmark(0, ns_id, current_mark)
      end

      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

      current_mark = vim.api.nvim_buf_set_extmark(0, ns_id, cursor_line, 0, {
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
  end,
} 
