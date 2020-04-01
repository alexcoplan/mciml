local
  structure T = Test

  val keywords = [
    "while",
    "for",
    "to",
    "break",
    "let",
    "in",
    "end",
    "function",
    "var",
    "type",
    "array",
    "if",
    "then",
    "else",
    "do",
    "of",
    "nil"
  ]
  val punctuation = [
   ( ",", "COMMA" ),
   ( ":", "COLON" ),
   ( ";", "SEMICOLON" ),
   ( "(", "LPAREN" ),
   ( ")", "RPAREN" ),
   ( "[", "LBRACK" ),
   ( "]", "RBRACK" ),
   ( "{", "LBRACE" ),
   ( "}", "RBRACE" ),
   ( ".", "DOT" ),
   ( "+", "PLUS" ),
   ( "-", "MINUS" ),
   ( "*", "TIMES" ),
   ( "/", "DIVIDE" ),
   ( "=", "EQ" ),
   ( "<>", "NEQ" ),
   ( "<", "LT" ),
   ( "<=", "LE" ),
   ( "<>", "NEQ" ),
   ( "<", "LT" ),
   ( "<=", "LE" ),
   ( ">", "GT" ),
   ( ">=", "GE" ),
   ( "&", "AND" ),
   ( "|", "OR" ),
   ( ":=", "ASSIGN" )
  ]

  val punct_symbols = List.map (fn x => #1 x) punctuation
  val punct_toktypes = List.map (fn x => #2 x) punctuation

  val lexer_cases = [
    ( "type", [ "TYPE", "EOF" ] ),
    ( Util.join " " keywords, List.map Util.upcase keywords ),
    ( Util.join " " punct_symbols, punct_toktypes ),
    ( "x", [ "ID(x)", "EOF" ] ),
    ( "abc a3 myVar_b23", [ "ID(abc)", "ID(a3)", "ID(myVar_b23)", "EOF" ] ),
    ( "5 23 442", [ "INT(5)", "INT(23)", "INT(442)", "EOF" ] ),
    ( "\"test_string_lit\"", [ "STRING(\"test_string_lit\")" ] ),
    ( "\"string lit with spaces\" a2",
        [ "STRING(\"string lit with spaces\")", "ID(a2)", "EOF" ] ),
    ( "\"myStr\" myId \"myStr2\"",
        [ "STRING(\"myStr\")", "ID(myId)", "STRING(\"myStr2\")", "EOF" ] )
  ]

  (* cheap hack - we just care about the first part of the string
   * used to represent the token *)
  fun tokType tokStr =
    case (Util.splitOnce tokStr "   ") of
         NONE => raise (Fail "bad token string")
      | (SOME (ty,_)) => ty

  fun lexerTest (input, toks) =
  let
    val lexer = Mlex.makeLexer (LexUtil.stringSource input)
    fun iter [] = ()
      | iter (t :: ts) = (T.assertStrEq (tokType (lexer ())) t; iter ts)
  in
    iter toks
  end

  val tests = [
    ( "test_string_source", fn () =>
      let val src = LexUtil.stringSource "hello"
      in
        (T.assertStrEq (src 2) "he";
         T.assertStrEq (src 1) "l";
         T.assertStrEq (src 2) "lo")
      end
    ),
    ( "test_lexer", fn () => (List.map lexerTest lexer_cases; ()) )
  ]
in

  structure TestLexer =
  struct
    fun main _ = T.testMain tests
  end

end
