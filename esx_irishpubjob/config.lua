
Config = {

    --Marker Config
    MarkerType = 22, 
    MarkerSizeLargeur = 0.3, 
    MarkerSizeEpaisseur = 0.3, 
    MarkerSizeHauteur = 0.3, 
    MarkerDistance = 6.0, -- Distane de visibiliter du marker (1.0 = 1 mètre)
    MarkerColorR = 72, 
    MarkerColorG = 153, 
    MarkerColorB = 43, 
    MarkerOpacite = 255,
    MarkerSaute = true, -- Marker saute (true = oui, false = non)
    MarkerTourne = true, -- Marker tourne (true = oui, false = non)
    
    --Config Points
    Position = {
        {
            Coffre = vector3(825.37, -118.15, 80.43),           -- Menu coffre 
            Comptoir = vector3(835.53, -115.14, 79.77),         -- Menu Comptoir
            GarageVehicule = vector3(814.26, -109.16, 80.60),   -- Menu Garage Vehicule
            RangerVehicule = vector3(814.12, -118.54, 80.30),   -- Menu ranger votre véhicule 
            Vestiaire = vector3(823.91, -113.25, 80.43),        -- Menu Vestiaire
            Boss = vector3(829.69, -117.95, 80.43),             -- Menu Boss
        }
    },

    -- Config Points Farm
    Farm = {
        {
            Recolte = vector3(374.23, 793.40, 187.27), Traitement = vector3(245.03, 370.70, 105.73), Vente = vector3(1126.34, -467.92, 66.48)
        }
    },
    
    
    --Config Texte
    TextCoffre = "Appuyez sur ~g~[E] ~s~pour accèder au ~g~Stockage ~s~",
    TextComptoir = "Appuyez sur ~g~[E] ~s~pour accèder au ~g~Comptoir ~s~",
    TextGarage = "Appuyez sur ~g~[E] ~s~pour accèder au ~g~Garage",
    TextRangerGarage = "Appuyez sur ~g~[E] ~s~pour ranger votre ~g~Véhicule de service",
    TextVestiaire = "Appuyez sur ~g~[E] ~s~pour accèder au ~g~Vestiaire",
    TextBoss = "Appuyez sur ~g~[E] ~s~pour accèder aux ~g~Comptes",
    
    
    --Config Vehicule Irish Pub 
    Vehiculeirishpub = { 
        {buttoname = "Hustler", rightlabel = "→→", spawnname = "hustler", spawnzone = vector3(821.87, -122.27, 80.32), headingspawn = 239.47}, 
        {buttoname = "Baller", rightlabel = "→→", spawnname = "baller6", spawnzone = vector3(821.87, -122.27, 80.32), headingspawn = 239.47}, 
        {buttoname = "Schafter", rightlabel = "→→", spawnname = "schafter4", spawnzone = vector3(821.87, -122.27, 80.32), headingspawn = 239.47}, 
        {buttoname = "Burrito", rightlabel = "→→", spawnname = "gburrito2", spawnzone = vector3(821.87, -122.27, 80.32), headingspawn = 239.47}, 
    },
    
}