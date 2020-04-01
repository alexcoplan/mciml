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
    ( "test_takedrop", fn () => (List.map takeDropTest takeDropCases; ()) ),
    ( "test_upcase", fn () => T.assertStrEq "ABC" (U.upcase "abc") ),
    ( "test_startswith", fn () => (
      T.assertThat (U.startsWith [1,2,3] []);
      T.assertThat (U.startsWith [1,2,3] [1]);
      T.assertThat (U.startsWith [1,2,3] [1,2]);
      T.assertThat (U.startsWith [1,2,3] [1,2,3]);
      T.assertNot (U.startsWith [1,2,3] [1,2,3,4]);
      T.assertNot (U.startsWith [1,2,3] [4]);
      T.assertNot (U.startsWith [1,2,3] [1,3])
    )),
    ( "test_lstlst", fn () => (
      T.assertIntOptEq (U.lstlst [1,2,3,4] [1,2]) (SOME 0);
      T.assertIntOptEq (U.lstlst [1,2,3,4] [2,3]) (SOME 1);
      T.assertIntOptEq (U.lstlst [1,2,3,4] [3,4]) (SOME 2);
      T.assertIntOptEq (U.lstlst [1,2,3,4] [4,5]) NONE
    )),
    ( "test_strstr", fn () => (
      T.assertIntOptEq (U.strstr "abc def!" "abc") (SOME 0);
      T.assertIntOptEq (U.strstr "abc def!" "def") (SOME 4);
      T.assertIntOptEq (U.strstr "abc def!" "cde") NONE
    )),
    ( "test_splitOnce", fn () => (
      T.assertStrPairOptEq (U.splitOnce "abcXYdef" "XY") (SOME ("abc", "def"));
      T.assertStrPairOptEq (U.splitOnce "abcXYdef" "XZ") NONE
    ))
  ];
in
  structure TestUtil = struct
    fun main _ = T.testMain tests
  end
end
