pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-->main-0
--------------�🅾️��☉��▥�----------------
map_location ={
    x = 0,
    y = 0,
}
controller = {
  jump = function ()
    if player.state == "climb" then
      player.climb_jump()
    else
      player.vecter.y -= 3
      direction_flag.y = "up"
      can_jump -= 1
      if player.state ~= "jump" then
        player.state = "jump"
        change_animation(player, "jump")
        change_animation(tail, "jump")
      end
    end
  end,

  up = function()
    if player.state == "climb" then
      local map_x = player.pos_x + (player.flip_x and -8 or (player.width*8 + 5))
      if get_map_flage(map_x, player.pos_y) ~= 1 then
        player.state = "jump"
        change_animation(player, "jump")
        player.is_physic = true
      end
      player.pos_y -= 2
    end
  end,
  down = function()
    player.new_ground = 1
    if player.state == "climb" then
      local map_y = player.pos_y + player.height + 10
      player.pos_y += 2
      if get_map_flage(player.pos_x, map_y) == 1 then
        player.state = "jump"
        change_animation(player, "jump")
        player.is_physic = true
      end
    end
  end,
  left = function()
    if player.state ~= "climb" then
      player.flip_x = true
      player_state_x_flag = "fast_go_left"
      if player.vecter.x <= -player_max_v then
        player_state_x_flag = "fast_go_stay"
      end
      if player.state ~= "run" and player.state ~= "jump" then
        player.state = "run"
        change_animation(player, "run")
        change_animation(tail, "run")
      end
    end
  end,
  right = function()
    if player.state ~= "climb" then
      player.flip_x = false
      player_state_x_flag = "fast_go_right"
      if player.vecter.x >= player_max_v then
        player_state_x_flag = "fast_go_stay"
      end
      if player.state ~= "run" and player.state ~= "jump" then
        player.state = "run"
        change_animation(player, "run")
        change_animation(tail, "run")
      end
    end
  end,
}

function _init()
  cls()
  direction_flag = {
    x,
    y,
  } --�∧��…➡️�♥签
  game_state_flag = "play"--游�☉◆�⌂��█▒�♥签
  gravity = 0.4-- �♥♪�⌂�
  update_state_flag = "play"
  draw_state_flage = "play"
  can_jump = 2
  player_state_x_flag = "nomal"
  player_acceleration = 0.1
  player_max_v = 2

  player = init_player()
  mogu_hit = map_trigger_enter(player, 3, player.mogu_hit, "down")
  tail = init_tail()

  -- map_col = map_hit(player)

  -- oncllision(player, text_obj)

  snow = init_snow()
  chest = init_chest()
  catepiller = init_catepiller()
  -- pinecones of whole level
  global_pinecone = init_global_pinecone()
  max_pinecone_num = 6
  player_pinecone = 3
  timer = newtimer()
  -- register collision
  -- ontrigger_enter(player, enemy, handle_player_hit, 'player_hit')
  ontrigger_stay(player, chest, function()
    if btnp(5) then
      if player_pinecone ~= 0 then
        player_pinecone -= 1
        chest.pinecone += 1
      end
    end
  end, 'chest_store')
end

------------游�☉◆�⌂��█▒机-----------------
game_states = {
----------update�⌂��█▒机--------------
update_states = {
  play_update = function()
    player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
    if (btnp (5) and can_jump <= 2 and can_jump > 0) controller.jump()
    if (btn (2)) controller.up()
    if (btn (3)) controller.down()
    if (btn (0) and direction_flag ~= "right") controller.left()
    if (btn (1) and direction_flag ~= "right") controller.right()

    player.player_states.states_x[player_state_x_flag]()
    -- player_states.states_y[player_state_y_flag]()
    player.hit()

    for v in all(object_table) do
      if v.name ~= "player" then
        v.vecter.y = v.vecter.y + (v.is_physic and gravity or 0)
        hit(v, 1, "height", function()
          v.vecter.y = 0
        end)
        hit(v, 1, "width", function()
          v.vecter.x = 0
        end)
        v.pos_x = v.pos_x + v.vecter.x
        v.pos_y = v.pos_y + v.vecter.y
      end
    end

      update_cllision()
      player.pos_x = player.pos_x + player.vecter.x
      player.pos_y = player.pos_y + player.vecter.y

      update_animation()
      if abs(player.vecter.x) < player_acceleration then
        player_state_x_flag = "nomal"
      else
        player_state_x_flag = "fast_back"
      end

      snow.update()
      timer.update()
      tail.update()
      catepiller.update()
    end,

    game_over_update = function()

    end,
  },
  ---------------------------------

  -----------draw�⌂��█▒机-------------
  draw_states = {
    play_draw = function()
      map(map_location.x, map_location.y)

      for v in all(object_table) do
        if v.flip_x then
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height, v.flip_x)
        else
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
        end
      end
      update_trigger()
      print(can_jump)
      print(player.state)
      snow.draw()
      chest.draw()
      catepiller.draw()
      global_pinecone.draw()
      draw_pinecone_ui()
      mogu_hit()
      -- map_col.update_trg()
      -- camera(player.pos_x-64, 0)
    end,
    game_over_draw = function()
      -- map(16, 0)
    end,
  },
  -------------------------------
}
-----------------------------------

