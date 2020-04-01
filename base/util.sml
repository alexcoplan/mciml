structure Util = struct
  fun id x = x
  fun printLn s = print (s ^ "\n")

  (* join a list of strings with a given separator *)
  fun join _ [] = ""
    | join _ [x] = x
    | join sep (x::xs) = x ^ sep ^ (join sep xs)

  fun showList showEl lst = "[" ^ (join "," (List.map showEl lst)) ^ "]"

  fun showOpt _ NONE = "NONE"
    | showOpt showEl (SOME x) = "SOME(" ^ (showEl x) ^ ")"

  fun showPair showA showB (a, b) = "(" ^ (showA a) ^ "," ^ (showB b) ^ ")"

  fun upcase str = String.map Char.toUpper str

  fun startsWith _ [] = true
    | startsWith [] _ = false
    | startsWith (x :: xs) (y :: ys) =
      if x=y then startsWith xs ys else false

  fun lstlst haystack needle =
    let
      val haystackLen = List.length haystack
      val needleLen = List.length needle
      fun iter hs i =
        if haystackLen < needleLen + i then NONE
        else if startsWith hs needle then SOME(i)
        else iter (tl hs) (i+1)
    in
      iter haystack 0
    end

  fun strstr haystack needle =
    lstlst (String.explode haystack) (String.explode needle)

  fun splitOnce str sep =
    let
      fun mapFn pos =
        (String.substring (str, 0, pos),
         String.extract (str, pos + String.size sep, NONE))
    in
      Option.map mapFn (strstr str sep)
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
