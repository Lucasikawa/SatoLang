# Makefile para SatoLang
# Linguagens e Paradigmas - APS Etapa 3
#
# Compila o compilador SatoLang e a Bitcoin VM

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g
# No macOS, não precisamos de -lfl (biblioteca Flex)
# Em Linux, pode ser necessário descomentar: LDFLAGS = -lfl
LDFLAGS =

# Arquivos fonte
LEXER = lexer.l
PARSER = parser.y
CODEGEN = codegen.y
VM = vm.c

# Arquivos gerados
PARSER_C = parser.tab.c
PARSER_H = parser.tab.h
CODEGEN_C = codegen.tab.c
CODEGEN_H = codegen.tab.h
LEXER_C = lex.yy.c

# Executáveis
TARGET_PARSER = btc_parser
TARGET_COMPILER = btc_compiler
TARGET_VM = btc_vm

# Arquivos de exemplo
EXAMPLE = exemplo.btc
EXAMPLE_SIMPLE = teste_simples.btc

# ========== REGRAS DE COMPILAÇÃO ==========

# Regra padrão: compila tudo
all: $(TARGET_PARSER) $(TARGET_COMPILER) $(TARGET_VM)
	@echo ""
	@echo "✅ Compilação concluída com sucesso!"
	@echo ""
	@echo "📚 Ferramentas disponíveis:"
	@echo "   1. Parser (validação):    ./$(TARGET_PARSER) arquivo.btc"
	@echo "   2. Compilador:            ./$(TARGET_COMPILER) arquivo.btc"
	@echo "   3. VM:                    ./$(TARGET_VM) arquivo.asm"
	@echo ""
	@echo "🚀 Pipeline completo:"
	@echo "   make pipeline             # Compila e executa teste_simples.btc"
	@echo ""

# Compila apenas o parser (validação sintática)
parser: $(TARGET_PARSER)

# Compila apenas o compilador
compiler: $(TARGET_COMPILER)

# Compila apenas a VM
vm: $(TARGET_VM)

# Compila o parser (validação)
$(TARGET_PARSER): $(PARSER_C) $(LEXER_C)
	@echo "🔗 Linkando parser (validação)..."
	$(CC) $(CFLAGS) -o $(TARGET_PARSER) $(PARSER_C) $(LEXER_C) $(LDFLAGS)

# Compila o compilador (geração de código)
$(TARGET_COMPILER): $(CODEGEN_C) lexer_codegen.c
	@echo "🔗 Linkando compilador..."
	$(CC) $(CFLAGS) -o $(TARGET_COMPILER) $(CODEGEN_C) lexer_codegen.c $(LDFLAGS)

# Compila a VM
$(TARGET_VM): $(VM)
	@echo "🔗 Compilando Bitcoin VM..."
	$(CC) $(CFLAGS) -o $(TARGET_VM) $(VM)

# Gera o parser com Bison (validação)
$(PARSER_C): $(PARSER)
	@echo "🔨 Gerando parser com Bison..."
	bison -d -o $(PARSER_C) $(PARSER)

# Gera o compilador com Bison (geração de código)
$(CODEGEN_C): $(CODEGEN)
	@echo "🔨 Gerando compilador com Bison..."
	bison -d -o $(CODEGEN_C) $(CODEGEN)

# Gera o lexer para validação
$(LEXER_C): $(LEXER)
	@echo "🔨 Gerando lexer com Flex (validação)..."
	flex -o $(LEXER_C) $(LEXER)

# Gera o lexer para compilador
lexer_codegen.c: $(LEXER)
	@echo "🔨 Gerando lexer com Flex (compilador)..."
	flex -o lexer_codegen.c $(LEXER)

# ========== REGRAS DE TESTE ==========

# Testa o parser (validação sintática)
test: $(TARGET_PARSER)
	@echo ""
	@echo "🧪 Testando parser com arquivo de exemplo..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET_PARSER) $(EXAMPLE)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""

# Pipeline completo: compila .btc → .asm → executa na VM
pipeline: all
	@echo ""
	@echo "🚀 ========== PIPELINE COMPLETO =========="
	@echo ""
	@echo "📝 Etapa 1: Compilando $(EXAMPLE_SIMPLE) para Assembly..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET_COMPILER) $(EXAMPLE_SIMPLE)
	@echo ""
	@echo "🎯 Etapa 2: Executando na Bitcoin VM..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET_VM) teste_simples.asm
	@echo ""
	@echo "✅ Pipeline concluído!"
	@echo ""

# Compila um arquivo específico e executa
compile-and-run: all
	@if [ -z "$(FILE)" ]; then \
		echo "Uso: make compile-and-run FILE=seu_arquivo.btc"; \
		exit 1; \
	fi
	@echo "📝 Compilando $(FILE)..."
	./$(TARGET_COMPILER) $(FILE)
	@echo ""
	@ASMFILE=$$(echo $(FILE) | sed 's/\.btc$$/\.asm/'); \
	echo "🎯 Executando $$ASMFILE..."; \
	./$(TARGET_VM) $$ASMFILE

# Executa o parser lendo da entrada padrão
run: $(TARGET_PARSER)
	@echo ""
	@echo "📝 Digite seu código SatoLang (Ctrl+D para finalizar):"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	./$(TARGET_PARSER)

# ========== REGRAS DE LIMPEZA ==========

# Remove arquivos gerados
clean:
	@echo "🧹 Limpando arquivos gerados..."
	rm -f $(TARGET_PARSER) $(TARGET_COMPILER) $(TARGET_VM)
	rm -f $(PARSER_C) $(PARSER_H) $(CODEGEN_C) $(CODEGEN_H)
	rm -f $(LEXER_C) lexer_codegen.c
	rm -f *.o *.asm
	rm -rf *.dSYM
	@echo "✅ Limpeza concluída!"

# Remove tudo e recompila
rebuild: clean all

# ========== REGRAS DE AJUDA ==========

help:
	@echo ""
	@echo "╔════════════════════════════════════════════════════════╗"
	@echo "║   SatoLang - Makefile (APS Etapa 3)                  ║"
	@echo "╚════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "📚 Comandos de Compilação:"
	@echo "  make              - Compila tudo (parser + compilador + VM)"
	@echo "  make parser       - Compila apenas o parser (validação)"
	@echo "  make compiler     - Compila apenas o compilador"
	@echo "  make vm           - Compila apenas a VM"
	@echo ""
	@echo "🧪 Comandos de Teste:"
	@echo "  make test         - Testa o parser com exemplo.btc"
	@echo "  make pipeline     - Pipeline completo (.btc → .asm → executa)"
	@echo "  make compile-and-run FILE=arquivo.btc  - Compila e executa arquivo"
	@echo ""
	@echo "🛠️  Comandos Utilitários:"
	@echo "  make clean        - Remove arquivos gerados"
	@echo "  make rebuild      - Limpa e recompila tudo"
	@echo "  make help         - Exibe esta mensagem"
	@echo ""
	@echo "💡 Uso das Ferramentas:"
	@echo "  ./btc_parser arquivo.btc       - Valida sintaxe"
	@echo "  ./btc_compiler arquivo.btc     - Gera arquivo.asm"
	@echo "  ./btc_vm arquivo.asm           - Executa Assembly"
	@echo ""
	@echo "🚀 Exemplo de Pipeline:"
	@echo "  ./btc_compiler teste.btc && ./btc_vm teste.asm"
	@echo ""

# Declara regras que não geram arquivos
.PHONY: all parser compiler vm test pipeline compile-and-run run clean rebuild help

