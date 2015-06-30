do

local BASE_URL = "https://api.spotify.com/v1/search"

local function get_spotify(Track)
  print("Spotify, ", Track)
  local url = BASE_URL
  url = url..'?q='..Track..'&type=track&limit=10'

  local dec, t, h = http.request(url)
  if t ~= 200 then return nil end

  local spotify = json:decode(dec)
  local Track = tracks.items.name
  local Surl = tracks.items.external_urls
end

local function run(msg, matches)
  local Track = ''

  if matches[1] ~= '!spotift' then 
    STrack = matches[1]
  end
  local text = get_spotify(STrack)..Surl
  if not text then
    text = 'Erro'
  end
  return text
end

return {
  description = "Track spotify", 
  usage = "!spotify (STrack)",
  patterns = {
    "^!spotify$",
    "^!spotify (.*)$"
  }, 
  run = run 
}

end
