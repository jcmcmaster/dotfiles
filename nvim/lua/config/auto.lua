return {
  setup = function()
    local ns = vim.api.nvim_create_namespace('StartScreen')

    local colors = {
      '#ff6b6b', '#ff8e53', '#feca57', '#48cae4', '#4ecdc4', '#45b7d1',
      '#96ceb4', '#a8e6cf', '#dda0dd', '#ff69b4', '#9370db', '#7b68ee'
    }

    local function apply_logo_hls()
      for i, col in ipairs(colors) do
        vim.api.nvim_set_hl(0, 'StartScreenLogo' .. i, { fg = col })
      end
    end
    apply_logo_hls()

    local function create_start_screen()
      if not (vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1) then return end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_current_buf(buf)
      local win = vim.api.nvim_get_current_win()

      local original_settings = {
        number = vim.wo[win].number,
        relativenumber = vim.wo[win].relativenumber,
        cursorline = vim.wo[win].cursorline
      }

      local logo = {
        '╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮',
        '│││├┤ │ │╰┐┌╯││││',
        '╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴',
      }

      local pending = false

      local function render()
        if not (vim.api.nvim_buf_is_valid(buf)
              and vim.api.nvim_win_is_valid(win)
              and vim.api.nvim_win_get_buf(win) == buf) then
          return
        end
        vim.bo[buf].modifiable = true
        apply_logo_hls()

        local win_h = vim.api.nvim_win_get_height(win)
        local win_w = vim.api.nvim_win_get_width(win)

        local top_pad = math.max(0, math.floor((win_h - #logo) / 2))
        local lines, centered = {}, {}
        for _ = 1, top_pad do lines[#lines + 1] = '' end
        for _, l in ipairs(logo) do
          local pad = math.max(0, math.floor((win_w - vim.fn.strdisplaywidth(l)) / 2))
          local padded = string.rep(' ', pad) .. l
          lines[#lines + 1] = padded
          centered[#centered + 1] = { text = l, pad = pad }
        end
        lines[#lines + 1] = ''
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        for idx, data in ipairs(centered) do
          local buf_line = top_pad + idx - 1
          local raw, pad_len = data.text, data.pad
          for i = 1, #raw do
            local ch = raw:sub(i, i)
            if ch ~= ' ' then
              local color_idx = ((i - 1) % #colors) + 1
              local group = 'StartScreenLogo' .. color_idx
              vim.api.nvim_buf_set_extmark(buf, ns, buf_line, pad_len + i - 1, {
                end_col = pad_len + i,
                hl_group = group
              })
            end
          end
        end

        vim.bo[buf].modifiable = false
        pending = false
      end

      local function schedule_render()
        if pending then return end
        pending = true
        vim.defer_fn(render, 40)
      end

      render()

      vim.bo[buf].modifiable = false
      vim.bo[buf].buflisted = false
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].swapfile = false
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
      vim.wo[win].cursorline = false
      vim.api.nvim_buf_set_name(buf, '[StartScreen]')

      local function restore_window_settings()
        if vim.api.nvim_win_is_valid(win) then
          vim.wo[win].number = original_settings.number
          vim.wo[win].relativenumber = original_settings.relativenumber
          vim.wo[win].cursorline = original_settings.cursorline
        end
      end

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile', 'BufReadPost' }, {
        callback = function(event)
          if event.buf == buf then return end

          local buftype = vim.bo[event.buf].buftype
          local filetype = vim.bo[event.buf].filetype
          local bufname = vim.api.nvim_buf_get_name(event.buf)

          if (filetype ~= '' and filetype ~= 'startscreen') or
              (buftype == '' and bufname ~= '') or
              (buftype ~= 'nofile' and buftype ~= '') then
            restore_window_settings()
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      })

      vim.api.nvim_create_autocmd('BufLeave', {
        buffer = buf,
        callback = restore_window_settings
      })

      vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = buf,
        callback = restore_window_settings
      })

      vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized', 'WinEnter', 'TabEnter' }, {
        callback = function()
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win) then
            schedule_render()
          end
        end
      })
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        apply_logo_hls()
      end
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      callback = create_start_screen,
      desc = 'Show custom start screen'
    })
  end
}
