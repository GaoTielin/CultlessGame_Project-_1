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
        now = time()
        for name, timer in pairs(o.timers) do
            timer_type, timer_start, timeout, callback = timer[1], timer[2], timer[3], timer[4]
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
