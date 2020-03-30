local
  structure T = Test

  val tests = [
    ( "test_string_source", fn () =>
      let val src = LexUtil.stringSource "hello"
      in
        (T.assertStrEq (src 2) "he";
         T.assertStrEq (src 1) "l";
         T.assertStrEq (src 2) "lo")
      end
    )
  ]
in

  structure TestLexer =
  struct
    fun main _ = T.testMain tests
  end

end
