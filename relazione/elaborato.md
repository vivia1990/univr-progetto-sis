---
title: Analisi pH
author: Michele Viviani, Pietro Decarli
language: it-IT
---

\newpage

# Presentazione
Viene richiesto di progettare un circuito sequenziale che controlli un macchinario chimico il cui scopo è di portare il pH di una certa soluzione ad essere neutro. Per modificare il pH il macchinario ha a disposizione
due valvole che controllano l'erogazione di una soluzione basica e una acida. Quando verrà data in ingresso una soluzione **acida** il macchinario aprirà la valvola che gestisce la soluzione basica, finchè la soluzione finale non sarà neutra. Quando verrà data in ingresso una soluzione **basica** il macchinario aprirà, invece, la valvola che gestisce la soluzione acida. Le valvole di erogazione hanno efficacia diversa, la valvola della soluzione basica permette di **alzare** il pH di `0.25` per ogni ciclo di clock, mentre la valvola della soluzione acida permette di **abbassarne** il livello di `0.5` per ciclo di clock.
Il macchinario tiene anche conto del numero di cicli necessari alla **normalizzazione**.

## Assunti e vincoli di progetto
Nella creazione del circuito abbiamo optato per i seguenti vincoli:

### Ph: {.unlisted .unnumbered}
Il pH è un numero **razionale** compreso tra $0 \leq\text{pH}\leq 14$, si considera **normale/normalizzato** quando il suo valore è  tra $7 \leq \text{pH} \leq 8$. Un pH $8 < \text{pH} \leq 14$ è considerato **basico**, Un $0 \leq \text{pH} < 7$ è considerato **acido**. \newline
Viene rappresentanto in base 2 con la codifica **modulo** e **virgola fissa**, si impongono 4bit per la parte intera e 4bit per la parte decimale.
Se $\text{pH} > 14$ il pH non è considerato valido.

### Datapath: {.unlisted .unnumbered}
Durante l'elaborazione di un valore, prima del **FINE OPERAZIONE**, non è possibile inserire un nuovo pH se non dopo aver lanciato un **RESET**. \newline
Dopo il primo inserimento si suppongono tutti gli input a `0`, o comunque **don't care**, ad esclusione del bit di **START** e **RESET**. \newline
Esempio funzionamento:
```bash
# inizio conteggio
sim 0 1 1 0 1 0 0 0 0 0
out -> 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# valori da passare
sim 0 0 0 0 0 0 0 0 0 0
out -> 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

# .... non posso lanciare analisi senza aver dato reset

sim 0 0 0 0 0 0 0 0 0 0
out -> 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0

# posso iniziare una nuova analisi, senza lanciare reset

```

### Valori e costanti: {.unlisted .unnumbered}
Tutti i valori numerici e le costanti sono da considerarsi espressi in **base 2**. I valori negativi utilizzando la codifica in **complemento a 2**. \newline
In alcune parti di questo documento i valori sono scritti, per semplicità, in **esadecimale**. Ad esempio il numero `f8` corrisponde al valore binario `11111000`, usando il complemento a 2 otteniamo `-0.5`.

