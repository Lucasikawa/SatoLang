%{
/*
 * SatoLang - Analisador Sintático
 * Linguagens e Paradigmas - APS Etapa 2
 * 
 * Este arquivo implementa as regras sintáticas da linguagem conforme a EBNF.
 * Valida a estrutura dos programas SatoLang.
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

/* Flag para indicar se houve erro */
int parse_error = 0;
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

/* Símbolo inicial */
%start program

%%

/* ========== PROGRAMA PRINCIPAL ========== */
/* PROGRAM = GENESIS, { STATEMENT } ; */
program:
    genesis statement_list
    {
        if (!parse_error) {
            printf("\n✅ Análise sintática concluída com SUCESSO!\n");
            printf("   Programa SatoLang válido.\n");
        }
    }
    ;

/* ========== BLOCO GENESIS ========== */
/* GENESIS = "genesis", "satoshi", "supply", NUMBER, "reward", NUMBER, "start_price", NUMBER ; */
genesis:
    GENESIS SATOSHI SUPPLY NUMBER REWARD NUMBER START_PRICE NUMBER
    {
        printf("🔷 GENESIS: supply=%d, reward=%d, start_price=%d\n", $4, $6, $8);
    }
    ;

/* ========== LISTA DE STATEMENTS (zero ou mais) ========== */
statement_list:
    /* vazio - permite zero statements */
    | statement_list statement
    ;

/* ========== STATEMENT ========== */
/* STATEMENT = WALLET | TRANSACTION | MINING | MARKET | BLOCKCHAIN | IFSTMT | LOOP | 
               TRADING_LOOP | MARKET_LOOP | STRATEGYDEC | STRATEGYCALL | BATTLE ; */
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
/* WALLET = "wallet", IDENTIFIER ; */
wallet_stmt:
    WALLET IDENTIFIER
    {
        printf("💼 WALLET criada: %s\n", $2);
        free($2);
    }
    ;

/* ========== MINING ========== */
/* MINING = IDENTIFIER, "mine" ; */
mining_stmt:
    IDENTIFIER MINE
    {
        printf("⛏️  MINING: %s está minerando\n", $1);
        free($1);
    }
    ;

/* ========== TRANSACTION ========== */
/* TRANSACTION = IDENTIFIER, "->", IDENTIFIER, ":", NUMBER ; */
transaction_stmt:
    IDENTIFIER ARROW IDENTIFIER COLON NUMBER
    {
        printf("💸 TRANSAÇÃO: %s -> %s : %d BTC\n", $1, $3, $5);
        free($1);
        free($3);
    }
    ;

/* ========== MARKET ========== */
/* MARKET = "market" | "market", "update" ; */
market_stmt:
    MARKET
    {
        printf("📊 MARKET: visualizando mercado\n");
    }
    | MARKET UPDATE
    {
        printf("📊 MARKET: atualizando preços\n");
    }
    ;

/* ========== BLOCKCHAIN ========== */
/* BLOCKCHAIN = "showchain" ; */
blockchain_stmt:
    SHOWCHAIN
    {
        printf("⛓️  BLOCKCHAIN: exibindo cadeia de blocos\n");
    }
    ;

/* ========== IF STATEMENT ========== */
/* IFSTMT = "if", CONDITION, "{", { STATEMENT }, "}", [ "else", "{", { STATEMENT }, "}" ] ; */
if_stmt:
    IF condition LBRACE statement_list RBRACE
    {
        printf("🔀 IF: condicional simples\n");
    }
    | IF condition LBRACE statement_list RBRACE ELSE LBRACE statement_list RBRACE
    {
        printf("🔀 IF-ELSE: condicional com alternativa\n");
    }
    ;

/* ========== CONDITION ========== */
/* CONDITION = "saldo", IDENTIFIER, REL_OP, NUMBER | "market", REL_OP, NUMBER ; */
condition:
    SALDO IDENTIFIER rel_op NUMBER
    {
        printf("   └─ Condição: saldo(%s) %s %d\n", $2, "comparado", $4);
        free($2);
    }
    | MARKET rel_op NUMBER
    {
        printf("   └─ Condição: market %s %d\n", "comparado", $3);
    }
    ;

/* ========== OPERADORES RELACIONAIS ========== */
/* REL_OP = ">" | "<" | "==" | "!=" | ">=" | "<=" ; */
rel_op:
    GT      { printf("   └─ Operador: >\n"); }
    | LT    { printf("   └─ Operador: <\n"); }
    | EQ    { printf("   └─ Operador: ==\n"); }
    | NEQ   { printf("   └─ Operador: !=\n"); }
    | GTE   { printf("   └─ Operador: >=\n"); }
    | LTE   { printf("   └─ Operador: <=\n"); }
    ;

/* ========== LOOPS ========== */
/* LOOP = WHILE_LOOP | FOR_LOOP ; */
loop_stmt:
    while_loop
    | for_loop
    ;

/* WHILE_LOOP = "while", CONDITION, "{", { STATEMENT }, "}" ; */
while_loop:
    WHILE condition LBRACE statement_list RBRACE
    {
        printf("🔁 WHILE: loop condicional\n");
    }
    ;

/* FOR_LOOP = "for", NUMBER, "{", { STATEMENT }, "}" ; */
for_loop:
    FOR NUMBER LBRACE statement_list RBRACE
    {
        printf("🔁 FOR: loop de %d iterações\n", $2);
    }
    ;

/* ========== TRADING LOOPS ========== */
/* TRADING_LOOP = "buy_the_dip", NUMBER, "{", { STATEMENT }, "}"
               | "take_profit_until", NUMBER, "{", { STATEMENT }, "}"
               | "hodl_until", NUMBER, "{", { STATEMENT }, "}"
               | "scalp_for", NUMBER, "{", { STATEMENT }, "}" ; */
trading_loop_stmt:
    BUY_THE_DIP NUMBER LBRACE statement_list RBRACE
    {
        printf("📉 TRADING LOOP: buy_the_dip por %d unidades\n", $2);
    }
    | TAKE_PROFIT_UNTIL NUMBER LBRACE statement_list RBRACE
    {
        printf("📈 TRADING LOOP: take_profit_until %d\n", $2);
    }
    | HODL_UNTIL NUMBER LBRACE statement_list RBRACE
    {
        printf("💎 TRADING LOOP: hodl_until %d\n", $2);
    }
    | SCALP_FOR NUMBER LBRACE statement_list RBRACE
    {
        printf("⚡ TRADING LOOP: scalp_for %d\n", $2);
    }
    ;

/* ========== MARKET LOOP ========== */
/* MARKET_LOOP = "market_for", NUMBER, "{", { STATEMENT }, "}" ; */
market_loop_stmt:
    MARKET_FOR NUMBER LBRACE statement_list RBRACE
    {
        printf("📊 MARKET LOOP: market_for %d ciclos\n", $2);
    }
    ;

/* ========== STRATEGY DECLARATION ========== */
/* STRATEGYDEC = "strategy", IDENTIFIER, "(", [ PARAMS ], ")", "{", { STATEMENT }, "}" ; */
strategy_dec:
    STRATEGY IDENTIFIER LPAREN RPAREN LBRACE statement_list RBRACE
    {
        printf("🎯 STRATEGY: declarando estratégia '%s' (sem parâmetros)\n", $2);
        free($2);
    }
    | STRATEGY IDENTIFIER LPAREN params RPAREN LBRACE statement_list RBRACE
    {
        printf("🎯 STRATEGY: declarando estratégia '%s' (com parâmetros)\n", $2);
        free($2);
    }
    ;

/* ========== PARAMS ========== */
/* PARAMS = IDENTIFIER, { ",", IDENTIFIER } ; */
params:
    IDENTIFIER
    {
        printf("   └─ Parâmetro: %s\n", $1);
        free($1);
    }
    | params COMMA IDENTIFIER
    {
        printf("   └─ Parâmetro: %s\n", $3);
        free($3);
    }
    ;

/* ========== STRATEGY CALL ========== */
/* STRATEGYCALL = "call", IDENTIFIER, "(", [ ARGS ], ")" ; */
strategy_call:
    CALL IDENTIFIER LPAREN RPAREN
    {
        printf("📞 CALL: chamando estratégia '%s' (sem argumentos)\n", $2);
        free($2);
    }
    | CALL IDENTIFIER LPAREN args RPAREN
    {
        printf("📞 CALL: chamando estratégia '%s' (com argumentos)\n", $2);
        free($2);
    }
    ;

/* ========== ARGS ========== */
/* ARGS = (IDENTIFIER | NUMBER), { ",", (IDENTIFIER | NUMBER) } ; */
args:
    arg
    | args COMMA arg
    ;

arg:
    IDENTIFIER
    {
        printf("   └─ Argumento: %s\n", $1);
        free($1);
    }
    | NUMBER
    {
        printf("   └─ Argumento: %d\n", $1);
    }
    ;

/* ========== BATTLE ========== */
/* BATTLE = "battle", IDENTIFIER, "vs", IDENTIFIER ; */
battle_stmt:
    BATTLE IDENTIFIER VS IDENTIFIER
    {
        printf("⚔️  BATTLE: %s vs %s\n", $2, $4);
        free($2);
        free($4);
    }
    ;

%%

/* ========== TRATAMENTO DE ERROS ========== */
void yyerror(const char *s) {
    fprintf(stderr, "\n❌ ERRO SINTÁTICO na linha %d: %s\n", yylineno, s);
    fprintf(stderr, "   Verifique a sintaxe do seu programa SatoLang.\n");
    parse_error = 1;
}

/* ========== FUNÇÃO PRINCIPAL ========== */
int main(int argc, char **argv) {
    printf("\n╔════════════════════════════════════════════════════════╗\n");
    printf("║   SatoLang - Analisador Léxico e Sintático   ║\n");
    printf("║   Linguagens e Paradigmas - APS Etapa 2              ║\n");
    printf("╚════════════════════════════════════════════════════════╝\n\n");

    /* Se houver arquivo como argumento, usa ele; senão, usa stdin */
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "❌ Erro: não foi possível abrir o arquivo '%s'\n", argv[1]);
            return 1;
        }
        yyin = file;
        printf("📄 Analisando arquivo: %s\n\n", argv[1]);
    } else {
        printf("📄 Lendo da entrada padrão (stdin)...\n\n");
        yyin = stdin;
    }

    /* Executa o parser */
    int result = yyparse();

    if (argc > 1) {
        fclose(yyin);
    }

    if (result == 0 && !parse_error) {
        printf("\n╔════════════════════════════════════════════════════════╗\n");
        printf("║              ✅ PARSING CONCLUÍDO COM SUCESSO!         ║\n");
        printf("╚════════════════════════════════════════════════════════╝\n");
        return 0;
    } else {
        printf("\n╔════════════════════════════════════════════════════════╗\n");
        printf("║              ❌ PARSING FALHOU - ERROS ENCONTRADOS     ║\n");
        printf("╚════════════════════════════════════════════════════════╝\n");
        return 1;
    }
}

