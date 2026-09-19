# Forged Idea: Vila Chico Bento (Landing Page)

## Decisões Fechadas (Locks)
- **Tipo de Produto**: Landing page única (One-Page) responsiva, Mobile-First.
- **Tecnologia & Arquitetura**: Flutter Web + `nano_core: ^1.0.7`, espelhando a estrutura do `nano-devs-website` (`core/theme`, `core/constants`, `core/widgets`, `modules/home`).
- **Hospedagem**: Firebase Hosting (`.web.app` inicial -> domínio próprio futuro).
- **Conversão Principal**: Botões de CTA direcionando direto para WhatsApp `(41) 99252-3108` com mensagem pré-preenchida para agendamento de adaptação/visita.
- **Seções da Página**:
  1. Hero com Logo oficial e CTA WhatsApp
  2. Sobre Nós & Diferenciais (espaço acolhedor, segurança, equipe)
  3. Serviços: Day Care Pet, Hospedagem (Hotelzinho), Enriquecimento Ambiental (EA) e Período de Adaptação
  4. Galeria de Fotos: Espaço e rotina dos cães (assets locais)
  5. Localização & Horários: R. Clóvis Beviláqua, 579 - Vargem Grande, Pinhais - PR (com rota Google Maps e Waze)
  6. Contato & Rodapé: Instagram `@vilachicobento` e botão flutuante de WhatsApp
- **Constantes Centralizadas**: Todos os dados em `AppConstants` para fácil manutenção e zero hardcode.

## Opções Rejeitadas (Killed)
- **Painel Admin / CMS Estilo WordPress**: Descartado do MVP. Evita necessidade de autenticação, Firestore/Storage de backend e complexidade de formulários, reduzindo o custo e tempo de entrega a zero de infraestrutura dinâmica.
- **Múltiplas Páginas / Roteamento Complexo**: Rejeitado em prol de rolagem contínua fluida e simples.
