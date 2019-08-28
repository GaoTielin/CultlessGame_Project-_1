-- objects
function init_chest ()
    local c = init_spr("chest", 4, 10, 50, 1, 1, false, 0, 0)
    c.pinecone = 0
    c.draw = function ()
        print(c.pinecone..'/'..10, c.pos_x-4, c.pos_y-4)
    end
    return c
end

function init_catepiller ()
    local e = init_spr("catepiller", 22, 60, 48, 1, 1, true, 0, 0)
    local max_range = 16
    local flip_x = false
    e.update = function ()
        if not flip_x and e.pos_x > 60 + max_range then
            flip_x = true
        end
        if flip_x and e.pos_x < 60 - max_range then
            flip_x = false
        end
        if flip_x then
            e.pos_x -= 0.5
        else
            e.pos_x += 0.5
        end
    end
    e.draw = function ()
        spr(e.sp, e.pos_x, e.pos_y, 1, 1, flip_x)
    end
    return e
end

function init_global_pinecone ()
    local g = {
        pinecone_list = {}
    }
    g.draw = function ()
        for p in all(g.pinecone_list) do
            if p.is_dropped then
                -- hack way to let pinecone flcik
                if time() % 0.5 < 0.25 then
                    spr(p.sp, p.pos_x, p.pos_y)
                end
            else
                spr(p.sp, p.pos_x, p.pos_y)
            end
        end
    end
    return g
end

function draw_pinecone_ui()
    for i=1, max_pinecone_num do
        if i <= player_pinecone then
            spr(4, 80+6*i, 3)
        else
            spr(3, 80+6*i, 3)
        end
    end
end

function init_player()
    local player = init_spr("player", 192, 100, 10, 1, 1, true)
	player.state = "nomal"
    player.ground = 1
    player.new_ground = 2
    player.player_states = {
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
                player.vecter.x = player.vecter.x > 0 and player_max_v or (-1 * player_max_v)
            end
        },
        states_y = {},
    }

    init_animation(player, 192, 194, 10, "nomal", true)
    init_animation(player, 215, 218, 10, "run", true)
    init_animation(player, 199, 202, 10, "jump", true)
    return player
end

function init_tail()
    if not player then
        return
    end
    local tail = init_spr("tail", 224, player.pos_x - 8, player.pos_y, 1, 1, false, 0, 0)
    tail.update = function()
        tail.flip_x = player.flip_x
        tail.pos_x = player.pos_x + (tail.flip_x and 8 or -8)
        tail.pos_y = player.pos_y
    end
    init_animation(tail, 137, 139, 10, "nomal", true)
    init_animation(tail, 211, 214, 10, "run", true)
    init_animation(tail, 195, 198, 10, "jump", true)
    return tail
end
