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

    fun assertLstEq showEl = assertEq (Util.showList showEl)

    val assertEqI = assertEq Int.toString
    val assertStrEq = assertEq (fn x => "\"" ^ x ^ "\"")
    val assertIntListEq = assertLstEq Int.toString

    fun testMain suite =
      ((testRunner suite); OS.Process.success)
      handle e => (Util.printLn ("FAIL\n" ^ ("Uncaught exception: " ^ (exnMessage e)));
                   OS.Process.failure)
  end

end