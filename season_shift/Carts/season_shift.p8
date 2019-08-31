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
      player.vecter.y -= cfg_jump_speed
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
      if get_map_flage(map_x, map_y) ~= 1 then
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
      if get_map_flage(player.pos_x, map_y) == 1 or get_map_flage(map_x, map_y) ~= 1 then
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
     if get_map_flage(map_x, map_y) ~= 1 then
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
     if get_map_flage(map_x, map_y) ~= 1 then
       player.state = "nomal"
       change_animation(player, "nomal")
       player.is_physic = true
       player.pos_x = player.pos_x + (player.flip_x and -1 or 1)
     end
    end
  end,
}

function _init()
  cls()
  game_level = 1
  camera_location = {
    x = 0,
    y = 0,
  }
  direction_flag = {
    x,
    y,
  } --Ê‚àßπÂ‚Ä¶‚û°Ô∏èÊ†‚ô•Á≠æ
  game_state_flag = "play"--Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊ†‚ô•Á≠æ
  gravity = cfg_gravity-- È‚ô•‚ô™Â‚åÇõ
  update_state_flag = "play"
  draw_state_flage = "play"
  player_state_x_flag = "nomal"
  player_acceleration_fast = cfg_player_acceleration_fast--Â‚åÇ†È‚ñàüÂ∫¶
  player_acceleration_low = cfg_player_acceleration_low
  player_max_v = cfg_player_max_v

  player = init_player()
  player.can_jump = player.max_jump
  mogu_hit = map_trigger_enter(player, 3, player.mogu_hit, "down")
  jinji_hit = map_trigger_enter(player, 7, game_over, "all")
  lupai_hit = map_trigger_stay(player, 6, function()
    print("x", player.pos_x, player.pos_y + 3, 4)
    if btnp(5) then
      game_level = 1
      change_level(game_level)
      player.pos_x = 48
      player.pos_y = 80      
    end
  end, "all")

  tail = init_tail()
  -- map_col = map_hit(player)

  -- oncllision(player, text_obj)
  cfg_levels = cfg_levels_autumn
  change_camera = init_change_camera()

  snow = init_snow()
  chest = init_chest()
  thief = init_thief()
  enemies = init_enemies(cfg_levels.level1.enemys)
  this_songzi_cfg = {}
  for k,v in pairs(cfg_levels.level1.songzi) do
    add(this_songzi_cfg, v)
  end
  if this_songzi_cfg then
    init_songzis(this_songzi_cfg)
  end
  -- pinecones of whole level
  global_pinecone = init_global_pinecone()
  max_pinecone_num = 10
  player_pinecone = 3
  timer = newtimer()

  map_ani_1 = init_map_animation(7, 15, 2, false)
  map_ani_2 = init_map_animation(6, 15, 2, true)

  -- register collision
  -- ontrigger_enter(player, bee, handle_player_hit, 'player_hit')
  ontrigger_stay(player, chest, function()
    if btnp(5) then
      if player_pinecone ~= 0 then
        player_pinecone -= 1
        chest.pinecone += 1
      end
    end
  end, 'chest_store')
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
        update_trigger()

        player.check_position()
        map_ani_1.update()
        map_ani_2.update()
        player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
        if (btnp (4) and player.can_jump <= player.max_jump and player.can_jump > 0) controller.jump()
        if (btn (2)) controller.up()
        if (btn (3)) controller.down()
        if (btn (0) ) controller.left()
        if (btn (1) ) controller.right()
        -- if (btnp (5)) change_level(2)

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
        if abs(player.vecter.x) < player_acceleration_low then
            player_state_x_flag = "nomal"
        -- elseif abs(player.vecter.x) == player_max_v then
        --     player_state_x_flag = "fast_go_stay"
        else
            player_state_x_flag = "fast_back"
        end
        if (player.pos_x < 0) player.pos_x = 1
        snow.update()
        timer.update()
        tail.update()
        enemies.update()
        move_camera()
        thief.draw_run1()

    end,

    game_over_update = function()

    end,
  },
  ---------------------------------

  -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------

  draw_states = {
    change_level_draw = function()
      map(map_location.x, map_location.y)

      for v in all(object_table) do
        if v.flip_x then
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height, v.flip_x)
        else
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
        end
      end

      print(player.can_jump)
      print(player.state)
      print(player.is_physic)
      print(player_state_x_flag)
      print(player.vecter.x)
      -- snow.draw()
      chest.draw()
      enemies.draw()
      global_pinecone.draw()
      draw_pinecone_ui()
      mogu_hit()
      jinji_hit()
      -- map_col.update_trg()
      -- camera(player.pos_x-64, 0)
    end,

    play_draw = function()
      map(map_location.x, map_location.y)

      for v in all(object_table) do
        if v.flip_x then
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height, v.flip_x)
        else
          spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
        end
      end

      print(player.can_jump)
      print(player.state)
      print(player.is_physic)
      print(player_state_x_flag)
      print(player.vecter.x)
      -- snow.draw()
      chest.draw()
      thief.update_run1()
      enemies.draw()
      global_pinecone.draw()
      draw_pinecone_ui()
      mogu_hit()
      jinji_hit()
      lupai_hit()
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
        -- destroy = function()
        --     -- spr_obj = nil
        --     spr_obj.trigger_enter = nil
        --     object_table[obj_idx] = nil
        -- end,
        flip_x = false,
        flip_y = false,
    }
    spr_obj.destroy = function()
      if spr_obj.destroy_trigger_enter then
        spr_obj.destroy_trigger_enter()
      end
      if spr_obj.destroy_trigger_stay then
        spr_obj.destroy_trigger_enter()
      end
      if spr_obj.destroy_trigger_stay then
        spr_obj.destroy_trigger_enter()
      end
      object_table[obj_idx] = nil
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
    local xs = w1 * 0.5 + w2 * 0.5 - 2
    local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
    local ys = h1 / 2 + h2 / 2 - 2
    if xd < xs and yd < ys then
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

