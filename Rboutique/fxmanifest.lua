



fx_version "adamant"

game "gta5"

shared_scripts {
    -- Config --
    "shared/*.lua"
}

client_scripts {
    -- RageUI --
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    -- Client --
    "client/*.lua",
}

exports {
	"GetLevel",
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    -- Server --
    "server/*.lua",
}