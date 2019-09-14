cg = {
  first_map = 0,
  last_map = 0,
  timer = 0,
  over_func = function()
  end,
}

play_cg_update = function()

play_cg_draw = function()
  cg.timer += 1
  local x = cg.first_map + flr(cg.timer/10)*16
  map(x, 0)

  if x >= cg.last_map then
    cg.over_func()
    game_state_flag = "play"
end
