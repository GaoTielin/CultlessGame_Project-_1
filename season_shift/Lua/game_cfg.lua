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
      '40,88'
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
      },
      catepillers = {
        '336,64,8,0.5,1,1,1',
        '320,56,8,0.5,0,1,1',
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
        '464,64,24,0.5',
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
