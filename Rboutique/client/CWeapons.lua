ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function OpenBoutiqueWeapon(aCoins)
    local BoutiqueSub = RageUI.CreateMenu('', "Bienvenue sur notre boutique")
    RageUI.Visible(BoutiqueSub, not RageUI.Visible(BoutiqueSub))
    while BoutiqueSub do
        Citizen.Wait(0)
        RageUI.IsVisible(BoutiqueSub, function()
            if WeaponBoutique == nil or json.encode(WeaponBoutique) == '[]' then
                RageUI.Separator('')
                RageUI.Separator('Aucun articles')
                RageUI.Separator('')
            else
                for k,v in pairs(WeaponBoutique) do
                   RageUI.Button(v.label, v.description, {RightLabel = v.price.. ' ~p~Nezerith'}, true, {
                       onActive = function()
                       end,
                       onSelected = function()
                           TriggerServerEvent('sBoutique:buyweapon', v.name, v.price, v.label)
                           RageUI.CloseAll()
                           Wait(150)
                       end
                   })
                end
            end
        end, function()
        end)

        if not RageUI.Visible(BoutiqueSub) then
            OpenBoutique()
            BoutiqueSub = RMenu:DeleteType('BoutiqueSub', true)
        end
    end
end