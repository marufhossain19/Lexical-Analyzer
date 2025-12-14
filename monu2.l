%option noyywrap

%{
#include "monu2.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"o monu shuru koro//"       { return START; }
"o monu eibar sesh koro//"  { return FINISH; }

dekhao           { return SHOW; }
store            { return STORE; }
jodi             { return IF; }
taile            { return THEN; }
naile            { return ELSE; }
hoy              { return HOY; }

"jog koro"       { return PLUS; }
"biyog koro"     { return MINUS; }
"gun koro"       { return TIMES; }
"vag koro"       { return DIVIDE; }

"theke boro othoba soman"   { return LTE; }
"theke choto othoba soman"  { return GTE; }
"theke boro"                { return LT; }
"theke choto"               { return GT; }
"soman soman"               { return EQ; }
"soman na"                  { return NEQ; }

[0-9]+\.[0-9]+   { yylval.fval = atof(yytext); return NUMBER; }
[0-9]+           { yylval.fval = atof(yytext); return NUMBER; }

\"[^\"]*\"       { 
                    yytext[strlen(yytext)-1] = '\0';  // Remove closing quote
                    yylval.sval = strdup(yytext+1);   // Skip opening quote
                    return STRING; 
                }

[A-Za-z_][A-Za-z0-9_]*  { yylval.sval = strdup(yytext); return IDENT; }

".."             { return '.'; }
"("              { return '('; }
")"              { return ')'; }

[ \t\n\r]+       { }
"#"[^\n]*        { }

.                { return yytext[0]; }

%%
