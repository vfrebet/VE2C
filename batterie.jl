###  Dimensionnement batterie Li-ion 18650

# Données cellule
cell_type = "18650"
chemistry = "Li-ion"
V_cell = 3.6           # V nominale
Ah_cell_min = 3.35      # Ah min
Ah_cell_typ = 3.4       # Ah typique
Wh_cell = V_cell * Ah_cell_typ  # Wh par cellule
mass_cell = 0.049       # kg
current_discharge = 8   # A
height_mm = 65
diameter_mm = 18.3
protected = false
version = "Haut plat"

# Architecture
S = 13  # cellules en série pour 48V

# Configurations parallèles à tester
parallel_configs = [4, 5, 6, 7]  # P

# Calcul pour chaque configuration
println("### ⚡ Caractéristiques des packs 13SxP ###\n")
for P in parallel_configs
    total_cells = S * P
    Ah_pack = P * Ah_cell_typ
    V_pack = S * V_cell
    Wh_pack = Wh_cell * total_cells
    mass_pack = mass_cell * total_cells
    println("Configuration: $(S)S$(P)P")
    println("  - Nombre de cellules : $total_cells")
    println("  - Tension pack : $(round(V_pack, digits=1)) V")
    println("  - Capacité pack : $(round(Ah_pack, digits=1)) Ah")
    println("  - Énergie pack : $(round(Wh_pack)) Wh")
    println("  - Masse pack : $(round(mass_pack, digits=2)) kg")
    println("  - Courant max (8A/cell) : $(P*current_discharge) A\n")
end