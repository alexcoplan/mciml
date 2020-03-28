local
  structure T = Test
  structure U = Util

  val tests = [
    ( "test_showList_empty", fn () => T.assertStrEq (U.showList U.id []) "[]" )
  ];
in
  structure TestUtil = struct
    fun main _ = T.testMain tests
  end
end
