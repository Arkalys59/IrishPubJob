ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do 
       Citizen.Wait(500)
       if VarColor == "~g~" then VarColor = "~s~" else VarColor = "~g~" end   -- Si vous voulez changer la couleur toucher uniquement aux "g"
   end 
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end
 
------------------------[ Config Menu ]------------------------

local mainMenu = RageUI.CreateMenu("", "Irish Pub") 

local annoncemenu = RageUI.CreateSubMenu(mainMenu, "", "Annonces")
local pointsmenu = RageUI.CreateSubMenu(mainMenu, "", "Points Farm")


local open = false
 
mainMenu.X = 0 
mainMenu.Y = 0
 
mainMenu.Closed = function() 
    open = false 
end 

------------------------[ MENU F6 ]------------------------
 
function menuirishpub()
    if open then 
        open = false 
            RageUI.Visible(mainMenu, false) 
            return 
    else 
        open = true 
            RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu, function()
                RageUI.Separator(VarColor.."↓ Options ↓") 
                RageUI.Button("Facture", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'facture',
                        {
                            title = 'Donner une facture'
                        },
                        function(data, menu)
                        
                            local amount = tonumber(data.value)
                        
                            if amount == nil or amount <= 0 then
                                ESX.ShowNotification('Montant invalide')
                            else
                                menu.close()
                        
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification('Pas de joueurs proche')
                                else
                                    local playerPed = GetPlayerPed(-1)
                        
                                    Citizen.CreateThread(function()
                                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(playerPed)
                                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_irishpub', 'irishpub', amount)
                                        ESX.ShowNotification("~r~Vous avez bien envoyé la facture")
                                    end)
                                end
                            end
                        end,
                        function(data, menu)
                            menu.close()
                    end)
                end
                })

                RageUI.Button("Annonces", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                end
                }, annoncemenu)

                RageUI.Button("Position Points Farm", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                end
                }, pointsmenu)      
            end)

            RageUI.IsVisible(annoncemenu, function()
                ESX.PlayerData = ESX.GetPlayerData()
                RageUI.Separator(VarColor.."↓ Annonces ↓")
                    RageUI.Button("Annonce ~g~Ouverture~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('AnnonceOuverture:irishpub')
                    end
                    })

                    RageUI.Button("Annonce ~r~Fermeture~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('AnnonceFermeture:irishpub')  
                    end
                    })

                    RageUI.Button("Annonce ~y~Recrutement~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        TriggerServerEvent('AnnonceRecrutement:irishpub') 
                    end
                    })
            end)

            RageUI.IsVisible(pointsmenu, function()
                ESX.PlayerData = ESX.GetPlayerData()
                RageUI.Separator(VarColor.."↓ Points Farm ↓")
                    RageUI.Button("~s~Récolte~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed, true)
                        if IsPedInAnyVehicle(playerPed, true) then
                            for k, v in pairs(Config.Farm) do
                                SetNewWaypoint(v.Recolte.x, v.Recolte.y)
                            end
                        else
                            ESX.ShowNotification("~r~Vous devez être en voiture !")
                        end
                    end
                    })

                    RageUI.Button("~s~Traitement~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed, true)
                        if IsPedInAnyVehicle(playerPed, true) then
                            for k, v in pairs(Config.Farm) do
                                SetNewWaypoint(v.Traitement.x, v.Traitement.y)
                            end
                        else
                            ESX.ShowNotification("~r~Vous devez être en voiture !")
                        end
                    end
                    })

                    RageUI.Button("~s~Vente~s~", nil, {RightLabel = "→→"}, true, {
                    onSelected = function()
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed, true)
                        if IsPedInAnyVehicle(playerPed, true) then
                            for k, v in pairs(Config.Farm) do
                                SetNewWaypoint(v.Vente.x, v.Vente.y)
                            end
                        else
                            ESX.ShowNotification("~r~Vous devez être en voiture !")
                        end
                    end
                    })
                end)
            Wait(0)
            end
        end)
    end
end
 
------------------------[ MARKERS ]------------------------
 
Keys.Register('F6', 'irishpub', 'Ouvrir le menu Irish Pub', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
        if IsControlJustPressed(1,167) then
            menuirishpub()
        end
	end
end)

