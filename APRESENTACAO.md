# 🎓 SatoLang - Apresentação do Projeto

## 📌 Informações Gerais

**Disciplina:** Linguagens e Paradigmas  
**Instituição:** Insper  
**Semestre:** 2025.2 (4º semestre)  
**Etapa:** 2 - Análise Léxica e Sintática  
**Data de Entrega:** 16/Out/2025  

---

## 🎯 Objetivo do Projeto

Desenvolver um **compilador completo** para a linguagem **SatoLang**, uma DSL (Domain-Specific Language) voltada à simulação de operações de trade e mineração de Bitcoin.

**Etapa atual:** Implementação da análise léxica e sintática usando **Flex** e **Bison**.

---

## 🪙 Sobre a SatoLang

A SatoLang é uma linguagem de programação criada especificamente para:
- 💼 Gerenciar carteiras (wallets)
- ⛏️ Simular mineração de Bitcoin
- 💸 Realizar transações entre wallets
- 📊 Monitorar e atualizar o mercado
- 🎯 Criar estratégias de trading
- ⚔️ Realizar batalhas entre traders

### Exemplo de Código

```btc
// Inicialização da blockchain
genesis satoshi supply 21000000 reward 50 start_price 1000

// Criação de wallets
wallet lucas
wallet carlos

// Mineração
lucas mine
carlos mine

// Transação
lucas -> carlos : 100

// Estratégia de trading
strategy pump_and_dump(trader, price) {
    buy_the_dip 5 {
        lucas -> carlos : 10
    }
    take_profit_until 70000 {
        carlos -> lucas : 5
    }
}

// Chamada da estratégia
call pump_and_dump(lucas, 75000)

// Batalha
battle lucas vs carlos
```

---

## 🏗️ Arquitetura do Compilador

```
┌─────────────────────────────────────────────────────────┐
│                   ARQUITETURA GERAL                     │
└─────────────────────────────────────────────────────────┘

    Código Fonte (.btc)
           │
           ▼
    ┌──────────────┐
    │   LEXER      │  ← lexer.l (Flex)
    │  (Análise    │
    │   Léxica)    │
    └──────────────┘
           │
           │ Stream de Tokens
           ▼
    ┌──────────────┐
    │   PARSER     │  ← parser.y (Bison)
    │  (Análise    │
    │  Sintática)  │
    └──────────────┘
           │
           ▼
    ✅ Validação Completa
```

---

## 📂 Estrutura de Arquivos

### Arquivos Principais (Código)
- `lexer.l` - Analisador léxico
- `parser.y` - Analisador sintático
- `Makefile` - Automação da compilação

### Arquivos de Teste
- `exemplo.btc` - Exemplo completo
- `exemplo_simples.btc` - Exemplo minimalista
- `exemplo_erro.btc` - Teste de erros

### Documentação
- `README.md` - Guia de uso
- `DOCUMENTACAO.md` - Documentação técnica
- `ESTRUTURA.md` - Estrutura do projeto
- `VALIDACAO.md` - Validação e testes
- `APRESENTACAO.md`
- `ebnf.txt` - Gramática formal

---

## 🔑 Funcionalidades Implementadas

### ✅ Análise Léxica
- [x] Reconhecimento de 40+ tokens
- [x] 27 palavras-chave
- [x] 8 operadores relacionais
- [x] Identificadores e números
- [x] Comentários de linha (`//`)
- [x] Tratamento de erros léxicos
- [x] Contagem de linhas para debugging

### ✅ Análise Sintática
- [x] Validação de estrutura do programa
- [x] Bloco `genesis` obrigatório
- [x] Declaração de wallets
- [x] Operações de mineração
- [x] Transações entre wallets
- [x] Operações de mercado
- [x] Condicionais (`if`, `if-else`)
- [x] Loops (`for`, `while`)
- [x] Trading loops especializados
- [x] Declaração de estratégias
- [x] Chamada de estratégias
- [x] Batalhas entre wallets
- [x] Estruturas aninhadas
- [x] Tratamento de erros sintáticos

---

## Características Únicas da Linguagem

### 1. Trading Loops
Loops especializados para operações de trading:

