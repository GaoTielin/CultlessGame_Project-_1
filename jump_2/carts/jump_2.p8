pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
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

--------------ÔøΩ‚àßÔøΩÔøΩ‚Ä¶‚û°Ô∏è----------------
controller = {
	up = function()
		player.vecter.y -= 1
        direction_flag.y = "up"
        can_jump += 1
	end,
	down = function()
		-- player.destroy()
	 	player, text_obj = exchange_obj(player, text_obj)
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
  direction_x = 0 --ÁßªÂ‚åÇ®Ë∑ùÁ¶ª_x
  direction_y = 0--ÁßªÂ‚åÇ®Ë∑ùÁ¶ª_y
  direction_flag = {
      x,
      y,
  } --Ê‚àßπÂ‚Ä¶‚û°Ô∏èÊ†‚ô•Á≠æ
  game_state_flag = "play"--Ê∏∏Ê‚òâ‚óÜÁ‚åÇ∂Ê‚ñà‚ñíÊ†‚ô•Á≠æ
  gravity = 0.05-- È‚ô•‚ô™Â‚åÇõ
  update_state_flag = "play"
  draw_state_flage = "play"
  can_jump = 2
  player = {}
  game_state_flag = "play"
  player_state_x_flag = "nomal"
	player_acceleration = 0.1
	player_max_v = 2

  player = init_spr("player", 1, 50, 50, 1, 1, true)

	text_obj = init_spr("text_obj", 3, 80, 50, 1, 1, true)
	text_name = player.name

  init_animation(player, 1, 3, 10, "nomal", true)
  init_animation(player, 4, 6, 10, "go", true)
  -- direction_flag.x = "nomal"
  -- direction_flag.y = "nomal"
  can_jump = 2
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

      for i,v in pairs(object_table) do
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
      -- direction_flag.x = "nomal"
      -- direction_flag.y = "nomal"
    end,

    game_over_update = function()

    end,
  },
  ---------------------------------

  -----------drawÁ‚åÇ∂Ê‚ñà‚ñíÊú∫-------------
  draw_states = {
	play_draw = function()
      map(0,0)
      -- print(player.vecter.x)
	  	print(player.name)
			print(object_table.player.name)
      for i,v in pairs(object_table) do
  			spr(v.sp, v.pos_x, v.pos_y, v.width, v.height)
      end
    end,
    game_over_draw = function()
      -- map(16, 0)
    end,
  },
    -------------------------------
}
-----------------------------------

-->8
object_table = {}
---------------ËÆ°Ê‚ùé∂Â‚ñ•®-------------------
function timer(time)
	local up_date = 0
	return function()
		print(time)
		if up_date >= 30 * time then
			up_date = 0
		end
			up_date += 1
		if up_date >= 30 * time then
			return true
		else
			return false
		end
	end
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

---------------Áõ‚òÖ‰Ω‚ßóÁ¢∞Ê‚òÖûÔº‚òâÊú™ÂÆüòêÊ‚òâ‚Ä¶ÔºÏõÉ-----------------
-- function ontrigger()
--
-- function oncllision(sprit_1, sprit_2)
-- 	local distance_x = abs(sprit_1.pos_x - sprit_2.pos_x)
-- 	local distance_y = abs(sprit_1.pos_y - sprit_2.pos_y)
-- 	local hit_distance_x = sprit_1.width + sprit_2.width
-- 	local hit_distance_y = sprit_1.height + sprit_2.height
-- 	if(distance_x <= hit_distance_x and distance_y <= hit_distance_y) then
-- 		return true
-- 	end
-- 	return false
-- end
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
	-- local mid_obj
	-- local mid_name
	-- mid_obj = obj_1
	-- -- mid_name = obj_1.name
	-- -- object_table[obj_1.name] = object_table[obj_2.name]
	-- -- object_table[obj_2.name] = object_table[mid_name]
	-- obj_1 = obj_2
	-- obj_2 = mid_obj
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

__gfx__
0000000088888888dddddddd55555555cccccc0000000bb0000000ee000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555c0000cc000bbbbb000ee00ee000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888888dddddddd555555550000ccc00bbbb0bb0eeee0ee000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888dddddddd5555555500ccccc00bbbbbb00eeee0ee000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888dddddddd555555550ccc00c00bbbbbb00000e00e000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888888dddddddd55555555ccccccc00bbbbbb0000eeeee000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555000000c000bbbbb00000ee00000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888dddddddd55555555000000000000bb000000ee00000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
