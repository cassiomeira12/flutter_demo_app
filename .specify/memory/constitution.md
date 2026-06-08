<!--
  Relatório de Impacto da Sincronização
  Mudança de versão: (template) → 1.0.0
  Princípios modificados: (todos novos — população inicial a partir do template)
  Seções adicionadas: Princípios Fundamentais (5), Stack Tecnológico & Padrões,
                      Fluxo de Desenvolvimento, Governança
  Seções removidas: (nenhuma)
  Templates que requerem atualizações:
    - .specify/templates/tasks-template.md: ✅ atualizado (OPCIONAL → OBRIGATÓRIO)
  TODOs de acompanhamento: nenhum
-->

# Constituição do Flutter Demo App

## Princípios Fundamentais

### I. Clean Architecture

Separação estrita de camadas aplicada em todas as funcionalidades: `domain` (entidades, contratos)
→ `data` (models, implementações de repository) → `infra` (data sources) → `presentation`
(controllers, páginas). Inversão de dependência DEVE ser usada — `domain` define
contratos abstratos, `data` fornece implementações concretas com sufixo `Impl`.
Entidades são classes Dart puras que estendem `ParserToJson` ou `BaseEntity`; Models
estendem sua Entidade correspondente e implementam `fromMap` com try/catch +
`BaseException` e `complement: 'Json Data: $map'`. Nenhuma camada pode importar de
uma camada acima dela.

### II. Convenções GetX

Todos os controllers DEVEM estender `BaseController`. Todas as páginas DEVEM estender
`AppView<Controller>`. Todo registro de dependência DEVE usar
`AppBinding.put<T>()` / `AppBinding.find<T>()`. Dependências DEVEM ser injetadas
via construtor — sem localizadores estáticos ou singletons globais. Navegação DEVE usar
roteamento GetX, nunca `Navigator.push` diretamente.

### III. Portão de Qualidade Test-First (NÃO-NEGOCIÁVEL)

`make analyze` DEVE passar com zero erros de lint antes de qualquer commit. `make test`
DEVE passar antes de qualquer merge em `developments/master`. Novas funcionalidades e correções
de bugs DEVEM incluir testes correspondentes (unitários, widget ou integração conforme
apropriado). Seções de teste em tarefas de funcionalidades são OBRIGATÓRIAS, não opcionais.
Ordem de validação de build: `make clean` → `make analyze` → `make test` → build. Testes
DEVEM ser escritos e confirmados como falhando antes do início da implementação
(Red-Green-Refactor).

### IV. Convenções de Código

Todos os imports DEVEM usar caminhos `package:` (`always_use_package_imports`). Strings
DEVEM usar aspas simples. Variáveis locais e campos DEVEM ser `final` quando possível
(`prefer_final_locals`, `prefer_final_fields`). `print()` NÃO DEVE ser usado —
use o logger do projeto. `avoid_void_async` e `prefer_single_quotes`
se aplicam em todo o projeto. Arquivos DEVEM terminar com uma única quebra de linha
(`eol_at_end_of_file`).

### V. Monorepo Modular

Funcionalidades DEVEM ser implementadas como pacotes isolados em `packages/` seguindo
a estrutura de diretórios `src/{domain,data,infra,presentation}/`. A direção da
dependência entre pacotes DEVE seguir estritamente a cadeia:
`dependency → core → design_system → clean_code_*`. Dependências circulares são
PROIBIDAS. Cada pacote DEVE ter uma única responsabilidade bem definida. Adicionar
um novo pacote requer justificativa na especificação ou plano relevante.

## Stack Tecnológico & Padrões

- **Runtime**: Flutter >=3.38.3, Dart SDK ^3.10.1
- **Gerenciamento de Estado**: GetX (Get, LifecycleController, AppBinding, AppView)
- **Analytics**: Aptabase
- **Relatório de Crash**: Sentry
- **Linting**: very_good_analysis com regras específicas do projeto em
  `analysis_options.yaml`
- **Ambiente**: Arquivos `.env.*` baseados em JSON injetados via
  `--dart-define-from-file=<env>`
- **Estratégia de Branch**: Todos os branches de funcionalidade a partir de `developments/master`

## Fluxo de Desenvolvimento

1. `make pubget` após qualquer mudança de dependência (executa `flutter pub get` +
   instalação CocoaPods)
2. `make analyze` antes de qualquer commit
3. `make test` antes de qualquer merge
4. `make build` para builds guiados (interativo: plataforma → env → modo)
5. PRs destinam-se a `developments/master` e DEVEM passar na análise CI + testes

## Governança

Esta Constituição substitui todas as práticas de desenvolvimento ad-hoc. Emendas
exigem:

1. Justificativa documentada na descrição do PR
2. Aprovação de pelo menos um mantenedor
3. Um plano de migração se a mudança afetar trabalhos em andamento
4. Incremento de versão por regras semânticas: MAJOR para mudanças de princípios
   que quebram compatibilidade, MINOR para novos princípios/seções, PATCH para
   esclarecimentos e refinamentos

Todos os PRs e revisões DEVEM verificar conformidade com os princípios acima.
Complexidade DEVE ser justificada conforme YAGNI — comece simples, adicione apenas
quando necessário. Use AGENTS.md para orientação de desenvolvimento em tempo real.

**Versão**: 1.0.0 | **Ratificado**: 2026-05-21 | **Última Emenda**: 2026-05-21
