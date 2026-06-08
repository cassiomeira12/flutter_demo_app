---
description: Gere uma mensagem de commit baseada nos arquivos staged
agent: build
---

Gere uma mensagem de commit seguindo o padrão do projeto.

## Passos

1. Obtenha a branch atual: `git symbolic-ref --short HEAD`
2. Extraia o suffixo (último segmento após `/`): `developments/master` → `master`, `feature/auth` → `auth`
3. Verifique os arquivos staged: `git diff --cached --name-status`
4. Se não houver arquivos staged, avise o usuário e pare
5. Analise as mudanças para determinar o tipo (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`)
6. Gere a mensagem no formato: `[<suffix>] <type>: <descrição curta e clara>`

## Regras de tipo

| Tipo       | Quando usar                                  |
| ---------- | -------------------------------------------- |
| `feat`     | Nova funcionalidade, novo arquivo de feature |
| `fix`      | Correção de bug                              |
| `docs`     | Apenas documentação                          |
| `style`    | Formatação, sem mudança de lógica            |
| `refactor` | Refatoração sem feature/fix                  |
| `test`     | Adição ou atualização de testes              |
| `chore`    | Build, CI, tooling, dependências             |
| `perf`     | Melhoria de performance                      |
| `ci`       | Configuração de CI/CD                        |

## Formato da mensagem

```
[<suffix>] <type>: <descrição>
```

- Descrição em inglês, início com letra minúscula
- Máximo 72 caracteres na primeira linha
- Sem ponto final

## Exemplos

```
[master] feat: add player strength rating field
[firebase] fix: resolve crash on app startup
[auth] docs: update login screen README
[profile] chore: bump AGP to 8.7.2
```

## Saída

Apresente a mensagem gerada ao usuário com um botão de copiar.
