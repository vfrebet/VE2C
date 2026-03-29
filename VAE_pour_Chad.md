# Introduction 

L'objectif de l'étude est de visualiser un chemin pour passer de la voiture à un VAE pour les trajets du quotidien. 
Les contraintes sont : 
- environnement montagneux avec du dénivelé
- Etre assez puissant pour mes grosses fesses 85kg
  
## Evolution du prix du pétrole 

![texte alternatif](./capture/prediction_essence.png)


## Cout de la bagnole

![texte alternatif](./capture/prediction_cout_entretien_voiture.png)

## Trajets 
3 trajets aller-retour possibles :

### Hurtières-gare de Brignoud
- Trajet 1 : 9.9km - estimation 29min - chemin VTT-VTC - 506m de dénivelé -
- Trajet 2 : 13.2km - estimation 42min - 
chemin route - 506m de dénivelé -

### gare de Brignoud-Hurtières
- Trajet 1 : 9.1km;estimation 1h17min;chemin VTT-VTC;506m de dénivelé+

### Hurtières-Boulot Meylan 
- 23.8km;estimation 1h13;chemin VTT-VTC;549m_dénivelé-;44m_dénivelé+ 

### Boulot Meylan-Hurtières 
- 21.2km;estimation 1h45;chemin VTT-VTC;541m_dénivelé+;37m_dénivelé- 

### Hurtières-Boulot Grand Place
- 32.3km;esimation 1h41;chemin VTT-VTC;554m_dénivelé-;52m_dénivelé+ 

### Boulot Grand Place-Hurtières
- 30.6km;esimation 2h15;chemin VTT-VTC;546m_dénivelé+;44m_dénivelé- 

### St Martin d'Uriage-Boulot Grand Place
- 17.9km;estimation 55min;chemin route;526m_dénivelé-

### Boulot Grand Place-St Martin d'Uriage
- 16.3km;estimation 1h25min;chemin route;570m_dénivelé+

### St Martin d'Uriage-Boulot Meylan
- 17.3km; estimation 48min;chemin route;528m_dénivelé-

### Boulot Meylan-St Martin d'Uriage
- 15.3km; estimation 1h21min;chemin route;528m_dénivelé+

# Dimensionnement

## Masse totale
Moi : 85kg
Velo : 20kg 
bonus : 5-6kg
Total : 111 kg 

## Batterie

### Calcul Energie 
calcul à 600 mètres de dénivelé
111kg*9.81*600m=653000 J ~ 181Wh 

Résistance au roulement et rendement moteur ~85%

Consommation réelle 220-260Wh pour le retour  

Wh = V × Ah 
### Cible Batterie 48V - 10A ~ 480W  
### Cible Batterie 48V - 14A ~ 672W  

# Recherche VAE premium existant 


![texte alternatif](./capture/comparatif_VAE_commerce.png)

# Recherche assemblage VAE DIY

###  Bafang BBS02 250W  
- Capteur de couple (pas seulement de cadence) pour un feeling naturel
Batterie 48V 14Ah (~672 Wh) 

https://www.lift-mtb.com/produit/moteur-bafang-bbs02-250w/

- Fournisseurs français sérieux : Cycloboost (Bordeaux), Virvolt, À bicyclette Paulette

## Batterie 
### Architecture

Les meilleures cellules Samsung 35E ou Panasonic NCR18650GA.
- pack de cellules 18650 Samsung (ex:13S4P = 52 cellules)
- BMS (circuit électronique de gestion)

Une batterie 48V Li-ion est composée de 13 cellules en série. Pour obtenir une batterie de 48V et 20Ah, il faut 13 × 2 soit 26 cellules, plus un BMS. Le montage en série est noté "S" et en parallèle "P" — une batterie 13S4P contient donc 52 cellules 18650

Achat de batterie 
https://www.nkon.nl/fr/samsung-inr18650-35e.html


Taille de la batterie : 18650
Batterie chimique : Li-ion
Tension nominale : 3.6V
Min. capacité : 3350 mAh
Capacité typ. : 3400 mAh
Poids : 49g
Version batterie : Haut plat
Courant de décharge : 8A
Protection des circuits : Non protégé
Hauteur : 65 mm
Diamètre : 18.3 mm


3.6V * 3.5Ah ~ 12.6Wh par cellule
Avec 52 cellules : 
Energie : 12.6Wh*52 ~ 655Wh
Masse cellule : 49g*52 = 2.55kg 



git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/vfrebet/VE2C.git
git push -u origin main