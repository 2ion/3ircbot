local Server = {}
local Channel = require 'Channel'
local P = require 'posix'

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
  self.channels = {}
  return self
end

function Server:connect()
  local pid = P.fork()
  if pid == 0 then
    P._exit(
      P.exec("./ii.bin",
        " -i " .. self.prefix ..
        " -n " .. self.nick   ..
        " -s " .. self.server ..
        " -p " .. self.port   ..
        " -f " .. self.name)
    )
  end
  self.i = io.open(self:path('in'), 'w')
  self.o = io.open(self:path('out'), 'r')
  return self
end

function Server:path(s)
  return string.format("%s/%s", self.prefix, s)
end

function Server:write(s)
  self.i:write(s..'\n')
  return self
end

function Server:cmd(c, ...)
  if select('#', ...) == 0 then
    self:write('/'..c)
  else
    self:write(string.format("/%s %s", c, table.concat({...}, ' ')))
  end
  return self
end

function Server:quit()
  self:cmd('q')
end

function Server:join(chan)
  self:cmd('j')
end

function Server:loop()
  return 0
end