------------------------[ MENU COFFRE ]------------------------ 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local mainMenu = RageUI.CreateMenu("", "Action :")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"", "Contenue :")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"", "Contenue :")

local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

    
function Coffreirishpub() 
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(mainMenu, function()
            RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getStock()
            end},GetMenu);

            RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                getInventory()
            end},PutMenu);
        end)

        RageUI.IsVisible(GetMenu, function()  
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "x"..""..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("irishpub:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStock()
                end});
            end
        end)

        RageUI.IsVisible(PutMenu, function()        
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, nil, {RightLabel = "x"..""..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    TriggerServerEvent("irishpub:putStockItems",v.item, count)
                    getInventory()
                end});
            end
       end)
    Wait(0)
    end
end)
end
end



function getInventory()
    ESX.TriggerServerCallback('irishpub:playerinventory', function(inventory)                            
        all_items = inventory   
    end)
end

function getStock()
    ESX.TriggerServerCallback('irishpub:getStockItems', function(inventory)                     
        all_items = inventory     
    end)
end

Citizen.CreateThread(function()
    while true do
		local wait = 750
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
				for k, v in pairs(Config.Position) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Coffre.x, v.Coffre.y, v.Coffre.z)

				if dist <= Config.MarkerDistance then
					wait = 0
					DrawMarker(Config.MarkerType, v.Coffre.x, v.Coffre.y, v.Coffre.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
				end

				if dist <= 1.0 then
					wait = 0
					ESX.ShowHelpNotification(Config.TextCoffre) 
					if IsControlJustPressed(1,51) then
						Coffreirishpub()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)


------------------------[ MENU GARAGE ]------------------------

function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 3,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    } 
    ESX.Game.SetVehicleProperties(vehicle, props)
end

local open = false 
local mainMenu6 = RageUI.CreateMenu('', 'Véhicules Entreprises')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
    open = false
end

function Garageirishpub()
    if open then 
        open = false
        RageUI.Visible(mainMenu6, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu6, true)
        CreateThread(function()
        while open do 
            RageUI.IsVisible(mainMenu6,function() 
            RageUI.Separator(VarColor.."↓ Véhicules ↓")
                for k,v in pairs(Config.Vehiculeirishpub) do
                    RageUI.Button(v.buttoname, nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                        if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                            ESX.ShowNotification("~g~Irish Pub\n~r~Point de spawn bloquée")
                        else
                            local model = GetHashKey(v.spawnname)
                            RequestModel(model)
                            while not HasModelLoaded(model) do 
                                Wait(10) 
                            end
                            SetVehicleMaxMods(vehicle)
                            local ambuveh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                            SetVehicleNumberPlateText(ambuveh, "IrishPub"..math.random(50, 999))
                            SetVehicleCustomPrimaryColour(ambuveh, 0, 87, 37)
                            SetVehicleCustomSecondaryColour(ambuveh, 0, 87, 37)
                            SetVehicleFixed(ambuveh)
                            SetVehRadioStation(ambuveh, 0)
                            RageUI.CloseAll()
                        end
                    end
                    })
                end
            end)
        Wait(0)
        end
    end)
end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
            for k, v in pairs(Config.Position) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.GarageVehicule.x, v.GarageVehicule.y, v.GarageVehicule.z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.GarageVehicule.x, v.GarageVehicule.y, v.GarageVehicule.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(Config.TextGarage) 
                    if IsControlJustPressed(1,51) then
                        Garageirishpub()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)
 
------------------------[ MENU RANGER - Véhicule ]------------------------

local open = false 
local mainMenuRanger = RageUI.CreateMenu('', 'Rentrer au garage')
mainMenuRanger.Display.Header = true 
mainMenuRanger.Closed = function()
    open = false
end

function RangerVoiture()
    if open then 
        open = false
        RageUI.Visible(mainMenuRanger, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenuRanger, true)
        CreateThread(function()
        while open do 
            RageUI.IsVisible(mainMenuRanger,function() 
            RageUI.Button("Ranger votre véhicule", 'Vous ne pouvez ranger uniquement les véhicules de service du ~g~Irish Pub', {RightLabel = "→→"}, true , {
                onSelected = function()
                    local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                    if dist4 < 1 then
                        DeleteEntity(veh)
                        ESX.ShowNotification('~r~Garage \n~g~- Véhicule rangé !~s~')
                        RageUI.CloseAll()
                    end
                end
            })
            end)
        Wait(0)
        end
    end)
