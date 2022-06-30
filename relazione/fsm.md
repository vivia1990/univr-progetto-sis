---
language: it-IT
---

\newpage

# FSM (final state machine):

Viene riportato il il grafico delle transizioni del controllore, realizzato con una **fsm** di Mealy con `11` bit di **input**, `5` bit di **output** e `3` stati, elencati qui di seguito. È rappresentata dal file `controller.blif`. \newline 
`controller_base.blif` è la stessa fsm ma senza i latch assegnati agli stati.

!["FSM"](resources/img/fsm.png)

## Stati {.unlisted .unnumbered}

- **RESET**: stato iniziale della macchina, che rimarrà in questo stato fino a che non verrà fornito un input con il secondo bit (**START**) uguale a `1`, in ogni altro caso lo stato rimarrà a **RESET**. Inoltre da qualsiasi stato ci si trovi, se viene fornito un input con il primo bit (**RST**) a `1`,  lo stato tornerà a **RESET** e tutti gli output verranno azzerati. In caso di ph non valido, lo stato non varia e viene alzato a `1` il bit di **ERRORE_SENSORE**. A fine di ogni operazione la fsm ritorna su questo stato.

- **BASICO ON**: stato raggiunto quando viene dato in input **START** e un valore di pH **acido**. Al cambio di stato, partendo da **RESET**, viene inviato al datapah il segnale **DPSTART**; lo stato tornerà in **RESET** una volta ricevuto il segnale **DPEND** dal datapah. Quando la fsm entra in questo stato il quarto bit di output (**VALVOLA BASICO**) viene alzato ad `1` e rimane attivo fino al termine delle operazioni del datapath.
 
- **ACIDO ON**: stato raggiunto quando viene dato in input un pH **basico**. Al cambio di stato, partendo da **RESET**, viene mandato il segnale **DPSTART** al datapath; lo stato tornerà in **RESET** una volta ricevuto il segnale **DPEND**. Quando la fsm entra in questo stato il terzo bit (**VALVOLA ACIDO**) viene alzato ad `1` e rimmane attivo fino al termine delle operazioni del datapath.