# -*- coding: utf-8 -*-
# Spotify Plugin for bot based on Polaris
# ByTiagoDanin - Telegram.me/tiagodanin

from __main__ import *
from utils import *

commands = [
	'^spotify',
	'^spo',
	'^s'
]

parameters = {('query', True)}

description = 'Returns results.\nAlias: /s, /spo'
action = 'typing'


def run(msg):
	input = get_input(msg['text'])

	if not input:
		doc = get_doc(commands, parameters, description)
		return send_message(msg['chat']['id'], doc, parse_mode="Markdown")

	url = 'https://api.spotify.com/v1/search'
	params = {
		'q': input,
		'type': 'track',
		'limit': '4'
	}

	jstr = requests.get(
	url,
		params=params,
	)

	if jstr.status_code != 200:
		return send_message(msg['chat']['id'], 'Erro connection.')

	spotify = json.loads(jstr.text)
	if spotify['tracks']['total'] == 0:
		return send_message(msg['chat']['id'], 'No results found.')

	text = '*Spotify Search*: "_' + input + '_"\n\n'
	for i in range(0, len(spotify['tracks']['items'])):
		title = spotify['tracks']['items'][i]['name'] +  ' - ' + spotify['tracks']['items'][i]['album']['name']
		if len(str(title)) > 48:
			title = title[:44] +  '...'
			stitle = title.replace('[', ' |').replace(']', '| ').replace('(', '').replace(')', '')
			surl = spotify['tracks']['items'][i]['external_urls']['spotify']
		text += U'• [' + stitle + '](' + surl + ')\n\n'

		send_message(msg['chat']['id'], text, parse_mode="Markdown")
