
local get_path = ya.sync(function()
  local path = tostring(cx.active.current.hovered.url)
  return path
end)

local function entry(self)
  local path = get_path()


  local ext = path:match("^.+%.(.+)$")
  if ext then ext = ext:lower() end

  -- Ensure safe path escaping for Python
  local safe_path = path:gsub("\\", "\\\\"):gsub("'", "\\'")

  local load_code = ""
  local loaded_var = nil

  -- Match file extensions and assign the correct libraries
  if ext == "csv" then
  load_code = "import pandas as pd\n  df = pd.read_csv(p)"
  loaded_var = "df"
  elseif ext == "tsv" then
  load_code = "import pandas as pd\n  df = pd.read_csv(p, sep='\\t')"
  loaded_var = "df"
  elseif ext == "parquet" then
  load_code = "import pandas as pd\n  df = pd.read_parquet(p)"
  loaded_var = "df"
  elseif ext == "jsonl" then
  load_code = "import pandas as pd\n  df = pd.read_json(p, lines=True)"
  loaded_var = "df"
  elseif ext == "nc" then
  load_code = "import xarray as xr\n  ds = xr.open_dataset(p)"
  loaded_var = "ds"
  elseif ext == "zarr" then
  load_code = "import xarray as xr\n  ds = xr.open_zarr(p)"
  loaded_var = "ds"
  elseif ext == "yaml" or ext == "yml" or ext == "lock" then
  load_code = "from omegaconf import OmegaConf\n  cfg = OmegaConf.load(p)"
  loaded_var = "conf"
  end

  local print_loaded = ""
  if loaded_var then
  print_loaded = string.format("print('➡️ Data loaded in variable `%s`')", loaded_var)
  end

  -- Find the IPython startup directory
  local home = os.getenv("HOME") or os.getenv("USERPROFILE")
  local ipython_dir = os.getenv("IPYTHONDIR")
  if not ipython_dir or ipython_dir == "" then
  ipython_dir = home .. "/.ipython"
  end

  local startup_dir = ipython_dir .. "/profile_default/startup"

  -- Create the directory safely across platforms
  local path_sep = package.config:sub(1,1)
  local is_windows = path_sep == "\\"

  if is_windows then
  os.execute(string.format('mkdir "%s" 2>nul', startup_dir:gsub("/", "\\")))
  else
  os.execute(string.format('mkdir -p "%s"', startup_dir))
  end

  local tmp_file = startup_dir .. "/00_yazi_euporie.py"
  local safe_tmp_file = tmp_file:gsub("\\", "\\\\"):gsub("'", "\\'")

  -- Create the Python script
  -- Wrapped in an environment variable check to only execute when launched from Yazi,
  -- and deletes itself immediately after running to keep your IPython profile clean.
  local script = string.format([[
import os
if os.environ.get('YAZI_EUPORIE') == '1':
  # try:
  #     os.remove('%s')
  # except:
  #     pass

  from pathlib import Path
  p = Path('%s')

  %s

  print('\n' + '='*45)
  print(f'📂 Path available in variable `p`: {p.name}')
  %s
  print('='*45 + '\n')
  ]], safe_tmp_file, safe_path, load_code, print_loaded)

  -- Write the script to the startup folder
  local f = io.open(tmp_file, "w")
  if not f then
  ya.notify({ title = "Euporie Plugin", content = "Failed to create IPython startup script", level = "error", timeout = 3 })
  return
  end
  f:write(script)
  f:close()

  -- Execute euporie-console with the flag set to trigger the startup script
  local cmd = is_windows 
  and 'set YAZI_EUPORIE=1 && euporie-console'
  or 'YAZI_EUPORIE=1 euporie-console --kernel=dev --multiplexer-passthrough --graphics kitty-unicode --force-graphics'

  ya.mgr_emit("shell", { cmd, block = true })
  end

  return { entry = entry }
