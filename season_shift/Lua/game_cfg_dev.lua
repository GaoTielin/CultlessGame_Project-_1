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
    player_start_pos = '0,7',
    camera_pos = '0,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '40,88'
    },
    box = {},
    ice = {},
  },
  level2 = {
    player_start_pos = '0,7',
    camera_pos = '16,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '208,48'
    },
    box = {},
    ice = {},
  },
  level3 = {
    player_start_pos = '0,7',
    camera_pos = '32,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '288,64',
      '352,48',
    },
    box = {},
    ice = {},
  },
  level4 = {
    player_start_pos = '0,7',
    camera_pos = '48,0',
    enemy_bees = {
        '432,64,24,0.5,0'
    },
    enemy_catepillers = {
        '432,72,24,0.5,1'
    },
    songzi = {
      '432,72',
    },
    box = {},
    ice = {},
  },
  level5 = {
    change_map = {
        '23,11,2',
        '24,11,2',
        '42,7,16',
        '42,8,16',
        '42,9,16',
        '42,10,16',
        '63,9,16',
        '63,10,16',
        '63,11,16',
    },
    player_start_pos = '0,7',
    camera_pos = '0,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {},
    box = {},
    ice = {},
  },
  level6 = {
    player_start_pos = '0,5',
    camera_pos = '16,0',
    enemy_bees = {},
    enemy_catepillers = {
        '216,48,8,0.5'
    },
    songzi = {},
    box = {},
    ice = {},
  },
  level7 = {
    player_start_pos = '0,5',
    camera_pos = '32,0',
    enemy_bees = {
        '280,64,16,0.5',
        '336,48,16,0.5',
    },
    enemy_catepillers = {
        '336,64,8,0.5,1,1,1',
    },
    songzi = {},
    box = {},
    ice = {},
  },
  level8 = {
    player_start_pos = '0,5',
    camera_pos = '48,0',
    enemy_bees = {
        '464,64,24,0.6'
    },
    enemy_catepillers = {
        '432,72,24,0.5,0',
        '432,72,24,0.5,1',
    },
    songzi = {},
    box = {},
    ice = {},
  },
  level9 = {
    player_start_pos = '0,5',
    camera_pos = '64,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {},
    box = {},
    ice = {},
  },

}

cfg_levels_winter = {
    level1 = { -- 第几关
    player_start_pos = '0,7', --角色重生位置（在本关第几格）
    camera_pos = '0,0', --相机位置（相对于整个地图）
    enemy_bees = {}, --蜜蜂配置
    enemy_catepillers = {}, -- 爬虫配置
    songzi = { --松子配置
      '40,88'
    },
    box = {}, -- 石头配置
    ice = {}, -- 冰块配置
  },
  level2 = {
    player_start_pos = '0,7',
    camera_pos = '16,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '224,80'
    },
    box = {},
    ice = {},
  },
  level3 = {
    player_start_pos = '0,7',
    camera_pos = '32,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '336,48',
    },
    box = {},
    ice = {'264,64','352,80','344,48'},
  },
  level4 = {
    player_start_pos = '0,7',
    camera_pos = '48,0',
    enemy_bees = {},
    enemy_catepillers = {},
    songzi = {
      '496,80',
    },
    box = {'416,40',},
    ice = {'416,64',},
  },
}
