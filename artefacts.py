from configure import BuildEnv

def describe(env : BuildEnv) -> None:
  env.Test('test_util', 'TestUtil.main', 'base/test_util.cm')
  env.Test('test_chap1', 'TestChap1.main', 'chap1/test_chap1.cm')
  env.Test('test_lexer', 'TestLexer.main', 'chap2/test_lexer.cm')
