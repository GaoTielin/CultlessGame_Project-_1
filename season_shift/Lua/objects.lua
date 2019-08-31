-- objects
function init_chest ()
    local c = init_spr("chest", 18, 10, 48, 1, 1, true, 0, 0)
     c.pinecone = 0
     c.draw = function ()
         print(c.pinecone..'/'..10, c.pos_x-4, c.pos_y-6, 4)
     end
     return c
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
            spr(142, ui_x - 6 * i, 2)
        else
            spr(143, ui_x - 6 * i, 2)
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

      game_level = game_level + 1
      change_level(game_level)
    end
    if  player.pos_x + 8 <= camera_location.x then
      game_level = game_level - 1
      -- printh("game_level- = " .. game_level, "dri")
      change_level(game_level)
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
