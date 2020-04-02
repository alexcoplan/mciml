structure LexUtil = struct
  fun stringSource str =
  let
    val buf = ref (String.explode str)
  in
    fn n =>
      let val (now, later) = Util.takeDrop (! buf) n
      in (buf := later; String.implode now) end
  end

  exception Escape of string

  local
    (* TODO: other escapes! see p517 *)
    fun escapeMap #"\\" = "\\"
      | escapeMap #"\"" = "\""
      | escapeMap #"n" = "\n"
      | escapeMap #"t" = "\t"
      | escapeMap c = raise (Escape ("unknown escape " ^ (String.str c)))

    fun iter [] = ""
      | iter (x :: xs) =
      if x = #"\\" then escape xs else (String.str x) ^ (iter xs)
    and escape [] = raise (Escape "incomplete escape sequence")
      | escape (x :: xs) = (escapeMap x) ^ (iter xs)

  in
    fun unescape str = iter (String.explode str)
  end


end