```btc
buy_the_dip 10 { ... }          // Compra na queda
take_profit_until 60000 { ... } // Take profit
hodl_until 100000 { ... }       // HODL até preço alvo
scalp_for 20 { ... }            // Scalping rápido
market_for 15 { ... }           // Loop de mercado
```

### 2. Estratégias Customizadas
Declaração e chamada de estratégias de trading:

```btc
strategy my_strategy(param1, param2) {
    // código da estratégia
}

call my_strategy(lucas, 50000)
```

### 3. Batalhas
Sistema de batalhas entre traders:

```btc
battle lucas vs carlos
```

### 4. Sintaxe Intuitiva
Operações expressivas e fáceis de entender:

```btc
lucas -> carlos : 100  // Transferência
lucas mine          // Mineração
market update       // Atualização de mercado
showchain           // Visualizar blockchain
```

---

## Validação e Testes

### Teste 1: Programa Completo 
```bash
./btc_parser exemplo.btc
```
**Resultado:** Parsing concluído com sucesso  
**Testa:** Todas as funcionalidades (180 linhas)

### Teste 2: Programa Simples ✅
```bash
./btc_parser exemplo_simples.btc
```
**Resultado:** Parsing concluído com sucesso  
**Testa:** Funcionalidades básicas (15 linhas)

### Teste 3: Tratamento de Erros ✅
```bash
./btc_parser exemplo_erro.btc
```
**Resultado:** Erro sintático detectado (esperado)  
**Testa:** Validação de erros

### Cobertura
- ✅ 100% das regras da EBNF implementadas
- ✅ 100% dos tokens reconhecidos
- ✅ 100% das funcionalidades testadas

---

## Como Executar

### 1. Compilar o projeto
```bash
make
```

### 2. Testar com exemplo
```bash
make test
```

### 3. Executar com arquivo próprio
```bash
./btc_parser meu_programa.btc
```

### 4. Modo interativo
```bash
make run
```

### 5. Limpar arquivos gerados
```bash
make clean
```

---

## Conformidade com a EBNF

Todas as 23 regras da EBNF foram implementadas:

| Categoria | Regras | Status |
|-----------|--------|--------|
| Estrutura | PROGRAM, GENESIS | ✅ |
| Operações | WALLET, MINING, TRANSACTION, MARKET, BLOCKCHAIN | ✅ |
| Controle | IFSTMT, LOOP, WHILE_LOOP, FOR_LOOP | ✅ |
| Trading | TRADING_LOOP, MARKET_LOOP | ✅ |
| Estratégias | STRATEGYDEC, STRATEGYCALL, PARAMS, ARGS | ✅ |
| Condições | CONDITION, REL_OP | ✅ |
| Batalhas | BATTLE | ✅ |
| Literais | IDENTIFIER, NUMBER | ✅ |

---

## Destaques Técnicos

### 1. Gerenciamento de Memória
```c
// Alocação e liberação adequada de strings
yylval.str = strdup(yytext);
free($2);
```

### 2. Tratamento de Erros
```c
void yyerror(const char *s) {
    fprintf(stderr, "❌ ERRO SINTÁTICO na linha %d: %s\n", 
            yylineno, s);
}
```

### 3. Ações Semânticas
```c
wallet_stmt:
    WALLET IDENTIFIER
    {
        printf("💼 WALLET criada: %s\n", $2);
        free($2);
    }
    ;
```

### 4. Estruturas Recursivas
```c
params:
    IDENTIFIER
    | params COMMA IDENTIFIER
    ;
```

---

## 🔍 Exemplo de Execução

### Entrada
```btc
genesis satoshi supply 21000000 reward 50 start_price 1000
wallet lucas
lucas mine
lucas -> carlos : 100
```

### Saída
```
╔════════════════════════════════════════════════════════╗
║   SatoLang - Analisador Léxico e Sintático   ║
╚════════════════════════════════════════════════════════╝

🔷 GENESIS: supply=21000000, reward=50, start_price=1000
💼 WALLET criada: lucas
⛏️  MINING: lucas está minerando
💸 TRANSAÇÃO: lucas -> carlos : 100 BTC

✅ Análise sintática concluída com SUCESSO!

╔════════════════════════════════════════════════════════╗
║              ✅ PARSING CONCLUÍDO COM SUCESSO!         ║
╚════════════════════════════════════════════════════════╝
```



