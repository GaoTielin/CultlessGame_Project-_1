pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-->main-0
--------------ÊüÖæÔ∏èßÂ‚òâ∂Â‚ñ•®----------------
map_location ={
    x = 0,
    y = 0,
}
camera_location = {
  x = 0,
  y = 0,
}
changed_map = {}
cg = {
  first_map = 0,
  last_map = 0,
  timer = 0,
  over_func = function()
  end,
}
controller = {
  jump = function ()
    if player.state == "climb" then
      player.climb_jump()
      sfx(10)
    elseif player.can_jump <= player.max_jump and player.can_jump > 0 then
      player.vecter.y = cfg_jump_speed * -1
      direction_flag.y = "up"
      player.can_jump =  player.can_jump - 1
      if player.state ~= "jump" then
        player.state = "jump"
        change_animation(player, "jump")
        change_animation(tail, "jump")
      end
      sfx(11)
    end
  end,

  up = function()
    if player.state == "climb" then
       player.pos_y -= cfg_climb_speed
      local map_x = player.pos_x + (player.flip_x and -1 or (player.width*8))
      local map_y = player.pos_y + player.height*8 - 1
      go_sound.play()
      if get_map_flage(map_x, map_y) ~= player.climb_flag then
        player.state = "nomal"
        change_animation(player, "nomal")
        player.is_physic = true
        player.pos_x = player.pos_x + (player.flip_x and -1 or 1)
      end
    end
  end,
  down = function()
    player.new_ground = 1
    if player.state == "climb" then
        player.pos_y += cfg_climb_speed
      local map_y = player.pos_y + player.height + 10
      local map_x = player.pos_x  + (player.flip_x and -1 or (player.width*8))
      if get_map_flage(player.pos_x, map_y) == 1 or get_map_flage(map_x, map_y) ~= player.climb_flag or get_map_flage(player.pos_x, map_y) == player.climb_flag then
        player.state = "nomal"
        change_animation(player, "nomal")
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
        -- player.vecter.x = player_max_v
      end
      if player.state ~= "run" and player.state ~= "jump" then
        player.state = "run"
        change_animation(player, "run")
        change_animation(tail, "run")
      end
      if player.state == "run" then
        go_sound.play()
      end
    elseif player.state == "climb" and player.flip_x then
     player.pos_y -= cfg_climb_speed
     local map_x = player.pos_x + (player.flip_x and -1 or (player.width*8))
     local map_y = player.pos_y + player.height*8 - 1
     go_sound.play()
     if get_map_flage(map_x, map_y) ~= player.climb_flag then
       player.state = "nomal"
       change_animation(player, "nomal")
       player.is_physic = true
       player.pos_x = player.pos_x + (player.flip_x and -1 or 1)
     end
    end
  end,
  right = function()
    if player.state ~= "climb" then
      player.flip_x = false
      player_state_x_flag = "fast_go_right"
      if player.vecter.x >= player_max_v then
        player_state_x_flag = "fast_go_stay"
        -- player.vecter.x = player_max_v
      end
      if player.state ~= "run" and player.state ~= "jump" then
        player.state = "run"
        change_animation(player, "run")
        change_animation(tail, "run")
      end
      if player.state == "run" then
        go_sound.play()
      end
    elseif player.state == "climb" and not player.flip_x then
     player.pos_y -= cfg_climb_speed
     local map_x = player.pos_x + (player.flip_x and -1 or (player.width*8))
     local map_y = player.pos_y + player.height*8 - 1
     if get_map_flage(map_x, map_y) ~= player.climb_flag then
       player.state = "nomal"
       change_animation(player, "nomal")
       player.is_physic = true
       player.pos_x = player.pos_x + (player.flip_x and -1 or 1)
     end
     go_sound.play()
    end
  end,
}

function init_game()
  spx_timer = 0
  autumn_config = init_config(cfg_levels_autumn)
  winter_config = init_config(cfg_levels_winter)
  spring_config = init_config(cfg_levels_spring)
  summer_config = init_config(cfg_levels_summer)

  game_season = "autum"
  -- game_season = "winter"
  -- game_season = "spring"

  cfg_levels = autumn_config -- Áß‚¨ÖÔ∏èÂ§©Âº‚ñàÂß‚¨ÖÔ∏è
  -- cfg_levels = winter_config -- Â‚óè¨Â§©Âº‚ñàÂß‚¨ÖÔ∏è
  -- cfg_levels = spring_config --Ê‚ñ§•Â§©Âº‚ñàÂß‚¨ÖÔ∏è

  game_level = 1

  direction_flag = {
    x,
    y,
  } --Ê‚àßπÂ‚Ä¶‚û°Ô∏èÊ†‚ô•Á≠æ
  cloud = init_cloud()
  moon_map = init_moon()
  game_state_flag = "play"--Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊ†‚ô•Á≠æ
  gravity = cfg_gravity-- È‚ô•‚ô™Â‚åÇõ
  update_state_flag = "play"
  draw_state_flage = "play"
  player_state_x_flag = "nomal"
  player_acceleration_fast = cfg_player_acceleration_fast--Â‚åÇ†È‚ñàüÂ∫¶
  player_acceleration_low = cfg_player_acceleration_low
  player_max_v = cfg_player_max_v

  go_sound = init_sound(33, 10)

  thief = init_thief()
  thief_event = true
  sandy = init_sandy()
  player = init_player()
  player.can_jump = player.max_jump
  mogu_hit = map_trigger_enter(player, 3, player.mogu_hit, "down")
  jinji_hit = map_trigger_enter(player, 7, game_over, "all")
  lupai_hit = map_trigger_stay(player, 6, function()
    if game_level == 4 or game_level == 9 then
        -- print("pass ‚ùé", player.pos_x-5, player.pos_y - 8, 1)
        spr(175, player.pos_x, player.pos_y - 8)
        -- print("‚ùé", player.pos_x, player.pos_y - 6, 1)
    end
    if btnp(5) then
      if game_level == 9 and player_pinecone == 5 then
        sandy.act = 'show'
      elseif game_level == 4 then
        game_level = 1
        change_level(1)
        -- local next_level = player_pinecone >= 10 then
        player.pos_x = 48
        player.pos_y = 80
      end
      sfx(29)
    end
  end, "all")

  tail = init_tail()

  change_camera = init_change_camera()
  tips = init_tips()

  snow = init_snow()
  -- leaves = init_leaves()
  shake = init_screen_shake()
  chest = init_chest()
  enemies = init_enemies(cfg_levels.level1.enemy_bees, cfg_levels.level1.enemy_catepillers)
  this_songzi_cfg = {}
  for k,v in pairs(cfg_levels.level1.songzi) do
    add(this_songzi_cfg, v)
  end
  if this_songzi_cfg then
    songzi = init_songzis(this_songzi_cfg)
  end
  boxs_table = init_boxs(cfg_levels.level1.box)
  ices_table = init_ices(cfg_levels.level1.ice)

  -- pinecones of whole level
  max_pinecone_num = 5
  player_pinecone = 0
  timer = newtimer()

  map_ani_1 = init_map_animation(7, 15, 2, false)
  map_ani_2 = init_map_animation(6, 15, 2, true)

  ontrigger_stay(player, chest, function()
    spr(175, chest.pos_x+5, chest.pos_y - 8)
    -- print("‚ùé", chest.pos_x+5, chest.pos_y - 8, 1)
    if btnp(5) then
      if player_pinecone ~= 0 then
        player_pinecone -= 1
        chest.pinecone += 1
        sfx(29)
      end
    end
  end, 'chest_store')
  change_level(game_level)
  -- bin_kuai = init_spr("bin_kuai", 159, 240, 88, 1, 1, true)
  -- bin_kuai_2 = init_spr("bin_kuai", 159, 23*8, 88, 1, 1, true)
  -- box_1 = init_box(176, 72, bin_kuai_2)
  -- box_2 = init_box(224, 32, bin_kuai)

  music(0)
end

function _init()
  game_state_flag = "start"
  start_timer = 0
  load_level("start.p8")
end

