--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'unh-salarysystems'
author       'JiPeg'
version      '1.0.0'
repository   'https://github.com/Ji-Peg'
description  'Salary System 1h complet'

shared_script '@es_extended/imports.lua'

--[[ Manifest ]]--
dependencies {
	'/server:5181',
	--'/onesync',
	'oxmysql',
}
client_scripts {
	'@oxmysql/lib/MySQL.lua',
	'client/*.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

export 'Givepay'
export 'paytime'