local
  structure T = Test
  structure U = Util

  val i2s = Int.toString

  val takeDropCases = [
    ( [],    0,  [],    [] ),
    ( [1],   0,  [],    [1] ),
    ( [1],   1,  [1],   [] ),
    ( [3,4], 0,  [],    [3,4] ),
    ( [3,4], 1,  [3],   [4] ),
    ( [3,4], 2,  [3,4], [] ),
    ( [3,4], 42, [3,4], [] ),
    ( [1,2,3,4,5,6], 3, [1,2,3], [4,5,6] )
  ]

  fun takeDropTest (lst, n, taken, left) =
  let val (actualTaken, actualLeft) = U.takeDrop lst n
  in
   (T.assertIntListEq actualTaken taken; T.assertIntListEq actualLeft left)
  end

  val tests = [
    ( "test_showList_empty", fn () => T.assertStrEq (U.showList U.id []) "[]" ),
    ( "test_showList_one",
      fn () => T.assertStrEq (U.showList i2s [1]) "[1]" ),
    ( "test_showList_123",
      fn () => T.assertStrEq (U.showList i2s [1,2,3]) "[1,2,3]" ),
    ( "test_int_list_eq",
      fn () => T.assertIntListEq [1,2,3] [1,2,3] ),
    ( "test_takedrop", fn () => (List.map takeDropTest takeDropCases; ()) )
  ];
in
  structure TestUtil = struct
    fun main _ = T.testMain tests
  end
end
