# esegue le ottimizzazioni in ordine

rl fsmd.blif
psf

source ./scripts/minimize/adder_1.min
source ./scripts/minimize/comparatorgte_8.min
source ./scripts/minimize/comparatorlte_8.min
source ./scripts/minimize/mux2_8.min
source ./scripts/minimize/controller.min
source ./scripts/minimize/counter_8.min
source ./scripts/minimize/normalizer.min
source ./scripts/minimize/fsmd.min

rl fsmd.blif
psf

