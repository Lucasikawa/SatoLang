# Bitcoin VM - Especificação

## Visão Geral

A **Bitcoin VM** é uma máquina virtual projetada especificamente para executar programas SatoLang compilados. Ela simula um ambiente de blockchain com suporte a carteiras, mineração, transações e mercado.

---

## Arquitetura

### Registradores

| Registrador | Função |
|-------------|--------|
| `R0` | Registrador de uso geral / acumulador |
| `R1` | Registrador de uso geral |
| `R2` | Registrador auxiliar |
| `PC` | Program Counter (interno) |
| `SP` | Stack Pointer (interno) |

### Memória

| Área | Tamanho | Função |
|------|---------|--------|
| **Blockchain** | Dinâmica | Armazena blocos minerados |
| **Wallets** | 256 slots | Tabela hash de carteiras (nome → saldo) |
| **Stack** | 1024 slots | Pilha de execução |
| **Market** | 1 slot | Preço atual do Bitcoin |

---

## Set de Instruções

### 1. Controle de Programa

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `HALT` | `HALT` | Para a execução |
| `NOP` | `NOP` | Nenhuma operação |
| `LABEL` | `LABEL nome` | Define um rótulo |
| `JUMP` | `JUMP label` | Salta para rótulo |
| `JUMPZ` | `JUMPZ label` | Salta se R0 == 0 |
| `JUMPNZ` | `JUMPNZ label` | Salta se R0 != 0 |

### 2. Blockchain Operations

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `GENESIS` | `GENESIS supply reward price` | Inicializa blockchain |
| `WALLET` | `WALLET name` | Cria carteira |
| `MINE` | `MINE wallet` | Minera bloco (adiciona reward) |
| `TRANSFER` | `TRANSFER from to amount` | Transfere BTC |
| `BALANCE` | `BALANCE wallet` | Carrega saldo em R0 |

### 3. Market Operations

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `MARKET_SHOW` | `MARKET_SHOW` | Exibe preço atual |
| `MARKET_UPDATE` | `MARKET_UPDATE` | Atualiza preço (±5% random) |
| `MARKET_LOAD` | `MARKET_LOAD` | Carrega preço em R0 |

### 4. Blockchain Query

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `SHOWCHAIN` | `SHOWCHAIN` | Exibe toda a blockchain |

### 5. Operações Aritméticas/Lógicas

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `LOAD` | `LOAD R0, value` | Carrega valor em registrador |
| `ADD` | `ADD R0, value` | R0 = R0 + value |
| `SUB` | `SUB R0, value` | R0 = R0 - value |
| `CMP` | `CMP R0, value` | Compara R0 com value (seta flags) |

### 6. Operações Relacionais (definem R0)

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `GT` | `GT val1, val2` | R0 = (val1 > val2) ? 1 : 0 |
| `LT` | `LT val1, val2` | R0 = (val1 < val2) ? 1 : 0 |
| `GTE` | `GTE val1, val2` | R0 = (val1 >= val2) ? 1 : 0 |
| `LTE` | `LTE val1, val2` | R0 = (val1 <= val2) ? 1 : 0 |
| `EQ` | `EQ val1, val2` | R0 = (val1 == val2) ? 1 : 0 |
| `NEQ` | `NEQ val1, val2` | R0 = (val1 != val2) ? 1 : 0 |

### 7. Stack Operations

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `PUSH` | `PUSH value` | Empilha valor |
| `POP` | `POP R0` | Desempilha para registrador |

### 8. I/O Operations

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `PRINT` | `PRINT msg` | Imprime mensagem |
| `PRINTNUM` | `PRINTNUM R0` | Imprime número em R0 |

### 9. Battle System

| Instrução | Formato | Descrição |
|-----------|---------|-----------|
| `BATTLE` | `BATTLE wallet1 wallet2` | Compara saldos e declara vencedor |

---

## Exemplo de Programa Assembly

### Programa SatoLang:
```btc
genesis satoshi supply 21000000 reward 50 start_price 1000
wallet alice
alice mine
alice mine
```

### Assembly Gerado:
```asm
GENESIS 21000000 50 1000
WALLET alice
MINE alice
MINE alice
HALT
```

---

## Formato de Arquivo Assembly

- **Extensão:** `.asm`
- **Encoding:** UTF-8
- **Comentários:** Linhas iniciadas com `#` ou `;`
- **Case-insensitive:** Instruções podem ser maiúsculas ou minúsculas

---

## Limites e Restrições

| Recurso | Limite |
|---------|--------|
| Wallets | 256 |
| Blocos na chain | Ilimitado (memória disponível) |
| Stack size | 1024 |
| Tamanho de label | 64 caracteres |
| Comprimento de linha | 1024 caracteres |

---

## Implementação

A VM é implementada em C como um interpretador que:

1. **Lê** o arquivo `.asm`
2. **Parseia** as instruções
3. **Executa** linha por linha
4. **Gerencia** estado da blockchain
5. **Para** ao encontrar `HALT`

---