end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
            for k, v in pairs(Config.Position) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.RangerVehicule.x, v.RangerVehicule.y, v.RangerVehicule.z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.RangerVehicule.x, v.RangerVehicule.y, v.RangerVehicule.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(Config.TextRangerGarage) 
                    if IsControlJustPressed(1,51) then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            RangerVoiture()
                        else
                            ESX.ShowNotification('Vous devez être dans un ~r~Véhicule !~s~')
                        end
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)
 
 
   
------------------------[ MENU VESTIAIRE ]------------------------

local open = false 
local mainMenuvestiaire = RageUI.CreateMenu('', 'Vos Tenues')
mainMenuvestiaire.Display.Header = true 
mainMenuvestiaire.Closed = function()
    open = false
end
    
function vestiaire()
    if open then 
        open = false
        RageUI.Visible(mainMenuvestiaire, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenuvestiaire, true)
        CreateThread(function()
        while open do 
            RageUI.IsVisible(mainMenuvestiaire,function() 
                RageUI.Separator(VarColor.."↓ Vestiaire ↓")
                RageUI.Checkbox("Prendre votre tenue", nil, service, {}, {
                    onChecked = function(index, items)
                        service = true
                        serviceon()
                        ESX.ShowAdvancedNotification('Irish Pub', '~r~Notification', "Vous venez de prendre votre ~g~tenue", 'CHAR_PROPERTY_BAR_IRISH', 7)
                    end,

                    onUnChecked = function(index, items)
                        service = false
                        serviceoff()
                        ESX.ShowAdvancedNotification('Irish Pub', '~r~Notification', "Vous venez de ~r~ranger votre tenue", 'CHAR_PROPERTY_BAR_IRISH', 7)
                    end
                })
                end)
            Wait(0)
            end
        end)
    end
end
    
Citizen.CreateThread(function()
    while true do  
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
            for k, v in pairs(Config.Position) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Vestiaire.x, v.Vestiaire.y, v.Vestiaire.z)
      
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.Vestiaire.x, v.Vestiaire.y, v.Vestiaire.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                end
      
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(Config.TextVestiaire) 
                    if IsControlJustPressed(1,51) then
                        vestiaire()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

------------------------[ Tenue Vestiaire Homme / Femme ]------------------------

function  serviceon()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
                ['tshirt_1'] = 10,  ['tshirt_2'] = 11,
                ['torso_1'] = 23,   ['torso_2'] = 0,
                ['arms'] = 4,
                ['pants_1'] = 20,   ['pants_2'] = 3,
                ['shoes_1'] = 3,    ['shoes_2'] = 2,
                ['helmet_1'] = 26,  ['helmet_2'] = 4,
                ['chain_1'] = 22,   ['chain_2'] = 0,
                ['ears_1'] = -1,    ['ears_2'] = 0
            }

        else
            clothesSkin = {
                ['tshirt_1'] = 38,  ['tshirt_2'] = 8,
                ['torso_1']  = 24,  ['torso_2']  = 11,
                ['arms']     = 1,
                ['pants_1']  = 23,  ['pants_2']  = 0,
                ['shoes_1']  = 6,   ['shoes_2']  = 0,
                ['helmet_1'] = 26,  ['helmet_2'] = 4,
                ['chain_1']  = 23,  ['chain_2']  = 1,
                ['ears_1']   = -1,  ['ears_2']   = 0
            }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end
    
function serviceoff()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

RegisterNetEvent('message:irishpub')
AddEventHandler('message:irishpub', function(message, nom)
	ESX.ShowAdvancedNotification('Notification Irish Pub', '~g~Message', '~s~De: ~r~'..nom..'\n~w~Message: ~s~'..message..'', 'CHAR_PROPERTY_BAR_IRISH', 1)
end)

------------------------[ MENU COMPTOIR ]------------------------ 

local open = false 
local mainMenuComptoir = RageUI.CreateMenu('', 'Irish Pub')
mainMenuComptoir.Display.Header = true 
mainMenuComptoir.Closed = function()
  open = false
end

