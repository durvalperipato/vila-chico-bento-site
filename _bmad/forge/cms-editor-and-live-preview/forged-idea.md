# Forged Idea: CMS Admin & Live Preview da Vila Chico Bento

## Decisões (Locks)
- **Fonte Canônica Única**: O `ContentBundle` em português salvo no Firebase é a única fonte da verdade para o site e o painel.
- **Remoção de Fallback Silencioso**: Eliminar qualquer fallback de tradução (`?? l10n.`) que mascare campos vazios ou ressuscite textos antigos.
- **Placeholders Visuais no Live Preview**: Campos apagados no formulário renderizam imediatamente `[ Nome do Campo ]` (em itálico e tom atenuado) no preview, mantendo a altura e o layout vivos sem colapsar a tela.
- **Campos Obrigatórios & Bloqueio ao Publicar (Opção A)**: Todos os campos essenciais têm `required: true`. O botão "Publicar" bloqueia com aviso caso haja campos obrigatórios vazios.
- **Rascunho Persistente & Reset (Reverter para Publicado)**: O painel salva rascunhos livremente e recarrega de onde parou. Um botão de "Descartar Alterações" com confirmação permite limpar o rascunho e recarregar a versão atualmente publicada no ar.
- **Componentes de Lista com `minItems` e `maxItems`**:
  - `serviços`: `min: 2`, `max: 6`. No desktop, mantém altura única constante (se tiver mais de 3 cards, usa navegação horizontal para nunca estourar a tela).
  - `destaques hero`: `min: 2`, `max: 4`.
  - `pilares sobre`: `min: 2`, `max: 4`.
  - `galeria`: `min: 3`, `max: 10` fotos.
- **Textos Pequenos Editáveis**: Hero (botão secundário e chips), Sobre (pilares e descrições) e Serviços (badges e botões de ação). As patinhas e ícones permanecem 100% nativos e fixos.
- **Performance de Digitação (120 FPS)**: Debounce de 150-200ms na atualização do Live Preview e isolamento de pintura com `RepaintBoundary` para eliminar travamentos e lentidão ao digitar.

## Opções Descartadas (Kills) & Motivos
- `Fallback para l10n`: Rejeitado por mascarar campos em branco e dar a falsa impressão de que o texto não foi apagado.
- `Duplicação de seções no Live Preview`: Rejeitado pelo alto custo de manutenção e inconsistência visual; o preview agora renderiza os componentes reais do site.
- `Quebrar cards de serviço em 2x2 no desktop`: Rejeitado por dobrar a altura vertical da seção e quebrar a regra de caber no viewport da tela.
- `Fallback silencioso ao publicar com campos vazios`: Rejeitado para impedir que o site oficial entre no ar com buracos de layout ou dados esquecidos.
