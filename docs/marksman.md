---
title: Marksman
author: Franco Colussi
contributors: Steve Spencer
tags:
    - neovim
    - editor
    - markdown
---

<!--vale off-->
# Marksman

Marksman è un server linguistico che si integra con il vostro editor per aiutarvi a scrivere e mantenere i vostri documenti Markdown. Utilizzando il protocollo LSP, fornisce il completamento, la navigazione nella cartella di lavoro, la ricerca di riferimenti, il refactoring dei nomi, la diagnostica e altro ancora.

## Installazione

Marksman viene installato automaticamente durante la configurazione iniziale di Rocksmarker. Se non dovesse, per qualche motivo, essere disponibile può sempre essere installato manualmente con il comando:

```txt
:MasonInstall marksman
```

Per verificare la corretta installazione del server linguistico aprire un file markdown (*.md*) nell'editor e digitare il comando `:LspInfo`, si aprirà un buffer flottante contenente le informazioni descritte sotto, in caso sia mancante LspInfo non rileverà nessun client attaccato al buffer.

```txt
 Language client log: /home/ambaradan/.local/state/nvim/lsp.log
 Detected filetype:   markdown
 
 1 client(s) attached to this buffer: 
 
 Client: marksman (id: 1, bufnr: [1, 14])
  filetypes:       markdown, markdown.mdx
  autostart:       true
  root directory:  /home/ambaradan/.config/rocksmarker
  cmd:             /home/ambaradan/.local/share/nvim/mason/bin/marksman server
```
