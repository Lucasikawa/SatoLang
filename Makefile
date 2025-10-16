# Makefile para SatoLang
# Linguagens e Paradigmas - APS Etapa 2
#
# Compila o analisador léxico (Flex) e sintático (Bison)
# para a linguagem SatoLang

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g
# No macOS, não precisamos de -lfl (biblioteca Flex)
# Em Linux, pode ser necessário descomentar: LDFLAGS = -lfl
LDFLAGS =

# Arquivos fonte
LEXER = lexer.l
PARSER = parser.y

# Arquivos gerados
PARSER_C = parser.tab.c
PARSER_H = parser.tab.h
LEXER_C = lex.yy.c

# Executável final
TARGET = btc_parser

# Arquivo de exemplo
EXAMPLE = exemplo.btc

# ========== REGRAS DE COMPILAÇÃO ==========

# Regra padrão: compila tudo
all: $(TARGET)
	@echo ""
	@echo "✅ Compilação concluída com sucesso!"
	@echo "   Execute: ./$(TARGET) < $(EXAMPLE)"
	@echo "   Ou:      ./$(TARGET) $(EXAMPLE)"
	@echo ""

# Compila o executável final
$(TARGET): $(PARSER_C) $(LEXER_C)
	@echo "🔗 Linkando arquivos objeto..."
	$(CC) $(CFLAGS) -o $(TARGET) $(PARSER_C) $(LEXER_C) $(LDFLAGS)

# Gera o parser com Bison
$(PARSER_C): $(PARSER)
	@echo "🔨 Gerando parser com Bison..."
	bison -d -o $(PARSER_C) $(PARSER)

# Gera o lexer com Flex
$(LEXER_C): $(LEXER)
	@echo "🔨 Gerando lexer com Flex..."
	flex -o $(LEXER_C) $(LEXER)

# ========== REGRAS DE TESTE ==========

# Executa o parser com o arquivo de exemplo
test: $(TARGET)
	@echo ""
	@echo "🧪 Testando com arquivo de exemplo..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET) $(EXAMPLE)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""

# Executa o parser lendo da entrada padrão
run: $(TARGET)
	@echo ""
	@echo "📝 Digite seu código SatoLang (Ctrl+D para finalizar):"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET)

# ========== REGRAS DE LIMPEZA ==========

# Remove arquivos gerados
clean:
	@echo "🧹 Limpando arquivos gerados..."
	rm -f $(TARGET) $(PARSER_C) $(PARSER_H) $(LEXER_C)
	rm -f *.o
	@echo "✅ Limpeza concluída!"

# Remove tudo e recompila
rebuild: clean all

# ========== REGRAS DE AJUDA ==========

help:
	@echo ""
	@echo "╔════════════════════════════════════════════════════════╗"
	@echo "║   SatoLang - Makefile                                 ║"
	@echo "╚════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo ""
	@echo "  make          - Compila o parser"
	@echo "  make test     - Compila e testa com exemplo.btc"
	@echo "  make run      - Compila e executa (lê da stdin)"
	@echo "  make clean    - Remove arquivos gerados"
	@echo "  make rebuild  - Limpa e recompila tudo"
	@echo "  make help     - Exibe esta mensagem"
	@echo ""
	@echo "Uso do parser:"
	@echo ""
	@echo "  ./$(TARGET) arquivo.btc    - Analisa um arquivo"
	@echo "  ./$(TARGET) < arquivo.btc  - Analisa via redirecionamento"
	@echo "  ./$(TARGET)                - Lê da entrada padrão"
	@echo ""

# Declara regras que não geram arquivos
.PHONY: all test run clean rebuild help

