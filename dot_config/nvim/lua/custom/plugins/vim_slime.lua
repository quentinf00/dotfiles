return {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_no_mappings = 1

      local function trim(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
      end

      -----------------------------------------------------------------------------
      -- ASYNC SEND: bypasses vim-slime's blocking system() calls
      -- Avoids PTY write hang when Euporie is busy rendering
      -----------------------------------------------------------------------------
      local function async_send(text)
        local config = vim.b.slime_config or vim.g.slime_default_config
        local socket = config.socket_name or "default"
        local target = config.target_pane

        -- Cancel copy mode if active (non-blocking, ignore errors)
        vim.system({"tmux", "-L", socket, "send-keys", "-X", "-t", target, "cancel"}, {})

        -- Strip trailing newline (re-sent as Enter after bracketed paste)
        local to_paste = text:gsub("[\r\n]+$", "")
        local has_trailing = #to_paste ~= #text

        vim.system(
          {"tmux", "-L", socket, "load-buffer", "-"},
          {stdin = to_paste},
          function(r1)
            if r1.code ~= 0 then return end
            vim.system(
              {"tmux", "-L", socket, "paste-buffer", "-d", "-p", "-t", target},
              {},
              function(r2)
                if r2.code == 0 and has_trailing then
                  vim.system({"tmux", "-L", socket, "send-keys", "-t", target, "Enter"}, {})
                end
              end
            )
          end
        )
      end

      -----------------------------------------------------------------------------
      -- CORE: The "NewTmuxRepl" Logic
      -----------------------------------------------------------------------------
      local function create_repl()
        -- Async: avoids blocking nvim while jupyter loads (especially on NFS)
        vim.system({"jupyter", "kernelspec", "list"}, {text = true}, function(result)
          if result.code ~= 0 then return end

          local kernels = {}
          for line in result.stdout:gmatch("[^\r\n]+") do
            if not line:match("Available kernels") then
              local kernel_name = line:match("%S+")
              if kernel_name then
                table.insert(kernels, kernel_name)
              end
            end
          end

          -- UI calls must run on main thread
          vim.schedule(function()
            vim.ui.select(kernels, { prompt = "Select Euporie Kernel:" }, function(selected_kernel)
              if not selected_kernel then return end

              local session_name = "repl"
              local pane_command = string.format(
                "euporie-console --multiplexer-passthrough --graphics kitty-unicode --force-graphics --kernel=%s",
                selected_kernel
              )

              vim.fn.system("tmux has-session -t " .. session_name .. " 2>/dev/null")
              local cmd
              if vim.v.shell_error ~= 0 then
                cmd = string.format(
                  "tmux new-session -d -s %s -P -F '#{session_name}:#{window_index}.#{pane_index}' '%s'",
                  session_name, pane_command
                )
              else
                cmd = string.format(
                  "tmux new-window -t %s: -P -F '#{session_name}:#{window_index}.#{pane_index}' -n 'console-%s' '%s'",
                  session_name, selected_kernel, pane_command
                )
              end

              local target_id = trim(vim.fn.system(cmd))
              vim.b.slime_config = { socket_name = "default", target_pane = target_id }
              print("Linked buffer to Euporie (" .. selected_kernel .. ") at " .. target_id)
            end)
          end)
        end)
      end

      -----------------------------------------------------------------------------
      -- COMMANDS & KEYMAPS
      -----------------------------------------------------------------------------

      vim.api.nvim_create_user_command("NewTmuxRepl", create_repl, {})
      vim.keymap.set("n", "<Leader>R", create_repl, { desc = "Create/Link Tmux Repl" })

      vim.g.slime_target = "tmux"
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      vim.g.slime_dont_ask_default = 1

      local function send_cell()
        local bufnr = vim.api.nvim_get_current_buf()
        local row = unpack(vim.api.nvim_win_get_cursor(0))
        local total_lines = vim.api.nvim_buf_line_count(bufnr)

        local start_line = 0
        for i = row, 1, -1 do
          local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
          if line:match("^# %%%%") then
            start_line = i
            break
          end
        end

        local end_line = total_lines
        for i = row + 1, total_lines do
          local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
          if line:match("^# %%%%") then
            end_line = i - 1
            break
          end
        end

        local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
        async_send(table.concat(lines, "\n") .. "\n")

        local next_cell_row = end_line + 2
        if next_cell_row <= total_lines then
          vim.api.nvim_win_set_cursor(0, {next_cell_row, 0})
        end
      end

      local function send_buffer()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        async_send(table.concat(lines, "\n") .. "\n")
        print("Sent full buffer to REPL")
      end

      vim.keymap.set("n", "<Leader><Leader>", send_cell, { desc = "Send Cell" })
      vim.keymap.set("x", "<Leader><Leader>", "<Plug>SlimeRegionSend", { remap = true, desc = "Send Selection" })
      vim.keymap.set("n", "<Leader><CR>", send_buffer, { desc = "Send Full Buffer" })
    end
}
