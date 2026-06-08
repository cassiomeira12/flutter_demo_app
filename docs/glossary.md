# Glossário

Termos e definições utilizados no projeto Flutter Demo App.

## Arquitetura e Padrões

| Termo | Definição |
|-------|-----------|
| **Clean Architecture** | Padrão de arquitetura de software que separa o código em camadas (domain, data, infra, presentation) com dependências unidirecionais |
| **Entity** | Objeto de domínio imutável que representa regras de negócio. Sufixo `Entity` (ex: `UserEntity`) |
| **Model** | Classe que estende uma Entity e adiciona desserialização (`fromMap`). Sufixo `Model` (ex: `UserModel`) |
| **Use Case** | Contrato que encapsula uma regra de negócio específica. Sufixo `UseCase` (ex: `LoginUseCase`) |
| **Repository** | Interface/implementation para acesso a dados. Sufixo `Repository` |
| **Data Source** | Fonte de dados concreta (API, banco local, cache) |
| **Service** | Contrato para serviços da aplicação. Sufixo `Service` |
| **DTO** | Data Transfer Object — objetos para transporte de dados entre camadas |
| **Binding** | Configuração de injeção de dependências no GetX |
| **Controller** | Classe que gerencia estado e lógica de apresentação. Extends `LifecycleController` |

## Pacotes Core

| Termo | Definição |
|-------|-----------|
| **clean_code_domain** | Pacote com entidades, contratos de repositórios, serviços e use cases |
| **clean_code_data** | Pacote com implementações de repositórios, models e data sources |
| **clean_code_infra** | Pacote com integrações externas, HTTP client, database local |
| **core** | Pacote com funcionalidades essenciais compartilhadas (crashlytics, logger, security) |
| **dependency** | Pacote com injeção de dependências e utilitários |
| **design_system** | Pacote com componentes UI reutilizáveis (Atomic Design) |

## Componentes UI (Design System)

| Termo | Definição |
|-------|-----------|
| **Atom** | Componente UI básico e fundamental (Button, Text, Icon) |
| **Molecule** | Componente composto por átomos (FormField, AppBar) |
| **Organism** | Componente complexo composto por molecules (Scaffold, Dialog) |
| **AppView** | Classe abstrata base para views usando GetX |
| **Design Token** | Valores visuais reutilizáveis (cores, tipografia, espaçamento) |

## GetX

| Termo | Definição |
|-------|-----------|
| **AppBinding** | Classe para registrar dependências no GetX |
| **LifecycleController** | Controller com ciclo de vida (onInit, onReady, onClose) |
| **Obx** | Widget que reconstrói quando observáveis mudam |
| **Rx** | Tipo reativo do GetX (ex: `RxString`, `RxBool`) |

## Infraestrutura

| Termo | Definição |
|-------|-----------|
| **ParserToJson** | Classe abstrata para serialização `toMap()` |
| **BaseEntity** | Classe base para entidades persistidas (objectId, createdAt, updatedAt) |
| **BaseException** | Exceção base do projeto com stack trace e complemento |
| **Result\<T\** | Padrão monad para resultados (Success/Error) |
| **ModuleBinding** | Interface para módulos de DI |

## Ferramentas

| Termo | Definição |
|-------|-----------|
| **Aptabase** | Serviço de analytics |
| **Sentry** | Serviço de crash reporting |
| **Hive** | Banco de dados local para Flutter |
| **GetX** | Framework de gerenciamento de estado para Flutter |

---

**Ver também**: [Visão Geral](overview.md) | [Arquitetura](architecture/architecture-diagrams.md)
