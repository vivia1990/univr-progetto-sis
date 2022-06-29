---
language: it-IT
---

\newpage

# FSM (final state machine):

Viene riportato il il grafico delle transizioni del controllore.
Il controllore in questione avra' 3 stati:

!["FSM"](resources/img/fsm.png)

- **RESET**: Reset sara' lo stato iniziale della macchina e rimarra in questo stato fino a che non verra' forinto un input con il secondo bit (START) a 1, in ogni altro caso lo stato rimarra' a reset. Inoltre da qualsiasi stato ci si trovi se viene fornito un input con il primo bit (RST) a 1  lo stato tornera' a RESET e tutti gli output verranno azzerati.

- **BASICO ON**: Lo stato di BASICO ON viene raggiunto quando viene dato in input START e un valore di pH acido, quindi  minore di 7 e maggiore di 0. Al cambio di stato da RESET a BASICO ON viene fornito al datapah il segnale DPSTART, lo stato tornera' in RESET una volta ricevuto il segnale DPEND dal datapah che porta il controllore al suo stato iniziale di RESET. Quando la fsm entra in questo stato il quarto bit di output (VALVOLA BASICO) viene attivato e rimane attivo fino al termine delle operazioni del datapath.
 

- **ACIDO ON**: Lo stato di ACIDO ON viene raggiunto quando viene dato in input un pH basico quindi quando il pH dato in input e' maggiore di 9 e minore di 14. Al cambio di stato da quello iniziale viene mandato il segnale DPSTART al datapath per farlo iniziare a lavorare. Quando la fsm entra in questo stato il terzo bit (VALVOLA ACIDO) viene attivato e rimmane attivo fino al termine delle operazioni del datapath