-->8
--> global-1
object_table = {}
---------------计�❎��▥�-------------------
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
        local now = time()
        for name, timer in pairs(o.timers) do
            local timer_type, timer_start, timeout, callback = timer[1], timer[2], timer[3], timer[4]
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

----------------------------------------

----------------实��⬅️�😐∧对象---------------
--sp(图�웃♥索�ˇ)--pos_x,pos_y(实�⬅️�😐∧�…�♥)--width,height(图�웃♥�▤度�😐宽度)--
function init_spr(name, sp, pos_x, pos_y, width, height, is_physic, v_x, v_y)
    if not v_x then v_x = 0 end
    if not v_y then v_y = 0 end
    local animation_table = {}
    local animation
    local obj_idx = #object_table + 1
    local spr_obj = {name = name, sp = sp, pos_x = pos_x, pos_y = pos_y, height = height, width = width,
        vecter = {x = v_x, y = v_y},
        is_physic = is_physic,
        animation_table = animation_table,
        animation = animation,
        destroy = function()
            object_table[obj_idx] = nil
        end,
        flip_x = false,
    }

    add(object_table, spr_obj)
    return spr_obj
end
----------------------------------------

-------------��★��⧗碰�★���☉触�◆➡️��⬅️��웃--------------
trigger_table = {}

function update_trigger()
    for _, v in pairs(trigger_table) do
        v()
    end
end

local function trigger(sprit_1, sprit_2)
    local hit = false
    local x1 = sprit_1.pos_x
    local x2 = sprit_2.pos_x
    local w1 = sprit_1.width * 8
    local w2 = sprit_2.width * 8
    local y1 = sprit_1.pos_y
    local y2 = sprit_2.pos_y
    local h1 = sprit_1.height * 8
    local h2 = sprit_2.height * 8
    local xd = abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
    local xs = w1 * 0.5 + w2 * 0.5
    local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
    local ys = h1 / 2 + h2 / 2
    if xd < xs and
    yd < ys then
        hit = true
    end
    return hit
end

function ontrigger_enter(sprit_1, sprit_2, enter_func, trigger_name)
    local entered = false
    local is_trigger = false
    local function trigger_enter ()
        is_trigger = trigger(sprit_1, sprit_2)
        if not entered and is_trigger then
            enter_func()
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
    end

    if trigger_name then
        trigger_table[trigger_name] = trigger_enter
    else
        add(trigger_table, trigger_enter)
    end

    return trigger_enter
end

function ontrigger_stay(sprit_1, sprit_2, stay_func, trigger_name)
    local function trigger_stay()
        if trigger(sprit_1, sprit_2) then
            stay_func()
        end
    end
    if trigger_name then
        trigger_table[trigger_name] = trigger_stay
    else
        add(trigger_table, trigger_stay)
    end

    return trigger_stay
end

function ontrigger_exit(sprit_1, sprit_2, exit_func, trigger_name)
    local entered = false
    local is_trigger = false
    local function trigger_exit()
        is_trigger = trigger(sprit_1, sprit_2)
        if not entered and is_trigger then
            entered = true
        end
        if entered and not is_trigger then
            exit_func()
            entered = false
        end
    end
    if trigger_name then
        trigger_table[trigger_name] = trigger_exit
    else
        add(trigger_table, trigger_exit)
    end

    return trigger_exit
