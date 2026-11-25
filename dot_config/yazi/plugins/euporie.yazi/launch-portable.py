"""Launch IPython with the file selected in Yazi available at the prompt."""

import os
from pathlib import Path
import sys


BOOTSTRAP = """
import os
from pathlib import Path

p = Path(os.environ.pop('YAZI_IPYTHON_PATH'))
ext = p.suffix.lower()
print(f'Path available as p: {p}')
try:
    if ext in {'.csv', '.tsv', '.parquet', '.jsonl'}:
        import pandas as pd

        if ext in {'.csv', '.tsv'}:
            df = pd.read_csv(p, sep='\\t' if ext == '.tsv' else ',')
        elif ext == '.parquet':
            df = pd.read_parquet(p)
        else:
            df = pd.read_json(p, lines=True)
        print('Data loaded as df')
    elif ext in {'.nc', '.zarr'}:
        import xarray as xr

        ds = xr.open_zarr(p) if ext == '.zarr' else xr.open_dataset(p)
        print('Data loaded as ds')
    elif ext in {'.yaml', '.yml', '.lock'}:
        from omegaconf import OmegaConf

        cfg = OmegaConf.load(p)
        print('Data loaded as cfg')
except Exception as error:
    print(f'Could not load {p.name}: {error}')
"""


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit('Usage: launch-portable.py SELECTED_PATH')

    environ = os.environ.copy()
    environ.pop('YAZI_EUPORIE', None)
    environ['YAZI_IPYTHON_PATH'] = str(Path(sys.argv[1]).absolute())
    python = environ.get('YAZI_IPYTHON_PYTHON')
    command = [python, '-m', 'IPython'] if python else ['ipython']
    try:
        os.execvpe(command[0], [*command, '--no-banner', '-i', '-c', BOOTSTRAP], environ)
    except OSError as error:
        sys.exit(f'Yazi IPython: {error}')
