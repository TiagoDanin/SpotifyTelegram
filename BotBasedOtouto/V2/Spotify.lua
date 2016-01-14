-- Spotify Plugin for bot based on otouto
-- ByTiagoDanin - Telegram.me/tiagodanin
local PLUGIN = {}

PLUGIN.doc = [[
  /spotify <musica>
  Track Spotify byTiagoDanin.
]]

PLUGIN.triggers = {
  '^/spotify'
}

function PLUGIN.action(msg)

  local input = get_input(msg.text)
  if not input then
    return send_msg(msg, PLUGIN.doc)
  end
  --URL API
  local BASE_URL = "https://api.spotify.com/v1/search"
  local URLP = "?q=".. (URL.escape(input) or "").."&type=track&limit=5" -- Limit 5
  -- Decode json
  local decj, tim = HTTPS.request(BASE_URL..URLP)
  if tim ~=200 then return nil  end
  -- Table
  local spotify = JSON.decode(decj)
  local tables = {}
  for pri,result in ipairs(spotify.tracks.items) do
    table.insert(tables, {
        spotify.tracks.total,
        result.name,
        result.external_urls.spotify
      })
  end
  -- Prit Tables
  local gets = ""
  for pri,cont in ipairs(tables) do
    gets=gets.."▶️ "..cont[2].." - "..cont[3].."\n"
  end
  -- ERRO 404
  local text_end = gets -- Text END
  if gets == "" then
    text_end = "Not found music"
  end
  -- Send MSG
  send_message(msg.chat.id, text_end)

end

return PLUGIN