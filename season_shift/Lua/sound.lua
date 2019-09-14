-->sound
sound_table = {}

function init_sound(num, timer)
  local sound_player = {}
  sound_player.timer = -1
  sound_player.play = function()
    if sound_player.timer < 0 then
      sfx(num, 3)
      sound_player.timer = timer
    end
  end
  sound_player.update = function()
    if sound_player.timer >= 0 then
      sound_player.timer -= 1
    end
  end

  add(sound_table, sound_player)
  return sound_player
end

function sound_update()
  for v in all(sound_table) do
    v.update()
  end
end
