shared_script '@rc-hub/ai_module_fg-obfuscated.lua'
shared_script '@rc-hub/shared_fg-obfuscated.lua'
shared_script 'config.lua'
fx_version 'cerulean'
lua54 'yes'
game 'gta5'
ui_page 'html/index.html'
client_scripts {
    'client/*.lua'
}
files {
    'html/**',
    'config.lua',
}
escrow_ignore 'client/main.lua'
dependency '/assetpacks'


lua54 'yes'
dependency '/assetpacks'