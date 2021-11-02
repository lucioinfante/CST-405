all: parser

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer2.l parser.tab.h
	flex lexer2.l

parser: lex.yy.c parser.tab.c parser.tab.h
	gcc -o parser parser.tab.c lex.yy.c
	./parser LexerTest.cmon

clean:
	rm -f parser lexer parser.tab.c lex.yy.c parser.tab.h parser.output
	ls -l
