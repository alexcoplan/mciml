local
  structure T = Test

  val tests = [
    ( "test_maxargs_prog", (fn _ => (T.assertEqI (Chap1.maxargs Chap1.prog) 2)) )
  ]

in

  structure TestChap1 = struct
    fun main _ = T.testMain tests
  end

end
