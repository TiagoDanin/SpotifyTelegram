-- Lastfm Plugin for bot based on Yagop
-- Glanced at https://github.com/yagop/telegram-bot/blob/master/plugins/lastfm.lua
-- byTiagoDanin
function run(msg, matches, user)
  local username = matches[1]
  -- URL  
  local BASE_URL = 'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&format=json&limit=1'
  BASE_URL = BASE_URL..'&api_key=' -- >>> KEY
  BASE_URL = BASE_URL..'&user='..username
  local decjson, time = http.request(BASE_URL)
  if time ~=200 then return nil end
  -- JSon
  local lastfm = json:decode(decjson)
  if lastfm.error then
    return "Not user or incorrect name" -- ERRO 404
  end
  if not lastfm.recenttracks.track then
    return "No history" -- ERRO 404 Not User
  end
  -- Print
  local lastfm = lastfm.recenttracks.track[1] or lastfm.recenttracks.track
  local name = lastfm.name or 'Unknown'
  local artist
  if lastfm.artist then
    artist = lastfm.artist['#text']
  else
    artist = 'Unknown'
  end
  -- Send msg
  local text = name..' - '..artist
  local msg = "💿 Scrobble: "..text
  -- END
  return msg
end
--RUN
return {
  description = "Lastfm byTiagoDanin",
  usage = "!Lastfm + Name User",
  patterns = {
    "^![Ll]astfm$",
    "^![Ll]astfm (.*)$",
    "^/[Ll]astfm$",
    "^/[Ll]astfm (.*)$",
  }, 
  run = run
}
