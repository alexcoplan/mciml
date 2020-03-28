structure Util = struct
  fun id x = x
  fun printLn s = print (s ^ "\n")

  fun showList showEl lst =
  let
    fun iter [] = ""
      | iter [x] = showEl x
      | iter (x :: xs) = (showEl x) ^ "," ^ (iter xs)
  in
    "[" ^ (iter lst) ^ "]"
  end

  local
    fun tdIter [] _ taken = (List.rev taken, [])
      | tdIter rest 0 taken = (List.rev taken, rest)
      | tdIter (x :: xs) n taken = tdIter xs (n-1) (x :: taken)
  in
    fun takeDrop lst n =
      if n >= 0 then tdIter lst n []
      else raise (Fail ("takeDrop with negative n = " ^ (Int.toString n)))
  end

end
