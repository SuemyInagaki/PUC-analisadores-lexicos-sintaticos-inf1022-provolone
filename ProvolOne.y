%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>



int yylex();
void yyerror(const char *s){
      fprintf(stderr, "%s\n", s);
   };
//Declaração do arquivo de saída.
   FILE *f;
   

%}
//Union necessária para definir os tipos dos tolkens
%union
 {
   char *str;
   int  number;
};
// declaracao dos  tipos dos tolkens.
%type <str> program varlist ret cmds cmd; //
%token <str> ID;
%token <number> ENTRADA; // indica entrada do programa
%token <number> SAIDA; // indica saida do programa
%token <number> END;  // indica final do programa
%token <number> FIML; // para o \n
%token <number> ENTAO; // corpo if
%token <number> SE;   // comeco if
%token <number> SENAO;// else
%token <number> INC; // i++
%token <number> ZERA;// variavel = 0;
%token <number> FIM; // Para o final do if else
%token <number> EQUAL;// Para o sinal de igualdade
%token <number> AP; // Abre parenteses
%token <number> FP; // Fecha parenteses
// a variavel que vai começar a gramatica 
%start program
%%
program : ENTRADA varlist SAIDA ret cmds END FIML
{
  fprintf(f, "Codigo objeto\n %s\n%s\n%s\n", $2,$5,$4);
  fclose(f);
  printf("o programa foi executado com sucesso");
  exit(0);
};
varlist : varlist ID {
  char *entrada=malloc(strlen($1) + strlen($2) + 20);
  sprintf(entrada, "%s int %s;\n", $1, $2);
  $$ = entrada;
};
| ID {
    char *val = malloc(strlen($1) +20);
    sprintf(val,"int %s;",$1);
    $$ = val;

};
cmds : cmds cmd {
          char *corpo=malloc(strlen($1) + strlen($2) + 20);
          sprintf(corpo, "%s%s\n", $1, $2);
          $$=corpo;
        };
        | cmd {
          char *corpo2=malloc(strlen($1) + 15);
          sprintf(corpo2, "%s", $1);
          $$=corpo2;
        };
cmd : SE ID ENTAO cmds SENAO cmds FIM{
          char *condicional1=malloc(strlen($2) + strlen($4) + strlen($6) + 40);
          sprintf(condicional1, "if (%s) {\n\t%s} else {\n\t%s }\n", $2, $4, $6);
          $$ = condicional1;};
      | SE ID ENTAO cmds FIM {
        char *condicional2 = malloc(strlen($2) + strlen($4) + 40);
        sprintf(condicional2, "if (%s) {\n\t%s}\n", $2, $4);
        $$ = condicional2;};
      | ID EQUAL ID{
        char *igualdade=malloc(strlen($1) + strlen($3) + 20);
        sprintf(igualdade, "%s = %s;\n",$1,$3);
        $$ = igualdade;
      };
      | INC AP ID FP{
        char *soma=malloc(strlen($3) + 20);
        sprintf(soma, "%s++;\n",$3);
        $$ = soma;
      };
      | ZERA AP ID FP{
        char *zerou=malloc(strlen($3) + 20);
        sprintf(zerou, "%s = 0;\n",$3);
        $$ = zerou;
      };
ret : ID {
      char *val2 = malloc(strlen($1) +20);
      sprintf(val2,"return %s;",$1);
      $$ = val2;
}
%%

int main(int argc, char *argv[]){
f = fopen("codigo.c", "w");
   if(f == NULL)
   {
     fprintf(stderr, "erro na abertura do arquivo");
     exit(1);
   }

    yyparse();
    return(0);
}