------------Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-----------------
game_states = {
----------updateÁ‚åÇ∂Ê‚ñà‚ñíÊú∫--------------
update_states = {
  start_update = function()
  end,

  change_level_update = function()
    if change_camera.update() then
      game_state_flag = "play"
    end
  end,

  play_update = function()
        player.check_position()
        player.update()
        map_ani_1.update()
        map_ani_2.update()
        player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
        if (btnp (4) ) controller.jump()
        if (btn (2)) controller.up()
        if (btn (3)) controller.down()
        if (btn (0) ) controller.left()
        if (btn (1) ) controller.right()
        -- if (btnp (5)) season_shift("winter")
        -- if (btnp (5)) change_map(map_cfg)

        player.player_states.states_x[player_state_x_flag]()
        -- player_states.states_y[player_state_y_flag]()
        player.hit()

        for v in all(object_table) do
          if v.name ~= "player" then
              if v.name == "box" or v.name == "ice" then
                  v.vecter.y = v.vecter.y + (v.is_physic and cfg_box_gravity or 0)
                  if v.vecter.y >= cfg_box_max_y then
                    v.vecter.y = cfg_box_max_y
                  end
              else
                  v.vecter.y = v.vecter.y + (v.is_physic and gravity or 0)
              end
            hit(v, 1, "height", function()
              v.vecter.y = 0
            end)
            hit(v, 1, "width", function()
              v.vecter.x = 0
            end)
            hit(v, 14, "height", function()
              v.vecter.y = 0
            end)
            hit(v, 14, "width", function()
              v.vecter.x = 0
            end)
            v.pos_x = v.pos_x + v.vecter.x
            v.pos_y = v.pos_y + v.vecter.y
          end
        end
        boxs_table.update()
        ices_table.update()
        update_cllision()
        player.pos_x = player.pos_x + player.vecter.x
        player.pos_y = player.pos_y + player.vecter.y

        update_animation()
        if abs(player.vecter.x) < player_acceleration_low then
            player_state_x_flag = "nomal"
        else
            player_state_x_flag = "fast_back"
        end
        player.anction_range()
        if game_season == "winter" then
          snow.update()
        end
        -- leaves.update()
        timer.update()
        tail.update()
        enemies.update()
        if thief.act == 'run1' then
            thief.update_run1()
        elseif thief.act == 'run2' and game_level == 9 then
            thief.update_run2()
        end
        if sandy.act == 'show' then
            sandy.update()
        end
        if chest.pinecone == 10 and thief_event then
            game_level = 5
            change_level(5)
            timer.add_timeout('thief_show', 1, function()
                thief.act = 'run1'
                chest.pinecone -= 5
                music(5)
            end)
            thief_event = false
        end
        cloud.update()
        tips.update()
        shake.update()
        sound_update()
    end,

  },
  ---------------------------------

  -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------

  draw_states = {
    start_draw = function()
      if start_timer >= 80 then
        load_level("season_shift.p8")
        init_game()
        game_state_flag = "play"
      end
      start_timer += 1
      local x = flr(start_timer/10)*16
      map(x, 0)
    end,

    change_level_draw = function()
      nomal_draw()
    end,

    play_draw = function()
        nomal_draw()
    end,

  },
  -------------------------------
}
-----------------------------------
function nomal_draw()
    map(112, 0, camera_location.x, camera_location.y, 16, 16)
    if game_season == "winter" or game_season == "spring"then
      moon_map.draw()
    end
    shake.draw()
    map(map_location.x, map_location.y)
    cloud.draw()

    for v in all(object_table) do
      if v.flip_x then
        spr(v.sp, v.pos_x, v.pos_y, v.width, v.height, v.flip_x)
      else
          if v.name == 'thief' or v.name == "thief_songzi" then
              if thief.act ~= 'init' then
                  spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
              end
          else
            spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
          end
      end
    end
    if game_season == "winter" then
      snow.draw()
    end
    chest.draw()
    sandy.draw()
    if thief.act == 'run1' or thief.act == 'run2' then thief.draw_run1() end
    enemies.draw()
    draw_pinecone_ui()
    -- mogu_hit()
    -- jinji_hit()
    -- lupai_hit()
    update_map_trigger()
    update_trigger()
    -- map_col.update_trg()
    -- camera(player.pos_x-64, 0)

end

-->8
--> global-1
object_table = {}
---------------ËÆ°Ê‚ùé∂Â‚ñ•®-------------------
newtimer = function ()
    local o = {
        timers = {}
    }
    o.add_timeout = function (name, timeout, callback)
        local start = time()
        local t = {'timeout', start, timeout, callback}
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
            end
        end
    end
    return o
end

----------------------------------------

----------------ÂÆû‰æ‚¨ÖÔ∏èÂüòê‚àßÂØπË±°---------------
--sp(ÂõæÔøΩÏõÉ‚ô•Á¥¢ÔøΩÀá)--pos_x,pos_y(ÂÆûÔøΩ‚¨ÖÔ∏èÔøΩüòê‚àßÔøΩ‚Ä¶ÔøΩ‚ô•)--width,height(ÂõæÔøΩÏõÉ‚ô•ÔøΩ‚ñ§Â∫¶ÔøΩüòêÂÆΩÂ∫¶)--
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
        flip_x = false,
        flip_y = false,
    }
    spr_obj.destroy_cllision = {}
    spr_obj.destroy = function()
      if spr_obj.destroy_trigger_enter then
        spr_obj.destroy_trigger_enter()
      end
      if spr_obj.destroy_trigger_stay then
        spr_obj.destroy_trigger_stay()
      end
      if spr_obj.destroy_trigger_stay then
        spr_obj.destroy_trigger_stay()
      end
      if spr_obj.destroy_cllision then
          for v in all(spr_obj.destroy_cllision) do
              v()
          end
      end
      if spr_obj.destroy_map_enter then
        spr_obj.destroy_map_enter()
      end
      -- object_table[obj_idx] = nil
      del(object_table, spr_obj)
    end

    add(object_table, spr_obj)
    return spr_obj
end
----------------------------------------

-------------Áõ‚òÖ‰Ω‚ßóÁ¢∞Ê‚òÖûÔº‚òâËß¶Â‚óÜ‚û°Ô∏èÂû‚¨ÖÔ∏èÔºÏõÉ--------------
trigger_table = {}

function update_trigger()
    for _, v in pairs(trigger_table) do
        v()
    end
end

local function trigger(sprit_1, sprit_2, half_type)
    local hit = false

    local x1 = sprit_1.pos_x
    local x2 = sprit_2.pos_x
    local w1 = sprit_1.width * 8
    local w2 = sprit_2.width * 8
    local y1 = sprit_1.pos_y
    local y2 = sprit_2.pos_y
    local h1 = sprit_1.height * 8
    local h2 = sprit_2.height * 8

    if half_type == "up" then
        h1 = h1/2
        y1 = y1 + h1
    elseif half_type == "down" then
        h1 = h1/2
    elseif half_type == "left" then
        w1 = w1/2
        x1 = x1 + w1
    elseif half_type == "right" then
        w1 = w1/2
    end

    local xd = abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
    local xs = w1 * 0.5 + w2 * 0.5 - 2
    local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
    local ys = h1 / 2 + h2 / 2 - 2
    if xd < xs and yd < ys then
      hit = true
    end
    return hit
end

function ontrigger_enter(sprit_1, sprit_2, enter_func, trigger_name, half_type)
    local entered = false
    local is_trigger = false
    local function trigger_enter ()
        is_trigger = trigger(sprit_1, sprit_2, half_type)
        if not entered and is_trigger then
            enter_func()
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
    end

    local idx = #trigger_table + 1
    add(trigger_table, trigger_enter)
    sprit_1.destroy_trigger_enter = function()
      trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_enter = function()
      trigger_table[idx] = nil
    end

    return trigger_enter
end

function ontrigger_stay(sprit_1, sprit_2, stay_func, trigger_name)
    local function trigger_stay()
        if trigger(sprit_1, sprit_2) then
            stay_func()
        end
    end

    local idx = #trigger_table + 1
    add(trigger_table, trigger_stay)
    sprit_1.destroy_trigger_stay = function()
      trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_stay = function()
      trigger_table[idx] = nil
    end

    return trigger_stay
end


-------------Áõ‚òÖ‰Ω‚ßóÁ¢∞Ê‚òÖûÔº‚òâÁ¢∞Ê‚òÖûÂû‚¨ÖÔ∏èÔºÏõÉ--------------
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

            -- print(xd)
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

            -- print(yd)
            if yd <= ys and xd < xs then
                sprit_1.vecter.y = 0
                if cllision_func then
                    if cllision_func.height then cllision_func.height() end
                end
            end
        end,
    }
    -- local idx = #cllision_table + 1
    add(cllision_table, tbl)

    local destroy_func = function()
        del(cllision_table, tbl)
    end
    add(sprit_1.destroy_cllision, destroy_func)

    add(sprit_2.destroy_cllision, destroy_func)

end
---------------------------------------

--------------Âú∞ÂΩ¢Á¢∞Ê‚òÖû-------------------
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


----------------------Â‚òâõÂª∫Â‚åÇ®Á‚¨ÜÔ∏èª-------------------
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

-------------Â‚òâ‚ô•Ê‚ô™¢Â‚åÇ®Á‚¨ÜÔ∏èª----------------
function change_animation(spr_obj, ani_flag)
    spr_obj.animation = spr_obj.animation_table[ani_flag]
end

-----------Â‚åÇ®Á‚¨ÜÔ∏èªÊ‚òÖ≠Ê‚¨ÜÔ∏èæ---------------
function update_animation()
    for v in all(object_table) do
        if v.animation then
            v.animation()
        end
    end
end

function load_level (cart_name)
    -- load spritesheet
    reload(0x0, 0x0, 0x1000, cart_name)
	reload(0x1000, 0x1000, 0x1000, cart_name)
    -- load map
	reload(0x2000, 0x2000, 0x1000, cart_name)
    -- load flag
	reload(0x3000, 0x3000, 0x0100, cart_name)
end

function init_change_camera()
  local camera_pos = string_to_array(cfg_levels.level1.camera_pos)
  local old_camera_pos_x = camera_pos[1]*8
  local old_camera_pos_y = camera_pos[2]*8
  local now_camera_pos_x = camera_pos[1]*8
  local now_camera_pos_y = camera_pos[2]*8
  local flip_x = false
  local flip_y = false
  local fix_driction_x = 0
  local fix_driction_y = 0
  local reset_player = false
  local reset_player_x = 0
  local reset_player_y = 0
  local function change(level)
    local camera_pos = string_to_array(cfg_levels["level" .. level].camera_pos)
    now_camera_pos_x = camera_pos[1]*8
    now_camera_pos_y = camera_pos[2]*8
    flip_x = old_camera_pos_x > now_camera_pos_x
    flip_y = old_camera_pos_y > now_camera_pos_y
    fix_driction_x = now_camera_pos_x - old_camera_pos_x
    fix_driction_y = now_camera_pos_y - old_camera_pos_y
    if abs(fix_driction_x) > 130 or fix_driction_y ~= 0 then
        reset_player = true
        local player_start_pos = string_to_array(cfg_levels["level" .. level].player_start_pos)
        reset_player_x = player_start_pos[1]
        reset_player_y = player_start_pos[2]
    end
    shake.camera_x = now_camera_pos_x
  end
  local function update()
    local changed_x = false
    local changed_y = false
    if fix_driction_x * (flip_x and -1 or 1) > 0 then
      old_camera_pos_x = old_camera_pos_x + cfg_camera_move_speed.x * (flip_x and -1 or 1)
      fix_driction_x = fix_driction_x + cfg_camera_move_speed.x * (flip_x and 1 or -1)
    else
      changed_x = true
    end
    if fix_driction_y * (flip_y and -1 or 1) > 0 then
      old_camera_pos_y = old_camera_pos_y + cfg_camera_move_speed.y * (flip_y and -1 or 1)
      fix_driction_y = fix_driction_y + cfg_camera_move_speed.y * (flip_y and 1 or -1)
    else
      changed_y = true
    end
    camera_location.x = old_camera_pos_x
    camera_location.y = old_camera_pos_y
    if changed_x and changed_y then
        if reset_player then
            player.pos_x = reset_player_x*8 + camera_location.x
            player.pos_y = reset_player_y*8 + camera_location.y
            reset_player = false
        end
          old_camera_pos_x = now_camera_pos_x
          old_camera_pos_y = now_camera_pos_y
          camera_location.x = old_camera_pos_x
          camera_location.y = old_camera_pos_y
      return true
    else
      return false
    end
  end
  return {
    change = change,
    update = update,
  }
