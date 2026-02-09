# ~/.config/yazi/scripts/nc_preview.py
import lovely_tensors as lt
lt.monkey_patch()
import torch
import sys

path = sys.argv[1]

try:
    print(torch.load(path))
except Exception as e:
    print(f"Error loading dataset:\n{e}")
