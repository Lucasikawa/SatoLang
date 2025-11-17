%{
/*
 * SatoLang - Compilador com Geração de Código
 * Linguagens e Paradigmas - APS Etapa 3
 *
 * Este arquivo compila programas SatoLang para Assembly da Bitcoin VM.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declarações de funções */
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
void emit(const char *code);
void emit_label(const char *label);

/* Arquivo de saída Assembly */
FILE *output_file = NULL;

/* Contadores para labels únicos */
int label_counter = 0;
int loop_counter = 0;

/* Flag para indicar se houve erro */
int parse_error = 0;

/* Buffer para geração de código */
char code_buffer[1024];
%}

/* União para os valores semânticos dos tokens */
%union {
    int num;
    char *str;
}

/* Definição dos tokens */
%token GENESIS SATOSHI SUPPLY REWARD START_PRICE
%token WALLET MINE MARKET UPDATE SHOWCHAIN
%token IF ELSE WHILE FOR
%token BUY_THE_DIP TAKE_PROFIT_UNTIL HODL_UNTIL SCALP_FOR MARKET_FOR
%token STRATEGY CALL BATTLE VS
%token SALDO
%token EQ NEQ GTE LTE GT LT
%token ARROW COLON LPAREN RPAREN LBRACE RBRACE COMMA
%token <str> IDENTIFIER
%token <num> NUMBER
%token INVALID_CHAR

/* Tipos dos não-terminais */
%type <num> rel_op

/* Símbolo inicial */
%start program

%%

/* ========== PROGRAMA PRINCIPAL ========== */
program:
    genesis statement_list
    {
        emit("HALT");
        if (!parse_error) {
            printf("\n✅ Compilação concluída com sucesso!\n");
            printf("   Assembly gerado no arquivo de saída.\n");
        }
    }
    ;

/* ========== BLOCO GENESIS ========== */
genesis:
    GENESIS SATOSHI SUPPLY NUMBER REWARD NUMBER START_PRICE NUMBER
    {
        sprintf(code_buffer, "GENESIS %d %d %d", $4, $6, $8);
        emit(code_buffer);
    }
    ;

/* ========== LISTA DE STATEMENTS ========== */
statement_list:
    /* vazio */
    | statement_list statement
    ;

/* ========== STATEMENT ========== */
statement:
    wallet_stmt
    | transaction_stmt
    | mining_stmt
    | market_stmt
    | blockchain_stmt
    | if_stmt
    | loop_stmt
    | trading_loop_stmt
    | market_loop_stmt
    | strategy_dec
    | strategy_call
    | battle_stmt
    ;

/* ========== WALLET ========== */
wallet_stmt:
    WALLET IDENTIFIER
    {
        sprintf(code_buffer, "WALLET %s", $2);
        emit(code_buffer);
        free($2);
    }
    ;

/* ========== MINING ========== */
mining_stmt:
    IDENTIFIER MINE
    {
        sprintf(code_buffer, "MINE %s", $1);
        emit(code_buffer);
        free($1);
    }
    ;

/* ========== TRANSACTION ========== */
transaction_stmt:
    IDENTIFIER ARROW IDENTIFIER COLON NUMBER
    {
        sprintf(code_buffer, "TRANSFER %s %s %d", $1, $3, $5);
        emit(code_buffer);
        free($1);
        free($3);
    }
    ;

/* ========== MARKET ========== */
market_stmt:
    MARKET
    {
        emit("MARKET_SHOW");
    }
    | MARKET UPDATE
    {
        emit("MARKET_UPDATE");
    }
    ;

/* ========== BLOCKCHAIN ========== */
blockchain_stmt:
    SHOWCHAIN
    {
        emit("SHOWCHAIN");
    }
    ;

