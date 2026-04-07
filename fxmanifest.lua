fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'Hex Modifications'
description 'A simple report system'
version '1.0.0'

escrow_ignore {
    'config.lua'
}

-- Load config.lua first
shared_script 'config.lua'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/sounds/hover.mp3',
    'html/sounds/click.mp3',
    'html/sounds/submit.mp3'
}

ui_page 'html/index.html'
