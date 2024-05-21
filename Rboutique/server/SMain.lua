ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetIdentifiers(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    else
        error("source is nil")
    end
end

ESX.RegisterServerCallback('sBoutique:getPoints', function(source, callback)
    local identifier = GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")

        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            if (result[1]["SUM(points)"] ~= nil) then
                callback(result[1]["SUM(points)"])
            else
                print('[Info] retrieve points nil')
                callback(0)
            end
        end);
    else
        callback(0)
    end

end)

function OnProcessCheckout(source, price, transaction, onAccepted, onRefused)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetIdentifiers(source);
    if (identifier['fivem']) then
        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
        MySQL.Async.fetchAll("SELECT SUM(points) FROM tebex_players_wallet WHERE identifiers = @identifiers", {
            ['@identifiers'] = after
        }, function(result)
            local current = tonumber(result[1]["SUM(points)"]);
            if (current ~= nil) then
                if (current >= price) then
                    LiteMySQL:Insert('tebex_players_wallet', {
                        identifiers = after,
                        transaction = transaction,
                        price = '0',
                        currency = 'Points',
                        points = -price,
                    });
                    onAccepted();
                else
                    onRefused();
                    xPlayer.showNotification('<C>Vous ne procédez pas les points nécessaires pour votre achat visité notre boutique.')
                end
            else
                onRefused();
                print('[Info] retrieve points nil')
            end
        end);
    else
        onRefused();
    end
end

local characters = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

function CreateRandomPlateText()
    local plate = ""
    math.randomseed(GetGameTimer())
    for i = 1, 4 do
        plate = plate .. characters[math.random(1, #characters)]
    end
    plate = plate .. ""
    for i = 1, 3 do
        plate = plate .. math.random(1, 9)
    end
    return plate
end

RegisterServerEvent('BoutiqueBucket:SetEntitySourceBucket')
AddEventHandler('BoutiqueBucket:SetEntitySourceBucket', function(valeur)
    if valeur then
        SetPlayerRoutingBucket(source, source+1)
    else
        SetPlayerRoutingBucket(source, 0)
    end
end)

RegisterCommand('addPoints', function(source, args)
    if source == 0 then
        local identifier = GetIdentifiers(args[1]);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            LiteMySQL:Insert('tebex_players_wallet', {
                identifiers = after,
                transaction = 'Ajout de Nezerith via la console',
                price = 0,
                currency = 'Points',
                points = args[2],
            });
        else
            print('LE JOUEUR N\'A LIER AUCUN COMPTE FIVEM')
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.getGroup() == 'createur' then
            local Target = ESX.GetPlayerFromId(args[1])
            local identifier = GetIdentifiers(args[1]);
            if (identifier['fivem']) then
                local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                LiteMySQL:Insert('tebex_players_wallet', {
                    identifiers = after,
                    transaction = 'Ajout de Nezerith par '..GetPlayerName(source),
                    price = 0,
                    currency = 'Points',
                    points = args[2],
                });
                Target.showNotification('Vous avez reçu ~b~'..args[2].. ' ~w~Nezerith')
            else
                xPlayer.showNotification('<C>Le joueur n\'as aucun compte FiveM lier')
            end
        end
    end
end)

RegisterCommand('removePoints', function(source, args)
    if source == 0 then
        local identifier = GetIdentifiers(args[1]);
        if (identifier['fivem']) then
            local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
            LiteMySQL:Insert('tebex_players_wallet', {
                identifiers = after,
                transaction = 'Retrait de Nezerith via la console',
                price = 0,
                currency = 'Points',
                points = '-'..args[2],
            });
        else
            print('LE JOUEUR N\'A LIER AUCUN COMPTE FIVEM')
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.getGroup() == 'createur' then
            local Target = ESX.GetPlayerFromId(args[1])
            local identifier = GetIdentifiers(args[1]);
            if (identifier['fivem']) then
                local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                LiteMySQL:Insert('tebex_players_wallet', {
                    identifiers = after,
                    transaction = 'Retrait de Nezerith par '..GetPlayerName(source),
                    price = 0,
                    currency = 'Points',
                    points = '-'..args[2],
                });
                Target.showNotification('Vous avez perdu ~b~'..args[2].. ' ~w~Nezerith')
            else
                xPlayer.showNotification('<C>Le joueur n\'as aucun compte FiveM lier')
            end
        end
    end
end)