end

function game_over()
  sfx(13)
  if player.hand_songzi >0 then
    player_pinecone = player_pinecone - player.hand_songzi
  end
  change_level(game_level)
end

function change_level(level)
  if level == 12 and game_season == "winter" then
    season_shift("spring")
    return
  end
  if level == 8 and game_season == "spring" then
    season_shift("summer")
    return
  end
  if level == 8 and game_season == "summer" then
    return
  end
  if game_level ~= level then
    local current_level_songzi = cfg_levels["level" .. game_level].songzi
    for i=1,#current_level_songzi do
      current_level_songzi[i] = this_songzi_cfg[i]
      this_songzi_cfg[i] = nil
    end
  end
  game_state_flag = "change_level"

  for v in all(enemies.enemies) do
      v.destroy()
  end
  songzi.destroy()
  if boxs_table then
      boxs_table.destroy()
  end
  if ices_table then
     ices_table.destroy()
 end
  for i = 1 ,#this_songzi_cfg do
    this_songzi_cfg[i] = nil
  end

  local level_cfg = cfg_levels["level" .. level]
  if level_cfg.change_map then
    change_map(level_cfg.change_map)
  end
  enemies = init_enemies(level_cfg.enemy_bees, level_cfg.enemy_catepillers)
  if level_cfg.ice and #level_cfg.ice ~= 0 then
      ices_table = init_ices(level_cfg.ice)
  end
  if level_cfg.box and #level_cfg.box ~= 0 then
      boxs_table = init_boxs(level_cfg.box)
  end
  if #level_cfg.songzi ~= 0 then
    for i = 1 ,#level_cfg.songzi do
      this_songzi_cfg[i] = level_cfg.songzi[i]
    end
    if #this_songzi_cfg ~= 0 then
      songzi = init_songzis(this_songzi_cfg)
    end
  end

  for v in all(changed_map) do
    mset(v[1], v[2], v[3])
    del(changed_map, v)
  end

  local camera_pos = string_to_array(level_cfg.camera_pos)
  local camera_pos_x = camera_pos[1]*8
  local camera_pos_y = camera_pos[2]*8
  if level == game_level then
    local player_pos = string_to_array(level_cfg.player_start_pos)
    player.pos_x = player_pos[1]*8 + camera_pos_x
    player.pos_y = player_pos[2]*8 + camera_pos_y
  end
  player.hand_songzi = 0
  change_camera.change(level)
  if game_season == "winter" then
    if level == 5 then
      shake.state = 'start'
      timer.add_timeout('shake', 2, function()
          shake.state = 'init'
          load_level("ruin.p8")
      end)
    elseif level == 6 then
      load_level("winter.p8")
    end
  end

end

local fadetable = {
    '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
    '1,1,1,1,1,1,1,0,0,0,0,0,0,0,0',
    '2,2,2,2,2,2,1,1,1,0,0,0,0,0,0',
    '3,3,3,3,3,3,1,1,1,0,0,0,0,0,0',
    '4,4,4,2,2,2,2,2,1,1,0,0,0,0,0',
    '5,5,5,5,5,1,1,1,1,1,0,0,0,0,0',
    '6,6,13,13,13,13,5,5,5,5,1,1,1,0,0',
    '7,6,6,6,6,13,13,13,5,5,5,1,1,0,0',
    '8,8,8,8,2,2,2,2,2,2,0,0,0,0,0',
    '9,9,9,4,4,4,4,4,4,5,5,0,0,0,0',
    '10,10,9,9,9,4,4,4,5,5,5,5,0,0,0',
    '11,11,11,3,3,3,3,3,3,3,0,0,0,0,0',
    '12,12,12,12,12,3,3,1,1,1,1,1,1,0,0',
    '13,13,13,5,5,5,5,1,1,1,1,1,0,0,0',
    '14,14,14,13,4,4,2,2,2,2,2,1,1,0,0',
    '15,15,6,13,13,13,5,5,5,5,5,1,1,0,0'
}

function fade(i)
    for c=0,15 do
        if flr(i+1)>=16 then
            pal(c,0)
        else
            pal(c,string_to_array(fadetable[c+1])[flr(i+1)])
        end
    end
end

function fade_out(season)
    for i=1,16 do
        timer.add_timeout('fade'..i, i*0.1, function()
            fade(i)
            if i == 16 and season then
              season_shift(season)
            end
        end)
    end
end

function string_to_array(str)
    local result = {}
    local num = ''
    for i=1,#str do
        local s = sub(str, i, i)
        if s ~= ',' then
            num = num..s
        else
            add(result, tonum(num))
            num = ''
        end
    end
    add(result, tonum(num))
    return result
end

function table_from_string(str)
  local tab, is_key = {}, true
  local key,val,is_on_key
  local function reset()
    key,val,is_on_key = '','',true
  end
  reset()
  local i, len = 1, #str
  while i <= len do
    local char = sub(str, i, i)
    -- token separator
    if char == '\31' then
      if is_on_key then
        is_on_key = false
      else
        tab[tonum(key) or key] = val
        reset()
      end
    -- subtable start
    elseif char == '\29' then
      local j,c = i,''
      -- checking for subtable end character
      while (c ~= '\30') do
        j = j + 1
        c = sub(str, j, j)
      end
      tab[tonum(key) or key] = table_from_string(sub(str,i+1,j-1))
      reset()
      i = j
    else
      if is_on_key then
        key = key..char
      else
        val = val..char
      end
    end
    i = i + 1
  end
  return tab
end

function init_config (config_table)
    local result = {}
    for level,data in pairs(config_table) do
        result[level] = table_from_string(data)
    end
    return result
end

function _update()
    update_state_flag = game_state_flag .. "_update"
    game_states.update_states[update_state_flag]()
end

function _draw()
    cls()
    camera(camera_location.x, camera_location.y)
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

-->8
-->map-3
function get_map_flage(m_x, m_y)
  return fget(mget(m_x/8+map_location.x,m_y/8+map_location.y))
end

map_trigger_tbl = {}

function update_map_trigger()
  for v in all(map_trigger_tbl) do
    v()
  end
end

function map_trigger(obj, flag, direction)
    local x = obj.pos_x
    local y = obj.pos_y
    local w = obj.width * 8
    local h = obj.height * 8
    local x1, x2, y1, y2 = 0, 0, 0, 0
    if direction == 'left' then
        x1 = x
        y1 = y
        x2 = x
        y2 = y + h
    elseif direction == 'right' then
        x1 = x + w
        y1 = y
        x2 = x + w
        y2 = y + h
    elseif direction == 'up' then
        x1 = x
        y1 = y
        x2 = x + w
        y2 = y
    elseif direction == 'down' then
        x1 = x
        y1 = y + h
        x2 = x + w
        y2 = y + h
    elseif direction == 'all' then
        x1 = x + 2
        y1 = y + 2
        x2 = x + w - 2
        y2 = y + h - 2
    end

    -- if get_map_flage(x1, y1) == flag or get_map_flage(x2, y2) == flag
    --     or get_map_flage(x1, y2) == flag or get_map_flage(x2, y1) == flag then
    --         return true
    -- end
    if get_map_flage(x1, y1) == flag then
        return true, x1, y1
    end
    if get_map_flage(x2, y2) == flag then
        return true, x2, y2
    end
    if get_map_flage(x1, y2) == flag then
        return true, x1, y2
    end
    if get_map_flage(x2, y1) == flag then
        return true, x2, y1
    end
    return false, 0, 0
end

function map_trigger_enter(obj, map_flag, enter_func, direction)
    local entered = false
    local is_trigger = false
    local enter_x
    local enter_y
    local function trigger_enter ()
        is_trigger, enter_x, enter_y = map_trigger(obj, map_flag, direction)
        if not entered and is_trigger then
            enter_func(enter_x, enter_y)
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
    end
    obj.destroy_map_enter = function()
      del(map_trigger_tbl, trigger_enter)
    end

    add(map_trigger_tbl, trigger_enter)
    return trigger_enter
end

function map_trigger_stay(obj, map_flag, stay_func, direction)
    local function trigger_stay()
        if map_trigger(obj, map_flag, direction) then
            stay_func()
        end
    end

    add(map_trigger_tbl, trigger_stay)
    return trigger_stay
end

function init_map_animation(map_ani_flag, update_time, max_sp, is_flip)
    local time = 0
    max_sp = max_sp*(is_flip and -1 or 1)
    local map_ani_table = {}
    local timer = 1
    for x=0, 127 do
        for y=0, 31 do
            if fget((mget(x, y)), map_ani_flag) then
                local one = {
                    x = x,
                    y = y,
                    sp = mget(x, y),
                }
                add(map_ani_table, one)
            end
        end
    end
    local function update()
        if timer <= update_time then
            timer = timer + 1
            return
        end
        for s in all(map_ani_table) do
            -- s.sp = s.sp + (time == 0 and 1 or -1)
            mset(s.x, s.y, s.sp + time)
        end
        time = time + (is_flip and -1 or 1)
        timer = 1
        if time == max_sp then
            time = 0
        end
    end
    return {
        update = update,
    }
