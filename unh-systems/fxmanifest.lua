fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

name         'unh-vehicle'
author       'JiPeg'
version      '1.0.0'
repository   'https://github.com/Ji-Peg'
description  'QTarget vehicle Menu'

shared_script '@es_extended/imports.lua'

dependencies {
	'/server:5181',
	'/onesync',
	'oxmysql',
}
client_scripts { 
	'client.lua'
}
server_scripts {
	'server.lua'
}