-->map-3
function get_map_flage(m_x, m_y)
    return fget(mget(m_x/8,m_y/8))
end

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

        if map_hit_cls["hit_" .. cllision_flage] then map_hit_cls["hit_" .. cllision_flage]() end
    end
    local trigger_flage

    local function update_trg()
        local x1 = obj.pos_x
        local w1 = obj.width * 8
        local y1 = obj.pos_y
        local h1 = obj.height * 8
        for i = x1, (x1 + w1 - 1), (w1 - 1) do
            for j = y1, (y1 + h1 - 1), (h1 - 1) do
                local m_x, m_y = i / 8, j / 8
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

function collide_map (obj, direction, flag, handler_func)
    local x = obj.pos_x
    local y = obj.pos_y
    local w = obj.width * 8
    local h = obj.height * 8
    local x1, x2, y1, y2 = 0, 0, 0, 0
    if direction == 'left' then
        x1 = x - 1
        y1 = y
        x2 = x
        y2 = y + h - 1
    elseif direction == 'right' then
        x1 = x + w
        y1 = y
        x2 = x + w + 1
        y2 = y + h - 1
    elseif direction == 'up' then
        x1 = x + 1
        y1 = y - 1
        x2 = x + w - 1
        y2 = y
    elseif direction == 'down' then
        x1 = x
        y1 = y + h
        x2 = x + w
        y2 = y + h
    end

    x1 /= 8
    y1 /= 8
    x2 /= 8
    y2 /= 8
    if fget(mget(x1, y1), flag) or fget(mget(x2, y2), flag)
        or fget(mget(x1, y2), flag) or fget(mget(x2, y1), flag) then
            handler_func()
    end
end