end

function change_map(change_cfg)
  for v in all(change_cfg) do
    local sv = string_to_array(v)
    mset(sv[1], sv[2], sv[3])
  end
end

-->8
-- objects
function init_chest ()
    local c = init_spr("chest", 139, 9, 80, 2, 2, true, 0, 0)
     c.pinecone = 5
     c.draw = function ()
         print(c.pinecone..'/'..10, c.pos_x, c.pos_y, 4)
     end
     return c
end

function init_songzis(songzi_config)
  local s = {
    table = {},
  }
  for i = 1 , #songzi_config do
    local s_cfg = string_to_array(songzi_config[i])
    local pos_x, pos_y = s_cfg[1], s_cfg[2]
    local b = init_spr("songzi", 141, pos_x, pos_y, 1, 1, false, 0, 0)
    init_animation(b, 141, 142, 5, "move", true)
    ontrigger_enter(b, player, function()
      sfx(8)
      b.destroy()
      player_pinecone = player_pinecone + 1
      player.hand_songzi = player.hand_songzi + 1
      songzi_config[i] = nil
    end)
    add(s.table, b)
  end
  s.destroy = function()
    for v in all(s.table) do
      v.destroy()
    end
  end
  return s
end

-- enemy could be bee or catepiller, depends on type args
function init_enemy (pos_x, pos_y, max_range, speed, flip_x, flip_y, type)
    local e
    if type == 'bee' then
        e = init_spr("bee", 48, pos_x, pos_y, 1, 1, false, 0, 0)
        init_animation(e, 48, 50, 10, "move", true)
        ontrigger_enter(e, player, function()
          game_over()
        end)
        e.sound = init_sound(30, 50)
    elseif type == 'catepiller_x' then
        e = init_spr("catepiller_x", 34, pos_x, pos_y, 1, 1, true, 0, 0)
        init_animation(e, 34, 35, 10, "move", true)
        ontrigger_enter(e, player, function()
            game_over()
        end, "up")
    elseif type == 'catepiller_y' then
        e = init_spr("catepiller_y", 34, pos_x, pos_y, 1, 1, false, 0, 0)
        init_animation(e, 36, 37, 10, "move", true)
        ontrigger_enter(e, player, function()
            game_over()
        end, flip_x and "right" or "left")
    end


    e.flip_x = flip_x
    e.flip_y = flip_y
    e.update = function ()
        if e.name == 'catepiller_x' or e.name == 'bee' then
            if not e.flip_x and e.pos_x > pos_x + max_range then
                e.flip_x = true
            end
            if e.flip_x and e.pos_x < pos_x - max_range then
                e.flip_x = false
            end
            e.pos_x = e.pos_x + (e.flip_x and -speed or speed)
        elseif e.name == 'catepiller_y' then
            if not e.flip_y and e.pos_y < pos_y - max_range then
                e.flip_y = true
            end
            if e.flip_y and e.pos_y > pos_y + max_range then
                e.flip_y = false
            end
            e.pos_y = e.pos_y + (e.flip_y and speed or -speed)
        end
        if e.sound then
          e.sound.play()
        end
    end
    e.draw = function ()
        spr(e.sp, e.pos_x, e.pos_y, 1, 1, e.flip_x, e.flip_y)
    end
    return e
end

function init_enemies (bees_config, catepillers_config)
    local o = {
        enemies = {}
    }
    if bees_config then
      for i=1,#bees_config do
          local e = string_to_array(bees_config[i])
          local pos_x, pos_y, max_range, speed = e[1], e[2], e[3], e[4]
          local flip_x = e[5]==1 and true or false
          local flip_y = e[6]==1 and true or false
          local b = init_enemy(pos_x, pos_y, max_range, speed, flip_x, flip_y, 'bee')
          add(o.enemies, b)
      end
    end
    if catepillers_config then
      for i=1,#catepillers_config do
          local e = string_to_array(catepillers_config[i])
          local pos_x, pos_y, max_range, speed = e[1], e[2], e[3], e[4]
          local flip_x = e[5]==1 and true or false
          local flip_y = e[6]==1 and true or false
          local direction = e[7]==1 and 'y' or 'x'
          local c
          if direction == 'x' then
              c = init_enemy(pos_x, pos_y, max_range, speed, flip_x, flip_y, 'catepiller_x')
          elseif direction == 'y' then
              c = init_enemy(pos_x, pos_y, max_range, speed, flip_x, flip_y, 'catepiller_y')
          end
          add(o.enemies, c)
      end
    end
    o.update = function ()
        for i=1,#o.enemies do
            local e = o.enemies[i]
            e.update()
        end
    end
    o.draw = function ()
        for i=1,#o.enemies do
            local e = o.enemies[i]
            e.draw()
        end
    end
    return o
end

function draw_pinecone_ui()
    local ui_x = 125
    for i = 1, max_pinecone_num do
        if i <= player_pinecone then
            spr(142, ui_x - 6 * i + camera_location.x, 2 + camera_location.y)
        else
            spr(143, ui_x - 6 * i + camera_location.x, 2 + camera_location.y)
        end
    end
end

function init_player()
  local player = init_spr("player", 192, 30, 10, 1, 1, true)
  player.state = "nomal"
  player.ground = 1
  player.new_ground = 2
  player.max_jump = 1
  player.can_jump = 1
  player.hand_songzi = 0
  player.on_ground = false
  player.climb_flag = 1

  player.anction_range = function()
    if (player.pos_x < 0) player.pos_x = 1
    if game_level == 9 and game_season == "autum" then
        if (player.pos_x < 515) player.pos_x = 516
        if (player.pos_x > 624) player.pos_x = 624
    end
  end

  player.player_states = {
    states_x = {
      nomal = function()
        player.vecter.x = 0
      end,
      fast_go_left = function()
        player.vecter.x -= player_acceleration_fast
      end,
      fast_back = function()
        if abs(player.vecter.x) < player_acceleration_low then
          player_state_x_flag = "nomal"
        else
          if (player.vecter.x > 0) then
            player.vecter.x -= player_acceleration_low
          elseif (player.vecter.x < 0) then
            player.vecter.x += player_acceleration_low
          end
        end
      end,
      fast_go_right = function()
        player.vecter.x += player_acceleration_fast
      end,
      fast_go_stay = function()
        player.vecter.x = player.vecter.x > 0 and player_max_v or (-1 * player_max_v)
      end
    },
    states_y = {},
  }

  player.on_ground_function = function()
    player.can_jump = player.max_jump
    if player.state ~= "nomal" and player.vecter.y > 0 then
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

    if player.vecter.y ~= 0 then
        player.pos_y = (player.vecter.y>0) and flr((player.pos_y + player.vecter.y)/8)*8 or flr((player.pos_y + player.vecter.y)/8)*8 + 8
    end

    player.vecter.y = 0
    player.on_ground = true
  end

  player.climb_function = function(map_flag)
      local map_y = player.pos_y + player.height*8+7
      if player.state == "jump" and get_map_flage(player.pos_x, map_y) ~= map_flag then-- (mget(player.pos_x, map_y - 6, 1) or get_map_flage(player.pos_x + (player.flip_x and -3 or (player.width*8 + 2)), player.pos_y - 8) == 1) and
        -- local map_x = player.pos_x + (player.flip_x and 0 or (player.width*8))

        player.state = "climb"
        player.can_jump = 1
        change_animation(player, "climb")
        change_animation(tail, "climb")
        player.is_physic = false
        player.vecter.y = 0
        player.climb_flag = map_flag
      end
  end

  player.update = function()
  end

  player.hit = function()
    hit(player, 1, "height", function()
        player_acceleration_fast = cfg_player_acceleration_fast
        player_acceleration_low = cfg_player_acceleration_low
        player_max_v = cfg_player_max_v
      player.on_ground_function()
      player.on_floor = 0
    end)
    hit(player, 1, "width", function()
      if player.vecter.x ~= 0 then
        player.pos_x = (player.vecter.x>0) and flr((player.pos_x + player.vecter.x)/8)*8 or flr((player.pos_x + player.vecter.x)/8)*8 + 8
      end
      player.vecter.x = 0

      player.climb_function(1)
    end)
    hit(player, player.new_ground, "height", function()
      player.can_jump = player.max_jump
      player.vecter.y = 0
    end)
    hit(player, player.new_ground, "width", function()
      player.vecter.x = 0
    end)

    hit(player, 14, "height", function()
        player_acceleration_fast = cfg_ice_acceleration_fast
        player_acceleration_low = cfg_ice_acceleration_low
        player_max_v = cfg_ice_max_v
        player.on_ground_function()
        player.on_ice = 0
    end)
    hit(player, 14, "width", function()
        if player.vecter.x ~= 0 then
          player.pos_x = (player.vecter.x>0) and flr((player.pos_x + player.vecter.x)/8)*8 or flr((player.pos_x + player.vecter.x)/8)*8 + 8
        end
        player.vecter.x = 0

        player.climb_function(14)
    end)
  end

  player.climb_jump = function()
    local btn_num = player.flip_x and 1 or 0
    local not_btn = player.flip_x and 0 or 1
    if btn(not_btn) then
      player.state = "nomal"
      change_animation(player, "nomal")
      change_animation(tail, "nomal")
    else
      player.state = "jump"
      change_animation(player, "jump")
      change_animation(tail, "jump")
      player.vecter.y = -3

      player.vecter.x = player.vecter.x + (player.flip_x and 2 or -2)
    end
    player.flip_x = not player.flip_x
    player.is_physic = true
  end

  player.mogu_hit = function(mogu_x, mogu_y)
      player.vecter.y = -1*cfg_mogu_jump
      change_animation(player, "jump")
      player.state = "jump"
      player.can_jump = 0
      mset(mogu_x/8, mogu_y/8, 85)
      sfx(10)
      timer.add_timeout("mogu_hit", 0.1, function()
          mset(mogu_x/8, mogu_y/8, 84)
      end)
  end

  player.check_position = function()
    if player.pos_x + 3 > camera_location.x + 128 then
      change_level(game_level+1)
      game_level = game_level + 1
    end
    if  player.pos_x + 8 < camera_location.x then
      -- printh("game_level- = " .. game_level, "dri")
      change_level(game_level-1)
      game_level = game_level - 1
    end
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

