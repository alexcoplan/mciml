#!/usr/bin/env python3

import os
import subprocess

from typing import Dict, List, TextIO

import artefacts

def get_smlnj_info() -> Dict[str, str]:
  if "SMLNJ_HOME" in os.environ:
    home = os.environ["SMLNJ_HOME"]
  else:
    home = "/usr/local/smlnj"

  if not os.path.exists(home):
    print("smlnj not found!")
    exit(1)

  arch_opsys = os.path.join(home, "bin/.arch-n-opsys")
  res = subprocess.run(arch_opsys, stdout=subprocess.PIPE, check=True)
  info_parts = res.stdout.decode("utf-8").split(";")
  info = {}
  for datum in info_parts:
    key, value = datum.split("=")
    info[key.strip()] = value.strip()

  return info

mlbuild_py_path = "util/mlbuild.py"
h2e_path = "build/h2a/heap2exec"

smlnj_info = get_smlnj_info()
arch = smlnj_info["ARCH"]
bitness = "-32" if arch == "x86" else "-64"

ninjafile_base = f"""# auto-generated by configure.py

# Use a ninja pool to serialise CM jobs.
#
# We want these CM jobs to be able to re-use work done by each other, and that
# can only happen if we run them serially.
#
# Moreover, we might end up upsetting CM / getting corruption since it doesn't
# expect multiple builds to be running over the same sources concurrently.
pool cm_pool
  depth = 1

rule reconf
  command = ./configure.py
  generator = 1

rule mlbuild
  command = {mlbuild_py_path} --cmfile $in --main $main --heapfile $out --depfile $out.d
  depfile = $out.d
  pool = cm_pool

rule h2e
  command = {h2e_path} {bitness} build/h2a/build/heap2asm $in $out

rule bootstrap
  command = util/bootstrap.py

rule stamp
  command = $in && touch $out
  description = TEST $in

# re-configure if necessary
build build.ninja : reconf configure.py artefacts.py

build {h2e_path} : bootstrap | util/bootstrap.py
"""

class Program:
  def __init__(self, name : str, main : str, cmfile : str) -> None:
    self.name = name
    self.main = main
    self.cmfile = cmfile

class BuildEnv():
  def __init__(self) -> None:
    self.programs : List[Program] = []
    self.test_exes : List[str] = []

  def Program(self, name : str, main : str, cmfile : str) -> None:
    self.programs.append(Program(name, main, cmfile))

  def Test(self, name : str, main : str, cmfile : str) -> None:
    self.Program(name, main, cmfile)
    self.test_exes.append(name)

  def write_ninja(self, fp : TextIO) -> None:
    fp.write(ninjafile_base)

    heap_suffix = smlnj_info["HEAP_SUFFIX"]

    for prog in self.programs:
      # first build the heap image
      heap_path = f"build/{prog.name}.{heap_suffix}"
      fp.write(f"\nbuild {heap_path} : mlbuild {prog.cmfile} | {mlbuild_py_path}")
      fp.write(f"\n  main = {prog.main}\n")
      # and now the exe
      fp.write(f"\nbuild build/{prog.name} : h2e {heap_path} | {h2e_path}\n")

    for test in self.test_exes:
      fp.write(f"\nbuild build/test/{test}.stamp : stamp build/{test}\n")

def main() -> None:
  env = BuildEnv()
  artefacts.describe(env)
  with open("build.ninja", "w") as f:
    env.write_ninja(f)

if __name__ == '__main__':
  main()
