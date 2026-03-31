# batterie_trajets.jl
# Script pour dimensionner batterie VAE pour plusieurs trajets
# Gestion des données trajets (distance et dénivelé, positifs et négatifs)
# Calcul de l’énergie nécessaire par trajet
# Calcul pour les configurations batterie 13S4P, 13S6P, 13S7P
# Vérification si la batterie est suffisante
# Calcul de vitesse moyenne atteignable pour moteurs 250 W, 500 W et 750 W

# ----------------------
# Données cellule
# ----------------------
cell_type = "18650"
chemistry = "Li-ion"
V_cell = 3.6          # V
Ah_cell_typ = 3.4     # Ah typique
mass_cell = 0.049     # kg
current_discharge = 8 # A par cellule
Wh_cell = V_cell * Ah_cell_typ



# ----------------------
# Données cycliste + sac
# ----------------------
mass_cyclist = 85      # kg
mass_sac = 10          # kg
mass_velo = 20         # kg
mass_total = mass_cyclist + mass_sac + mass_velo  # kg

g = 9.81  # gravité m/s²

# ----------------------
# Fonctions batterie
# ----------------------
function calculer_batterie(S::Int, P::Int)
    total_cells = S * P
    V_pack = S * V_cell
    Ah_pack = P * Ah_cell_typ
    Wh_pack = Wh_cell * total_cells
    mass_pack = mass_cell * total_cells
    courant_max = P * current_discharge
    return (V_pack, Ah_pack, Wh_pack, mass_pack, courant_max, total_cells)
end

# ----------------------
# Fonction énergie trajet
# ----------------------
function calculer_energie_trajet(mass_total::Float64, denivele::Float64, distance_km::Float64; perte=1.3)
    # Seules les montées positives demandent de l’énergie
    denivele_pos = max(denivele, 0.0)
    E_grav = mass_total * g * denivele_pos       # en Joules
    # Approximation résistance au roulement et friction
    E_plat = 0.03 * mass_total * distance_km * 1000 * g  # Joules
    E_total = (E_grav + E_plat) * perte
    return E_total / 3600  # Wh
end

# ----------------------
# Fonction vitesse moyenne atteignable pour un moteur
# ----------------------
function vitesse_moyenne_temps_atteignable(E_total_Wh, distance_km, P_moteur_W)
    t_h = E_total_Wh / P_moteur_W       # heures
    v_moy = distance_km / t_h           # km/h
    return v_moy, t_h
end

# ----------------------
# Affichage résultats pour un trajet
# ----------------------
function afficher_batterie_trajet(trajet_nom::String, distance_km, denivele, S::Int, parallel_configs::Vector{Int}, moteurs::Vector{Int})
    println("\n=== $trajet_nom ===")
    println("Distance : $distance_km km | Dénivelé : $denivele m")
    energy_needed = calculer_energie_trajet(Float64(mass_total), Float64(denivele), Float64(distance_km))
    println("Énergie estimée nécessaire : $(round(energy_needed)) Wh")
    
    for P in parallel_configs
        V, Ah, Wh, mass, Imax, cells = calculer_batterie(S, P)
        println("\n--- Configuration $(S)S$(P)P ---")
        println("Tension : $(round(V,digits=1)) V | Capacité : $(round(Ah,digits=1)) Ah | Énergie pack : $(round(Wh)) Wh")
        println("Masse pack : $(round(mass,digits=2)) kg | Courant max : $Imax A | Nombre cellules : $cells")
        if Wh >= energy_needed
            println("Suffisant pour le trajet")
        else
            println("Insuffisant pour le trajet")
        end
        
        # Calcul vitesse moyenne pour chaque moteur
        for P_mot in moteurs
            v_moy,t_h = vitesse_moyenne_temps_atteignable(Float64(energy_needed), Float64(distance_km), Float64(P_mot))
            println("Puissance moteur : $P_mot W → Vitesse moyenne atteignable : $(round(v_moy,digits=1)) km/h en $(round(t_h,digits=1)) heures")
        end
    end
end

# ----------------------
# Données trajets (dénivelés négatifs pour descentes)
# ----------------------
# trajets = [
#     ("Hurtières → gare de Brignoud (VTT-VTC)", 9.9, -506),
#     ("Hurtières → gare de Brignoud (route)", 13.2, -506),
#     ("Gare de Brignoud → Hurtières (VTT-VTC)", 9.1, 506),
#     ("Hurtières → Boulot Meylan", 23.8, -549),
#     ("Boulot Meylan → Hurtières", 21.2, 541),
#     ("Hurtières → Boulot Grand Place", 32.3, -554),
#     ("Boulot Grand Place → Hurtières", 30.6, 546),
#     ("St Martin d'Uriage → Boulot Grand Place", 17.9, -526),
#     ("Boulot Grand Place → St Martin d'Uriage", 16.3, 570),
#     ("St Martin d'Uriage → Boulot Meylan", 17.3, -528),
#     ("Boulot Meylan → St Martin d'Uriage", 15.3, 528)
# ]

