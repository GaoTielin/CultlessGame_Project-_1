-->scene-2
function init_snow(speed, num)
  if not speed then speed = 1 end
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
