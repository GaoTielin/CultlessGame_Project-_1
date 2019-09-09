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
    -- box.can_move = true
    map_trigger_enter(box, 7, function(zhui_x, zhui_y)
      -- printh("box_enter==============", "dir")
      local x, y = zhui_x/8, zhui_y/8
      local one = {x, y, mget(x, y)}
      add(changed_map, one)
      mset(x, y, 0)
    end, "all")
    OnCllision(box, player, {
      height = function()
        player.on_ground_function()
        player.vecter.y = box.vecter.y
      end,
      width = function()
          -- if not box.can_move then
          --     player.vecter.x = 0
          -- end
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

      -- hit(box, 1, "width", function()
      --     box.can_move = false
      -- end)
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
            OnCllision(ice, v, {
                width = function()
                  -- ice.can_move = false
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
        OnCllision(box, bin_kuai, {
            width = function()
              -- box.pos_x = bin_kuai.pos_x + (box.pos_x > bin_kuai.pos_x  and 8 or -8)
              -- box.can_move = false
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
        OnCllision(box, v, {
          width = function()
              box.vecter.x = v.vecter.x
              -- box.can_move = false
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
