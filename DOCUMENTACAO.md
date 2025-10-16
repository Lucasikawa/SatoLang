# 📚 Documentação Técnica - SatoLang

## Estrutura do Compilador

Este documento detalha a implementação técnica do analisador léxico e sintático da SatoLang.

---

## 📁 Arquivos do Projeto

### 1. `lexer.l` - Analisador Léxico (Flex)

**Função:** Reconhecer tokens da linguagem e convertê-los em símbolos para o parser.

#### Tokens Implementados

| Categoria | Tokens |
|-----------|--------|
| **Genesis** | `genesis`, `satoshi`, `supply`, `reward`, `start_price` |
| **Operações** | `wallet`, `mine`, `market`, `update`, `showchain` |
| **Controle de Fluxo** | `if`, `else`, `while`, `for` |
| **Trading Loops** | `buy_the_dip`, `take_profit_until`, `hodl_until`, `scalp_for`, `market_for` |
| **Estratégias** | `strategy`, `call`, `battle`, `vs` |
| **Condições** | `saldo` |
| **Operadores Relacionais** | `==`, `!=`, `>=`, `<=`, `>`, `<` |
| **Delimitadores** | `->`, `:`, `(`, `)`, `{`, `}`, `,` |
| **Literais** | `IDENTIFIER`, `NUMBER` |

#### Características Especiais

- **Comentários:** Suporta comentários de linha com `//`
- **Espaços em branco:** Ignorados automaticamente
- **Contagem de linhas:** Mantém `yylineno` para mensagens de erro precisas
- **Tratamento de erros:** Detecta caracteres inválidos

#### Exemplo de Expressões Regulares

```c
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT}|_)*
NUMBER      {DIGIT}+
```

---

### 2. `parser.y` - Analisador Sintático (Bison)

**Função:** Validar a estrutura sintática dos programas conforme a EBNF.

#### Estrutura da Gramática

##### Símbolo Inicial
```
program: genesis statement_list
```

##### Regras Principais

**GENESIS (obrigatório)**
```
genesis: GENESIS SATOSHI SUPPLY NUMBER REWARD NUMBER START_PRICE NUMBER
```

**STATEMENTS**
- `wallet_stmt`: Criação de carteiras
- `transaction_stmt`: Transferências entre wallets
- `mining_stmt`: Operações de mineração
- `market_stmt`: Consulta/atualização de mercado
- `blockchain_stmt`: Visualização da blockchain
- `if_stmt`: Condicionais (com ou sem else)
- `loop_stmt`: Loops while e for
- `trading_loop_stmt`: Loops específicos de trading
- `market_loop_stmt`: Loop de mercado
- `strategy_dec`: Declaração de estratégias
- `strategy_call`: Chamada de estratégias
- `battle_stmt`: Batalhas entre wallets

#### Tratamento de Repetições e Opcionais

A EBNF usa notações especiais que são traduzidas para regras Bison:

| EBNF | Bison |
|------|-------|
| `{ X }` (zero ou mais) | `list: ε \| list X` |
| `[ X ]` (opcional) | `opt: ε \| X` |
| `X \| Y` (alternativa) | `rule: X \| Y` |

#### Exemplo de Tradução EBNF → Bison

**EBNF:**
```ebnf
PARAMS = IDENTIFIER, { ",", IDENTIFIER } ;
```

**Bison:**
```yacc
params:
    IDENTIFIER
    | params COMMA IDENTIFIER
    ;
```

#### Ações Semânticas

Cada regra sintática executa uma ação (por enquanto, apenas `printf`):

```c
wallet_stmt:
    WALLET IDENTIFIER
    {
        printf("💼 WALLET criada: %s\n", $2);
        free($2);
    }
    ;
```

---

### 3. `Makefile` - Automação da Compilação

**Função:** Automatizar o processo de compilação e teste.

#### Fluxo de Compilação

```
lexer.l  ──[flex]──>  lex.yy.c  ─┐
                                  ├──[gcc]──> btc_parser
parser.y ──[bison]──> parser.tab.c ┘
                      parser.tab.h
```

#### Comandos Disponíveis

| Comando | Ação |
|---------|------|
| `make` | Compila o parser |
| `make test` | Compila e testa com `exemplo.btc` |
| `make run` | Executa interativamente |
| `make clean` | Remove arquivos gerados |
| `make rebuild` | Limpa e recompila |
| `make help` | Exibe ajuda |

#### Arquivos Gerados

- `lex.yy.c`: Código C do lexer gerado pelo Flex
- `parser.tab.c`: Código C do parser gerado pelo Bison
- `parser.tab.h`: Header com definições de tokens
- `btc_parser`: Executável final

---

## 🔍 Análise Léxica Detalhada

### Processo de Tokenização

1. **Entrada:** Arquivo `.btc` ou stdin
2. **Scanning:** Flex lê caractere por caractere
3. **Matching:** Compara com expressões regulares
4. **Ação:** Retorna token correspondente
5. **Valor:** Armazena em `yylval` (se necessário)

### Exemplo de Tokenização

**Entrada:**
```btc
wallet lucas
lucas mine
```

