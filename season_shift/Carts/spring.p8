pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
	-->main-0
--------------ÊüÖæÔ∏èßÂ‚òâ∂Â‚ñ•®----------------
map_location ={
    x = 0,
    y = 0,
}
controller = {
  jump = function ()
    if player.state == "climb" then
      player.climb_jump()
    else
      player.vecter.y = cfg_jump_speed * -1
      direction_flag.y = "up"
      player.can_jump =  player.can_jump - 1
      if player.state ~= "jump" then
        player.state = "jump"
        change_animation(player, "jump")
        change_animation(tail, "jump")
      end
    end
  end,

  up = function()
    if player.state == "climb" then
       player.pos_y -= cfg_climb_speed
      local map_x = player.pos_x + (player.flip_x and -1 or (player.width*8))
      local map_y = player.pos_y + player.height*8 - 1
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
    elseif player.state == "climb" and player.flip_x then
     player.pos_y -= cfg_climb_speed
     local map_x = player.pos_x + (player.flip_x and -1 or (player.width*8))
     local map_y = player.pos_y + player.height*8 - 1
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
    end
  end,
}

function _init()
  game_season = "autum"
  autumn_config = init_config(cfg_levels_autumn)
  winter_config = init_config(cfg_levels_winter)
  -- spring_config = init_config(cfg_levels_spring)
  -- summer_config = init_config(cfg_levels_summer)
  game_level = 1
  camera_location = {
    x = 0,
    y = 0,
  }
  direction_flag = {
    x,
    y,
  } --Ê‚àßπÂ‚Ä¶‚û°Ô∏èÊ†‚ô•Á≠æ
  cloud = init_cloud()
  game_state_flag = "play"--Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊ†‚ô•Á≠æ
  gravity = cfg_gravity-- È‚ô•‚ô™Â‚åÇõ
  update_state_flag = "play"
  draw_state_flage = "play"
  player_state_x_flag = "nomal"
  player_acceleration_fast = cfg_player_acceleration_fast--Â‚åÇ†È‚ñàüÂ∫¶
  player_acceleration_low = cfg_player_acceleration_low
  player_max_v = cfg_player_max_v

  thief = init_thief()
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
    end
  end, "all")

  tail = init_tail()
  cfg_levels = autumn_config
  change_camera = init_change_camera()
  tips = init_tips()

  -- snow = init_snow()
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
      end
    end
  end, 'chest_store')
  change_level(game_level)
  bin_kuai = init_spr("bin_kuai", 159, 240, 88, 1, 1, true)
  -- bin_kuai_2 = init_spr("bin_kuai", 159, 23*8, 88, 1, 1, true)
  -- box_1 = init_box(176, 72, bin_kuai_2)
  -- box_2 = init_box(224, 32, bin_kuai)
  ices = init_ices(ices_cfg)
  boxs_table = init_boxs(boxs_cfg)
end

------------Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-----------------
game_states = {
----------updateÁ‚åÇ∂Ê‚ñà‚ñíÊú∫--------------
update_states = {
  change_level_update = function()
    if change_camera.update() then
      game_state_flag = "play"
    end
  end,

  play_update = function()
        player.check_position()
        map_ani_1.update()
        map_ani_2.update()
        player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
        if (btnp (4) and player.can_jump <= player.max_jump and player.can_jump > 0) controller.jump()
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
              else
                  v.vecter.y = v.vecter.y + (v.is_physic and gravity or 0)
              end
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
        boxs_table.update()
        ices.update()
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
        -- snow.update()
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
        if chest.pinecone == 10 then
            game_level = 5
            change_level(5)
            chest.pinecone -= 5
            timer.add_timeout('thief_show', 1, function()
                thief.act = 'run1'
            end)
        end
        cloud.update()
        tips.update()
        shake.update()
    end,

    game_over_update = function()

    end,
  },
  ---------------------------------

  -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------

  draw_states = {
    change_level_draw = function()
      nomal_draw()
    end,

    play_draw = function()
        nomal_draw()
    end,
    game_over_draw = function()
      -- map(16, 0)

    end,
  },
  -------------------------------
}
-----------------------------------
function nomal_draw()
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
    -- snow.draw()
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
        spr_obj.destroy_cllision()
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

    local idx = #trigger_table + 1
    add(trigger_table, trigger_exit)
    sprit_1.destroy_trigger_exit = function()
      trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_exit = function()
      trigger_table[idx] = nil
    end

    return trigger_exit
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
    local idx = #cllision_table + 1
    sprit_1.destroy_cllision = function()
      cllision_table[idx] = nil
    end

    sprit_2.destroy_cllision = function()
      cllision_table[idx] = nil
    end
    add(cllision_table, tbl)
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
  local fix_driction = 0
  local function change(level)
    local camera_pos = string_to_array(cfg_levels["level" .. level].camera_pos)
    now_camera_pos_x = camera_pos[1]*8
    now_camera_pos_y = camera_pos[2]*8
    flip_x = old_camera_pos_x > now_camera_pos_x
    flip_y = old_camera_pos_y > now_camera_pos_y
    fix_driction_x = now_camera_pos_x - old_camera_pos_x
    fix_driction_y = now_camera_pos_y - old_camera_pos_y
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
    if fix_driction_y * (flip_x and -1 or 1) > 0 then
      old_camera_pos_y = old_camera_pos_y + cfg_camera_move_speed.y * (flip_y and -1 or 1)
      fix_driction_y = fix_driction_y + cfg_camera_move_speed.y * (flip_y and 1 or -1)
    else
      changed_y = true
    end
    camera_location.x = old_camera_pos_x
    camera_location.y = old_camera_pos_y
    if changed_x and changed_y then
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
  if player.hand_songzi >0 then
    player_pinecone = player_pinecone - player.hand_songzi
  end
  change_level(game_level)