end

-------------��★��⧗碰�★���☉碰�★���⬅️��웃--------------
cllision_table = {}
function update_cllision()
    for k, v in pairs(cllision_table) do
        v.width()
        v.height()
    end
end

function oncllision(sprit_1, sprit_2, cllision_func)
    local tbl = {
        width = function()
            local cllision_width = false
            local x1 = sprit_1.pos_x + sprit_1.vecter.x
            local w1 = sprit_1.width * 8

            local x2 = sprit_2.pos_x + sprit_2.vecter.x
            local w2 = sprit_2.width * 8

            local xd = abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
            local xs = w1 * 0.5 + w2 * 0.5

            local cllision_height = false
            local y1 = sprit_1.pos_y
            local h1 = sprit_1.height * 8

            local y2 = sprit_2.pos_y
            local h2 = sprit_2.height * 8

            local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
            local ys = h1 / 2 + h2 / 2

            print(xd)
            if xd <= xs and yd < ys then
                sprit_1.vecter.x = 0
                if cllision_func then
                    if cllision_func.width then cllision_func.width() end
                end
            end
        end,
        height = function()
            local cllision_height = false
            local y1 = sprit_1.pos_y + sprit_1.vecter.y
            local h1 = sprit_1.height * 8

            local y2 = sprit_2.pos_y + sprit_2.vecter.y
            local h2 = sprit_2.height * 8

            local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
            local ys = h1 / 2 + h2 / 2

            local x1 = sprit_1.pos_x
            local w1 = sprit_1.width * 8

            local x2 = sprit_2.pos_x
            local w2 = sprit_2.width * 8

            local xd = abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
            local xs = w1 * 0.5 + w2 * 0.5

            print(yd)
            if yd <= ys and xd < xs then
                sprit_1.vecter.y = 0
                if cllision_func then
                    if cllision_func.height then cllision_func.height() end
                end
            end
        end,
    }
    add(cllision_table, tbl)
end
---------------------------------------

--------------地形碰�★�-------------------
--sprit_flag: palyer = 1, map = 2
function hit(sprit, hit_spr_flag, hit_side, hit_func, not_hit_func)
    local next_x = sprit.pos_x + sprit.vecter.x
    local next_y = sprit.pos_y + sprit.vecter.y
    local w = sprit.width * 8 - 1
    local h = sprit.height * 8 - 1
    local next_last_x = next_x + w
    local next_last_y = next_y + h
    -- if hit_spr_flag == 1 then
    --     next_y = next_y - 8
    -- end

    local function h_func()
        for i = sprit.pos_x, sprit.pos_x + w, w do
            if (get_map_flage(i, (next_y)) == hit_spr_flag) or (get_map_flage(i, (next_last_y)) == hit_spr_flag) then
                return true
            end
        end
        return false
    end

    local function w_func()
        for i = sprit.pos_y, sprit.pos_y + h, h do
            if ((get_map_flage((next_x), i)) == hit_spr_flag) or (get_map_flage((next_last_x), i) == hit_spr_flag) then
                -- x = fget(mget((next_x) / 8, i / 8))
                return true
            end
        end
        return false
    end

    local get_func_tbl = {
        height = function()
            if h_func() then
                hit_func()
            elseif not_hit_func then
                not_hit_func()
            end
        end,

        width = function()
            if w_func() then
                hit_func()
            elseif not_hit_func then
                not_hit_func()
            end
        end,

        all = function()
            if h_func() and w_func()then
                hit_func()
            elseif not_hit_func then
                not_hit_func()
            end
        end,
    }
    get_func_tbl[hit_side]()
end
------------------------------------------


----------------------�☉�建�⌂��⬆️�-------------------
function init_animation(spr_obj, first_spr, last_spr, play_time, ani_flag, loop)
    local update_time = 0
    local sp = first_spr
    local width = spr_obj.width
    local height = spr_obj.height
    local function next_ps(sprit)
        local next = sprit + width
        if next > 15 then next = flr(next / 15) * 16 + height end
        return (sprit + width)
    end
    local updat_v = 1
    spr_obj.animation_table[ani_flag] = function()
        update_time += updat_v
        if update_time == play_time then
            if sp == last_spr then
                sp = first_spr
                if not loop then
                    updat_v = 0
                end
            else
                sp = next_ps(sp)
            end
            update_time = 0
        end
        spr_obj.sp = sp
    end
    if spr_obj.animation == nil then
        spr_obj.animation = spr_obj.animation_table[ani_flag]
    end