function init_thief ()
    local thief = init_spr("thief", 160, 20, 60, 1, 1, true)
    local thief_songzi = init_spr("thief_songzi", 141, thief.pos_x, thief.pos_y, 1, 1, false)
    init_animation(thief_songzi, 141, 142, 5, "nomal", true)
    thief.act = 'init'
    thief.mogu_jump_event = false
    thief.fall_event = false
    thief.flip_x = false
    thief.draw_run1 = function ()
        -- thief_mogu_hit()
        spr(thief.sp, thief.pos_x, thief.pos_y, 1, 1)
        thief_songzi.pos_x = thief.pos_x
        thief_songzi.pos_y = thief.pos_y - 6
    end
    local tail = init_spr("tail", 224, thief.pos_x - 8, thief.pos_y, 1, 1, false, 0, 0)
    init_animation(tail, 0, 0, 10, "nomal", true)
    init_animation(tail, 179, 182, 10, "run", true)
    init_animation(tail, 163, 166, 10, "jump", true)
    init_animation(tail, 0, 0, 10, "climb", true)
    tail.update = function()
      tail.flip_x = thief.flip_x
      tail.pos_x = thief.pos_x + (tail.flip_x and 8 or - 8)
      tail.pos_y = thief.pos_y
    end
    thief.update_run1 = function ()
        if not thief.mogu_jump_event then
            thief.state = 'run'
            change_animation(thief, 'run')
            change_animation(tail, 'run')
            thief.pos_x += 2
        end
        if thief.pos_x >= 68 and not thief.mogu_jump_event then
            thief.vecter.y -= 4
            thief.vecter.x += 0.5
            thief.mogu_jump_event = true
        end
        if thief.pos_x >= 96 then
            hit(thief, 1, "width", function()
                thief.vecter.x = 0
                thief.vecter.y = -3
                timer.add_timeout('thief_move', 0.1, function()
                    thief.vecter.x = 2
                end)
            end)
        end
        tail.update()
        if thief.pos_x >= 520 then
            thief.vecter.x = 0
            thief.act = 'run2'
        end
    end
    thief.mogu_hit = function()
        change_animation(thief, 'jump')
        change_animation(tail, 'jump')
        thief.vecter.y = -5
        timer.add_timeout('thief_jump', 0.1, function()
            thief.vecter.x = 1
        end)
    end
    thief.draw_run2 = function ()
    end
    thief.update_run2 = function ()
        if not (thief.pos_x >= 584) then
            change_animation(thief, 'run')
            change_animation(tail, 'run')
            thief.pos_x += 2
        else
            if not thief.fall_event then
                thief.state = 'fall'
                thief.vecter.x = 0
                change_animation(thief, 'fall')
                change_animation(tail, 'nomal')
                timer.add_timeout('thief_run', 1, function()
                    change_animation(thief, 'run')
                    change_animation(tail, 'run')
                    thief.state = 'run'
                    init_songzis({
                      '584,88',
                      '600,88',
                      '552,88',
                      '576,88',
                      '616,88',
                    })
                    thief_songzi.destroy()
                end)
                thief.fall_event = true
            end
            if thief.state ~= 'fall' then thief.pos_x += 2 end
        end
        tail.update()
    end
    thief_mogu_hit = map_trigger_enter(thief, 3, thief.mogu_hit, "down")
    -- init_animation(thief, 160, 162, 10, "nomal", true)
    init_animation(thief, 167, 170, 10, "run", true)
    init_animation(thief, 183, 186, 10, "jump", true)
    init_animation(thief, 176, 177, 10, "climb", true)
    init_animation(thief, 178, 178, 10, "fall", false)
    return thief
end

function init_sandy ()
    local sandy = {x=600, y=88}
    sandy.act = 'init'
    sandy.draw = function ()
        spr(187, sandy.x, sandy.y, 1, 1, true)
        sspr(8, 96, 16, 16, 600, 80)
    end
    sandy.update = function ()
        sandy.x -= 0.1
        if sandy.x <= 592 then
            sandy.x = 592
            fade_out("winter")
            sandy.act = 'init'
            -- season_shift("winter")

        end
    end
    return sandy
end

function init_comoon_box(box)
    box.down_dis = 0
    box.can_hit = false
    box.can_move = true
    map_trigger_enter(box, 7, function(zhui_x, zhui_y)
      -- printh("box_enter==============", "dir")
      local x, y = zhui_x/8, zhui_y/8
      local one = {x, y, mget(x, y)}
      add(changed_map, one)
      mset(x, y, 0)
    end, "all")
    oncllision(box, player, {
      height = function()
        player.on_ground_function()
        player.vecter.y = box.vecter.y
      end,
      width = function()
          hit(box, 1, "width", function()
              box.can_move = false
          end)
          if not box.can_move then
              player.vecter.x = 0
              if player.pos_x ~= box.pos_x then
                player.pos_x = box.pos_x + (box.pos_x > player.pos_x and - 8 or 8)
              end
              return
          end
          local player_v_x = player.vecter.x
          if abs(player_v_x) >= cfg_box_max_v then
              player.vecter.x = player_v_x > 0 and cfg_box_max_v or -1*cfg_box_max_v
          end
          box.vecter.x = player_v_x
      end,
    })
    box.update = function()
      hit(box, 1, "height", function()
        box.down_dis = 0
        box.can_hit = false
      end, function()
        if box.down_dis >= 13 then box.can_hit = true end
        box.down_dis = box.down_dis + box.vecter.y
      end)

      hit(box, 1, "width", function()
          box.can_move = false
      end)
      box.vecter.x = 0
    end
end

function init_ices(ice_config)
    local ices = {
      table = {},
    }
    local function init_ice(pos_x, pos_y, is_songzi)
        local sp = is_songzi and 196 or 212
        local ice = init_spr("ice", sp, pos_x, pos_y, 1, 1, true, 0, 0)
        init_comoon_box(ice)
        ice.is_songzi = is_songzi

        for v in all(ices.table) do
            oncllision(ice, v, {
                width = function()
                  ice.can_move = false
                  ice.vecter.x = 0
                end,
                height = function()
                    ice.pos_y = v.pos_y - 8
                    ice.vecter.y = 0
                    ice.down_dis = 0
                    if ice.can_hit or v.can_hit then
                        v.destroy()
                        ice.destroy()
                    end
                end,}
            )
        end
        return ice
    end

    if ice_config then
        for i = 1 , #ice_config do
            local cfg_tbl = string_to_array(ice_config[i])
            local pos_x, pos_y, is_songzi = cfg_tbl[1], cfg_tbl[2], cfg_tbl[3]
            ice = init_ice(pos_x, pos_y, is_songzi)
            ice.idx = i
            add(ices.table, ice)
        end
    end

    ices.destroy = function()
        for v in all(ices.table) do
            v.destroy()
        end
    end

    ices.update = function()
        for v in all(ices.table) do
            hit(v, 1, "height", function()
                if v.can_hit then
                    v.destroy()
                end
            end)
            v.update()
        end
    end

    return ices
end

function init_boxs(box_config)
  local boxs = {
    table = {},
  }

  local function init_box(pos_x, pos_y)
    local box = init_spr("box", 192, pos_x, pos_y, 1, 1, true, 0, 0)

    init_comoon_box(box)

    for bin_kuai in all(ices_table.table) do
        oncllision(box, bin_kuai, {
            width = function()
              box.pos_x = bin_kuai.pos_x + (box.pos_x > bin_kuai.pos_x  and 8 or -8)
              box.can_move = false
              box.vecter.x = 0
            end,
          height = function()
            bin_kuai.pos_y = bin_kuai.pos_y - bin_kuai.vecter.y
            local b_y, k_y = box.pos_y, bin_kuai.pos_y
            box.pos_y = k_y + ((b_y > k_y) and 8 or -8) + cfg_box_gravity
            -- box.pos_y = k_y - 8
            box.vecter.y = 0
            box.down_dis = 0
            bin_kuai.vecter.y = 0
            bin_kuai.down_dis = 0
            if box.can_hit then bin_kuai.destroy() end
            box.can_hit = false
            bin_kuai.can_hit = false
          end,
        })
    end

    for v in all(boxs.table) do
        oncllision(box, v, {
          width = function()
              box.vecter.x = v.vecter.x
              box.can_move = false
          end,
          height = function()
            box.pos_y = v.pos_y - 8
            box.vecter.y = 0
          end,
        })
    end

    return box
  end

  for i = 1 , #box_config do
    local cfg_tbl = string_to_array(box_config[i])
    local b_x, b_y = cfg_tbl[1], cfg_tbl[2]
    local box = init_box(b_x, b_y, bin_kuai)
    box.idx = i
    add(boxs.table, box)
  end

  boxs.destroy = function()
      for v in all(boxs.table) do
          v.destroy()
      end
  end

  boxs.update = function()
      for v in all(boxs.table) do
          v.update()
      end
  end

  return boxs
end

-->8
-->game_cfg

cfg_player_acceleration_fast = 0.3 -- ÔøΩ‚û°Ô∏èÊ≠•ÔøΩ‚åÇÔøΩÔøΩ‚ñàÔøΩÂ∫¶
cfg_player_acceleration_low = 0.6 -- ÔøΩ‚û°Ô∏èÊ≠•ÔøΩ‚ô•‚óÜÔøΩ‚ñàÔøΩÂ∫¶
cfg_player_max_v = 1.8 -- ÔøΩ‚ñàÂ§ßÔøΩ‚ñàÔøΩÂ∫¶
cfg_ice_acceleration_fast = 0.1--Â‚óè∞Èù¢Â‚åÇ†È‚ñàüÂ∫¶
cfg_ice_acceleration_low = 0.1--Â‚óè∞Èù¢Â‚ô•‚óÜÈ‚ñàüÂ∫¶
cfg_ice_max_v = 3 -- Â‚óè∞Èù¢Êú‚ñàÂ§ßÈ‚ñàüÂ∫¶