------------Â‚òâ‚ô•Ê‚ô™¢ÂØπË±°---------------
function exchange_obj(obj_1, obj_2)
    local mid_obj = obj_1
    return obj_2, mid_obj
end

function handle_player_hit ()
    if player_pinecone == 0 then
        -- todo change scene to gameover
    else
        player_pinecone -= 1
        local p = {sp=141, pos_x=player.pos_x+8, pos_y=player.pos_y+8, is_dropped=true}
        add(global_pinecone.pinecone_list, p)
        timer.add_timeout('remove_pinecone'..player_pinecone, 3, function()
            del(global_pinecone.pinecone_list, p)
        end)
        player.vecter.x = player.flip_x and 2 or -2
        game_over()
    end
end

function move_camera ()
    local map_start = 0
    local map_end = 1024
    local cam_x = (player.pos_x - 64) + (player.width * 8) / 2
    if cam_x < map_start then
        cam_x = map_start
    end
    if cam_x > map_end - 128 then
        cam_x = map_end - 128
    end
    camera(cam_x, 0)
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
  local old_camera_pos_x = cfg_levels.level1.camera_pos.x*8
  local old_camera_pos_y = cfg_levels.level1.camera_pos.y*8
  local now_camera_pos_x = cfg_levels.level1.camera_pos.x*8
  local now_camera_pos_y = cfg_levels.level1.camera_pos.y*8
  local flip_x = false
  local flip_y = false
  local fix_driction = 0
  local function change(level)
    now_camera_pos_x = cfg_levels["level" .. level].camera_pos.x*8
    now_camera_pos_y = cfg_levels["level" .. level].camera_pos.y*8
    flip_x = old_camera_pos_x > now_camera_pos_x
    flip_y = old_camera_pos_y > now_camera_pos_y
    fix_driction_x = now_camera_pos_x - old_camera_pos_x
    fix_driction_y = now_camera_pos_y - old_camera_pos_y
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
    for i=1,#this_songzi_cfg do
      cfg_levels["level" .. game_level].songzi[i] = this_songzi_cfg[i]
    end
    -- cfg_levels["level" .. game_level].songzi = this_songzi_cfg
  end
  game_state_flag = "change_level"
  for v in all(enemies.enemies) do
      v.destroy()
  end
  for k,v in pairs(this_songzi_cfg) do
    v = nil
  end
  local level_cfg = cfg_levels["level" .. level]
  enemies = init_enemies(level_cfg.enemys)
  if level_cfg.songzi then
    for k,v in pairs(level_cfg.songzi) do
      add(this_songzi_cfg, v)
    end
    if this_songzi_cfg then
      init_songzis(this_songzi_cfg)
    end
  end
  local camera_pos_x = level_cfg.camera_pos.x*8
  local camera_pos_y = level_cfg.camera_pos.y*8
  player.pos_x = level_cfg.player_start_pos.x*8 + camera_pos_x
  player.pos_y = level_cfg.player_start_pos.y*8 + camera_pos_y
  player.hand_songzi = 0
  change_camera.change(level)
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

-->8
-->map-3
function get_map_flage(m_x, m_y)
  return fget(mget(m_x/8+map_location.x,m_y/8+map_location.y))
end

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
    elseif direction == 'all' then
        x1 = x
        y1 = y
        x2 = x + w
        y2 = y + h
    end

    if get_map_flage(x1, y1) == flag or get_map_flage(x2, y2) == flag
        or get_map_flage(x1, y2) == flag or get_map_flage(x2, y1) == flag then
            return true
    end
    return false
end

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

-->8
-- objects
function init_chest ()
    local c = init_spr("chest", 139, 9, 48, 2, 2, true, 0, 0)
     c.pinecone = 0
     c.draw = function ()
         print(c.pinecone..'/'..10, c.pos_x-4, c.pos_y-6, 4)
     end
     return c
end

