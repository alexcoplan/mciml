structure LexUtil = struct
  fun stringSource str =
  let
    val buf = ref (String.explode str)
  in
    fn n =>
      let val (now, later) = Util.takeDrop (! buf) n
      in (buf := later; String.implode now) end
  end
end