cfg_jump_speed = 3 -- Ë∑≥ÔøΩ‚¨áÔ∏èÔøΩ‚ñàÔøΩÂ∫¶
cfg_climb_speed = 1.6 -- ÔøΩ‚òâÔøΩÔøΩ‚ñ•ÔøΩ‚ñàÔøΩÂ∫¶
cfg_gravity = 0.3 -- ÔøΩ‚ô•‚ô™ÔøΩ‚åÇÔøΩ(ÔøΩ‚Ä¶‚û°Ô∏èÔøΩ‚¨ÖÔ∏èÔøΩ‚ñëÔøΩ‚åÇÔøΩÔøΩ‚ñàÔøΩÂ∫¶)

cfg_mogu_jump = 4 -- ÔøΩ‚ô•‚ô•ÔøΩ‚ñ§‚û°Ô∏èÔøΩ‚óÜ‚ô•Ë∑≥ÔøΩ‚¨áÔ∏èÔøΩ‚ñàÔøΩÂ∫¶
cfg_camera_move_speed = { -- ÔøΩ‚òâ‚ô•ÔøΩ‚ô™ÔøΩÂú∞ÂõæÔøΩ‚ùéÔøΩÔøΩÀáÔøΩÂ§¥ÁßªÔøΩ‚åÇÔøΩÔøΩ‚ñàÔøΩÂ∫¶
  x = 5,
  y = 5,
}

cfg_box_gravity = 0.1 --ÁÆ±Â≠‚Ä¶Áö‚ñëÈ‚ô•‚ô™Â‚åÇõ
cfg_box_max_v = 1.5 --ÊüÖæÔ∏è®ÁÆ±Â≠‚Ä¶Êú‚ñàÂ§ßÈ‚ñàüÂ∫¶
cfg_box_max_y = 3 --ÁÆ±Â≠‚Ä¶Â‚òÖüòêÂ‚óè∞Âù‚ùéyËΩ¥Áö‚ñëÊú‚ñàÂ§ßÈ‚ñàüÂ∫¶

cfg_levels_autumn = {
  level1 = 'enemy_catepillerscamera_pos0,0icesboxsongzi140,88enemy_beesplayer_start_pos0,7',
  level2 = 'songzi1208,48icesenemy_catepillersenemy_beescamera_pos16,0player_start_pos0,7box',
  level3 = 'player_start_pos0,7icesenemy_beessongzi1288,642352,48camera_pos32,0boxenemy_catepillers',
  level4 = 'songzi1432,72icescamera_pos48,0player_start_pos0,7enemy_bees1432,64,24,0.5,0enemy_catepillers1432,72,24,0.5,1box',
  level5 = 'player_start_pos0,7camera_pos0,0songzienemy_catepillersicesboxenemy_beeschange_map123,11,2224,11,2342,7,16442,8,16542,9,16642,10,16763,9,16863,10,16963,11,16',
  level6 = 'songzienemy_catepillers1216,48,8,0.5player_start_pos0,5enemy_beesboxicescamera_pos16,0',
  level7 = 'boxenemy_bees1280,64,16,0.52336,48,16,0.5songzicamera_pos32,0player_start_pos0,5icesenemy_catepillers1336,64,8,0.5,1,1,1',
  level8 = 'boxcamera_pos48,0icessongziplayer_start_pos0,5enemy_catepillers1432,72,24,0.5,02432,72,24,0.5,1enemy_bees1464,64,24,0.6',
  level9 = 'boxenemy_beesplayer_start_pos0,5songziicesenemy_catepillerscamera_pos64,0'
}

cfg_levels_winter = {
  level1 = 'camera_pos0,0songzi140,88enemy_catepillersplayer_start_pos0,7boxicesenemy_bees',
  level2 = 'enemy_beesboxicesplayer_start_pos0,7songzi1224,80camera_pos16,0enemy_catepillers',
  level3 = 'enemy_catepillerssongzi1336,48player_start_pos0,7ice1264,642352,803344,48boxcamera_pos32,0enemy_bees',
  level4 = 'camera_pos48,0box1416,40ice1416,64songzi1496,80player_start_pos0,8enemy_catepillersenemy_bees',
  level5 = 'iceboxenemy_catepillersplayer_start_pos0,7songzienemy_beescamera_pos0,0',
  level6 = 'enemy_catepillersbox1104,176ice140,184232,216,truesongzienemy_beescamera_pos0,16player_start_pos0,7',
  level7 = 'camera_pos16,16enemy_beesice1184,2162184,2083192,1924192,1685176,200,trueenemy_catepillersbox1176,168player_start_pos0,7songzi',
  level8 = 'songzi1288,192iceenemy_beesplayer_start_pos0,5enemy_catepillersbox1296,168camera_pos32,16',
  level9 = 'camera_pos48,16enemy_catepillersplayer_start_pos0,5box1416,168ice1424,216,trueenemy_beessongzi',
  level10='boxsongzienemy_beesice1552,168player_start_pos0,5enemy_catepillerscamera_pos64,16',
  level11='icebox1672,1522712,152enemy_catepillerssongziplayer_start_pos0,5enemy_beescamera_pos80,16',
}

cfg_levels_spring = {
  level1 = 'camera_pos0,16boxenemy_catepillerssongziplayer_start_pos0,11enemy_beesice',
  level2 = 'enemy_beesplayer_start_pos0,10box1160,176enemy_catepillersicecamera_pos16,16songzi1216,208',
  level3 = 'player_start_pos0,10iceenemy_catepillersboxsongzi1312,200camera_pos32,16enemy_bees',
  level4 = 'player_start_pos0,2enemy_catepillerscamera_pos48,16enemy_beesiceboxsongzi1448,192',
  level5 = 'enemy_beesenemy_catepillersicecamera_pos64,16songzi1592,184box1544,176player_start_pos0,2',
  level6 = 'player_start_pos3,11enemy_beesicebox1680,32camera_pos80,0enemy_catepillerssongzi1728,88',
  level7 = 'songziboxplayer_start_pos0,10enemy_beesenemy_catepillerscamera_pos96,0ice',
}


cfg_levels_summer = {
  level1 = 'songzienemy_catepillersenemy_beesboxplayer_start_pos0,11icecamera_pos0,16',
 level2 = 'enemy_beesplayer_start_pos0,10iceboxenemy_catepillerscamera_pos16,16songzi1192,184',
 level3 = 'songzicamera_pos32,16enemy_catepillersboxenemy_beesplayer_start_pos0,10ice',
 level4 = 'enemy_catepillersicesongzi1408,2162488,216player_start_pos0,10box1424,1762464,216camera_pos48,16enemy_bees',
 level5 = 'enemy_catepillers1560,216,24,0.5,0,0,02624,200,8,0.5,1,0,1iceplayer_start_pos0,10enemy_bees1536,200,16,0.5,0boxcamera_pos64,16songzi1528,216',
 level6 = 'camera_pos80,16enemy_catepillersiceboxsongzi1760,160player_start_pos0,8enemy_bees',
}

-->8
-->sound
sound_table = {}

function init_sound(num, timer)
  local sound_player = {}
  sound_player.timer = -1
  sound_player.play = function()
    if sound_player.timer < 0 then
      sfx(num)
      sound_player.timer = timer
    end
  end
  sound_player.update = function()
    if sound_player.timer >= 0 then
      sound_player.timer -= 1
    end
  end

  add(sound_table, sound_player)
  return sound_player
end

function sound_update()
  for v in all(sound_table) do
    v.update()
  end
end

