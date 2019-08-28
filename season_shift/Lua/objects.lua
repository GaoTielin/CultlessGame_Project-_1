-- objects
function init_chest ()
    local c = init_spr("chest", 4, 10, 50, 1, 1, false, 0, 0)
    c.pinecone = 0
    c.draw = function ()
        print(c.pinecone..'/'..10, c.pos_x-4, c.pos_y-4)
    end
    return c
end

function init_enemy ()
    local e = init_spr("enemy", 221, 60, 40, 1, 1, false, 0, 0)
    e.draw = function ()
        spr(enemy.sp, enemy.pos_x, enemy.pos_y)
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
    local player = init_spr("player", 192, 50, 30, 2, 2, true)
	player.state = "nomal"
    player.flip_x = false
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
    init_animation(player, 192, 200, 10, "run", true)
    init_animation(player, 224, 236, 10, "jump", true)
    return player
end

function init_tail()
    if not player then
        return
    end
    local tail = init_spr("tail", )
end
