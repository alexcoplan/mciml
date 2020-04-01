(* Simple unit test library *)

local

  fun testRunner [] = (Util.printLn "SUCCESS"; OS.Process.success)
    | testRunner ((name, body) :: remaining) =
      (print (name ^ ": ");
       body ();
       print "OK\n";
       testRunner remaining)

in

  structure Test = struct
    fun assertEq show x y =
      if x <> y then raise (Fail ("expected " ^ (show x) ^ " to equal " ^ (show y)))
      else ()

    fun assertThat b =
      if b then () else raise (Fail "false")

    fun assertNot b =
      if b then raise (Fail "true") else ()

    fun showString x = "\"" ^ x ^ "\""

    fun assertLstEq showEl = assertEq (Util.showList showEl)
    fun assertOptEq showEl = assertEq (Util.showOpt showEl)
    fun assertPairEq showA showB = assertEq (Util.showPair showA showB)

    val assertIntEq = assertEq Int.toString
    val assertStrEq = assertEq showString
    val assertIntListEq = assertLstEq Int.toString
    val assertIntOptEq = assertOptEq Int.toString
    val assertStrPairOptEq = assertOptEq (Util.showPair showString showString)

    fun testMain suite =
      ((testRunner suite); OS.Process.success)
      handle e => (Util.printLn ("FAIL\n" ^ ("Uncaught exception: " ^ (exnMessage e)));
                   OS.Process.failure)
  end

end
