---
language: it-IT
---

\newpage

# Minimizzazione logica
La minimizzazione logica è stata effettuata con gli strumenti di sintesi di sis. Tutte le operazioni di minimizzazione sono disponibili nella cartella `scripts/minimize` e vengono lanciate **in ordine** dal file `minimize.s`. L'ordine è fondamentale in quanto alcuni componenti dipendono da altri, ed è quindi necessario minimizzare prima le dipendenze.\newline
La minimizzazione andava fatta per **area**, ossia diminuendo il numero di letterali. Con alcuni componenti la `script.rugged` dava una soluzione buona, con altri è stato necessario trovare una sequenza "ottimale" di comandi per l'ottimizzazione. In alcuni casi abbiamo ottenuto anche un notevole miglioramento del **ritardo**, ossia il numero di nodi. \newline
Di seguito le statistiche per la **fsm** e il **datapath**.

## Fsm
Statistiche ottenute dopo aver lanciato l'assegnazione degli stati, `state_assign jedi`, **non minimizzate**.
```js
sis> rl controller.blif
sis> psf
controller    	pi=11	po= 5	nodes=  7	latches= 2
lits(sop)= 324	states(STG)=   3
```

Come si può notare i **letterali** sono `324`, mentre i nodi della rete sono `7`. \newline

Statistiche ottenute dopo aver lanciato l'assegnazione degli stati, `state_assign jedi`, e lo script di ottimizzazione `scripts/minimize/controller.min`
```js
sis> rl controller.blif
sis> psf
controller    	pi=11	po= 5	nodes= 12	latches= 2
lits(sop)=  46	#states(STG)=   3
```

Dopo l'ottimizzazione i **letterali** sono `46`, circa l'`85%` in meno, mentre i nodi della rete sono quasi raddoppiati a `12`. Ci interessa l'ottimizzazione per area quindi il risultato è buono.

## Datapath
Essendo il datapath separato in 2 circuiti, li analizzo a parte.

## Normalizzatore {.unlisted .unnumbered}
Statistiche ottenute dal circuito **non minimizzato**.
```js
sis> rl normalizer.blif
sis> psf
normalizer    	pi=12	po= 9	nodes= 77	latches= 8
lits(sop)= 458
```

I **letterali** sono `458`, mentre i nodi della rete sono `77`. \newline

Risultato dopo lo script `scripts/minimize/normalizer.min`, e sottocomponenti `adder_8.min` e `mux_8.min`
```js
sis> rl normalizer.blif
sis> psf
normalizer    	pi=12	po= 9	nodes= 36	latches= 8
lits(sop)= 128
```
Il miglioramento qui è stato notevole sia per i letterali che per i nodi.

## Contatore 8bit {.unlisted .unnumbered}
Statistiche ottenute dal circuito **non minimizzato**.
```js
sis> rl counter_8.blif
sis> psf
counter_8     	pi= 3	po= 8	nodes= 50	latches= 8
lits(sop)= 192
```

I **letterali** sono `192`, mentre i nodi della rete sono `50`. \newline

Risultato dopo lo script `scripts/minimize/counter_8.min`, e sottocomponenti `adder_8.min` e `mux_8.min`
```js
sis> rl counter_8.blif
sis> psf
counter_8     	pi= 3	po= 8	nodes= 22	latches= 8
lits(sop)=  70
```
Il miglioramento qui è stato buono sia per i letterali che per i nodi.

## FSMD
Le statistiche **complessive** del circuito non minimizzato sono:
```js
sis> rl fsmd.blif
sis> psf
fsmd            pi=10	po=20	nodes=134	latches=18
lits(sop)= 974
```

Dopo la minimizzazione di ogni componente e anche di `fsmd.blif`, presente nel file `scripts/minimize/fsmd.min`, abbiamo:
```js
sis> rl fsmd.blif
sis> psf
fsmd          	pi=10	po=20	nodes= 68	latches=18
lits(sop)= 231
```

Un miglioramento di circa il `76%` per quanto riguardo l'**area**, e del `49%` circa per quanto riguarda il **ritardo** .