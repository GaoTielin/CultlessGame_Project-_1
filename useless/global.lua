
function OnTrigger_exit(sprit_1, sprit_2, exit_func, trigger_name)
    local entered = false
    local is_trigger = false
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

    local idx = #Trigger_table + 1
    add(Trigger_table, trigger_exit)
    sprit_1.destroy_trigger_exit = function()
      Trigger_table[idx] = nil
    end

    sprit_2.destroy_trigger_exit = function()
      Trigger_table[idx] = nil
    end

    return trigger_exit
end
