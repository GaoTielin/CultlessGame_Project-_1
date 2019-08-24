pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--------------------�▥个�⬆️�第�█个代�▒�∧♥件�♥😐-------------------
function _init()
  cls()
  -----------------------------�⬅️�…-------------------------------
  --todo:--�☉�建对象---(对象�…♪, 精�▒��∧�◆�, �☉�建�░�♪置_x, �☉�建�░�♪置_y, 精�▒�宽度, 精�▒��▤度, �▤��…��✽��웃�웃��…●�░�☉▥)
  player = init_spr("player", 1, 50, 50, 1, 1, true)
  --todo:--�☉�建�⌂��⬆️�第�█个---(对象, 第�█帧精�▒��∧�◆�, �█�…🅾️�█帧精�▒��∧�◆�, �⌂��⬆️��…♪称, �▤��…�循�🅾️�)
  init_animation(player, 1, 3, 10, "nomal", false)
  --todo:--�☉�建�⌂��⬆️�第�😐个---(对象, 第�█帧精�▒��∧�◆�, �█�…🅾️�█帧精�▒��∧�◆�, �⌂��⬆️��…♪称, �▤��…�循�🅾️�)
  init_animation(player, 4, 6, 10, "go", true)
  ----------------------------------------------------------------
end

function _update()
  ---------------�♥😐面�♪�⬆️�管------------------
  game_states.update_states["play_update"]()
  ------------------------------------------

  ------------------------举�⬅️------------------------
  -----------�⌂��⬆️��▤认�★��⬆️��░�▤�第�█个�☉�建�░�⌂��⬆️�------------
  --todo:--�☉♥�♪��⌂��⬆️�----(�⌂��⬆️��웃█在�░对象�😐欲�☉♥�♪��░�⌂��⬆️��…♪称)
  if (btnp(l)) change_animation(player, "go")

end

function _draw()
  cls()
  ---------------�♥😐面�♪�⬆️�管------------------
  game_states.draw_states["play_draw"]()
  ------------------------------------------
end

-->8
--------------------�▥个�⬆️�第�😐个代�▒�∧♥件�♥😐-------------------
--------------------�▥�♥😐�░�⬇️��♪�⬆️�管--------------------------

object_table = {}

----------------实�⬅️�😐∧对象---------------
--sp(图�웃♥索�ˇ)--pos_x,pos_y(实�⬅️�😐∧�…�♥)--width,height(图�웃♥�▤度�😐宽度)--
function init_spr(name, sp, pos_x, pos_y, width, height, is_physic, v_x, v_y)
  if not v_x then v_x = 0 end
  if not v_y then v_y = 0 end
  local animation_table = {}
  local animation
  local spr_obj = {sp = sp, pos_x = pos_x, pos_y = pos_y, height = height, width = width,
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

--------------地形碰�★�-------------------
--sprit_flag: palyer = 1, map = 2
x = 0
function hit(sprit, hit_spr_flag, hit_side, hit_func)
	local next_x = sprit.pos_x + sprit.vecter.x
	local next_y = sprit.pos_y + sprit.vecter.y
	local w = sprit.width*8 -1
	local h = sprit.height*8 -1
	local next_last_x = next_x + w
	local next_last_y = next_y + h
  x = 0

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


----------------------�☉�建�⌂��⬆️�-------------------
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

--------------�☉♥�♪��⌂��⬆️�-------------
function change_animation(spr_obj, ani_flag)
	spr_obj.animation = spr_obj.animation_table[ani_flag]
end

--------------更�∧��⌂��⬆️�--------------
function update_animation()
	for i,v in pairs(object_table) do
		v.animation()
	end
end

game_states = {
  ----------update�⌂��█▒机--------------
	update_states = {
    play_update = function()
      update_animation()
    end,

    game_over_update = function()

    end,
  },
  ---------------------------------
  draw_states = {
		play_draw = function()
      map(0,0)
      print(x)
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

__gfx__
0000000044444444888888885555555599999999ddddddddeeeeeeee777b77770000000000000000000000000000000000000000000000000000000000000000
0000000044444444888888885555555599999999ddddddddeeaeeeee777b77b70000000000000000000000000000000000000000000000000000000000000000
007007004444444488888888555555559999999999d99d9deeaeeaee77bb77bb0000000000000000000000000000000000000000000000000000000000000000
0007700044444444888888885555555599999999d9999d9deeaaaaaebb7777bb0000000000000000000000000000000000000000000000000000000000000000
0007700044444444888888885555555599999999dddd9d9deeeeaeae77b77bb70000000000000000000000000000000000000000000000000000000000000000
0070070044444444888888885555555599999999ddd99d9deeeaaeae77bbbb770000000000000000000000000000000000000000000000000000000000000000
0000000044444444888888885555555599999999ddd9999deeaaeaee777777770000000000000000000000000000000000000000000000000000000000000000
0000000044444444888888885555555599999999ddddddddeeeaaaee777777770000000000000000000000000000000000000000000000000000000000000000
