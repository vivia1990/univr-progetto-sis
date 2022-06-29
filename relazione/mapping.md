---
language: it-IT
---

\newpage

# Mapping tecnologico
Il **mapping tencologico** è stato eseguito con la libreria fornita da sis `synch.genlib`, mediante il comando `map -m 0` per ridurre al minimo l'**area**, sul file complessivo del circuito `fsmd.blif`. I risultati sono divisi tra il circuito **ottimizzato** e quello **non ottimizzato**.

Circuito **pre ottimizzazione**:
```go
sis> print_map_stats
Total Area		= 7104.00
Gate Count		= 206
Buffer Count		= 18
Inverter Count 		= 39
Most Negative Slack	= -38.00
Sum of Negative Slacks	= -844.20
Number of Critical PO	= 38
```
L'**area** occupata dal circuito **post mapping** è pari a `7104`, e il **cammino critico** è di `38`.
\newline

Circuito **post ottimizzazione**:
```go
Total Area		= 5152.00
Gate Count		= 149
Buffer Count		= 16
Inverter Count 		= 41
Most Negative Slack	= -34.60
Sum of Negative Slacks	= -658.80
Number of Critical PO	= 38
```

L'area è diminuita circa del `27%` mentre il cammino critico dell'`8%`. Siamo riusciti a ridurre sia l'area che il ritardo durante la fase di ottimizzazione. Il che ci porta ad aver pienamente raggiunto il nostro obiettivo.
