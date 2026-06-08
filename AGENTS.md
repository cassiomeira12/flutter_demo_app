# Flutter Demo App — AGENTS.md

## Stack

- **Flutter** >=3.44.0 | **Dart SDK** ^3.12.0
- **State**: GetX (`LifecycleController`, `AppBinding`, `AppView`, `GetMaterialApp`)
- **Lint**: `very_good_analysis` 10.2.0 + custom rules in `analysis_options.yaml`
- **Analytics**: Aptabase | **Crashlytics**: Sentry

## Project structure

Flutter monorepo workspace with **28 packages** in `packages/`. App entrypoint at `lib/main.dart`.

```
lib/ → {app, core, data, domain, infra, presentation, translations}/
```

### Key packages

| Package | Role |
|---|---|
| `core` | Shared utils, DI, router, logger, themes, i18n, middlewares, observers |
| `dependency` | DI wiring |
| `design_system` | UI atoms/molecules (AppBar, Button, TextField, Scaffold, etc.) |
| `clean_code_domain` | Entities, repository/usecase contracts |
| `clean_code_data` | Models, repository/usecase implementations |
| `clean_code_infra` | Data sources, external integrations |

### Package layer convention

Each feature package (`login/`, `home/`, etc.) has `src/{domain,data,infra,presentation}/` mirroring clean architecture.

### Commented-out packages

`appsflyer`, `firebase_initialize`, `push_notifications`, `push_messaging` — commented in `pubspec.yaml`, `app_bindings.dart`, and `app_module.dart`. Do not import without uncommenting.

## Essential commands

```bash
make pubget              # flutter pub get + pod install (iOS/macOS)
make analyze             # flutter analyze --no-pub
make test                # flutter test test packages (interactive env selection)
make test-file           # flutter test <file> (interactive, caches path in .test_file_path)
make clean               # flutter clean + gradle clean + pods clean + pubget
make build               # guided: platform → env → mode
```

### Test quirk

`make test` and `make test-file` require selecting an env file **interactively** via `make choice-env`. Env files are stored at `../envs/env.<project-name>.<env>` (parent directory), **not** `.env.*` at root. Tests inject config via `--dart-define-from-file=<path>`.

### Validation order before build

`make clean` → `make analyze` → `make test` → build

## Code conventions (enforced by lint)

- Single quotes (`'string'`)
- `always_use_package_imports: true` — use `package:` imports, never relative across packages
- `prefer_final_locals: true`, `prefer_final_fields: true`
- `avoid_print: true` — use the project logger
- `eol_at_end_of_file: true`

## Architecture patterns

- **Entities**: suffix `Entity`, `final` fields, named constructor, extend `ParserToJson` (serialization) or `BaseEntity` (DB persistence)
- **Models**: suffix `Model`, extend the Entity, `fromMap` with try/catch + `BaseException` + `complement: 'Json Data: $map'`
- **Use Cases**: abstract interface in `domain`, suffixed `Impl` implementation in `data`
- **Services**: abstract interface in `domain`, mixin pattern (`*ServiceMixin`) in `data`
- **Controllers**: `extends LifecycleController`, deps via constructor
- **Pages**: `extends AppView<Controller>`
- **Bindings**: `AppBinding.put<T>()` / `AppBinding.find<T>()`

## Git workflow

- **Base branch**: `developments/master`
- **Commit format** (enforced by `.githooks/commit-msg`):
  ```
  [<branch-suffix>] <type>: <description>
  ```
  Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`
- **Pre-commit hook** (`.githooks/pre-commit`): runs `dart analyze` + `dart fix --dry-run`. Skip with `SKIP_ANALYZE=1 git commit ...`
- **Setup hooks**: `make install-hooks` (`git config core.hooksPath .githooks`)

### Makefile git helpers

| Command | Action |
|---|---|
| `make stash` | Stash with date message |
| `make stash-pop` | Stash pop (or apply) |
| `make rebase` | Interactive rebase branch picker |
| `make push` | `git push --force-with-lease` |
| `make logs` | Generate changelog from commit history |
| `make worktree` | Interactive git worktree creator |

## Other useful commands

```bash
dart run package_rename                                # rename app package
dart run flutter_launcher_icons -f flutter_launcher_icons*.yaml  # app icons (dev/stg/prod)
dart run flutter_native_splash:create --path=flutter_native_splash*.yaml  # splash screens
dart run build_runner build                            # code generation
make native-splash                                     # all env splash + cleanup
make icons                                             # all env icons + cleanup
make integration-test                                  # flutter test integration_test/runner_test.dart
```

## Env files

- Stored at `../envs/env.<project-name>.<env>` (outside workspace root, in parent directory)
- `.env.*` patterns in `.gitignore` at root
- `.env_selected` stores chosen path (also gitignored)
- Env is JSON with keys like `app_name`, `server_url`, `analytics_aptabase_app_key`, `crashlytics_sentry_dsn`, etc.
