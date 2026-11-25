local get_paths = ya.sync(function()
  local paths = {}
  for _, url in pairs(cx.active.selected) do
    paths[#paths + 1] = tostring(url.path)
  end
  if #paths == 0 and cx.active.current.hovered then
    paths[1] = tostring(cx.active.current.hovered.url.path)
  end
  table.sort(paths)
  return paths
end)

return {
  entry = function()
    local paths = get_paths()
    if #paths == 0 then return end
    local config = os.getenv('YAZI_CONFIG_HOME')
    if not config or config == '' then
      local xdg = os.getenv('XDG_CONFIG_HOME')
      config = (xdg and xdg ~= '' and xdg or os.getenv('HOME') .. '/.config') .. '/yazi'
    end
    local script = config .. '/plugins/visidata.yazi/concat.py'
    local args = { 'python3', ya.quote(script), '--viewer', 'fx', '--' }
    for _, path in ipairs(paths) do
      args[#args + 1] = ya.quote(path)
    end
    ya.emit('shell', { table.concat(args, ' '), block = true, confirm = true })
  end,
}
