-->main-0
--------------控制器----------------
controller = {
    up = function()
        player.vecter.y -= 3
        direction_flag.y = "up"
        can_jump -= 1
		if player.state ~= "jump" then
			player.state = "jump"
			change_animation(player, "jump")
            change_animation(tail, "jump")
		end
    end,
    down = function()
        player.new_ground = 1
    end,
    left = function()
        -- change_animation(player, "go")
        player_state_x_flag = "fast_go_left"
        if player.vecter.x <= -player_max_v then
            player_state_x_flag = "fast_go_stay"
        end
		if player.state ~= "run" and player.state ~= "jump" then
			player.state = "run"
			change_animation(player, "run")
            change_animation(tail, "run")
		end
    end,
    right = function()
        player_state_x_flag = "fast_go_right"
        if player.vecter.x >= player_max_v then
            player_state_x_flag = "fast_go_stay"
        end
		if player.state ~= "run" and player.state ~= "jump" then
			player.state = "run"
			change_animation(player, "run")
            change_animation(tail, "run")
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

    player = init_player()
    tail = init_tail()

    map_col = map_hit(player)

    -- OnCllision(player, text_obj)

    snow = init_snow()
    chest = init_chest()
    -- enemy = init_enemy()
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
            if (btnp (2) and can_jump <= 2 and can_jump > 0) controller.up()
            if (btn (3)) controller.down()
            if (btn (0) and direction_flag ~= "right") then
                player.flip_x = true
                controller.left()
            end
            if (btn (1) and direction_flag ~= "right") then
                player.flip_x = false
                controller.right()
            end

            player.player_states.states_x[player_state_x_flag]()
            -- player_states.states_y[player_state_y_flag]()
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
                player.new_ground = 2
				player.vecter.y = 0
			end, function()
				if player.state ~= "jump" then
					can_jump = 1
				end
			end)
			hit(player, 1, "width", function()
				player.vecter.x = 0
			end)
            hit(player, player.new_ground, "height", function()
                can_jump = 2
				player.vecter.y = 0
			end)
			hit(player, player.new_ground, "width", function()
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
            timer.update()
            tail.update()
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
            -- enemy.draw()
            global_pinecone.draw()
            draw_pinecone_ui()
            map_col.update_trg()
        end,
        game_over_draw = function()
            -- map(16, 0)
        end,
    },
    -------------------------------
}
-----------------------------------
