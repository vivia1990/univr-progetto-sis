# univr-progetto-sis
Progetto sis "analisi ph" architettura degli elaboratori


## Automazioni:
Nel file `command.sh` sono presenti i seguenti comandi. Per eseguirli è necessario scrivere da terminale unix
```bash
./command.sh {nomeComando}
```

### **copy**
Copia i file `*.blif` dalla directory `non_ottimizzato` alla root del progetto.

### **delete**
Elimina tutti i file `.blif` nella root del progetto. Necessaria conferma.

### **minimize**
Eseguire **dopo** il copy.
Lancia le minimizzazioni logiche presenti nella cartella `scripts/minimize.s` relativamente ai `.blif` nella root del progetto.

### **deploy**
Esegue **copy** e **minimize**

### **relazione**
Costruisce il file `relazione.pdf` dai files markdown presenti in `relazione/`. (vedi documentazione pandoc)

### **test**
Lancia i test presenti nella cartella `tests` e verifica in maniera rudimentale che abbiano avuto successo. Il formato per il parsing **deve** essere come quello nei file **istanze\*.test**

## Dockerfile
Buildare con `docker build . -t {nomeImmagine}`, contiene **sis** e **pandoc** con tutte le dipendenze.
