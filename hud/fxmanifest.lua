fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'qb-hud - Multi-Framework (QBCore, QBox, ESX)'
version '2.3.0'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
    'bridge/loader.lua',
    'bridge/notify.lua',
}

client_scripts {
    'bridge/client/*.lua',
    'client.lua',
    'HRSGears.lua',
}

server_scripts {
    'bridge/server/*.lua',
    'server.lua',
}

ui_page 'html/index.html'

files {
    'html/*',
    'html/index.html',
    'html/styles.css',
    'html/responsive.css',
    'html/app.js',
}
