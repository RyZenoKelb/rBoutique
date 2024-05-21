ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('sBoutique:BuyVehicle')
AddEventHandler('sBoutique:BuyVehicle', function(model, price, label)
    local _src = source
    local source = source;
    local identifier = GetIdentifiers(source);
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayer = ESX.GetPlayerFromId(source)
        OnProcessCheckout(source, price, string.format("Achat de : %s", label), function()
            local plate = CreateRandomPlateText()
            LiteMySQL:Insert('owned_vehicles', {
                owner = xPlayer.identifier,
                plate = plate,
                vehicle = json.encode({ model = GetHashKey(model), plate = plate }),
                type = 'car',
                state = 1,
                label = label,
                boutique = 1,
            })
            xPlayer.showNotification("<C>Vous avez acheter : " .. label .. " sur la boutique !")
            sendtoVehicule('Coins - LOGS', '[ARME-Boutique] \n' ..GetPlayerName(source).. '\nViens d\'acheter un véhicule\nVéhicule : ' ..SecurityVehicles[model].model..'\nPrix : ' ..SecurityVehicles[model].price.. '', 3124441)
    end, function()
        xPlayer.showNotification("<C>~b~Vous ne posséder pas les points nécessaires")
        return
    end)
end)

RegisterCommand('givevehicule', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'fondateur' then
        local plate = CreateRandomPlateText()
        LiteMySQL:Insert('owned_vehicles', {
            owner = xPlayer.identifier,
            plate = plate,
            label = args[1],
            vehicle = json.encode({ model = GetHashKey(args[1]), plate = plate }),
            type = args[2],
            state = 1,
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(600000)
        local allPlayers = GetPlayers()

        for i=1, #allPlayers, 1 do
            local license = nil
            for _,v in pairs(GetPlayerIdentifiers(allPlayers[i])) do
                if string.find(v, "license:") then
                    license = v
                    break
                end
            end
            TriggerClientEvent('esx:showNotification', allPlayers[i], 'N\'hésitez pas a faire un tour sur notre magnifique boutique ( F1 ).', 'CHAR_CALIFORNIA')
        end
    end
end)

function sendtoVehicule (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "wEBHOOKS"
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