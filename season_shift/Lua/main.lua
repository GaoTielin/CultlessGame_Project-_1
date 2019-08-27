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
            player.vecter.x = player.vecter.x > 0 and player_max_v or (-1 * player_max_v)
        end
    },
    states_y = {},
}

--------------控制器----------------
controller = {
    up = function()
        player.vecter.y -= 3
        direction_flag.y = "up"
        can_jump -= 1
		if player.state ~= "jump" then
			player.state = "jump"
			change_animation(player, "jump")
		end
    end,
    down = function()
    end,
    left = function()
        -- change_animation(player, "go")
        player_state_x_flag = "fast_go_left"
        if player.vecter.x <= -player_max_v then
            player_state_x_flag = "fast_go_stay"
        end
    		if player.state ~= "run" and player.state ~= "jump" then
    			player.state = "run"
          player.width = 4
    			change_animation(player, "run")
    		end
    end,
    right = function()
        player_state_x_flag = "fast_go_right"
        if player.vecter.x >= player_max_v then
            player_state_x_flag = "fast_go_stay"
        end
    		if player.state ~= "run" and player.state ~= "jump" then
    			player.state = "run"
          player.width = 4
    			change_animation(player, "run")
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
    player = {}
    game_state_flag = "play"
    player_state_x_flag = "nomal"
    player_acceleration = 0.1
    player_max_v = 2

    player = init_spr("player", 192, 50, 30, 2, 2, true)
	player.state = "nomal"

    -- text_obj = init_spr("text_obj", 3, 80, 30, 2, 1, true)

	init_animation(player, 192, 194, 10, "nomal", true)
    init_animation(player, 224, 236, 10, "run", true)
    init_animation(player, 224, 236, 10, "jump", true)
    map_col = map_hit(player)

    -- OnCllision(player, text_obj)

    snow = init_snow()
end

------------游戏状态机-----------------
game_states = {
    ----------update状态机--------------
    update_states = {
        play_update = function()
			player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
            if (btnp (⬆️) and can_jump <= 2 and can_jump > 0) controller.up()
            if (btnp (⬇️)) controller.down()
            if (btn (⬅️) and direction_flag ~= "right") controller.left()
            if (btn (➡️) and direction_flag ~= "right") controller.right()

            player_states.states_x[player_state_x_flag]()
            -- player_states.states_y[player_state_y_flag]()
            hit(player, 1, "height", function()
                can_jump = 2
        				if player.state ~= "nomal" then
        					if player.vecter.x == 0 then
                    player.width = 2
        						change_animation(player, "nomal")
                    player.state = "nomal"
        					else
        						player.state = "run"
                    player.width = 4
        						change_animation(player, "run")
        					end
        				end
            end)
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


			hit(player, 1, "height", function()
				player.vecter.y = 0
			end, function()
				if player.state ~= "jump" then
					can_jump = 1
				end
			end)
			hit(player, 1, "width", function()
				player.vecter.x = 0
			end)
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

        end,

        game_over_update = function()

        end,
    },
    ---------------------------------

    -----------draw状态机-------------
    draw_states = {
        play_draw = function()
            map(0, 0)

            for v in all(object_table) do
                spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
            end
            Update_Trigger()
			print(player.vecter.x)
            print(player.state)
            snow.draw()
            map_col.update_trg()
        end,
        game_over_draw = function()
            -- map(16, 0)
        end,
    },
    -------------------------------
}
-----------------------------------
