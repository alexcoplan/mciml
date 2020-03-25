local
  structure T = Test
  structure C1 = Chap1

  val printTestCase =
    (C1.PrintStm
      [C1.EseqExp ((C1.PrintStm [C1.IdExp "a", C1.NumExp 5]), C1.IdExp "b")])

  val tests = [
    ( "test_maxargs_prog", (fn _ => (T.assertEqI (C1.maxargs C1.prog) 2)) ),
    ( "test_maxargs_simple", (fn _ => (
      T.assertEqI (C1.maxargs (C1.AssignStm ("x", C1.NumExp 3))) 0;
      T.assertEqI (C1.maxargs (C1.PrintStm [C1.NumExp 42])) 1;
      T.assertEqI (C1.maxargs printTestCase) 2
    )))
  ]

in

  structure TestChap1 = struct
    fun main _ = T.testMain tests
  end

end
