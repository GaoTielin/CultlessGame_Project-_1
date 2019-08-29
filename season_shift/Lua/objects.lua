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
    hit(player, 1, "all", function()
      player.vecter.x = 0
    end)
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
