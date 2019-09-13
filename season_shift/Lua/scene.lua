-->scene-2
function init_snow(speed, num, hit_spr_flag)
    if not speed then speed = 1 end
    if not hit_spr_flag then hit_spr_flag = 1 end
    if not num then num = 128 end
    local snows = {}
    for i = 1, num do
        local s = {
            n = i,
            x = rnd(128),
            y = rnd(128),
            speed = rnd(2) + speed
        }
        add(snows, s)
    end

    local function is_land(sp)
        if get_map_flage(sp.x, (sp.y + speed)) == hit_spr_flag then
            sp.y = flr((sp.y + speed) / 8) * 8 - 1
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
                    s.y = camera_location.y
                    s.x = rnd(128)  + camera_location.x
                end)
            end
        end
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


function init_cloud()
  local function update_location(need_x, speed)
    local cloud_x = need_x
    if cloud_x < -128 then
      cloud_x = 0
    end
    cloud_x = cloud_x - speed
    return cloud_x
  end
  local maps = {}

  local function init_map(x, y, map_x, map_y, width, height, speed)
    local m = {
      x = x,
      y = y,
      map_x = map_x,
      map_y = map_y,
      width = width,
      height = height,
      speed = speed,
      ex_x = 0,
      ex_y = 0,
    }
    m.update = function()
      m.ex_x = update_location(m.ex_x, m.speed)
    end
    add(maps, m)
  end

  init_map(112, 21, 0, 8, 16, 3, 0.2)--2
  init_map(112, 21, 128, 8, 16,  3, 0.2)
  -- init_map(112, 24, 0, 16, 16, 4, 0.3) --3
  -- init_map(112, 24, 128, 16, 16, 4, 0.3)
  init_map(112, 16, 0, 0, 16, 3, 0.4)--1
  init_map(112, 16, 128, 0, 16, 3, 0.4)
  -- init_map(112, 28, 0, 24, 16, 4, 0.5)--4
  -- init_map(112, 28, 128, 24, 16, 4, 0.5)

  local function update()
    if game_season ~= "winter" then
      for v in all(maps) do
        v.update()
      end
    end
  end

  local function draw()
    if game_season ~= "winter" then
      for m in all(maps) do
        map(m.x, m.y, m.map_x + m.ex_x + camera_location.x, m.map_y + camera_location.y, m.width, m.height)
      end
    end
  end
  return {
    update = update,
    draw = draw,
  }
end

function init_moon()
  local moon = {}
    moon.x = 336
  moon.draw = function()
    moon.x -= 0.2
    if moon.x <= -128 then
      moon.x = 720
    end
    map(96, 16, moon.x, camera_location.y + 8)
  end

  return moon
end

function init_tips()
    local putin_tip = init_spr("putin_tip", 0, 12, 70, 1, 1, false, 0, 0)
    local putin_tiped = false
    init_animation(putin_tip, 0, 0, 5, "nomal", true)
    init_animation(putin_tip, 157, 158, 5, "shine", true)
    local function update()
        if not putin_tiped and player_pinecone == 5 then
            change_animation(putin_tip, "shine")
        end
        if putin_tiped and player_pinecone < 5 then
            change_animation(putin_tip, "nomal")
        end
    end
    return {
        update = update,
    }
end

function init_screen_shake()
    local shake = {}
    local offset = 0
    shake.state = 'init'
    shake.camera_x = 0
    shake.draw = function ()
        if shake.state == 'start' then
            local fade = 0.95
            local offset_x=shake.camera_x+16-rnd(32)
            local offset_y=16-rnd(32)
            offset_x*=offset
            offset_y*=offset
            camera(offset_x,offset_y)
            offset*=fade
            if offset<0.5 then
                offset=0
            end
        end
    end
    shake.update = function ()
        if shake.state == 'start' then offset = 1 end
    end
    return shake
end

function season_shift(season)
  if season == "winter" then
    cfg_levels = winter_config
    music(-1)
    music(20)
  elseif season == "spring" then
    cfg_levels = spring_config
    music(-1)
    music(14)
  elseif season == "summer" then
    cfg_levels = summer_config
    music(-1)
  end

  player_pinecone = 0
  load_level(season..".p8")
  game_level = 1
  change_level(1)
  game_season = season
  map_ani_1 = init_map_animation(7, 15, 2, false)
  map_ani_2 = init_map_animation(6, 15, 2, true)
  pal()
end
