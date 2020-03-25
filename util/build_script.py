import subprocess
from typing import List, Optional

logbuf = ""
def log(msg : str) -> None:
  global logbuf
  logbuf += msg

def logln(msg : str) -> None:
  global logbuf
  logbuf += (msg + "\n")

def fail() -> None:
  print(logbuf)
  exit(1)

def run(cmd : List[str], input : Optional[str] = None) -> None:
  log("Running " + " ".join(cmd) + " ... ")
  res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=input)
  if res.returncode == 0:
    logln("OK")
    return
  logln("FAILED")
  stdout = res.stdout.decode("utf-8").strip()
  stderr = res.stderr.decode("utf-8").strip()
  if len(stdout) > 0:
    logln("Output (stdout):")
    log(stdout)
  if len(stderr) > 0:
    logln("Output (stderr):")
    log(stderr)

  fail()
