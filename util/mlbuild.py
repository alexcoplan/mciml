#!/usr/bin/env python3

# This script wraps ml-build and also invokes CM to generate
# a depfile for the CM build at hand.

import argparse
import os
import tempfile
import build_script as bs

def gen_ml(args : argparse.Namespace) -> str:
  return f"""
let
  val depfile = \"{args.depfile}\"
  val cmfile = \"{args.cmfile}\"
  val heapfile = \"{args.heapfile}\"
  val sourceRecs = CM.sources NONE cmfile
  val sources = case sourceRecs of
     (NONE) => raise (Fail "CM.sources failed")
   | (SOME lst) => List.map (fn x => #file x) lst
  val fp = TextIO.openOut depfile
  fun writeDepfile [] = ()
    | writeDepfile (line :: lines) =
    (TextIO.output (fp, (line ^ \" \")); writeDepfile lines)
in
  TextIO.output (fp, (heapfile ^ \" : \"));
  writeDepfile sources
end
"""

def main() -> None:
  parser = argparse.ArgumentParser()
  parser.add_argument("--depfile", type=str)
  parser.add_argument("--cmfile", type=str, required=True)
  parser.add_argument("--heapfile", type=str, required=True)
  parser.add_argument("--main", type=str, required=True)

  args = parser.parse_args()

  cmd = ["ml-build", args.cmfile, args.main, args.heapfile]
  bs.run(cmd)

  # Note: if CM feels it doesn't need to re-build, then it doesn't even
  # touch the heapfile.
  #
  # This is bad as it is possible that e.g. this script has been updated and
  # that forces a heap image re-build, but the timestamp on the heap image never
  # gets updated so ninja keeps trying to re-build it.
  #
  # To get around that, we touch the heap image here.
  assert os.path.exists(args.heapfile) and os.path.isfile(args.heapfile)
  bs.run(["touch", args.heapfile])

  if args.depfile is not None:
    ml_src = gen_ml(args)
    with tempfile.NamedTemporaryFile(mode='w', suffix='.sml', delete=False) as tf:
      tf.write(ml_src)
      tf_name = tf.name

    if os.path.exists(args.depfile):
      os.unlink(args.depfile)
    assert not os.path.exists(args.depfile)
    ml_src = gen_ml(args)
    bs.run(["sml", tf_name], input='')
    assert os.path.exists(args.depfile)
    os.unlink(tf_name)

if __name__ == '__main__':
  main()