end

function change_level(level)
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
  for i = 1 ,#this_songzi_cfg do
    -- printh("this-i = " .. i, "dir")
    this_songzi_cfg[i] = nil
  end
  local level_cfg = cfg_levels["level" .. level]
  if level_cfg.change_map then
    change_map(level_cfg.change_map)
  end
  enemies = init_enemies(level_cfg.enemy_bees, level_cfg.enemy_catepillers)
  if #level_cfg.songzi ~= 0 then
    for i = 1 ,#level_cfg.songzi do
      -- printh("level-i = " .. i, "dir")
      this_songzi_cfg[i] = level_cfg.songzi[i]
    end
    if #this_songzi_cfg ~= 0 then
      songzi = init_songzis(this_songzi_cfg)
    end
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
  -- shake.state = 'start'
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
                    s.y = 0
                    s.x = rnd(128)
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

function init_leaves(speed, num, hit_spr_flag)
  local function init_leaf(pos_x, v_x, v_y)
    local lf = init_spr("leaf", 159, pos_x, 0, 1, 1, false, v_x, v_y)
    local update_speed = 5+flr(rnd(15))
    init_animation(lf, 159, 159, update_speed, "leaf", true)
    return lf
  end

  if not speed then speed = 1 end
  if not hit_spr_flag then hit_spr_flag = 1 end
  if not num then num = flr(rnd(10)) + 10 end
  local leaves = {}
  for i = 1, num do
      local pos_x = flr(rnd(125))+2
      local v_y = rnd(2)+speed
      local v_x = 3 - rnd(6)
      local f = init_leaf(pos_x, v_x, v_y)
      f.n = i
      f.landed = false
      add(leaves, f)
  end

  local function out_of_scen(sp)

    if sp.pos_x >= camera_location.x+128 or sp.pos_x <= camera_location.x - 8 or sp.pos_y >= camera_location.y+128 then
      return true
    end
    return false
  end

  local function is_land(sp)
      -- printh("canland? ========= ", "dir")
      if out_of_scen(sp) then
        sp.landed = false
        sp.pos_y = 0
        sp.pos_x = flr(rnd(125))+2
        sp.vecter.x = rnd(3)+speed
        sp.vecter.y = 3 - rnd(6)
        return false
      end
      if get_map_flage(sp.pos_x, (sp.pos_y + sp.vecter.y*2)) == hit_spr_flag or get_map_flage((sp.pos_x + sp.vecter.x*2), sp.pos_y ) == hit_spr_flag then
          -- sp.pos_y = flr((sp.pos_y + sp.vecter.y) / 8) * 8 - 8
          return true
      end

  end

  local function update()
      for s in all(leaves) do
          if not s.landed then
              s.pos_x += s.vecter.x
              s.pos_y += s.vecter.y
          end
          if is_land(s) and not s.landed then
              -- s.y = 100
              s.landed = true
              timer.add_timeout('leaf_melt'..s.n, 1, function()
                  s.landed = false
                  s.pos_y = 0
                  s.pos_x = flr(rnd(125))+2
                  s.vecter.x = rnd(3)+speed
                  s.vecter.y = 3 - rnd(6)
              end)
          end
      end
  end

  return{
    update = update,
  }
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
  elseif season == "spring" then
    cfg_levels = spring_config
  elseif season == "summer" then
    cfg_levels = summer_config
  end

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

    add(map_trigger_tbl, trigger_exit)
    return trigger_exit
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
            spr(142, ui_x - 6 * i + camera_location.x, 2)
        else
            spr(143, ui_x - 6 * i + camera_location.x, 2)
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
    if game_level == 9 then
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

    player.pos_y = (player.vecter.y>0) and flr((player.pos_y + player.vecter.y)/8)*8 or flr((player.pos_y + player.vecter.y)/8)*8 + 8

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

  player.hit = function()
    hit(player, 1, "height", function()
        player_acceleration_fast = cfg_player_acceleration_fast
        player_acceleration_low = cfg_player_acceleration_low
        player_max_v = cfg_player_max_v
      player.on_ground_function()
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
        sspr(16, 32, 16, 16, 600, 80)
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
      mset(zhui_x/8, zhui_y/8, 16)
    end, "up")
    oncllision(box, player, {
      height = function()
        player.on_ground_function()
      end,
      width = function()
          if not box.can_move then
              player.vecter.x = 0
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
        if box.down_dis >= 16 then box.can_hit = true end
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
        local sp = is_songzi and 143 or 159
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
                    if ice.can_hit then
                        v.destroy()
                        ice.destroy()
                    end
                end,}
            )
        end
        return ice
    end

    for i = 1 , #ice_config do
        local pos_x, pos_y, is_songzi = ice_config[i][1], ice_config[i][2], ice_config[i][3]
        ice = init_ice(pos_x, pos_y, is_songzi)
        ice.idx = i
        add(ices.table, ice)
    end

    ices.update = function()
        for v in all(ices.table) do
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
    local box = init_spr("box", 3, pos_x, pos_y, 1, 1, true, 0, 0)

    init_comoon_box(box)

    for bin_kuai in all(ices) do
        oncllision(box, bin_kuai, {
            width = function()
              -- box.pos_x = bin_kuai.pos_x + (box.pos_x > bin_kuai.pos_x  and 8 or -8)
              box.can_move = false
              box.vecter.x = 0
            end,
          height = function()
            box.pos_y = bin_kuai.pos_y - 8
            box.vecter.y = 0
            box.down_dis = 0
            if box.can_hit then bin_kuai.destroy() end
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
    local b_x, b_y = box_config[i][1], box_config[i][2]
    local box = init_box(b_x, b_y, bin_kuai)
    box.idx = i
    add(boxs.table, box)
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
cfg_ice_acceleration_fast = 0.15--Â‚óè∞Èù¢Â‚åÇ†È‚ñàüÂ∫¶
cfg_ice_acceleration_low = 0.15--Â‚óè∞Èù¢Â‚ô•‚óÜÈ‚ñàüÂ∫¶
cfg_ice_max_v = 2.4 -- Â‚óè∞Èù¢Êú‚ñàÂ§ßÈ‚ñàüÂ∫¶

cfg_jump_speed = 	3 -- Ë∑≥ÔøΩ‚¨áÔ∏èÔøΩ‚ñàÔøΩÂ∫¶
cfg_climb_speed = 1.6 -- ÔøΩ‚òâÔøΩÔøΩ‚ñ•ÔøΩ‚ñàÔøΩÂ∫¶
cfg_gravity = 0.3 -- ÔøΩ‚ô•‚ô™ÔøΩ‚åÇÔøΩ(ÔøΩ‚Ä¶‚û°Ô∏èÔøΩ‚¨ÖÔ∏èÔøΩ‚ñëÔøΩ‚åÇÔøΩÔøΩ‚ñàÔøΩÂ∫¶)

cfg_mogu_jump = 4 -- ÔøΩ‚ô•‚ô•ÔøΩ‚ñ§‚û°Ô∏èÔøΩ‚óÜ‚ô•Ë∑≥ÔøΩ‚¨áÔ∏èÔøΩ‚ñàÔøΩÂ∫¶
cfg_camera_move_speed = { -- ÔøΩ‚òâ‚ô•ÔøΩ‚ô™ÔøΩÂú∞ÂõæÔøΩ‚ùéÔøΩÔøΩÀáÔøΩÂ§¥ÁßªÔøΩ‚åÇÔøΩÔøΩ‚ñàÔøΩÂ∫¶
  x = 5,
  y = 5,
}

cfg_box_gravity = 0.1 --ÁÆ±Â≠‚Ä¶Áö‚ñëÈ‚ô•‚ô™Â‚åÇõ
cfg_box_max_v = 1.5 --ÊüÖæÔ∏è®ÁÆ±Â≠‚Ä¶Êú‚ñàÂ§ßÈ‚ñàüÂ∫¶
boxs_cfg = { --ÁÆ±Â≠‚Ä¶È‚úΩ‚ô™ÁΩÆ
    -- {176, 72},
    {264,64},
    {424,88},
    {416,40},
   
}
ices_cfg = { --Â‚óè∞Âù‚ùéÈ‚úΩ‚ô™ÁΩÆ
    -- {48, 88},
    {360,80},
    {468,40},
    {416,64},

}

cfg_levels_autumn = {
  level1 = 'camera_pos0,0songzi1104,64player_start_pos0,7enemy_catepillersenemy_bees',
  level2 = 'camera_pos16,0player_start_pos0,7enemy_beesenemy_catepillerssongzi1208,48',
  level3 = 'player_start_pos0,7enemy_beescamera_pos32,0enemy_catepillerssongzi1288,642352,48',
  level4 = 'camera_pos48,0enemy_catepillers1432,72,24,0.5,1songzi1432,72player_start_pos0,7enemy_bees1432,64,24,0.5,0',
  level5 = 'enemy_beessongzienemy_catepillerschange_map123,11,2224,11,2342,7,16442,8,16542,9,16642,10,16763,9,16863,10,16963,11,16camera_pos0,0player_start_pos1,11',
  level6 = 'camera_pos16,0songziplayer_start_pos0,5enemy_catepillers1216,48,8,0.5enemy_bees',
  level7 = 'enemy_bees1280,64,16,0.5camera_pos32,0player_start_pos0,5enemy_catepillers1336,64,8,0.5,1,0,12320,56,8,0.5,0,1,1songzi',
  level8 = 'player_start_pos0,5camera_pos48,0songzienemy_bees1464,64,24,0.5enemy_catepillers1432,72,24,0.5,02432,72,24,0.5,1',
  level9 = 'enemy_catepillersplayer_start_pos0,5songzienemy_beescamera_pos64,0'
}

cfg_levels_winter = {
  level1 = 'camera_pos0,0songzi1104,64player_start_pos0,7enemy_catepillersenemy_bees',
  level2 = 'camera_pos16,0player_start_pos0,7enemy_beesenemy_catepillerssongzi1208,48',
  level3 = 'player_start_pos0,7enemy_beescamera_pos32,0enemy_catepillerssongzi1288,642352,48',
  level4 = 'camera_pos48,0enemy_catepillers1432,72,24,0.5,1songzi1432,72player_start_pos0,7enemy_bees1432,64,24,0.5,0',
  level5 = 'enemy_beessongzienemy_catepillerschange_map123,11,2224,11,2342,7,16442,8,16542,9,16642,10,16763,9,16863,10,16963,11,16camera_pos0,0player_start_pos1,11',
  level6 = 'camera_pos16,0songziplayer_start_pos0,5enemy_catepillers1216,48,8,0.5enemy_bees',
  level7 = 'enemy_bees1280,64,16,0.5camera_pos32,0player_start_pos0,5enemy_catepillers1336,64,8,0.5,1,0,12320,56,8,0.5,0,1,1songzi',
  level8 = 'player_start_pos0,5camera_pos48,0songzienemy_bees1464,64,24,0.5enemy_catepillers1432,72,24,0.5,02432,72,24,0.5,1',
  level9 = 'enemy_catepillersplayer_start_pos0,5songzienemy_beescamera_pos64,0'
}

__gfx__
00000000bbbbbbbb080021006666666677777777777777777777777777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff100002106dddddd677777777777777777777777777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffbfff210811106d6dd6d6c777c777c777c77777c777c777c777c7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff021222216ddd6dd6cc7ccc7ccc7ccc7c7ccc7ccc7ccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000fbffffff001200806dd6ddd6cccc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff001200006d6dd6d6cccccccccccccc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000fffffbff010101206dddddd6ccccccccc7ccccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000ffffffff2002100166666666ccccccc7ccccccccccccc7cccccccccccccccccccccccccccceccccc77777ccccccccccccccccccccccccccccccccccc
ccccccccbbbbbbbbcccccccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccceecccc77777c7cccccccccccccccccccccccccccccccccc
ccccccccbbb3bbbbcccccccc77777777cc7ccccccccccccc7ccccccccccccccccccccccccccccccccccccc777ee7777ccccc7ccccccccccc88cccccccccccccc
cccccccc3b3f3b3bcccccccc77777777ccccccccccccccccccccccccccccccc7cccccccccccccccccccc77777ee77ee77cc7eeecccccccc8878ccccccccccccc
ccccccccf3ff3b33cccccccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccccc77777eeee7eeee77eeeeeeeccc88888cccccccccccccc
ccccccccfffff3ffccc8cccc77777777cccccccccccccccccccccccccccccccccccccccccccccccccc777777eeeeeeeeeeeeeeeeeecccc8888bccccccccccccc
ccccccccffffffffcc878ccc77777777ccccc7ccccccccccccc7cccccccccccccccccccccccccccccccc77eeeeeeeeeeee777eee777cccbbbbcccccccccccccc
ccccccccfbffffffc88888cc77777777cccccccccccccccccccccccccccccccccccccccccccccccccccc77eeeeeeeeeeeee7eeeee7777777bbcccccccccccccc
ccccccccffffffbfcc777ccc77777777ccccccccccccccccccccccccccccccccccccccccccccccccc7777eeeeeeeeeeeeeeeeeeeeeee777777cccccccccccccc
77777777ffffffffcccccccccccccccc88cccccc88ccccccccccccccccccccccccccccceccccccc777eeeeeeee7eeeeeeeeeeeeeeeeeee7777cccccccccccccc
77777777ffffffffccccccccccccccccddccccccddcccccccccccccccccccccccccccceeeccccce777eeeee777eeeeeeeeeeeeeeee7eeeee77cccccccccccccc
77777777fffffbffcccccccccccccccc88ccccccc88cccccccccccccccccccccccccccccccccceeeeeeeeeee77eeeeeeeeeeeeeeee7eeeeee77ccccccceccccc
77777777ffffffffccccccccccccccccddccccccccddccccccccccccccccccccccccccccccccceeeeeeeeeeee7eeeeeeeeeeeeee7777eeeeee7cccccceeccccc
77777777ffffffffccccccccccccdccc88ccccccc88cccccccbccccccccbccccccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeee7777eeeeee77ccccccccccc
77777777fbffffffccccccccccc8d8cc88cccccc88cccccccccbbbcccccbcccccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7ccccccccccc
77777777ffffffffc8882828c888c8d888cccccc88cccccccccbcbcccccbbcccccccccccc7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeeeeeeeeeccccccccc
66666666ffffffffc8882828c88cccd8cccccccccccccccccccbcccccccbcbcccccccccc7eeeeeeee7eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eecccccccc
cccccccccccccccccccccccc97777777bbbbbbbbcccccccc0000000000080000cccccccc7eeeeeeeee77eeeeeeeeeeee7eeee7eeeeeeeeeeeeee77eecccccccc
76ccc67c666ccc6676ccc67cd9999997b2bbb2bbcccccccc0800000000000008cccccccc7eeeeeeeeee77eeeeeeeeeeee7e77eeeeeeeeeeeeeeeeeeeeccccccc
776c677c7776c677776c677cd99999972d2b2d26cccccccc00a0800000008000cccccccc7eeeeeeeeee77eeeeeeeeeeeee777eeeeeeeeeeeeee7eeeee7cccccc
c76c67ccc7779c4cc76c67ccd99999972dddddd6cccccccc0000880000088800cccccccceeeeeeeeee7eeeeee4eeeeeeeee7eeeeee4eeeeee7777ee7e7cccccc
cc79c4ccccc55ccccc79c4ccd99999972dddddd67ccccccc0808988000888880ccccccccceeeeeeee7eeeeeeeeeeeeeeeeeeeeeee4eeeeee77777eee7ccccccc
cc55ccccccc99ccccc55ccccd99999972dddddd6bc7bbbcc0889a98008899988ccccccccceeeeeeeeeeeeeeeee4eeeeeeeeeeeee4eeeeeeeeeee7eeecccccccc
cc99cccccccc5cccccc99cccd99999972dddddd67bbbbb3c889aaa98889aa998cccccccccceeeeeeeeeeeeeee444eeeeeeeeeeee4eeeeeeeeeeeeeeecccccccc
ccc57cccccccc7ccccccc57cd99999972dddddd6b3bb337789aaaaa8899aaa98ccccccc7eeeeeeeeeeeeeeeeeee44eeeeeeeeeef44eee7eeeeeeeeeccccccccc
00000000000a0000007700ddd0000000ccc33cccccee33ccccccccccccccccccccccccc7eeeeeeeeeeeeeee7eeee444eeeeeee74eeeee77eeeeeeccccccccccc
000a000000aaa00000770ddddd000000c888c3ccccee8c3ccccccccccccccccccccccc7eeeeeeeeeeeeee777eeeeeee44eeee4feeeee777eeeeeeecccccccccc
00a7a0000aa7aa000007ddddddd00000cee8c3cccc888cc3cccccccccccccccccccccc7eeeeeeee4eeeeeee77eeeeee444fee44eeeeeeeeeeeeeeeeccccccccc
0a777a00aa777aa0000dddd7ddd00000cee8c3cccccccc3cccccccccccccccccccccc7eeeeeeeeee4eeeeeeeee4eeeee44e44feeeeeeeeeeee4eeeeccccccccc
00a7a0000aa7aa00000ddd777ddd0000ccccc3cccccccc3cccccccccccccccccccccc7eeeeeeeeee44eeeeeeeee4eeeee4444feeeeeeeeeee4eee7eeeccccccc
000a000000aaa00000ddd77777ddd000ccccc3ccccccc3ccccccccccccccccccccccc7eeeeeeeeeee4eeeeeeeeee44eee444ffeeeeeeeeee4eeee77eeecccccc
00000000000a00000ddd7777777ddd00cccc333ccccc333cccccccccccccccccccccc77eeeeeeeeee44eeeeeeeeeee4fe444ffee44444444ee777777eeeccccc
0000000000000000ddd777777777ddd0ccc33333ccc33333cccccccccccccccccccccc7eeeee7e7eeee444eeeeeeee44f444fee4fff4eeeeee777777eeeccccc
ccccccccccccccccdd77777777777dd0cccccccccccccccccccccccccccccccccccceeeeeeeee77eeeeee444eeeeeee44444444ffeeeeeeee77777777eeccccc
cccccccccccccccc0077e87777777000ccc88cccccccccccccccccccccccccccccc77eeeeeeeeeeeeeeeee4444eeeee4444444feeeeeeeeeee7777eeeeeccccc
cccccccccccccccc0077887777777000cc8878ccccc88cccccccccccccccccccccc77eeeee7eeeeeeeeee44ee44feeee44444ffeeeeeeee7eee77eeeeecccccc
ccaceccccccecacc0077777755577000c878888ccc8878cccccccccccccccccccccc777eeeeeeeeeeeeee4eeee44feee44444feeeeeeeeee7777eeeeeecccccc
ccc7cccccccc7ccc007777775557700088888788c878888ccccccccccccccccccccc777777eeeeeee7fe4e7eee444ffe444444eeeeeeeeeee777eeeeeccccccc
cce3acccccca3ecc0077777755577000ccc77ccc88888788ccccccccccccccccccccc7777777e7eeff444777eee444ff4444444ffffeeeeeee7eeeeeeccccccc
ccc3cccccccc3ccc0777777755d77700ccc77ccccc7776cccccccccccccccccccccccc777777ee7744777777eeee444444444444444ff77feeeeeeeecccccccc
ccc3ccccccc3cccc0777777755577700ccc77cccccc76ccccccccccccccccccccccccccee77777777777777eeeeee444444447777777eeeeeeeeeee7cccccccc
ccccbcccccccbcccccccbcccccccbcccc44444ccc44444ccccccccccccccccccccccccccc777777777777eeeeeeeec4444444777777eeeceeeeeee77cccccccc
ccccbcccccccbccccccbbccccccbbccc4455544c4455544ccccccaaaaaccccccccccccccccccccccccccceeeecccccc444444ccccceeecccceeeee7ccccccccc
cccbbbbcccbbbbccccccbccccccccbcc4449444c4449444cccccaaaaaaaaccccccccccccccccccccccccccccccccccc444444ccccccccccccccce7cccccccccc
ccccbccccccbccccccccecccccccceccc44444ccc44444ccccaaaaaaaaaaacccccccccccccccccccccccccccccccccc444444ccccccccccccccccccccccccccc
ccebbccccebbccccccccccccccccccccccc4ccccccc4cccccaaaaaaaaaaaaaacccccccccccccccccccccccccccccccc444444ccccccccccccccccccccccccccc
ccccbeccccccbeccccccccccccccccccccc4ccccccc4cccccaaaaaaaaaaaaaaccccccccccccccccccccccccccccccccf44444ccccccccccccccccccccccccccc
ccccbcccccccbccccccccccccccccccceee4ccccccc4ccccaaaaaaaaaaaaaaaacccccccccccccccccccccccccccccccf44444ccccccccccccccccccccccccccc
cccbbceccccbbcecccccccccccccccccbbb4bbbbccc4ccccaaaaaaaaaaaaaaaacccccccccccccccccccccccccccccc4444444ccccccccccccccccccccccccccc
00000000000000000000000000000000d000000d00000000aaaaaaaaaaaaaaaaccccccccccccccccccccccccccccc44444444ccccccc66cccccccccccccccccc
000000000000000000000000000000004d0505d4d0050500aaaaaaaaaaaaaaaacccccccccccccccccccccccccccc444444444ccccccccccccccccccccccccccc
0000000000000000000000000000000044d505444d05050daaaaaaaaaaaaaaaccccccccccccccccccccccccccccff444444444cccccccccccccccccccccccccc
00000000000000000000000000000000444656444dd656d4caaaaaaaaaaaaaaccccccccccccccccccccccccc444444f4444444cccccccccccccccccccccccccc
0000000000000000000000000000000044d5554044d55544ccaaaaaaaaaaaaacccccccccccccccccccccccffff3fffbbb44bbf333bbbbbbbeccccccccccccccc
0000000000000000000000000000000004dddd4044dddd40ccaaaaaaaaaaaacccccccccccccbbcccccccbbbbbb3bbbbb44bbbbff33bbbbbbbccccccccccccccc
000000000000000000000000000000000055550004555540cccaaaaaaaaaaccccccbbbbbebbbbbbbbbbbbeeb33bbbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccc
0000000000000000000000000000000000d0d000000d0d00cccccaaaaaacccccccbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbbbbbbbbbb3bbbbbbbbbeeeeeccccccc
cccccccccccccccccccccccccccccccccc77cccccccccccc00000000000004000000040000000000000000000000000000000000000000000000000000000000
ccccccccccccccccccccccccccccccccccc7cc888ccccccc00000000000049900000499004440400000000000000000000000000000000000006600000066000
ccccccccccccccccccccccccccccccccccc7c88888cccccc40000000000497790049977949994990044000000000000000000000000000000063b60000600600
ccccccccccccccccccccccc7ccccccccccc78887888ccccc094440000499900004997900977097794994040000000000000000000003b00006333b6006000060
ccccccccccccccccccccccc7777cccccccc888777888cccc0099994004970990049700900999090097794990000000000000000000333b000611136006000060
cccccccccccccccccccccc777777cccccc88877777888ccc00000004497700004990000000000090970797790000000000660000001113000611136006000060
ccccccccccccccccccccc77777777cccc8887777777888cc00000000099000000099900000000000099009000000066006796000001113000061160000600600
cccccccccccccccccccccccccccccccc88877777777788cc0000000000990000000000000000000000000099000067966a999600000110000006600000066000
cccccccccccccccccccccccccccccccc887777777777788c00000000000000000000000000000000000000000006a99969442600000000000007800007f07f00
cccccccccccccccccccccccccccccccccc77e87777777ccc0000000000000000000000000000000000000000000644426944260000078000000e8000feefee20
cccccccccccccccccccccccccccccccccc77887777777ccc0044400000000000000000000000000000000000006644a967927960000e800000e88e008eeeee20
cccccccccccccccccccccccccccccccccc77777755577ccc049994000000040004400000000004000000040006799799949a999600e88e007888888208eee200
cccccccccccccccccccccccccccccccccc77777755577ccc09000940044499904994040004440990044049906a449a4424494426788888820e888820008e2000
ccccccccccccccc777cccccccccccccccc77777755577ccc400000944999977997794990499947794994977964449944244944260e88882000e8820000020000
cccccccccccccc77777cccccccccccccc777777755d777cc0000000097704900990797799977900099779000062246226296426000e88200000e200000000000
cccccccc77ccc777777ccccccccccccc777777775557777c00000000994040990400094040990990099409400066606606606600000e20000000000000000000
cccccc777777c7777777cccc777ccccc00000000000000000000000000000d0000000d0000000000000000000000000000000000000000000000000000000000
cccc77777777777777777c777777cccc00d1d1000d1d1000000000000000d1100000d1100dd00d0000000000000000000000000006000000007d7000007d7000
cccc777777777777777777777777cccc010000d0d0000d10d0000000000d166100d11661d111d1100dd0000000000600000000006f00000007d7d70007d7d700
ccc7777777777777777777777777ccccd000000d0000000d01d1d000001110000011610016601661d11d0d0000000ff0060000606f00000007ddd70007dd7700
cc777777777777777777777777777ccc0000000000000000000001d00d1601100d160010011101001661d1100600f7006f0006ff6000006007d7d70007d7d700
7777777777777777777777777777777c00000000000000000000000dd16600d0d11000d00000001d160616616f067f006f06670060660fff06777600067d7600
cccccccccccccccccccccccccccccccc000000000000000000000000011000000011100000000000011001006f06700006f70f000677f7000066600000666000
cccccccccccccccccccccccccccccccc0000000000000000000000000011000000000000000000000000001d06f0ff0000f000f00ff000f00000000000000000
cccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000000000000000000000f00000eff00000f0000000000000000000000
ccccccccccccccccccccccccccccccccd00000000000000000000000000000000000000000000000000000000ef00f00ef000f000e00f0000077700000777000
cccccccccccccccccccccccccccccccc0d000000000000000011d00000000000000000000000000000000000ef000ee0f000fee0ef00ee0007d7d70007d7d700
cccccccccccccccccccccccccccccccc0100000000011d000d00010000000d000dd0000000000d0000000d00fe00fe7ee00fe77ef00fe7e0077d7700077d7700
cccccccccccccccccccccccccccccccc001d000000d00010010000d00ddd0110d11d0d000dd001100dd0d110e0ffe700e0fe70e0e0fe709707d7d700077d7700
cccccccccccccccccccccccccccccccc0000d11dd100000dd000000dd11116611661d110d11dd661d11d1661f0ee7ee0fef7ee00f0e7eee90677760006777600
cccccccccccccccccccccccccccccccc000000000000000000000000166011001106166111661000116610000fe700000fe700000fe700490066600000666000
cccccccccccccccccccccccccccccccc00000000000000000000000001d0d01d0d0001d0d01101d0011d01d000eee00000eee00000eee0000000000000000000
00776d00001212000021210000d67700007667000000000000000000000000000000000000004000000400000004000000040000000400000000700000000e00
07d6d6d00d51d120021d15d00d6d6d700767b6700703b0000000000000066000000660000044440000404040044040400440044009400400070767007eeee880
6d6d6d51d6dd1d1221d1dd6d15d6d6d676337b6776337b07000000000063b6000060060000994900044999004900999049000990940009907776777088888888
d6dddd126d6dd152251dd6d621dddd6d6d1177d66d7163760003b00006333b600600006000994900049447904904479949004799490049796777676027722772
6d6dd15176ddd512215ddd67151dd6d66d1713766dc1137d00333b00061113600600006000949900049449004944790049447900904497000767777070007007
55d515127d6d6d5115d6d6d721515d5576711c677671176c00111300061113600600006000949900049494900499949404997990409979900777676070007007
0151512007d6d510015d6d7002151510076dd670076d06d700111300006116000060060000947900094790009479000009490000049700006767777070777007
00121200006d65000056d60000212100007667000076707000011000000660000006600000900900099094009449440009494400009990000606666007070770
000007007cd6d6d70000000770000000007667000000000000000000000000000000000000000000000000000007700000000000077766700007000000007000
000006700cdc67d007776dccdd6700000767d67007000000000000000703b000000000000000000000000000007cc700000000007c7c7cd70008e00000008e00
00700c700d6c0c607dccc6dd67cc670076dc7d67760070070000000076337b0700000000000000000000000007c7bc600003b00676c6d77d00e88e00000e88e0
00600c7006c60c7000006cc6d60000006dcc77d66d706076000000006d7163760000000000000000000000000c3367c000333b0c6c6dd7c77e8888e007e8888e
07c06c6007c006000000006d6cc600006dc7cc766dc0c07d000000076dc1137d0000000000000000000000000c1713c0001113006cdd76c78888882008888882
06c0c6d007c007000076cc76dd6cccd7767ccd677670076c70c000007671176c0000000000000000000000000c1163d070111300c67767c60028820000028820
0d76cdc007600000000076ddccd67770076dd670076d06d77d6d00d7076d06d70000000000000000000000000dc11660cc611067d7ccc76d0008200000008200
7d6d6dc700700000000000077000000000766700007670700776067000767070000000000000000000000000006dd60017c6061c076c6d700002000000002000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000033300000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003333333333333333300033333000300033333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000
00030000000000000000007000000303007000000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000
00300777077707770777076707770030076707770707770777003000000000000000000000000000000000000000000000000000000000000000000000000000
03007666766676667666769676667000764676667676667666700300000000000000000000000000000000000000000000000000000000000000000000000000
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
0001070200000000000000000000000000010000070707070000000000000000000100000000808000000000000000000000000e01008040000000000000000080800000804000400000000000000000804000000300004000000000000000000000000006060000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101062106010106667101060101010101010101010601060101010101010101010101010101010101010101010101010101010601010101010101010101010101010101010101010101010101010104010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101063101076771010621010101080818283101010601010101010101010101010101010101010101010101010101010106010101010101010101010101008090a0b0c0d0e0f10101010101008090a0b0c0d0e0f10101010101010101010101010101010101010101010101010101010101010101010101010101010
18191a1b1c1d1e1f1010101080818283101090919293101010101010101010101010101010101010101010101010101010101010106210101010101010101010101018191a1b1c1d1e1f10101010101018191a1b1c1d1e1f10101010101010101010101010101010101010101010101010101010101010101010101010101010
28292a2b2c2d2e2f10101008909192930d0ea0a1a2a3101010101010101010101010101010101010101010501010333333101034341010101010101010101010101028292a2b2c2d2e2f10101010101028292a2b2c2d2e2f10101010101010101010101010101010101010101010101010101010101010101010101010101010
38393a3b3c3d3e3f10101018a0a1a2a31010b0b1b2b3101010101010101010101010101010101010101034341010333333101010101010101010101010101010101038393a3b3c3d3e3f10101010121038393a3b3c3d3e3f10101010101010101010101010101010101010101010101010101010101010101010101010101010
48494a4b4c4d4e4f10101032b0b1b2b31010101f1010101010101010101010101210101010101010102610101010333310101010101010101010101010101010101048494a4b4c4d4e4f10101034341048494a4b4c4d4e4f10101010101010101010101010101010101010101010101010101010101010101010101010101010
58595a5b5c5d5e5f1010101010101010101010101010101010101010101010343434101010101010103410101010331010103434341010101010101010101010101058595a5b5c5d5e5f10103333331058595a5b5c5d5e5f10101010101010101010101010101010101010101010101010101010101010101010101010101010
10106a6b6c6d6e848510101010101010101010101010101010101010101034341034341010101010101010101050101010343434101010101010101010641010464768696a6b6c6d6e6f10331010331068696a6b6c6d6e6f10101010101010101010101010101010101010101010101010101010101010101010101010101010
51457a7b7c7d64949550541010101010101010103333101010101010333434501010103412104510101010343434343434343410101010101010101010343434565778647a7b7c7d357f33105145335178797a7b7c7d7e7f10101010101010101010101010101010101010101010101010101010101010101010101010101010
1111111111111111111111040506070405060704113410101010101034111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111040507101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121141514161714171616213433333333333334212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121141414101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121141414141616171717211111111111111111212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212110101010101010101010101010101010101010101010101010101010101010101010101010
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212110101010101010101010101010101010101010101010101010101010101010101010101010
0000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101020202020132013132020202020202013
0000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101020727113131373702020720000702020
0000101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000007020202072000000000000000000
0010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
0010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000
000010101010101010101010101010103333101010101010101010101010333333001010101010101010101010101010101010101010101010101010101010101010101010101010100010d0d0101010101010101010101010101010101010101010101010101010101010101010101000000000000071131313131313137300
0000101010101010101010101010101033333310103434103434341010333333333300101010101010101010101010101010101010101010101010101010101010101010343410101000d23333101010101010101010101010101010101010101010101010101010101010101010101071131373000070202020202020207200
00101010101010101010101010d2343433333310100000000000101010333333333300103434341010343434101010103434341010101010101010101010101010101010001010101000d233331010101010101010d2333333331010101010101010101010101010101010101010101070202072000000000000000000000000
00101034d33434101010101010d2343433333310101010101010101010333333333300101010101010101010101010101010341010101010101010101010101010101034101010101000d234340010101010101010d2333333331010101010101010101010101010101010101010101000740000760000750074000074007500
00103434d30101101010101010d2343433331010103434103434341010103333330010101010101010101010101010101010101010101010101010101010101010103401101010101010d8d8101010101010101010d2343434341010101010101010101010101010101010101010101000740000000000770075000075007700
00340134d3212110101010101010101010101010101010101010101010101010000010101010101010101010101010101010101034343400333300000033331000340121101010101010103333101033341010101010101010101010101033331010101010101010101010101010101000760000000000000077000075000000
34012134102121101010101010d2343434343434d0d0d000d0d0d03434343434343434d0d0d0d0d0d0d0d0d0d034343434343410101010343434d0d0d034343434012121d0d0d0d0d0d0d03333d0d033343410101010101010101010103333331010101010101010101010101010101000000000000000000000000076000000
0121210101212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101013434010101010101010101010101010101010101011010101010101010101010101010101000007400007500000000760000750000
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121210101212121212121212121212121212121212121211010101010101010101010101010101000007700007500000000000000750000
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211010101010101010101010101010101000000000007400000000000000770000
2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211010101010101010101010101010101000000000007700000000000000000000
