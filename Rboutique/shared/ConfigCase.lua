VisualitionCaisse = {
    ['case_1'] = {
        {model = 'WEAPON_PISTOL', label = 'Pistolet', rarity = 2},
        {model = 'tmaxdx', label = 'Tmax', rarity = 3},
        {model = 'money_50000', label = '50000$', rarity = 1},
    },
    ['case_2'] = {
        {model = 'WEAPON_APPISTOL', label = 'Pistolet automatique', rarity = 2},
        {model = 'a45', label = 'A45 AMG', rarity = 3},
        {model = 'money_350000', label = '350000$', rarity = 1},
    },
    ['case_3'] = {
        {model = 'WEAPON_COMBATPDW', label = 'Combat PDW', rarity = 2},
        {model = 'VENENO', label = 'Lamborghini Veneno', rarity = 3},
        {model = 'money_750000', label = '750000$', rarity = 1},
    }
}

reward = {
    -- Caisse gold
    ["WEAPON_PISTOL"] = { type = "weapon", message = "Vous avez gagner un ~b~Pistolet." },
    ["money_75000"] = { type = "money", message = "Vous avez gagner ~g~75000$." },
    ["tmaxdx"] = { type = "vehicle", message = "Vous avez gagner un ~y~TMax." },


    -- Caisse Diamond
    ["WEAPON_APPISTOL"] = { type = "weapon", message = "Vous avez gagner un ~b~Pistolet automatique." },
    ["money_350000"] = { type = "money", message = "Vous avez gagner ~g~350000$." },
    ["a45"] = { type = "vehicle", message = "Vous avez gagner une ~y~A45 AMG." },

    -- Caisse Ruby
    ["WEAPON_COMBATPDW"] = { type = "weapon", message = "Vous avez gagner une ~b~Combat PDW." },
    ["money_750000"] = { type = "money", message = "Vous avez gagner ~g~750000$." },
    ["venatus"] = { type = "vehicle", message = "Vous avez gagner une ~y~Lamborghini Veneno." },
}

box = {
    [1] = {
        [3] = {
            "tmaxdx",
        },
        [2] = {
            "WEAPON_PISTOL",
        },
        [1] = {
            "money_75000",
        },
    }
}

box2 = {
    [1] = {
        [3] = {
            "a45",
        },
        [2] = {
            "WEAPON_APPISTOL",
        },
        [1] = {
            "money_350000",
        },
    }
}

box3 = {
    [1] = {
        [3] = {
            "venatus",
        },
        [2] = {
            "WEAPON_COMBATPDW",
        },
        [1] = {
            "money_750000",
        },
    }
}