trajets = [
    ("Gare de Brignoud → Hurtières (VTT-VTC)", 9.1, 506),
    ("Boulot Meylan → Hurtières", 21.2, 541),
    ("Boulot Grand Place → Hurtières", 30.6, 546),
    ("Boulot Grand Place → St Martin d'Uriage", 16.3, 570),
    ("Boulot Meylan → St Martin d'Uriage", 15.3, 528)
]

# ----------------------
# Paramètres batterie et moteurs
# ----------------------
S = 13
# parallel_configs = [4, 6, 7]
parallel_configs = [4]

moteurs = [250, 500, 750]  # W

# ----------------------
# Calcul pour chaque trajet
# ----------------------
for (nom, distance, denivele) in trajets
    afficher_batterie_trajet(nom, Float64(distance), Float64(denivele), S, parallel_configs, moteurs)
end

# g = 9.81  # gravité m/s²

# # ----------------------
# # Fonctions
# # ----------------------

# function calculer_batterie(S::Int, P::Int)
#     total_cells = S * P
#     V_pack = S * V_cell
#     Ah_pack = P * Ah_cell_typ
#     Wh_pack = Wh_cell * total_cells
#     mass_pack = mass_cell * total_cells
#     courant_max = P * current_discharge
#     return (V_pack, Ah_pack, Wh_pack, mass_pack, courant_max, total_cells)
# end

# function calculer_energie_trajet(mass_total::Float64, denivele::Float64, distance_km::Float64; perte=1.3)
#     # Si dénivelé négatif, on considère 0 pour énergie gravitationnelle
#     denivele_pos = max(denivele, 0.0)
#     E_grav = mass_total * g * denivele_pos       # en Joules
#     # Énergie pour rouler sur plat approximative
#     E_plat = 0.03 * mass_total * distance_km * 1000 * g  # en Joules
#     E_total = (E_grav + E_plat) * perte
#     E_total_Wh = E_total / 3600  # Joules → Wh
#     return E_total_Wh
# end

# function afficher_batterie_trajet(trajet_nom::String, distance_km::Float64, denivele::Float64, S::Int, parallel_configs::Vector{Int})
#     println("\n=== $trajet_nom ===")
#     println("Distance : $distance_km km | Dénivelé : $denivele m")
#     energy_needed = calculer_energie_trajet(Float64(mass_total), Float64(denivele), Float64(distance_km))
#     println("Énergie estimée nécessaire : $(round(energy_needed)) Wh")
    
#     for P in parallel_configs
#         V, Ah, Wh, mass, Imax, cells = calculer_batterie(S, P)
#         println("\nConfiguration $(S)S$(P)P :")
#         println("  - Tension : $(round(V,digits=1)) V")
#         println("  - Capacité : $(round(Ah,digits=1)) Ah")
#         println("  - Énergie pack : $(round(Wh)) Wh")
#         println("  - Masse pack : $(round(mass,digits=2)) kg")
#         println("  - Courant max : $Imax A")
#         println("  - Nombre cellules : $cells")
#         if Wh >= energy_needed
#             println("  Suffisant pour le trajet")
#         else
#             println("  Insuffisant pour le trajet")
#         end
#     end
# end

# # ----------------------
# # Données trajets
# # ----------------------

# trajets = [
#     ("Hurtières → gare de Brignoud (VTT-VTC)", 9.9, 506),
#     ("Hurtières → gare de Brignoud (route)", 13.2, 506),
#     ("Gare de Brignoud → Hurtières (VTT-VTC)", 9.1, 506),
#     ("Hurtières → Boulot Meylan", 23.8, -549),  # descente
#     ("Boulot Meylan → Hurtières", 21.2, 541),  # montée
#     ("Hurtières → Boulot Grand Place", 32.3, -554), # descente
#     ("Boulot Grand Place → Hurtières", 30.6, 546), # montée
#     ("St Martin d'Uriage → Boulot Grand Place", 17.9, -526), # descente
#     ("Boulot Grand Place → St Martin d'Uriage", 16.3, 570),  # montée
#     ("St Martin d'Uriage → Boulot Meylan", 17.3, -528), # descente
#     ("Boulot Meylan → St Martin d'Uriage", 15.3, 528)   # montée
# ]
# # ----------------------
# # Paramètres batterie
# # ----------------------
# S = 13
# parallel_configs = [4, 6, 7]

# # ----------------------
# # Calculs pour chaque trajet
# # ----------------------
# for (nom, distance, denivele) in trajets
#     afficher_batterie_trajet(nom, Float64(distance), Float64(denivele), S, parallel_configs)
# end

