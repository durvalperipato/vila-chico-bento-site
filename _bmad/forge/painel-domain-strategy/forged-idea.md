# Forged Idea: Estratégia de Domínio e Hub do Cliente (`painel.nanodevs.com.br`)

## Decisões (Locks)
- **URL Central**: `painel.nanodevs.com.br` no Firebase Hosting com DNS apontado 1 única vez no Registro.br.
- **Conceito**: Portal do Cliente unificado da NanoDevs. O cliente entra para gerenciar o site dele ou qualquer outro serviço contratado.
- **Estrutura Modular**: Navegação por menu lateral baseada em permissões/serviços contratados por cliente (ex: `sites`, `leads`, `relatórios`).
- **Isolamento de SaaS Independente**: Produtos SaaS de mercado aberto (ex: carteirinha veterinária) terão marcas e domínios próprios dedicados (ex: `app.petpass.com.br`).

## Opções Descartadas (Kills) & Motivos
- `admin.{cliente}.com.br`: Rejeitado pelo alto atrito operacional (DNS e SSL repetidos a cada novo cliente) e risco de manutenção.
- `cms.nanodevs.com.br`: Rejeitado por ser jargão técnico confuso para clientes leigos no suporte/WhatsApp.
- `meusite.nanodevs.com.br`: Rejeitado por amarrar a URL exclusivamente a sites, impedindo a oferta de outros serviços no mesmo painel.
- `painel.nanodevs.com.br` para SaaS B2B massivo: Rejeitado para evitar acoplamento de código e desgaste de branding entre agência e produto.