**Tokens gerados:**
```
WALLET
IDENTIFIER("lucas")
IDENTIFIER("lucas")
MINE
```

---

## 🔍 Análise Sintática Detalhada

### Processo de Parsing

1. **Entrada:** Stream de tokens do lexer
2. **Parsing:** Bison aplica regras da gramática
3. **Validação:** Verifica estrutura sintática
4. **Ações:** Executa código associado às regras
5. **Resultado:** Sucesso ou erro sintático

### Exemplo de Parsing

**Entrada:**
```btc
genesis satoshi supply 21000000 reward 50 start_price 1000
```

**Árvore sintática (simplificada):**
```
program
└── genesis
    ├── GENESIS
    ├── SATOSHI
    ├── SUPPLY
    ├── NUMBER(21000000)
    ├── REWARD
    ├── NUMBER(50)
    ├── START_PRICE
    └── NUMBER(1000)
```

---

## 🎯 Conformidade com a EBNF

### Mapeamento Completo

Todas as regras da EBNF foram implementadas:

✅ **PROGRAM** = GENESIS, { STATEMENT }  
✅ **GENESIS** = "genesis", "satoshi", "supply", NUMBER, "reward", NUMBER, "start_price", NUMBER  
✅ **STATEMENT** = WALLET | TRANSACTION | MINING | MARKET | BLOCKCHAIN | IFSTMT | LOOP | TRADING_LOOP | MARKET_LOOP | STRATEGYDEC | STRATEGYCALL | BATTLE  
✅ **WALLET** = "wallet", IDENTIFIER  
✅ **MINING** = IDENTIFIER, "mine"  
✅ **TRANSACTION** = IDENTIFIER, "->", IDENTIFIER, ":", NUMBER  
✅ **MARKET** = "market" | "market", "update"  
✅ **BLOCKCHAIN** = "showchain"  
✅ **IFSTMT** = "if", CONDITION, "{", { STATEMENT }, "}", [ "else", "{", { STATEMENT }, "}" ]  
✅ **LOOP** = WHILE_LOOP | FOR_LOOP  
✅ **WHILE_LOOP** = "while", CONDITION, "{", { STATEMENT }, "}"  
✅ **FOR_LOOP** = "for", NUMBER, "{", { STATEMENT }, "}"  
✅ **TRADING_LOOP** = "buy_the_dip", NUMBER, "{", { STATEMENT }, "}" | ...  
✅ **MARKET_LOOP** = "market_for", NUMBER, "{", { STATEMENT }, "}"  
✅ **BATTLE** = "battle", IDENTIFIER, "vs", IDENTIFIER  
✅ **STRATEGYDEC** = "strategy", IDENTIFIER, "(", [ PARAMS ], ")", "{", { STATEMENT }, "}"  
✅ **PARAMS** = IDENTIFIER, { ",", IDENTIFIER }  
✅ **STRATEGYCALL** = "call", IDENTIFIER, "(", [ ARGS ], ")"  
✅ **ARGS** = (IDENTIFIER | NUMBER), { ",", (IDENTIFIER | NUMBER) }  
✅ **CONDITION** = "saldo", IDENTIFIER, REL_OP, NUMBER | "market", REL_OP, NUMBER  
✅ **REL_OP** = ">" | "<" | "==" | "!=" | ">=" | "<="  
✅ **IDENTIFIER** = LETTER, { LETTER | DIGIT | "_" }  
✅ **NUMBER** = DIGIT, { DIGIT }  

---

## 🐛 Tratamento de Erros

### Erros Léxicos

**Detectados por:** `lexer.l`  
**Exemplo:**
```
Erro léxico na linha 5: caractere inválido '@'
```

### Erros Sintáticos

**Detectados por:** `parser.y` (função `yyerror`)  
**Exemplo:**
```
❌ ERRO SINTÁTICO na linha 10: syntax error
   Verifique a sintaxe do seu programa SatoLang.
```

### Estratégias de Recuperação

- **Panic mode:** Descarta tokens até encontrar ponto de sincronização
- **Mensagens claras:** Indica linha do erro
- **Exit code:** Retorna 1 em caso de erro (útil para scripts)

---

## 🧪 Casos de Teste

### Teste 1: Programa Completo
**Arquivo:** `exemplo.btc`  
**Resultado esperado:** ✅ Sucesso  
**Testa:** Todas as funcionalidades da linguagem

### Teste 2: Programa Simples
**Arquivo:** `exemplo_simples.btc`  
**Resultado esperado:** ✅ Sucesso  
**Testa:** Funcionalidades básicas

### Teste 3: Programa com Erro
**Arquivo:** `exemplo_erro.btc`  
**Resultado esperado:** ❌ Erro sintático  
**Testa:** Tratamento de erros

---

## 🔧 Detalhes de Implementação

### Gerenciamento de Memória

- **Strings:** Alocadas com `strdup()`, liberadas com `free()`
- **Números:** Passados por valor (sem alocação)

### Union Type (yylval)

```c
%union {
    int num;      // Para NUMBER
    char *str;    // Para IDENTIFIER
}
```

### Precedência e Associatividade

Não foi necessário definir precedência, pois a gramática não tem ambiguidades.

---
