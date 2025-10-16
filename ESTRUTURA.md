# 🏗️ Estrutura do Projeto SatoLang

## 📂 Árvore de Arquivos

```
SatoLang/
│
├── 📄 lexer.l                  # Analisador léxico (Flex)
├── 📄 parser.y                 # Analisador sintático (Bison)
├── 📄 Makefile                 # Automação da compilação
│
├── 📝 ebnf.txt                 # Gramática EBNF da linguagem
├── 📖 README.md                # Documentação principal
├── 📚 DOCUMENTACAO.md          # Documentação técnica detalhada
├── 📋 ESTRUTURA.md             # Este arquivo
│
├── 🧪 exemplo.btc              # Exemplo completo (testa tudo)
├── 🧪 exemplo_simples.btc      # Exemplo minimalista
├── 🧪 exemplo_erro.btc         # Exemplo com erros (teste de validação)
│
├── 🚫 .gitignore               # Arquivos a ignorar no Git
│
└── 🔨 Arquivos Gerados (não commitados):
    ├── lex.yy.c                # Código C do lexer (gerado)
    ├── parser.tab.c            # Código C do parser (gerado)
    ├── parser.tab.h            # Header do parser (gerado)
    └── btc_parser              # Executável final (gerado)
```

---

## 🔄 Fluxo de Compilação

```
┌─────────────────────────────────────────────────────────────┐
│                    PROCESSO DE COMPILAÇÃO                    │
└─────────────────────────────────────────────────────────────┘

  lexer.l                           parser.y
     │                                  │
     │ flex -o lex.yy.c lexer.l         │ bison -d -o parser.tab.c parser.y
     ▼                                  ▼
  lex.yy.c                          parser.tab.c
     │                              parser.tab.h
     │                                  │
     └──────────────┬───────────────────┘
                    │
                    │ gcc -o btc_parser parser.tab.c lex.yy.c
                    ▼
               btc_parser
                    │
                    │ ./btc_parser exemplo.btc
                    ▼
            ✅ Análise concluída!
```

---

## 🎯 Fluxo de Execução

```
┌─────────────────────────────────────────────────────────────┐
│                    PROCESSO DE PARSING                       │
└─────────────────────────────────────────────────────────────┘

  exemplo.btc
      │
      │ Leitura do arquivo
      ▼
  ┌─────────────────┐
  │ ANÁLISE LÉXICA  │ (lexer.l)
  │   (Tokenização) │
  └─────────────────┘
      │
      │ Stream de tokens
      ▼
  ┌─────────────────┐
  │ ANÁLISE SINTÁT. │ (parser.y)
  │  (Validação)    │
  └─────────────────┘
      │
      ├─── ✅ Sucesso ──> Mensagem de sucesso
      │
      └─── ❌ Erro ────> Mensagem de erro + linha
```

---

## 📊 Componentes Principais

### 1️⃣ Analisador Léxico (`lexer.l`)

```
┌──────────────────────────────────────────────────┐
│              ANALISADOR LÉXICO                   │
├──────────────────────────────────────────────────┤
│                                                  │
│  Entrada:  "wallet alice"                        │
│            ↓                                     │
│  Tokens:   WALLET IDENTIFIER("alice")            │
│            ↓                                     │
│  Saída:    Para o parser                         │
│                                                  │
├──────────────────────────────────────────────────┤
│  Funções:                                        │
│  • Reconhecer palavras-chave                     │
│  • Identificar operadores                        │
│  • Extrair identificadores e números             │
│  • Ignorar comentários e espaços                 │
│  • Detectar erros léxicos                        │
└──────────────────────────────────────────────────┘
```

### 2️⃣ Analisador Sintático (`parser.y`)

```
┌──────────────────────────────────────────────────┐
│             ANALISADOR SINTÁTICO                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  Entrada:  Stream de tokens                      │
│            ↓                                     │
│  Processo: Aplica regras da gramática            │
│            ↓                                     │
│  Saída:    Validação + Ações                     │
│                                                  │
├──────────────────────────────────────────────────┤
│  Funções:                                        │
│  • Validar estrutura sintática                   │
│  • Construir árvore de derivação                 │
│  • Executar ações semânticas                     │
│  • Detectar erros sintáticos                     │
│  • Gerenciar memória (free strings)              │
└──────────────────────────────────────────────────┘
```

