-->main-0
--------------控制器----------------
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
  fps = 10,
  over_func = function()
  end,
}
controller = {
  jump = function ()
    if player.state == "climb" then
      player.climb_jump()
      sfx(10, 3)
    elseif player.can_jump <= player.max_jump and player.can_jump > 0 then
      player.vecter.y = cfg_jump_speed * -1
      direction_flag.y = "up"
      player.can_jump =  player.can_jump - 1
      if player.state ~= "jump" then
        player.state = "jump"
        change_animation(player, "jump")
        change_animation(tail, "jump")
      end
      sfx(11, 3)
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
        player.pos_y += cfg_climb_speed
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
       player.pos_y += cfg_climb_speed
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
       player.pos_y += cfg_climb_speed
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
  -- game_season = "summer"

  cfg_levels = autumn_config -- 秋天开始
  -- cfg_levels = winter_config -- 冬天开始
  -- cfg_levels = spring_config --春天开始
  -- cfg_levels = summer_config --夏天开始

  game_level = 1

  direction_flag = {
    x,
    y,
  } --方向标签
  cloud = init_cloud()
  moon_map = init_moon()
  game_state_flag = "play"--游戏状态标签
  gravity = cfg_gravity-- 重力
  update_state_flag = "play"
  draw_state_flage = "play"
  player_state_x_flag = "nomal"
  player_acceleration_fast = cfg_player_acceleration_fast--加速度
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
    if game_level == 4 or game_level == 9 or game_level == 12 then
        -- print("pass ❎", player.pos_x-5, player.pos_y - 8, 1)
        spr(175, player.pos_x, player.pos_y - 8)
        -- print("❎", player.pos_x, player.pos_y - 6, 1)
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
      if game_level == 12 then
        --TODO:init_cg(cart, first_map, last_map, fps, function() season_shift("spring") end)
      end
      sfx(29, 3)
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
    -- print("❎", chest.pos_x+5, chest.pos_y - 8, 1)
    if btnp(5) then
      if player_pinecone ~= 0 then
        player_pinecone -= 1
        chest.pinecone += 1
        sfx(29, 3)
      end
    end
  end, 'chest_store')
  change_level(game_level)
  -- bin_kuai = init_spr("bin_kuai", 159, 240, 88, 1, 1, true)
  -- bin_kuai_2 = init_spr("bin_kuai", 159, 23*8, 88, 1, 1, true)
  -- box_1 = init_box(176, 72, bin_kuai_2)
  -- box_2 = init_box(224, 32, bin_kuai)

  music(14)
end

function _init()
  -- game_state_flag = "start"
  -- start_timer = 0
  -- load_level("start.p8")
  sfx(31)
  init_cg("start.p8", 0, 112, 10, function()
    load_level("season_shift.p8")
    init_game()
    game_state_flag = "play"
  end)
end

------------游戏状态机-----------------
game_states = {
----------update状态机--------------
update_states = {
  -- start_update = function()
  -- end,

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
        Update_Cllision()
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
                music(11)
            end)
            thief_event = false
        end
        cloud.update()
        tips.update()
        shake.update()
        sound_update()
    end,
    play_cg_update = function()
    end,
  },
  ---------------------------------

  -----------draw状态机-------------

  draw_states = {
    -- start_draw = function()
    --   if start_timer >= 80 then
    --     load_level("season_shift.p8")
    --     init_game()
    --     game_state_flag = "play"
    --   end
    --   start_timer += 1
    --   local x = flr(start_timer/10)*16
    --   map(x, 0)
    -- end,

    change_level_draw = function()
      nomal_draw()
    end,

    play_draw = function()
        nomal_draw()
    end,

    play_cg_draw = function()
      cg.timer += 1
      local x = cg.first_map + flr(cg.timer/cg.fps)*16
      local y = 0
      if x>= 128 then
        x = x - 128
        y = 16
      end
      map(x, y, camera_location.x, camera_location.y)

      if x >= cg.last_map then
        game_state_flag = "play"
        cg.over_func()
      end
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
    Update_Trigger()
    -- map_col.update_trg()
    -- camera(player.pos_x-64, 0)

end
