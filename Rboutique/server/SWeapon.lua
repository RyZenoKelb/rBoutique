ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sBoutique:buyweapon')
AddEventHandler('sBoutique:buyweapon', function(weapon, price, label)
    local _src = source
    local source = source;
    local identifier = GetIdentifiers(source);
    local xPlayer = ESX.GetPlayerFromId(source)
    OnProcessCheckout(xPlayer.source, SecurityWeapons[weapon].price, string.format("Achat de : %s", label), function()
        xPlayer.addWeapon(SecurityWeapons[weapon].name, 250)
        xPlayer.showNotification("<C>Vous avez acheter : " .. SecurityWeapons[weapon].label .. " sur la boutique !")
        sendtoarme('aCoins - LOGS', '[ARME-Boutique] \n' ..GetPlayerName(source).. '\nViens d\'acheter une arme\nArme : ' ..SecurityWeapons[weapon].name..'\nPrix : ' ..SecurityWeapons[weapon].price.. '', 3124441)
    end, function()
        xPlayer.showNotification("<C>~b~Vous ne posséder pas les points nécessaires")
        return
    end)
end)

function sendtoarme (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discord.com/api/webhooks/1005171560279179275/5kXUJBKmm-9tp3h_tuQo3_rWegs2-PuN8jfan4Q4hak2qMSbcM1JQKwIav8z7jw4qvpF"
    local embeds = {  
        {

            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] =  {
            ["text"] = "Heure: " ..date_local.. "",
		},
	}
}

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 