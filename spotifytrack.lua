do

local BASE_URL = "https://api.spotify.com/v1/search"

local function get_spotify(STrack)
  print("Spotify, ", STrack)
  local url = BASE_URL
  url = url..'?q='..STrack..'&type=track&limit=1'

  local decj, tim, h = http.request(url)
  if tim ~= 200 then return nil end

  local spotify = json:decode(decj)
  local Track = spotify.tracks.items.name
  local Surl = spotify.tracks.items.external_urls
  local resu = 'Track is '..Track..' URL: '..Surl
  
  return resu
end

local function run(msg, matches)
  local Track = ''

  if matches[1] ~= '!spotify' then 
    Track = matches[1]
  end
  local text = get_spotify(Track)
  if not text then
    text = 'Erro'
  end
  return text
end

return {
  description = "Track spotify", 
  usage = "!spotify (Track)",
  patterns = {
    "^!spotify$",
    "^%.[s|S]potify (.*)$"
  }, 
  run = run 
}

end
