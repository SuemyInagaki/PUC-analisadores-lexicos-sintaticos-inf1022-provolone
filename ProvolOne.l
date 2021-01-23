%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "ProvolOne.tab.h"
%%
END return(END);
SAIDA return(SAIDA);
ENTRADA return(ENTRADA);
SE return(SE);
ENTAO return(ENTAO);
SENAO return(SENAO);
ZERA 		return(ZERA);
INC 		return(INC);
FIM		return(FIM);
\n		return(FIML);
"=" 		return(EQUAL);
"(" 		return(AP);
")"		return(FP);
[a-zA-Z]+   {printf("lido %s",yytext); yylval.str=strdup(yytext); return ID ; }
