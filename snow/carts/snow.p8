pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function init_snow(speed, num)
  if not speed then speed = 1 end
  if not num then num = 128 end
  local snows = {}
  for i=1, 128 do
      local s = {
          n = i,
          landed=false,
          x=rnd(128),
          y=rnd(128),
          speed=rnd(2)+1
      }
      add(snows, s)
  end
  local timer = newtimer()

  local function update()
    for s in all(snows) do
        if not s.landed then
            s.y += s.speed
        end
        if s.y >= 100 and not s.landed then
            s.y = 100
            s.landed = true
            timer.add_timeout('snow_melt'..s.n, 1, function()
                s.landed = false
                s.y = 0
                s.x = rnd(128)
            end)
        end
    end
    timer.update()
  end

  local function draw()
    for s in all(snows) do
        pset(s.x, s.y, 6)
    end
  end

  return {
    update = update,
    draw = draw,
  }
end

function _init()
    snow = init_snow()
end

function _update()
    snow.update()
end

function _draw()
    cls()
    snow.draw()
end

-->8
newtimer = function ()
    local o = {
        timers = {}
    }
    o.add_timeout = function (name, timeout, callback)
        local start = time()
        local t = {'timeout', start, timeout, callback}
        o.timers[name] = t
    end
    o.add_interval = function (name, interval, callback)
        local start = time()
        local t = {'interval', start, interval, callback}
        o.timers[name] = t
    end
    o.del = function (name)
        o.timers[name] = nil
    end
    o.update = function ()
        now = time()
        for name, timer in pairs(o.timers) do
            timer_type, timer_start, timeout, callback = timer[1], timer[2], timer[3], timer[4]
            if timer_type == 'timeout' then
                if now - timer_start >= timeout then
                    callback()
                    o.del(name)
                end
            elseif timer_type == 'interval' then
                if now - timer_start >= timeout then
                    callback()
                    o.add_interval(name, timeout, callback)
                end
            end
        end
    end
    return o
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