function init_songzis(songzi_config)
  for i,v in pairs(songzi_config) do
    local pos_x, pos_y = v[1], v[2]
    local b = init_spr("songzi", 141, pos_x, pos_y, 1, 1, false, 0, 0)
    init_animation(b, 141, 142, 5, "move", true)
    ontrigger_enter(b, player, function()
      b.destroy()
      player_pinecone = player_pinecone + 1
      player.hand_songzi = player.hand_songzi + 1
      songzi_config[i] = nil
    end)
  end
end

-- enemy could be bee or catepiller, depends on type args
function init_enemy (pos_x, pos_y, max_range, speed, type)
    local e
    if type == 'bee' then
        e = init_spr("bee", 48, pos_x, pos_y, 1, 1, false, 0, 0)
        init_animation(e, 48, 50, 10, "move", true)
    elseif type == 'catepiller' then
        e = init_spr("catepiller", 34, pos_x, pos_y, 1, 1, true, 0, 0)
        init_animation(e, 34, 35, 10, "move", true)
    end
    ontrigger_enter(e, player, game_over)

    e.flip_x = false
    e.update = function ()
        if not e.flip_x and e.pos_x > pos_x + max_range then
            e.flip_x = true
        end
        if e.flip_x and e.pos_x < pos_x - max_range then
            e.flip_x = false
        end
        e.pos_x = e.pos_x + (e.flip_x and -speed or speed)
    end
    e.draw = function ()
        spr(e.sp, e.pos_x, e.pos_y, 1, 1, e.flip_x)
    end
    return e
end

