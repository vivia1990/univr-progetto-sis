---
title: Analisi PH
author: Michele Viviani, Pietro Decarli
language: it-IT
---

\newpage

# Datapath
Il **datapath** è responsabile dell'esecuzione di tutte le operazioni necessarie alla normalizzazione del ph ricevuto in input e del conteggio. Abbiamo deciso di scomporlo in **2 macrocircuiti**, uno relativo alla normalizzazione `normalizer.blif` e uno relativo al contatore ad 8bit `counter_8.blif`.
L'unico segnale che i 2 si scambiano è **DPEND**, dal normalizzatore al contatore.

## Normalizzatore

Il **normalizzatore** si occupa di normalizzare il ph, ossia portarlo da un valore compreso tra $0 \leq \text{ph} \leq 14$ ad un valore compreso tra $7 \leq \text{ph} \leq 8$). Una volta terminata la normalizzazione, il segnale **DPEND** si alzerà da 0 a 1, certificando la **fine operazione**.

!['Normalizzatore ph'](resources/img/normph.svg)

### Legenda:
- **MUX 1**: multiplexer con selezione a 1 bit **DPSTART**, ingressi:
  - **0**: output di **REG 1**
  - **1**: **PHIN**
\newline

- **MUX 2**: multiplexer con selezione a 2bit (**ACIDO_ON BASICO_ON**), ingressi:
  - **00**: output costante `00`
  - **01**: costante `04`
  - **10**: costante `f8`
  - **11**: don't care
\newline
\newline

- **MUX 3**: multiplexer con selezione a 1bit **DPEND** ingressi:
  - **0**: costante `00`
  - **1**: output del **MUX 1** 

### Input:
-   **PHIN[8]**: segnale a 8bit che rappresenta il ph.
-   **DPSTART[1]**: segnale a 1bit che stabilisce l'inizio del conteggio. Funge da selezione al multiplexer tra il valore in uscita dal registro, a quello presente in ingresso **PHIN**.
-   **CLOCK[1]**: segnale di clock.
-   **DPRESET[1]**: segnale di 1bit che resetta (set a 0) in modo asincrono tutti i **latch** del circuito.
-   **ACIDO_ON[1]**: segnale che, assieme a **BASICO_ON** forma un segnale a 2bit di selezione per il multiplexer
-   **BASICO_ON[1]**: segnale formato
Una volta normalizzato (ridotto ad una soglia compresa tra $7 \leq \text{ph} \leq 8$)
il datapath manderà in output un segnale **DPEND**.


## Contatore 8bit
!['Contatore 8bit'](resources/img/counter_8.svg)