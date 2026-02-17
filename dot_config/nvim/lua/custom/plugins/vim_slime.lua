return {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_no_mappings = 1
      local function trim(s)
      return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

    -----------------------------------------------------------------------------
    -- 2. CORE: The "NewTmuxRepl" Logic
    -----------------------------------------------------------------------------
    local function create_repl()
      -- A. Get available kernels from Jupyter
      -- We capture the output of 'jupyter kernelspec list'
      local handle = io.popen("jupyter kernelspec list")
      if not handle then return end
      local result = handle:read("*a")
      handle:close()

      -- B. Parse the kernels
      local kernels = {}
      for line in result:gmatch("[^\r\n]+") do
        -- Skip the header line "Available kernels:"
        if not line:match("Available kernels") then
          -- Extract the first word (kernel name)
          local kernel_name = line:match("%S+")
          if kernel_name then
            table.insert(kernels, kernel_name)
          end
        end
      end

      -- C. UI: Ask user to select a kernel
      -- vim.ui.select uses your preferred UI (Telescope, Fzf-lua, or default menu)
      vim.ui.select(kernels, { prompt = "Select Euporie Kernel:" }, function(selected_kernel)
        if not selected_kernel then return end

        local session_name = "repl"
        local pane_command = string.format("euporie-console --multiplexer-passthrough --graphics kitty-unicode --force-graphics --kernel=%s", selected_kernel)
        
        -- D. TMUX MAGIC
        -- 1. Check if the 'repl' session exists
        local check_session = vim.fn.system("tmux has-session -t " .. session_name .. " 2>/dev/null")
        local cmd = ""
        
        if vim.v.shell_error ~= 0 then
          -- Session doesn't exist: Create new session
          -- -d: detached
          -- -P: print info
          -- -F: format output
          cmd = string.format(
            "tmux new-session -d -s %s -P -F '#{session_name}:#{window_index}.#{pane_index}' '%s'",
            session_name, pane_command
          )
        else
          -- Session exists: Create new window in it
          cmd = string.format(
            "tmux new-window -t %s: -P -F '#{session_name}:#{window_index}.#{pane_index}' -n 'console-%s' '%s'",
            session_name, selected_kernel, pane_command
          )
        end

        -- Execute tmux command and capture the new Pane ID (e.g., "repl:1.0")
        local target_id = trim(vim.fn.system(cmd))

        -- E. CONFIGURATION
        -- Set the slime config for the CURRENT buffer only
        -- This means different buffers can point to different kernels!
        vim.b.slime_config = { socket_name = "default", target_pane = target_id }

        print("Linked buffer to Euporie (" .. selected_kernel .. ") at " .. target_id)
      end)
    end

    -----------------------------------------------------------------------------
    -- 3. COMMANDS & KEYMAPS
    -----------------------------------------------------------------------------
    
    -- Create the user command :NewTmuxRepl
    vim.api.nvim_create_user_command("NewTmuxRepl", create_repl, {})

    -- Map <Leader>R to create/select repl
    vim.keymap.set("n", "<Leader>R", create_repl, { desc = "Create/Link Tmux Repl" })


        -- Use tmux as the target
        vim.g.slime_target = "tmux"
        
        -- Essential for Python: Bracketed Paste
        -- This ensures Euporie receives the code as a block, not char-by-char
        -- preventing indentation errors.
        vim.g.slime_bracketed_paste = 1
        
        -- Optional: Don't ask for pane ID every time. 
        -- It will ask once, then remember.
        vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
        vim.g.slime_dont_ask_default = 1
    
        local function send_cell()
            local bufnr = vim.api.nvim_get_current_buf()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local total_lines = vim.api.nvim_buf_line_count(bufnr)

            -- Search backwards for cell delimiter or start of file
            local start_line = 0
            for i = row, 1, -1 do
                local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
                if line:match("^# %%%%") then
                    start_line = i
                    break
                end
            end

            -- Search forwards for cell delimiter or end of file
            local end_line = total_lines
            for i = row + 1, total_lines do
                local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
                if line:match("^# %%%%") then
                    end_line = i - 1 -- Exclude the next delimiter
                    break
                end
            end

            -- Get the text
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
            local text = table.concat(lines, "\n") .. "\n"

            -- Send to slime
            vim.fn["slime#send"](text)
            
            -- Optional: Move cursor to next cell automatically (VS Code behavior)
            local next_cell_row = end_line + 2
            if next_cell_row <= total_lines then
                vim.api.nvim_win_set_cursor(0, {next_cell_row, 0})
            end
        end

        -- 2. FUNCTION: Send Full Buffer
        local function send_buffer()
          -- Get all lines from buffer (0 to -1)
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local text = table.concat(lines, "\n") .. "\n"
          vim.fn["slime#send"](text)
          print("Sent full buffer to REPL")
        end

        -- 3. KEYMAPPINGS

        -- A. Normal Mode: Shift+Enter -> Send Cell
        vim.keymap.set("n", "<Leader><Leader>", send_cell, { desc = "Send Cell" })

        -- B. Visual Mode: Shift+Enter -> Send Selection
        -- We use <Plug>SlimeRegionSend provided by the plugin. 
        -- 'remap = true' is essential here.
        vim.keymap.set("x", "<Leader><Leader>", "<Plug>SlimeRegionSend", { remap = true, desc = "Send Selection" })

        -- C. Normal Mode: Ctrl+Shift+Enter -> Send Full Buffer
        vim.keymap.set("n",  "<Leader><CR>", send_buffer, { desc = "Send Full Buffer" })

  end
}