__gfx__
00000000bbbbbbbb0800210066666666777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff100002106dddddd6777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000ffffbfff210811106d6dd6d6c777c777c777c77777c777c777c777c70000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff021222216ddd6dd6cc7ccc7ccc7ccc7c7ccc7ccc7ccc7ccc0000000000000000000000000000000000000000000000000000000000000000
00000000fbffffff001200806dd6ddd6cccc7ccccccccccccc7ccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff001200006d6dd6d6cccccccccccccc7ccccccccccccc7ccc0000000000000000000000000000000000000000000000000000000000000000
00000000fffffbff010101206dddddd6ccccccccc7ccccccccccccc7cccccccc0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff2002100166666666ccccccc7ccccccccccccc7cccccccccc000000000000000000e000007777700000000000000000000000000000000000
00000000bbbbbbbb0000000077777777cccccccccccccccccccccccccccccccc00000000000000000ee000077777070000000000000000000000000000000000
00000000bbb3bbbb0000000077777777cc7ccccccccccccc7ccccccccccccccc0000000000000000000000777ee7777000007000000000008800000000000000
000000003b3f3b3b0000000077777777ccccccccccccccccccccccccccccccc70000000000000000000077777ee77ee77007eee0000000088780000000000000
00000000f3ff3b330000000077777777cccccccccccccccccccccccccccccccc000000000000000000077777eeee7eeee77eeeeeee0008888800000000000000
00000000fffff3ff0008000077777777cccccccccccccccccccccccccccccccc000000000000000000777777eeeeeeeeeeeeeeeeee00008888b0000000000000
00000000ffffffff0087800077777777ccccc7ccccccccccccc7cccccccccccc0000000000000000000077eeeeeeeeeeee777eee777000bbbb00000000000000
00000000fbffffff0888880077777777cccccccccccccccccccccccccccccccc0000000000000000000077eeeeeeeeeeeee7eeeee7777777bb00000000000000
00000000ffffffbf0077700077777777cccccccccccccccccccccccccccccccc000000000000000007777eeeeeeeeeeeeeeeeeeeeeee77777700000000000000
77777777ffffffff0000000000000000880000008800000000000000000000000000000e0000000777eeeeeeee7eeeeeeeeeeeeeeeeeee777700000000000000
77777777ffffffff0000000000000000dd000000dd0000000000000000000000000000eee00000e777eeeee777eeeeeeeeeeeeeeee7eeeee7700000000000000
77777777fffffbff0000000000000000880000000880000000000000000000000000000000000eeeeeeeeeee77eeeeeeeeeeeeeeee7eeeeee770000000e00000
77777777ffffffff0000000000000000dd00000000dd000000000000000000000000000000000eeeeeeeeeeee7eeeeeeeeeeeeee7777eeeeee7000000ee00000
77777777ffffffff000000000000d000880000000880000000b00000000b0000000000000007eeeeeeeeeeeeeeeeeeeeeeeeeeeee7777eeeeee7700000000000
77777777fbffffff000000000008d8008800000088000000000bbb00000b000000000000007eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee700000000000
77777777ffffffff08882828088808d88800000088000000000b0b00000bb0000000000007eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeeeeeeeee000000000
66666666ffffffff08882828088000d80000000000000000000b0000000b0b00000000007eeeeeeee7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7ee00000000
00000000000000000000000097777777bbbbbbbb000000000000000000080000000000007eeeeeeeee77eeeeeeeeeeee7eeee7eeeeeeeeeeeeee77ee00000000
760006706660006676000670d9999997b2bbb2bb000000000800000000000008000000007eeeeeeeeee77eeeeeeeeeeee7e77eeeeeeeeeeeeeeeeeeee0000000
776067707776067777606770d99999972d2b2d260000000000a0800000008000000000007eeeeeeeeee77eeeeeeeeeeeee777eeeeeeeeeeeeee7eeeee7000000
076067000777904007606700d99999972dddddd600000000000088000008880000000000eeeeeeeeee7eeeeee4eeeeeeeee7eeeeee4eeeeee7777ee7e7000000
007904000005500000790400d99999972dddddd670000000080898800088888000000000ceeeeeeee7eeeeeeeeeeeeeeeeeeeeeee4eeeeee77777eee70000000
005500000009900000550000d99999972dddddd6b07bbb000889a9800889998800000000ceeeeeeeeeeeeeeeee4eeeeeeeeeeeee4eeeeeeeeeee7eee00000000
009900000000500000099000d99999972dddddd67bbbbb30889aaa98889aa99800000000cceeeeeeeeeeeeeee444eeeeeeeeeeee4eeeeeeeeeeeeeee00000000
000570000000070000000570d99999972dddddd6b3bb337789aaaaa8899aaa9800000007eeeeeeeeeeeeeeeeeee44eeeeeeeeeef44eee7eeeeeeeee000000000
00000000000a000000770000000000000003300000ee3300000000000000000000000007eeeeeeeeeeeeeee7eeee444eeeeeee74eeeee77eeeeee00000000000
000a000000aaa00000070088800000000888030000ee803000000000000000000000007eeeeeeeeeeeeee777eeeeeee44eeee4feeeee777eeeeeee0000000000
00a7a0000aa7aa0000070888880000000ee803000088800300000000000000000000007eeeeeeee4eeeeeee77eeeeee444fee44eeeeeeeeeeeeeeee000000000
0a777a00aa777aa000078887888000000ee80300000000300000000000000000000007eeeeeeeeee4eeeeeeeee4eeeee44e44feeeeeeeeeeee4eeee000000000
00a7a0000aa7aa00000888777888000000000300000000300000000000000000000007eeeeeeeeee44eeeeeeeee4eeeee4444feeeeeeeeeee4eee7eee0000000
000a000000aaa000008887777788800000000300000003000000000000000000000007eeeeeeeeeee4eeeeeeeeee44eee444ffeeeeeeeeee4eeee77eee000000
00000000000a00000888777777788800000033300000333000000000000000000000077eeeeeeeeee44eeeeeeeeeee4fe444ffee44444444ee777777eee00000
00000000000000008887777777778800000333330003333300000000000000000000007eeeee7e7eeee444eeeeeeee44f444fee4fff4eeeeee777777eee00000
00000000000000008877777777777880000000000000000000000000000000000000eeeeeeeee77eeeeee444eeeeeee44444444ffeeeeeeee77777777ee00000
00000000000000000077e877777770000008800000000000000000000000000000077eeeeeeeeeeeeeeeee4444eeeee4444444feeeeeeeeeee7777eeeee00000
000000000000000000778877777770000088780000088000000000000000000000077eeeee7eeeeeeeeee44ee44feeee44444ffeeeeeeee7eee77eeeee000000
00a0e000000e0a000077777755577000087888800088780000000000000000000000777eeeeeeeeeeeeee4eeee44feee44444feeeeeeeeee7777eeeeee000000
00070000000070000077777755577000888887880878888000000000000000000000777777eeeeeee7fe4e7eee444ffe444444eeeeeeeeeee777eeeee0000000
00e3a000000a3e00007777775557700000077000888887880000000000000000000007777777e7eeff444777eee444ff4444444ffffeeeeeee7eeeeee0000000
00030000000030000777777755d7770000077000007776000000000000000000000000777777ee7744777777eeee444444444444444ff77feeeeeeee00000000
00030000000300007777777755577770000770000007600000000000000000000000000ee77777777777777eeeeee444444447777777eeeeeeeeeee700000000
0000b0000000b0000000b0000000b00004444400044444000000000000000000000000000777777777777eeeeeeee04444444777777eee0eeeeeee7700000000
0000b0000000b000000bb000000bb000445554404455544000000aaaaa000000000000000000000000000eeee00000044444400000eee0000eeeee7000000000
000bbbb000bbbb000000b00000000b0044494440444944400000aaaaaaaa00000000000000000000000000000000000444444000000000000000e70000000000
0000b000000b00000000e00000000e00044444000444440000aaaaaaaaaaa0000000000000000000000000000000000444444000000000000000000000000000
00ebb0000ebb0000000000000000000000040000000400000aaaaaaaaaaaaaa00000000000000000000000000000000444444000000000000000000000000000
0000be000000be00000000000000000000040000000400000aaaaaaaaaaaaaa00000000000000000000000000000000f44444000000000000000000000000000
0000b0000000b0000000000000000000eee4000000040000aaaaaaaaaaaaaaaa0000000000000000000000000000000f44444000000000000000000000000000
000bb0e0000bb0e00000000000000000bbb4bbbb00040000aaaaaaaaaaaaaaaa0000000000000000000000000000004444444000000000000000000000000000
cccccccc000000000000000000000000d000000d00000000aaaaaaaaaaaaaaaa0000000000000000000000000000044444444000000000000000000000000000
cccccccc0000000000000000000000004d0505d4d0050500aaaaaaaaaaaaaaaa0000000000000000000000000000444444444000000000000000000000000000
cccccccc00000000000000000000000044d505444d05050daaaaaaaaaaaaaaa0000000000000000000000000000ff44444444400000000000000000000000000
cccccccc000000000000000000000000444656444dd656d40aaaaaaaaaaaaaa0000000000000000000000000444444f444444400000000000000000000000000
cccccccc00000000000000000000000044d5554044d5554400aaaaaaaaaaaaa00000000000000000000000ffff3fffbbb44bbf333bbbbbbbe000000000000000
cccccccc00000000000000000000000004dddd4044dddd4000aaaaaaaaaaaa0000000000000bb0000000bbbbbb3bbbbb44bbbbff33bbbbbbb000000000000000
cccccccc0000000000000000000000000055550004555540000aaaaaaaaaa000000bbbbbebbbbbbbbbbbbeeb33bbbbbbbbbbbbbbbbbbbbbbbbbb000000000000
cccccccc00000000000000000000000000d0d000000d0d0000000aaaaaa0000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbb3bbbbbbbbbeeeee0000000
000f0000000eef00000ef0000000000000000000000000000000000000000f0000000f0000000000000000000000000000000000000000000000060000000600
0ef00f000fef000000efeef00000000000ffff000ffff000000000000000fee00000fee00fff0f00000000000000000000000000000002000006626000066060
ef000ee0fef00f000ef0000f00fff0000feeeef0f00eeef0f0000000000fe77e00fee77efeeefee00ff000000000000000000000000e8220006e822600600006
fe00fe7eef00fee0f0000f000feeef00f000000f000000ee0efff0000feee0000fee7e00e770e77efeef0f000000000000000000008828800688288606000006
e0ffe700f0ffe77e0ff0fee0f0000ef0000000000000000000eeeef00fe70ee00fe700e00eee0e00e77efee000000000000000000e8282006e82826060000060
f0ee7ee00fee0e00feefe77e0000000f00000000000000000000000ffe770000fee00000000000e0e707e77e00000000006600000228eb306228eb3660000006
0fe700000e7700e0e7700e00000000000000000000000000000000000ee0000000eee000000000000ee00e00000006600679600000080b3006686b3606606006
00eee00000eee0000eee00ee0000000000000000000000000000000000ee00000000000000000000000000ee000067966a9996000000b3000006066000060660
000f0f00f0000f000000000000000000000000000000000000000000000000000000000000000000000000000006a99969442600000000000007800007f07f00
0fe00ee00e000ee000fff0000f000000f0000000000000000000000000000000000000000000000000000000000644426944260000078000000e8000feefee20
fe00f77e0fe0f77e0feeeef000f000000e0000000000000000fff00000000000000000000000000000000000006644a967927960000e800000e88e008eeeee20
fe00fe000fe0fe000e00000f00eff0000ef00000000fff000feeef0000000f000ff0000000000f0000000f0006799799949a999600e88e007888888208eee200
fe0fe7ee0fefe7e0f0000000000eef0000eff00000feeef00e000ef00fffeee0feef0f000fff0ee00ff0fee06a449a4424494426788888820e888820008e2000
0e0fe7000fefe70e0ff00f0000000eef000eeeeffee0000ff00000effeeee77ee77efee0feeef77efeefe77e64449944244944260e88882000e8820000020000
00e0fee000e0fe00feeffeef00000000000000000000000000000000e770fe00ee07e77eee77e000ee77e000062246226296426000e88200000e200000000000
000f000e000f00eeff77efff00000000000000000000000000000000eef0f0ee0f000ef0f0ee0ee00eef0ef00066606606606600000e20000000000000000000
000000000000000000bbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000ffffff000000bb3bbbbbbb3bbb000000000000000000000000000000000000000000000000000000000000000000000000006000000007d7000007d7000
0400ffffff4f0000bb3f3b3b3b3f3b3b0000000000000000000000000000000000000000000000000000000000000600000000006f00000007d7d70007d7d700
0040444445440000b3ff3b33f3ff3b3b0000000000000000000000000000000000000000000000000000000000000ff0060000606f00000007ddd70007dd7700
0004444544445000bffff3fffffff3fb000000000000000000000000000000000000000000000000000000000600f7006f0006ff6000006007d7d70007d7d700
b04544454454450b3ffffffffffffff3000000000000000000000000000000000000000000000000000000006f067f006f06670060660fff06777600067d7600
05444545444545b03bfffffffbfffff3000000000000000000000000000000000000000000000000000000006f06700006f70f000677f7000066600000666000
44454b44543544533fffffbfffffffb30000000000000000000000000000000000000000000000000000000006f0ff0000f000f00ff000f00000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f00000eff00000f0000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ef00f00ef000f000e00f0000077700000777000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ef000ee0f000fee0ef00ee0007d7d70007d7d700
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fe00fe7ee00fe77ef00fe7e0077d7700077d7700
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0ffe700e0fe70e0e0fe709707d7d700077d7700
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f0ee7ee0fef7ee00f0e7eee90677760006777600
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fe700000fe700000fe700490066600000666000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eee00000eee00000eee0000000000000000000
07f07f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
feefee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8eeeee20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08eee200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000
008e2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777700000
00020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777770000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777777000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077700000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777770000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000770007777770000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777707777777000077700000
00000000000000000000033300000000033300000000000000000000000000000000000000000000000000000000000000007777777777777777707777770000
00003333333333333333300033333000300033333333333333300000000000000000000000000000000000000000000000007777777777777777777777770000
00030000000000000000007000000303007000000000000000030000000000000000000000000000000000000000000000077777777777777777777777770000
00300777077707770777076707770030076707770707770777003000000000000000000000000000000000000000000000777777777777777777777777777000
03007666766676667666769676667000764676667676667666700300000000000000000000000000000000000000000077777777777777777777777777777770
03076699699966966699699a69966707646669696969996999670300000000000000000000000000000000000000000000000000000000000000000000000000
03076966699669696966644469696777694669996969666696670300000000000000000000000000000000000000000000000000000000000000000000000000
03076669696669996669644469696666699469696969966696670300000000000000000000000000000000000000000000000000000000000000000000000000
03076996699969696996664669696999669469696969666696670300000000000000000000000000000000000000000000000000000000000000000000000000
03007666766676667666766676667666764676667676667666700300000000000000000000000000000000000000000000000000000000000000000000000000
00300777077707770777077707770777076707770707770777003000000000000000000000000000000000000000000000000000000000000000000000000000
00030000000000000000000000000000007000000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000
00003333333333333333333333333333300033333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001070200000000000000000000000000010000070707070000000000000000000100000000808000000000000000000000000101008040000000000000000080800000804000400000000000000000804000000300004000000000000000000000000006060000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4647464760466046464646464660101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101070707070707070707070707070707070
5657565760466046464646464660101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101070707070707070707070707070707070
4647464760466046464646464660101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101000001010101010101010101010101010101010101010101010101010101010101010101010101070707070707070707070707070707070
5657565762466046466667464660101010101010101010601060101010101010101010101010101010101010101010101010101010601010101010101010101010100010100000101010101010101010101010101010101010101010101010101010101010101010101010101010101070707070707070707070707070707070
464746464646634646767746466210101010101010101010106010101010101010101010101010101010101010101010101010101060101010101010101010101010080000000000000f101010101010101010101010101010101010101010101010101010101010101010101010101070707070707070707070707070707070
56571a1b1c1d1e46464646464610101010101010101010101010101010101010101010101010101010101010101010101010101010101010103410101010101010101810101010101010101010101010343434343434101010101010101010101010101010101010101010101010101070707070707070707070707070707070
28292a2b2c2d2e2f464646464610101010101010101010101010101010101010101010101010101010101010101033333410103434101010101010101010101010101010101010101010101010101010101010101034101010101010101010101010101010101010101010101010101070707070707070707070707070707070
38393a3b3c3d3e3f464646464647101010101010101010101010101010101010101010101010101010103434101033333410101010101010101010101010101010101010101010101010101010101010101010101010101010101010103410101010101010101010101010101010101070707070707070707070707070707070
48494a4b4c4d4e4f464647474757441010101010101010101010101010101010101010101010101010101010101033341010101010101010101010101010101010101010101010101010101010101010101010101010101010101010103410101010101010101010101010101010101070707070707070707070707070707070
58595a5b5c5d5e5f465657575734343410101010101010101010101010101010343410101010101034341010101034341010343434101010101010101010101010101010101010101010101010101010101010101010103434020202103410101010101010101010101010101010101070707070707070707070707070707070
46476a6b6c6d6e42434646333333464610101068101010101010101010101010103434341010101010101010101010101034343410101010101010101064101010101010101010101010101010101010101010101010100202021010103410101010101010101010101010101010101070707070707070707070707070707070
56577a7b7c7d6452535446464646464610101010101010101010101010101010101010341010101010101034343434343434341010341010101010103434341010101010101010101010101010101010101010101010100210101010343434341010101010101010101010101010101070707070707070707070707070707070
0101010101010101010101040506060601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101101010101010101010101010101010010101010101010101010101010101010101010101010101010101010170707070707070707070707070707070
2121212121212121212121161616161621212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121101010101010101010101010101010212121212121212121212121212121212121212121212121212121212170707070707070707070707070707070
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121101010101010101010101010101010212121212121212121212121212121212121212121212121212121212170707070707070707070707070707070
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121101010101010101010101010101010212121212121212121212121212121212121212121212121212121212170707070707070707070707070707070
46461010101010101010101010101010101010104646464646464646464646464610101010101010101010101010101010101010101010101010101010101010101010461046464646464610010101010210101010101010101010101010101010101010101010101010101010101010000000cccdcecf000000000000000000
46461010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010104646464646464646212121211010101010101010101010101010101010101010101010101010101010101010000071dcdddedf000000720000000000
46461010101010101010101010101010101010101010101010101010101010101010101010104646464610464610101010101010101010101010101010101010101010101046464646464646212121211010101010101010101010101010101010101010101010101066671010101010000000ecedeeef000000000000000000
46461010101010101010101010101010101010101010101010101010101010101010101010104646464646101010103434101010101010104646101010101034101010104646460101464646342121211010101010101010101010101010101010101010101010101076771010101010000000000000000000caca00cccdcecf
461008090a0b0c0d0e0f101010101010101010101010101010101010101008101010101010104646464646101010103434101010101010084646101010101034101046464634342134464646342121211010103434341010343434101010101010101010101010101000000010101010cccdcccc0000000000caca00dcdddedf
464618191a1b1c1d1e1f101010104610464610101010101010101010101008080808080810104646464646464646463434341010101010464646464646103401101046463434012134020246342121211010464646344646464646464646463410101010101010101000001010101010cccccccc0000710000000000ecedeeef
464628292a2b2c2d2e2f101010104646464646100808080846020202100808080808080846464610100246101010343401344646464610464646464646463421103402024646464646464646342121211010101010101010101010104634463410101010101010101010101010101010cccccccc000000000000000000000000
461038393a3b3c3d3e3f08080808084608083434344646463434343434080808080808083434464646343434461034012134344646461046464610464634012134341034344646464646463434212121101046464646464634464646464646341010101010101010101010101010101000000000000000000000000000000000
461048494a4b4c4d4e4f10100808084608080808081010101008100808080808080808343410101010340246463434212101344646461046464610464634212101010101014646464646340101212121104610101046464634464610104646341010101010101010101010101010101000000000000000000000000000000000
461058595a5b5c5d5e5f101008080846080810103434341046464646080808080808343446464646100246464634012121210134464646020246464634012121212121212102023402020121212121214646463446464646344646101010101010101010101010101010101010101010000000000000000000000000cccdcecf
080868696a6b6c6d6e42431010100846080810100808084602020246020210084634341010103434341046103434212121212134464634343434464634212121212121212121212121212121212121214646463446464646344646101010343310101010101010101010101010101010000000000000000000000000dcdddedf
085145797a7b7c7d64525350100808540808a2a30808a0a134343434343446a2a334464646464646464646343401212121212134344646464646463401212121212121212121212121212121212121213446463446463446344646464646333310101010101010101010101010101010000000000000000000000000ecedeeef
1111111111111111111111110404051111111111111111111111111111111111111111111111111111111101012121212121210134464646464646342121212121212121212121212121212121212121010101010101010101013434340101011010101010101010101010101010101000000000000000000000000000000000
2121212121212121212121211414152121212121212121212121212121212121212121212121212121212121212121212121212101344646464634012121212121212121212121212121212121212121212121212121212121210101012121211010101010101010101010101010101000000000000000000000000000000000
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121013446463401212121212121212121212121212121212121212121212121212121212121212121212121211010101010101010101010101010101000000000000000000000000000000000
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121213434343421212121212121212121212121212121212121212121212121212121212121212121212121211010101010101010101010101010101000000000000000000000000000000000
