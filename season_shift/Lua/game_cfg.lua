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
      bees = {
        -- {6*8, 10*8, 16, 0.5},
        -- {3*8, 11*8, 16, 0.5},
      },
      catepillers = {
        -- {10*8, 10*8, 16, 0.5},
        -- {5*8, 10*8, 16, 0.5},
      },
    },
    songzi = {
      -- {13*8, 8*8},
      -- {3*8, 11*8},
      -- {6*8, 11*8},
      {5*8,11*8}
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
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        --{25*8, 9*8, 8, 0.5, true,true, 'y'},
      },
    },
    songzi = {
      -- {13*8, 8*8},
      {26*8, 6*8}
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
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {

      },

    },
    songzi = {
      {36*8,8*8},
      {44*8,6*8},
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
      caterpillar ={},
      bees = {
        {54*8, 8*8, 24, 0.5, false},
      },
      catepillers = {
        {54*8, 9*8, 24, 0.5,true}
      },
    },
    songzi = {
      {54*8, 9*8},
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
      caterpillar ={},
      bees = {
        -- {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        -- {52*8, 9*8, 8, 0.5}
      },
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
      caterpillar ={},
      bees = {
        -- {26*8, 6*8, 16, 0.5},
      },
      catepillers = {
        {27*8, 6*8, 8, 0.5}
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
      caterpillar ={},
      bees = {
        {35*8, 8*8, 16, 0.5},
      },
      catepillers = {
        {42*8, 8*8, 8, 0.5,true,true,'y'},
        {40*8, 7*8, 8, 0.5,false,true,'y'},
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
      caterpillar ={},
      bees = {
        {58*8, 8*8, 24, 0.5},
      },
      catepillers = {
        {54*8, 9*8, 24, 0.5,false},
        {54*8, 9*8, 24, 0.5,true},
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
      caterpillar ={},
      bees = {
        {54*8, 7*8, 24, 0.5},
      },
      catepillers = {
        {56*8, 9*8, 8, 0.5}
      },
    },
    songzi = {
    },
  },
}