end

-------------�☉♥�♪��⌂��⬆️�----------------
function change_animation(spr_obj, ani_flag)
    spr_obj.animation = spr_obj.animation_table[ani_flag]
end

-----------�⌂��⬆️��★��⬆️�---------------
function update_animation()
    for v in all(object_table) do
        if v.animation then
            v.animation()
        end
    end
end

------------�☉♥�♪�对象---------------
function exchange_obj(obj_1, obj_2)
    local mid_obj = obj_1
    return obj_2, mid_obj
end

function handle_player_hit ()
    if player_pinecone == 0 then
        -- todo change scene to gameover
    else
        player_pinecone -= 1
        local p = {sp=207, pos_x=player.pos_x+8, pos_y=player.pos_y+8, is_dropped=true}
        add(global_pinecone.pinecone_list, p)
        timer.add_timeout('remove_pinecone'..player_pinecone, 3, function()
            del(global_pinecone.pinecone_list, p)
        end)

        if not player.flip_x then
            player.pos_x -= 32
        else
            player.pos_x += 32
        end
    end
end

function _update()
    update_state_flag = game_state_flag .. "_update"
    game_states.update_states[update_state_flag]()
end

function _draw()
    cls()
    draw_state_flage = game_state_flag .. "_draw"
    game_states.draw_states[draw_state_flage]()
end

-->8
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
    local timer = newtimer()

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

-->8
-->map-3
function get_map_flage(m_x, m_y)
  return fget(mget(m_x/8+map_location.x,m_y/8+map_location.y))
end

-- function map_hit(obj)
--     local map_hit_trg = {
--         hit_3 = function(x, y)
--             mset(x, y, 0)
--         end,
--         hit_5 = function(x, y)
--
--         end
--     }
--     local map_hit_cls = {
--         hit_2 = function(x, y)
--
--         end,
--         hit_4 = function(x, y)
--
--         end
--     }
--
--     local function update_cls()
--         local cllision_flage
--
--         if map_hit_cls["hit_" .. cllision_flage] then map_hit_cls["hit_" .. cllision_flage]() end
--     end
--     local trigger_flage
--
--     local function update_trg()
--         local x1 = obj.pos_x
--         local w1 = obj.width * 8
--         local y1 = obj.pos_y
--         local h1 = obj.height * 8
--         for i = x1, (x1 + w1 - 1), (w1 - 1) do
--             for j = y1, (y1 + h1 - 1), (h1 - 1) do
--                 local m_x, m_y = i / 8, j / 8
--                 trigger_flage = fget(mget(m_x+map_location.x, m_y+map_location.y))
--                 if trigger_flage ~= 0 and trigger_flage ~= nil then
--                     if map_hit_trg["hit_" .. trigger_flage] then
--                         map_hit_trg["hit_" .. trigger_flage](m_x, m_y)
--                     end
--                         return
--                     end
--                 end
--             end
--         end
--     return{
--         update_trg = update_trg,
--         update_cls = update_cls,
--     }
-- end
function map_trigger(obj, flag, direction)
    local x = obj.pos_x
    local y = obj.pos_y
    local w = obj.width * 8
    local h = obj.height * 8
    local x1, x2, y1, y2 = 0, 0, 0, 0
    if direction == 'left' then
        x1 = x - 1
        y1 = y
        x2 = x
        y2 = y + h - 1
    elseif direction == 'right' then
        x1 = x + w
        y1 = y
        x2 = x + w + 1
        y2 = y + h - 1
    elseif direction == 'up' then
        x1 = x + 1
        y1 = y - 1
        x2 = x + w - 1
        y2 = y
    elseif direction == 'down' then
        x1 = x
        y1 = y + h
        x2 = x + w
        y2 = y + h
    end


    -- printh("x1 = " .. x1 .. ",y2 = " .. y2 .." flag = " .. get_map_flage(x1, y2), "logging_name")
    -- printh("x2 = " .. x2 .. ",y2 = " .. y2 .." flag = " .. get_map_flage(x2, y2), "logging_name")
    if get_map_flage(x1, y1) == flag or get_map_flage(x2, y2) == flag
        or get_map_flage(x1, y2) == flag or get_map_flage(x2, y1) == flag then
            return true
    end
    return false
