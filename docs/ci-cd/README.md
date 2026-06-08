# CI/CD

Propósito
- Visão geral do pipeline de integração contínua e entrega contínua.

## Pipeline

```mermaid
flowchart LR
    A[Push/PR] --> B[Lint & Analyze]
    B --> C[Tests]
    C --> D[Build]
    D --> E[Deploy]
```

## Etapas

### 1. Lint & Analyze

```bash
make analyze
```

- Verificação de estilo de código (`very_good_analysis`)
- Detecção de erros estáticos
- Validação de imports e convenções

### 2. Tests

```bash
make test
```

- Testes unitários (`test/`)
- Testes de widget
- Seleção de env via `.env.*`
- Coverage report

### 3. Build

```bash
make build
```

Fluxo guiado:
1. Seleção de plataforma (android, ios, web, macos, linux, windows)
2. Seleção de env (dev, stg, prod)
3. Seleção de modo (debug, profile, release)

### 4. Deploy

- **Android**: Google Play Store (via Fastlane ou manual)
- **iOS**: App Store Connect (via Fastlane ou Xcode)
- **Web**: Hosting (Firebase, Netlify, etc)
- **macOS**: Mac App Store ou distribuição direta

## Ambientes

| Ambiente | Arquivo Env | Descrição |
|----------|-------------|-----------|
| Development | `.env.dev` | Desenvolvimento local |
| Staging | `.env.stg` | Testes e validação |
| Production | `.env.prod` | Produção |

**Importante**: Arquivos `.env.*` estão no `.gitignore` — não committar.

## Variáveis de Ambiente

```json
{
  "app_name": "Flutter Demo App",
  "server_url": "https://api.example.com",
  "analytics_aptabase_app_key": "chave-aptabase",
  "sentry_dsn": "dsn-sentry"
}
```

## Observabilidade

| Serviço | Propósito |
|---------|-----------|
| **Aptabase** | Analytics e métricas de uso |
| **Sentry** | Crash reporting e tracking de erros |

## Comandos Úteis

```bash
# Limpeza completa
make clean

# Instalar dependências
make pubget

# Análise estática
make analyze

# Rodar testes
make test

# Build guiado
make build
```

## Qualidade

Antes de cada deploy, verificar:

- [ ] `make analyze` sem erros
- [ ] `make test` todos passando
- [ ] Coverage mínimo mantido
- [ ] Changelog atualizado
- [ ] Versão bumpada no `pubspec.yaml`

---

**Ver também**: [Testes](../testing/README.md) | [Governança](../governance.md)
