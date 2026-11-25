-- Local Markdown links: text in Neovim; directories/data in Yazi.
local M = {}
local uv = vim.uv or vim.loop
local data_extensions = {
  csv=true, tsv=true, parquet=true, arrow=true, feather=true,
  nc=true, zarr=true, npy=true, npz=true, pt=true, ckpt=true,
  png=true, jpg=true, jpeg=true, webp=true, gif=true, pdf=true,
}

function M.target_at(line, col)
  -- Find the entire Markdown link, including when the cursor is on its label.
  local from = 1
  while true do
    -- General balanced-parenthesis parser supports parentheses inside paths.
    local a, b = line:find('%b[]%b()', from)
    if not a then break end
    if col >= a and col <= b then
      local part = line:sub(a, b)
      local closing = part:find(']%(', 1)
      local raw = part:sub(closing + 2, -2)
      return raw:match('^%s*<(.-)>') or raw:match('^%s*(.-)%s+".*"%s*$') or raw
    end
    from = b + 1
  end
  return nil
end

function M.resolve(raw, buffer_path)
  raw = raw:gsub('^%s+', ''):gsub('%s+$', ''):gsub('^file://', '')
  if raw:match('^%a[%w+.-]*://') or raw:sub(1, 1) == '#' then return nil end
  raw = raw:gsub('#.*$', ''):gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
  raw = raw:gsub('\\([ ()])', '%1')
  local base = vim.fs.dirname(uv.fs_realpath(buffer_path) or buffer_path) or vim.fn.getcwd()
  if raw:sub(1, 2) == '~/' then raw = vim.fn.expand('~') .. raw:sub(2) end
  local path = raw:sub(1, 1) == '/' and raw or base .. '/' .. raw
  local lineno
  if not uv.fs_stat(path) then
    local without, number = path:match('^(.-):(%d+)$')
    if without and uv.fs_stat(without) then path, lineno = without, tonumber(number) end
  end
  path = vim.fs.normalize(path)
  return path, lineno
end

function M.browse(path)
  if vim.fn.executable('yazi') ~= 1 then
    vim.notify('yazi is not on PATH', vim.log.levels.ERROR)
    return
  end
  local original = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  local width, height = math.max(20, vim.o.columns - 4), math.max(5, vim.o.lines - 5)
  local win = vim.api.nvim_open_win(buf, true, {
    relative='editor', row=1, col=1, width=width, height=height,
    style='minimal', border='rounded', title=' Yazi — Enter: choose file · q: return ',
  })
  local chooser = vim.fn.tempname()
  vim.fn.jobstart({ 'yazi', '--chooser-file', chooser, path }, {
    term=true,
    on_exit=function(_, code)
      vim.schedule(function()
        local chosen = vim.fn.filereadable(chooser) == 1 and vim.fn.readfile(chooser) or {}
        vim.fn.delete(chooser)
        if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force=true }) end
        if vim.api.nvim_win_is_valid(original) then vim.api.nvim_set_current_win(original) end
        if code == 0 and chosen[1] and chosen[1] ~= '' then
          -- :edit retains Neovim's modified-buffer protection and jump history.
          local ok, err = pcall(vim.cmd.edit, vim.fn.fnameescape(chosen[1]))
          if not ok then vim.notify(err, vim.log.levels.WARN) end
        end
      end)
    end,
  })
  vim.cmd.startinsert()
end

function M.follow(force_yazi)
  local raw = M.target_at(vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2] + 1)
    or vim.fn.expand('<cfile>')
  local path, lineno = M.resolve(raw, vim.api.nvim_buf_get_name(0))
  local stat = path and uv.fs_stat(path)
  if not stat then
    if force_yazi then vim.notify('No existing local path under cursor', vim.log.levels.WARN)
    else vim.cmd('normal! gf') end
    return
  end
  local ext = path:match('%.([^./]+)$')
  if force_yazi or stat.type == 'directory' or data_extensions[(ext or ''):lower()] then
    M.browse(path) -- Yazi reveals a file in its parent directory automatically.
  else
    vim.cmd.edit(vim.fn.fnameescape(path))
    if lineno then vim.api.nvim_win_set_cursor(0, { lineno, 0 }) end
  end
end

vim.api.nvim_create_user_command('Yazi', function(args)
  M.browse(args.args ~= '' and vim.fn.fnamemodify(args.args, ':p') or vim.api.nvim_buf_get_name(0))
end, { nargs='?', complete='file' })
vim.keymap.set('n', '<leader>y', '<Cmd>Yazi<CR>', { desc='Reveal current file in Yazi' })
vim.api.nvim_create_autocmd('FileType', {
  pattern={ 'markdown', 'markdown.mdx' },
  group=vim.api.nvim_create_augroup('xpcc-markdown-navigation', { clear=true }),
  callback=function(args)
    vim.keymap.set('n', 'gf', function() M.follow(false) end, { buffer=args.buf, desc='Follow local link (data/directories in Yazi)' })
    vim.keymap.set('n', 'gy', function() M.follow(true) end, { buffer=args.buf, desc='Reveal linked path in Yazi' })
  end,
})
return M
