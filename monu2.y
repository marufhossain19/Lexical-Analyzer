%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct symnode {
    char *name;
    double value;
    struct symnode *next;
} symnode;

typedef struct output {
    int is_string;      // 1 for string, 0 for number
    union {
        double value;
        char *text;
    } data;
    struct output *next;
} output;

symnode *symtab = NULL;
output *outputs = NULL;
int program_started = 0;
int silent_mode = 1;
int skip_execution = 0;

double lookup(const char *name);
void insert(const char *name, double value);
void add_output(double value);
void add_string_output(const char *text);
void print_all_outputs();
int yylex();
void yyerror(const char *s);
#define UNDEF (-999999.999)
%}

%union {
    double fval;
    char* sval;
}

%token <fval> NUMBER
%token <sval> IDENT STRING
%token SHOW STORE IF THEN ELSE END HOY
%token START FINISH
%token GT LT GTE LTE EQ NEQ

%type <fval> expr

%left EQ NEQ
%left GT LT GTE LTE
%left PLUS MINUS
%left TIMES DIVIDE
%right UMINUS

%%

program:
      program stmt
    |
    ;

stmt:
      START
        {
            program_started = 1;
            printf("\n\033[32m\033[1m\033[5m*** Monu2 ACTIVATED! ***\033[0m\033[32m Type your magical code...\033[0m\n\n");
        }
    | STORE IDENT expr '.'
        {
            if (!program_started) {
                yyerror("Agey 'o monu shuru koro//' likho!");
            } else if (!skip_execution) {
                insert($2, $3);
                if (!silent_mode) printf("\033[36m>> Stored %s = %.2f\033[0m\n", $2, $3);
            }
            free($2);
        }
    | SHOW STRING '.'
        {
            if (!program_started) {
                yyerror("Agey 'o monu shuru koro//' likho!");
            } else if (!skip_execution) {
                add_string_output($2);
            }
            free($2);
        }
    | SHOW expr '.'
        {
            if (!program_started) {
                yyerror("Agey 'o monu shuru koro//' likho!");
            } else if (!skip_execution) {
                add_output($2);
            }
        }
    | expr '.'
        { }
    | IF '(' expr ')' HOY THEN 
        { 
            skip_execution = ($3 == 0);
        } 
        stmtlist
        { 
            skip_execution = ($3 != 0);
        } 
        elselist
        { 
            skip_execution = 0;
        }
    | FINISH
        {
            if (!program_started) {
                yyerror("Program shuru kora hoy nai!");
            } else {
                printf("\n\033[33m\033[1m\033[5m*** Monu2 FINISHING! ***\033[0m\033[33m Results coming...\033[0m\n");
                print_all_outputs();
                exit(0);
            }
        }
    ;

stmtlist:
      stmtlist stmt
    | stmt
    ;

elselist:
      ELSE stmtlist
    | /* empty */
    ;

expr:
      expr PLUS expr      { $$ = $1 + $3; }
    | expr MINUS expr     { $$ = $1 - $3; }
    | expr TIMES expr     { $$ = $1 * $3; }
    | expr DIVIDE expr
        {
            if ($3 == 0) {
                yyerror("Shunno diye vag kora jay na!");
                $$ = 0;
            } else {
                $$ = $1 / $3;
            }
        }
    | expr GT expr        { $$ = ($1 > $3) ? 1.0 : 0.0; }
    | expr LT expr        { $$ = ($1 < $3) ? 1.0 : 0.0; }
    | expr GTE expr       { $$ = ($1 >= $3) ? 1.0 : 0.0; }
    | expr LTE expr       { $$ = ($1 <= $3) ? 1.0 : 0.0; }
    | expr EQ expr        { $$ = ($1 == $3) ? 1.0 : 0.0; }
    | expr NEQ expr       { $$ = ($1 != $3) ? 1.0 : 0.0; }
    | MINUS expr %prec UMINUS  { $$ = -$2; }
    | IDENT
        {
            double v = lookup($1);
            if (v == UNDEF) {
                char msg[256];
                snprintf(msg, sizeof(msg), "Undefined variable: %s", $1);
                yyerror(msg);
                $$ = 0;
            } else {
                $$ = v;
            }
            free($1);
        }
    | NUMBER              { $$ = $1; }
    | '(' expr ')'        { $$ = $2; }
    ;

%%

double lookup(const char *name) {
    symnode *curr = symtab;
    while (curr) {
        if (strcmp(curr->name, name) == 0)
            return curr->value;
        curr = curr->next;
    }
    return UNDEF;
}

void insert(const char *name, double value) {
    symnode *curr = symtab;
    while (curr) {
        if (strcmp(curr->name, name) == 0) {
            curr->value = value;
            return;
        }
        curr = curr->next;
    }
    symnode *node = (symnode*)malloc(sizeof(symnode));
    node->name = strdup(name);
    node->value = value;
    node->next = symtab;
    symtab = node;
}

void add_output(double value) {
    output *node = (output*)malloc(sizeof(output));
    node->is_string = 0;
    node->data.value = value;
    node->next = outputs;
    outputs = node;
}

void add_string_output(const char *text) {
    output *node = (output*)malloc(sizeof(output));
    node->is_string = 1;
    node->data.text = strdup(text);
    node->next = outputs;
    outputs = node;
}

