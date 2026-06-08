# Documentação do Flutter Demo App

Ponto de entrada central para toda a documentação do projeto.

## Visão Geral

- [Visão Geral do Projeto](overview.md) — Propósito, escopo e princípios-chave
- [Arquitetura](architecture/architecture-diagrams.md) — Estrutura Clean Architecture e diagramas
- [Guia de Pacotes](packages-guide.md) — Estrutura do monorepo e 28 pacotes

## Camadas Clean Architecture

| Camada           | Documentação                                  | Descrição                                         |
| ---------------- | --------------------------------------------- | ------------------------------------------------- |
| **Domain**       | [entities.md](domain/entities.md)             | Entidades de domínio (9 cenários documentados)    |
|                  | [use-cases.md](domain/use-cases.md)           | Contratos de casos de uso                         |
|                  | [domain/README.md](domain/README.md)          | Documentação completa do pacote clean_code_domain |
| **Data**         | [models.md](data/models.md)                   | Models (4 cenários de serialização)               |
|                  | [repositories.md](data/repositories.md)       | Implementações de repositórios offline-first      |
|                  | [services.md](data/services.md)               | Implementações de services (23 services)          |
| **Infra**        | [infra.md](infra/infra.md)                    | Data sources, HTTP client, database               |
| **Presentation** | [controllers.md](presentation/controllers.md) | Controllers (BaseController, LifecycleController) |
|                  | [page.md](presentation/page.md)               | Pages (AppView)                                   |
|                  | [bindings.md](presentation/bindings.md)       | Bindings (ModuleBinding + page Bindings)          |

## Padrões e Templates

| Template | Arquivo                             |
| -------- | ----------------------------------- |
| Entity   | [entities.md](domain/entities.md)   |
| Model    | [models.md](data/models.md)         |
| Use Case | [use-cases.md](domain/use-cases.md) |

## Design System

- [Design System README](design-system/README.md) — Componentes Atomic Design (Atoms, Molecules, Organisms)

## Diretrizes e Governança

| Documento                                    | Descrição                                           |
| -------------------------------------------- | --------------------------------------------------- |
| [Diretrizes de Código](guidelines/README.md) | Estilo, lint, formatação e convenções               |
| [Governança](governance.md)                  | Papéis, responsabilidades e processo de atualização |
| [Glossário](glossary.md)                     | Termos e definições do projeto                      |

## Infraestrutura

| Documento                   | Descrição                                       |
| --------------------------- | ----------------------------------------------- |
| [Testes](testing/README.md) | Estratégia de testes (unit, widget, integração) |
| [CI/CD](ci-cd/README.md)    | Pipeline de integração e entrega contínua       |

## Fluxo de Navegação Sugerido

```
Novo no projeto?
  → overview.md (entender propósito)
  → architecture/architecture-diagrams.md (ver estrutura)
  → packages-guide.md (conhecer pacotes)

Criando uma nova feature?
  → domain/entities.md (criar entity)
  → data/models.md (criar model)
  → domain/use-cases.md (criar use case)
  → presentation/controllers.md (criar controller)
  → presentation/bindings.md (registrar dependências)

Contribuindo?
  → guidelines/README.md (estilo de código)
  → governance.md (processo de revisão)
```
