# Entity Template

Propósito
- Descrever entidades do domínio, seus campos, serialização e regras de validação.

Conteúdo Sugerido
- Nome da entidade
- Descrição resumida
- Campos
  - nome: tipo, obrigatório, validações, relacionamentos
- Herança/Interfaces
  - estende BaseEntity? ParserToJson?
- Serialização
  - fromMap(Map<String, dynamic> map)
  - toMap()
- Validações de regras de negócio
- Regras de persistência (se houver)
- Casos de uso típicos
- Testes sugeridos
- Exemplo de código (snippet)
