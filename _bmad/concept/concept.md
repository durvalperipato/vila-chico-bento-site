# 🚀 Nano CMS — Conceito, Arquitetura & Visão SaaS

> **Documento Estratégico de Conceito e Arquitetura Central**  
> **Repositório Piloto:** `vila-chico-bento-site`  
> **Projeto Firebase Central:** `nano-devs-cms`  
> **Plataforma da Agência:** `nanodevs.com.br`

---

## 1. 🎯 Visão Geral & Modelo de Negócio

O **Nano CMS** é uma plataforma proprietária desenvolvida com o ecossistema **`nano_core` + Flutter Web + Firebase**, criada para viabilizar a venda escalável de **Landing Pages de Alta Conversão** para pequenas e médias empresas (clínicas, creches/hotéis pet, escritórios, comércios locais).

### O Diferencial de Venda (A Proposta de Valor)
Ao vender uma landing page para um cliente, você não entrega apenas um código estático:
1. **Autonomia do Cliente**: O próprio cliente ganha acesso a um painel simples e elegante onde altera textos, telefones, links de redes sociais, galeria de fotos e banners.
2. **Zero Dependência Técnica**: O cliente não precisa abrir chamados para mudar uma vírgula ou trocar uma foto no site. Ele salva como rascunho, vê o **Live Preview em tempo real** e clica em **Publicar**.
3. **Receita Recorrente (MRR)**: O cliente paga uma mensalidade de hospedagem, segurança SSL e acesso ao painel do Nano CMS. Se ele atrasar ou cancelar, o acesso dele ao painel pode ser pausado em um clique.

---

## 2. 🏗️ Arquitetura Multi-Tenant em 1 Único Projeto Firebase

Um ponto crucial da arquitetura: **NÃO é necessário criar um projeto Firebase para cada cliente**.  
Tudo funciona centralizado no projeto **`nano-devs-cms`**, economizando custos, simplificando manutenção e centralizando a gestão.

```text
┌────────────────────────────────────────────────────────────────────────┐
│               PROJETO FIREBASE CENTRAL: "nano-devs-cms"                │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  🔐 Firebase Authentication                                            │
│     ├── durval@nanodevs.com.br (Super Admin - Acesso a todos os sites) │
│     ├── cliente@vilachicobento.com.br (Operador da Vila Chico Bento)   │
│     └── cliente@clinicasorriso.com.br (Operador da Clínica Sorriso)    │
│                                                                        │
│  🗄️ Cloud Firestore (Dados Multi-Tenant & Perfis)                     │
│     ├── users/ {collection}                                            │
│     │   ├── {uid_durval}/ {doc} -> { isSuperAdmin: true }              │
│     │   ├── {uid_esposa}/ {doc} -> { isSuperAdmin: true }              │
│     │   └── {uid_cliente}/ {doc} -> { allowedSites: ['vila-chico...'] }│
│     └── sites/ {collection}                                            │
│         ├── vila-chico-bento/ {doc} (Produção)                         │
│         │   └── drafts/current/ {doc} (Rascunho em edição)             │
│         ├── clinica-sorriso/ {doc} (Produção)                          │
│         │   └── drafts/current/ {doc} (Rascunho em edição)             │
│         └── [novo-cliente]/ ...                                        │
│                                                                        │
│  📁 Firebase Storage (Mídias Isoladas)                                 │
│     └── sites/                                                         │
│         ├── vila-chico-bento/                                          │
│         │   ├── hero/                                                  │
│         │   └── gallery/                                               │
│         └── clinica-sorriso/                                           │
│             └── gallery/                                               │
│                                                                        │
│  🌐 Firebase Hosting (Multi-Site Hosting nativo)                       │
│     ├── [Site: nano-cms]            ➔ painel.nanodevs.com.br           │
│     ├── [Site: vila-chico-bento]    ➔ vilachicobento.com.br            │
│     ├── [Site: clinica-sorriso]     ➔ clinicasorriso.com.br            │
│     └── [Site: proximo-cliente]     ➔ proximo.com.br                   │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 🌐 Como Funciona o Firebase Multi-Site Hosting & Domínios Próprios

O Firebase Hosting permite **até 36 sites distintos dentro do mesmo projeto**, sem custo adicional de infraestrutura básica.

### A. O Painel Central (SaaS da NanoDevs)
* **Domínio**: Subdomínio criado gratuitamente no Registro.br a partir do seu domínio principal:
  * `painel.nanodevs.com.br` (Portal do Cliente da NanoDevs).
* **Função**: Aplicação Flutter Web onde você e seus clientes fazem login.
  * O Super Admin vê e gerencia todos os clientes.
  * O cliente comum só vê o editor do `siteId` dele.

### B. As Landing Pages dos Clientes
* **Domínio do Cliente**: Cada cliente compra o seu próprio domínio no **Registro.br** (ex: `vilachicobento.com.br`, `clinicasorriso.com.br`).
* **Configuração no Firebase**:
  1. No console do `nano-devs-cms` ➔ Hosting, clica em **"Adicionar outro site"** com o ID do cliente.
  2. Clica em **"Adicionar domínio personalizado"** e digita `vilachicobento.com.br`.
  3. O Firebase gera 2 IPs do Google (registro tipo `A`).
  4. Esses IPs são adicionados no painel DNS do Registro.br do cliente.
  5. O Google emite o **certificado SSL (HTTPS com cadeado verde) automaticamente e de graça**.

### C. Deploy Independente de Cada Site
Quando você atualizar o código da landing page de um cliente específico:
```bash
# Faz deploy APENAS da landing page da Vila Chico Bento:
firebase deploy --only hosting:vila-chico-bento

