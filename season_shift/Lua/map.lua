-->map-3
function get_map_flage(m_x, m_y)
  return fget(mget(m_x/8+map_location.x,m_y/8+map_location.y))
end

-- function map_hit(obj)
--     local map_hit_trg = {
--         hit_3 = function(x, y)
--             mset(x, y, 0)
--         end,
--         hit_5 = function(x, y)
--
--         end
--     }
--     local map_hit_cls = {
--         hit_2 = function(x, y)
--
--         end,
--         hit_4 = function(x, y)
--
--         end
--     }
--
--     local function update_cls()
--         local cllision_flage
--
--         if map_hit_cls["hit_" .. cllision_flage] then map_hit_cls["hit_" .. cllision_flage]() end
--     end
--     local trigger_flage
--
--     local function update_trg()
--         local x1 = obj.pos_x
--         local w1 = obj.width * 8
--         local y1 = obj.pos_y
--         local h1 = obj.height * 8
--         for i = x1, (x1 + w1 - 1), (w1 - 1) do
--             for j = y1, (y1 + h1 - 1), (h1 - 1) do
--                 local m_x, m_y = i / 8, j / 8
--                 trigger_flage = fget(mget(m_x+map_location.x, m_y+map_location.y))
--                 if trigger_flage ~= 0 and trigger_flage ~= nil then
--                     if map_hit_trg["hit_" .. trigger_flage] then
--                         map_hit_trg["hit_" .. trigger_flage](m_x, m_y)
--                     end
--                         return
--                     end
--                 end
--             end
--         end
--     return{
--         update_trg = update_trg,
--         update_cls = update_cls,
--     }
-- end
function map_trigger(obj, flag, direction)
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

    if get_map_flage(x1, y1) == flag or get_map_flage(x2, y2) == flag
        or get_map_flage(x1, y2) == flag or get_map_flage(x2, y1) == flag then
            return true
    end
    return false
end

function map_trigger_enter(obj, map_flag, enter_func, direction)
    local entered = false
    local is_trigger = false
    local function trigger_enter ()
        is_trigger = map_trigger(obj, map_flag, direction)
        if not entered and is_trigger then
            enter_func()
            entered = true
        end
        if entered and not is_trigger then
            entered = false
        end
    end

    return trigger_enter
end

function map_trigger_stay(obj, map_flag, stay_func, direction)
    local function trigger_stay()
        if map_trigger(obj, map_flag, direction) then
            stay_func()
        end
    end

    return trigger_stay
end

function map_trigger_exit(obj, map_flag, exit_func, direction)
    local entered = false
    local is_trigger = false
    local function trigger_exit()
        is_trigger = map_trigger(obj, map_flag, direction)
        if not entered and is_trigger then
            entered = true
        end
        if entered and not is_trigger then
            exit_func()
            entered = false
        end
    end

    return trigger_exit
end
