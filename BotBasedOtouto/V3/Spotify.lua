-- Spotify Plugin for bot based on otouto
-- ByTiagoDanin - Telegram.me/tiagodanin

local command = 'spotify <query>'
local doc = [[```
/spotify <query>
Returns results.
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

    local url = "https://api.spotify.com/v1/search?q=".. (URL.escape(input) or "") .."&type=track"
    
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
	
	if spotify.tracks.total == 0 then
	    sendReply(msg, config.errors.results)
	    return
	end
    
    local output = '*Spotify: Results for* _' .. input .. '_ *:*\n'
    for i,v in ipairs(spotify.tracks.items) do
		local title = (spotify.tracks.items[i].name..' - '..spotify.tracks.items[i].album.name):gsub('%[.+%]', ''):gsub('&amp;', '&')
		if title:len() > 48 then
			title = title:sub(1, 45) .. '...'
		end
		local url = spotify.tracks.items[i].external_urls.spotify
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
