pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
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

--------------ÊüÖæÔ∏èßÂ‚òâ∂Â‚ñ•®----------------
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
			change_animation(player, "run")
		end
    end,
}

function _init()
    cls()
    direction_flag = {
        x,
        y,
    } --Ê‚àßπÂ‚Ä¶‚û°Ô∏èÊ†‚ô•Á≠æ
    game_state_flag = "play"--Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊ†‚ô•Á≠æ
    gravity = 0.4-- È‚ô•‚ô™Â‚åÇõ
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
    init_animation(player, 192, 200, 10, "run", true)
    init_animation(player, 224, 236, 10, "jump", true)
    map_col = map_hit(player)

    -- oncllision(player, text_obj)

    snow = init_snow()
end

------------Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-----------------
game_states = {
    ----------updateÁ‚åÇ∂Ê‚ñà‚ñíÊú∫--------------
    update_states = {
        play_update = function()
			player.vecter.y = player.vecter.y + (player.is_physic and gravity or 0)
            if (btnp (‚¨ÜÔ∏è) and can_jump <= 2 and can_jump > 0) controller.up()
            if (btnp (‚¨áÔ∏è)) controller.down()
            if (btn (‚¨ÖÔ∏è) and direction_flag ~= "right") controller.left()
            if (btn (‚û°Ô∏è) and direction_flag ~= "right") controller.right()

            player_states.states_x[player_state_x_flag]()
            -- player_states.states_y[player_state_y_flag]()
            hit(player, 1, "height", function()
                can_jump = 2
				if player.state ~= "nomal" then
					if player.vecter.x == 0 then
						player.state = "nomal"
						change_animation(player, "nomal")
					else
						player.state = "run"
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
			update_cllision()
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

    -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------
    draw_states = {
        play_draw = function()
            map(0, 0)

            for v in all(object_table) do
                spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
            end
            update_trigger()
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
        destroy = function()
            object_table[obj_idx] = nil
        end,
    }

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
    local xs = w1 * 0.5 + w2 * 0.5
    local yd = abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
    local ys = h1 / 2 + h2 / 2
    if xd < xs and
    yd < ys then
        hit = true
    end
    return hit
end

function ontrigger_enter(sprit_1, sprit_2, enter_func, trigger_name)
    local entered = false
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

    if trigger_name then
        trigger_table[trigger_name] = trigger_enter
    else
        add(trigger_table, trigger_enter)
    end

    return trigger_enter
end

function ontrigger_stay(sprit_1, sprit_2, stay_func, trigger_name)
    local entered = false
    local function trigger_stay()
        if trigger(sprit_1, sprit_2) then
            stay_func()
        end
    end
    if trigger_name then
        trigger_table[trigger_name] = trigger_stay
    else
        add(trigger_table, trigger_stay)
    end

    return trigger_stay
end

function ontrigger_exit(sprit_1, sprit_2, exit_func, trigger_name)
    local entered = false
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
    if trigger_name then
        trigger_table[trigger_name] = trigger_exit
    else
        add(trigger_table, trigger_exit)
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

    local function h_func()
        for i = sprit.pos_x, sprit.pos_x + w, w do
            if (fget(mget(i / 8, (next_y) / 8)) == hit_spr_flag) or (fget(mget(i / 8, (next_last_y) / 8)) == hit_spr_flag) then
                return true
            end
        end
        return false
    end

    local function w_func()
        for i = sprit.pos_y, sprit.pos_y + h, h do
            if (fget(mget((next_x) / 8, i / 8)) == hit_spr_flag) or (fget(mget((next_last_x) / 8, i / 8)) == hit_spr_flag) then
                x = fget(mget((next_x) / 8, i / 8))
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

function _update()
    update_state_flag = game_state_flag .. "_update"
    game_states.update_states[update_state_flag]()
end

function _draw()
    cls()
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
  for i=1, num do
      local s = {
          n = i,
          landed=false,
          x=rnd(128),
          y=rnd(128),
          speed=rnd(2)+speed
      }
      add(snows, s)
  end
  local timer = newtimer()

  local function is_land(sp)
    if fget(mget(sp.x/8, (sp.y+speed)/8)) == hit_spr_flag then
      sp.y = flr((sp.y+speed)/8)*8 - 1
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
    timer.update()
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
function map_hit(obj)
	local map_hit_trg = {
		hit_3 = function(x, y)
			mset(x, y, 0)
		end,
		hit_5 = function(x, y)

		end
	}
	local map_hit_cls = {
		hit_2 = function(x, y)

		end,
		hit_4 = function(x, y)

		end
	}

	local function update_cls()
		local cllision_flage

		if map_hit_cls["hit_" .. cllision_flage] then	map_hit_cls["hit_" .. cllision_flage]() end
	end
	local trigger_flage

	local function update_trg()
		local x1 = obj.pos_x
		local w1 = obj.width*8
		local y1 = obj.pos_y
		local h1 = obj.height*8
		for i = x1, (x1 + w1 - 1), (w1-1) do
			for j = y1, (y1 + h1 -1), (h1-1) do
				local m_x, m_y = i/8, j/8
				trigger_flage = fget(mget(m_x, m_y))
				if trigger_flage ~= 0 and trigger_flage ~= nil then
					if map_hit_trg["hit_" .. trigger_flage] then
						map_hit_trg["hit_" .. trigger_flage](m_x, m_y) end
					return
				end
			end
		end
	end
	return{
		update_trg = update_trg,
		update_cls = update_cls,
	}
end
__gfx__
0000000033333333ffff3fffffff3fffffffffff00000000ffffffffffffffff7000000000000000000000000000000000000000000000000000000000770000
0000000044444444ffff3ffffff33ffffff88fff000000007fff7fff7fff7fff0770000000000000000000000000000000000000000000000000000577500000
0070070044445544fff3333fffff3fffff8878ff00000000c7f7c7f7c7f7c7f70077700000000000000000000000000000000000000000000000007775000000
0007700044444444ffff3fffffffbffff878888f00000000cc7ccc7ccc7ccc7c0005777000000000000000000000000000000000000000000077770750000000
0007700045544444ffb33fffffffffff8888878800000000cccc7ccccccccccc0000577670000000000000000000000000000000000000076665577500000000
0070070044444444ffff3bfffffffffffff77fff00000000cccccccccccccc7c0000007766700000000000000000000000000000000005666657777000000000
0000000044444554ffff3ffffffffffffff77fff00000000ccccccccc7cccccc0000000777676600000000000000070000000066605666666777770000000000
0000000044444444fff33f3ffffffffffff77fff00000000ccccccc7cccccccc0000000076766656500000000000000000060065556166667777707550000000
000000003333333366666666ffffffffffffffffffffffffcccccccccccccccc0000000005656555650007070700700006655551115566676677775500000000
00000000333533336dddddd6ffffffffffffffffffffffffcc7ccccccccccccc0000000000765655556006076677766666055511551666766766750000000000
00000000535453536d6dd6d6ffffffffffffffffffffffffcccccccccccccccc0000000000515555555106766766775566655111115166666670000000000000
00000000454453556ddd6dd6ffffffffffffffffff9f9fffcccccccccccccccc0000000000111111115107755667755551151111551666760000000000000000
00000000444445446dd6ddd6ff2f2fffff3ffffffff7ffffcccccccccccccccc0000000000015111110056556667755555199116666660000000000000000000
00000000444444446d6dd6d6fff9fffffff333ffff939fffccccc7cccccccccc0000000000000100000005550676555191190000000000000000000000000000
00000000454444446dddddd6ff232ffffff3f3fffff3ffffcccccccccccccccc00000000000000000000055a0051111119900900000000000000000000000000
000000004444445466666666fff3fffffff3fffffff3ffffcccccccccccccccc000000000000000000000aa09900901119999000000000000000000000000000
0000000044444444ffffffff0000000000000000000000000000000000000000000000000000000000000a000099000000900000000000000000000000000000
0000000044444444ffffffff00000000000000000000000000000000000000000000000000000000000000000009000000900000000000000000000000000000
0000000044444544ffffffff00000000000000000000000000000000000000000000000000000000000000000090000000990000000000000000000000000000
0000000044444444ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044444444fff8ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000045444444ff878fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044444444f88888ff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044444444ff777fff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000070000000066605666666600000000000000
00000000ffffffffffffffff00000000000000000000000000000000000000000000000000066656500000000000000000060065556166666666770000000000
00000000ffffffff4fffffff00000000000000000000000000000000000000000000000077666555650007070700700006655551115566676616167777000000
00000000fffffffff44f44ff00000000000000000000000000000000000000000000007766165655556006076677766666055511551666766706111667700000
00000000fffffffffff4444f00000000000000000000000000000000000000000000776661515555555106766766775566655111115166606670000066677000
00000000fffffffffff44fff00000000000000000000000000000000000000000077600000111111115107755667755551151111551666760000000000000077
00000000ffffffffff4fffff00000000000000000000000000000000000000000000000000015111110056556667755555199116666660000000000000000000
00000000ffffffffffffffff00000000000000000000000000000000000000000000000000000100000005550676555191190000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000055a0051111119900900000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000aa09900901119999000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000a000099000000900000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000009000000900000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000090000000090000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffff99ffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffff9999999999fffffffffffffffff99ffffffff0000000000000000000005000000000000000000000000000000000000000000
ffffffffffffffffffffffff9999999999999999ffffffffffffff99ffffffff0000000000000000000005550000000000000000000000000000000000000000
fffffffffffffffffffff9999999999999999999fffffffffff99999ffffffff0000000000000000000655550000000000000006665500000000000000000000
ffffffffffffffffffff999999999999999f99999ffffffffff99999ffffffff0000000000000000000655550700000700006006555766600000000000000000
fffffffffffffffffff99999999999999999999999ffffffffffffffffffffff0000000000000000006565757007007000665555655677760000000000000000
ffffffffffffffffff999999999999999999999999ffffffffffffffffffffff0000000000000000065655657667776666605555165667770000000000000000
fffffffffffffffff999999f9999999999999999999fffffffffffffffffffff0000000000000000076765676676677556665555656576677000000000000000
fffffffffffffffff99999ff9999999999999999999fffffffffffffffffffff0000000000000000767655775566775555155555565667777000000000000000
ffffffffffffffff999999999999999999999999999fffffffffffffffffffff0000000000000007676760655666775555515151006576770000000000000000
fffffffffffffffff99999999999999999999999999fffffffffffffffffffff0000000000000007777750555067655515150000000667677000000000000000
fffffffffffffffff999999999999999999999999999ffffffffffff77ffffff000000000000077770700055a005115151510000000066777700000000000000
ffffffffff7fffffff99999999999999999999999999ffffffffffffffffffff0000000000777007000000aa0000090111110000000000770700000000000000
fffffffff77fffffff9999999999999999999999999fffffffffffffffffffff0000000070000000000000a00099900009110000000000077000000000000000
ffffffffffffffffff99999999999999f9999999999ffffff999ffffffffffff0000000000000000000000000904900999000000000000007700000000000000
fffffffffffffffff99999999949999ff9994999999ff9999999999fffffffff0000000000000000000000009009009090900000000000000700000000000000
fffffffffffffffff999999999449999999449999999999999999999ffffffff0000000000000000000000000040000490900000000000000070000000000000
ffffffffffffffffff9999999944449999444999999999999999999999ffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffff999999999944449444449999999949999999999999fffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffff999999999994444444449999999944499999999f999fffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffff999999999999944444449999999999444999999ff9999ffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffff9f9999999999999944444449999999999444999999999999ffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffff9999994999999999444444499999999994444999999999999fff0000000000000000000000000000000000000000000000000000000000000000
fffffffff9f99999944999999999944444499999999999444499999999999fff0000000000000000000000000000000000000000000000000000000000000000
fffffffff9999999944999999999944444444999999999444449999999999fff0000000000000000000000000000000000000000000000000000000000000000
ffffffff99999999944449999994444444444499994444444444499999999fff0000000000000000000000000000000000000000000000000000000000000000
fffffff9999999999444444944444444444444994444444444444444499999ff0000000000000000000000000000000000000000000000000000000000000000
fffffff9999999994444445444944444444444444944444444444444999999ff0000000000000000000000000000000000000000000000000000000000000000
ffffff99999999444544445444444444444d54444444454444444499999999ff0000000000000000000000000000000000000000000000000000000000000000
fffff999f9999444454445544444444444d554444444554444444999999999ff0000000000000000000000000000000000000000000000000000000000000000
fffff999999944444d544555444444444d555444444d554444449999999999ff0000000000000000000000000000000000000000000000000000000000000000
fffff9999999999444d5455544444444d5554444444d554444449999999f99ff0000000000000000000000000000000000000000000000000000000000000000
ffff999999999994444d55555444444d5555444444d5554444999999999999ff0000000000000000000000000000000000000000000000000000000000000000
fffff999999999944444dd555544455d555444444d5555444449999999999fff0000000000000000000000000000000000000000000000000000000000000000
fffff9999999999944444455555dd555555555ddd5555444444999999999ffff0000000000000000000000000000000000000000000000000000000000000000
ffffff9999999994449444d5555555555555555555555544444499999999ffff0000000000000000000000000000000000000000000000000000000000000000
ffffff99999994444444444d55555555555555555555555555444444999fffff0000000000000000000000000000000000000000000000000000000000000000
ffffff99f994444444444444d55555555555555555555555555444449fffffff0000000000000000000000000000000000000000000000000000000000000000
fffffff999444444444999999ddd55555555555555554444444444999fffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffff999999999999999999ffd555555555555554444999999999ffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffff99999999fffffd55555555555599999fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffd555555555ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffff555555555fffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffffffd55555555ffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffffff55555555fffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffd5555555ffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffffd5555555ffffff444444444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffffd55555555fffffff444454444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffffd555555555ffffffff444555444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffd555555555fffffffff444999444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffffd555555555ffffffffff444494444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd5555555555ffffffffff444444444ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd5555555555ffffffffffffff4ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffd555555555555ffffffffffff4ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
fffffffffffffffffffd555555555555555555fffffff4ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000097000
00000000009400000000000000000000000000000000000000000000000000000000094999400000000000000000000000000000000000000700007000999700
000000009949000000000499944999400000499994444000000000000000000000099494449990000000000000000000007600060000000007600670049999a0
00000499449000000049994449944000004994444999994400000444400000000049490000044900000000000000000000776067076000060776077000444400
00049944990000000494449994000000049449999400000000099999990000000494900000000044000000000000000000777077077600670777077004444470
004944994000000049499940000000000949994000000000004944444990000409490000000000000000000000000000007770770777007700770700054444a0
00949944000040009499400000000000949940000000000004949999949000049494000000000000000000000000000000077077007770770007666000144400
09494000009499004940000000004000494000000000000009490000994400409494000000000000000000000000000000097070000770770055c6c000014000
0490000009499990490009900944990094000000000000009490000000994490094940e000000000000000000000000005997666059976660995666000000000
09000999949977904900944994999990400999009900400049000000000099000094994000099900990040000000000055595c6c05595c6c0599500000009700
049094444997000004094994499777909094449944449900900000000000000000004494009444994444990000000000955956669559566609550000000999a0
00494999779999000094999977900000494999449999999040099900000000000000000049499944999999900000000099550000995000000099900000044490
00949997700000000049999700090000049999977997779009944490990040000000000004999997799777900000000009900000099900000000055700044490
00099997000000000009977000009900099977700900000094499949444499040000000009997770090000000000000000557000000557000000000000004400
00099770000000000009970000000000009700000090000049999994999999940000000000970000009000000000000000000000000000000000000000000000
00009999000000000000999000000000000990000009900004496667064444400000000000099000000990000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000999000000000000000000000000004499400000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000994444499000000000000000000000040049994000000000000000000000
00000000000000000000000000000000040000000000000000000000040000000094449999944490000999009900400000000000499490000000000000000000
00000000000000000000000004000000009944400000000000000009499000004449900000009944009444994494990000000000049949000000000000000000
49944499000000000000000949900000000099944000000000000994999900000000000000000000494999449949779000000000004994000000000000000000
00099944490000000000009499990000000000099440000000099449977900000000000000000000049999777997779000000000000449400000000000000000
00000099944000000099994997790000000000004994000009944999700000000000000000000000009777000094000000000000000004940009990000000000
00000000499400000944449970000000000000000499400009499770994000000000000000000000000999900009400000000000000000940094449000000000
00000000004940009499977904400000000000000044990094997000009940000000000000000000000004400000994000000000000000094949994900004000
00000000000494004999770099000000000000000000449949977000000000000000000000000000000000000000000000000000000000009499999499949900
00000000000049409999700000000000000000000000000099770000000000000000000000000000000000000000000000000000000000000999777944497790
00000000000000949977000000000000000000000000000009040000000000000000000000000000000000000000000000000000000000000099900779977790
00000000000000004900000000000000000000000000000009400000000000000000000000000000000000000000000000000000000000000049990000900000
00000000000000004900000000000000000000000000000090400000000000000000000000000000000000000000000000000000000000000000449900490000
00000000000000000499600000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000000000000049900
__gff__
0001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3131525354553257023102310202313131313131313131313131313102313102313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3261626364656667033102310302313131313131313131313132313102313103313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727374757677313102313103313131313131313131313131313102313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8081828384858687313102313112121231313131313131313131313102311212123131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9091929394959697313103313131313131313131313131313131313103313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31a1a2a3a4a5a631313131313115130431313131310431220431313131313131313131310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0422b2b3b4b5b631141531311111111111111111111111111111060706070607060706070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111122142121212121212121212121212121161716171617161716170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121212121212121212111112121212121212121212121212121212121212121212121210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