function init_enemies (enemy_config)
    local o = {
        enemies = {}
    }
    if enemy_config.bees then
      for i=1,#enemy_config.bees do
          local e = enemy_config.bees[i]
          local pos_x, pos_y, max_range, speed = e[1], e[2], e[3], e[4]
          local b = init_enemy(pos_x, pos_y, max_range, speed, 'bee')
          add(o.enemies, b)
      end
    end
    if enemy_config.catepillers then
      for i=1,#enemy_config.catepillers do
          local e = enemy_config.catepillers[i]
          local pos_x, pos_y, max_range, speed = e[1], e[2], e[3], e[4]
          local c = init_enemy(pos_x, pos_y, max_range, speed, 'catepiller')
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

  player.hit = function()
    hit(player, 1, "all", function()
      -- player.vecter.x = 0
      -- player.vecter.y = 0
    end)
    hit(player, 1, "height", function()
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
      -- if player.vecter.y>0 then
      --    player.pos_y = flr((player.pos_y + player.vecter.y)/8)*8
      -- elseif player.vecter.y<0 then
      --    player.pos_y = flr((player.pos_y + player.vecter.y)/8)*8 + 8-1
      -- end
      player.vecter.y = 0
    end)
    hit(player, 1, "width", function()
      -- player.pos_x = (player.vecter.x>0) and flr((player.pos_x + player.vecter.x)/8)*8 or flr((player.pos_x + player.vecter.x)/8)*8 + 8
      player.vecter.x = 0
      local map_y = player.pos_y + player.height*8+7
      if player.state == "jump" and get_map_flage(player.pos_x, map_y) ~= 1 then-- (mget(player.pos_x, map_y - 6, 1) or get_map_flage(player.pos_x + (player.flip_x and -3 or (player.width*8 + 2)), player.pos_y - 8) == 1) and
        local map_x = player.pos_x + (player.flip_x and 0 or (player.width*8))

        player.state = "climb"
        player.can_jump = 1
        change_animation(player, "climb")
        change_animation(tail, "climb")
        player.is_physic = false
        player.vecter.y = 0
      end
    end)
    hit(player, player.new_ground, "height", function()
      player.can_jump = player.max_jump
      player.vecter.y = 0
    end)
    hit(player, player.new_ground, "width", function()
      player.vecter.x = 0
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

  player.mogu_hit = function()
      player.vecter.y = -1*cfg_mogu_jump
  end

  player.check_position = function()
    if player.pos_x + 3 >= camera_location.x + 128 then


      change_level(game_level+1)
      game_level = game_level + 1
    end
    if  player.pos_x + 8 <= camera_location.x then

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
    local thief = init_spr("thief", 160, 20, 50, 1, 1, true)
    thief.mogu_jump_event = false
    thief.flip_x = false
    thief.draw_run1 = function ()
        thief_mogu_hit()
        spr(thief.sp, thief.pos_x, thief.pos_y, 1, 1)
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
            thief.pos_x += 1
        end
        if thief.pos_x >= 68 and not thief.mogu_jump_event then
            thief.vecter.y -= 4
            thief.vecter.x += 3
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
    end
    thief.mogu_hit = function()
        change_animation(thief, 'jump')
        change_animation(tail, 'jump')
        thief.vecter.y = -4
        timer.add_timeout('thief_jump', 0.15, function()
            thief.vecter.x = 1
        end)
    end
    thief.draw_run2 = function ()
    end
    thief.update_run2 = function ()
      tail.update()
    end
    thief_mogu_hit = map_trigger_enter(thief, 3, thief.mogu_hit, "down")
    init_animation(thief, 160, 162, 10, "nomal", true)
    init_animation(thief, 167, 170, 10, "run", true)
    init_animation(thief, 183, 186, 10, "jump", true)
    init_animation(thief, 176, 178, 10, "climb", true)
    return thief
end

-->8
-->game_cfg

cfg_player_acceleration_fast = 0.2 -- Ë∑‚û°Ô∏èÊ≠•Â‚åÇ†È‚ñàüÂ∫¶
cfg_player_acceleration_low = 0.3 -- Ë∑‚û°Ô∏èÊ≠•Â‚ô•‚óÜÈ‚ñàüÂ∫¶
cfg_jump_speed = 4 -- Ë∑≥Ë∑‚¨áÔ∏èÈ‚ñàüÂ∫¶
cfg_climb_speed = 2 -- Á‚òâ¨Â¢‚ñ•È‚ñàüÂ∫¶
cfg_gravity = 0.4 -- È‚ô•‚ô™Â‚åÇõ(Â‚Ä¶‚û°Ô∏è‰∏‚¨ÖÔ∏èÁö‚ñëÂ‚åÇ†È‚ñàüÂ∫¶)
cfg_player_max_v = 1.6 -- Êú‚ñàÂ§ßÈ‚ñàüÂ∫¶
cfg_mogu_jump = 4 -- È‚ô•‚ô•Ë‚ñ§‚û°Ô∏èË‚óÜ‚ô•Ë∑≥Ë∑‚¨áÔ∏èÈ‚ñàüÂ∫¶
cfg_camera_move_speed = { -- Â‚òâ‚ô•Ê‚ô™¢Âú∞ÂõæÊ‚ùé∂ÈÀáúÂ§¥ÁßªÂ‚åÇ®È‚ñàüÂ∫¶
  x = 5,
  y = 5,
}

cfg_levels_autumn = {
  level1 = {
    player_start_pos = { -- Ëß‚òÖËÏõÉ≤Ëµ∑Âß‚¨ÖÔ∏èÂú®Â‚úΩ≥Â‚ô™°‰∏≠Áö‚ñë‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 0,
      y = 7,
    },
    camera_pos = { -- Áõ∏Êú∫‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 0,
      y = 0,
    },
    level_type = "noaml", -- È‚úΩ‚ô™ÁΩÆÂú∞ÂõæÁ±ªÂû‚¨ÖÔ∏èÔº‚òâÂ‚óÜØÂ‚ñíöÂ‚òâ∞‰∏‚ô™Â‚Ä¶üòêÂú∞Âõæ‰ΩøÁ‚¨ÜÔ∏è®‰∏‚ô™Â‚Ä¶üòêÁö‚ñëÂú∞ÂΩ¢È‚úΩ‚ô™ÁΩÆÔºÏõÉ
    enemys = { -- ÊÀáüòê‰∫∫È‚úΩ‚ô™ÁΩÆÔºüòêÂ‚óÜüê±ÊÀá∞Â‚òâ‚óèÂ‚òâ´‰∏∫xÂù‚Ä¶Ê†‚ô•ÔºüòêyÂù‚Ä¶Ê†‚ô•ÔºüòêÁßªÂ‚åÇ®Êú‚ñàËøúË∑ùÁ¶ª, È‚ñàüÂ∫¶
      bees = {
        -- {6*8, 6*8, 16, 0.5},
        -- {56*8, 8*8, 16, 0.5}
      },
      catepillers = {
        -- {10*8, 10*8, 16, 0.5}
      }
    },
    songzi = {
      -- {9*8, 10*8}
    },
  },
  level2 = {
    player_start_pos = { -- Ëß‚òÖËÏõÉ≤Ëµ∑Âß‚¨ÖÔ∏èÂú®Â‚úΩ≥Â‚ô™°‰∏≠Áö‚ñë‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉps:Áõ∏ÂØπ‰∫üÖæÔ∏èÊ‚û°Ô∏è‚ñëÂ‚¨áÔ∏è‚óÜÊú∫
      x = 0,
      y = 7,
    },
    camera_pos = { -- Áõ∏Êú∫‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 16,
      y = 0,
    },
    level_type = "noaml", -- È‚úΩ‚ô™ÁΩÆÂú∞ÂõæÁ±ªÂû‚¨ÖÔ∏èÔº‚òâÂ‚óÜØÂ‚ñíöÂ‚òâ∞‰∏‚ô™Â‚Ä¶üòêÂú∞Âõæ‰ΩøÁ‚¨ÜÔ∏è®‰∏‚ô™Â‚Ä¶üòêÁö‚ñëÂú∞ÂΩ¢È‚úΩ‚ô™ÁΩÆÔºÏõÉ
    enemys = { -- ÊÀáüòê‰∫∫È‚úΩ‚ô™ÁΩÆ
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        -- {27*8, 6*8, 8, 0.5}
      },
    },
    songzi = {
      {13*8, 8*8},
      {26*8, 6*8},
    },
  },
  level3 = {
    player_start_pos = { -- Ëß‚òÖËÏõÉ≤Ëµ∑Âß‚¨ÖÔ∏èÂú®Â‚úΩ≥Â‚ô™°‰∏≠Áö‚ñë‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 0,
      y = 7,
    },
    camera_pos = { -- Áõ∏Êú∫‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 32,
      y = 0,
    },
    level_type = "noaml", -- È‚úΩ‚ô™ÁΩÆÂú∞ÂõæÁ±ªÂû‚¨ÖÔ∏èÔº‚òâÂ‚óÜØÂ‚ñíöÂ‚òâ∞‰∏‚ô™Â‚Ä¶üòêÂú∞Âõæ‰ΩøÁ‚¨ÜÔ∏è®‰∏‚ô™Â‚Ä¶üòêÁö‚ñëÂú∞ÂΩ¢È‚úΩ‚ô™ÁΩÆÔºÏõÉ
    enemys = { -- ÊÀáüòê‰∫∫È‚úΩ‚ô™ÁΩÆ
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {

      },

    },
    songzi = {
      {36*8,8*8},
      {44*8,6*8},
    },
  },
  level4 = {
    player_start_pos = { -- Ëß‚òÖËÏõÉ≤Ëµ∑Âß‚¨ÖÔ∏èÂú®Â‚úΩ≥Â‚ô™°‰∏≠Áö‚ñë‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 0,
      y = 7,
    },
    camera_pos = { -- Áõ∏Êú∫‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 48,
      y = 0,
    },
    level_type = "noaml", -- È‚úΩ‚ô™ÁΩÆÂú∞ÂõæÁ±ªÂû‚¨ÖÔ∏èÔº‚òâÂ‚óÜØÂ‚ñíöÂ‚òâ∞‰∏‚ô™Â‚Ä¶üòêÂú∞Âõæ‰ΩøÁ‚¨ÜÔ∏è®‰∏‚ô™Â‚Ä¶üòêÁö‚ñëÂú∞ÂΩ¢È‚úΩ‚ô™ÁΩÆÔºÏõÉ
    enemys = { -- ÊÀáüòê‰∫∫È‚úΩ‚ô™ÁΩÆ
      caterpillar ={},
      bees = {
        {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        {52*8, 9*8, 8, 0.5}
      },
    },
    songzi = {
      {54*8, 9*8},
    },
  },
  level5 = {
    player_start_pos = { -- Ëß‚òÖËÏõÉ≤Ëµ∑Âß‚¨ÖÔ∏èÂú®Â‚úΩ≥Â‚ô™°‰∏≠Áö‚ñë‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 0,
      y = 7,
    },
    camera_pos = { -- Áõ∏Êú∫‰Ω‚ô™ÁΩÆ Â‚ô™Àá‰Ω‚ô™Ôº‚òâÊ†ºÔºÏõÉ
      x = 64,
      y = 0,
    },
    level_type = "noaml", -- È‚úΩ‚ô™ÁΩÆÂú∞ÂõæÁ±ªÂû‚¨ÖÔ∏èÔº‚òâÂ‚óÜØÂ‚ñíöÂ‚òâ∞‰∏‚ô™Â‚Ä¶üòêÂú∞Âõæ‰ΩøÁ‚¨ÜÔ∏è®‰∏‚ô™Â‚Ä¶üòêÁö‚ñëÂú∞ÂΩ¢È‚úΩ‚ô™ÁΩÆÔºÏõÉ
    enemys = { -- ÊÀáüòê‰∫∫È‚úΩ‚ô™ÁΩÆ
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        {}
      },
    },
    songzi = {
    }
  },
}

