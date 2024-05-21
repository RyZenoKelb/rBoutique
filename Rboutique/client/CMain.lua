ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local aCoins = 0

function RageUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 332 + 20 + 100, 7, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 332 + 20 + 100, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 332 + 332 + 100, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(332 + 10 + 100, 0, 332, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end

function OpenBoutique()
    local BoutiqueMain = RageUI.CreateMenu('', "Que voulez-vous choisir ?")
    ESX.TriggerServerCallback('sBoutique:getPoints', function(result)
        aCoins = result
    end)
    RageUI.Visible(BoutiqueMain, not RageUI.Visible(BoutiqueMain))
    while BoutiqueMain do
        Citizen.Wait(0)
        RageUI.IsVisible(BoutiqueMain, function()
            RageUI.Separator('↓ ~p~Vos Coins~s~ ↓')
            RageUI.Separator('Vos Nezerith : ~p~'..aCoins.. '')
            RageUI.Separator('↓ ~p~Nos catégories~s~ ↓')
            RageUI.Info('Boutique De ~p~Nezeria~s~', {'Votre Id : ','Vos ~p~Nezerith : '}, { GetPlayerServerId(PlayerId()), aCoins })
            RageUI.Button('∑ ~p~→~s~ Voir mes anciens achat(s)', 'Vous permet de voir vos anciens achats !', {RightLabel = ''}, true, {
                onSelected = function()
                    OpenHistoryMenu()
                end
            })
            RageUI.Button('∑ ~p~→~s~ Armes ~r~(NEW)', 'Equipe toi d\'armes afin de faire régner la terreur !', {RightLabel = ''}, true, {
                onSelected = function()
                    OpenBoutiqueWeapon(aCoins)
                end
            })
            RageUI.Button('∑ ~p~→~s~ Customisations d\'armes', 'Customise tes armes !', {RightLabel = ''}, true, {
                onSelected = function()
                    OpenCustomArmes()
                end
            })
            RageUI.Button('∑ ~p~→~s~ Véhicules ~r~(NEW)', 'Déplace toi plus rapidement !', {RightLabel = ''}, true, {
                onSelected = function()
                    OpenBoutiqueVehicles(aCoins)
                end
            })
            RageUI.Button('∑ ~p~→~s~ Caisses Mystères', 'A vos risques et périls :)', {RightLabel = ''}, true, {
                onSelected = function()
                    OpenMysteryBoxBoutique()
                end
            })
        end, function()
        end)

        if not RageUI.Visible(BoutiqueMain) then
            BoutiqueMain = RMenu:DeleteType('BoutiqueMain', true)
        end
    end
end

RegisterCommand("f1", function()
        OpenBoutique()
end, false)

RegisterKeyMapping('F1', 'Menu ~p~Boutique', 'keyboard', 'F1')