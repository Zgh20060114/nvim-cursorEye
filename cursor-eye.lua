return {
  "nvim-lua/plenary.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ns_id = vim.api.nvim_create_namespace("cursor_eye")
    local current_mark = nil

    -- 创建或更新extmark
    local function update_cursor_eye()
      -- 清除旧的mark
      if current_mark then
        vim.api.nvim_buf_del_extmark(0, ns_id, current_mark)
      end

      -- 获取当前光标位置
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

      -- 创建新的mark
      current_mark = vim.api.nvim_buf_set_extmark(0, ns_id, cursor_line, 0, {
        sign_text = "👀",
        sign_hl_group = "CursorEye",
        priority = 1000,
      })
    end

    -- 创建高亮组
    vim.api.nvim_set_hl(0, "CursorEye", { fg = "#61AFEF" })

    -- 设置自动命令
    local group = vim.api.nvim_create_augroup("CursorEye", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      callback = update_cursor_eye,
    })
  end,
} 