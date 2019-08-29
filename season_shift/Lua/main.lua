-->main-0
--------------控制器----------------
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
  } --方向标签
  game_state_flag = "play"--游戏状态标签
  gravity = 0.4-- 重力
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

  -- OnCllision(player, text_obj)

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

------------游戏状态机-----------------
game_states = {
----------update状态机--------------
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

      Update_Cllision()
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

  -----------draw状态机-------------
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
      Update_Trigger()
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
