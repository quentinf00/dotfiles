-- ~/.config/yazi/plugins/copy-rel.yazi/init.lua
local get_paths = ya.sync(function()
  local cwd = tostring(cx.active.current.cwd)
  local urls = {}

  -- Support copying multiple selected files, or just the hovered one
  if #cx.active.selected == 0 then
  if cx.active.current.hovered then
    table.insert(urls, tostring(cx.active.current.hovered.url))
  end
  else
  for _, u in pairs(cx.active.selected) do
    table.insert(urls, tostring(u))
  end
  end

  return cwd, urls
  end)

  local function entry()
    local cwd, urls = get_paths()
    if #urls == 0 then return end

    local rel_paths = {}
    for _, u in ipairs(urls) do
    local rel = u
    -- Strip the CWD prefix to make it relative
    if u == cwd then
    rel = "."
    elseif u:sub(1, #cwd) == cwd then
    local remainder = u:sub(#cwd + 1)
    if remainder:sub(1, 1) == "/" or remainder:sub(1, 1) == "\\" then
    rel = remainder:sub(2)
    elseif cwd == "/" or cwd == "\\" then
    rel = remainder
    end
    end
    table.insert(rel_paths, rel)
    end

    -- Join with newlines if multiple files are selected
    local text = table.concat(rel_paths, "\n")

    -- Copy to system clipboard
    ya.clipboard(text)

    -- Notify the user
    ya.notify({
      title = "Clipboard",
      content = "Copied " .. #rel_paths .. " relative path(s)",
      level = "info",
      timeout = 2,
      })
      end

      return { entry = entry }