function ComptoirIrishPub()
    if open then 
        open = false
        RageUI.Visible(mainMenuComptoir, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenuComptoir, true)
        CreateThread(function()
        while open do 
           RageUI.IsVisible(mainMenuComptoir,function() 
            RageUI.Separator(VarColor.."↓ Boissons ↓")
            RageUI.Button("Whisky", "Acheter un Whisky", {RightLabel = "0$"}, true, { 
                onSelected = function()
                    TriggerServerEvent('whisky:irishpub')
                end
              })

              RageUI.Button("Whisky-Coca", "Acheter un Whisky-Coca", {RightLabel = "0$"}, true, { 
                onSelected = function()
                    TriggerServerEvent('whiskycoca:irishpub')
                end
              })

              RageUI.Button("Tequila", "Acheter une Tequila", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('tequila:irishpub')
                end
              })

              RageUI.Button("Vodka", "Acheter une Vodka", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('vodka:irishpub')
                end
              })

              RageUI.Button("Bière", "Acheter une Bière", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('beer:irishpub')
                end
              })

              RageUI.Button("Rhum", "Acheter un Rhum", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('rhum:irishpub')
                end
              })

              RageUI.Button("Martini Blanc", "Acheter un Martini Blanc", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('martini:irishpub')
                end
              })

              RageUI.Button("Café", "Acheter un Café", {RightLabel = "0$"}, true, { 
                onSelected = function()
                     TriggerServerEvent('coffe:irishpub')
                end
              })

            end)
        Wait(0)
        end
    end)
end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
            for k, v in pairs(Config.Position) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Comptoir.x, v.Comptoir.y, v.Comptoir.z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.Comptoir.x, v.Comptoir.y, v.Comptoir.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(Config.TextComptoir) 
                    if IsControlJustPressed(1,51) then
                        ComptoirIrishPub()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

------------------------[ MENU ACTIONS PATRON ]------------------------

local open = false 
local societyargent = nil
local mainMenuBoss = RageUI.CreateMenu('', 'GESTION')
mainMenuBoss.Display.Header = true 
mainMenuBoss.Closed = function()
  open = false
end

function bossmenu()
    if open then 
        open = false
        RageUI.Visible(mainMenuBoss, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenuBoss, true)
        CreateThread(function()
        while open do 
            RageUI.IsVisible(mainMenuBoss,function() 
            RageUI.Separator(VarColor.."↓ Gestion Entreprise ↓") 
            RageUI.Button("Accédez à la gestion de l\'entreprise" , nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    gestionboss()
                    RageUI.CloseAll()    
                end
            })
            end)
        Wait(0)
        end
    end)
end
end

Citizen.CreateThread(function()
    while true do  
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then
            for k, v in pairs(Config.Position) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Boss.x, v.Boss.y, v.Boss.z)
  
                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.Boss.x, v.Boss.y, v.Boss.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                end
  
                if dist <= 2.0 then 
                    wait = 0
                    ESX.ShowHelpNotification(Config.TextBoss) 
                    if IsControlJustPressed(1,51) then
                        bossmenu()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

function ArgentRefresh(money)
    irishpub = ESX.Math.GroupDigits(money)
end

function UpdateMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            ArgentRefresh(money)
        end, ESX.PlayerData.job.name)
    end
end

function gestionboss()
    TriggerEvent('esx_society:openBossMenu', 'irishpub', function(data, menu)
        menu.close()
    end, {wash = false})
end

------------------------[ Config Blips ]------------------------
 
local blips = {
    {title="~g~Irish ~s~Pub", colour=2, id=547, x = 829.69, y = -117.95, z = 80.43}
}
  
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

local blips2 = {
    {title="~g~Irish ~s~ | Récolte", colour=2, id=547, x = 374.23, y = 793.40, z = 187.27}, 
    {title="~g~Irish ~s~ | Traitement", colour=2, id=547, x = 245.03, y = 370.70, z = 105.73},
    {title="~g~Irish ~s~ | Vente", colour=2, id=547, x = 1126.34, y = -467.92, z = 66.48},
}

Citizen.CreateThread(function()
    if ESX.PlayerData.job.name == 'irishpub' then
        for _, info in pairs(blips2) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.9)
            SetBlipColour(info.blip, info.colour)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.title)
            EndTextCommandSetBlipName(info.blip)
        end
    end
end)