__gfx__
0000000033333333f8ff21ff66666666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
00000000444444441ffff21f6dddddd67fff7fff7fff7fffff7fff7fff7fff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
000000004444554421f8111f6d6dd6d6c7f7c7f7c7f7c7f7f7c7f7c7f7c7f7c7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444444f21222216ddd6dd6cc7ccc7ccc7ccc7c7ccc7ccc7ccc7cccffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000045544444ff12ff8f6dd6ddd6cccc7ccccccccccccc7cccccccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444444ff12ffff6d6dd6d6cccccccccccccc7ccccccccccccc7cccffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000000044444554f1f1f12f6dddddd6ccccccccc7ccccccccccccc7ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
00000000444444442ff21ff166666666ccccccc7ccccccccccccc7ccccccccccffffffffffffffffff9fffffaaaaafffffffffffffffffffffffffffffffffff
ffffffff33333333ffffffff00000000ccccccccccccccccccccccccccccccccfffffffffffffffff99ffffaaa7aaaffffffffffffffffffffffffffffffffff
ffffffff33353333ffffffff00000000cc7ccccccccccccc7cccccccccccccccffffffffffffffffffffffaaa77aaaafffffafffffffffff22ffffffffffffff
ffffffff53545353ffffffff00000000ccccccccccccccccccccccccccccccc7ffffffffffffffffffffffaa777aa9aaaffaaafffffffff2282fffffffffffff
ffffffff45445355ffffffff00000000ccccccccccccccccccccccccccccccccfffffffffffffffffffaaaaa777aa9aaaaaaaaaffffff22222ffffffffffffff
ffffffff44444544fff8ffff00000000ccccccccccccccccccccccccccccccccffffffffffffffffffafaaa7777aaa9aaaaaaaaaffffff2222ffffffffffffff
ffffffff44444444ff878fff00000000ccccc7ccccccccccccc7ccccccccccccfffffffffffffffffffffaaa777aaa9aaa777aaaafaffffaa2ffffffffffffff
ffffffff45444444f88888ff00000000ccccccccccccccccccccccccccccccccfffffffffffffffffffffaaaaa7a9aaaaaa7aaaaaaaffffaaaffffffffffffff
ffffffff44444454ff777fff00000000ccccccccccccccccccccccccccccccccfffffffffffffffffaffaaaaaaaaa9aaaaaaaaaaaaaaaaaaaaffffffffffffff
00000000444444440000000000000000bb000000bb000000fffffffffffffffffffffffafffffffffaaaaaaaaaaaa999aaaaaaaa9aaaaaffaaffffffffffffff
000000004444444400000000000000003300000033000000ffffffffffffffffffffffaaafffffaaaaaaaaa777aaaa9a99aaaaa9aaaaaaaaaaffffffffffffff
00000000444445440000000000000000bb0000000bb00000fffffffffffffffffffffffffffff9aaaaa9aaaa77aaaaaa999aa99aaa7aaaaaaaafffffffafffff
000000004444444400000000000000003300000000330000fffffffffffffffffffffffffffffa999999aaaaa7aaaaaaa999999aaa7a99aaaaaffffffaafffff
00000000444444440000000000003000bb0000000bb00000ff3ffffffff3fffffffffffffffaaa99999aaaaa9aaaa9aaaa9999aaaa77aaaa9aaaffffffffffff
000000004544444400000000000b3b00bb000000bb000000fff333fffff3ffffffffffffffaaaa9999aaaaaaa9999aaaaaa9aaaaaaaa9aa999aaafffffffffff
00000000444444440bbb3b3b0bbb0b3bbb000000bb000000fff3f3fffff33ffffffffffffaaaaaaa9999aaaaaaaaaaaaaaaaaaaaaaaaa9a99a99999fffffffff
00000000444444440bbb3b3b0bb0003b0000000000000000fff3fffffff3f3ffffffffffaaaaaaaaa799aaaaaaaaaaaaaaaaaaaa9aaaa99999999799ffffffff
000000000000000000000000977777773333333300000000fffffffffff8ffffffffffffaaaaaaaaaa779aaaaa99aaaaaaaaaaaaa9aa999999997799ffffffff
760006706660006676000670d99999973233323300000000f8fffffffffffff8ffffffffaaaaaaaaaaa77aaaa9999aaaaaaaaaaaaa999999999999999fffffff
776067707776067777606770d99999972d232d2700000000ffaf8fffffff8fffffffffffaaaaaaaaaaa77aaa999999aa7777aaaa99999999999a9a9999ffffff
0760670007779c4c07606700d99999972dddddd700000000ffff88fffff888ffffffffff99aaaaaaaaaaaaa99999999aaa99aaaa999999999aaaa9999fffffff
0079c4c0000550000079c4c0d99999972dddddd700000000f8f8988fff88888ffffffffff99aaaaaaaaaaa999992999999aaaaa999999999aaaaa9999fffffff
005500000009900000550000d99999972dddddd700000000f889a98ff8899988fffffffff99aaaa99aaaaaaaa922a999aaaaa999997799999999a999ffffffff
009900000000500000099000d99999972dddddd700000000889aaa98889aa998ffffffffff99aa9aaaaaaaaaa222aaaaaaaa9a9a777799999a999999ffffffff
000570000000070000000570d99999972dddddd70000000089aaaaa8899aaa98fffffff999999aaaaaaaa77999e2997777a9aaa7227999999a99999fffffffff
fffffffffffffffffffffffffffffffffff33fffffaa33fffffffffffffffffffffffff9999a99aaaaaaa779999e22277a999a72e779999999aa9fffffffffff
ffffffffffffffffff777f999ffffffff999f3ffffaa9f3fffffffffffffffffffffffaaaaaaa9aa9999799999aee292279992eaee999eee99aa99ffffffffff
fffffffffffffffffff7999999fffffffaa9f3ffff999ff34fffffffffffffffffffffaaaaaaaaa29999999999aaee9222eee22e99aa99ee9a99999fffffffff
faaadffffffffffffff79997999ffffffaa9f3ffffffff3ff44f44ff4fff444ffffffaaaaaaaaa992999999999aaaa99222ee2ee999aaa999929999fffffffff
faaadffffaaadffffff999777999fffffffff3ffffffff3ffff4444ff44444fffffffaaaaaaaa99922999999999999aa9222e2ee9e9aaaaa9299a9999fffffff
fffadffffffadfffff99977777999ffffffff3fffffff3fffff44fffffff4fffffffffaaa9aaa999aaee9a999999929ae22222eeeee9aaaa29999a7999ffffff
ffafffffffaadffff9997777777999ffffff333fffff333fff4ffffffff4ffffffffffaaa9aaa9aaaaeeeaaaaa99992ae22222ee2222222299aaaa77999fffff
fffffffffaffffff999777777777999ffff33333fff33333ffffffffffffffffffffff999aa999997799222ee9999922e2222ee29ee2ee9999aaaa77999fffff
ffffffffffffffff997777777777799fffffffffffffffffffffffffffffffffffff9999999aaa777779e222eeeee99222222229999999999aaaaaa7799fffff
ffffffffffffffffff77e87777777ffffff88ffffffffffffffffffffffffffffffaaaaa99a997777777e22222eee992222222e99999999999aaaa9a999fffff
ffffffffffffffffff77887777777fffff8878fffff88fffffffffffffffffffffaaaaaaaa99999777999922222eee9e22222e7999999999999aa99999ffffff
ff9f9ffffff9f9ffff77777755577ffff878888fff8878ffffffffffffffffffffaaaaaaaaaa9999999e92999922779e22222e7aaaa99a99777a999999ffffff
fff7ffffffff7fffff77777755577fff88888788f878888fff2f2ffffff2f2fffffaaaaaaaaa999999e229999922277e22222e7777aaa999977a9aa99fffffff
ff939ffffff939ffff77777755577ffffff77fff88888788fff9ffffffff9fffffffaaaaaaa99999ee22299aa9e22eee222222222eeeaa99997999a99fffffff
fff3ffffffff3ffff7777777559777fffff77fffff7776ffff232ffffff232ffffffa9aaaaa99999229999aaeeee222222222222222222eeef999999ffffffff
fff3fffffff3fffff7777777555777fffff77ffffff76ffffff3fffffff3fffffffffa999aa9999999999aaeee9e92222222299999eeee9ffff9ee99ffffffff
ffff3fffffff3fffffff3fffffff3ffff44444fff44444fffff3fffff9faaf9fffffff999999999999999eeee9999f2222222999ff9e99ffff999999ffffffff
ffff3fffffff3ffffff33ffffff33fff4455544f4455544ffff3ffffffaaaaffffffff9999999f9999999e9e99fffff222222fffff999fffffff999fffffffff
fff3333fff3333ffffff3ffffffff3ff4449444f4449444ff3f3fffffaa99aaffffffff99999fff9999fffff99fffff222222ffffffffffffffff9ffffffffff
ffff3ffffff3ffffffffbffffffffbfff44444fff44444ffff33fffffaa99aaffffffffff999f9f999fffffffffffff222222fffffffffffffffffffffffffff
ffb33ffffb33fffffffffffffffffffffff4fffffff4fffffff3f3ffffaaaaffffffffffffffffff9ffffffffffffff222222fffffffffffffffffffffffffff
ffff3bffffff3bfffffffffffffffffffff4fffffff4fffffff33ffff9faaf9ffffffffffffffffffffffffffffffffe22222ffffff22fffffffffffffffffff
ffff3fffffff3fffffffffffffffffffaaa4fffffff4fffffff3fffffff3ffffffffffffffffffafffffffaffffffffe22222fffff2fffffffffffffffffffff
fff33f3ffff33f3fffffffffffffffff99949999fff4fffffff3fffffff3fffffffffffffffffaafffffffffffffff2222222fffffffafffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffafffffffffffffff22222222fffffffaaffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffff222222222fffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffe222222222ffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff222222e2222222ffffffffffffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffeee922e9992299e229aaaaaaaafffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fffffffffffaafffffff999999299999229999ee229999999fffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000fff9aaaa9aaaaa9999999aa9229999992999999999999aaaaaaaffffffffffff
0000000000000000000000000000000000000000000000000000000000000000ff999999aaaa9999999999999999999999999999999a99999999aaaaafffffff
00040000000994000009400000000000000000000000000000000000000004000000040000000000000000000000000000000000000000000000000000000000
09400400049400000094994000000000004444000444400000000000000049900000499004440400000000000000000000000000000000000006600000066000
94000990494004000940000400444000049999404009994040000000000497790049977949994990044000000000000000000000000000000069760000600600
490049799400499040000400049994004000000400000099094440000499900004997900977097794994040000000000000000000009700006999a6006000060
9044970040449779044049904000094000000000000000000099994004970990049700900999090097794990000000000000000000999a000644496006000060
40997990049909004994977900000004000000000000000000000004497700004990000000000090970797790000000000660000004449000644496006000060
04970000097700909770090000000000000000000000000000000000099000000099900000000000099009000000066006796000004449000064460000600600
0099900000999000099900990000000000000000000000000000000000990000000000000000000000000099000067966a999600000440000006600000066000
00040400400004000000000000000000000000000000000000000000000000000000000000000000000000000006a99969442600000000000000000007f07f00
049009900900099000444000040000004000000000000000000000000000000000000000000000000000000000064442694426000000000000000000feefee20
4900477904904779049999400040000009000000000000000044400000000000000000000000000000000000006644a96792796000000000000000008eeeee20
490049000490490009000004009440000940000000044400049994000000040004400000000004000000040006799799949a9996000000000000000008eee200
49049799049497904000000000099400009440000049994009000940044499904994040004440990044049906a449a44244944260000000000000000008e2000
09049700049497090440040000000994000999944990000440000094499997799779499049994779499497796444994424494426000000000000000000020000
00904990009049004994499400000000000000000000000000000000977049009907977999779000997790000622462262964260000000000000000000000000
00040009000400994477944400000000000000000000000000000000994040990400094040990990099409400066606606606600000000000000000000000000
00000000000d1d000001d0000000000000000000000000000000000000000d0000000d0000000000000000000000000000000000000000000000000000000000
00d00d000d1000000d1001d00000000000d1d1000d1d1000000000000000d1100000d1100dd00d00000000000000000000000000060000000000000000000000
01000110d1000d001000000d00d1d000010000d0d0000d10d0000000000d166100d11661d111d1100dd0000000000600000000006f0000000000000000000000
d000d1611000d110d0000d0001000100d000000d0000000d01d1d000001110000011610016601661d11d0d0000000ff0060000606f0000000000000000000000
10dd1600d0dd16610dd0d110d00000d00000000000000000000001d00d1601100d160010011101001661d1100600f7006f0006ff600000600000000000000000
d011611d0d110100d11d16610000000d00000000000000000000000dd16600d0d11000d00000001d160616616f067f006f06670060660fff0000000000000000
0d1600000166001d1660100000000000000000000000000000000000011000000011100000000000011001006f06700006f70f000677f7000000000000000000
00011000001110000111011d000000000000000000000000000000000011000000000000000000000000001d06f0ff0000f000f00ff000f00000000000000000
000d0d00d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000f00000eff00000f0000000000000000000000
0d1001100100011000ddd0000d000000d00000000000000000000000000000000000000000000000000000000ef00f00ef000f000e00f0000000000000000000
d000d6610d00d6610d0001d0001000000d000000000000000011d00000000000000000000000000000000000ef000ee0f000fee0ef00ee000000000000000000
1000d10d0100d1000100000d000d10000100000000011d000d00010000000d000dd0000000000d0000000d00fe00fe7ee00fe77ef00fe7e00000000000000000
d00d16100d0d161dd00000000000d100001d000000d00010010000d00ddd0110d11d0d000dd001100dd0d110e0ffe700e0fe70e0e0fe70970000000000000000
010d1600010d16000dd00d000000001d0000d11dd100000dd000000dd11116611661d110d11dd661d11d1661f0ee7ee0fef7ee00f0e7eee90000000000000000
0010d1100010d100d11dd11d00000000000000000000000000000000166011001106166111661000116610000fe700000fe700000fe700490000000000000000
000d0001000d0011dd661dd00000000000000000000000000000000001d0d01d0d0001d0d01101d0011d01d000eee00000eee00000eee0000000000000000000
__gff__
0001070200000000000000000000000000010000070707070000000000000000000100000000808000000000000000000000000101008040000000000000000080400000804080400000000000000000804000000300804000000000000000000000000006060000000000000000000000000000030000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101060106010101010101060101010101010101010601060101010101010101010101010101010101010101010101010106010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
1010101062106010101010101060101010101010101010601060101010101010101010101010106710101010101040101010101010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
08090a0b0c0d630f101010101062101010101010411010101060101010101040101010101010106610101010101010101010101010601041101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
18191a1b1c1d1e1f411010101010101041101010101010101010101010101010101010101010023410101010101010101010104010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
28292a2b2c2d2e2f101010101010101010101010101010101010101010101010101010101010023310101010101010101010101010601010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
38393a3b3c3d3e3f101010101010101010101010101010101010343434101010101010101010023310100234341010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
48494a4b4c4d4e4f104010101010441010101010101067101010331033101010101010101010103310100233331010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
58595a5b5c5d5e5f101010101034343410101010101066101010331033101010101010343410101010100233331010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
68696a6b6c6d6e42431010333333101033101010343434101010331033101010101010331010101010540233331010101010103434343434343410651010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
78797a7b7c7d6452535654101010101010505633331010020233331033121044101254334456101033333350563410561050333333101210333333333310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
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
