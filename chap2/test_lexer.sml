local
  structure T = Test
  structure Lex = TigerLexFun(structure Tokens = MockTokens)

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

val tiger_test1 = "/* an array type and an array variable */ \
\ let \
\   type arrtype = array of int \
\   var arr1:arrtype := arrtype [10] of 0 \
\ in \
\   arr1 \
\ end"

  val tiger_test1_toks = [
    "LET", "TYPE", "ID(arrtype)", "EQ", "ARRAY", "OF", "ID(int)",
    "VAR", "ID(arr1)", "COLON", "ID(arrtype)", "ASSIGN", "ID(arrtype)",
    "LBRACK", "INT(10)", "RBRACK", "OF", "INT(0)", "IN", "ID(arr1)",
    "END", "EOF"
  ]


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
        [ "STRING(\"myStr\")", "ID(myId)", "STRING(\"myStr2\")", "EOF" ] ),
    ( "\"a \\\"quote in a string\" xy23 \"more string\"",
        [ "STRING(\"a \"quote in a string\")", "ID(xy23)",
          "STRING(\"more string\")", "EOF" ]
    ),
    ( "\"here\\nare\\tsome\\\"escapes\"",
      [ "STRING(\"here\nare\tsome\"escapes\")", "EOF" ] ),
    ( "x2 /* a comment */ y2", [ "ID(x2)", "ID(y2)", "EOF" ] ),
    ( "a1 /* a comment */ x2 /* and another */ b3",
      [ "ID(a1)", "ID(x2)", "ID(b3)", "EOF" ] ),
    ( tiger_test1, tiger_test1_toks )
  ]

  fun tokType (ty, _) = ty

  fun lexerTest (input, toks) =
  let
    val lexer = Lex.makeLexer (LexUtil.stringSource input)
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
    ( "test_unescape", fn () => T.assertStrEq (LexUtil.unescape "\\\\") "\\" ),
    ( "test_lexer", fn () => (List.map lexerTest lexer_cases; ()) )
  ]
in

  structure TestLexer =
  struct
    fun main _ = T.testMain tests
  end

end
