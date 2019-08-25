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
			player.vecter.x = player.vecter.x > 0 and player_max_v or (-1*player_max_v)
		end
	},
	states_y = {},
}

--------------ÊüÖæÔ∏èßÂ‚òâ∂Â‚ñ•®----------------
controller = {
	up = function()
		player.vecter.y -= 3
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

  player = init_spr("player", 1, 50, 50, 1, 1, true)

	text_obj = init_spr("text_obj", 3, 80, 50, 2, 1, true)

  init_animation(player, 1, 3, 10, "nomal", true)
  init_animation(player, 4, 6, 10, "go", true)

	oncllision(player, text_obj)

  can_jump = 2
	snow = init_snow()
end

------------Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-----------------
game_states = {
  ----------updateÁ‚åÇ∂Ê‚ñà‚ñíÊú∫--------------
	update_states = {
    play_update = function()
      if (btnp (‚¨ÜÔ∏è) and can_jump < 2) controller.up()
      if (btnp (‚¨áÔ∏è)) controller.down()
      if (btn (‚¨ÖÔ∏è) and direction_flag ~= "right") controller.left()
      if (btn (‚û°Ô∏è) and direction_flag ~= "right") controller.right()

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
				update_cllision()
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

  -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------
  draw_states = {
		play_draw = function()
      map(0,0)

      for k, v in pairs(object_table) do
  			spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
      end
			update_trigger()

			snow.draw()
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
  local spr_obj = {name = name, sp = sp, pos_x = pos_x, pos_y = pos_y, height = height, width = width,
    vecter = {x = v_x, y = v_y},
    is_physic = is_physic,
	animation_table = animation_table,
	animation = animation,
	destroy = function()
		object_table[name] = nil
	end,
  }

  object_table[name] = spr_obj
	return spr_obj
end
----------------------------------------

trigger_table = {}

function update_trigger()
	for _,v in pairs(trigger_table) do
		v()
	end
end

local function trigger(sprit_1, sprit_2)
	local hit = false
	local x1 = sprit_1.pos_x
	local x2 = sprit_2.pos_x
	local w1 = sprit_1.width*8
	local w2 = sprit_2.width*8
	local y1 = sprit_1.pos_y
	local y2 = sprit_2.pos_y
	local h1 = sprit_1.height*8
	local h2 = sprit_2.height*8
	local xd=abs((x1+(w1/2))-(x2+(w2/2)))
  local xs=w1*0.5+w2*0.5
  local yd=abs((y1+(h1/2))-(y2+(h2/2)))
  local ys=h1/2+h2/2
  if xd<xs and
     yd<ys then
    hit=true
  end
  return hit
end
---------------Áõ‚òÖ‰Ω‚ßóÁ¢∞Ê‚òÖûÔº‚òâÊú™ÂÆüòêÊ‚òâ‚Ä¶ÔºÏõÉ-----------------
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

cllision_table = {}
function update_cllision()
  for k,v in pairs(cllision_table) do
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

      local xd=abs((x1+(w1/2))-(x2+(w2/2)))
      local xs=w1*0.5+w2*0.5

      local cllision_height = false
      local y1 = sprit_1.pos_y
      local h1 = sprit_1.height * 8

      local y2 = sprit_2.pos_y
      local h2 = sprit_2.height * 8

      local yd=abs((y1+(h1/2))-(y2+(h2/2)))
      local ys=h1/2+h2/2

      print(xd)
      if xd<=xs and yd<ys then
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

      local yd=abs((y1+(h1/2))-(y2+(h2/2)))
      local ys=h1/2+h2/2

      local x1 = sprit_1.pos_x
      local w1 = sprit_1.width * 8

      local x2 = sprit_2.pos_x
      local w2 = sprit_2.width * 8

      local xd=abs((x1+(w1/2))-(x2+(w2/2)))
      local xs=w1*0.5+w2*0.5

      print(yd)
      if yd<=ys and xd<xs then
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
function hit(sprit, hit_spr_flag, hit_side, hit_func)
	local next_x = sprit.pos_x + sprit.vecter.x
	local next_y = sprit.pos_y + sprit.vecter.y
	local w = sprit.width*8 -1
	local h = sprit.height*8 -1
	local next_last_x = next_x + w
	local next_last_y = next_y + h

	local function h_func()
		for i = sprit.pos_x, sprit.pos_x + w, w do
			if (fget(mget(i/8, (next_y)/8)) == hit_spr_flag) or (fget(mget(i/8, (next_last_y)/8)) == hit_spr_flag) then
				return true
			end
		end
		return false
	end

	local function w_func()
		for i = sprit.pos_y, sprit.pos_y + h, h do
			if (fget(mget((next_x)/8, i/8)) == hit_spr_flag) or (fget(mget((next_last_x)/8, i/8)) == hit_spr_flag) then
        x = fget(mget((next_x)/8, i/8))
        return true
			end
		end
		return false
	end

	local get_func_tbl = {
		height = function()
			if h_func() then
				hit_func()
			end
		end,

		width = function()
			if w_func() then
				hit_func()
			end
		end,

		all = function()
			if h_func() and w_func()then
				hit_func()
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
		if next > 15 then next = flr(next/15) * 16 + height end
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
	for i,v in pairs(object_table) do
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
  if not hit_spr_flag then hit_spr_flag = 2 end
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

__gfx__
0000000088888888dddddddd55555555cccccccc00000bb0000000ee000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555cccccccc00bbbbb000ee00ee000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888888dddddddd55555555cccccccc0bbbb0bb0eeee0ee000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888dddddddd55555555cccccccc0bbbbbb00eeee0ee000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888dddddddd55555555cccccccc0bbbbbb00000e00e000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888888dddddddd55555555cccccccc0bbbbbb0000eeeee000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555cccccccc00bbbbb00000ee00000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555cccccccc0000bb000000ee00000000000000000000000000000000000000000000000000000000000000000000000000
000000009999999944444444777777778888880805555505ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
0000000099999999444444447777777000800088555555500ccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000009999999944444444077777770888888850055555cccccccc000000000000000000000000000000000000000000000000000000000000000000000000
0000000099999999444444447777777700088880555055550000cccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000999999994444444477700777008888805555555000cccccc000000000000000000000000000000000000000000000000000000000000000000000000
0000000099999999444444447077777788880888555555500cccc6cc000000000000000000000000000000000000000000000000000000000000000000000000
000000009999999944444444777777770888888805550555cccc0c0c000000000000000000000000000000000000000000000000000000000000000000000000
000000009999999944444444777770700088000000555555c0ccc000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