### 3️⃣ Makefile

```
┌──────────────────────────────────────────────────┐
│                  MAKEFILE                        │
├──────────────────────────────────────────────────┤
│                                                  │
│  Comandos:                                       │
│  • make         → Compila tudo                   │
│  • make test    → Compila e testa                │
│  • make run     → Executa interativamente        │
│  • make clean   → Remove arquivos gerados        │
│  • make rebuild → Limpa e recompila              │
│  • make help    → Exibe ajuda                    │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

## 🧪 Arquivos de Teste

### `exemplo.btc` - Completo
- ✅ Testa **TODAS** as funcionalidades
- ✅ Estruturas aninhadas
- ✅ Todos os tipos de loops
- ✅ Estratégias complexas
- ✅ Batalhas
- **Linhas:** ~180
- **Tempo de parsing:** < 1s

### `exemplo_simples.btc` - Minimalista
- ✅ Funcionalidades básicas
- ✅ Genesis + wallets + transações
- ✅ Ideal para testes rápidos
- **Linhas:** ~15
- **Tempo de parsing:** < 0.1s

### `exemplo_erro.btc` - Inválido
- ❌ Falta bloco genesis
- ❌ Deve gerar erro sintático
- ✅ Testa tratamento de erros
- **Resultado esperado:** Erro na linha 4

---

## 📈 Estatísticas

```
┌─────────────────────────────────────────────────┐
│              ESTATÍSTICAS DO PROJETO            │
├─────────────────────────────────────────────────┤
│                                                 │
│  Tokens definidos:        40+                   │
│  Palavras-chave:          27                    │
│  Operadores:              8                     │
│  Regras sintáticas:       30+                   │
│                                                 │
│  Linhas de código:                              │
│    • lexer.l:             ~110                  │
│    • parser.y:            ~400                  │
│    • Makefile:            ~100                  │
│    • Total:               ~610                  │
│                                                 │
│  Documentação:                                  │
│    • README.md:           ~300 linhas           │
│    • DOCUMENTACAO.md:     ~400 linhas           │
│    • ESTRUTURA.md:        Este arquivo          │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 🎓 Conformidade Acadêmica

### ✅ Requisitos da Etapa 2

| Requisito | Status | Arquivo |
|-----------|--------|---------|
| Análise Léxica | ✅ | `lexer.l` |
| Análise Sintática | ✅ | `parser.y` |
| Conformidade com EBNF | ✅ | `ebnf.txt` + implementação |
| Tratamento de erros | ✅ | Ambos os arquivos |
| Makefile funcional | ✅ | `Makefile` |
| Exemplos de teste | ✅ | `exemplo*.btc` |
| Documentação | ✅ | `README.md` + extras |

### 📝 Entregas

- [x] Código-fonte completo
- [x] Makefile para compilação
- [x] Arquivo de exemplo funcional
- [x] README com instruções
- [x] EBNF da linguagem
- [x] Documentação técnica adicional

---

## 🚀 Como Usar Este Projeto

### 1. Compilar
```bash
make
```

### 2. Testar com exemplo
```bash
make test
```

### 3. Criar seu próprio programa
```bash
# Crie um arquivo .btc
nano meu_programa.btc

# Execute
./btc_parser meu_programa.btc
```

### 4. Modo interativo
```bash
make run
# Digite o código e pressione Ctrl+D
```

---

## 🔍 Debugging

### Ver tokens gerados
```bash
# Adicione debug no lexer.l:
printf("TOKEN: %s\n", yytext);
```

### Ver árvore de parsing
```bash
# Use a flag -t do Bison:
bison -t -d -o parser.tab.c parser.y
```

### Compilar com debug
```bash
make clean
make CFLAGS="-Wall -g -DYYDEBUG=1"
```

---

## 📚 Recursos Adicionais

### Arquivos de Referência
- `ebnf.txt` - Gramática formal
- `DOCUMENTACAO.md` - Detalhes técnicos
- `README.md` - Guia de uso

### Ferramentas Necessárias
- Flex (lexer generator)
- Bison (parser generator)
- GCC (compilador C)
- Make (automação)

### Links Úteis
- [Flex Manual](https://github.com/westes/flex)
- [Bison Manual](https://www.gnu.org/software/bison/)
- [EBNF Wikipedia](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form)

---

