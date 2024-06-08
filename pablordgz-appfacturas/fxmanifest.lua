fx_version "cerulean"
game "gta5"

title "pablordgz appfacturas"
description "billing app for lbphone and pefcl"
author "pablordgz"

client_script "client.lua"
server_script "server.lua"

files {
    "ui/**/*"
}

ui_page "ui/index.html"
shared_script '@es_extended/imports.lua'
server_script '@oxmysql/lib/MySQL.lua'

lua54 'yes'
