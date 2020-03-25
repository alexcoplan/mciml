from configure import BuildEnv

def describe(env : BuildEnv) -> None:
  env.Test('test_chap1', 'TestChap1.main', 'test_chap1.cm')
