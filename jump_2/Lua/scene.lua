-->scene-2
function init_snow(speed, num, hit_spr_flag)
  if not speed then speed = 1 end
  if not hit_spr_flag then hit_spr_flag = 2 end
  if not num then num = 128 end
  local snows = {}
  for i=1, num do
      local s = {
          n = i,
          landed=false,
          x=rnd(128),
          y=rnd(128),
          speed=rnd(2)+speed
      }
      add(snows, s)
  end
  local timer = newtimer()

  local function is_land(sp)
    if fget(mget(sp.x/8, (sp.y+speed)/8)) == hit_spr_flag then
      sp.y = flr((sp.y+speed)/8)*8 - 1
      return true
    end
  end

  local function update()
    for s in all(snows) do
        if not s.landed then
            s.y += s.speed
        end
        if is_land(s) and not s.landed then
            -- s.y = 100
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
