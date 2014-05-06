local Server = {}

function Server.new(host, port, nick, name, prefix)
  local _o = {}
  setmetatable(_o, { __index = Server })
  return _o:set(host, port, nick, name, prefix)
end

function Server:set(host, port, nick, name, prefix)
  self.host = host
  self.port = port
  self.nick = nick
  self.name = name
  self.prefix = prefix
  return self
end


