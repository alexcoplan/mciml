structure Chap1 = struct

  type id = string

  datatype binop = Plus | Minus | Times | Div

  datatype stm = CompoundStm of stm * stm
         | AssignStm of id * exp
         | PrintStm of exp list

       and exp = IdExp of id
         | NumExp of int
               | OpExp of exp * binop * exp
               | EseqExp of stm * exp
  val prog =
   CompoundStm(AssignStm("a",OpExp(NumExp 5, Plus, NumExp 3)),
    CompoundStm(AssignStm("b",
        EseqExp(PrintStm[IdExp"a",OpExp(IdExp"a", Minus,NumExp 1)],
             OpExp(NumExp 10, Times, IdExp"a"))),
     PrintStm[IdExp "b"]))

  fun maxargsE (OpExp (e1,_,e2)) = Int.max (maxargsE e1, maxargsE e2)
    | maxargsE (EseqExp (s1,e1)) = Int.max (maxargs s1, maxargsE e1)
    | maxargsE _ = 0
  and maxargs (PrintStm exprList) =
    let
      val innerMaxes = List.map (fn e => maxargsE e) exprList
      val innerMax = List.foldl Int.max 0 innerMaxes
    in
      Int.max (List.length exprList, innerMax)
    end
    | maxargs (AssignStm (_,e1)) = maxargsE e1
    | maxargs (CompoundStm (s1,s2)) = Int.max (maxargs s1, maxargs s2)

end;
