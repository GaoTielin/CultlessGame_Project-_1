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
