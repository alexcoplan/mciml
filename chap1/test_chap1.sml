local
  structure T = Test
  structure C1 = Chap1

  val printTestCase =
    (C1.PrintStm
      [C1.EseqExp ((C1.PrintStm [C1.IdExp "a", C1.NumExp 5]), C1.IdExp "b")])

  val numExprs = List.map (fn x => C1.NumExp x)

  val printCases = [
    (C1.PrintStm [], "\n"),
    (C1.PrintStm (numExprs [42]), "42\n"),
    (C1.PrintStm (numExprs [5,3]), "5 3\n")
  ]

  val arithCases = [
    (C1.PrintStm [C1.OpExp (C1.NumExp 2, C1.Plus, C1.NumExp 3)], "5\n"),
    (C1.PrintStm [C1.OpExp (C1.NumExp 3, C1.Times, C1.NumExp 7)], "21\n")
  ]

  fun interpIter [] = ()
    | interpIter ((prog,str) :: rest) =
    (T.assertStrEq (C1.interpStr prog) str; interpIter rest)

  fun interpTest testCases = (fn () => interpIter testCases)

  val tests = [
    ( "test_maxargs_prog", (fn () => (T.assertIntEq (C1.maxargs C1.prog) 2)) ),
    ( "test_maxargs_simple", (fn () => (
      T.assertIntEq (C1.maxargs (C1.AssignStm ("x", C1.NumExp 3))) 0;
      T.assertIntEq (C1.maxargs (C1.PrintStm [C1.NumExp 42])) 1;
      T.assertIntEq (C1.maxargs printTestCase) 2
    ))),
    ( "test_interp_print", interpTest printCases ),
    ( "test_interp_arith", interpTest arithCases ),
    ( "test_interp_prog", (fn () =>
      T.assertStrEq (C1.interpStr C1.prog) "8 7\n80\n"
    ))
  ]

in

  structure TestChap1 = struct
    fun main _ = T.testMain tests
  end

end
