Creat by KaiSoR#0509

Veuillez à bien ajouter le SQL avant de lancer votre serveur !! 

Pour ajouter les items "Pomme / Cidre" consommable suivez les instructions suivantes :

--> Pour le cidre : 

--> Vous rendre dans votre esx_basicneeds --> main.lua serveur et ajouter :

ESX.RegisterUsableItem('wine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cidre', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_cidre'))
end)

--> Puis dans esx_basicneeds --> locales --> fr.lua et ajouter : 

['used_cidre'] = 'Vous avez utilisé 1x ~y~Cidre~s~'

[------------------------------------------]

--> Pour la pomme : 

--> Vous rendre dans votre esx_basicneeds --> main.lua serveur et ajouter :

ESX.RegisterUsableItem('pomme', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pomme', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_pomme'))
end)

--> Puis dans esx_basicneeds --> locales --> fr.lua et ajouter : 

['used_pomme'] = 'Vous avez utilisé 1x ~y~Pomme~s~'
