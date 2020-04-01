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
    ( Util.join " " punct_symbols, punct_toktypes )
  ]

  fun tokType tokStr = hd (String.tokens (fn c => c = #" ") tokStr)

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
    (
      "test_lexer", fn () => (List.map lexerTest lexer_cases; ())
    )
  ]
in

  structure TestLexer =
  struct
    fun main _ = T.testMain tests
  end

end
