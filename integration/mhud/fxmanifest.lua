fx_version 'cerulean'
games { 'gta5', 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'mhud'
author 'Stream Ember'
description 'MHud - temali NUI HUD kiti (FiveM + RedM)'
version '1.2.0'

lua54 'yes'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/channels.lua'

ui_page 'html/index.html'
-- Hazir yayin duzeni: ui_page 'html/games/gta5/index.html' (rdr2 | l4d2 | arena)

files {
  'html/index.html',
  'html/app.css',
  'html/app.js',
  'html/kit/css/*.css',
  'html/kit/css/themes/*.css',
  'html/kit/js/*.js',
  'html/kit/fonts/*.css',
  'html/kit/fonts/*.woff2',
  'html/games/shared/*.js',
  'html/games/shared/*.css',
  'html/games/gta5/*.html',
  'html/games/rdr2/*.html',
  'html/games/l4d2/*.html',
  'html/games/arena/*.html'
}
