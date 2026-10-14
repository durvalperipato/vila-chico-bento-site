# Forged Idea: Arquitetura de Autorização & Perfis de Usuário no Firebase

## Decisões (Locks)
- **Estrutura de Perfil Central**: Coleção `/users/{uid}` indexada pelo `request.auth.uid` criptográfico único do Firebase Auth.
  - Campos: `{ email: string, isSuperAdmin: boolean, allowedSites: string[] }`
- **Regra de Segurança do Firestore**:
  - `canEditSite(siteId)` consulta `/users/$(request.auth.uid)`.
  - Autorizado se `isSuperAdmin == true` OU se `siteId in allowedSites`.
- **Governança Centralizada**: Criação e gestão de contas de clientes/operadores realizada exclusivamente pelos SuperAdmins (Durval e esposa) via Firebase Console ou painel de gestão da agência.
- **Experiência do Painel (`painel.nanodevs.com.br`)**:
  - Se `isSuperAdmin`: exibe seletor global com todos os 40+ clientes.
  - Se cliente comum: abre diretamente o editor do único site autorizado (`allowedSites[0]`), sem expor a existência de outros clientes.

## Opções Descartadas (Kills) & Motivos
- `adminEmails` dentro do documento `/sites/{siteId}`: Rejeitado por fragilidade de identidade (string de email mutável em vez de UID) e impossibilidade do app descobrir quais sites o operador pode gerenciar sem queries custosas.
- Self-service de criação de usuários por clientes no frontend: Rejeitado porque `createUserWithEmailAndPassword` no cliente desloga a sessão ativa e exigiria Cloud Functions desnecessárias para gerenciar RBAC de pequenas empresas.
- Custom Claims obrigatório no MVP: Rejeitado para evitar dependência de backend/Cloud Functions em Node.js neste estágio.
