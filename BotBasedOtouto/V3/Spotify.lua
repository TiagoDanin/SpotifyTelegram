-- Spotify Plugin for bot based on otouto
-- ByTiagoDanin - Telegram.me/tiagodanin

local command = 'spotify [type] <query>'
local doc = [[```
/spotify <query>
Returns results.

Use /spotify [type] for custom search.
Types: albums, artists, tracks, playlists
Alias: /s, /spo
```]]

local triggers = {
    '^/spotify[@'..bot.username..']*',
    '^/spo[@'..bot.username..']*',
    '^/s[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendMessage(msg.chat.id, doc, true, msg.message_id, true)
			return
		end
	end
	
	local type = 'track' --Default
	if get_word(input, 1) == 'tracks' then
		type = 'track'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'albums' then
		type = 'album'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'artists' then
		type = 'artist'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'playlists' then
		type = 'playlist'
		input = input:gsub(get_word(input, 1), '')
	end
	
    local url = 'https://api.spotify.com/v1/search?q='..(URL.escape(input) or '')..'&type='..type
    
    if msg.from.id == msg.chat.id then
		url = url .. '&limit=8'
	else
		url = url .. '&limit=4'
	end
    
    local jstr, res = HTTPS.request(url)
    if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end
	
	local spotify = JSON.decode(jstr)
	type = type..'s' -- Optimizes :)
	
	if spotify[tostring(type)].total == 0 then
	    sendReply(msg, config.errors.results)
	    return
	end
    
    local output = '*Spotify results for*_' .. input .. '('..type..')' .. '_ *:*\n'
    for i,v in ipairs(spotify[tostring(type)].items) do
    	
    	local more = ''
    	if type == 'tracks' then
    		more = ' - '..spotify.tracks.items[i].album.name
    	elseif type == 'albums' then
    		more = ' - '..spotify.albums.items[i].album_type
    	elseif type == 'playlists' then
    		more = ' - '..spotify.playlists.items[i].owner.id
    	end
    	
		local title = (spotify[tostring(type)].items[i].name .. more):gsub('%[.+%]', ''):gsub('&amp;', '&')
		if title:len() > 45 then
			title = title:sub(1, 42) .. '...'
		end
		local url = spotify[tostring(type)].items[i].external_urls.spotify
		if url:find('%)') then
			output = output .. '• ' .. title .. '\n' .. url:gsub('_', '\\_') .. '\n'
		else
			output = output .. '• [' .. title .. '](' .. url .. ')\n'
		end
	end
    
    sendMessage(msg.chat.id, output, true, nil, true)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
