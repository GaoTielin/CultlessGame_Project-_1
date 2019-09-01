--> global-1
object_table = {}
---------------计时器-------------------
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

----------------实例化对象---------------
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

-------------盒体碰撞（触发型）--------------
Trigger_table = {}

function Update_Trigger()
    for _, v in pairs(Trigger_table) do
        v()
    end
end

local function Trigger(sprit_1, sprit_2)
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

function OnTrigger_enter(sprit_1, sprit_2, enter_func, trigger_name)
    local entered = false
    local is_trigger = false
    local function trigger_enter ()
        is_trigger = Trigger(sprit_1, sprit_2)
        if not entered and is_trigger then
            enter_func()
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
    end

    local idx = #Trigger_table + 1
    add(Trigger_table, trigger_enter)
    sprit_1.destroy_trigger_enter = function()
      Trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_enter = function()
      Trigger_table[idx] = nil
    end

    return trigger_enter
end

function OnTrigger_stay(sprit_1, sprit_2, stay_func, trigger_name)
    local function trigger_stay()
        if Trigger(sprit_1, sprit_2) then
            stay_func()
        end
    end

    local idx = #Trigger_table + 1
    add(Trigger_table, trigger_stay)
    sprit_1.destroy_trigger_stay = function()
      Trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_stay = function()
      Trigger_table[idx] = nil
    end

    return trigger_stay
end

function OnTrigger_exit(sprit_1, sprit_2, exit_func, trigger_name)
    local entered = false
    local is_trigger = false
    local function trigger_exit()
        is_trigger = Trigger(sprit_1, sprit_2)
        if not entered and is_trigger then
            entered = true
        end
        if entered and not is_trigger then
            exit_func()
            entered = false
        end
    end

    local idx = #Trigger_table + 1
    add(Trigger_table, trigger_exit)
    sprit_1.destroy_trigger_exit = function()
      Trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_exit = function()
      Trigger_table[idx] = nil
    end

    return trigger_exit
end

-------------盒体碰撞（碰撞型）--------------
Cllision_Table = {}
function Update_Cllision()
    for k, v in pairs(Cllision_Table) do
        v.width()
        v.height()
    end
end

function OnCllision(sprit_1, sprit_2, cllision_func)
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
    add(Cllision_Table, tbl)
end
---------------------------------------

--------------地形碰撞-------------------
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


----------------------创建动画-------------------
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

-------------切换动画----------------
function change_animation(spr_obj, ani_flag)
    spr_obj.animation = spr_obj.animation_table[ani_flag]
end

-----------动画播放---------------
function update_animation()
    for v in all(object_table) do
        if v.animation then
            v.animation()
        end
    end
end

------------切换对象---------------
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
  songzi.destroy()
  -- for v in all(songzi.table) do
  --   printh(" des--1-------------- ")
  --   v.destroy()
  -- end
  for i = 1 ,#this_songzi_cfg do
    -- printh("this-i = " .. i, "dir")
    this_songzi_cfg[i] = nil
  end

  local level_cfg = cfg_levels["level" .. level]
  enemies = init_enemies(level_cfg.enemys)
  if #level_cfg.songzi ~= 0 then
    for i = 1 ,#level_cfg.songzi do
      -- printh("level-i = " .. i, "dir")
      this_songzi_cfg[i] = level_cfg.songzi[i]
    end
    if this_songzi_cfg then
      songzi = init_songzis(this_songzi_cfg)
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
