%{
/*
 * SatoLang - Analisador Léxico
 * Linguagens e Paradigmas - APS Etapa 2
 * 
 * Este arquivo define todos os tokens da linguagem conforme a EBNF.
 * Reconhece palavras-chave, identificadores, números, operadores e delimitadores.
 */

#include "parser.tab.h"
#include <stdio.h>
#include <string.h>

/* Flex já define yylineno automaticamente */
extern int yylineno;
%}

/* Definições de padrões reutilizáveis */
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+
WHITESPACE  [ \t\r]+

%%

    /* ========== PALAVRAS-CHAVE DO BLOCO GENESIS ========== */
"genesis"       { return GENESIS; }
"satoshi"       { return SATOSHI; }
"supply"        { return SUPPLY; }
"reward"        { return REWARD; }
"start_price"   { return START_PRICE; }

    /* ========== PALAVRAS-CHAVE DE OPERAÇÕES ========== */
"wallet"        { return WALLET; }
"mine"          { return MINE; }
"market"        { return MARKET; }
"update"        { return UPDATE; }
"showchain"     { return SHOWCHAIN; }

    /* ========== PALAVRAS-CHAVE DE CONTROLE DE FLUXO ========== */
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"for"           { return FOR; }

    /* ========== PALAVRAS-CHAVE DE TRADING LOOPS ========== */
"buy_the_dip"       { return BUY_THE_DIP; }
"take_profit_until" { return TAKE_PROFIT_UNTIL; }
"hodl_until"        { return HODL_UNTIL; }
"scalp_for"         { return SCALP_FOR; }
"market_for"        { return MARKET_FOR; }

    /* ========== PALAVRAS-CHAVE DE ESTRATÉGIAS ========== */
"strategy"      { return STRATEGY; }
"call"          { return CALL; }
"battle"        { return BATTLE; }
"vs"            { return VS; }

    /* ========== PALAVRAS-CHAVE DE CONDIÇÕES ========== */
"saldo"         { return SALDO; }

    /* ========== OPERADORES RELACIONAIS ========== */
"=="            { return EQ; }
"!="            { return NEQ; }
">="            { return GTE; }
"<="            { return LTE; }
">"             { return GT; }
"<"             { return LT; }

    /* ========== OPERADORES E DELIMITADORES ========== */
"->"            { return ARROW; }
":"             { return COLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
","             { return COMMA; }

    /* ========== IDENTIFICADORES E NÚMEROS ========== */
{IDENTIFIER}    { 
                    yylval.str = strdup(yytext); 
                    return IDENTIFIER; 
                }
{NUMBER}        { 
                    yylval.num = atoi(yytext); 
                    return NUMBER; 
                }

    /* ========== COMENTÁRIOS (ignorados) ========== */
"//".*          { /* Ignora comentários de linha */ }

    /* ========== ESPAÇOS EM BRANCO (ignorados) ========== */
{WHITESPACE}    { /* Ignora espaços, tabs */ }
\n              { yylineno++; /* Conta linhas */ }

    /* ========== CARACTERES INVÁLIDOS ========== */
.               { 
                    fprintf(stderr, "Erro léxico na linha %d: caractere inválido '%s'\n", 
                            yylineno, yytext);
                    return INVALID_CHAR;
                }

%%

/* Função chamada quando o arquivo termina */
int yywrap(void) {
    return 1;
}

