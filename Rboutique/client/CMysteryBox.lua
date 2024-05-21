ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local index = {
    list = 1
}

local Button = 1

local Action = {
   '~y~Visualiser~s~',
   '~g~Acheter~s~'
}

function OpenMysteryBoxBoutique(aCoins)
    local BoutiqueSub = RageUI.CreateMenu('', "Que voulez-vous faire ?")
    RageUI.Visible(BoutiqueSub, not RageUI.Visible(BoutiqueSub))
    while BoutiqueSub do
        Citizen.Wait(0)
        RageUI.IsVisible(BoutiqueSub, function()
            if BoutiqueMysteryBox == nil or json.encode(BoutiqueMysteryBox) == '[]' then
                RageUI.Separator('')
                RageUI.Separator('Aucun articles')
                RageUI.Separator('')
            else
                for k,v in pairs(BoutiqueMysteryBox) do
                    RageUI.List(v.label..' • ~y~'..v.price.. '~s~', Action, index.list, v.description, {}, true, {
                        onActive = function()
                        end,
                        onListChange = function(Index, Item)
                            index.list = Index;
                            Button = Index;
                        end,
                        onSelected = function()
                            if Button == 1 then
                                OpenMenuPreviewCaisse(v.model)
                            elseif Button == 2 then
                                RageUI.CloseAll()
                                TriggerServerEvent('sBoutique:process_checkout_case', v.model)
                            end
                        end
                    })
                end
            end
        end, function()
        end)

        if not RageUI.Visible(BoutiqueSub) then
            BoutiqueSub = RMenu:DeleteType('BoutiqueSub', true)
        end
    end
end

function OpenMenuPreviewCaisse(model)
    local CaissePreview = RageUI.CreateMenu('Boutique Nezeria', "Bienvenue sur notre boutique")
    RageUI.Visible(CaissePreview, not RageUI.Visible(CaissePreview))
    while CaissePreview do
        Citizen.Wait(0)
        RageUI.IsVisible(CaissePreview, function()
            if model == 'case_1' then 
                caisselabel = '~c~Argent'
            elseif model == 'case_2' then
                caisselabel = '~y~Gold'
            elseif model == 'case_3' then
                caisselabel = '~b~Diamond'
            else
                caisselabel = 'Caisse Temporaire'
            end
            RageUI.Separator('Prévisualisation de la caisse : '..caisselabel)
            for k,v in pairs(VisualitionCaisse[model]) do
                if v.rarity == 3 then
                    RageUI.Button(v.label, nil, {RightLabel = '~y~Mythique'}, true, {
                        onActive = function()
                        end,
                        onSelected = function()
        
                        end
                    })
                end
            end
            for k,v in pairs(VisualitionCaisse[model]) do
                if v.rarity == 2 then
                    RageUI.Button(v.label, nil, {RightLabel = '~b~Rare'}, true, {
                        onActive = function()
                        end,
                        onSelected = function()
        
                        end
                    })
                end
            end
            for k,v in pairs(VisualitionCaisse[model]) do
                if v.rarity == 1 then
                    RageUI.Button(v.label, nil, {RightLabel = '~g~Commun'}, true, {
                        onActive = function()
                        end,
                        onSelected = function()
        
                        end
                    })
                end
            end
        end, function()
        end)

        if not RageUI.Visible(CaissePreview) then
            OpenMysteryBoxBoutique()
            CaissePreview = RMenu:DeleteType('BoutiqueSub', true)
        end
    end
end


local picture;
local mysterybox = RageUI.CreateMenu("Caisse Mystère", "Bonne chance !")

RegisterNetEvent('sBoutique:sCaisseOpenC')
AddEventHandler('sBoutique:sCaisseOpenC', function(animations, name, message, model)
    RageUI.Visible(mysterybox, not RageUI.Visible(mysterybox))
    Citizen.Wait(0)
    for k, v in pairs(animations) do
        picture = v.name
        RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
        if v.time == 5000 then
            RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
            ESX.ShowNotification("~y~Bravo !~s~ "..message)
            Wait(4000)
        end
        Citizen.Wait(v.time)
    end
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(10)

        RageUI.IsVisible(mysterybox, function()

        end, function()
            if (picture) then
                RageUI.CaissePreviewOpen("vehicles", picture)
            end
        end)
    end
end)