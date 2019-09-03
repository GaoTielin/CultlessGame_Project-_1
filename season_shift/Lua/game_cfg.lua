<<<<<<< HEAD
-->game_cfg

cfg_player_acceleration_fast = 0.3 -- �➡️步�⌂��█�度
cfg_player_acceleration_low = 0.6 -- �➡️步�♥◆�█�度
cfg_jump_speed = 3 -- 跳�⬇️�█�度
cfg_climb_speed = 1.6 -- �☉��▥�█�度
cfg_gravity = 0.3 -- �♥♪�⌂�(�…➡️�⬅️�░�⌂��█�度)
cfg_player_max_v = 1.8 -- �█大�█�度
cfg_mogu_jump = 4 -- �♥♥�▤➡️�◆♥跳�⬇️�█�度
cfg_camera_move_speed = { -- �☉♥�♪�地图�❎��ˇ�头移�⌂��█�度
  x = 5,
  y = 5,
}

cfg_levels_autumn = {
  level1 = 'camera_pos0,0songzi140,88player_start_pos0,7enemy_catepillersenemy_bees',
  level2 = 'camera_pos16,0player_start_pos0,7enemy_beesenemy_catepillerssongzi1208,48',
  level3 = 'player_start_pos0,7enemy_beescamera_pos32,0enemy_catepillerssongzi1288,642352,48',
  level4 = 'camera_pos48,0enemy_catepillers1432,72,24,0.5,1songzi1432,72player_start_pos0,7enemy_bees1432,64,24,0.5,0',
  level5 = 'enemy_beessongzienemy_catepillerschange_map123,11,2224,11,2342,7,16442,8,16542,9,16642,10,16763,9,16863,10,16963,11,16camera_pos0,0player_start_pos0,7',
  level6 = 'camera_pos16,0songziplayer_start_pos0,5enemy_catepillers1216,48,8,0.5enemy_bees',
  level7 = 'enemy_bees1280,64,16,0.5camera_pos32,0player_start_pos0,5enemy_catepillers1336,64,8,0.5,1,1,12320,56,8,0.5,0,1,1songzi',
  level8 = 'player_start_pos0,5camera_pos48,0songzienemy_bees1464,64,24,0.5enemy_catepillers1432,72,24,0.5,02432,72,24,0.5,1',
  level9 = 'player_start_pos0,5songzicamera_pos64enemy_catepillersenemy_bees'
}
=======
-->game_cfg

cfg_player_acceleration_fast = 0.3 -- �➡️步�⌂��█�度
cfg_player_acceleration_low = 0.6 -- �➡️步�♥◆�█�度
cfg_jump_speed = 3 -- 跳�⬇️�█�度
cfg_climb_speed = 1.6 -- �☉��▥�█�度
cfg_gravity = 0.3 -- �♥♪�⌂�(�…➡️�⬅️�░�⌂��█�度)
cfg_player_max_v = 1.8 -- �█大�█�度
cfg_mogu_jump = 4 -- �♥♥�▤➡️�◆♥跳�⬇️�█�度
cfg_camera_move_speed = { -- �☉♥�♪�地图�❎��ˇ�头移�⌂��█�度
  x = 5,
  y = 5,
}

cfg_levels_autumn = {
  level1 = {

    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 0,
    },
    enemys = {
        -- �ˇ😐人�✽♪置�😐�◆🐱�ˇ��☉●�☉�为x�…�♥�😐y�…�♥�😐移�⌂��█远距离, �█�度, �▤��…��◆♪�…➡️, �▥��…�♪ˇ�⬅️��웃�█个�◆🐱�ˇ�表示�▤�水平�☉��▤�▤��∧直�☉�
    },
    songzi = {
      '104,64'
    },
  },
  level2 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃ps:相对�🅾️�➡️░�⬇️◆机
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 16,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
    },
    songzi = {
      '208,48'
    },
  },
  level3 = {

    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 32,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置

    },
    songzi = {
      '288,64',
      '352,48',
    },
  },
  level4 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 48,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
      bees = {
        '432,64,24,0.5,0'
      },
      catepillers = {
        '432,72,24,0.5,1'
      },
    },
    songzi = {
      '432,72',
    },
  },
  level5 = {
    change_map = {
      {x = 23, y = 11, sp = 2},
      {x = 24, y = 11, sp = 2},
      {x = 42, y = 7, sp = 16},
      {x = 42, y = 8, sp = 16},
      {x = 42, y = 9, sp = 16},
      {x = 42, y = 10, sp = 16},
      {x = 63, y = 9, sp = 16},
      {x = 63, y = 10, sp = 16},
      {x = 63, y = 11, sp = 16},
    },
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 7,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
    },
    songzi = {
      -- {54*8, 9*8},
    },
  },
  level6 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃ps:相对�🅾️�➡️░�⬇️◆机
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 16,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        '216,48,8,0.5'
      },
    },
    songzi = {
    },
  },
  level7 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 32,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
      bees = {
        '280,64,16,0.5',
        '336,48,16,0.5',
      },
      catepillers = {
        '336,64,8,0.5,1,1,1',
      },
    },
    songzi = {
    },
  },
  level8 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 48,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
      bees = {
        '464,64,24,0.6',
      },
      catepillers = {
        '432,72,24,0.5,0',
        '432,72,24,0.5,1',
      },
    },
    songzi = {
    },
  },
  level9 = {
    player_start_pos = { -- �★�웃�起�⬅️在�✽��♪�中�░�♪置 �♪ˇ�♪�☉格�웃
      x = 0,
      y = 5,
    },
    camera_pos = { -- 相机�♪置 �♪ˇ�♪�☉格�웃
      x = 64,
      y = 0,
    },
    enemys = { -- �ˇ😐人�✽♪置
    },
    songzi = {
    },
  },
}
>>>>>>> 2385bd6f85350ec472082d8b4b273ae8f610d08a
