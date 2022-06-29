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

## Legenda: {.unlisted .unnumbered}
- **MUX 1**: multiplexer con selezione a 1 bit **DPSTART** relativo al file `mux_8.blif`, **ingressi**:
  - **0**: output di **REG 1**, opera sul valore presente nel registro **REG 1**
  - **1**: **PHIN**, inizia dal nuovo valore
\newpage

- **MUX 2**: multiplexer con selezione a 2bit (**ACIDO_ON**, **BASICO_ON**) relativo al file `mux2_8.blif`, **ingressi**:
  - **00**: output costante `00`
  - **01**: costante `04`
  - **10**: costante `f8`
  - **11**: don't care
- **MUX 3**: multiplexer con selezione a 1bit **DPEND** relativo al file `mux_8.blif`, **ingressi**:
  - **0**: costante `00`
  - **1**: output del **MUX 1**
- **REG 1**: registro a 8bit, relativo al file `register_8.blif` 
- **COMP 1**: comparatore a 8bit, ritorna `1` se il valore è **minore o uguale**, relativo al file `comparatorlte_8.blif`
- **COMP 2**: comparatore a 8bit, ritorna `1` se il valore è **maggiore o uguale**, relativo al file `comparatorgte_8.blif`


## Input: {.unlisted .unnumbered}
-   **PHIN[8]**: segnale a 8bit che rappresenta il ph.
-   **DPSTART[1]**: segnale a 1bit che stabilisce l'inizio del conteggio. Funge da selezione al multiplexer tra il valore in uscita dal registro, a quello presente in ingresso **PHIN**.
-   **CLOCK[1]**: segnale di clock.
-   **DPRESET[1]**: segnale di 1bit che resetta (set a 0) in modo asincrono tutti i **latch** del circuito.
-   **ACIDO_ON[1]**: segnale che, assieme a **BASICO_ON** forma un segnale a 2bit di selezione per il **MUX 2**
-   **BASICO_ON[1]**: segnale che, assieme a **ACIDO_ON** forma un segnale a 2bit di selezione per il **MUX 2**

## Output: {.unlisted .unnumbered}
- **DPEND[1]**: segnale a 1bit, di valore 1 quando il ph è **normalizzato**.
- **PHOUT[8]**: valore del ph ottenuto dopo la **normalizzazione**, compreso quindi $7 \leq \text{ph} \leq 8$

## Flusso: {.unlisted .unnumbered}
Il **MUX 1** seleziona il valore del ph da processare tra quello di **PHIN** e l'uscita di **REG 1**.
Il valore viene poi dato in input a 2 **comparatori** di tipo maggiore/minore uguale, le cui uscite a 1bit sono collegate in **and**, e producono il segnale di **DPEND**.
Il **MUX 2** seleziona il valore costante da passare come secondo addendo al sommatore `adder_8.blif`, da sommare al valore di ph in uscita da **MUX 2**. \newline
La selezione a 2 ingressi, che fornisce $2^{2} = 4$ uscite, dipende da **ACIDO_ON** E **BASICO_ON**. Essendo che entrambi, per i vincoli di progetto, non saranno mai a `1`, l'ingresso `11` è **trascurabile**. \newline
Abbiamo quindi 3 casi:

### `ACIDO_ON = 1 e BASICO_ON = 0` {.unlisted .unnumbered}
l'ingresso `10` selezionato del **MUX 2** è la costante relativa alla **valvola acida** `-0.5`.
La costante, negativa, è codificata in **complemento a 2**, il cui valore è `f8`. Così da poter sfruttare il vantaggio della codifica ed effettuare solo somme, senza necessitare anche di un sotrattore.

### `ACIDO_ON = 0 e BASICO_ON = 1` {.unlisted .unnumbered}
l'ingresso `01` selezionato del **MUX 2** è la costante relativa alla **valvola basica** `0.25`.
La costante, è codificata in modulo, il valore è `04`.

### `ACIDO_ON = 0 e BASICO_ON = 0` {.unlisted .unnumbered}
l'ingresso `00` selezionato del **MUX 2** è la costante `00`, elemento neutro dell'addizione, in modo da non cambiare il risultato in caso di ph già **normalizzato**.

Una volta selezionato il secondo addendo, il risultato viene messo nel **REG 1**. Al ciclo di clock successivo sarà presente all'ingresso del **MUX 1**, e verrà quindi selezionato, se il bit di selezione è `0`, in modo da creare il ciclo per le successive somme. \newline
Ogni valore in uscita dal **MUX 1** viene testato dai 2 comparatori, che produrrano il segnale **DPEND**. Quando questo risulterà `1` il **MUX 3** potrà portare in uscita il valore del ph ottenuto. \newline
Per normalizzare un nuovo ph basterà passare nuovamente **PHIN** e il segnale **DPSTART** a `1`, senza necessariamente passare dalla fase di reset.

\newpage

## Contatore 8bit
Il **contatore a 8bit**, `counter_8.blif`, è un semplice contatore in grado di contare fino a $2^{8} - 1 = 255$. L'output viene visualizzato solo quando il segnale di selezione di **MUX_2**, rappresentato da **ENDCOUNT**, è a `1`.

!['Contatore 8bit'](resources/img/counter_8.svg)

## Legenda: {.unlisted .unnumbered}
- **MUX 1**: multiplexer con selezione a 1 bit **START** relativo al file `mux_8.blif`, ingressi:
  - **0**: output di **REG 1**
  - **1**: costante `00`, inizio conteggio
- **MUX 2**: multiplexer con selezione a 1 bit **ENDCOUNT** relativo al file `mux_8.blif`, ingressi:
  - **0**: costante `00`
  - **1**: valore in uscita da **MUX 1**
- **REG 1**: registro a 8bit, relativo al file `register_8.blif`
  
## Input: {.unlisted .unnumbered}
-   **START[1]**: segnale a 1bit che stabilisce l'inizio del conteggio. Funge da selezione al **MUX 1**
-   **CLOCK[1]**: segnale di clock.
-   **RESET[1]**: segnale di 1bit che resetta (set a 0) in modo asincrono tutti i **latch** del circuito.
-   **ENDCOUNT[1]**: segnale a 1bit che selezione l'uscita del **MUX 2**, se a `1` mostra il valore attuale del contatore.

## Output: {.unlisted .unnumbered}
- **OUTCOUNT[8]**: valore memorizzato del contatore, dipende dalla selezione di **MUX 2**

## Flusso: {.unlisted .unnumbered}
Il **MUX 1** seleziona il primo addendo per il sommatore, scegliendo tra l'output del registro (valore attuale del contatore) o la costante `00`, a seconda del segnale di selezione **START**. Se `1` il contatore partirà da 0, se `0` il contatore incrementerà il valore presente nel registro.
Il secondo addendo del sommatore è la costante `01`, lo step richiesto dal progetto.
Il contatore produrrà in output sempre `00` fino a che il segnale di selezione **ENDCOUNT** del **MUX 2** non verrà alzato ad `1`, così da produrre in output il valore in uscita da **MUX 1**.
