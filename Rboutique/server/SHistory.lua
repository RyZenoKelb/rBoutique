ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('sBoutique:getHistory', function(source, callback)
    local identifier = GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            callback(result)
        else
            print('[Exceptions] retrieve category is nil')
            callback({ })
        end
    end
end)

RegisterCommand('history', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == '_dev' then
        if args[1] ~= nil then
            openHistory(source, args[1])
        else
            xPlayer.showNotification('<C>Vous devez mettre une ID')
        end
    end
end)

function openHistory(source, player)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetIdentifiers(player);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        local count, result = LiteMySQL:Select('tebex_players_wallet'):Where('identifiers', '=', after):Get();
        if (result ~= nil) then
            TriggerClientEvent('sBoutique:retrieveHistoryClient', source, result)
        else
            xPlayer.showNotification('<C>Cette personne n\'a pas de FiveM lier')
        end
    end
end