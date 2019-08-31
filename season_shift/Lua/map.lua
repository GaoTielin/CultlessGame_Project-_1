-->map-3
function get_map_flage(m_x, m_y)
  return fget(mget(m_x/8+map_location.x,m_y/8+map_location.y))
end

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
    elseif direction == 'all' then
        x1 = x
        y1 = y
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

function init_map_animation(map_ani_flag, update_time, max_sp, is_flip)
    local time = 0
    max_sp = max_sp*(is_flip and -1 or 1)
    local map_ani_table = {}
    local timer = 1
    for x=0, 127 do
        for y=0, 31 do
            if fget((mget(x, y)), map_ani_flag) then
                local one = {
                    x = x,
                    y = y,
                    sp = mget(x, y),
                }
                add(map_ani_table, one)
            end
        end
    end
    local function update()
        if timer <= update_time then
            timer = timer + 1
            return
        end
        for s in all(map_ani_table) do
            -- s.sp = s.sp + (time == 0 and 1 or -1)
            mset(s.x, s.y, s.sp + time)
        end
        time = time + (is_flip and -1 or 1)
        timer = 1
        if time == max_sp then
            time = 0
        end
    end
    return {
        update = update,
    }
end
