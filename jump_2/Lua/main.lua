-->main-0
player_states = {
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
			player.vecter.x = player.vecter.x > 0 and player_max_v or (-1*player_max_v)
		end
	},
	states_y = {},
}

--------------控制器----------------
controller = {
	up = function()
		player.vecter.y -= 1
        direction_flag.y = "up"
        can_jump += 1
	end,
	down = function()
		-- player.destroy()
	end,
	left = function()
		-- change_animation(player, "go")
        player_state_x_flag = "fast_go_left"
		if player.vecter.x <= -player_max_v then
			player_state_x_flag = "fast_go_stay"
		end
	end,
	right = function()
		player_state_x_flag = "fast_go_right"
		if player.vecter.x >= player_max_v then
			player_state_x_flag = "fast_go_stay"
		end
	end,
}
---------------------------------------

function _init()
  cls()
  direction_flag = {
      x,
      y,
  } --方向标签
  game_state_flag = "play"--游戏状态标签
  gravity = 0.05-- 重力
  update_state_flag = "play"
  draw_state_flage = "play"
  can_jump = 2
  player = {}
  game_state_flag = "play"
  player_state_x_flag = "nomal"
	player_acceleration = 0.1
	player_max_v = 2

  player = init_spr("player", 1, 50, 50, 1, 1, true)

	text_obj = init_spr("text_obj", 3, 80, 50, 2, 1, true)

  init_animation(player, 1, 3, 10, "nomal", true)
  init_animation(player, 4, 6, 10, "go", true)

	test = 0
	test_trigger_enter = OnTrigger_enter(player, text_obj, function()
		test = 1
	end)
	test_trigger_exit = OnTrigger_exit(player, text_obj, function()
		test = 0
	end)
	test_trigger_enter = OnTrigger_enter(player, text_obj, function()
		test = 1
	end)
	test_trigger_stay = OnTrigger_stay(player, text_obj, function()
		print("stay==")
	end)
  can_jump = 2
	snow = init_snow()
end

------------游戏状态机-----------------
game_states = {
  ----------update状态机--------------
	update_states = {
    play_update = function()
      if (btnp (⬆️) and can_jump < 2) controller.up()
      if (btnp (⬇️)) controller.down()
      if (btn (⬅️) and direction_flag ~= "right") controller.left()
      if (btn (➡️) and direction_flag ~= "right") controller.right()

      player_states.states_x[player_state_x_flag]()
	  -- player_states.states_y[player_state_y_flag]()

        for k, v in pairs(object_table) do
	        v.vecter.y = v.vecter.y + (v.is_physic and gravity or 0)
	        hit(v, 2, "height", function()
	          v.vecter.y = 0
	          can_jump = 0
	        end)
	      	hit(v, 2, "width", function()
	          v.vecter.x = 0
	        end)
	        v.pos_x = v.pos_x + v.vecter.x
	        v.pos_y = v.pos_y + v.vecter.y
	      end
      update_animation()
	  if  abs(player.vecter.x) < player_acceleration then
		  player_state_x_flag = "nomal"
	  else
		  player_state_x_flag = "fast_back"
	  end
    snow.update()
    end,

    game_over_update = function()

    end,
  },
  ---------------------------------

  -----------draw状态机-------------
  draw_states = {
		play_draw = function()
      map(0,0)
      print(test)

      for k, v in pairs(object_table) do
  			spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
      end
			Update_Trigger()
			snow.draw()
    end,
    game_over_draw = function()
      -- map(16, 0)
    end,
  },
    -------------------------------
}
-----------------------------------
