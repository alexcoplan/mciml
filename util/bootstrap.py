#!/usr/bin/env python3

import subprocess
import os
import sys
import shutil
import build_script as bs

build_dir = 'build'
h2a_url = 'https://github.com/alexcoplan/heap2asm.git'
h2a_dir = os.path.join(build_dir, 'h2a')
h2a_script = os.path.join(h2a_dir, 'bootstrap.py')

if os.path.exists(h2a_dir):
  assert os.path.isdir(h2a_dir)
  shutil.rmtree(h2a_dir)

cmd = ['git', 'clone', h2a_url, h2a_dir]
bs.run(cmd)

sys.path.insert(0, os.getcwd())

# We ignore the type here since this an import that can only succeed at runtime.
import build.h2a.bootstrap as bstrap # type: ignore

os.chdir(h2a_dir)
bstrap.main()
