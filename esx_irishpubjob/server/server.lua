ESX = nil

 TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
 TriggerEvent('esx_society:registerSociety', 'irishpub', 'irishpub', 'society_irishpub', 'society_irishpub', 'society_irishpub', {type = 'private'})
   
------------------------[ CONFIG ANNONCES F6 ]------------------------ 

RegisterServerEvent('AnnonceOuverture:irishpub')
AddEventHandler('AnnonceOuverture:irishpub', function()
  local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Irish Pub', '~r~Annonce', 'Irish Pub est maintenant ~g~ouvert !', 'CHAR_PROPERTY_BAR_IRISH', 2) --> Modif Char pour le logo entreprise
	end
end)

RegisterServerEvent('AnnonceFermeture:irishpub')
AddEventHandler('AnnonceFermeture:irishpub', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Irish Pub', '~r~Annonce', 'Irish Pub ferme ses portes pour ~r~aujourd\'hui~s~ !', 'CHAR_PROPERTY_BAR_IRISH', 2)
	end
end)

RegisterServerEvent('AnnonceRecrutement:irishpub')
AddEventHandler('AnnonceRecrutement:irishpub', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Irish Pub', '~r~Annonce', '~s~Recrutement en cours, rendez-vous au Irish Pub', 'CHAR_PROPERTY_BAR_IRISH', 2)
	end
end)

------------------------[ CONFIG COFFRE ]------------------------ 

ESX.RegisterServerCallback('irishpub:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end

	cb(all_items)
end)

ESX.RegisterServerCallback('irishpub:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_irishpub', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

ESX.RegisterServerCallback('irishpub:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_irishpub', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end

	end)
	cb(all_items)
end)

RegisterServerEvent('irishpub:putStockItems')
AddEventHandler('irishpub:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_irishpub', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~g~Dépot\n~s~- ~g~Coffre : ~s~Irish Pub \n~s~- ~o~Quantitée ~s~: "..count.."")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
		end
	end)
end)

RegisterServerEvent('irishpub:takeStockItems')
AddEventHandler('irishpub:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_irishpub', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~r~Retrait\n~s~- ~g~Coffre : ~s~Irish Pub \n~s~- ~o~Quantitée ~s~: "..count.."")
	end)
end)


RegisterServerEvent('message:irishpub')
AddEventHandler('message:irishpub', function(PriseOuFin, message)
    local _source = source
    local _raison = PriseOuFin
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName(_source)

    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'irishpub' then
            TriggerClientEvent('message:irishpub', xPlayers[i], _raison, name, message)
        end
    end
end)

------------------------[ CONFIG FARM  ]------------------------ 

----------[ CONFIG Récolte ]----------


RegisterServerEvent("recolte:irishpub")
AddEventHandler("recolte:irishpub", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    if result >= 100 then
        TriggerClientEvent("esx:showNotification", source, "Vous ne pouvez pas en porter d'avantage")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent("esx:showNotification", source, "Récolte en cours...")
    end
end)

----------[ CONFIG Traitement ]----------

RegisterServerEvent("traitement:irishpub")
AddEventHandler("traitement:irishpub", function(item, xitem)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    local xresult = xPlayer.getInventoryItem(xitem).count
    if xresult > 100 then
        TriggerClientEvent("esx:showNotification", source, "Vous ne pouvez pas en porter d'avantage")
    elseif result < 5 then
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez plus assez de ~b~"..item.."~s~ pour traiter")
    else
        xPlayer.removeInventoryItem(item, 5)
        xPlayer.addInventoryItem(xitem, 1)
    end
end)

----------[ CONFIG Vente ]----------

RegisterServerEvent("vente:irishpub")
AddEventHandler("vente:irishpub", function(item)
    local price = math.random(40,50)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = xPlayer.getInventoryItem(item).count
    if result > 0 then
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
        societyAccount = account
        end)
        societyAccount.addMoney(price)
        xPlayer.removeInventoryItem(item, 1)     
        TriggerClientEvent("esx:showNotification", source, "Votre entreprise a gagné ~g~"..price.."$")
    else
        TriggerClientEvent("esx:showNotification", source, "Vous n'avez plus rien à vendre")
    end
end)

------------------------[ CONFIG COMPTOIR ]------------------------ 


RegisterNetEvent('whisky:irishpub') 
AddEventHandler('whisky:irishpub', function() 
  local joueur = ESX.GetPlayerFromId(source)  
  local prix = 0

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix)  
      joueur.addInventoryItem('whisky', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Whisky \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('whiskycoca:irishpub') 
AddEventHandler('whiskycoca:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('whiskycoca', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Whisky-Coca \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('tequila:irishpub') 
AddEventHandler('tequila:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix)
      joueur.addInventoryItem('tequila', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Tequila \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('vodka:irishpub') 
AddEventHandler('vodka:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('vodka', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Vodka \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('beer:irishpub') 
AddEventHandler('beer:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('beer', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Bière \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('rhum:irishpub') 
AddEventHandler('rhum:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('rhum', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Rhum \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('martini:irishpub') 
AddEventHandler('martini:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('martini', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Martini Blanc \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)

RegisterNetEvent('coffe:irishpub') 
AddEventHandler('coffe:irishpub', function() 
   local joueur = ESX.GetPlayerFromId(source)  
   local prix = 0
   TriggerEvent('esx_addonaccount:getSharedAccount', 'society_irishpub', function(account)
    if account.money >= prix then 
      account.removeMoney(prix) 
      joueur.addInventoryItem('coffe', 1) 
      TriggerClientEvent('esx:showNotification', source, "~g~Achat :~s~ \n- Objet : ~g~x1 ~s~~o~Café \n~s~- Paiement : ~g~Entreprise~s~\n- Prix : ~r~0$")
    else 
      TriggerClientEvent('esx:showNotification', source, "~r~Achat annulé~s~\n - ~o~Pas assez d'argent")
    end
  end)
end)