void print_all_outputs() {
    #define RESET   "\033[0m"
    #define BOLD    "\033[1m"
    #define CYAN    "\033[36m"
    #define YELLOW  "\033[33m"
    #define GREEN   "\033[32m"
    #define MAGENTA "\033[35m"
    #define BLUE    "\033[34m"
    #define RED     "\033[31m"
    #define BG_BLUE "\033[44m"
    #define BG_GREEN "\033[42m"
    
    printf("\n");
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf(BG_BLUE YELLOW BOLD "                      *** OUTPUT ***                        " RESET "\n");
    printf(CYAN BOLD "************************************************************\n" RESET);
    
    output *curr = outputs;
    
    // Reverse the list
    output *prev = NULL;
    while (curr) {
        output *next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }
    
    curr = prev;
    int count = 0;
    
    // Colorful results with alternating colors
    while (curr) {
        const char *color = (count % 2 == 0) ? GREEN : MAGENTA;
        count++;
        
        if (curr->is_string) {
            // Print string
            printf("%s", color);
            printf(BOLD "  >> " RESET);
            printf(YELLOW BOLD "%s" RESET, curr->data.text);
            printf(GREEN " <<\n" RESET);
            free(curr->data.text);
        } else {
            // Print number
            if (curr->data.value == (int)curr->data.value) {
                printf("%s", color);
                printf(BOLD "  >> " RESET);
                printf(YELLOW BOLD "%d" RESET, (int)curr->data.value);
                printf(GREEN " <<\n" RESET);
            } else {
                printf("%s", color);
                printf(BOLD "  >> " RESET);
                printf(YELLOW BOLD "%.2f" RESET, curr->data.value);
                printf(GREEN " <<\n" RESET);
            }
        }
        curr = curr->next;
    }
    
    if (count == 0) {
        printf(RED BOLD "  (kono output nai)\n" RESET);
    }
    
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf("\n");
}

void yyerror(const char *s) {
    fprintf(stderr, "\033[31m\033[1m\033[5m!!! ERROR: %s !!!\033[0m\n", s);
}

int main() {
    #define RESET   "\033[0m"
    #define BOLD    "\033[1m"
    #define CYAN    "\033[36m"
    #define YELLOW  "\033[33m"
    #define GREEN   "\033[32m"
    #define MAGENTA "\033[35m"
    #define BLUE    "\033[34m"
    #define RED     "\033[31m"
    #define BG_CYAN "\033[46m"
    #define BG_MAGENTA "\033[45m"
    
    printf("\n");
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf(BG_MAGENTA YELLOW BOLD "                                                            " RESET "\n");
    printf(BG_MAGENTA YELLOW BOLD "     *** MONU2 - Super Creative Bangla Calculator ***      " RESET "\n");
    printf(BG_MAGENTA CYAN "              (Enhanced with Comparisons!)                  " RESET "\n");
    printf(BG_MAGENTA YELLOW BOLD "                                                            " RESET "\n");
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf("\n");
    
    printf(GREEN BOLD "  >> SHURU:  " RESET CYAN BOLD "o monu shuru koro//\n" RESET);
    printf(RED BOLD "  >> SESH:   " RESET CYAN BOLD "o monu eibar sesh koro//\n" RESET);
    printf(YELLOW BOLD "  >> ENDING: " RESET MAGENTA "Use '..' (double dot) to end statements!\n" RESET);
    printf("\n");
    
    printf(YELLOW BOLD "  COMMANDS:\n" RESET);
    printf(BLUE "    * store <var> <value> ..    " RESET "- Save value\n");
    printf(BLUE "    * dekhao <expression> ..    " RESET "- Show result\n");
    printf("\n");
    
    printf(YELLOW BOLD "  ARITHMETIC OPERATORS:\n" RESET);
    printf(GREEN "    + jog koro       " RESET "- Addition\n");
    printf(GREEN "    - biyog koro     " RESET "- Subtraction\n");
    printf(GREEN "    * gun koro       " RESET "- Multiplication\n");
    printf(GREEN "    / vag koro       " RESET "- Division\n");
    printf("\n");
    
    printf(YELLOW BOLD "  COMPARISON OPERATORS (NEW!):\n" RESET);
    printf(MAGENTA "    > theke choto                " RESET "- Greater than\n");
    printf(MAGENTA "    < theke boro               " RESET "- Less than\n");
    printf(MAGENTA "    >= theke boro othoba soman  " RESET "- Greater or equal\n");
    printf(MAGENTA "    <= theke choto othoba soman " RESET "- Less or equal\n");
    printf(MAGENTA "    == soman soman              " RESET "- Equal to\n");
    printf(MAGENTA "    != soman na                 " RESET "- Not equal\n");
    printf("\n");
    
    printf(YELLOW BOLD "  CONDITIONALS:\n" RESET);
    printf(CYAN "    jodi ( condition ) hoy taile ... shesh\n" RESET);
    printf(CYAN "    jodi ( condition ) hoy taile ... naile ... shesh\n" RESET);
    printf("\n");
    
    printf("\n");
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf(CYAN BOLD "************************************************************\n" RESET);
    printf("\n");
    
    yyparse();
    return 0;
}
