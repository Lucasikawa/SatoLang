# ⚡ Quick Start - SatoLang

## 🚀 Início Rápido em 3 Passos

### 1️⃣ Compilar
```bash
make
```

### 2️⃣ Testar
```bash
make test
```

### 3️⃣ Criar seu programa
```bash
nano meu_programa.btc
./btc_parser meu_programa.btc
```

---

## 📝 Template Mínimo

Crie um arquivo `meu_programa.btc`:

```btc
// Bloco genesis (obrigatório)
genesis satoshi supply 21000000 reward 50 start_price 1000

// Seu código aqui
wallet alice
alice mine
```

Execute:
```bash
./btc_parser meu_programa.btc
```

---

## 🎯 Comandos Essenciais

| Comando | O que faz |
|---------|-----------|
| `make` | Compila tudo |
| `make test` | Testa com exemplo |
| `make clean` | Limpa arquivos gerados |
| `make help` | Mostra ajuda |

---

## 📚 Sintaxe Básica

### Bloco Genesis (obrigatório)
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

### Transação
```btc
alice -> bob : 100
```

### Mercado
```btc
market
market update
```

### Condicional
```btc
if saldo alice > 500 {
    alice -> bob : 100
}
```

### Loop
```btc
for 10 {
    alice mine
}
```

### Estratégia
```btc
strategy my_strategy() {
    alice mine
}

call my_strategy()
```

---

## 🐛 Problemas Comuns

### Erro: "library 'fl' not found"
**Solução:** Já corrigido no Makefile (macOS)

### Erro: "genesis not found"
**Solução:** Todo programa deve começar com o bloco `genesis`

### Erro: "syntax error"
**Solução:** Verifique a sintaxe. Veja `exemplo.btc` para referência

---

## 📖 Documentação Completa

- `README.md` - Guia completo de uso
- `DOCUMENTACAO.md` - Detalhes técnicos
- `ESTRUTURA.md` - Estrutura do projeto
- `APRESENTACAO.md` - Apresentação do projeto
- `ebnf.txt` - Gramática formal

---

## 🎓 Exemplos Prontos

| Arquivo | Descrição |
|---------|-----------|
| `exemplo.btc` | Exemplo completo (180 linhas) |
| `exemplo_simples.btc` | Exemplo minimalista (15 linhas) |
| `exemplo_erro.btc` | Exemplo com erro (para teste) |

---

## ✅ Checklist

- [ ] Compilou com `make`?
- [ ] Testou com `make test`?
- [ ] Executou `./btc_parser exemplo.btc`?
- [ ] Criou seu próprio programa `.btc`?
- [ ] Leu o `README.md`?

---

## 🆘 Ajuda

### Precisa de ajuda?
```bash
make help
```

### Ver exemplos?
```bash
cat exemplo_simples.btc
cat exemplo.btc
```

### Recompilar do zero?
```bash
make rebuild
```

---

**Pronto para começar! 🚀**

