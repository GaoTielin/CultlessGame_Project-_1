object_table = {}
---------------计时器-------------------
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

----------------实例化对象---------------
--sp(图�웃♥索�ˇ)--pos_x,pos_y(实�⬅️�😐∧�…�♥)--width,height(图�웃♥�▤度�😐宽度)--
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

Trigger_table = {}

function Update_Trigger()
	for _,v in pairs(Trigger_table) do
		v()
	end
end

local function Trigger(sprit_1, sprit_2)
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
---------------盒体碰撞（未完成）-----------------
function OnTrigger_enter(sprit_1, sprit_2, enter_func, trigger_name)
	local entered = false
	local function trigger_enter ()
		is_trigger = Trigger(sprit_1, sprit_2)
		if not entered and is_trigger then
			enter_func()
			entered = true
		end
		if entered and not is_trigger then
			entered = false
		end
	end

	if trigger_name then
		Trigger_table[trigger_name] = trigger_enter
	else
		add(Trigger_table, trigger_enter)
	end

	return trigger_enter
end

function OnTrigger_stay(sprit_1, sprit_2, stay_func, trigger_name)
	local entered = false
	local function trigger_stay()
		if Trigger(sprit_1, sprit_2) then
			stay_func()
		end
	end
	if trigger_name then
		Trigger_table[trigger_name] = trigger_stay
	else
		add(Trigger_table, trigger_stay)
	end

	return trigger_stay
end

function OnTrigger_exit(sprit_1, sprit_2, exit_func, trigger_name)
	local entered = false
	local function trigger_exit()
		is_trigger = Trigger(sprit_1, sprit_2)
		if not entered and is_trigger then
			entered = true
		end
		if entered and not is_trigger then
			exit_func()
			entered = false
		end
	end
	if trigger_name then
		Trigger_table[trigger_name] = trigger_exit
	else
		add(Trigger_table, trigger_exit)
	end

	return trigger_exit
end

function OnCllision(sprit_1, sprit_2)
	local distance_x = abs(sprit_1.pos_x - sprit_2.pos_x)
	local distance_y = abs(sprit_1.pos_y - sprit_2.pos_y)
	local hit_distance_x = sprit_1.width + sprit_2.width
	local hit_distance_y = sprit_1.height + sprit_2.height
	if(distance_x <= hit_distance_x and distance_y <= hit_distance_y) then
		return true
	end
	return false
end
---------------------------------------

--------------地形碰撞-------------------
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


----------------------创建动画-------------------
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

-------------切换动画----------------
function change_animation(spr_obj, ani_flag)
	spr_obj.animation = spr_obj.animation_table[ani_flag]
end

-----------动画播放---------------
function update_animation()
	for i,v in pairs(object_table) do
		if v.animation then
			v.animation()
		end
	end
end

------------切换对象---------------
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
