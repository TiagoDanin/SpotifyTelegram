--Base
--Get URL
local function get_spotify(search)
  local BASE_URL = "https://api.spotify.com/v1/search"
  local URLP = "?q=".. (URL.escape(search) or "").."&type=track&limit=5" --limit 5

  --Decode json
  local decj, tim = https.request(BASE_URL..URLP)
  if tim ~=200 then return nil  end
  --Table
  local spotify = json:decode(decj)
  local tables = {}
  for pri,result in ipairs(spotify.tracks.items) do
    table.insert(tables, {
        spotify.tracks.total,
        result.name,
        result.external_urls.spotify
      })
  end
  return tables
end
--Print table
local function prints(tables)
  -- Beta show number music:
  --local total=""
  --for pri,cont in ipairs(tables) do
  --  total=cont[1]
  --end
  local gets=""
  for pri,cont in ipairs(tables) do
    gets=gets.."▶️ "..cont[2].." - "..cont[3].."\n"
  end
  local thend = gets --.."Total "..total.."Music" -- OFF
  return thend
end

local function run(msg, matches)
  local tables = get_spotify(matches[1])
  local text = prints(tables)
  if text == "" then --Or if text == "Total  Music"
    text = "Not found music" -- MSG Erro
  end
  return text
end
--Run
return {
  description = "Track Spotify byTiagoDanin",
  usage = "!Spotify + Name Track",
  patterns = {
    "^![Ss]potify$",
    "^![Ss]potify (.*)$",
    "^/[Ss]potify$",
    "^/[Ss]potify (.*)$",
  },
  run = run
}
