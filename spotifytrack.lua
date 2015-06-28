do

local BASE_URL = "https://api.spotify.com/v1/search"

local function get_spotify(Track)
  print("Spotify, ", Track)
  local url = BASE_URL
  url = url..'?q='..Track..'&type=track&limit=10'

  local b, c, h = http.request(url)
  if c ~= 200 then return nil end

  local spotify = json:decode(b)
  local Track = name.name
end

local function run(msg, matches)
  local Track = ''

  if matches[1] ~= '!spotift' then 
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
    "^!spotify (.*)$"
    "^%.[s|S]potify (.*)$"
  }, 
  run = run 
}

end
