structure Util = struct
  fun id x = x
  fun printLn s = print (s ^ "\n")

  (* join a list of strings with a given separator *)
  fun join _ [] = ""
    | join _ [x] = x
    | join sep (x::xs) = x ^ sep ^ (join sep xs)

  fun showList showEl lst = "[" ^ (join "," (List.map showEl lst)) ^ "]"

  fun upcase str = String.map Char.toUpper str

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
