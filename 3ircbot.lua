#!/usr/bin/env lua5.2

-- 3ircbot - <3 ii
-- work in progress

local Version = '0.1'
local Posix = require 'posix'
local Tbox = require 'tbox'
local II = {}
local Config = {
  server = "camelia.2ion.de",
  port = 6669,
  nickname = "3ircbot",
  fullname = "3ircbot!",
  prefix = "./irc.io",
  channels = {}
}

local function printf(...)
  io.write(string.format(...)..'\n')
end

local function printfb(...)
  io.write(Tbox(string.format(...))..'\n')
end

local function assert_arg_type(v, type)
  assert(v and type(v) == type)
end

local function register_hook(f, channels, cond)
  assert_arg_type(f, 'function')
  assert_arg_type(channels, 'table')
  assert_arg_type(cond, 'table')
  for _,c in ipairs(channels) do
    if not Config.channels[c] then
      Config.channels[c] = { { cond, f } }
    else
      table.insert(Config.channels[c], { cond, f })
    end
  end
  return f
end

local function fork_ii()
  local r, w = Posix.pipe()
  local pid = Posix.fork()
  if pid == 0 then -- child
    Posix.close(w)
    local h = io.popen("./ii.bin" ..
      " -i " .. Config.prefix     ..
      " -n " .. Config.nickname   ..
      " -s " .. Config.server     ..
      " -p " .. Config.port       ..
      " -f " .. Config.fullname,
      "w")
      while true do
        local b = Posix.read(r, 1)
        if not b or h:write(b) then break end
      end
      Posix._exit(0)
  else
    Posix.close(r)
    return w
  end
end

local function ii_write(s)
  assert_arg_type(s, 'string')
  return Posix.write(II.wpipe, s)
end

local function ii_join()
  for c,_ in pairs(Config.channels) do
    ii_write("/j " .. c)
  end
end

local function ii_collect_pipes(channel)
  local function channelpath(c)
    return string.format("%s/%s/%s",
      Config.prefix,
      Config.server,
      c)
  end
  for c,_ in pairs(Config.channels) do
    local p = channelpath(c)
    Config.channels[c].pout = p..'/out'
    Config.channels[c].pin = p..'/in'
    assert(access(p, "rx"), "No access to channel directory: "..c)
    assert(access(Config.channels[c].pout, "r") and access(Config.channels[c].pin, "w"),
      "No access to channel FIFOs: "..c)
  end
  assert(access(Config.prefix, "rx"))
  II.pin = Config.prefix..'/in'
  II.pout = Config.prefix..'/out'
  assert(access(II.pin, "w") and access(II.pout, "r"))
end

-- main

printfb("<3ircbot")
printf([[Bot version: %s
Server: %s
Port: %s
Nick: %s
Full name: %s]], Version, Config.server, Config.port, Config.nickname, Config.fullname)



--II.wpipe = fork_ii()
