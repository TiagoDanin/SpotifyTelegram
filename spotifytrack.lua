--Base
--Get URL
local function get_spotify(search)
  local BASE_URL = "https://api.spotify.com/v1/search"
  local URLP = "?q=".. (URL.escape(search) or "").."&type=track&limit=3" --limit 3

  --decode json
  local decj, tim = https.request(BASE_URL..URLP)
  if tim ~=200 then return nil  end
  --Table
  local spotify = json:decode(decj)
  local tables = {}
  for pri,result in ipairs(spotify.tracks.items) do
    table.insert(tables, {
        result.name,
        result.external_urls.spotify
      })
  end
  return tables
end
--Print table
local function prints(tables)
  local gets=""
  for pri,cont in ipairs(tables) do
    gets=gets.."▶️ "..cont[1].." - "..cont[2].."\n"
  end
  return gets
end

local function run(msg, matches)
  local tables = get_spotify(matches[1])
  if not tables then
    tables = '🔴 Erro'
  end
  return prints(tables)
end
--Run
return {
  description = "✅ Track spotify byTiagoDanin",
  usage = "!spotify + Name Track",
  patterns = {
    "^!spotify$",
    "^!Spotify$",
    "^!spotify (.*)$",
    "^!Spotify (.*)$",
    "^/spotify$",
    "^/Spotify$",
    "^/spotify (.*)$",
    "^/Spotify (.*)$"
  },
  run = run
}
