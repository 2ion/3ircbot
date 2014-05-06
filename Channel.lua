local Channel = {}

function Channel.new(i, o, p)
  local _o = {}
  setmetatable(_o, { __index = Channel })
  _o:setpipes(i, o)
  return _o
end

function Channel:setpipes(i, o)
  self.i = io.open(i, "w")
  self.o = io.open(o, "r")
  return self
end

function Channel:write(s)
  self.i:write(s..'\n')
  return self
end

function Channel:read()
  return self.o:read("*l")
end

function Channel:part()
  self:write("/part")
end

return Channel
