# Forged Idea: Repositório Central `nano-cms` no Ecossistema NanoDevs

## Decisões (Locks)
- **Criação de Repositório Dedicado**: O CMS da NanoDevs terá seu próprio repositório oficial na organização (`nano-cms`), integrando o ecossistema ao lado de `nano-core`, `nano-agents`, etc.
- **Papel do `nano-cms`**:
  - Aplicação Flutter Web servida exclusivamente em `painel.nanodevs.com.br`.
  - Contém o motor Schema-Driven, gerador dinâmico de formulários, live preview split-screen, autenticação e gestão de múltiplos tenants.
  - Ponto único de evolução e deploy para atender todos os clientes da agência.
- **Desacoplamento das Landing Pages dos Clientes**:
  - Repositórios como `vila-chico-bento-site` abrigam estritamente o código da landing page pública.
  - Consomem o Firestore público em modo somente-leitura.
  - Zero código de admin, zero dependência de Auth, máxima performance e proteção de propriedade intelectual.

## Opções Descartadas (Kills) & Motivos
- Manter o Admin embutido no repositório de cada cliente: Rejeitado por duplicar código em cada novo contrato, vazar segredo industrial para clientes e exigir 40 deploys manuais a cada atualização de tela.
- Admin como package (`nano_admin`) embutido no bundle do site: Rejeitado por inflar desnecessariamente o bundle web das landing pages com dependências de edição que os visitantes nunca utilizam.