end

enter = false
function map_trigger_enter(obj, map_flag, enter_func, direction)
    local entered = false
    local is_trigger = false
    local function trigger_enter ()
        is_trigger = map_trigger(obj, map_flag, direction)
        if not entered and is_trigger then
            enter_func()
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
        enter = is_trigger
    end

    return trigger_enter
end

function map_trigger_stay(obj, map_flag, stay_func, direction)
    local function trigger_stay()
        if map_trigger(obj, map_flag, direction) then
            stay_func()
        end
    end

    return trigger_stay
end

function map_trigger_exit(obj, map_flag, exit_func, direction)
    local entered = false
    local is_trigger = false
    local function trigger_exit()
        is_trigger = map_trigger(obj, map_flag, direction)
        if not entered and is_trigger then
            entered = true
        end
        if entered and not is_trigger then
            exit_func()
            entered = false
        end
    end

    return trigger_exit
end

-->8
-- objects
function init_chest ()
    local c = init_spr("chest", 18, 10, 48, 1, 1, true, 0, 0)
     c.pinecone = 0
     c.draw = function ()
         print(c.pinecone..'/'..10, c.pos_x-4, c.pos_y-4)
     end
     return c
end

function init_catepiller ()
  local e = init_spr("catepiller", 203, 60, 48, 1, 1, true, 0, 0)
  init_animation(e, 203, 204, 10, "move", true)
  local max_range = 16
  e.flip_x = false
  e.update = function ()
    if not e.flip_x and e.pos_x > 60 + max_range then
      e.flip_x = true
    end
    if e.flip_x and e.pos_x < 60 - max_range then
      e.flip_x = false
    end
    e.pos_x = e.pos_x + (e.flip_x and - 0.5 or 0.5)
  end
  e.draw = function ()
    spr(e.sp, e.pos_x, e.pos_y, 1, 1, e.flip_x)
  end
  return e
end

function init_global_pinecone ()
  local g = {
    pinecone_list = {}
  }
  g.draw = function ()
    for p in all(g.pinecone_list) do
      if p.is_dropped then
        -- hack way to let pinecone flcik
        if time() % 0.5 < 0.25 then
          spr(p.sp, p.pos_x, p.pos_y)
        end
      else
        spr(p.sp, p.pos_x, p.pos_y)
      end
    end
  end
  return g
end

function draw_pinecone_ui()
  for i = 1, max_pinecone_num do
    if i <= player_pinecone then
      spr(142, 125 - 6 * i, 2)
    else
      spr(143, 125 - 6 * i, 2)
    end
  end
end

