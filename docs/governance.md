# Governança de Documentação

Objetivo
- Garantir qualidade, consistência e atualização contínua da documentação do OpenCode.

Papéis e Responsáveis
- Arquiteto de Software: arquitetura e padrões de alto nível.
- Owner de Domínio: entidades, modelos e use cases do domínio.
- Engenheiro de Dados/Infra: repositórios, fontes de dados e integrações.
- Designer de Sistema: design system e componentes de UI.
- Revisor de Docs: responsável pela qualidade de cada área.

Processo de Atualização
- Qualquer mudança de arquitetura, contratos entre pacotes ou API deve vir acompanhada de atualização de docs relevante.
- PRs de docs seguem o fluxo normal de revisão com pelo menos 1 aprovado da área afetada.
- Cadência de revisão sugerida: trimestral para arquitetura; semestral para glossário.

Cadência de Publicação
- Releases grandes: atualização de overview, glossary e architecture-diagrams.
- Após mudança relevante de API/contratos: atualizar docs de API.

Governança de Conteúdo
- Owners de área mantêm a visão geral atualizada.
- Novos termos entram no glossary.md com definição clara.
- Diagramas (Mermaid/PlantUML) incluídos quando ajudam a entender dependências.

Qualidade esperada
- Cada novo módulo ou contrato introduz pelo menos uma página de docs associada.
- Checklists de PR de docs: propósito, público-alvo, referências, exemplos de código, e diagramas quando aplicável.
