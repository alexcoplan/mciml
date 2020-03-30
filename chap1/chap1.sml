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

  datatype interp_io = IOPrint | IOBuf of string

  exception NameError of id
  local
    type table = (id * int) list
    type store = interp_io * table

    fun lookupTable [] id = raise (NameError id)
      | lookupTable ((id,n)::env) targetId =
        if id = targetId then n
        else lookupTable env targetId

    fun lookup ((io, tab) : store) id = lookupTable tab id

    fun updateTable [] p = [p]
      | updateTable ((id,n)::env) (newId, m) =
        if id = newId then (id, m) :: env
        else updateTable env (newId, m)

    fun update ((io, tab) : store) kv = (io, updateTable tab kv)

    fun doIO (IOPrint, table) line = (print line; (IOPrint, table))
      | doIO (IOBuf buf, table) line = (IOBuf (buf ^ line), table)

    fun doOp v1 Plus v2 = v1 + v2
      | doOp v1 Minus v2 = v1 - v2
      | doOp v1 Times v2 = v1 * v2
      | doOp v1 Div v2 = v1 div v2

    fun interpExpr (IdExp id) (store : store) = (lookup store id, store)
      | interpExpr (NumExp n) store = (n, store)
      | interpExpr (OpExp (e1, theOp, e2)) store =
        let
          val (v1, s') = (interpExpr e1 store)
          val (v2, s'') = (interpExpr e2 s')
        in
          (doOp v1 theOp v2, s'')
        end
      | interpExpr (EseqExp (s1,e1)) store =
        interpExpr e1 (interpStmt s1 store)
    and interpStmt (CompoundStm (s1,s2)) store =
        let val store' = interpStmt s1 store
        in interpStmt s2 store'
        end
      | interpStmt (AssignStm (id, e1)) store =
        let val (v1, store') = interpExpr e1 store
        in
          update store' (id, v1)
        end
      | interpStmt (PrintStm exprList) store =
      let
        fun foldFn (e, (s, str)) =
          let
            val (v, s') = interpExpr e s
            val vStr = Int.toString v
            val newStr =
              if (String.size str) = 0
              then vStr else (str ^ " " ^ vStr)
          in (s', newStr)
          end
        val (store', line) = List.foldl foldFn (store, "") exprList
      in
        doIO store' (line ^ "\n")
      end
  in
    fun interp stmt = (interpStmt stmt (IOPrint, []); ())

    fun interpStr stmt =
      case interpStmt stmt (IOBuf "", []) of
           (IOBuf s, _) => s
         | (IOPrint, _) => raise (Fail "Unexpected IOPrint")
  end

end