/* ========== IF STATEMENT ========== */
if_stmt:
    IF condition LBRACE
    {
        sprintf(code_buffer, "L_IF_%d", label_counter);
        char *else_label = strdup(code_buffer);
        sprintf(code_buffer, "L_END_%d", label_counter);
        char *end_label = strdup(code_buffer);
        label_counter++;

        sprintf(code_buffer, "JUMPZ %s", else_label);
        emit(code_buffer);

        // Guarda labels na pilha semântica (simplificado: usa variáveis globais)
    }
    statement_list RBRACE
    {
        sprintf(code_buffer, "L_END_%d", label_counter - 1);
        emit_label(code_buffer);
    }
    | IF condition LBRACE
    {
        sprintf(code_buffer, "L_ELSE_%d", label_counter);
        char *else_label = strdup(code_buffer);
        sprintf(code_buffer, "L_END_%d", label_counter);
        char *end_label = strdup(code_buffer);
        label_counter++;

        sprintf(code_buffer, "JUMPZ L_ELSE_%d", label_counter - 1);
        emit(code_buffer);
    }
    statement_list RBRACE ELSE LBRACE
    {
        sprintf(code_buffer, "JUMP L_END_%d", label_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_ELSE_%d", label_counter - 1);
        emit_label(code_buffer);
    }
    statement_list RBRACE
    {
        sprintf(code_buffer, "L_END_%d", label_counter - 1);
        emit_label(code_buffer);
    }
    ;

/* ========== CONDITION ========== */
condition:
    SALDO IDENTIFIER rel_op NUMBER
    {
        sprintf(code_buffer, "BALANCE %s", $2);
        emit(code_buffer);

        // Gera comparação baseada no operador relacional
        switch($3) {
            case 1: // GT
                sprintf(code_buffer, "LOAD R1, %d", $4);
                emit(code_buffer);
                emit("GT R0, R1");  // Simplificado
                break;
            case 2: // LT
                sprintf(code_buffer, "LOAD R1, %d", $4);
                emit(code_buffer);
                sprintf(code_buffer, "LT R0 %d", $4);
                emit(code_buffer);
                break;
            case 3: // GTE
                sprintf(code_buffer, "GTE R0 %d", $4);
                emit(code_buffer);
                break;
            case 4: // LTE
                sprintf(code_buffer, "LTE R0 %d", $4);
                emit(code_buffer);
                break;
            case 5: // EQ
                sprintf(code_buffer, "EQ R0 %d", $4);
                emit(code_buffer);
                break;
            case 6: // NEQ
                sprintf(code_buffer, "NEQ R0 %d", $4);
                emit(code_buffer);
                break;
        }
        free($2);
    }
    | MARKET rel_op NUMBER
    {
        emit("MARKET_LOAD");

        switch($2) {
            case 1: sprintf(code_buffer, "GT R0 %d", $3); break;
            case 2: sprintf(code_buffer, "LT R0 %d", $3); break;
            case 3: sprintf(code_buffer, "GTE R0 %d", $3); break;
            case 4: sprintf(code_buffer, "LTE R0 %d", $3); break;
            case 5: sprintf(code_buffer, "EQ R0 %d", $3); break;
            case 6: sprintf(code_buffer, "NEQ R0 %d", $3); break;
        }
        emit(code_buffer);
    }
    ;

/* ========== OPERADORES RELACIONAIS ========== */
rel_op:
    GT      { $$ = 1; }
    | LT    { $$ = 2; }
    | GTE   { $$ = 3; }
    | LTE   { $$ = 4; }
    | EQ    { $$ = 5; }
    | NEQ   { $$ = 6; }
    ;

/* ========== LOOPS ========== */
loop_stmt:
    while_loop
    | for_loop
    ;

while_loop:
    WHILE
    {
        sprintf(code_buffer, "L_WHILE_START_%d", loop_counter);
        emit_label(code_buffer);
        loop_counter++;
    }
    condition LBRACE statement_list RBRACE
    {
        sprintf(code_buffer, "JUMPZ L_WHILE_END_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "JUMP L_WHILE_START_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_WHILE_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    ;

for_loop:
    FOR NUMBER
    {
        sprintf(code_buffer, "LOAD R0, %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "L_FOR_START_%d", loop_counter);
        emit_label(code_buffer);
        sprintf(code_buffer, "JUMPZ L_FOR_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    LBRACE statement_list RBRACE
    {
        emit("SUB R0, 1");
        sprintf(code_buffer, "JUMP L_FOR_START_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_FOR_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    ;

/* ========== TRADING LOOPS ========== */
trading_loop_stmt:
    BUY_THE_DIP NUMBER LBRACE
    {
        emit("# Trading loop: buy_the_dip");
        sprintf(code_buffer, "LOAD R0, %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "L_LOOP_%d", loop_counter);
        emit_label(code_buffer);
        sprintf(code_buffer, "JUMPZ L_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    statement_list RBRACE
    {
        emit("SUB R0, 1");
        sprintf(code_buffer, "JUMP L_LOOP_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    | TAKE_PROFIT_UNTIL NUMBER LBRACE
    {
        emit("# Trading loop: take_profit_until");
        sprintf(code_buffer, "L_LOOP_%d", loop_counter);
        emit_label(code_buffer);
        emit("MARKET_LOAD");
        sprintf(code_buffer, "LT R0 %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "JUMPZ L_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    statement_list RBRACE
    {
        sprintf(code_buffer, "JUMP L_LOOP_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    | HODL_UNTIL NUMBER LBRACE
    {
        emit("# Trading loop: hodl_until");
        sprintf(code_buffer, "L_LOOP_%d", loop_counter);
        emit_label(code_buffer);
        emit("MARKET_LOAD");
        sprintf(code_buffer, "LT R0 %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "JUMPZ L_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    statement_list RBRACE
    {
        sprintf(code_buffer, "JUMP L_LOOP_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    | SCALP_FOR NUMBER LBRACE
    {
        emit("# Trading loop: scalp_for");
        sprintf(code_buffer, "LOAD R0, %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "L_LOOP_%d", loop_counter);
        emit_label(code_buffer);
        sprintf(code_buffer, "JUMPZ L_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    statement_list RBRACE
    {
        emit("SUB R0, 1");
        sprintf(code_buffer, "JUMP L_LOOP_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    ;

/* ========== MARKET LOOP ========== */
market_loop_stmt:
    MARKET_FOR NUMBER LBRACE
    {
        emit("# Market loop");
        sprintf(code_buffer, "LOAD R0, %d", $2);
        emit(code_buffer);
        sprintf(code_buffer, "L_LOOP_%d", loop_counter);
        emit_label(code_buffer);
        sprintf(code_buffer, "JUMPZ L_END_%d", loop_counter);
        emit(code_buffer);
        loop_counter++;
    }
    statement_list RBRACE
    {
        emit("SUB R0, 1");
        sprintf(code_buffer, "JUMP L_LOOP_%d", loop_counter - 1);
        emit(code_buffer);
        sprintf(code_buffer, "L_END_%d", loop_counter - 1);
        emit_label(code_buffer);
    }
    ;

/* ========== STRATEGY DECLARATION ========== */
strategy_dec:
    STRATEGY IDENTIFIER LPAREN RPAREN LBRACE statement_list RBRACE
    {
        emit("# Strategy declaration (ignored in this implementation)");
        free($2);
    }
    | STRATEGY IDENTIFIER LPAREN params RPAREN LBRACE statement_list RBRACE
    {
        emit("# Strategy declaration (ignored in this implementation)");
        free($2);
    }
    ;

params:
    IDENTIFIER
    {
        free($1);
    }
    | params COMMA IDENTIFIER
    {
        free($3);
    }
    ;

/* ========== STRATEGY CALL ========== */
strategy_call:
    CALL IDENTIFIER LPAREN RPAREN
    {
        emit("# Strategy call (ignored in this implementation)");
        free($2);
    }
    | CALL IDENTIFIER LPAREN args RPAREN
    {
        emit("# Strategy call (ignored in this implementation)");
        free($2);
    }
    ;

args:
    arg
    | args COMMA arg
    ;

arg:
    IDENTIFIER
    {
        free($1);
    }
    | NUMBER
    {
        // Número
    }
    ;

/* ========== BATTLE ========== */
battle_stmt:
    BATTLE IDENTIFIER VS IDENTIFIER
    {
        sprintf(code_buffer, "BATTLE %s %s", $2, $4);
        emit(code_buffer);
        free($2);
        free($4);
    }
    ;

%%

/* ========== FUNÇÕES AUXILIARES ========== */

void emit(const char *code) {
    if (output_file) {
        fprintf(output_file, "%s\n", code);
    }
}

void emit_label(const char *label) {
    if (output_file) {
        fprintf(output_file, "LABEL %s\n", label);
    }
}

/* ========== TRATAMENTO DE ERROS ========== */
void yyerror(const char *s) {
    fprintf(stderr, "\n❌ ERRO SINTÁTICO na linha %d: %s\n", yylineno, s);
    fprintf(stderr, "   Verifique a sintaxe do seu programa SatoLang.\n");
    parse_error = 1;
}

/* ========== FUNÇÃO PRINCIPAL ========== */
int main(int argc, char **argv) {
    printf("\n╔════════════════════════════════════════════════════════╗\n");
    printf("║       SatoLang - Compilador para Bitcoin VM          ║\n");
    printf("║        Linguagens e Paradigmas - APS Etapa 3         ║\n");
    printf("╚════════════════════════════════════════════════════════╝\n\n");

    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo.btc> [saida.asm]\n", argv[0]);
        return 1;
    }

    /* Abre arquivo de entrada */
    FILE *input = fopen(argv[1], "r");
    if (!input) {
        fprintf(stderr, "❌ Erro: não foi possível abrir '%s'\n", argv[1]);
        return 1;
    }
    yyin = input;

    /* Define arquivo de saída */
    char output_filename[256];
    if (argc >= 3) {
        strcpy(output_filename, argv[2]);
    } else {
        // Remove extensão .btc e adiciona .asm
        strcpy(output_filename, argv[1]);
        char *dot = strrchr(output_filename, '.');
        if (dot) *dot = '\0';
        strcat(output_filename, ".asm");
    }

    output_file = fopen(output_filename, "w");
    if (!output_file) {
        fprintf(stderr, "❌ Erro: não foi possível criar '%s'\n", output_filename);
        fclose(input);
        return 1;
    }

    printf("📄 Compilando: %s\n", argv[1]);
    printf("📝 Gerando: %s\n\n", output_filename);

    /* Cabeçalho do arquivo Assembly */
    fprintf(output_file, "# Assembly gerado pelo compilador SatoLang\n");
    fprintf(output_file, "# Arquivo fonte: %s\n\n", argv[1]);

    /* Executa o parser/compilador */
    int result = yyparse();

    fclose(input);
    fclose(output_file);

    if (result == 0 && !parse_error) {
        printf("\n╔════════════════════════════════════════════════════════╗\n");
        printf("║           ✅ COMPILAÇÃO CONCLUÍDA COM SUCESSO!        ║\n");
        printf("╚════════════════════════════════════════════════════════╝\n");
        printf("\n💡 Execute: ./btc_vm %s\n\n", output_filename);
        return 0;
    } else {
        printf("\n╔════════════════════════════════════════════════════════╗\n");
        printf("║           ❌ COMPILAÇÃO FALHOU - ERROS ENCONTRADOS    ║\n");
        printf("╚════════════════════════════════════════════════════════╝\n");
        remove(output_filename); // Remove arquivo de saída em caso de erro
        return 1;
    }
}
