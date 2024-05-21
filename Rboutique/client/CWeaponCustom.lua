ESX = nil

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local selected = nil;

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1000)
        local weapon = GetSelectedPedWeapon(PlayerPedId());
        if (weapon ~= GetHashKey("weapon_unarmed")) and (weapon ~= 966099553) and (weapon ~= 0) then
            if (selected ~= nil) and (weapon == GetHashKey("weapon_unarmed")) and (weapon == 966099553) and (weapon == 0) then
                selected = nil;
            end
            for i, v in pairs(ESX.GetWeaponList()) do
                if (GetHashKey(v.name) == weapon) then
                    selected = v
                end
            end
        else
            selected = nil;
        end

    end
end)

function OpenCustomArmes()
    local BoutiqueSub = RageUI.CreateMenu('', "Que voulez-vous ?")
    BoutiqueSub.onIndexChange = function(index)
        if (selected ~= nil) then
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index].hash)
            if (selected.components[index - 1] ~= nil) and (selected.components[index - 1].hash ~= nil) then
                RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index - 1].hash)
            end
            if (index == 1) then
                RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[#selected.components].hash)
            end
        end
    end
    RageUI.Visible(BoutiqueSub, not RageUI.Visible(BoutiqueSub))
    while BoutiqueSub do
        Citizen.Wait(0)
        RageUI.IsVisible(BoutiqueSub, function()
            if (selected) then
                if (ESX.Table.SizeOf(selected) > 0) then
                    for i, v in pairs(selected.components) do
                        RageUI.Button(v.label, nil, { RightLabel = "250 Pultions" }, true, {
                            onSelected = function()
                                variable = KeyboardInput("Écrivez ~g~OUI~s~/~p~NON~s~ pour acheter", "OUI", 3)
                                if variable == 'OUI' or variable == 'oui' then
                                    TriggerServerEvent('tebex:on-process-checkout-weapon-custom', selected.name, v.hash)
                                    ESX.ShowNotification("<C>Vous avez acheter "..v.label.." pour 250 Pultions")
                                else
                                    ESX.ShowNotification("<C>Vous avez annulez l'achat")
                                end
                            end,
                        })
                    end
                else
                    RageUI.Separator("Aucune personnalisation disponible")
                end
            else
                RageUI.Separator("Vous n'avez pas d'arme dans vos main")
            end
        end, function()
        end)

        if not RageUI.Visible(BoutiqueSub) then
            OpenBoutique()
            TriggerEvent('esx:restoreLoadout')
            BoutiqueSub = RMenu:DeleteType('BoutiqueSub', true)
        end
    end
end

AddEventHandler("cstmMenu", function()
    Wait(150)
    RageUI.Visible(wp, true)
end)
