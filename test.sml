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
      else OS.Process.success

    fun assertEqI x y = assertEq Int.toString x y

    fun testMain suite =
      (testRunner suite)
      handle e => (Util.printLn ("FAIL\n" ^ ("Uncaught exception: " ^ (exnMessage e)));
                   OS.Process.failure)
  end

end
