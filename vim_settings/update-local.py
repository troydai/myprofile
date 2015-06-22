#!/usr/bin/env python3

import os.path
import pathlib
import sys
import shutil

print("Update the local vim settings.")

if os.name == 'nt':
    vim_runtime = os.path.join(os.environ['HOME'], 'vimfiles')
else:
    vim_runtime = os.path.join(os.environ['HOME'], '.vim')
    
script_dir = os.path.dirname(sys.argv[0])

colors_src = os.path.join(script_dir, 'colors')
colors_dst = os.path.join(vim_runtime, 'colors')
for p in [p for p in pathlib.Path(colors_src).glob('*.vim') if p.is_file()]:
    if not os.path.exists(colors_dst):
        os.mkdir(colors_dst)

    src = str(p.resolve())
    dst = os.path.join(colors_dst, p.name)
    shutil.copyfile(src, dst)

