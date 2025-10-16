# 🪙 SatoLang

**SatoLang** é uma DSL (Domain-Specific Language) voltada à simulação de operações de trade e mineração de Bitcoin. Este projeto implementa a análise léxica e sintática da linguagem usando **Flex** e **Bison**.

---

## 📚 Sobre o Projeto

Este é um projeto acadêmico da disciplina **Linguagens e Paradigmas** (Insper - 2025.2), desenvolvido como parte da APS (Atividade Prática Supervisionada).

**Etapa atual:** Análise Léxica e Sintática (Etapa 2)  
**Data de entrega:** 16/Out/2025

---

## 🎯 Funcionalidades Implementadas

### ✅ Análise Léxica (Flex)
- Reconhecimento de todos os tokens da linguagem
- Palavras-chave: `genesis`, `wallet`, `mine`, `market`, `strategy`, `battle`, etc.
- Operadores relacionais: `>`, `<`, `==`, `!=`, `>=`, `<=`
- Identificadores e números
- Comentários de linha (`//`)
- Tratamento de erros léxicos

### ✅ Análise Sintática (Bison)
- Validação da estrutura sintática completa
- Bloco `genesis` obrigatório
- Declaração de wallets e transações
- Estruturas de controle: `if-else`, `while`, `for`
- Trading loops: `buy_the_dip`, `take_profit_until`, `hodl_until`, `scalp_for`
- Declaração e chamada de estratégias
- Batalhas entre wallets
- Tratamento de erros sintáticos com mensagens claras

---

## 🛠️ Pré-requisitos

Para compilar e executar o projeto, você precisa ter instalado:

- **GCC** (GNU Compiler Collection)
- **Flex** (Fast Lexical Analyzer Generator)
- **Bison** (GNU Parser Generator)
- **Make** (ferramenta de automação)

### Instalação no macOS
```bash
brew install flex bison gcc make
```

### Instalação no Ubuntu/Debian
```bash
sudo apt-get install flex bison gcc make
```

### Instalação no Fedora/RHEL
```bash
sudo dnf install flex bison gcc make
```

---

## 🚀 Como Compilar

### Compilação simples
```bash
make
```

### Compilação e teste automático
```bash
make test
```

### Recompilar do zero
```bash
make rebuild
```

---

## 📖 Como Usar

### 1. Analisar um arquivo
```bash
./btc_parser exemplo.btc
```

### 2. Usar redirecionamento
```bash
./btc_parser < exemplo.btc
```

### 3. Entrada interativa (stdin)
```bash
./btc_parser
# Digite o código e pressione Ctrl+D (Unix) ou Ctrl+Z (Windows) para finalizar
```

---

## 📝 Sintaxe da Linguagem

### Estrutura Básica
Todo programa SatoLang deve começar com um bloco `genesis`:

```btc
genesis satoshi supply 21000000 reward 50 start_price 1000
```

### Wallets
```btc
wallet alice
wallet bob
```

### Mineração
```btc
alice mine
```

### Transações
```btc
alice -> bob : 100
```

### Mercado
```btc
market          // Visualiza o mercado
market update   // Atualiza preços
```

### Blockchain
```btc
showchain       // Exibe a cadeia de blocos
```

### Condicionais
```btc
if saldo alice > 500 {
    alice -> bob : 100
}

if market >= 50000 {
    alice mine
} else {
    bob mine
}
```

### Loops Tradicionais
```btc
// Loop for (número fixo de iterações)
for 10 {
    alice mine
}

// Loop while (condicional)
while saldo alice < 1000 {
    alice mine
}
```

### Trading Loops
```btc
// Compra na queda
buy_the_dip 5 {
    alice -> bob : 10
}

// Take profit
take_profit_until 60000 {
    bob -> alice : 5
}

// HODL
hodl_until 100000 {
    market update
}

// Scalping
scalp_for 20 {
    alice -> bob : 1
}

// Loop de mercado
market_for 15 {
    market update
}
```

### Estratégias
```btc
// Declaração
strategy pump_and_dump(trader, price) {
    buy_the_dip 5 {
        alice -> bob : 10
    }
    take_profit_until 70000 {
        bob -> alice : 5
    }
}

// Chamada
call pump_and_dump(alice, 75000)
```

### Batalhas
```btc
battle alice vs bob
```

### Comentários
```btc
// Isto é um comentário de linha
```

---

## 📂 Estrutura do Projeto

```
SatoLang/
├── lexer.l          # Analisador léxico (Flex)
├── parser.y         # Analisador sintático (Bison)
├── Makefile         # Automação da compilação
├── exemplo.btc      # Arquivo de exemplo completo
├── ebnf.txt         # Gramática EBNF da linguagem
└── README.md        # Este arquivo
```

---

## 🧪 Testando o Parser

O arquivo `exemplo.btc` contém um programa completo que testa todas as funcionalidades da linguagem:

```bash
make test
```

Saída esperada:
```
✅ Análise sintática concluída com SUCESSO!
   Programa SatoLang válido.
```

---

## 🔧 Comandos do Makefile

| Comando | Descrição |
|---------|-----------|
| `make` | Compila o parser |
| `make test` | Compila e testa com `exemplo.btc` |
| `make run` | Compila e executa (lê da stdin) |
| `make clean` | Remove arquivos gerados |
| `make rebuild` | Limpa e recompila tudo |
| `make help` | Exibe ajuda |

---

## 🐛 Tratamento de Erros

### Erros Léxicos
Caracteres inválidos são detectados e reportados:
```
Erro léxico na linha 5: caractere inválido '@'
```

### Erros Sintáticos
Estruturas inválidas são detectadas com mensagens claras:
```
❌ ERRO SINTÁTICO na linha 10: syntax error
   Verifique a sintaxe do seu programa SatoLang.
```

---

## 📋 EBNF da Linguagem

A gramática completa está disponível no arquivo `ebnf.txt`. Principais construções:

```ebnf
PROGRAM = GENESIS, { STATEMENT } ;

GENESIS = "genesis", "satoshi",
          "supply", NUMBER,
          "reward", NUMBER,
          "start_price", NUMBER ;

STATEMENT = WALLET | TRANSACTION | MINING | MARKET | BLOCKCHAIN
          | IFSTMT | LOOP | TRADING_LOOP | MARKET_LOOP
          | STRATEGYDEC | STRATEGYCALL | BATTLE ;
```

---

## 🎓 Informações Acadêmicas

**Disciplina:** Linguagens e Paradigmas  
**Instituição:** Insper  
**Semestre:** 2025.2  
**Etapa:** 2 - Análise Léxica e Sintática  
**Ferramentas:** Flex, Bison, C, Make

---

## 📝 Próximas Etapas

- [ ] **Etapa 3:** Análise Semântica
- [ ] **Etapa 4:** Geração de Código Intermediário
- [ ] **Etapa 5:** Implementação da VM
- [ ] **Etapa 6:** Otimizações

---

## 🤝 Contribuições

Este é um projeto acadêmico individual. Sugestões e feedback são bem-vindos!

---

## 📄 Licença

Este projeto é desenvolvido para fins educacionais.

---

## 🔗 Links Úteis

- [Documentação do Flex](https://github.com/westes/flex)
- [Documentação do Bison](https://www.gnu.org/software/bison/)
- [EBNF - Extended Backus-Naur Form](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form)
