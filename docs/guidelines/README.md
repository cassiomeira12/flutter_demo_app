# Diretrizes de Código e Documentação

Propósito
- Padronizar estilo de código, documentação, e práticas de engenharia.

## Estilo de Código

### Análise Estática

O projeto usa `very_good_analysis` com regras customizadas em `analysis_options.yaml`.

```bash
# Verificar erros
make analyze
```

### Regras Principais

| Regra | Descrição |
|-------|-----------|
| `always_use_package_imports: true` | Sempre usar `package:`, nunca relative imports |
| `prefer_final_locals: true` | Variáveis locais devem ser `final` |
| `prefer_final_fields: true` | Campos devem ser `final` quando possível |
| `avoid_print: true` | Usar logger do projeto, nunca `print()` |
| `avoid_void_async: true` | Evitar `Future<void>` desnecessariamente |
| `eol_at_end_of_file: true` | Arquivos devem terminar com newline |
| `prefer_single_quotes: true` | Sempre usar aspas simples |

### Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Classes | PascalCase | `LoginController` |
| Variáveis | camelCase | `userName` |
| Constantes | camelCase | `appVersion` |
| Arquivos | snake_case | `login_controller.dart` |
| Pacotes | snake_case | `clean_code_domain` |
| Entities | Sufixo `Entity` | `UserEntity` |
| Models | Sufixo `Model` | `UserModel` |
| Use Cases | Sufixo `UseCase` | `LoginUseCase` |
| Controllers | Sufixo `Controller` | `LoginController` |
| Bindings | Sufixo `Binding` | `LoginBinding` |
| Pages | Sufixo `Page` | `LoginPage` |
| Widgets | Sufixo `Widget` | `PrimaryButton` |

### Imports

```dart
// ✅ Correto - package import
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:design_system/design_system.dart';

// ❌ Errado - relative import entre pacotes
import '../../clean_code_domain/lib/entities/user.dart';
```

## Documentação

### Markdown

- Títulos: usar `#` hierarchy (máximo 3 níveis)
- Código: sempre com linguagem especificada (```dart, ```yaml, etc)
- Links: usar links relativos entre docs
- Imagens: adicionar ao repositório na própria feature ou diretório relevante

### Código

- Comentários: apenas quando necessário para explicar "por quê", não "o que"
- Docstrings: para APIs públicas de pacotes
- TODOs: usar formato `// TODO(username): descrição`

## Estrutura de Pastas

```
lib/
├── app/                    # Inicialização, rotas, temas
├── core/                   # Utilitários globais
├── data/                   # Implementações de acesso a dados
├── domain/                 # Entidades, regras de negócio
├── infra/                  # Integrações externas
├── presentation/           # UI, controllers, pages
└── translations/           # Internacionalização
```

## Boas Práticas

1. **Separar responsabilidades**: Uma classe, um propósito
2. **Dependências via construtor**: Nunca buscar dependências dentro de classes
3. **Estado reativo**: Usar `Rx` types para estado que muda
4. **Imutabilidade**: Entities devem ser imutáveis (`final` fields)
5. **Tratamento de erros**: Usar `BaseException` com contexto
6. **Testes**: Cobrir cenários de sucesso e erro

---

**Ver também**: [Governança](governance.md) | [Glossário](glossary.md)
