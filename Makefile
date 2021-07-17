# Be sure to use yacc/j ; not unix yacc nor bison.
BYACCJ = yacc -J
JFLEX  = jflex

generate: Lexer.java Parser.java

Lexer.java: src/lexer/rules.flex src/token/*
	$(JFLEX) src/lexer/rules.flex

Parser.java: src/parser/grammar.y src/token/*
	cd src/parser; $(BYACCJ) -v grammar.y

clean:
	cd src/lexer; rm -f Lexer.java Lexer.java~;
	cd src/parser; rm -f Parser.java ParserVal.java y.output