function init_player()
  local player = init_spr("player", 192, 30, 10, 1, 1, true)
  player.state = "nomal"
  player.ground = 1
  player.new_ground = 2
  player.player_states = {
    states_x = {
      nomal = function()
        player.vecter.x = 0
      end,
      fast_go_left = function()
        player.vecter.x -= player_acceleration
      end,
      fast_back = function()
        if abs(player.vecter.x) < player_acceleration then
          player_state_x_flag = "nomal"
        else
          if (player.vecter.x > 0) then
            player.vecter.x -= player_acceleration
          elseif (player.vecter.x < 0) then
            player.vecter.x += player_acceleration
          end
        end
      end,
      fast_go_right = function()
        player.vecter.x += player_acceleration
      end,
      fast_go_stay = function()
        player.vecter.x = player.vecter.x > 0 and player_max_v or (-1 * player_max_v)
      end
    },
    states_y = {},
  }

  player.hit = function()
    hit(player, 1, "height", function()
      can_jump = 2
      if player.state ~= "nomal" then
        if player.vecter.x == 0 then
          player.state = "nomal"
          change_animation(player, "nomal")
          change_animation(tail, "nomal")
        else
          player.state = "run"
          change_animation(player, "run")
          change_animation(tail, "run")
        end
      end
      player.new_ground = 2
      player.vecter.y = 0
    end, function()
      if player.state ~= "jump" then
        can_jump = 1
      end
    end)
    hit(player, 1, "width", function()
      player.vecter.x = 0
      local map_y = player.pos_y + player.height + player.height*8+5
      if player.state == "jump" and get_map_flage(player.pos_x, map_y) ~= 1 then
        player.state = "climb"
        change_animation(player, "climb")
        change_animation(tail, "climb")
        player.is_physic = false
        player.vecter.y = 0
      end
    end)
    hit(player, player.new_ground, "height", function()
      can_jump = 2
      player.vecter.y = 0
    end)
    hit(player, player.new_ground, "width", function()
      player.vecter.x = 0
    end)
  end
  player.climb_jump = function()
    player.state = "jump"
    change_animation(player, "jump")
    change_animation(tail, "jump")

    player.flip_x = not player.flip_x
    player.vecter.x = player.vecter.x + (player.flip_x and -2 or 2)
    player.vecter.y = -3
    player.is_physic = true
  end

  player.mogu_hit = function()
      player.vecter.y = -3
  end

  init_animation(player, 128, 130, 10, "nomal", true)
  init_animation(player, 151, 154, 10, "run", true)
  init_animation(player, 135, 138, 10, "jump", true)
  init_animation(player, 144, 145, 10, "climb", true)
  -- init_animation(player, )
  return player
end

function init_tail()
  if not player then
    return
  end
  local tail = init_spr("tail", 224, player.pos_x - 8, player.pos_y, 1, 1, false, 0, 0)
  tail.update = function()
    tail.flip_x = player.flip_x
    tail.pos_x = player.pos_x + (tail.flip_x and 8 or - 8)
    tail.pos_y = player.pos_y
  end
  init_animation(tail, 0, 0, 10, "nomal", true)
  init_animation(tail, 147, 150, 10, "run", true)
  init_animation(tail, 131, 134, 10, "jump", true)
  init_animation(tail, 0, 0, 10, "climb", true)
  return tail
end

