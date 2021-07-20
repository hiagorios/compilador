JFLEX  = jflex
BISON = bison -v -t -Wall -Wother

generate: Lexer.java Parser.java

Lexer.java: src/lexer/rules.flex src/token/*
	$(JFLEX) src/lexer/rules.flex

Parser.java: src/parser/grammar.y src/token/*
	cd src/parser; $(BISON) grammar.y

clean:
	rm -rf out;
	cd src/lexer; rm -f YYLexer.java YYLexer.java~;
	cd src/parser; rm -f Parser.java Parser.output
