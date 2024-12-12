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

Il messaggio, come si può vedere, dice che nel buffer è stato rilevato un file di tipo markdown e che c'è un client attaccato (marksman).
Sono descritte le caratteristiche dei tipi di file supportati e che il server viene avviato automaticamente al rilevamento di quei tipi di file, segue poi l'indicazione della directory di lavoro e il comando utilizzato per il supporto linguistico.  
La direttiva `root directory` è molto importante in quanto indica la cartella che marksman usa per la diagnostica, la scrittura assistita di collegamenti e le altre funzionalità fornite dal server.

Questo implica che un file contenuto all'interno della cartella di lavoro, in questo caso la cartella rocksmarker, se aperto dalla cartella stessa viene controllato e supportato da marksman a livello di progetto:

```bash
cd .config/rocksmarker
nvim your_file.md
```

Mentre se aperto da una posizione fuori dalla root directory viene trattato da marksman al livello di file con la mancanza delle funzionalità proprie del progetto (come anteprima e gestione dei collegamenti, ricerca delle referenze e altre funzionalità):

```bash
nvim ~/.config/rocksmarker/your_file.md
 ```

La corretta implementazione del server linguistico è verificabile inoltre nella barra di stato dove viene visualizzato, se attaccato, il nome del server corrispondente.

## Funzionalità di Marksman

### Auto completamento

Il server linguistico supporta, nella scrittura assistita, l'auto completamento dei collegamenti. Durante la digitazione di un collegamento dopo aver inserito nella parentesi quadre il testo del collegamento alla digitazione delle due parentesi tonde si aprirà un popup contenente i nomi dei file presenti in quella area di lavoro che se selezionati forniranno un'ulteriore informazione sul titolo del file.  
Selezionando il file voluto con il tasto ENTER questo verrà automaticamente inserito nelle parentesi tonde.

<!--schermata link assistito-->

### Navigazione del buffer

Marksman fornisce alcune utili scorciatoie per la navigazione del buffer markdown, con la combinazione dei caratteri `[[` e `]]` si naviga avanti e indietro nei header del documento velocizzando in questo modo il posizionamento e la ricerca della sezione desiderata.
Utilizzando invece la funzionalità go to `<leader>gd`, comune a tutti i server linguistici si può navigare i collegamenti interni al progetto.  
Se il collegamento è interno al file, come nel caso di un TOC (Tabella dei contenuti), posizionandosi sul collegamento e richiamando la chiave da tastiera si viene automaticamente posizionati nella sezione corrispondente se invece il collegamento è esterno al file questo viene aperto in un nuovo buffer.
