fx_version 'adamant'
games {'rdr3'}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Nosmakos'
description 'TPZ-CORE - Stables'
version '1.0.1'

ui_page 'html/index.html'

shared_scripts { 
    'config/config.lua', 
    'config/config_horses.lua', 
    'config/config_wagons.lua', 
    'config/config_horses_equipment.lua', 
    'config/config_wagons_equipment.lua', 
    'locales.lua',
}

client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' }

dependencies {
    'tpz_core',
    'tpz_characters',
    'tpz_inventory',
    'tpz_menu_base',
    'tpz_inputs',
}


files { 'html/**/*' }

lua54 'yes'