# Faz deploy APENAS do painel administrativo central:
firebase deploy --only hosting:nano-cms
```

---

## 4. 🧩 O Motor Schema-Driven (Coração do Nano CMS)

O grande segredo que permite reutilizar o mesmo motor para centenas de sites sem reescrever telas é o conceito **Schema-Driven**:

### O que é um Schema?
É a definição declarativa dos campos editáveis de um site:
* **`AdminSectionGroup`**: Grupos de seções (ex: Hero/Topo, Sobre Nós, Serviços, Galeria, Contato).
* **`AdminField.text`**: Campos de texto curto ou longo com validação de limite de caracteres.
* **`AdminField.image`**: Upload de imagem única (ex: banner) com limite de tamanho (ex: máx 3MB).
* **`AdminField.gallery`**: Upload múltiplo de fotos com reordenação e exclusão.

### Exemplo Real Implementado:
Localizado em [`lib/modules/admin/domain/vila_chico_bento_schema.dart`](file:///Users/durvalperipatoneto/Frella/vila-chico-bento-site/lib/modules/admin/domain/vila_chico_bento_schema.dart).

```dart
// Se amanhã você criar a Clínica Sorriso, basta definir o schema correspondente:
static final SiteSchema clinicaSchema = SiteSchema(
  siteId: 'clinica-sorriso',
  sections: [
    AdminSectionGroup(
      id: 'hero',
      title: 'Apresentação da Clínica',
      fields: [
        AdminField.text(key: 'hero.title', label: 'Título', maxLength: 80, required: true),
        AdminField.text(key: 'hero.subtitle', label: 'Subtítulo', maxLength: 160),
        AdminField.image(key: 'hero.banner', label: 'Foto da Fachada'),
      ],
    ),
    // ...demais seções
  ],
);
```

O gerador dinâmico de formulários lê essa lista e desenha todos os inputs, contadores de caracteres e seletores de arquivos automaticamente!

---

## 5. ⚡ Resiliência e Offline Fallback (Zero Downtime)

Uma regra inegociável da arquitetura é: **a landing page do cliente NUNCA pode quebrar ou ficar em branco**.

* Se o cliente estiver sem internet;
* Se o Firebase estiver com instabilidade momentânea;
* Ou se o cliente acabou de ser criado e o Firestore ainda estiver vazio;

O repositório [`FirestoreSiteContentRepository`](file:///Users/durvalperipatoneto/Frella/vila-chico-bento-site/lib/modules/admin/infrastructure/repositories/firestore_site_content_repository.dart) intercepta qualquer erro e ativa automaticamente os valores locais padrões de fallback ([`VilaChicoBentoDefaultContent`](file:///Users/durvalperipatoneto/Frella/vila-chico-bento-site/lib/modules/admin/domain/vila_chico_bento_default_content.dart)).

---

## 6. 🖥️ Split-Screen Live Preview & Fluxo de Publicação

```text
┌─────────────────────────────────┬─────────────────────────────────┐
│     PAINEL DE EDIÇÃO (ESQ)      │    LIVE PREVIEW EM TEMPO REAL   │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                 │
│  [Hero: Título Principal]       │    🐾 O Paraíso do Seu Cão      │
│  > O Paraíso do Seu Cão         │                                 │
│                                 │    [Banner atualizado ao vivo]  │
│  [Subtítulo]                    │                                 │
│  > Cuidado e amor em Pinhais... │    [Botão WhatsApp]             │
│                                 │                                 │
│  [Fotos da Galeria] [Upload]    │    [Carrossel de Fotos]         │
│                                 │                                 │
├─────────────────────────────────┴─────────────────────────────────┤
│  [💾 Salvar Rascunho (Draft)]         [🚀 Publicar Alterações]    │
└───────────────────────────────────────────────────────────────────┘
```

1. **Rascunho (`Draft`)**: Enquanto o cliente digita ou testa fotos, as alterações ficam salvas em `sites/{siteId}/drafts/current`. O público no site **não vê** o rascunho incompleto.
2. **Preview**: A metade direita da tela escuta o rascunho e reflete as mudanças com animação suave e em tempo real.
3. **Publicação**: Ao clicar em **"Publicar"**, os dados do rascunho são copiados para `sites/{siteId}`. O site oficial em produção atualiza instantaneamente para todos os visitantes.

---

## 7. 📋 Checklist para Adicionar um Novo Cliente no Futuro

Quando você fechar um novo contrato de landing page:

1. **No Firebase (`nano-devs-cms`)**:
   - Criar o site no Hosting: `firebase target:apply hosting <nome-do-cliente> <id-do-site>`
   - Adicionar o domínio `.com.br` do cliente e colar os IPs no Registro.br dele.
   - Criar o usuário e senha do cliente no Firebase Auth.
2. **No Projeto da Landing Page**:
   - Definir o `siteId` correspondente.
   - Fornecer os textos padrões de fallback no código.
   - Executar: `firebase deploy --only hosting:<id-do-site>`.
3. **No Nano CMS (Painel Central)**:
   - Cadastrar o Schema daquele template ou associar o cliente ao template existente.
   - Passar o link de acesso (`painel.nanodevs.com.br`) e credenciais para o cliente.
