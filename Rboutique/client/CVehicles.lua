ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local LastVeh = nil
local InVehicle = false


local index = {
    list = 1
}

local Button = 1

local Action = {
    '~y~Visualiser~s~',
    '~g~Acheter~s~'
 }
 
function OpenBoutiqueVehicles(aCoins)
    local BoutiqueSub = RageUI.CreateMenu('', "Voici notre Catalogue ")
    local lastPos = GetEntityCoords(PlayerPedId())
    local rot = 1.0
    SetEntityCoords(PlayerPedId(), vector3(-74.9472, -812.6113, 325.1751))
    SetEntityHeading(PlayerPedId(), 184.531)
    TriggerServerEvent('BoutiqueBucket:SetEntitySourceBucket', true)
    RageUI.Visible(BoutiqueSub, not RageUI.Visible(BoutiqueSub))
    while BoutiqueSub do
        Citizen.Wait(0)
        RageUI.IsVisible(BoutiqueSub, function()
            for k,v in pairs(BoutiqueVehicles) do
                RageUI.List(v.label..' • ~b~'..v.price.. '~s~', Action, index.list, nil, {}, true, {
                    onActive = function()
                        FreezeEntityPosition(PlayerPedId(), true)
                        SetEntityVisible(PlayerPedId(), false, 0)
                        SetWeatherTypeNow('EXTRASUNNY')
                        NetworkOverrideClockTime(4, 0, 0)
                        SetFollowPedCamViewMode(4)
                        if LastVeh ~= nil then
                            rot = rot + 0.10
                            SetEntityHeading(LastVeh, rot)
                        end
                    end,
                    onListChange = function(Index, Item)
                        index.list = Index;
                        Button = Index;
                    end,
                    onSelected = function()
                        if Button == 1 then
                            if ESX.Game.IsSpawnPointClear(vector3(-75.16219, -819.2629, 325.1755), 100) then
                                ESX.Game.SpawnVehicle(v.model, vector3(-75.16219, -819.2629, 325.1755), 355.858, function(vehicle)
                                    LastVeh = vehicle
                                    FreezeEntityPosition(vehicle, true)
                                    SetVehicleDoorsLocked(vehicle, 2)
                                    SetEntityInvincible(vehicle, true)
                                    SetVehicleFixed(vehicle)
                                    SetVehicleDirtLevel(vehicle, 0.0)
                                    SetVehicleEngineOn(vehicle, true, true, true)
                                    SetVehicleLights(vehicle, 2)
                                    SetVehicleCustomPrimaryColour(vehicle, 33,33,33)
                                    SetVehicleCustomSecondaryColour(vehicle, 33,33,33)
                                end)
                            else
                                DeleteEntity(LastVeh)
                                ESX.Game.SpawnVehicle(v.model, vector3(-75.16219, -819.2629, 325.1755), 355.858, function(vehicle)
                                    LastVeh = vehicle
                                    FreezeEntityPosition(vehicle, true)
                                    SetVehicleDoorsLocked(vehicle, 2)
                                    SetEntityInvincible(vehicle, true)
                                    SetVehicleFixed(vehicle)
                                    SetVehicleDirtLevel(vehicle, 0.0)
                                    SetVehicleEngineOn(vehicle, true, true, true)
                                    SetVehicleLights(vehicle, 2)
                                    SetVehicleCustomPrimaryColour(vehicle, 33,33,33)
                                    SetVehicleCustomSecondaryColour(vehicle, 33,33,33)
                                end)
                            end
                        elseif Button == 2 then
                            TriggerServerEvent('sBoutique:BuyVehicle', v.model, v.price, v.label)
                            RageUI.CloseAll()
                        end
                    end
                })
            end
        end, function()
        end)

        if not RageUI.Visible(BoutiqueSub) then
            DeleteEntity(LastVeh)
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), true, 0)
            SetEntityCoords(PlayerPedId(), lastPos)
            SetFollowPedCamViewMode(1)
            TriggerServerEvent('BoutiqueBucket:SetEntitySourceBucket', false)
            NetworkOverrideClockTime(16, 0, 0)
            BoutiqueSub = RMenu:DeleteType('BoutiqueSub', true)
            OpenBoutique()
        end
    end
end