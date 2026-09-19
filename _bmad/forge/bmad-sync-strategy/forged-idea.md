# Forged Idea: Estratégia de Versionamento e Sincronização do BMAd

## Locked Decisions (Decisões Fechadas)
- **Versionamento no Próprio Repositório (In-Repo)**: A pasta `_bmad/` faz parte da documentação viva e do estado de engenharia do projeto. Deve ser commitada e versionada junto com o código-fonte.
- **Remoção do `.gitignore`**: Remover a regra `_bmad/` do `.gitignore` dos projetos para que specs, épicos, sprint-status e relatórios de forge fiquem salvos no histórico do Git.
- **Portabilidade Total**: Ao trocar de máquina ou viajar, basta um único `git clone` ou `git pull` para restaurar o código e todo o cérebro/contexto do BMAd simultaneamente.
- **Atomicidade de Branches e Commits**:
  - Mudanças de histórias no `sprint-status.yaml` são commitadas junto com as alterações de código correspondentes.
  - Branches (`feat/...`, `fix/...`) carregam suas próprias especificações e estados de sprint isolados.
- **Política de Visibilidade**: Repositórios de projetos com BMAd devem ser mantidos como privados no GitHub (ou públicos sem expor credenciais, já que credenciais residem no `.env`).

## Rejected Options (Killed)
- **Repositório Central Externo de BMad (`nome-do-projeto/_bmad`)**:
  - *Causa da Morte*: Dessincronização atômica inevitável, quebra do fluxo de branches do Git, necessidade de gerenciar múltiplos repositórios/commits a cada tarefa e alta fricção operacional ao trocar de máquina.
