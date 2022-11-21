ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function IrishPubRecolte()
    local open = false
    local mainMenu = RageUI.CreateMenu("", "Récolte")
    mainMenu.Closed = function() open = false end
    if not open then open = true RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Lancer/Stopper la Récolte", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            Recolte()
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end

function Recolte()
    recolte = not recolte
    while recolte do
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.Wait(2000)
        TriggerServerEvent("recolte:irishpub", "pomme")
    end
    if not recolte then
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k, v in pairs(Config.Farm) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'irishpub' then 
                local coords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(coords.x, coords.y, coords.z, v.Recolte.x, v.Recolte.y, v.Recolte.z)
                if dist <= 20.0 then 
                    wait = 0
                    DrawMarker(Config.MarkerType, v.Recolte.x, v.Recolte.y, v.Recolte.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
                    if dist <= 5.0 then 
                        wait = 0 
                        ESX.ShowHelpNotification("~INPUT_TALK~ pour ouvrir la ~g~Récolte")
                        if IsControlJustPressed(1,51) then 
                            IrishPubRecolte()
                        end
                    end
                end
            end
        Citizen.Wait(wait)
        end
    end
end)