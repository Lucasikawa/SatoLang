# SatoLang Programming Language

**SatoLang** is a domain-specific programming language designed for blockchain simulation, cryptocurrency operations, and trading strategy development. The language provides high-level abstractions for blockchain concepts while maintaining a simple and expressive syntax.

Version: 1.0.0
License: Educational Use
Author: Lucas (Insper - 2025.2)

---

## Table of Contents

1. [Introduction](#introduction)
2. [Language Overview](#language-overview)
3. [Installation](#installation)
4. [Getting Started](#getting-started)
5. [Language Reference](#language-reference)
6. [Virtual Machine Specification](#virtual-machine-specification)
7. [Compiler Architecture](#compiler-architecture)
8. [Examples](#examples)
9. [Build System](#build-system)
10. [Documentation](#documentation)

---

## Introduction

SatoLang is a statically-scoped, imperative programming language with specialized constructs for blockchain and cryptocurrency operations. Named after Satoshi Nakamoto, the creator of Bitcoin, SatoLang aims to provide an accessible platform for learning blockchain concepts, testing trading strategies, and simulating cryptocurrency markets.

### Design Philosophy

- **Domain-Specific**: Native support for blockchain operations (mining, transactions, wallets)
- **Educational**: Clear syntax that maps directly to blockchain concepts
- **Expressive**: Trading-specific loops and constructs
- **Simple**: Minimal syntax with implicit typing
- **Practical**: Complete toolchain from source to execution

### Key Features

- Native blockchain simulation with genesis block, mining, and transactions
- Specialized trading loops (`buy_the_dip`, `hodl_until`, `take_profit_until`)
- Dynamic market simulation with price volatility
- Wallet management and balance tracking
- Battle system for comparing wallet balances
- Strategy definition and execution
- Complete virtual machine implementation

---

## Language Overview

### Paradigm

SatoLang follows an imperative programming paradigm with declarative elements for blockchain initialization. Programs execute sequentially with support for conditional branching and loops.

### Type System

SatoLang uses implicit typing with two primary data types:

- **Identifiers**: Wallet names and strategy identifiers
- **Numbers**: Integer values for amounts, prices, and counters (internally represented as `long long`)

Types are inferred from context, eliminating the need for explicit type declarations.

### Scope

SatoLang operates with a global scope model where:

- All wallets are globally accessible
- Market state is shared across the program
- Blockchain is a global, immutable (append-only) structure

### File Extension

SatoLang source files use the `.btc` extension, referencing Bitcoin.

---

## Installation

### Prerequisites

SatoLang requires the following tools to build and run:

- **GCC** (GNU Compiler Collection) - C compiler
- **Flex** 2.6 or later - Lexical analyzer generator
- **Bison** 3.8 or later - Parser generator
- **Make** - Build automation tool

### Platform-Specific Installation

#### macOS

```bash
brew install flex bison gcc make
```

#### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install flex bison gcc make
```

#### Fedora/RHEL

```bash
sudo dnf install flex bison gcc make
```

### Building from Source

Clone the repository and build:

```bash
git clone <repository-url>
cd SatoLang
make
```

This will generate three executables:

- `btc_parser` - Syntax validator
- `btc_compiler` - SatoLang to Assembly compiler
- `btc_vm` - Bitcoin Virtual Machine

---

## Getting Started

### Hello World Equivalent

The simplest valid SatoLang program:

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000
wallet satoshi
satoshi mine
```

This program:
1. Initializes a blockchain with 21 million coin supply
2. Creates a wallet named "satoshi"
3. Mines one block, crediting 50 coins to the wallet

### Compiling and Running

#### Method 1: Automated Pipeline

```bash
make pipeline
```

This compiles and executes the default test program.

#### Method 2: Manual Compilation

```bash
# Compile SatoLang source to Assembly
./btc_compiler program.btc

# Execute the Assembly on the VM
./btc_vm program.asm
```

#### Method 3: Makefile Target

```bash
make compile-and-run FILE=program.btc
```

### Your First Program

Create a file named `first.btc`:

```satolang
// Initialize blockchain
genesis satoshi supply 21000000 reward 50 start_price 1000

// Create wallets
wallet alice
wallet bob

// Mining operations
alice mine
alice mine
bob mine

// Transaction
alice -> bob : 30

// Check market
market

// Conditional mining
if saldo alice > 50 {
    alice mine
}

// Display blockchain
showchain

// Battle
battle alice vs bob
```

Compile and run:

```bash
./btc_compiler first.btc
./btc_vm first.asm
```

---

## Language Reference

### Program Structure

Every SatoLang program must begin with a `genesis` block:

```satolang
genesis satoshi supply TOTAL_SUPPLY reward BLOCK_REWARD start_price INITIAL_PRICE
```

**Parameters:**
- `TOTAL_SUPPLY`: Maximum coin supply (integer)
- `BLOCK_REWARD`: Coins awarded per mined block (integer)
- `INITIAL_PRICE`: Starting market price (integer)

**Example:**

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000
```

### Lexical Structure

#### Identifiers

Identifiers start with a letter and can contain letters, digits, and underscores:

```
identifier = letter (letter | digit | '_')*
```

**Valid identifiers:**
```satolang
alice
trader_1
myWallet
satoshi_nakamoto
```

#### Numbers

Integer literals only:

```
number = digit+
```

**Examples:**
```satolang
100
21000000
50
```

#### Keywords

Reserved keywords (27 total):

**Blockchain:**
```
genesis, satoshi, supply, reward, start_price
wallet, mine, showchain
```

**Market:**
```
market, update
```

**Control Flow:**
```
if, else, while, for
```

**Trading:**
```
buy_the_dip, take_profit_until, hodl_until
scalp_for, market_for
```

**Strategies:**
```
strategy, call, battle, vs
```

**Conditions:**
```
saldo
```

#### Operators

**Relational Operators:**
```
>   greater than
<   less than
>=  greater than or equal
<=  less than or equal
==  equal
!=  not equal
```

**Transaction Operator:**
```
->  transfer operator
:   value separator
```

#### Comments

Single-line comments use `//`:

```satolang
// This is a comment
wallet alice  // Inline comment
```

### Declarations

#### Wallet Declaration

Creates a new cryptocurrency wallet:

```satolang
wallet IDENTIFIER
```

**Example:**
```satolang
wallet alice
wallet bob
wallet exchange
```

### Statements

#### Mining Statement

Mines a block and credits the reward to the specified wallet:

```satolang
IDENTIFIER mine
```

**Example:**
```satolang
alice mine
```

**Effect:**
- Creates a new block in the blockchain
- Credits the block reward to the wallet
- Increments block counter

#### Transaction Statement

Transfers coins from one wallet to another:

```satolang
IDENTIFIER -> IDENTIFIER : NUMBER
```

**Example:**
```satolang
alice -> bob : 100
```

**Constraints:**
- Sender must have sufficient balance
- Amount must be positive

#### Market Statements

**Display Market Price:**
```satolang
market
```

**Update Market Price:**
```satolang
market update
```

Updates market price with random variation (±5%).

#### Blockchain Statement

Displays the entire blockchain:

```satolang
showchain
```

### Control Flow

#### Conditional Statements

**Simple If:**
```satolang
if CONDITION {
    STATEMENTS
}
```

**If-Else:**
```satolang
if CONDITION {
    STATEMENTS
} else {
    STATEMENTS
}
```

**Conditions:**

Balance condition:
```satolang
if saldo WALLET OPERATOR NUMBER {
    // statements
}
```

Market condition:
```satolang
if market OPERATOR NUMBER {
    // statements
}
```

**Examples:**
```satolang
if saldo alice > 500 {
    alice -> bob : 100
}

if market >= 50000 {
    alice mine
} else {
    bob mine
}
```

#### Traditional Loops

**For Loop (counted):**
```satolang
for NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
for 10 {
    alice mine
}
```

**While Loop (conditional):**
```satolang
while CONDITION {
    STATEMENTS
}
```

**Example:**
```satolang
while saldo alice < 1000 {
    alice mine
}
```

### Trading Loops

SatoLang provides specialized loops for trading strategies:

#### Buy The Dip

Executes statements a fixed number of times (simulating buying during price drops):

```satolang
buy_the_dip NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
buy_the_dip 5 {
    alice -> exchange : 10
}
```

#### Take Profit Until

Executes until market price reaches target:

```satolang
take_profit_until NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
take_profit_until 60000 {
    bob -> alice : 5
}
```

#### HODL Until

Holds position until market price target:

```satolang
hodl_until NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
hodl_until 100000 {
    market update
}
```

#### Scalp For

Executes rapid trades for a fixed number of iterations:

```satolang
scalp_for NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
scalp_for 20 {
    alice -> bob : 1
    bob -> alice : 1
}
```

#### Market For

Executes market operations for a fixed number of cycles:

```satolang
market_for NUMBER {
    STATEMENTS
}
```

**Example:**
```satolang
market_for 15 {
    market update
    alice mine
}
```

### Strategies

#### Strategy Declaration

Defines a reusable strategy (currently simplified in VM):

```satolang
strategy IDENTIFIER(PARAMETERS) {
    STATEMENTS
}
```

**Examples:**

Without parameters:
```satolang
strategy simple_mine() {
    alice mine
    bob mine
    market update
}
```

With parameters:
```satolang
strategy pump_and_dump(trader, price) {
    buy_the_dip 5 {
        alice -> bob : 10
    }
    take_profit_until 70000 {
        bob -> alice : 5
    }
}
```

#### Strategy Call

Invokes a defined strategy:

```satolang
call IDENTIFIER(ARGUMENTS)
```

**Example:**
```satolang
call pump_and_dump(alice, 75000)
```

### Battle System

Compares balances between two wallets:

```satolang
battle IDENTIFIER vs IDENTIFIER
```

**Example:**
```satolang
battle alice vs bob
```

**Output:**
Declares the wallet with higher balance as winner.

---

## Virtual Machine Specification

### Architecture Overview

The Bitcoin VM is a register-based virtual machine designed specifically for executing SatoLang programs. It provides native support for blockchain operations, wallet management, and market simulation.

### Registers

| Register | Purpose |
|----------|---------|
| R0 | General purpose / accumulator |
| R1 | General purpose |
| R2 | Auxiliary register |
| PC | Program counter (internal) |
| SP | Stack pointer (internal) |

### Memory Layout

| Memory Area | Size | Description |
|-------------|------|-------------|
| Blockchain | Dynamic | Append-only list of blocks |
| Wallets | 256 slots | Hash table mapping wallet names to balances |
| Stack | 1024 slots | Execution stack for temporary values |
| Market | 1 slot | Current Bitcoin price |

### Instruction Set

The VM supports 30+ instructions across several categories:

#### Control Flow Instructions

```assembly
HALT                    Stop execution
NOP                     No operation
LABEL name              Define a jump label
JUMP label              Unconditional jump
JUMPZ label             Jump if R0 == 0
JUMPNZ label            Jump if R0 != 0
```

#### Blockchain Operations

```assembly
GENESIS supply reward price    Initialize blockchain
WALLET name                     Create wallet
MINE wallet                     Mine block to wallet
TRANSFER from to amount         Transfer coins
BALANCE wallet                  Load wallet balance to R0
```

#### Market Operations

```assembly
MARKET_SHOW                     Display current price
MARKET_UPDATE                   Update price (random ±5%)
MARKET_LOAD                     Load price to R0
```

#### Blockchain Queries

```assembly
SHOWCHAIN                       Display entire blockchain
```

#### Arithmetic Operations

```assembly
LOAD R0, value                  Load immediate value
ADD R0, value                   R0 = R0 + value
SUB R0, value                   R0 = R0 - value
```

#### Relational Operations

```assembly
GT val1, val2                   R0 = (val1 > val2) ? 1 : 0
LT val1, val2                   R0 = (val1 < val2) ? 1 : 0
GTE val1, val2                  R0 = (val1 >= val2) ? 1 : 0
LTE val1, val2                  R0 = (val1 <= val2) ? 1 : 0
EQ val1, val2                   R0 = (val1 == val2) ? 1 : 0
NEQ val1, val2                  R0 = (val1 != val2) ? 1 : 0
```

#### Stack Operations

```assembly
PUSH value                      Push value to stack
POP R0                          Pop from stack to R0
```

#### I/O Operations

```assembly
PRINT message                   Print string
PRINTNUM R0                     Print R0 value
```

#### Battle Operations

```assembly
BATTLE wallet1 wallet2          Compare balances
```

### Assembly Format

Assembly files (`.asm`) use the following format:

- **Comments**: Lines starting with `#` or `;`
- **Instructions**: Case-insensitive
- **Labels**: Defined with `LABEL name`
- **Encoding**: UTF-8

**Example:**

```assembly
# Bitcoin VM Assembly
# Generated from: program.btc

GENESIS 21000000 50 1000
WALLET alice
WALLET bob
MINE alice
TRANSFER alice bob 30
MARKET_SHOW
HALT
```

### Execution Model

The VM uses a two-pass execution model:

**Pass 1 - Label Registration:**
- Scans entire program
- Records all label positions
- Builds jump table

**Pass 2 - Execution:**
- Executes instructions sequentially
- Resolves jumps using label table
- Maintains program counter
- Updates blockchain and wallet states

---

## Compiler Architecture

### Overview

The SatoLang compiler follows a traditional multi-phase architecture:

```
Source Code (.btc)
        ↓
   Lexical Analysis (Flex)
        ↓
   Syntax Analysis (Bison)
        ↓
   Code Generation
        ↓
  Assembly Code (.asm)
        ↓
Virtual Machine Execution
```

### Lexical Analysis

**Tool**: Flex (Fast Lexical Analyzer Generator)
**Input**: `.btc` source file
**Output**: Token stream

**Implementation**: `lexer.l`

The lexer recognizes:
- 27 reserved keywords
- Identifiers (wallet names, strategy names)
- Integer literals
- 6 relational operators
- Special operators (`->`, `:`)
- Comments (`//`)

**Token Types:**

```c
GENESIS, SATOSHI, SUPPLY, REWARD, START_PRICE
WALLET, MINE, MARKET, UPDATE, SHOWCHAIN
IF, ELSE, WHILE, FOR
BUY_THE_DIP, TAKE_PROFIT_UNTIL, HODL_UNTIL, SCALP_FOR, MARKET_FOR
STRATEGY, CALL, BATTLE, VS
SALDO
EQ, NEQ, GTE, LTE, GT, LT
ARROW, COLON, LPAREN, RPAREN, LBRACE, RBRACE, COMMA
IDENTIFIER, NUMBER
```

### Syntax Analysis

**Tool**: Bison (GNU Parser Generator)
**Input**: Token stream from lexer
**Output**: Parse tree with semantic actions

**Implementation**: `codegen.y`

The parser validates program structure according to the EBNF grammar and generates Assembly code during parsing (single-pass compiler).

**Grammar Structure:**

```ebnf
PROGRAM = GENESIS { STATEMENT } ;

GENESIS = "genesis" "satoshi" "supply" NUMBER
          "reward" NUMBER "start_price" NUMBER ;

STATEMENT = WALLET | TRANSACTION | MINING | MARKET | BLOCKCHAIN
          | IFSTMT | LOOP | TRADING_LOOP | MARKET_LOOP
          | STRATEGYDEC | STRATEGYCALL | BATTLE ;
```

Full grammar available in `ebnf.txt`.

### Code Generation

The compiler generates Assembly code directly during parsing (syntax-directed translation).

**Techniques Used:**

- Label generation for control flow
- Symbol table for label management
- Direct emission of VM instructions
- Stack-based temporary storage

**Example Translation:**

**Source:**
```satolang
if saldo alice > 500 {
    alice mine
}
```

**Generated Assembly:**
```assembly
BALANCE alice
GT R0 500
JUMPZ L_END_0
MINE alice
LABEL L_END_0
```

### Error Handling

**Lexical Errors:**
```
Erro léxico na linha 5: caractere inválido '@'
```

**Syntax Errors:**
```
ERRO SINTÁTICO na linha 10: syntax error
Verifique a sintaxe do seu programa SatoLang.
```

---

## Examples

### Example 1: Basic Operations

```satolang
// Initialize blockchain
genesis satoshi supply 21000000 reward 50 start_price 1000

// Create wallets
wallet alice
wallet bob

// Mining
alice mine
alice mine
bob mine

// Transaction
alice -> bob : 30

// Check balances
showchain
battle alice vs bob
```

### Example 2: Conditional Trading

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000

wallet trader
wallet exchange

// Accumulate coins
for 5 {
    trader mine
}

// Conditional sell
if saldo trader > 200 {
    trader -> exchange : 100
    market update
}

// Buy on dip
if market < 1500 {
    buy_the_dip 3 {
        exchange -> trader : 20
    }
}
```

### Example 3: Market Simulation

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000

wallet investor

// Initial accumulation
for 10 {
    investor mine
}

// HODL strategy
hodl_until 5000 {
    market update
}

// Take profit
if market >= 5000 {
    investor -> exchange : 50
}

showchain
market
```

### Example 4: Strategy Definition

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000

wallet alice
wallet bob

// Define strategy
strategy accumulate(trader, cycles) {
    for 10 {
        alice mine
        bob mine
    }

    if saldo alice > saldo bob {
        alice -> bob : 50
    }
}

// Execute strategy
call accumulate(alice, 10)

battle alice vs bob
```

### Example 5: Complex Trading

```satolang
genesis satoshi supply 21000000 reward 50 start_price 1000

wallet day_trader
wallet hodler

// Accumulate initial position
for 5 {
    day_trader mine
    hodler mine
}

// Day trading
scalp_for 10 {
    day_trader -> hodler : 5
    hodler -> day_trader : 5
    market update
}

// Long-term hold
hodl_until 10000 {
    market update
    hodler mine
}

// Final comparison
battle day_trader vs hodler
showchain
```

---

## Build System

### Makefile Targets

| Target | Description |
|--------|-------------|
| `make` | Build all components (parser, compiler, VM) |
| `make parser` | Build only the syntax validator |
| `make compiler` | Build only the compiler |
| `make vm` | Build only the virtual machine |
| `make test` | Validate syntax of example.btc |
| `make pipeline` | Full pipeline: compile and execute test_simples.btc |
| `make compile-and-run FILE=<file>` | Compile and execute specific file |
| `make clean` | Remove generated files |
| `make rebuild` | Clean and rebuild all |
| `make help` | Display help information |

### Build Process

**Phase 1 - Lexer Generation:**
```bash
flex -o lex.yy.c lexer.l
flex -o lexer_codegen.c lexer.l
```

**Phase 2 - Parser Generation:**
```bash
bison -d -o parser.tab.c parser.y
bison -d -o codegen.tab.c codegen.y
```

**Phase 3 - Compilation:**
```bash
gcc -Wall -g -o btc_parser parser.tab.c lex.yy.c
gcc -Wall -g -o btc_compiler codegen.tab.c lexer_codegen.c
gcc -Wall -g -o btc_vm vm.c
```

### Generated Files

**Temporary (not tracked in git):**
```
lex.yy.c
lexer_codegen.c
parser.tab.c
parser.tab.h
codegen.tab.c
codegen.tab.h
*.o
*.asm
```

**Executables:**
```
btc_parser
btc_compiler
btc_vm
```

---

## Documentation

### File Structure

```
SatoLang/
├── lexer.l                  Lexical analyzer specification
├── parser.y                 Syntax validator (Bison)
├── codegen.y                Compiler with code generation
├── vm.c                     Virtual machine implementation
├── Makefile                 Build automation
│
├── ebnf.txt                 Formal grammar (EBNF)
├── VM_SPEC.md               Virtual machine specification
├── README.md                This file
├── DOCUMENTACAO.md          Technical documentation (Portuguese)
├── ESTRUTURA.md             Project structure (Portuguese)
├── ENTREGA_FINAL.md         Final delivery document (Portuguese)
├── QUICKSTART_FINAL.md      Quick start guide (Portuguese)
│
├── exemplo.btc              Comprehensive example
├── teste_simples.btc        Simple example
├── teste_completo.btc       Complete example
│
└── .gitignore               Git ignore rules
```

### Additional Resources

**Grammar Specification:**
- `ebnf.txt` - Complete EBNF grammar

**VM Documentation:**
- `VM_SPEC.md` - Detailed VM specification
- Assembly instruction reference
- Memory layout details

**Technical Documentation (Portuguese):**
- `DOCUMENTACAO.md` - Implementation details
- `ESTRUTURA.md` - Project architecture
- `ENTREGA_FINAL.md` - Academic delivery document

---

## Language Grammar (EBNF)

Complete grammar specification:

```ebnf
PROGRAM = GENESIS, { STATEMENT } ;

GENESIS = "genesis", "satoshi", "supply", NUMBER,
          "reward", NUMBER, "start_price", NUMBER ;

STATEMENT = WALLET | TRANSACTION | MINING | MARKET | BLOCKCHAIN
          | IFSTMT | LOOP | TRADING_LOOP | MARKET_LOOP
          | STRATEGYDEC | STRATEGYCALL | BATTLE ;

WALLET = "wallet", IDENTIFIER ;

MINING = IDENTIFIER, "mine" ;

TRANSACTION = IDENTIFIER, "->", IDENTIFIER, ":", NUMBER ;

MARKET = "market" | "market", "update" ;

BLOCKCHAIN = "showchain" ;

IFSTMT = "if", CONDITION, "{", { STATEMENT }, "}",
         [ "else", "{", { STATEMENT }, "}" ] ;

LOOP = WHILE_LOOP | FOR_LOOP ;

WHILE_LOOP = "while", CONDITION, "{", { STATEMENT }, "}" ;

FOR_LOOP = "for", NUMBER, "{", { STATEMENT }, "}" ;

TRADING_LOOP = "buy_the_dip", NUMBER, "{", { STATEMENT }, "}"
             | "take_profit_until", NUMBER, "{", { STATEMENT }, "}"
             | "hodl_until", NUMBER, "{", { STATEMENT }, "}"
             | "scalp_for", NUMBER, "{", { STATEMENT }, "}" ;

MARKET_LOOP = "market_for", NUMBER, "{", { STATEMENT }, "}" ;

STRATEGYDEC = "strategy", IDENTIFIER, "(", [ PARAMS ], ")",
              "{", { STATEMENT }, "}" ;

PARAMS = IDENTIFIER, { ",", IDENTIFIER } ;

STRATEGYCALL = "call", IDENTIFIER, "(", [ ARGS ], ")" ;

ARGS = (IDENTIFIER | NUMBER), { ",", (IDENTIFIER | NUMBER) } ;

BATTLE = "battle", IDENTIFIER, "vs", IDENTIFIER ;

CONDITION = "saldo", IDENTIFIER, REL_OP, NUMBER
          | "market", REL_OP, NUMBER ;

REL_OP = ">" | "<" | "==" | "!=" | ">=" | "<=" ;

IDENTIFIER = LETTER, { LETTER | DIGIT | "_" } ;

NUMBER = DIGIT, { DIGIT } ;

LETTER = "a" | ... | "z" | "A" | ... | "Z" ;

DIGIT = "0" | ... | "9" ;
```

---

## Technical Specifications

### Language Metrics

- **Keywords**: 27
- **Operators**: 8 (6 relational + 2 special)
- **Tokens**: 40+
- **Loop constructs**: 7 (2 traditional + 5 trading)
- **Data types**: 2 (implicit)

### Compiler Metrics

- **Lexer**: ~110 lines (Flex)
- **Parser**: ~400 lines (Bison)
- **Code Generator**: ~500 lines (Bison)
- **Total Compiler Code**: ~1,010 lines

### VM Metrics

- **Implementation**: ~600 lines (C)
- **Instructions**: 30+
- **Registers**: 3 general purpose
- **Max Wallets**: 256
- **Stack Size**: 1024 slots

---

## Performance Characteristics

### Compilation

- **Lexical Analysis**: O(n) where n = source length
- **Syntax Analysis**: O(n) single-pass parser
- **Code Generation**: O(n) direct emission

### Runtime

- **Label Resolution**: O(1) hash table lookup
- **Wallet Lookup**: O(w) linear search, w = wallet count
- **Block Addition**: O(1) append operation
- **Market Update**: O(1) constant time

---

## Limitations and Constraints

### Current Limitations

1. **Strategy Execution**: Strategies are recognized but not fully executed (simplified implementation)
2. **Type System**: No type checking beyond implicit integer/identifier distinction
3. **Error Recovery**: Limited error recovery during parsing
4. **Wallet Capacity**: Maximum 256 wallets per program
5. **Integer Overflow**: No overflow protection on large balances
6. **Market Model**: Simplified random walk, not realistic price simulation

### Known Issues

1. **Assembly Comments**: Unicode characters in comments may cause warnings
2. **Grammar Conflicts**: 16 reduce/reduce conflicts in Bison (benign)
3. **Label Scope**: All labels are globally scoped

---

## Contributing

This is an academic project developed for educational purposes. For questions or suggestions:

- Review the documentation in `DOCUMENTACAO.md`
- Check the VM specification in `VM_SPEC.md`
- Examine example programs in `exemplo.btc` and `teste_completo.btc`

---

## References

### Tools and Standards

- **Flex**: [Flex Manual](https://github.com/westes/flex)
- **Bison**: [Bison Manual](https://www.gnu.org/software/bison/)
- **EBNF**: [Extended Backus-Naur Form](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form)

### Blockchain References

- Bitcoin Whitepaper (Satoshi Nakamoto, 2008)
- Blockchain terminology and concepts
- Cryptocurrency trading strategies

### Academic Context

**Course**: Programming Languages and Paradigms
**Institution**: Insper
**Semester**: 2025.2
**Project**: Supervised Practical Activity (APS) - Final Delivery

---

## License

This project is developed for educational purposes as part of an academic assignment.

---

## Acknowledgments

Named after Satoshi Nakamoto, the pseudonymous creator of Bitcoin, SatoLang aims to make blockchain concepts accessible through a dedicated programming language.

The language design was inspired by domain-specific languages like SQL (database operations) and R (statistical computing), demonstrating how specialized syntax can improve expressiveness for specific domains.

---

**SatoLang** - A Domain-Specific Language for Blockchain Simulation

Version 1.0.0 | 2025
