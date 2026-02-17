# ~/.config/yazi/scripts/nc_preview.py
import sys
import xarray as xr
import os
xr.set_options(display_max_rows=50)

path = sys.argv[1]

try:
    # Check if it is zarr (often a directory) or netcdf
    if path.endswith('.zarr') or os.path.isdir(path):
        ds = xr.open_dataset(path, engine='zarr', chunks={})
    else:
        ds = xr.open_dataset(path, chunks={})
    
    print(ds)
    print()
    print("All variables:", list(ds))
except Exception as e:
    print(f"Error loading dataset:\n{e}")
