ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local labeltype = nil

function random(x, y)
    local u = 0;
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

sBoutiqueBoutique = sBoutiqueBoutique or {};
sBoutiqueBoutique.Cache = sBoutiqueBoutique.Cache or {}
sBoutiqueBoutique.Cache.Case = sBoutiqueBoutique.Cache.Case or {}

function GenerateLootbox(source, box, list)
    local chance = random(1, 100)
    local gift = { category = 1, item = 1 }
    local minimalChance = 4

    local identifier = GetIdentifiers(source);
    if (sBoutiqueBoutique.Cache.Case[source] == nil) then
        sBoutiqueBoutique.Cache.Case[source] = {};
        if (sBoutiqueBoutique.Cache.Case[source][box] == nil) then
            sBoutiqueBoutique.Cache.Case[source][box] = {};
        end
    end
    if chance <= minimalChance then
        local rand = random(1, #list[3])
        sBoutiqueBoutique.Cache.Case[source][box][3] = list[3][rand]
        gift.category = 3
        gift.item = list[3][rand]
    elseif (chance > minimalChance and chance <= 30) then
        local rand = random(1, #list[2])
        sBoutiqueBoutique.Cache.Case[source][box][2] = list[2][rand]
        gift.category = 2
        gift.item = list[2][rand]
    else
        local rand = random(1, #list[1])
        sBoutiqueBoutique.Cache.Case[source][box][1] = list[1][rand]
        gift.category = 1
        gift.item = list[1][rand]
    end
    local finalList = {}
    for _, category in pairs(list) do
        for _, item in pairs(category) do
            local result = { name = item, time = 150 }
            table.insert(finalList, result)
        end
    end
    table.insert(finalList, { name = gift.item, time = 5000 })
    return finalList, gift.item
end

RegisterServerEvent('sBoutique:process_checkout_case')
AddEventHandler('sBoutique:process_checkout_case', function(type)
    local _src = source
    local source = source;
    if (source) then
        local identifier = GetIdentifiers(source);
        local xPlayer = ESX.GetPlayerFromId(source)
        if type == "case_1" then
            labeltype = "Caisse Gold"
        elseif type == "case_2" then
            labeltype = "Caisse Diamond"
        elseif type == "case_3" then
            labeltype = "Caisse Ruby"
        end
        if (xPlayer) then
            if type == "case_1" then
                OnProcessCheckout(source, 1000, "Achat d'une caisse (Gold)", function()
                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box[boxId])
                    local giveReward = {
                        ["vehicle"] = function(_s, license, player)
                            if result == 'mule' then 
                                local plate = CreateRandomPlateText()
                                LiteMySQL:Insert('owned_vehicles', {
                                    owner = xPlayer.identifier,
                                    plate = plate,
                                    label = result,
                                    vehicle = json.encode({ model = GetHashKey(result), plate = plate }),
                                    state = 1,
                                    type = 'car',
                                })
                                LiteMySQL:Insert('open_car', {
                                    owner = license,
                                    plate = plate,
                                    NB = 1
                                });
                            else
                                local plate = CreateRandomPlateText()
                                LiteMySQL:Insert('owned_vehicles', {
                                    owner = xPlayer.identifier,
                                    plate = plate,
                                    label = label,
                                    vehicle = json.encode({ model = GetHashKey(model), plate = plate }),
                                    type = 'car',
                                    state = 1,
                                    boutique = 1,
                                })
                                LiteMySQL:Insert('open_car', {
                                    owner = xPlayer.identifier,
                                    plate = plate,
                                    NB = 1
                                });
                            end
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 250)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            xPlayer.addAccountMoney('bank', quantity)
                        end,
                    }

                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    TriggerClientEvent('sBoutique:sCaisseOpenC', source, lists, result, r.message)
                    sendToCaisses('SBoutique - LOGS', '[PACK-Boutique] \n' ..GetPlayerName(source).. ' viens d\'ouvrir la Caisse Mystère : ' ..type.. '\nGagné : ' ..result.. '', 3124441)
                    end, function()
                    xPlayer.showNotification("<C>~b~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_2" then
                OnProcessCheckout(source, 2500, "Achat d'une caisse (Diamond)", function()
                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box2[boxId])
                    local giveReward = {
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = license,
                                plate = plate,
                                label = result,
                                vehicle = json.encode({ model = GetHashKey(result), plate = plate }),
                                state = 1,
                                type = 'car',
                                boutique = 1
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = license,
                                plate = plate,
                                NB = 1
                            });
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end

                    TriggerClientEvent('sBoutique:sCaisseOpenC', source, lists, result, r.message)
                    sendToCaisses('SBoutique - LOGS', '[PACK-Boutique] \n' ..GetPlayerName(source).. ' viens d\'ouvrir la Caisse Mystère : ' ..type.. '\nGagné : ' ..result.. '', 3124441)
                    end, function()
                    xPlayer.showNotification("<C>~b~Vous ne posséder pas les points nécessaires")
                end)
            elseif type == "case_3" then
                OnProcessCheckout(source, 5000, "Achat d'une caisse (Ruby)", function()
                    local boxId = 1;
                    local lists, result = GenerateLootbox(source, boxId, box3[boxId])
                    local giveReward = {
                        ["Nezerith"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            if (identifier['fivem']) then
                                local _, fivemid = identifier['fivem']:match("([^:]+):([^:]+)")
                                LiteMySQL:Insert('tebex_players_wallet', {
                                    identifiers = fivemid,
                                    transaction = "Gain dans la boîte Nezerith",
                                    price = '0',
                                    currency = 'Points',
                                    points = quantity,
                                });
                            end
                        end,
                        ["vehicle"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = license,
                                plate = plate,
                                label = result,
                                vehicle = json.encode({ model = GetHashKey(result), plate = plate }),
                                state = 1,
                                type = 'car',
                                boutique = 1
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = license,
                                plate = plate,
                                NB = 1
                            });
                        end,
                        ["helico"] = function(_s, license, player)
                            local plate = CreateRandomPlateText()
                            LiteMySQL:Insert('owned_vehicles', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                label = label,
                                vehicle = json.encode({ model = GetHashKey(model), plate = plate }),
                                type = 'aircraft',
                                state = 1,
                                boutique = 1,
                            })
                            LiteMySQL:Insert('open_car', {
                                owner = xPlayer.identifier,
                                plate = plate,
                                NB = 1
                            });
                        end,
                        ["weapon"] = function(_s, license, player)
                            xPlayer.addWeapon(result, 150)
                        end,
                        ["money"] = function(_s, license, player)
                            local before, after = result:match("([^_]+)_([^_]+)")
                            local quantity = tonumber(after)
                            player.addAccountMoney('bank', quantity)
                        end,
                    }
                    local r = reward[result];
                    if (r ~= nil) then
                        if (giveReward[r.type]) then
                            giveReward[r.type](source, identifier['license'], xPlayer);
                        end
                    end
                    if (identifier['fivem']) then
                        local before, after = identifier['fivem']:match("([^:]+):([^:]+)")
                        LiteMySQL:Insert('tebex_players_wallet', {
                            identifiers = after,
                            transaction = r.message,
                            price = '0',
                            currency = 'Box',
                            points = 0,
                        });
                    end
                    TriggerClientEvent('sBoutique:sCaisseOpenC', source, lists, result, r.message)
                    sendToCaisses('SBoutique - LOGS', '[PACK-Boutique] \n' ..GetPlayerName(source).. ' viens d\'ouvrir la Caisse Mystère : ' ..type.. '\nGagné : ' ..result.. '', 3124441)
                    end, function()
                    xPlayer.showNotification("<C>~b~Vous ne posséder pas les points nécessaires")
                end)
            end
        else
            print('[Error] Failed to retrieve ESX player')
        end
    else
        print('[Error] Failed to retrieve source')
    end
end)

function sendToCaisses (name,message,color)
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