__gfx__
0000000033333333ffff3fffffff3ffffffffffffaff3bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444444ffff3ffffff33ffffff88fffbffff3bf7fff7fff7fff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044445544fff3333fffff3fffff8878ff3bfabbbfc7f7c7f7c7f7c7f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444444ffff3fffffffbffff878888ff3b3333bcc7ccc7ccc7ccc7cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000045544444ffb33fffffffffff88888788ffb3ffafcccc7cccccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444444ffff3bfffffffffffff77fffffb3ffffcccccccccccccc7cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444554ffff3ffffffffffffff77ffffbfbfb3fccccccccc7ccccccfffffffffffffffffffffffffffff99fffffffffffffffffffffffffffffffff
0000000044444444fff33f3ffffffffffff77fff3ff3bffbccccccc7ccccccccfffffffffffffffffffffffffff99999ffffffffffffffffffffffffffffffff
ffffffff3333333366666666ffffffffffffffffffffffffccccccccccccccccffffffffffffffffffffffff9999999999999fffffffffffffffffffffffffff
ffffffff333533336dddddd6ffffffffffffffffffffffffcc7cccccccccccccffffffffffffffffffffff999999999999999999ffffffffffffffffffffffff
ffffffff535453536d6dd6d6ffffffffffffffffffffffffccccccccccccccccfffffffffffffffffffff9999999999999999999ffffffffffffff9fffffffff
ffffffff454453556ddd6dd6ffffffffffffffffff9f9fffccccccccccccccccffffffffffffffffffff999999999999999f99999ffffffffffff99fffffffff
ffffffff444445446dd6ddd6ff2f2fffff3ffffffff7ffffccccccccccccccccfffffffffffffffffff99999999999999999999999ffffffffffffffffffffff
ffffffff444444446d6dd6d6fff9fffffff333ffff939fffccccc7ccccccccccffffffffffffffffff999999999999999999999999ffffffffffffffffffffff
ffffffff454444446dddddd6ff232ffffff3f3fffff3ffffccccccccccccccccfffffffffffffffff999999f9999999999999999999fffffffffffffffffffff
ffffffff4444445466666666fff3fffffff3fffffff3ffffccccccccccccccccfffffffffffffffff99999ff99999999999999999999ffffffffffffffffffff
ffffffff44444444ffffffffffffffffffffffffbfffffffbfffffff00000000ffffffffffffffff999999999999999999999999999fffffffffffffffffffff
ffffffff44444444ffffffffffffffffffffffff3fffffff3fffffff00000000fffffffffffffffff999999999999999999999999999ffffffffffffffffffff
4fffffff44444544ffffffffffffffffffffffffbffffffffbffffff00000000fffffffffffffffff999999999999999999999999999ffffffffffff7fffffff
f44f44ff44444444ffffffffffffffffffffffff3fffffffff3fffff00000000ffffffffff7fffffff999999999999999999999999999fffffffffffffffffff
fff4444f44444444fff8ffffffffffffffffffffbffffffffbffffff00000000fffffffff77fffffff9999999999999999999999999f99ffffffffffffffffff
fff44fff45444444ff878fffffffffffffff3fffbfffffffbfffffff00000000ffffffffffffffffff99999999999999f99999999999999999ffffffffffffff
ff4fffff44444444f88888fffffffffffffbfbffbfffffffbfffffff00000000fffffffffffffffff99999999949999ff9994999999999999999999fffffffff
ffffffff44444444ff777fffbbbb3b3bfbbfff3bbfffffffffffffff00000000fffffffffffffffff999999999449999999449999999999999999999ffffffff
ffffffffffffffffffffffff9777777733333333fff33ffffffffffffff8ffffffffffffffffffffff9999999944449999444999999999999999999999ffffff
76fff67f666fff6676fff67fd999999732333233f999f3fff8fffffffffffff8fffffffffffffff9f999999999944449444449999999949999999999999fffff
776f677f7776f677776f677fd99999972d232d27faa9f3ffffaf8fffffff8fffffffffffffffff9f999999999994444444449999999944499999999f999fffff
f76f67fff7779c4cf76f67ffd99999972dddddd7faa9f3ffffff88fffff888ffffffffffffffff9999999999999944444499999999999444999999ff9999ffff
ff79c4cffff55fffff79c4cfd99999972dddddd7fffff3fff8f8988fff88888fffffffffffff999999999999999994444449999999999444999999999999ffff
ff55fffffff99fffff55ffffd99999972dddddd7fffff3fff889a98ff8899988ffffffffffff9999994999999999994444499999999999444999999999999fff
ff99ffffffff5ffffff99fffd99999972dddddd7ffff333f889aaa98889aa998fffffffff9999999944999999999944444499999999999444999999999999fff
fff57ffffffff7fffffff57fd99999972dddddd7fff3333389aaaaa8899aaa98fffffffff9999999944999999999944444444999999999444499999999999fff
ffffffffffffffffffffffffffffffff00000000000000000000000000000000ffffffff99999999944449999994444444444499994444444449999999999fff
ffffffffffffffffff777f999fffffff00000000000000000000000000000000fffffff9999999999444444944444444444444994444444444444444499999ff
fffffffffffffffffff7999999ffffff00000000000000000000000000000000fffffff9999999994444445444944444444444444944444444444444999999ff
faaadffffffffffffff79997999fffff00000000000000000000000000000000ffffff99999999444544445444444444444d54444444454444444499999999ff
faaadffffaaadffffff999777999ffff00000000000000000000000000000000fffff999f9999444454445544444444444d554444444554444444999999999ff
fffadffffffadfffff99977777999fff00000000000000000000000000000000fffff999999944444d544555444444444d555444444d554444449999999999ff
ffafffffffaadffff9997777777999ff00000000000000000000000000000000fffff9999999999444d5455544444444d5554444444d554444449999999f99ff
fffffffffaffffff999777777777999f00000000000000000000000000000000ffff999999999994444d55555444444d5555444444d5554444999999999999ff
0000000000000000997777777777799f00000000000000000000000000000000fffff999999999944444dd555544455d555444444d5555444449999999999fff
0000000000000000ff77e87777777fff00000000000000000000000000000000fffff9999999999944444455555dd555555555ddd5555444444999999999ffff
0000000000000000ff77887777777fff00000000000000000000000000000000ffffff9999999994449444d5555555555555555555555544444499999999ffff
0000000000000000ff77777755577fff00000000000000000000000000000000ffffff99999994444444444d55555555555555555555555555444444999fffff
0000000000000000ff77777755577fff00000000000000000000000000000000ffffff99f994444444444444d55555555555555555555555555444449fffffff
0000000000000000ff77777755577fff00000000000000000000000000000000fffffff999444444444999999ddd55555555555555554444444444999fffffff
0000000000000000f7777777559777ff00000000000000000000000000000000ffffffff99999999999999999999d555555555555554444999999999ffffffff
0000000000000000f7777777555777ff00000000000000000000000000000000ffffffffff99999999999999ff999d555555555555999999999999ffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffff999999999fffffffffd555555555ffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffff555555555fffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffffd55555555ffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffff55555555fffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffd5555555ffffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffd5555555ffffff444444444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffd55555555fffffff444454444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffd555555555ffffffff444555444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffd555555555fffffffff444999444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffd555555555ffffffffff444494444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffd5555555555ffffffffff444444444ffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffd555555555555ffffffffffff4ffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffd555555555555555555fffffff4ffffffffffffffffff
00040000000994000009400000000000000000000000000000000000000004000000040000000000000000000000000000000000000000000000000000000000
09400400049400000094994000000000004444000444400000000000000049900000499004440400000000000000000000000000000000000006600000066000
94000990494004000940000400444000049999404009994040000000000497790049977949994990044000000000000000000000000000000069760000600600
490049799400499040000400049994004000000400000099094440000499900004997900977097794994040000000000000000000009700006999a6006000060
9044970040449779044049904000094000000000000000000099994004970990049700900999090097794990000000000000000000999a000644496006000060
40997990049909004994977900000004000000000000000000000004497700004990000000000090970797790000000000000000004449000644496006000060
04970000097700909770090000000000000000000000000000000000099000000099900000000000099009000000000000000000004449000064460000600600
00999000009990000999009900000000000000000000000000000000009900000000000000000000000000990000000000000000000440000006600000066000
00040400400004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04900990090009900044400004000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49004779049047790499994000400000090000000000000000444000000000000000000000000000000000000000000000000000000000000000000000000000
49004900049049000900000400944000094000000004440004999400000004000440000000000400000004000000000000000000000000000000000000000000
49049799049497904000000000099400009440000049994009000940044499904994040004440990044049900000000000000000000000000000000000000000
09049700049497090440040000000994000999944990000440000094499997799779499049994779499497790000000000000000000000000000000000000000
00904990009049004994499400000000000000000000000000000000977049009907977999779000997790000000000000000000000000000000000000000000
00040009000400994477944400000000000000000000000000000000994040990400094040990990099409400000000000000000000000000000000000000000
__gff__
0001000003000000000000000000000000010200000000000000000000000000000100000000000000000000000000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101002101010101010101002101010101010101010021002101010101010101010101010101010101010101010101010100210021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101002100210101010101002101010101010101010021002101010101010101010101010101010101010101010101010100210021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101002100210101010101002101010101010101010021002101010101010101010101010101010101010101010101010100310021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101003100210101010101002101010101010101010031002101010101010101010101010101010101010101040101010101010021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
08090a0b0c0d030f101010101003101010101010411010101003101010101040101010101010101010101010101010101010101010021041101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
18191a1b1c1d1e1f411010101010101041101010101010101010101010101010101010101010053410101010101010101010104010021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
28292a2b2c2d2e2f101010101010101010101010101010101010241010101010101010103010053310101010101010101010101010031010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
38393a3b3c3d3e3f101010101010101010101010101010101010343434101010101010101010053310100534341010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
48494a4b4c4d4e4f104010101010351010101010101010101010331033101010101010101010053310100533331010101010101010101010301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
58595a5b5c5d5e5f1010101010343434101010101010101010103310331010101010103434101010101005333310101010101010241010101010106d6e10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
68696a6b6c6d6e424310103333331010331010103434341010103310331010101010103310101010100405333310101010101034343434343434107d7e10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
78797a7b7c7d7e52531304101010101010151333331010050533331033221035102204333513101033333315133410131015333333102210333333333310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1111111111111111111111060606060611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121161616161621212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
